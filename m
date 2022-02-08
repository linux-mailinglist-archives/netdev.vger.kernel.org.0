Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCA64ADE9D
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 17:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352311AbiBHQuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 11:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbiBHQuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 11:50:01 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2109.outbound.protection.outlook.com [40.107.94.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31626C061576;
        Tue,  8 Feb 2022 08:50:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pr28Q9CTVHE/HHlsODG3azskayQm6FK28jLdqUfcv4Y1Bt7VHRcBTxwMyP9U6zRgnqacyqhqilzZGWrH3kivYrNDw86oscX8cXFtIEsgnHkQP7xjkiTVUEKTouF+rH38Znid7ee2vvi9QJ4xiWuEGuobFeCe69hI579Q/jlNto1ARy324t2e3Re/3xSoaXR1I9LyN+G/mNAYM1HJHAQYnGi/mWd9xUhFQslQp7LLzIocbzHdB2jPerLDDVtZla4ws/wQHlw+ZqGPlv7Id4h49obEgSb6clklsDxyh6RdntCd5tl9Lr3eI2/vbI5ax2J8+7mTvM7YXRLNIh8rwAexog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Af+aRsW+IVMdrxbigPu+UO921LMb7qJCux2LaLSm4w=;
 b=SU5UXQjDDVWpoKFhKDI4q49yzhNBSX7b+xbbtIt94FxjucCRFqxQcfmwY79WIKNJdnwvy/oz69LcpeuCAIvIpgukrt+AS4G1leh1hxBuxly+AaNpQA1P8yf3MpZ7xx6vsBFNL/yLa5Of6D/1sTJHqVIaYPw6XXcIkOdlqYqwJfbfTWXGB9ofHlb516ZHjcZTHe/fUu/PujV3MEX5UGjv3bP3cCYRo9loTLEkj3ilIY8reag/p7vgFna6qNn8iSRnO1+JYXqyhsc4RgSpHjcTaFF3tuvktvFi4bcXMwW2/AFQKj281I4h2O+lHCZwjjZyuxg+gRAdByyvOqc/pqtpug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Af+aRsW+IVMdrxbigPu+UO921LMb7qJCux2LaLSm4w=;
 b=mSyVdZCl07ZeklpURSnq3kEk9ZK2Ge2rLkU4uFV0qlA0z1RZX9i4pX3RqFNHUramzndUvRJEHXnrDvqV9s+jcchtSunHioiHvEk9P4S4uAbyCMgsF6pvPrhGtfnSKpJWFV31SJbc38dC44H/NjbV7d07jqj2XZ9zYDwSEbYCPuY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB3551.namprd10.prod.outlook.com
 (2603:10b6:208:112::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Tue, 8 Feb
 2022 16:49:57 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4951.018; Tue, 8 Feb 2022
 16:49:57 +0000
Date:   Tue, 8 Feb 2022 08:49:52 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for
 stats
Message-ID: <20220208164952.GA238@COLIN-DESKTOP1.localdomain>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
 <20220208044644.359951-4-colin.foster@in-advantage.com>
 <20220208150303.afoabx742j4ijry7@skbuf>
 <20220208153913.GA4785@euler>
 <20220208154515.poeg7uartqkae26r@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208154515.poeg7uartqkae26r@skbuf>
X-ClientProxiedBy: MW4PR02CA0004.namprd02.prod.outlook.com
 (2603:10b6:303:16d::19) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec6f6b5e-dd44-4c17-0291-08d9eb2309a4
X-MS-TrafficTypeDiagnostic: MN2PR10MB3551:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB35515253A6F95218578BB474A42D9@MN2PR10MB3551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qoHBP9XowFHJP1z5eXIhwuqniw+jU4gbPwCwrmBqnsgU7r97QpR4eAAefS3Kw2CB2LJ8B6o/SJX9v8jl0ScAykj0t3x2tCLYxKC2g5Rq/Tf/jiVZ6W4HGxTKtXG417fDxCHDtdwkmRvt6mw8AW6I/ZChKBmIVvbYZVyx/ACbqHjSPU0dxxQoodYfx26M+tEoKCyFiAzuNYB88MIFcExRKdiqmt0KorP47akaN2knOb3pkxM8Ki2xx0VYsZhNk1FtTBupBt3t8BU33pMgyLInDqirPGyDhS17T3nx5Xo6wclnCk/AdSK40Kkw6sz/6nrcONfa6pnWcM1cXejCx3Q+g1f/RH1p9Y8l5+96Rl3rUIuM7lFD72MZI6MjV1nCsztYp7ftfb/Y4mG1dtA0YVQlhrxuVzvg6N0YnlWF8d6pftF6HpxJjYq/rSB+p0SDSNFiifwhdeyLOE/SpoN13t116gDu0NCDKG0KdoBs6veXLfgUJspPQB4K7uG4scm0IPDnSDJNxU1GAF7FyxCgH8iU7VKsVHIL8pl6tEPIgEqwhM0xVtgB17CxKsYxsI+NyZtySWfTMXHxw32wFBJC7KQ0z1uTzaruMpF5Q8/6W4lIqnKlKaxTW8SrTgND5QAiKwfdjx8VhXDxl2i6RzCZD0hpA9+zG3d1ECBVRVYMP1lMnKxxzh0cvDrBDcH8QUcnnuZxKAsPmijkvO6vfX/Q/8hJNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(42606007)(136003)(376002)(396003)(39830400003)(346002)(366004)(186003)(1076003)(33656002)(26005)(38100700002)(38350700002)(6512007)(86362001)(6486002)(66556008)(8676002)(4326008)(66946007)(66476007)(6916009)(316002)(54906003)(508600001)(8936002)(4744005)(6666004)(6506007)(44832011)(5660300002)(52116002)(2906002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ObhA8bRiWqzscqSI2Nn6H6tYo6LkusXMQR9+EzwBaE+pkWHez8xQwPKfwooU?=
 =?us-ascii?Q?70+HpAYOWDkANTAOplrgUfsyU19rFHfLM5XiT6CtldeDc8KIgNHjAWIXCYMJ?=
 =?us-ascii?Q?goLzU3mkgI6we2Nsc0S92+sXSC7EyhAFmMZGe+7+YFCnGRsV22yyRA0H/RMb?=
 =?us-ascii?Q?ZWRmpkXfLLD+l/lKg6RV7/RV2MwmivoJLsTFYaK6E6ED5S9oKQED2SZ7Ludw?=
 =?us-ascii?Q?azpQE1lVH7NQ3KvVuTxobaJEHNdp9yCFO/MTAaTsMYyseyhixjlrAhQ1ZT0G?=
 =?us-ascii?Q?710qh+BUMv3tY0d6jrCmWXqkiBBFyx+9tN/vKpUxpvrxZnUl/vk/Ht+GpnEB?=
 =?us-ascii?Q?LjgN4NedSGgJzlzqWRjl8R5rlhMS67TZA7dh1rcBFcCgNIB6Ji0cIctdI+4l?=
 =?us-ascii?Q?q2sug7y8p79ar00na3hzuFxNj6GMU21FDn5fFswzFGIrlrvufPIlFeli0Bq4?=
 =?us-ascii?Q?u00jnBmk6fjt49LrRp/2TvtdyIWDxg3V1qZDTTh/MF4Lm7y13u9raKjpkfBG?=
 =?us-ascii?Q?MXq4m7xIC5WGWbuhvzbpt++BnhpMiidcmGL/rHghw8QGHK2VusB0Eqkcqkve?=
 =?us-ascii?Q?CFWf9oiV6XrnMFGUmvzwHqg6EABbZB/g+IqRlVXJLTJMl6hLpuJ280vMNdE+?=
 =?us-ascii?Q?hKsOfNMyeRtUGRIM9DXBfw/hFCyPrNCEjFZLN6uKNo6Zvk92dX8xbV0FsS58?=
 =?us-ascii?Q?m+8l05NvFuiY5CJeXqxdAFX/mHNZvVaa5s/7gN0FGXwNeZopBm6pZmquFN+f?=
 =?us-ascii?Q?CyXGLZNh+gxipjobXts9l7bhfsaDdJUrPNCw0TFZGyJQRRzn3qbRPw+crNML?=
 =?us-ascii?Q?50f/gt3/XjucBK7NpvXzwKz7Q69U31Uf06urVpVjKW8vACSXeny6jrz4xnGq?=
 =?us-ascii?Q?6SW6i1rVI++OPSSFLzvSkjcUaO+ygUkT9cCufH/lZppXQKCW9UFXCr8dNIrg?=
 =?us-ascii?Q?jufNf68hMe5Rm8GjrUoejC1EB5udniwCcMWlbH04SrF4Dk8AF+hYgKIf/hmX?=
 =?us-ascii?Q?uAZZkdTIMxBefxJPdcVxtxBut7Fc7Yj4/OldtarXgtZOx/Mfl2ozGw3xVFNe?=
 =?us-ascii?Q?x9p8scxnWcPxcWVMgQT6VHcVv7ZOQ64wh6+0oi1Ga0kI7aXOs13mjDh83Wnf?=
 =?us-ascii?Q?ebq3W9UH3ZkTJj2bhHPzKjHE24XVPG/Fz3M7T288Hz+ANNMfQgd8if1fl/LW?=
 =?us-ascii?Q?Ab1ocxODyvSa5AoKM0tpgW9FDt6DqZ4M0nLPb2jLmMsEVeb7D3TqAD2Rf1p0?=
 =?us-ascii?Q?mB5+nHDP817q7O+WffsZk4n8TYnIR2J1WtSRAj5ftC3bptbNNcoKVPDBq3mr?=
 =?us-ascii?Q?Qc1VtJYv86BPKX0KscPvSNwbKbkf7VOAuSVs6OJ9G1CMdq2b8wQGsAtJz8E7?=
 =?us-ascii?Q?xzaVQSshRUgGO3UB8CXKiVS4dTeppJIi1AALUJz6A99BOs+zcXePui6NPquE?=
 =?us-ascii?Q?QI9XlcPCd+OQ3Q5LrvwV2QC4Ao1wMA4SY1BpVjgZGmgRYWf0cJTVMzLMTCON?=
 =?us-ascii?Q?4Sf3gYVGfUQAcwIqRJK8zkHKxmY+haJ/Rce0xkGdjJT2Js+asheluCIfEuhE?=
 =?us-ascii?Q?5CtdepktxFxpdiUJcu8TOwJ16Y4cdSI1FEtWDzAgTCeF+uolOmsNPh9f8by/?=
 =?us-ascii?Q?umYZY4ZmpUnhFZJokFqZXThQWaQtE+AHB+W6hNKBuO9u1XT0NtS4l6dXMENT?=
 =?us-ascii?Q?bXTCRjbpKeht5dRvQ0QAHMZSyC8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6f6b5e-dd44-4c17-0291-08d9eb2309a4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 16:49:57.0105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oed+ZJ0N2BOqL2PNfe8SUVuMzwi4rqq28FSFoaCHgbTHwYIWAT3QlxrnCyM1qNF+FqZ/8nafQh2AMGST1Agu4yOY/Or4Hl1gg0Iwlo+jWvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3551
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 03:45:15PM +0000, Vladimir Oltean wrote:
> On Tue, Feb 08, 2022 at 07:41:56AM -0800, Colin Foster wrote:
> > I see that now. It is confusing and I'll clear it up. I never caught
> > this because I'm testing in a setup where port 0 is the CPU port, so I
> > can't get ethtool stats. Thanks!
> 
> You can retrieve the stats on the CPU port, as they are appended to the
> ethtool stats of the DSA master, prefixed with "p%02d_", cpu_dp->index.
> 
> ethtool -S eth0 | grep -v ': 0' # where eth0 is the DSA master

Thanks for this hint. I didn't even think to go looking for it since the
DSA Documenation mentions an "inability to fetch CPU port statistics
counters using ethtool." I see now that this bullet point is from 2015,
and probably should be removed entirely.
