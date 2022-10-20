Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9B4605B8E
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 11:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiJTJzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 05:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJTJzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 05:55:37 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A4714C51D;
        Thu, 20 Oct 2022 02:55:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XaXD18bPEeOMqcCMZ/+PQC2vGyrt/tpfJCHTnHNcY0GRiEmTEXzqAOoRKhKbuo29Tr6Z7E65dbLxC1YItayjM1SYZjW/7XagxkFrq4RI2XGiDvEbm3fDn1Ile3mxswcydTS9goCDWfPtTWfO+OflutJvcf1xlqL1MQXGYGKZ41/s5NCREGK8LYtTxHFXnY7Olc8Ur6upFJTqRHbsWnaDAmsMBPS/jlH4gNh6ziyi3hkKCQm/JMSn5eLRdanAgW/BxvjzNiyrokVHicJf4/OvIjA2d5KFj6najbGLlxKsjOJHCWNH035DUFP3h51178+JwF5YCO+9aNPJOTNZaetGRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hPEFtBZAzwiUajtMxvjOEuCLKwkEocj6qxTW3LRTvaU=;
 b=Qb7n6c1OvvajAqsXHhf3KdPJzvuWbp/i50+C6I5jZ/KXrokVbe3sJFvf2BQcklwgWhxBKyVucFPT5+ltlMh6qln7yl7VwovcrPce/gGqnkdw01yNfwcaqmGxovVpitVPByJ2P15imeUzzwtjgLyIQP2upwsV22QYDiE0HJEd6GtAR6sHO/nkPpdaTlbT9XkUWOj0LtzK7U7XDs78K4eWC6h8k9JUMNSlo9yDTinENkPq3idExxkHebtprmugmizFyrQVKiMlF1e6jMaFvlvIIRxDddLgnrTk5CGJ+m0MDqPV4E6GsHeXtxk7uB8aXz38m9y4U2I5fRgd0b1dr7UWSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hPEFtBZAzwiUajtMxvjOEuCLKwkEocj6qxTW3LRTvaU=;
 b=o7SzomlP+TxTBd6PrRmqXGpxrn1y7EBB6qWHbu6xaunclxqy2K9m+6oN7z1dC4gzROICoR3GAwh8uC4AzIYUhaq/QnFSHv4UvyB64aJ1pfpDWD/yG1XbH/wXtVK/7uZ1RmXhKPLadChGI91OzoL8A9cVphkSHgMc7WNZ+AfcIVrK0K7TXHV9bLjHr2j7TGMvjbYdCACRuCEgWwUrwXBfCA55hwIALs7qH6Q3PFRvlUBPOpFCmtrHKc4VZqyOzumSK43moVvfMQbyAP3h+4rSQZc8zP9VmJlqCGxXGC05O9kGrfJUa79qgtGy2PQdMek2AShtZcKSmsX1oPvUNSzLxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH3PR12MB7617.namprd12.prod.outlook.com (2603:10b6:610:140::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Thu, 20 Oct
 2022 09:55:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 09:55:34 +0000
Date:   Thu, 20 Oct 2022 12:55:27 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Hans J. Schultz" <netdev@kapio-technology.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 00/12] Extend locked port feature with FDB
 locked flag (MAC-Auth/MAB)
Message-ID: <Y1EbD4gp7MuTb8lu@shredder>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221019115809.552812a5@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019115809.552812a5@kernel.org>
X-ClientProxiedBy: VI1P195CA0084.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::37) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH3PR12MB7617:EE_
X-MS-Office365-Filtering-Correlation-Id: da607213-eb7c-4fdf-b04a-08dab2813b0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ib0akApWlC3oDxWG1XVCrv1J454cTr5bYmGhk7BDiW3HMGDudCq/Dkl3407MbXTJHg74jsgqPhPqGlkYOAgdQT5hY8pRhcwt2Uaohqo+a7BbcHccYcRaWOwV1qvkWtkPY4nVmDaL2nGY/QbcDtIr/htdxyZea2BeqknsJO5gzAXoP/HVv6Mqx2B/aMtfWUgv2d8tDmX7p91Azi2DkLXF1kBLBM1T+T7rwi+nDI1x5lFWl7lDZ/bPrgxMlb9FwoYRtVIkExsYqUbZEjoEYX004X/YUYPg41GATEi76bWmEwGYYhz6Ecx7wuZJ5rcZ1p6s7me8eEzbPuJjBqM09AlDZs/+q5Pba4oPDEI/fGPGL8hS0BHsWbn18VmYdquRZTyO//zs2m2fKHzNEimqAJ0X2JLQFt+GKI5zaDNBLyt3zTLVTATlYSZPy/SDe0GMppB5ysYXzDB+dy4n9VdEvXU6lH6PivS7MLBjJ95Q192z4+lUPelRyZKpmlVdHcs+wbIKxhpz+dWcDPsWzVTFR8YJHtigHvHVIGTph68UgqzcYYvxSFQvoF+kZdQ54bJ45apGiQQUxoZXVKKQg47Lu3eEhlrOOYy0OhwgfmfLFmQb8O/3MvXJFCrf3YSatNQnKV9QcDOSmLL+69r3hq5vAle9nVuzmZQDiMCfuBUpiWuZUFbcUO8sD307u1HkrGrz6SoKkirXGFFPVJhBoo+bq3RQZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199015)(7406005)(316002)(4326008)(54906003)(6506007)(6512007)(8936002)(2906002)(4744005)(26005)(86362001)(41300700001)(9686003)(7416002)(5660300002)(66946007)(6916009)(6666004)(66556008)(66476007)(8676002)(38100700002)(66899015)(33716001)(6486002)(186003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tn4Ed1z4LZOhHafpBDv/lprJwbMvaIIf5O39bSBZCI3wBymGln4H5QoJw2TW?=
 =?us-ascii?Q?0oQZwv0bsPeyAqHUbSf+2BrOSxrtCpuOCfAD4+lhnT+ro8GTm8HMqdse77lu?=
 =?us-ascii?Q?+gGtDmYPAVnd2KtxSZeXHNSvwtl0ps7XXf45dvUyRrD+rzHY5u9VWsQd4D+x?=
 =?us-ascii?Q?ZUwaTyWeWDx2QvQphnPBRxQIcaVGfXJVHcxeD2rhcbzxMkKEfpxNysKL3tRZ?=
 =?us-ascii?Q?8Un+rBlsLb4qpcHLMFAtzC1zrRJR5nhSi1TdwYphsG9MxcwDnEH/KOm7Xhcg?=
 =?us-ascii?Q?kbLKkRYY2oCVxMtHz6+JUVtjQpbmA9sslk3E7klY2E7kUWeIB9KawQMJiBOZ?=
 =?us-ascii?Q?BaGXCMxrVOpf1RsYMlprXjFj8ioOcUMDrWm2lhjuecUTCCeOwpdkrUftOylH?=
 =?us-ascii?Q?et4y4nn8e6J9oklINYBY4wqVm574Lalm2AEKMu0JEUs+yIWTaVJA//zt7la2?=
 =?us-ascii?Q?a/Zc2X2dzfis4V5NkcVuhsTXRVQtnvY4+LkoTzNuvG0zBotoISukh+FNH3Mf?=
 =?us-ascii?Q?J2ppKupyCz9jAcsjAv03jbAY22wXbFImNrAFwTQ2waUewmv+1eee85nRsmCP?=
 =?us-ascii?Q?PO0jXeAX7y6xDbvA0Z1pjDI8G3np+PmiLYfIfDzEgOES/bByOpB/Vh6gWG8Q?=
 =?us-ascii?Q?ANjg87Pk+9mdhfDPpZHZel11smU8tY/OU4+nntY4yv6ifFXGDLcs39BSJnRZ?=
 =?us-ascii?Q?RFxN8cHlKU/04qL3ynaCh8nJxanob0Qp8A+nCQvpJUUnzDJJrOLefKP6G7aS?=
 =?us-ascii?Q?eAIepWQP9A3KycYLJLP93y0FPYB6fhBUs1t8i8qeR7uZZcC8ql6Qtj2+S4Fz?=
 =?us-ascii?Q?bTBT4rHXUruKU2+vc883kY9hrP+G2Rq8d4FCypV6fmgp96wBX0/E87PdkuoU?=
 =?us-ascii?Q?xEWbddcfLPyjsAgNxKHYkm3X4gd0+PyjSDZtHMLC3FaRfOjKhs6IeBapivgW?=
 =?us-ascii?Q?f4xtVl4FtuMEyYKtzB3pWCC7QYZvg2Y5L5xQEyu1qpE6HKcs7rfaJoCEK1e3?=
 =?us-ascii?Q?pYmKqJdBffifjcVmO/BALlzx05TbPyh0XAwfPO/gw9rZA7zbNBWILq+Cxybm?=
 =?us-ascii?Q?UUEQjv2sYYhR4U6HxWdleyVIKmKcGoC7uS97YOZomFYOvIy0sy1r5hP8thuj?=
 =?us-ascii?Q?DAmYHgNsL7hLbkZv1HodzxPTYmY6feIozZwJqrpAno/2Y3lUe7lRx8eSaG/m?=
 =?us-ascii?Q?qPyEoRz9cEETx5Fuq0YvFE3tfqfmne8HIBGrlVX8T/aNC2lj2S77fkn/49Vx?=
 =?us-ascii?Q?VNX1zq+hoMq2oe7f6xYeeNJUoPdHpnALfaB/14oJCVyP0b+5jVWnTmyVZhrO?=
 =?us-ascii?Q?h/KymZ4zkogzR4d1y6NhKaW9NVJIt2fpjXfgV1JueM0uy7lIxV3WcXAmNODz?=
 =?us-ascii?Q?TuE6vVNFJwYPLhtdHwu5fx3AgP4JQlnZi6uMyFkt9vJ259zT6u2/LiY1LVX6?=
 =?us-ascii?Q?hvUhSItztICffR8xTc/JB2pYoU3m2Z7niG50flVSD7m1fJbhgYntgTuzIkvp?=
 =?us-ascii?Q?4tdmcZsUitrI4VKD1o9GWtYrkZdxJ8TXDZnC4j6rShEua8+OhbuK9oklnKMK?=
 =?us-ascii?Q?e6wNf3PM4PxQ6HqgagcyJ0a/HFp09hRdzoNDVFZ6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da607213-eb7c-4fdf-b04a-08dab2813b0b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 09:55:33.9524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1tfyF+rSX2q/Pq4LAAlDbNE4KeAFaY1SxyBmwBQMWTfUppWs8AqnxfRrLMaD9mNSBQfscjuGiXU+KGR3BMV8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7617
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 11:58:09AM -0700, Jakub Kicinski wrote:
> FWIW half of this posting got stuck on the "email pipes" for a day..
> somehow. Let's give Ido and others a chance to have a look but you'll
> need to repost even if it's flawless because the build bots can't deal
> with a delay that long :(

Will review today
