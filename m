Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EAF648F1B
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 15:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiLJOCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 09:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiLJOB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 09:01:58 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9AE1F9DE
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 05:59:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4U3Lonk5GN0Ik6H5e8PDR63Om9xMPqBsO4bKKORs0qVF2BirV76g9cAsiAE8wbU0RWjZB4KkqKYqLgh6KevNCLUQIErKG/eG1dCV+MzY8Eql/94ub9xCfZLUDCBHgAy1iNpYZPWJ4LYuqXNVNzdbjLDT3b/oIKxHDfPGosIG/v/S8NXAE/4rJZ/iVw9cA/oTfnYk9k8T8o3OEbpEvXimIS9jdKyJEdvyT0NsDeVfdJeXEE2AUiTpENXxQ2M/IkAUsXKwvBGeNENpbocBMsIOx6/XiyU45KlyAIwBjuAUQoUkcGE6lKQYC7xp5iuo7sp2TnCFIKJ0gElqqlaAkM5jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2toN10eNhv4HMWKFSZK+9VKl4CVOBThXiT0ZKUDwpuE=;
 b=AyeVbnANT09eJxRLjbazc43iRfsyMgKujD/DKzqRo/zkwViRQdX/bOm0h6QN2wfHonqZMnWKkSioNgi3qp4x8jZepq+fYU5PujhCiGkAVxug1PYQtHtiE8sz3MX1D7Xn890j8HLO02BhgMSlWkR7rGIFTwg2Mt4MSeY6aeb9fjt5x1tJtgrj1P+h3Lz2czEW1YH4lUJjQegt9B0rygzsl4hhWxXsQ920upCDcuqbHvfWzdYwCUmR9bpeY/4j/W3Ldm3ZeCXixIO+DOS0h47UXnIx5E17rZIz9IzMTX5Z/n+Fyjv+uOy0RI8EsaDtvhaBnSi1ELrz6YeVTuzs1gEi9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2toN10eNhv4HMWKFSZK+9VKl4CVOBThXiT0ZKUDwpuE=;
 b=OL+RNn+JPRMvesKemlCHHqCrTnCg18zSVl6ocuu4sV/k+xaqDUXWaBKaTpnd7qTqAm/jEzYhmmnm8UGsmNhkRgGII7SbRBJ80qGK6Dj9ODr1lfB5mtuA+PKaKS528s7Nlssrwxu01q1/FvsUMZ2utVja7nnBnl5fxFhsvG+tQEgt3Rps1hkqmr5ZUPk8NQ/A8MnZ9bgH+7qOivlvX46OX69AuIV6/MJAZskOOJ7Nj5sn3ftQItlUoF5CZESUjgyWA+zNQ4LaxUc3MA/WOTnK4r+gTcCqCQcWbeKhqayTilZOax4T2uGnIT/I/benwjgoB7jzslrQEW/I1tGuNZv2qg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA1PR12MB7104.namprd12.prod.outlook.com (2603:10b6:806:29e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Sat, 10 Dec
 2022 13:59:21 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 13:59:21 +0000
Date:   Sat, 10 Dec 2022 15:59:14 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 12/14] bridge: mcast: Support replacement of MDB
 port group entries
Message-ID: <Y5SQsuAiiZUO4mrL@shredder>
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-13-idosch@nvidia.com>
 <38bcf2b8-83eb-1df7-b836-d2de4db851a0@blackwall.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38bcf2b8-83eb-1df7-b836-d2de4db851a0@blackwall.org>
X-ClientProxiedBy: VI1PR0501CA0016.eurprd05.prod.outlook.com
 (2603:10a6:800:92::26) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA1PR12MB7104:EE_
