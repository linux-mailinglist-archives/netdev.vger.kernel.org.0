Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FAC6C30F2
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjCULyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjCULyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:54:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6525D4BE8A;
        Tue, 21 Mar 2023 04:53:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JviNRaAIaI/Yw770qu8UwRCXQhMGT/ZWrzsjZ3J16NgCcaDd/Tm0yV0JZZ6Eh0xcdm3QAsj2HVrgfm8+avfR6EI7L9r1ueMSeJFkfC05H/Pn7tfSsxYmVzi/NcGe0ztvRZW50k9GShPwmTHulBCFZgcTv6CRR6rqgmBK3H5p4Yl6hgXJKQ7pbxisa+/Kw9PaoJm+kwEs4Y2n3C7fNqkaX6oC1IMMwdihqREPgItLZxBTT1ACXqMcUJa34tDVVJmhJoyuznR5a14/L5xv/jV1mQ6VWYnmbqs+qg8BPw1EyM4bfQwVsElK/nEqw1on68pWlBpltMUhhEUtiTvz+cDukA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=exfYwQANsutbSTClZ23Jh5tLOlp0tQ7XOJqGYdAASSk=;
 b=JStQJPqjBTjTTayojnlYoU4KbBC01f6y+neLwDyqOXxB1TEzDZfxN3A1n2x6Zu1OzkcdDE0+tj9D3wmSTHGMZZoiLdPHLKY7ORz1kEdgdp37UVwpeFm+a6n2SqJt1WUGyhkId0kBi0Qf6sPucnZVj8FMZIfA/xtKN/9BQljGW0qOJrjrl2VcoGZoEAvZmAe/3s1cB/IdE5lJ5m2VSaSAKXhE8Y53NAP4n6JEEfeQHdEZDKA5VKl1EfyApCLALjIkFU9NZd2f0YwjM5iQSMrWzsdqbKKUKWaJOybC53lnHxL3gRpxjnOrSjKCD+jnPJrlXVp7EGHAdnjVagmVR3cpmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exfYwQANsutbSTClZ23Jh5tLOlp0tQ7XOJqGYdAASSk=;
 b=tiJ94tzGA04r6FAGA3PS7+qUpwUB6Pm4Udypvq7CwZC3Xuz1sJNhHGMPZ8tcAFYIaa9w4VV09MbvjsDjbYlTn3jDFAo09//QEGCKXMTAQEuxdQ2T77hJKGZpEXhpbAWolxNTY1AfbM1TaVukRUOai/gOr/bR8cwr11KIIQ+yKh7aLetJeP9um8EBOlPlMn1ipnk8GErqljxv8Od27TnB4zg2ojq/k1hOzzWmpb8siviINgJn/11rAT18DyuI482yObTkEdwgxNp/xyAPlw7tQj3eE+RhAVZZwdApRKV7wyUtSkIavdxrT5LEtshl0YplY6V8bi/Niu+OmjCOO8YwyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB5669.namprd12.prod.outlook.com (2603:10b6:806:237::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 11:53:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 11:53:37 +0000
Date:   Tue, 21 Mar 2023 08:53:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next v1 2/3] RDMA/mlx5: Handling dct common resource
 destruction upon firmware failure
Message-ID: <ZBmav4CF1yqRvyzZ@nvidia.com>
References: <cover.1678973858.git.leon@kernel.org>
 <1a064e9d1b372a73860faf053b3ac12c3315e2cd.1678973858.git.leon@kernel.org>
 <ZBixdlVsR5dl3J7Y@nvidia.com>
 <20230321075458.GP36557@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321075458.GP36557@unreal>
