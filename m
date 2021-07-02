Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A646B3BA451
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 21:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhGBTTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 15:19:32 -0400
Received: from mail-eopbgr70102.outbound.protection.outlook.com ([40.107.7.102]:61283
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229996AbhGBTTb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 15:19:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MAj76rrTOEGJQtmantgvWDDI++/9PwJznsy07tYxDDU8nP8uQmjLS0n/Xr2JplDpYHcWTmSd+omnRG1kFeCEbF7dmNSoPZxCFUgGgNh3F3pNP/7iuwmuMP0Nx2iBhwPvOWP5Z+VdGBPhKaDDpAbkcdti0fi23qEm1uCY0esCvXf1JUPQl5aLWYKMrd0szZmvqX8/rh0GPvGCq19d+TEanUbIQUYEaYD76QD+cDp6z3dj3NqCvcwo0lenmxVRhWDUncPTF7OWcpboFDQCf4+wrZu21i5Q/Ouk9EufkIe89cgcrjoOt5CR1nz5NRtoSVQINIKAL8BYk1NgL9aEp3bpPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWUqhOxcU0Y90zfw7DjsYT697BkKRZ7hOcHRkvfwkdc=;
 b=hLPiabkAdV0jqbyKvVjiYAnFW8E6c7YaRlrZoLbpgxf4pNiNT3K7nkf47n+5kChL2KB5iKFJpzilRzGTw5loUf0SxBTuKhveRzDfOerxz8QebndwYh3jIIr0fpG8x+HjcHE2BAysSXl3pIbJFpb/dtAp3ZkWZynRWDzaNsUwFFX/V6mh5TdEfFETzg0q9nuyzsII/o4eNt6/ymkQSII6PCa4XdjWeF2Hb85uh11+hqqGeIpNmpqO+KCDywDkUx026NU1nLeFGrg9tyCmbniC3kJ1TLRKv6EtGLqrrC6u7GrlCHsaTyQUFDWFOnmjF4d42s4zc7QVKZqWDwCjiUyjpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWUqhOxcU0Y90zfw7DjsYT697BkKRZ7hOcHRkvfwkdc=;
 b=iaH6/m7zqivHRmDI08HQ6MD4/dWgIbdlLxwETKcR/yIdrCjmpIYzjmM9FVc8zylWBZsirAaC+nVw3g0OWCYR2mQVItLyd1udgWmMxB5dM4sPu9lZkVVFevamSO1WojIukVKxoRIAUhE4JMsvBzt4b6PWbsVrRX9Nqro8LpIb5dE=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0331.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.27; Fri, 2 Jul 2021 19:16:56 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::40d:b065:3aa7:ac38]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::40d:b065:3aa7:ac38%5]) with mapi id 15.20.4264.032; Fri, 2 Jul 2021
 19:16:56 +0000
Date:   Fri, 2 Jul 2021 22:16:53 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [RFC net-next 0/4] Marvell Prestera add policer support
Message-ID: <20210702191653.GA23602@plvision.eu>
References: <20210702182915.1035-1-vadym.kochan@plvision.eu>
 <YN9ge12XzhZCdBNj@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN9ge12XzhZCdBNj@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P195CA0041.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::18) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P195CA0041.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Fri, 2 Jul 2021 19:16:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 808a760a-5c37-4da7-2be0-08d93d8df501
