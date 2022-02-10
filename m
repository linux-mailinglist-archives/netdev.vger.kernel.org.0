Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0654B11CD
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243676AbiBJPfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:35:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbiBJPfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:35:46 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2117.outbound.protection.outlook.com [40.107.94.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B28D1F4;
        Thu, 10 Feb 2022 07:35:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3IaxRIzaRKaxV0yRng3MX+8ELFId1bbWkSuq5LxByNpcEv+78wDMg3WdeLHrrVcJoIQKmJZbrRtXPn2B7zTxWGUyjOtskD7LrJyBNIhUdLORrKg2M9/RLAaty3S6+F/UP/bBf+sZBCssWdbk4J9dbx/xuEgNuojC8hMWCjUM+lU5Z371CzOYw5Gy6U+OdEockHTIvRx5qQic4TEYTlZHyeBhVrlYYVSUVMzbvxti7MJZpn90MuCyhxilcFxGosnzjj7XnP6suRdxXKLr4dRDBd56YyBwIbFloTkxZd18Loi0DHBNdmsgO0MSKt6jONmmhmWd2vgzOPmdiOPR2/G9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQibbOYoz3j4663IAMto4myREgWjBOgK3ROCVjflfI8=;
 b=dXqsQXwE8iQiCoqYkO+2Lcnqqq6GtAT8kOfo8opSnI+qD6rJlPPhc4jaJ3jJdBgzMPFiGW/KREmkiHpGqNwDHAiPpEWB6affnHOEQ0eZ46pVlz2xgQin5j8BdzL1ZYZmuMm66b9gFtq8tyCOiNZL+Mqyvc7VYVhTABgKFcFS9JpibuTq4EU0SOY7jZPtDRNrQabZTMfMuR4Ta9NmUy4TA7fONiaXyhzn1H1I+ZBwJt0x1rIzY+M4BXSA8MjWsr761qur567nKlgjIZ5CVz1YSwvZdKxvK6WcnFVvYTMeZEAaq8H9ernfV+j+BJk3fDVxV4ct65npcjDSRGM8gtGRfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQibbOYoz3j4663IAMto4myREgWjBOgK3ROCVjflfI8=;
 b=UmZdCTFcYoVRPmDzstbO08sjWf/JuDsPqd3szermoXBOdyYxtGW2n9u+CEvd6UOP36COi+jHzwIW8ZbNXUQQ/VOtjRhPk+BiPaLwZH9bJmIm+IYD6I8Mf85zQwRlPZGXmL9yD1TqoidsbK/fdFdVw9Of8uHqB5j2YHrKPSkxoR0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3307.namprd10.prod.outlook.com
 (2603:10b6:5:1a1::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 15:35:44 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.4975.012; Thu, 10 Feb 2022
 15:35:44 +0000
Date:   Thu, 10 Feb 2022 07:35:40 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v6 net-next 5/5] net: mscc: ocelot: use bulk reads for
 stats
Message-ID: <20220210153540.GC354478@euler>
References: <20220210041345.321216-1-colin.foster@in-advantage.com>
 <20220210041345.321216-6-colin.foster@in-advantage.com>
 <20220210103636.gtkky2l2q7jyn7y5@skbuf>
 <20220210152103.GB354478@euler>
 <20220210152712.jchztf34gf3pgsyf@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210152712.jchztf34gf3pgsyf@skbuf>
X-ClientProxiedBy: CO2PR05CA0088.namprd05.prod.outlook.com
 (2603:10b6:104:1::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c0b06cc-3b5e-4146-19c6-08d9ecab003b
X-MS-TrafficTypeDiagnostic: DM6PR10MB3307:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB33078BAF89AE56B140E935C2A42F9@DM6PR10MB3307.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SuGx1W/3ZRidts7vA3HS/SJmmF/6Itn8ZHbrVSR1I8oC/375FLeKr6nlUJR5KxzaSmYtw0NDyjf+6t8H/pEbLAwq3lOSIYtkSDu1Y0sOuTmg3FCJxf/uAnNmsvRmQJDML5NPSCi4TKFLEvFNwFWtcYS7TERCt+xFDYdcr/2b5csWEhTJOE1Zc5vFkFtZN2SvSD+IYopR1wRLEFHTfSJq+MPCYYWjj+LlgzoxsXolq8pCFG/0qf7OQVtBGQatq4Ic6lV9LV/rWnaSB8K6woNCo8vakh4ZCqSU4dq5qPgPDkDp9FBjv8iBtvcyoFHQPTDPvGB4xlJiec6jHTuFkdy5CfBGqe0AYzBRersoxP7i4HQIwwMlKs5OYp6aeVNrO0e/nIGY+6gZPHp0xGkdritZT1giJ3k0/Z9Z8HW6LmfArwqu5CPyxGMNDXNc/1o0p9J9P/F6MaBi7TebgqnFrs0mYOB/JK1LTLyFp+39YahuMoGd6YEPy15obu2wL8qNys/9DMcP8umDCTIbOcH1T30JIHiIGa0wsMONvpizc+1d2SjSdCvwcNKWjb/1TTEmXOAJvGFk1xOphEOpihJ/TO8oKv1KfIJDFOW3QRT17lE1mm3VaL2uxgtAYyC6JLAxGZ2M8I/kcYNXnmmnSZLA7e8evlqSf7QIYrF4yS1QILFzMyapr9XEX4+nibubtPZrRNY3V82sQG+nsV18zDWNgNH3gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(39840400004)(136003)(346002)(42606007)(366004)(396003)(376002)(33716001)(52116002)(6666004)(4326008)(44832011)(9686003)(6512007)(33656002)(83380400001)(66476007)(86362001)(38100700002)(508600001)(5660300002)(66556008)(8936002)(6506007)(6486002)(38350700002)(8676002)(2906002)(186003)(4744005)(6916009)(54906003)(66946007)(26005)(316002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Rv5++Q+65HCELKWCjfTM/wStuqB7snhvaw1O3gw5pwlzhcMONyXg/mRXZQl?=
 =?us-ascii?Q?Dr6FQYpz+ECe2BfOAPN/ng7ONOaNtPj7Q9951eYg9+sPyFdS1EXnL9Rp2Z4N?=
 =?us-ascii?Q?yLIZFSD42TJVO55AL3HRLVYJfOZX6fqc0JCo/lb6ZoZDm/KD4Q6valkE1GO7?=
 =?us-ascii?Q?zw32AMVOiQIYidVKHyo5CCuWlGzjevRZwFaDRqBN4PY3nNm7DvUmTOehych0?=
 =?us-ascii?Q?EiI1lCvOJOF9vqrx3srJnWRJo+GupxdkHk0COh3sMmTkE0EE2sHaAYqXrgsf?=
 =?us-ascii?Q?vigQDoLUd7Nxoc+ze3gtoeqmUthKzIiEC9HbaWay9a7hqLJ6eZ/4ek2SlfLu?=
 =?us-ascii?Q?wjKWjdARtJMXIM4C/njGTyR4nUvXAV0m8yqojHrPyednd4LkaIuZozUZUTzA?=
 =?us-ascii?Q?oNjnAMkjGiJ5XUQaCRFKggpIwWLUXHt/Fdfc8gy8cmfNmziZQ5ph08nsFz0U?=
 =?us-ascii?Q?gdwX3gsj452ny4rurqMsohxFuQDPt3YP/iBH04db1uwTgznleaiI8nzM5TJi?=
 =?us-ascii?Q?sanBvbWbHsLGZxV+nLiJazL24XoqHP8iuS31sAIh8Su7duIWyaDzOYRePv2Y?=
 =?us-ascii?Q?lkY80VhtT5k1aI1Xf69LbDZs3Ujz4to8URfRrqM1QU2cLspUp9dP4e4x3z5p?=
 =?us-ascii?Q?sAdSXqeTogbqgkfpVUNnx9QSpQOjjbvvAX2/7/or1/f5dAd1EpKOaervzuxN?=
 =?us-ascii?Q?b8BO3QEaZatFKsntehwCRgifn52qgnvlyXSX7HyfaIgUtAg4MltqY0V+Efud?=
 =?us-ascii?Q?7Knb/Y9fmZATI7Lt+4xwgVE0bkRNeLVr76sxNkTtaINHUqcapjjCkYspkv3P?=
 =?us-ascii?Q?0ecc1s29TAf17CY17zYre5X1DEf6RBclZrht+gLwQ8FLR7bWBZfamgi6CvWX?=
 =?us-ascii?Q?lZVdgYNML+2T6rlm3aBM55LPoexk7cndzj79mrxFgM61eRUcp4A8mTCGkpEb?=
 =?us-ascii?Q?Q5EBwyYenCDFIkTz2WrGyB+YxPq1vA4fdPJnC8GCtlcDfy4DT50aNQVxYsnM?=
 =?us-ascii?Q?aSI5wQlRJIhgtbIYObNrKnm6os8YZahZ9Af/o8jJa3IcVa+kf++7Jl6GyL4Q?=
 =?us-ascii?Q?SKsnmXRmJt6GwalVY4AekGDSdW///lryUkoDqjutGx9X4PZ1ZcyaSilLp37E?=
 =?us-ascii?Q?RwhEB88U5KjSb3ho9dwvn/ABwWPD2KIgQXxNMHJtHsGY6J5Prk41Zkojsft6?=
 =?us-ascii?Q?0++Rl1yf1ZZKlHmh6S2Ws2tdAIGZXjRHe/njdHD1wTdMLnsAHjRwI59ehCcJ?=
 =?us-ascii?Q?MQIm+AKDV4c73jIyznh8Tm5exKl5DJVPPcZiH/2ggfXZEKM9zguI8WxD/iCa?=
 =?us-ascii?Q?pviJh9eosswaHVawckctbZSifcq9NklxuqaqY1YlhinMmnpkwtZnZXcFQkos?=
 =?us-ascii?Q?6kR82vAE+Fkp4ZSpiS51Xemvjd5CNnUdL1YNGUJE+DSYZ1Tgf0swWE6GDfuW?=
 =?us-ascii?Q?ed3Ghf2KwR/DUgLfy0yV+ySGuePphShMiF1/07MVOZzFTdfvHbZUhM/4FHfy?=
 =?us-ascii?Q?AgsKfQVMaYNGro9YJLGTUxS667CS8WbQgLKmDa0pYnMDVGdl9YuIGQZrv5bC?=
 =?us-ascii?Q?99xwFosZlJJAIN3q8ODX60a5vUgXl+WD23nfiMCEceaNaE+OyhCQZMvzc1UV?=
 =?us-ascii?Q?GZ5EfG8oVz2Hcza8fbTiEiBgQMv9SlnoBCgF+Ocd5jlNOont5n31bjpw34Aj?=
 =?us-ascii?Q?WDe//3pShFCJb5mvsfbSw/q2oqM=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c0b06cc-3b5e-4146-19c6-08d9ecab003b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 15:35:44.8008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C2huxfnJJ+q1sAkeqer5Dbwk4QqH/eXys/wSH2NrQqh+pw2ML08tR7iXqRt62yie3yR+2QKcoGeJR0OFVG4s+f50A1COQWso70UnIhK9UWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3307
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 03:27:13PM +0000, Vladimir Oltean wrote:
> On Thu, Feb 10, 2022 at 07:21:03AM -0800, Colin Foster wrote:
> > > ocelot_check_stats_work() should also check for errors.
> > 
> > Another change I'm catching: I assume calling dev_err while holding a
> > mutex is frowned upon, so I'm moving this err check after the counter
> > copy / mutex unlock. I'll submit that fix after patch 1 gets merged into
> > net / mainline.
> 
> Where did you read that? Doing work that doesn't need to be under a lock
> while that work is held isn't preferable, of course, but what is special
> about dev_err?

I didn't read it anywhere, just a hunch about string formatting
overhead. Either way - not necessary to do inside of stats_lock, so I
moved it out. Next round will hopefully be early next week.
