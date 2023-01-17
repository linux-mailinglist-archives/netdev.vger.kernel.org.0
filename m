Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA3C66E05B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbjAQOXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbjAQOWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:22:31 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57573FF03;
        Tue, 17 Jan 2023 06:21:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePirdxuVc9ah3EJ+d04a+va8MLpMoJNmco4fluTz4VF/MslH6dmD4kzSlIjFxT8QCJ49VH1pmpWWUyJDvbZfkRAwfUOtjE5/T3ls/gbFQRzuGS9aVYyDDnkeL0qtn+grhMgDVxNGb88n+JgWU1VQ4Jr8D+TXuTd36wnujGV5ZPViiiUbvaofivl/YQewjekvmP2dLXbGi+WBhLeKCqa/4DNtICyQZRQLnO4QylkXZs3Sg/yid6iX7iQUtal5bxiiyOzyp5wDmlWMaK2BPQIuMzfeUFDdfL7KPYAwWneE3YxQy5Dx54YHLaR1InjIs6+dXrr/9eb5ECKfS79jHqlq2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GzcxGyxBcI6XwuuXf+1G5uFCGWKr0Dmzf11HvWa/5/w=;
 b=KiEQonOtG5N3su9driETicCTPt/3zn5uyymIqtSTrTM5AUqljUOV/arGVFgHFwdlFXBjgqTQVsMlszVd9GHbscRsDB9jWPHFWCLGJ0PLwfSJrJbDBRpczPZhD0TOu4wjJ43XR3QxlxfkDUBdA5vZcyybApz3a8GLUPIk4NQsBvwymnBHQ+h8JO4m1TdtucQCGcAkK4E87on1AjJax59IYYTJH6GZp6Dy0Ia7KZsQMg/WHcLJNlhPsHVQfR7s8ahabqceqByI0o0GTSYbZcx+T9IWf5uQgjp639XqvQfjTkikSRmfOkE47AsI8GEvekoksDvrQuGE1UkiA9Hiaz235w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzcxGyxBcI6XwuuXf+1G5uFCGWKr0Dmzf11HvWa/5/w=;
 b=Ot/jAa486fwo2cswCAnTYcegqnn3BlsBvdm7INiyez/RvCT7U2Akyvfq06F/BbaKSmzQjtKT0S9n4JKh95mvT5rpppwlYPoE0JZiJ+4ogX8V56KATOpMQzxUnieje/8q8NiGYwmqWzZ4NJ4vBLJkrPv2irziqQFG/JWBrUbrkU74vHusQv73tX5GFUi27v5HJX0kChgzZY+1S1jTBfa9bbWENY3RHZe/Oq5eCjLWR/8jPuwJSHiZfWtiA5VE3DuLR+QWCbPRDOMxmmjkV7MJP9oQP+IcvLxWeVxdUGkywcLigXABPwEABo5LItdS2xzRqz23CSG+msCMf0YMycJasw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 14:21:19 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 14:21:19 +0000
Date:   Tue, 17 Jan 2023 10:21:18 -0400
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
Message-ID: <Y8au3ni8NVBPI5hu@nvidia.com>
References: <cover.1673873422.git.leon@kernel.org>
 <6e46859a58645d9f16a63ff76592487aabc9971d.1673873422.git.leon@kernel.org>
 <Y8WL2gQqqeZdMvr6@nvidia.com>
 <Y8aOe68Q49lvsjv8@unreal>
 <Y8anaBBZDOGF471q@nvidia.com>
 <Y8atPjQ1x75tBdib@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8atPjQ1x75tBdib@unreal>