X-MS-TrafficTypeDiagnostic: HE1P190MB0331:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0331DDB5CA5B395BCF732CDD951F9@HE1P190MB0331.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ul2Dp23doC08Mpl2/ypncNEsDYdYOrc2B/MZMXGERR+IJR1ckaSyfn3kerx+Dp+2Nq3x/CMBZ2fUJxkHpThbXiZvYdev0b2oJV7ahTIGDqmbTqWufxMlfxwRcDmVHVSY8MRtbPz7IAp/8zMzpdetY+IL2urgR5bhCgxDYCK7AyccTNq6EDRXi3ub4Foa0Aq1AapMrguJpfrRbsjNa4zdb0PAOtwe9Iki8SmvC43vkgYYDOJW3KhpLfHBx0zasoXBGRX92nh8RTyZLRMAh7VD5YXq0zLt8e61oqLkmTsn/lOyE1rLQzno28yyMN78gQ7siMN+U8K1ttOWvGWGj0Gbgl27WXGQmn2gtrXKgvOrRXzTGKk8noKjE8L+bM3tmq+bm4dq971ken79rNakMi788WFwupbDIORL2lEt45+KAPWJNg6fb2lLj1Xlq7UgE2zGsJqzSPMX9/w3UAKrqzX3QVzAShpjq/MYV6qgEbQ4tC9XLCao0u/HhnY9sITkYmwn8Gj03TbqtffxLXp8VBEeb/WfjgNc976rJ6+w/g4GKA04s7J8+BaLDWRwRZ8k8Nyr976qWAFVoryuQddANbgrdfIfCGclxkChhvuF30jLN9maGbe5u8jFamOynMfIVjVkbs3H76Muer56rLVEwwLGLs50Qc09RHqlAay1NUco3T0AW+qLUfcYVTuKNw9prbbxZ6Ce2L+5qGNrdKoLaJbdmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(376002)(136003)(346002)(16526019)(2906002)(6916009)(316002)(83380400001)(86362001)(5660300002)(55016002)(33656002)(54906003)(66556008)(8886007)(7696005)(66476007)(956004)(66946007)(4326008)(2616005)(44832011)(8936002)(1076003)(26005)(8676002)(478600001)(7416002)(36756003)(38350700002)(38100700002)(52116002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nWsxotxxEbfr8AE0lp/mWc+BIykKu3bHm8aaV19xtpVsuAsBHITMc/YhEg5f?=
 =?us-ascii?Q?xz4ywywpCt7nDhSNQo59Donc+v6/g50Y4c+Tb0pMBvpspOjBSw/V7a4RHSKd?=
 =?us-ascii?Q?OIyAvyIHGB76l2VSk8AL97pFrM9B0gyIapedh5OcZhKbXTFx5ar1xCnCYh/H?=
 =?us-ascii?Q?LDhkjgkZd7+QztvV8eSIHv/iZrKdI5vYEOM/pH3YplU12WrobKF5bxBpC11T?=
 =?us-ascii?Q?d9XEnuC3lCfBGsrYhk/nn0f91aOHLMEAnq8sq/GO08OXx0tT32O3BREunTa2?=
 =?us-ascii?Q?BjfI3bAdBdEhDEO+P5TfWHWCSALNvrbfy5voaZODcVzL8sWBOWjauJGHyws9?=
 =?us-ascii?Q?fR8hw1Hh+2eX4UzifxFDnkbrFM+41WclU9dc4pvSeN6yqTXPMtmPcrLHC47I?=
 =?us-ascii?Q?4XSspOr13l6A+tZZaG5JWX9um3cM4cgvr/qm2Ptx1n/TuWVjmX47YpwCj590?=
 =?us-ascii?Q?fRzNXROJGaZbUIh6KA028Nrc3PiC6xucnVzqwcCeJBoAw6dXAF1rWp21ezo4?=
 =?us-ascii?Q?D/l0CSb90m/JILN4nhfFf9XVlCf75Kw0/G54LLC9q7Dk9bVr7z5uWVTRpEb8?=
 =?us-ascii?Q?ZEsXF1yDJ3LBcwhNXtZRW8j7+xNIC+VbQ7YsWVH7VHqVrbU5LgsGWxUEq8HW?=
 =?us-ascii?Q?h3MFii7gJiCN3xR+rF6C3Uyvu23qCfzUQn49UMVEG21Xkx0DbO+LRFGfV1PT?=
 =?us-ascii?Q?SlaK1TWKr8quUQon9+AS8Vihh+fE6ksb01azCpROVWhq1ZhwtabOqmpW7ctF?=
 =?us-ascii?Q?CAFltpwuLYkbhl3n3puU9vfSHnWkWDdjEVmttxZ5PcIummuPAiP2Z4HwyceP?=
 =?us-ascii?Q?9SMUwX+TlFTqr+WrS8Ek9iwYsrjtguV3Stmk0mj18a7EXrbbl55ZdmQgFHv/?=
 =?us-ascii?Q?tRgnB9xGKuUgzPozIJPrp5iddiyRR4n/+KXAMBW0/i851nuDui9be8hRN3Oi?=
 =?us-ascii?Q?Vy+hYHsD4bU9FGMTzPru41ENJS5ZJaOtFoaDum1iNhBdi5zwH20o5YbxDdtc?=
 =?us-ascii?Q?A51nQKt9Y5t0DXSx6CXvbOuFvpyy9l+sIRnp75kAajM10JwZMLQp3hnKZopl?=
 =?us-ascii?Q?TCrOu0fxf/+LrPKrpWE2zVOhIRBhtuTPhOB8q9Uvo4XAa10SkM3mGQSDloKJ?=
 =?us-ascii?Q?hClT29z3b6KZY/2kNpHJPkCPHScVi0PSv3FKMKMe8EdSHkzaFQgHGIUsrs0/?=
 =?us-ascii?Q?1J+EoSl6w/8c2vn+fT+oV2laTmJdCZVuY6klQf041/ZI0uAUsHOCwWgZ1VDL?=
 =?us-ascii?Q?J4/Y22SXJbdSm8FTMHHGbBEySn89ei76MewA2/G/YfIlE92c/ZtnbceqpaeH?=
 =?us-ascii?Q?/Lgnvl4SV3f0pGbe/WuV5EvM?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 808a760a-5c37-4da7-2be0-08d93d8df501
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 19:16:56.1002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hZ3po3dBvVnYipCl9q23dgHazES60WKuzE56ap+MCJ2PV7+xWs8+g4Eu8K2AptYCJgExbNUAFGWiugn9kPeX9KvGfp7EWLqQgQBxa1sGdYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0331
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Jul 02, 2021 at 08:52:43PM +0200, Andrew Lunn wrote:
> On Fri, Jul 02, 2021 at 09:29:11PM +0300, Vadym Kochan wrote:
> > From: Vadym Kochan <vkochan@marvell.com>
> > 
> > Offload action police when keyed to a flower classifier.
> > Only rate and burst is supported for now. The conform-exceed
> > drop is assumed as a default value.
> > 
> > Policer support requires FW 3.1 version. Because there are some FW ABI
> > differences in ACL rule messages between 3.0 and 3.1 so added separate
> > "_ext" struct version with separate HW helper.
> 
> This driver is less than a year old, and it is on its third ABI break?
> It is accumulating more and more cruft as you need to handle old and
> new messages. Maybe you should take a harder look into your crystal
> ball and try to figure out an ABI which you can use for 12 months or
> more? Or just directly address the hardware, and skip the firmware?
> 
>       Andrew

I thought (considering the latest discussion about latest FW PULL
REQUEST) it will be not a problem to update FW (and adapt the driver)
quite often during the initial feature bring-up (actually the older
supported FW code will be removed in the driver after some time). If it
is the problem, then probably it makes sense to first add new FW 4.x
with much more features and after add support of these features in the
driver step-by-step.
