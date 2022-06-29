Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7836155F711
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 08:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiF2Gqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 02:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiF2Gqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 02:46:37 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DC72F67F
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 23:46:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6g8CTQHeFCYw+8tR2aSEF3tqHwUP4FBJsiHETxGJlqPp8FR39WnAxp8LgjGxlKUIU4tOJnzrQABymTBdJGeteVYeRUcMaviucMXqxcfWKl71xh96UnT56MH3hp+mfvd5mo4glEOJiaqYVD0Fuf13D7gq2PKPspzRQG2JvrYZc7wp3DaYZxSiauD6bLU/3KTVxsM4tkaaxEfIlv0rLYBGVu73p3NBk4wFI9UW280oGaD9BMk2PxPGSg0fhyK2ItG3onrUXuVnz4YYngYcW247g08rildX3NDO3AgFUulNMSuyh85lU4bZeCc3Ye1MzhhdZthBJmPDuEBrnzR3UF8Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OhDW1/W4vYWW+Av8SiNKQkg7LLZ7faI2bvBDcMQ0V+Q=;
 b=OJ6YHzWd3znSAu6KLwTwVf8Afyt9TJ+rnk8Hk3APZvS2wt1Q1ProTX4YnRpMh+3WPjGfSpeaXrDADvFkB2KGwpbsuRUgvqzGYM04oq/mrngeTmj2pAl9vy3AaIyyHFzW7sA+swoTfOySl5NPi7ShAJt06c48V1hBZ2TGY4su8Iw8nTRr55n9gdjpg0+7zScPYeRfuABajuES+7EbiWQBbEmEFK6OmysAIGiujkhAVN8bLNA4DW5GVIIq7ZrItj4h2M1dVENgkH6UDORFM9/epfAyhh4wfzCRvuArTOjY3QfG/Xgj649/Gyu9WhAnZ8qEEllzYjdfu7oiS3KLaq9DmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhDW1/W4vYWW+Av8SiNKQkg7LLZ7faI2bvBDcMQ0V+Q=;
 b=jBcMClaVELgiAr0qZjwi0/Bx1FmuTJk1NVt50jlFSnrKgNAKxOcEvlsPOkAJmu0CbaHfIpWMt07qELcSepiBEkn9iwEkmoZtps7N6Hx9Uh6yBhu+JCi2SWfYEaeGoGtdgHdEqlxzpRZmIDm7KWZyT8FhfRRqJ39XwNUHdrXmBdZ4w9GtsDjVJjqx5F5217dLGTHWzW9TbCYBH83h419sswLiIBZ9zHltWZizdETqQyImYvpTtjgKl5kZPrdq6ZrxR17d8ZieD0DaGFoEz1YJNMNPZ119JNE0BYaKUjQaSHl7/+prS1khDxZ2dM4AMkNKyKOrsRg6DALNE+BfvDXYmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN6PR12MB1249.namprd12.prod.outlook.com (2603:10b6:404:1d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 06:46:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 06:46:34 +0000
Date:   Wed, 29 Jun 2022 09:46:28 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next] net: switchdev: add reminder near struct
 switchdev_notifier_fdb_info