X-MS-Office365-Filtering-Correlation-Id: f93c71c7-ecb0-4bc5-e67e-08dadab6bc01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DrHEryHjM1goxEz7iJbCIpkn/59fhsw+QVSjRaYnnJ2+9i44dwmRVEzJPlXh5PPPlSjOrnYhG4wKG5ALC+F/v0joVoM9plwCkKBCFJk4Iz2+8VDuL5lEabR0KQ4t/5uUfxRF4yDec79+MgxLX+JsDUa6ts9jrWSmLuVl2vDBQM2KTWaR5I1OoXT0szJv9piPPEsBVZjD6asI1H8RnTMia42cIQAjAzEOJckcJVuMp84BRxNJ4PmQaIFpcUgK2JILe4Gd5zxU2P4yYZK+SjSYLUH3SBlbk9sbbSSI2IGyv1PiuTqyLeg6yo90eoj+Ijsk64HlGryve7V7TF0jvmTsiFMHOhek6PpGhH7svg9Bk76Ip+dHfNxZEodA01fycR/bN4IFvK0wClUecv4ndsNSs5p3JtlAKBdkAFaj3o2At2sOGL1lA+jqjzpxRDSLfIpW8nkVPPmKngLROmvgLvk4q7HcLUuKFQGY4IJZpOTUkAkZbVqkG8xoi8gK3PVfmiTa55pHQIX3CuG9ERP1TSOgYfn18tOFSQXCavxotUH8uz31O1CkgrJ++Syt3vc/tg+2ufYnhW8aapi6Ee+CnkdfldfUoC06WwqgT9BfGjN07xF/3qfnjxVVRwZtXazE/gcHYJ+t9mscU0doPUar66A9Ng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199015)(26005)(2906002)(6512007)(9686003)(53546011)(38100700002)(66476007)(66556008)(8676002)(8936002)(66946007)(86362001)(41300700001)(186003)(33716001)(5660300002)(6916009)(4326008)(316002)(6506007)(478600001)(6666004)(107886003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1q0VlnEbMI/8MXysCjRra4ZEHAdN50bVvCU1zMY+KtqGP/wk+GKedJOkkluB?=
 =?us-ascii?Q?QwoczvnCP7E/zQudJsn6UQxesVzaU/VlABZDiU1y9EZXxHhi/hGkULKJEAgg?=
 =?us-ascii?Q?WjVwQZwGWZv6UxZZnNa1vnA3Et8Enmmy6LtYXROsB8xvnUDTzWizhxzzJHCS?=
 =?us-ascii?Q?wHutwp1QvIqfMv0IztW52t+av/cyhIXy4BACD+eZmwL2xNMnnuaOu2LKw5zo?=
 =?us-ascii?Q?7Veewz/8u/lbMYj6SJeVSegkmmL2XWC0ppgjoD85BuZqOklK0M1lv1I9ZoIX?=
 =?us-ascii?Q?hwEQBb/Mz5hnLbh5TSG1usYZcMR8xGp1FzKM52QefYnLq/Q5GestUfguH5dh?=
 =?us-ascii?Q?ylemhrkfvC8VNazfrjkwrT31pPa2o5wao6tJzeGylVdCAEERyMmuxfyuGqRC?=
 =?us-ascii?Q?s+zha28ikdldCzoEb+gOm0DIZjMMhvl+TwrqUbPMGW1hki+hG9aThk3ZnrMj?=
 =?us-ascii?Q?y56ZnmRknMpeoYlK2E3mZoug/3G9H8rtMrr3nbZre3BrTpGWR2XKxCO6ge6D?=
 =?us-ascii?Q?1js7zH3uR0S4BqhbZdFm7a7LN8ot1oNZQ794071Qne1p6mvmo6ZCdhYL4mzG?=
 =?us-ascii?Q?uozWYT7wnSDiHxKahw60rM8gWhJtqst3JGX+LkWpWwXDIaLXfGVPbBLRi9xU?=
 =?us-ascii?Q?OyBCgNJ9w1cyU0rmqhx+IsMmd7/usYLwkVrwAM9JUhQG9wVwfTsJ0ATDrqR6?=
 =?us-ascii?Q?8/dLNcG2+VH9qQ0tp0Sf6Mp5rOhZv5+iJ0C3lG6FsMcInwipBTWR7mJZ7594?=
 =?us-ascii?Q?0+C+ZLaCf9I0DDwPI+Eqa8n8FGeZ0ETnN8WOcI2SujVf4LCdgyLFM3cfmAT1?=
 =?us-ascii?Q?U19qrMAE+rNF4N6821BGr7DmA4Mfm330ozgKmJAodyPteBeZEmk5oYqFERyd?=
 =?us-ascii?Q?2+ucM+ZXVUslEqY+cUDjFLIvx05bSoy7CiOJy9XYLEIZsVtY1rot2nKiwSPt?=
 =?us-ascii?Q?YiHdhh3fcdhUS0upNFG2tT5UaTb/hTHrpVVWxYdEvz2F93TaBRqZIaijtSmA?=
 =?us-ascii?Q?KxDdHckW10T9gSMu6lYOO+B58Cdx7lUIPpVbSVjmWG/N/0MnMUjiUP+SIRST?=
 =?us-ascii?Q?Jvp708lvt1KI80vALgOg/4A2DTjJOw3Ak1ETtwbOVcb232rieJbRMIMeMrxv?=
 =?us-ascii?Q?0QreP4yxMZwjATlLIwReXv6RAqxj0O5Q97bkt+tnwkNCiJ9xfLqusJGS57bn?=
 =?us-ascii?Q?rPf5kcQp0w5GuM6hsCODxd2WmkYFrTuKdKFuVhWWiRjb9WJ8am5Zm2+ySP+b?=
 =?us-ascii?Q?8VTffLmu6zNyEgYYDXIBmUoc/c3ZzS/dd7oB575D54IYcS940uYAzLejU6Em?=
 =?us-ascii?Q?4lEvXnqWrQshoF/bgFU+MtL34H+6xZ8ojKGWk971oiwRYwrXbGm+7VQJPN33?=
 =?us-ascii?Q?AOLaRFAGY6TiYqNCqkDBqoeIZQRfT/d2oY8saB8/maurhTP208hdHTGOuNw2?=
 =?us-ascii?Q?OkxmwqqwbVcoTlRr0bbc9mO7uUnF6jIUIVB9Sl/qZz4CnJQv9zyfD9uNl4Y4?=
 =?us-ascii?Q?fV9XM53olw7VB8CT8ARuwwU0LGpgcUnP36tftNY7uMGT+98dpdGr9gsn6yFp?=
 =?us-ascii?Q?K37Vs3SqBCvNENLy01E7imp6/9MVrH5zoWRdZO08?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f93c71c7-ecb0-4bc5-e67e-08dadab6bc01
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 13:59:21.3876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VFu+c60+xnvUzsZa84pVAXlOCcn9HfGTRHZyVX4Zv9NpTDWv/T0IAznhwbftZ68dLzFuntaKZFRR9IbxzJA8iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7104
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 10:08:48AM +0200, Nikolay Aleksandrov wrote:
> On 08/12/2022 17:28, Ido Schimmel wrote:
> > +static int br_mdb_replace_group_sg(const struct br_mdb_config *cfg,
> > +				   struct net_bridge_mdb_entry *mp,
> > +				   struct net_bridge_port_group *pg,
> > +				   struct net_bridge_mcast *brmctx,
> > +				   unsigned char flags,
> > +				   struct netlink_ext_ack *extack)
> 
> extack seems unused here

Oops, will remove. Audited the code and didn't find more places where
extack is passed unnecessarily.

> 
> > +{
> > +	unsigned long now = jiffies;
> > +
> > +	pg->flags = flags;
> > +	pg->rt_protocol = cfg->rt_protocol;
> > +	if (!(flags & MDB_PG_FLAGS_PERMANENT) && !cfg->src_entry)
> > +		mod_timer(&pg->timer,
> > +			  now + brmctx->multicast_membership_interval);
> > +	else
> > +		del_timer(&pg->timer);
> > +
> > +	br_mdb_notify(cfg->br->dev, mp, pg, RTM_NEWMDB);
> > +
> > +	return 0;
> > +}
> > +
> >  static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
> >  			       struct net_bridge_mdb_entry *mp,
> >  			       struct net_bridge_mcast *brmctx,
> [snip]
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index cdc9e040f1f6..2473add41e16 100644
> > --- a/net/bridge/br_private.h
> > +++ b/net/bridge/br_private.h
> > @@ -107,6 +107,7 @@ struct br_mdb_config {
> >  	struct br_mdb_src_entry		*src_entries;
> >  	int				num_src_entries;
> >  	u8				rt_protocol;
> > +	u32				nlflags;
> 
> nlmsg_flags is u16 (__u16), also I'd add it before rt_protocol

Not sure why I used u32... Changed to u16 and moved it after
'filter_mode' to fill in the 2 bytes hole:

struct br_mdb_config {
        struct net_bridge *        br;                   /*     0     8 */
        struct net_bridge_port *   p;                    /*     8     8 */
        struct br_mdb_entry *      entry;                /*    16     8 */
        struct br_ip               group;                /*    24    36 */
        bool                       src_entry;            /*    60     1 */
        u8                         filter_mode;          /*    61     1 */
        u16                        nlflags;              /*    62     2 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct br_mdb_src_entry *  src_entries;          /*    64     8 */
        int                        num_src_entries;      /*    72     4 */
        u8                         rt_protocol;          /*    76     1 */

        /* size: 80, cachelines: 2, members: 10 */
        /* padding: 3 */
        /* last cacheline: 16 bytes */
};

Thanks!
