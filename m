Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324E366DF4C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjAQNuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjAQNtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:49:49 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C5B3BDAD;
        Tue, 17 Jan 2023 05:49:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8fJB4CBARFXOSWe1+koMrWCvnVz8ZM6lxdtAq8BlxnOsOtE8zIvvMUXRJWfquwNnyvG4zqTU/9D91/kvBrZr1oXp6RJ9V22bExgWD4cQmfG78wjBNV3wVI3bySMXwQuLKUtdXuyEmn9YoKzj0Dd7Hb9UBCAG4oaDspOsbeolHRvaFfefJ2n3GL0mKM2qdfRqOx39aIN0hly5Ch/wHS6OeXZyH0Ayu+SY3rmpIytkTBMGyEkYruQCzdqDwqDC9GEB4hMIFS1SMI6ewpGVynBao3rd7ahp6B6sOMl5SDqmteusAyfPH4Pylj1sD00joTV1RGfCw83R3oU1tJEpAb4tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQmchS+i21MjtfvKSkvJ9eVBqvTCctjr7pttEfd51GI=;
 b=dSrUKNvskYfyH/XebEC9x+3auE24vzUh0HGlYbhGhfZ6t7750EbTiVFjknbiaFgyl3AOqH0oYiSswjTczURiOGjl7sJu5deOMsUsw0uaR050qX7WMTZRsM2VL07IeXlpdGHdy52NSr6s8WjYdhVlGmn0QwVRdIMz51UyUIDAUAqsoRlPNZiUAidXY4R/0Q4CmeVtImrWUD8jnM9Tb2m6t6pIEYCFIJEBAJxJ7Fhh2/2RdpSpF2Dt3VxKeGBHsfB3RmB2xe3GKnJycarMTwJXmmBWJuOBJ7RoFOngKOC+Q9MERvAT+19c8qXA/9a6ShxluypTJa4hS8OQtjYczTgKDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQmchS+i21MjtfvKSkvJ9eVBqvTCctjr7pttEfd51GI=;
 b=PNEqn8o2Nwxgno7ZaIIdb9x3iyCtgKOM7HGTsJ+pcsRE0Lml5I6lW3Jqp5avtNTe/s6fx+zCvyTyGnE5eEFHQlnaFyyIbUoD499QU3z+HLpnF/KEYSp5NAY6DRdwbPFds6l4NpQc4f20yYXDRB1gYJFRIl3vHInCRegZ/rFIJS89GW3AdS9mkn4AlIvAaptYXhuNyZxjoyyBPmEWf33G0Pp4KnkgAMpADM44m0HtsRnIbxpVmlVMkOWQbrkTt/o32efr7LpJkjBo6HTjG6qrdkPgHA+DXuFBjInRAGc+wDCKkcAG1QbaE51H/G9fdoZtMXEKbfq5a6nUMp+ABpJOPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4034.namprd12.prod.outlook.com (2603:10b6:a03:205::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 13:49:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 13:49:30 +0000
Date:   Tue, 17 Jan 2023 09:49:28 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Israel Rukshin <israelr@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 03/13] RDMA: Split kernel-only create QP flags
 from uverbs create QP flags
Message-ID: <Y8anaBBZDOGF471q@nvidia.com>
References: <cover.1673873422.git.leon@kernel.org>
 <6e46859a58645d9f16a63ff76592487aabc9971d.1673873422.git.leon@kernel.org>
 <Y8WL2gQqqeZdMvr6@nvidia.com>
 <Y8aOe68Q49lvsjv8@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8aOe68Q49lvsjv8@unreal>