X-ClientProxiedBy: MN2PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:208:236::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB5669:EE_
X-MS-Office365-Filtering-Correlation-Id: a8d0bfdd-0c17-438d-4493-08db2a02e7de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lU/Vfjc1Cp7yJ6tOCEv+xv0r0JdVBbhLpeJhfF/f0QBd7WRye8Tr+7QuMBSf+96YskSOcUB3w94pXePM77I9Jsvk0AaCm4nf8Hc4U23tmvgDgnYEgvEoM3ZYWwb6C0Bj4/qkvJvQ872uStF9EzQU72PnFkNYsYexlDqSTs+B/GkxL1NRgG5MGO3M1OolAlXJy4BDRJDwGRk/Of71PjcLpRqQpSwoggYjATWsTHrBQte8I36mZSpY3oG5kPPcpRlsUPpbgPhbADndWusgsKlcUuhXnolYH6dO0P03X2pq1zp9PllW2taedW3t2FRp7ZDvli4viZQym9yk81QdD/WepYtbxeh58STNWQJXk+J/MGZwG1LPwIV7+rMioVdsVLI4FOJYY2MKoC1nK+Mg5YiSEYtJK1UKcKId5UVtgYLfVcgkQlVs0bpL1hgYvhvKEaEaV/A3pWtuGAOX9G3ERgit3WguCdu5Z7S6wmnQgsvq4tCCDdxC4E34uvqZNFwd6dVKm8Edu5/tvqowU+gQSdm99zhTEO+bVAuaxoIyzggHJY8zAPPzI1bhSbPE/Kc2f1BZ7y1s06raMit279c0MsbJSetijB3CMh1iJQVd5gvrXuMfdE2gnusOt5MfEQP3RtPArbKgyyvTQGNd454fGq7JAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(6916009)(4326008)(41300700001)(36756003)(66946007)(66476007)(8676002)(66556008)(38100700002)(2906002)(8936002)(86362001)(6512007)(5660300002)(107886003)(6506007)(26005)(2616005)(6486002)(186003)(54906003)(83380400001)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XidRsMAFuj22PwppSaSi1TAt4PVTkiSJwEaXrhpuOxuj04KOrG4yI+FPnNCv?=
 =?us-ascii?Q?0SHW9vy1sQ9QPPD35lohn21FY2+quneggyN2mM+x0W6gCN2DT8Lydw8X6Fte?=
 =?us-ascii?Q?vYHqsyZJ7ficfW1BcjXfUDyyLMnDd4LMc1+cy31OYpqRY2krTDKYoC7UJ7v9?=
 =?us-ascii?Q?++KMGGN0wjKxvQTO2Z2O6V9JTON0d2h7LSxPTKdnKCQ9iEs82zDO/5wtMb2t?=
 =?us-ascii?Q?665KKXcXCzzENc7a7qDCySJY+YBtAB4aT68YUs+j1vPE4Rs9y2NvDlZa831w?=
 =?us-ascii?Q?UAFWWv2vjptrRa/kekJ3XiYyPhCxq/+l/LskFlhj9dbO2WYJ6kKXP/PPbzvd?=
 =?us-ascii?Q?VgmEjjOfZUrwRIDRNKlh//1RvAqMl1bIHbIGHPtWTAhfxyveqyo9+53IOejB?=
 =?us-ascii?Q?DwZkmyPrl6TH3v6tpqWST60dNLG9JodoewqrC+dgbhvVafr9V/kTG+r7brI9?=
 =?us-ascii?Q?33kwMolSFD3yYcPdN3ez1YbLjtpXvtapa9q4Kc4FNgV/VblbdvOv0K4sr3FK?=
 =?us-ascii?Q?gBhQRJk1YvdJ/EtOttcOgrkluVFJYJy5Kq0r57ffuLhgJrh6dT4msT0UtOQ0?=
 =?us-ascii?Q?voQlptJJojyemmAdDoL6uopeRVOpSqC6iytS7/n6jHeB2zfmPAoKpZs39XX7?=
 =?us-ascii?Q?q0FqE2XGKUttod4p3dmh26XQV49qIsHWxrUnwJzfaSGwDU9RLZBMFj9gaJlv?=
 =?us-ascii?Q?KmbhKLS6C4cbVqCBswSweVkefCjeDn98qaqSepCukcMf2BoVLjcqnRk4QbQR?=
 =?us-ascii?Q?W+5O5ZGIWUDzSgwjRmz0WY+B81Kp2jWoh3rJZMSa08WZ+wTjICQDDM7OuCjF?=
 =?us-ascii?Q?osv3a/GFA+YBYAnLqbi5FQuAnHDNeImhLSJ1fTYC5EUkLvIfXgPRfIdwr51O?=
 =?us-ascii?Q?eoGgltGiBc9fq0xgtXagXa6MHrSnwd0AjNq0mDJ5HoMfsPjLcm3g3IRluZE8?=
 =?us-ascii?Q?N4jkjwG0z/Xyl5OF7LhnEXjkJ9ULWpAetT48Q33hxP85TbOr8FqB/XuQnDvj?=
 =?us-ascii?Q?cTseoJYEqMduZGuwSG0RMWcwwvop+O5ZG5/l1cpXIoim9W7uW6nNniN381+6?=
 =?us-ascii?Q?w9vKimPEEwRshlsNByJCQoAlMGaDCFbuCLIXdHBn1Cu+8Z9Spq+cNvYBcUUl?=
 =?us-ascii?Q?0O5JYYLL+1x6uGNFT7MzlEEQKmvcXGhk7YWANaILAxl6atG2+WDAX4huGjQE?=
 =?us-ascii?Q?IOp6euA7Nn94fgaBg/CoI4AEWVfcyjL86BIE+4F3UcUKuQNCKG3KoPHSzR/r?=
 =?us-ascii?Q?kp7P6lFk80EVS8v2wIoeStFYkfCx6cw4tXpaM2pAYPXcLIOEyl5MIRchqXEh?=
 =?us-ascii?Q?mIDAhhQu/HFyjR83YFmenCbWO7STO/7o7IyYDh0HFHHMuuxGTnjVu7iRdMy4?=
 =?us-ascii?Q?+H2Ltj0uAthkNXdqtd4gvFnqKJh5LllwuaCW6iwvmL8B3nW2+Tu/sbt5yslN?=
 =?us-ascii?Q?lt8JhljRVDh7Auwnt7ULAoIFWGAB63yNmhXc+sW0A7BPo5mr/xEKBFUUy2Yl?=
 =?us-ascii?Q?6Ipnvmo2PFrNtFCT3w3x35lWcFELQHA/otF6Aw43LuWMPhCQPOIhJa4+OBbZ?=
 =?us-ascii?Q?PByKGEh5IqdvwobssMmXKAyHI3DHf12Y87WMeT6X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d0bfdd-0c17-438d-4493-08db2a02e7de
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:53:37.2555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PCmvueNa3ErmmEVdENmIzT2nGpLkV/29XwniwWUyWtzYRlTNVg7+CZ4VUe7A6Lw8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5669
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 09:54:58AM +0200, Leon Romanovsky wrote:
> On Mon, Mar 20, 2023 at 04:18:14PM -0300, Jason Gunthorpe wrote:
> > On Thu, Mar 16, 2023 at 03:39:27PM +0200, Leon Romanovsky wrote:
> > > From: Patrisious Haddad <phaddad@nvidia.com>
> > > 
> > > Previously when destroying a DCT, if the firmware function for the
> > > destruction failed, the common resource would have been destroyed
> > > either way, since it was destroyed before the firmware object.
> > > Which leads to kernel warning "refcount_t: underflow" which indicates
> > > possible use-after-free.
> > > Which is triggered when we try to destroy the common resource for the
> > > second time and execute refcount_dec_and_test(&common->refcount).
> > > 
> > > So, currently before destroying the common resource we check its
> > > refcount and continue with the destruction only if it isn't zero.
> > 
> > This seems super sketchy
> > 
> > If the destruction fails why not set the refcount back to 1?
> 
> Because destruction will fail in destroy_rq_tracked() which is after
> destroy_resource_common().
> 
> In first destruction attempt, we delete qp from radix tree and wait for all
> reference to drop. In order do not undo all this logic (setting 1 alone is
> not enough), it is much safer simply skip destroy_resource_common() in reentry
> case.

This is the bug I pointed a long time ago, it is ordered wrong to
remove restrack before destruction is assured

Jason