Message-ID: <Yrv1RDz/WYsURJ9m@shredder>
References: <20220628100831.2899434-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628100831.2899434-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: VI1PR0701CA0032.eurprd07.prod.outlook.com
 (2603:10a6:800:90::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdb52251-f570-4200-ca2e-08da599b1b80
X-MS-TrafficTypeDiagnostic: BN6PR12MB1249:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fFJlRah3PB6YKNvyAj9ILdtOvQvMa8Z/aWmYdG4OOtwRPkOiHal5qJHe5LTj7qgBks4u4a0GCr+FdpVEG84scoDl6aev1/4bqmFU65BTs7QLCdvaiL32DEYTrpyn/FTsmodmyvktwjcVMgPCAWgIbYfsWzjpT+0OrqLPJoJ8w8bQ/m9sag9gR8hZCzwDbhMdKMl4XlJZa/oHoH464lNWRzN5MO+f2vcDNVXqHMLPWNHbnySvwHgMdSbxU1RDLvV/4PE8hf73QZwnOKIKlqTebilGWc/oMldXi91WQfOOV4SUOKewfdSaH2xowgcHMvRI9EfNPWj65KXqP6FR87xs+aQk3Gs0IVE4TMBp8s+fVzad4np6o788onQnRI2fhgnpXb/PIHk+qNsJEVUxtawEbiFF6CHyWCWyQL25dQl9fW1X55gMCj8xf1DA5QRuiDxMaewNIMJoMghkr8CvcfvFbCdpUuf7Z7GsJxCnRJyA6Tnbgnzpu6E9k2aU64D+7u4zkvymlmqvSlpQ4LkBtl3nkpROEId6XdVjKyYxKzVwsfBjvaUiX8THdXpIae4zzffOjIZrgMbso9JoPRXGr2/zzZH+M2znqT19+fEpbwMah0JkkSISjBEl2OlpvJP7DNdSFQ5c8muU6sNe5ys+fmmvaIcfSr02xwKmpKo4/e0lDGs8NbU3DkVj/qTGvSeU9sU3HsPqnbs+JgjAJz88JmqGKxHg/MoggXMRNspUtP13Hrktfmd545z+gWokf3r82Sr+RQgiivStkw6Spt6dWRLnPSFiBMLEnymVX/rMK7Kcum8ubDK7ZBBhpoThrNMxVzE8qdYedK3qLRXWenyrNfQmhHjl+Ak1WCeRx08LDsG6gdY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(136003)(366004)(376002)(396003)(39860400002)(4326008)(5660300002)(4744005)(478600001)(9686003)(8936002)(38100700002)(316002)(6486002)(86362001)(2906002)(33716001)(83380400001)(6506007)(54906003)(6916009)(6666004)(66946007)(8676002)(41300700001)(186003)(966005)(26005)(66476007)(66556008)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NFE5jhAabN9JM92WNnjiUBIrPe4i//IcFI7J7jUDftyCYSTEux3ucq/t6tPN?=
 =?us-ascii?Q?BrUvPSeM93h0KDh88XffeV2tMrKrUUIxdl0xiVAeUbr7MhfLXI0/zxYBRUbY?=
 =?us-ascii?Q?Kn5flkgnc1rvQ72JT4Zjdft7O/SxJ+ybBV6w7USU1ZOtA0mwxOhi+lp67n9I?=
 =?us-ascii?Q?Fz2AXHVKgtakyKFwobYDZsa1k7/aJ1gmHjP3BSKaUsz6Wp6QCHrlWEsmW/0s?=
 =?us-ascii?Q?XHSxJeUZasPbvr9tCojRWd81gE4JxpU0gzpYAUBuH4CodH4TskwPmbT/LNiV?=
 =?us-ascii?Q?xfxufj2bxIAyEGSOEIJzX1VvQ1mS/wV40/zz/ZIvKpmiQ1LuVAU0Ei8BNLBw?=
 =?us-ascii?Q?w0h+V7yyRMNfnFVbj0sxUVgIg8DP1vP7OxOoYeAHKMsS4PnOiQqU11HRjcC4?=
 =?us-ascii?Q?F08aZVFx932y6rqtBa8CgkYZQ6Cnf6RNtwsSNVR1ywApfwJeWga+MOzvqskV?=
 =?us-ascii?Q?xrhgUrNQ6lBvNDYxKOATCsRiKPR74YAAlm3eatlR5GkdI5VtkkFXEIeS5edy?=
 =?us-ascii?Q?1FLvuCgE2KkuMstVEvgtgyE//QbYOebH9/oeOwm/VBnjH1SoYiZEG15PFqvj?=
 =?us-ascii?Q?NAJSjw4zmMxGH/4ZDDfVvV47YIqT7NJIs5L2abEy/IUpyux5a7y+8rGLOK2V?=
 =?us-ascii?Q?qIos0G5FgS8k0jdmJ6BCuOWpbBrdsANY3R5+zPZYi80SidXRgyBrXi/7EMyX?=
 =?us-ascii?Q?gotzZBGsC3phEH1GPEdaWNbWxFqSTOzAx/m5nQkYx9gtuP1zYKP2FWD3BHkW?=
 =?us-ascii?Q?uGwh0iH2c6bRnUR+5Y658JWregqFNBkamamfZdQCnhp9VjKhVGuaq0Dc5KLo?=
 =?us-ascii?Q?0R5xMSDXdGHUZt3wpkBqKFXykhgmYi6/zalXeOuio878VPuHC4GIWXAdUz2u?=
 =?us-ascii?Q?cuW+55ZgWMDDR7DSv5bVYZ/mVzV3UgQzfyLqbGS8WkXaeG/yd3esMjvZvLuJ?=
 =?us-ascii?Q?Zbeju/AuRMzzCg6hL4h0RFcUsDfUGiy55lxNp+AWfVs2JGNTYPM/w1YejCQ4?=
 =?us-ascii?Q?TUcZY+N/SlZhAMXwMwvtHWvHhZjTJSkRMtxiJ4AZwukvXOYFd+pYAC6ivd5U?=
 =?us-ascii?Q?x7F/J+BqJQWRtt8t7drCtTutBs57bWGiVGlYtsntZqkDCE25FjgQYwYK1pYq?=
 =?us-ascii?Q?fL58fBtnUVln1arS8wfz7M8fNdwq12jpWKJ4OTlxlf7sJ5tsT+xbvO4BobFs?=
 =?us-ascii?Q?NhNjfTZm8gRHIt3lknafAeQfx+mc9+Snp7BuVd4Zmdb57TxlwHPDZ1aVzvR/?=
 =?us-ascii?Q?A8W0fxNHmsSUrdYjCvDS4WnxOUO1fYnhI1dwW9jPlbKlgIS9mjTV6fJib21S?=
 =?us-ascii?Q?xyTCNYUiQPwwa/0KOdGGxuvhARSS3dIpl1qTUs6pDdx3zd6FUx1IH+omfxPd?=
 =?us-ascii?Q?NlBrumyUXQ3dFbPz9XeDUWzeYtgI0UvwhSQ59mHDdWWFZoweaaQC6SONyFsh?=
 =?us-ascii?Q?CVopjocDq9FRym7F9ThE2Wy+yyPLyOso4zaRC9YtM1EKD0XxGdjdD1LoM6cz?=
 =?us-ascii?Q?+hffBPJi6mtD15TLH6mL2b6ssMT4a9sChVdWCrWPdGgTXKQ8B8TTmJuhxnFX?=
 =?us-ascii?Q?LENQ2pCqRFw8d8g+N9NYFkQxt+zfTMzd0SdBgDzu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb52251-f570-4200-ca2e-08da599b1b80
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 06:46:34.4773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: khMnOi/6+BjuahFs+wTooQ5u04hee2w7xHK/OES2jPfkONE93fIg6Wdi6us/WZMsCEfgU76jypUwPZHRISLdpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1249
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 01:08:31PM +0300, Vladimir Oltean wrote:
> br_switchdev_fdb_notify() creates an on-stack FDB info variable, and
> initializes it member by member. As such, newly added fields which are
> not initialized by br_switchdev_fdb_notify() will contain junk bytes
> from the stack.
> 
> Other uses of struct switchdev_notifier_fdb_info have a struct
> initializer which should put zeroes in the uninitialized fields.
> 
> Add a reminder above the structure for future developers. Recently
> discussed during review.
> 
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220524152144.40527-2-schultz.hans+netdev@gmail.com/#24877698
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220524152144.40527-3-schultz.hans+netdev@gmail.com/#24912269
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