X-ClientProxiedBy: MN2PR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:208:15e::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4034:EE_
X-MS-Office365-Filtering-Correlation-Id: e0f35378-1365-43a5-b404-08daf891a7de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MhQfuYedYq8u3JAVOe/xcbpJH1paq+xa+TMKE8mKMSfBs+CcjlsYmk6pcg1I2P+zfDHpObwsVcelzhEbzNBZe02xkV5UN6r8uVz1K97Hc2yvisE05TyNZ4SPQy8hnpHi1ciI8wYynZDNDLHNl5EySwhEsQ+bLqKLGe1KNlnl8ceXSAmCuT456kpGuEHvP7zs0M6E2VeGLmfxDDexvRB2rCdPc3nBWF+uajZv7LLmee+rJ1J3GiGyebAa28NspKbQ5E+feq5o/QLueAwwNQPgXwXEWHdSibe2pmVADX1+GEUlQskPVlF8nTloheIwXNtD8Sp8xB/pTJgDJTivqGpqspni5TR0iuU2mmg3TIFbRc+2Hl7tqn6ozK6mqWTP50T1h56ZKZF9d2Q0eNdA+sOgv+2riDpfXF/sd2VJ8NcOOyZ5Hk6Hnu1BNz4UowSzLh6YbxrAl1A1aXCa+7hF2+3uhwBcITaO0dOVUzGfaqGt+nSNg2rCuwynr0Y5BfxK2i8UIM2CU8IjmcoCwPoCWlbC43Lfhm2ZvFTOKA6e5aiad4oB/iQb5rHZF/YoewtjRbeyQvx+J6hGndvLhOGCmOdcEI6jYuR5JRcCEy/0CReR5rGvDR6BPfaGv1zRjR/hQ6lP8Y7bKXI4RgDa4mf2uvteFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199015)(38100700002)(86362001)(7416002)(8936002)(4744005)(4326008)(5660300002)(2906002)(8676002)(6916009)(66946007)(66476007)(66556008)(41300700001)(2616005)(186003)(6506007)(107886003)(26005)(6512007)(316002)(54906003)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dUK4Bu/PY52F9WB5T0mxDbblSL3zcucKqQD/o1XR4hdvBFkTdi5vhTBObq/Z?=
 =?us-ascii?Q?Lx2oP0fwNvOr+55yyOz0oirJbhS/ehF1cDUDKuduEzmCfUw4gT2dKoQ5EqwU?=
 =?us-ascii?Q?vQPfw9oW/Ii5QDlRdIFqigV+vDMpN4YN+F3GydOhyquU4tCKaouynBQ2b+o4?=
 =?us-ascii?Q?VPXDrPECzA/Mo1Ucwx5/jU7uyGqyN+CeTiP4Hjv3l4k6RwvaZZ2W+rGaSmnr?=
 =?us-ascii?Q?KHuLs6lhbElTRSdGTPp+xwqym6ntZHzwInqC37f4nYlNhg6rj3ZOtNlMm1Da?=
 =?us-ascii?Q?t52MoXjJIUQkqgdtC+IKTHeDlN5GntfK7hogN36PEpqS8T3Lm5N9KfBUmvCR?=
 =?us-ascii?Q?mj98TRr1EKKKocm879momuQETr4TQ5DwqMueetrC2/QFX8owTZFi5znnKS1N?=
 =?us-ascii?Q?s0xxJNWbKpjZdaiOLF5lQvL48ITb0bNemRO7BMMLeR8WtK4LHGwiSM2IbjVh?=
 =?us-ascii?Q?h3ww+h5C+zGC7X+Eg6Jg/6aI4rwIuVSJ7ZSdl8ry975MfhsDRA4noAiD/dsA?=
 =?us-ascii?Q?9+puLwHmChCp61zaBsjbH7lVqwTIQTeQ6/MTl72OH5K0+WIa/XHXKDtXGf6Z?=
 =?us-ascii?Q?9AolGusYNRlyGNR2rAXXPEaCOwcBpG/CVqtGlCfh3l4dhrFkOHhDoOy+hrWU?=
 =?us-ascii?Q?ZhxZtt5a4BW+fIlIt8eYQ7sg58krb3oQBgiI+NKDIG262H81l/wSLjTepKen?=
 =?us-ascii?Q?VFZCQgbdKi8laJnUsvKc38axaRIOUJf7er58UKhZxEMGHhaPVwWRQc3FYZij?=
 =?us-ascii?Q?qM1km6ppZ+EqlrPsy3HtyPVdIUKU4zkQfqxCnb+zOwdgKmheknBu2LwBnmqo?=
 =?us-ascii?Q?20Zeux89PKfPwOs1FuoyJvQdSkvJAenOIYHufws9Hpjy0iLv3y54o52f2su1?=
 =?us-ascii?Q?5BTjhvJ5MIeD1iDjbPJSTCFuS7X0awDWFRu0mawLCVggnWiGDkfVOxstsJvj?=
 =?us-ascii?Q?j858eyaq7tRo/kqjG9jC4dchUccqrNlATCvY5n6jjXo+fn7yzlQZZ3+rIPYX?=
 =?us-ascii?Q?iAhzg/gtN6/kWxwEBqdNkOuromirLNWWjEwPjhykvsR5g0a8/iV6llXI8K1t?=
 =?us-ascii?Q?K9ma4/eXItZ+6TyNgGNQCa3NAV7B9syrY8OxvA4URTBHpCJzjz8VK1uPlvbs?=
 =?us-ascii?Q?cReulMLuhteSrGowpOpaflR2F1vkJUWuHYwt3wQ2Vuf1T9UaspfEiFJ5BN7/?=
 =?us-ascii?Q?ZJafdQnNQgAFRUDHwRhaQLXVkLH8Dh/c3synp/o2e1GsFu6YaVNgspUH6uy5?=
 =?us-ascii?Q?F9dsUmDh1L9z2CeCFkwjlpSBNEZNS9RsCO9SUa83AvLSkhFb+rHz/YAOfRuN?=
 =?us-ascii?Q?1zgNwDlXYyPOYcZMtlbwGM+uKddWbsHtee4a5gV35m6N/Z9wPHx9HAMaVihs?=
 =?us-ascii?Q?PjM+Wsfk849jozGSjJhUpHle+lrGrsCSmzXNTgAI0m5oYOQqZbJocthNycvX?=
 =?us-ascii?Q?8Vn9vWSIw4UvazO7qd/gME6kUFXUcAVgRqm+sbmelU30DeBWsTezCM4rimyi?=
 =?us-ascii?Q?xjL61E8yjc9NUhNDoRibbFgaW+maHI2wn0NvRjk/HQEKteIh0KtsQEg6pz1p?=
 =?us-ascii?Q?Jrj+7Kg3/87i7I2sTe1X5SKeohm+uthjCdC46or0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f35378-1365-43a5-b404-08daf891a7de
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 13:49:29.8713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UtQWck1Yc0WcJxT9OqncArAw4c4CHWTlqacY5zMEiuDV1TBknzwPffGbjPZjGUZi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4034
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 02:03:07PM +0200, Leon Romanovsky wrote:
> On Mon, Jan 16, 2023 at 01:39:38PM -0400, Jason Gunthorpe wrote:
> > On Mon, Jan 16, 2023 at 03:05:50PM +0200, Leon Romanovsky wrote:
> > 
> > > diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > > index 17fee1e73a45..c553bf0eb257 100644
> > > --- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > > +++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > > @@ -184,7 +184,7 @@ enum mlx4_ib_qp_flags {
> > >  	/* Mellanox specific flags start from IB_QP_CREATE_RESERVED_START */
> > >  	MLX4_IB_ROCE_V2_GSI_QP = MLX4_IB_QP_CREATE_ROCE_V2_GSI,
> > >  	MLX4_IB_SRIOV_TUNNEL_QP = 1 << 30,
> > > -	MLX4_IB_SRIOV_SQP = 1 << 31,
> > > +	MLX4_IB_SRIOV_SQP = 1ULL << 31,
> > >  };
> > 
> > These should be moved to a uapi if we are saying they are userspace
> > available
> > 
> > But I'm not sure they are?
> 
> I don't think so.

Then they should be > 32 bits right?

Jason