X-ClientProxiedBy: BLAPR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:36e::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5174:EE_
X-MS-Office365-Filtering-Correlation-Id: e46fd2e1-021f-499b-dc62-08daf8961a32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s6nq8BNayMMZWn3OC3qTDHxxJnwiWbBy11YrT7kmHnWVA6kZMMLMBn6hFvoTcTt6VtGBIhtyjFlksGPVVKAZd11g7iKDe9A03C72MMQ0R1P71FJiSmvOqAVKMkJ4SMJfm1MljM8smPHYKOKsa/LJE3TxvINzRJgsqjLiaU7mR+uIYRdsQfzqDxPQlW/zB+yGu6Y74uuiouW5FF8N7QOTeRprvQZA8oCmo3QqP7idvjvte3ult9RdWlbriwyNiowC6mDJ2F8GHhyVPskbeeixpKPpvLtZ0kgXVUKXtn96PncZbRJ51GyaKwAtf2zBql3m60Db2VvLeodL2VDT31QZ/5H2p4CcPff6Du51mx56MN865Lz4ZK1ypws6FqjeR+/9n14z5kErHxQFOj/zA4oBuEJT4y+QiJmZGphhhV5zXMCFpypSvtqct2jqaqJ5EFmMSQoEdyBlJ9WdbrOjUlsQTf1VuTnwuQABJBku+0f+mv8umd4TcsbSBOsSYhrzWsrtlO6Ao57gqSlXt+5SF+POw1hae1WKHZ9YQSDSjR12giRa9cVzTM0CT/hjvN4r4lCkhdIozFNJeEYu9Nv6i0gJxLc27qal0hlPk1TxiUYb9QG2tMnfR4kXuYypR2iMiDKSygd0LD/+WAUF+tg6SvFwMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(451199015)(2616005)(66476007)(41300700001)(186003)(66946007)(6916009)(8676002)(6512007)(66556008)(4326008)(26005)(36756003)(86362001)(5660300002)(8936002)(107886003)(54906003)(478600001)(316002)(6506007)(7416002)(2906002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ktFCzKxzvxP2CrSGrmcl+tknN27b4DjZwVFRqzZJZH1/PyjfqGzqc17wSipd?=
 =?us-ascii?Q?rbQSxZmbrYeL480aKT+ffHuKSB3z0h2QbZhysFS1xh3Ieh5SUlKTKkLdbAlb?=
 =?us-ascii?Q?K3YdCWOBCoEcuXRLL9KLGb2SxH37WraZKobygxzqGML4uN2FFkPu4PolyMp9?=
 =?us-ascii?Q?KR/GwV6fxk6qwT/eTC7+qq4DWoHmxwVf5tyftgkz7OqfFD2uZIWnLmRyO3HH?=
 =?us-ascii?Q?Hpr2M3QyJESk/342RODMs89YVcOhelQN8YjQYQuCQsNX/lEf5SXOyQgrVqd1?=
 =?us-ascii?Q?IlHR4bSrJUooPzGx4Ybjd0fpPZW6jhFU+FJBW/NHleRq4l6tXzscT9Nd5ygk?=
 =?us-ascii?Q?HnwmRPpZbT3KLpP8EqleOIMLU4JGnCFaDY7HHjmQQTNxX/h1IyjZkiA9wntV?=
 =?us-ascii?Q?ExSISQ5QocSq4Jj0s4t/ClTJkycsEkXDa/i0GBvQkLtxjKs+aF9eYuIcXipw?=
 =?us-ascii?Q?HX45Hxa8w06O4ix1zaG7bedptTjhrRo74b1bT6PMtOaTJwcyJie8ovrVXUKu?=
 =?us-ascii?Q?gXTzZAx29pCmvlHUVQkg33h/m+LRcvgy3wSk2maaJy/bITXMlOExZXgGNOPI?=
 =?us-ascii?Q?g4IGAC6dp5hr9VILUpMudGuUvDEOp5e5pZSvUjZBgR0w03p6C9rFau5IyECM?=
 =?us-ascii?Q?eKQw9UcdaJwGKhi4HL++PNUeehJ4Cy3dPALm4Lea6FX9NY3XDrkZ6Rf8188C?=
 =?us-ascii?Q?TcpJSUToARDU5faLP9si0W3O1cia1bhaDLAjpaXcp6xk/qNJveAjTZ7avM5K?=
 =?us-ascii?Q?7ZpcB5c3npmAcs/ABlnlANzal3IS/Cqb5eJmnnd1mQSmMIg+SxgrePWstFxA?=
 =?us-ascii?Q?sSROGvOW9Hn6niIRotY0P8EsM2VSka9JISJfvMl/QbvYXq2XwIbZeZWOydGJ?=
 =?us-ascii?Q?1xmiVWcU0emfueupi2QNqe/ZRqB/g1omtmkIE3OdQu0hy+rEZCQIpcK1qX2N?=
 =?us-ascii?Q?FMBJNZ0d1xNEbg0WZ4ANF40mi2PZhvpgfXFq4WfnEg9AyV6aYSiGMKhJS6ZE?=
 =?us-ascii?Q?sjM3tZWrYwZF6ZzdeFKmw6qsBMNOJsMaH/4ThwZIWh/Oln+3NwOC0pm53Png?=
 =?us-ascii?Q?DAuy9x4VwWyRKhwv3ohXstx2iiR//WSmv5+B5m9mtoSBCn8yzu0UAFBQJs+e?=
 =?us-ascii?Q?VN0dmn5OUY69xlTte9V9ohGPkB77XwQ+dvH7ah+s8YZKrBJq5NLDzgmgTwqe?=
 =?us-ascii?Q?6gqX/AYIqXvI5Pbjx586/MG+Iv9XJktVPdbZ14zcWiX05J41y5K9aOCwhOMK?=
 =?us-ascii?Q?vP40N9NAPfFSiYcMCo2e36mKQLNyWXWLTC9reR0zWmJs8LaJehE8yhIJ9MBU?=
 =?us-ascii?Q?Dh+x8RLM6WV2CM8RTc6fPTePRDKbYvqhZSP3WrvZuoOCjsWKdXt6Y7tnpYDW?=
 =?us-ascii?Q?KXexJBlJtDz24Nji2USX2kbPKJ3njxzjAkpUFDQ6ZtgA5neETiyWwd4+FRXx?=
 =?us-ascii?Q?ef9CDDEX47PKUqoExl88XzCSTyNiUe20tvoxB5JVXO9Rq0XTf0soF78oA91l?=
 =?us-ascii?Q?w+HZV0AyL37y5NOrCA8wmb1kwDMAc9lR84Zt2HwRbSfpi0pBiHuvgW8PytmO?=
 =?us-ascii?Q?VZVT37FhPIMG1XtYSAYXDrMi+LFWJZ+da66fVZI5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e46fd2e1-021f-499b-dc62-08daf8961a32
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 14:21:19.6557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vh9Woi2sy1rcOcg2Pi5ukvYefztPS5pzWl05OedFEYdMflPfo0KtnrEkaxzcwba2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5174
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 04:14:22PM +0200, Leon Romanovsky wrote:
> On Tue, Jan 17, 2023 at 09:49:28AM -0400, Jason Gunthorpe wrote:
> > On Tue, Jan 17, 2023 at 02:03:07PM +0200, Leon Romanovsky wrote:
> > > On Mon, Jan 16, 2023 at 01:39:38PM -0400, Jason Gunthorpe wrote:
> > > > On Mon, Jan 16, 2023 at 03:05:50PM +0200, Leon Romanovsky wrote:
> > > > 
> > > > > diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > > > > index 17fee1e73a45..c553bf0eb257 100644
> > > > > --- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > > > > +++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > > > > @@ -184,7 +184,7 @@ enum mlx4_ib_qp_flags {
> > > > >  	/* Mellanox specific flags start from IB_QP_CREATE_RESERVED_START */
> > > > >  	MLX4_IB_ROCE_V2_GSI_QP = MLX4_IB_QP_CREATE_ROCE_V2_GSI,
> > > > >  	MLX4_IB_SRIOV_TUNNEL_QP = 1 << 30,
> > > > > -	MLX4_IB_SRIOV_SQP = 1 << 31,
> > > > > +	MLX4_IB_SRIOV_SQP = 1ULL << 31,
> > > > >  };
> > > > 
> > > > These should be moved to a uapi if we are saying they are userspace
> > > > available
> > > > 
> > > > But I'm not sure they are?
> > > 
> > > I don't think so.
> > 
> > Then they should be > 32 bits right?
> 
> Right now, they are in reserved range:
>         /* reserve bits 26-31 for low level drivers' internal use */
>         IB_QP_CREATE_RESERVED_START             = 1 << 26,
>         IB_QP_CREATE_RESERVED_END               = 1ULL << 31,
> 
> If we move them to kernel part, we will need to define reserved range
> there too. So we just "burn" extra bits just for mlx4, also I don't see
> any reason to promote mlx4 bits to be general ones.

Is the reserved range kernel only? It would be nice to clarify that
detail

If yes we should move it so that userspace cannot set it. Do we have a
bug here already?

Jason
