Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE58439550F
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 07:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhEaF2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 01:28:20 -0400
Received: from mail-eopbgr1310124.outbound.protection.outlook.com ([40.107.131.124]:51803
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229730AbhEaF2S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 01:28:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uyy7J9rOHczUjUSVmr6U6VuIj4i1sH+Uh5VJ0JTkC1PAN8oi0dP+LAQIxyMeki0EIWC3+OFp6OS8JynPM1O+g1ek6oiaybGPgRvmfGWP34oN6pIg8hJRpnRjN74hHQL4a65S2UvSCVUrsf4/rgSJVNrzT+P+c4vyUV4CTXY3oQVtfx+4aBkChhfBbeMLISkHS2byXsPPLISHlIQpMH9lxzIx1uhQM4XHEN59idQC1QtKZN+XXBf02jjaukkCtUBNHDiZx9UpGE/a9VeqaH/FbAos1w6XS9VmGAp4BiRgMKKYbtQcNm+rdfppQAZmqu9W/+CyrYnZj6g5QpE6qjhdVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RBNrwz/0avJ0EXO54jVrCGsu7oQ2qKPsNaPtFlGn9A=;
 b=Ceze7Rzevz9XyKCwJnvXBZkaGPg6EAac1jd55DhHTn/RvSrdpaUR6Q33l1RvWmIgqzGBmUVTlh+BdtNuFvtGUrMLARwp/g12bsJbEwSrEI43MlunZqfvp6ThGCIXBpEiNSRfb/jLD8efgxp5w8oiXZYoIBhNw1TyFjzMqoVC0MSLfHD+999hTWF4BwtuGnHS7vFO+zdp4NLTgnGP7xSpqAwwaW06LCgGlm3/LbAYG686G9dBjL+v/LwOekxiMR4KvhKFNvfVuxNm2Jj+UtOIC7U+y/Pm1umxmaPoSZ9mp45aOLczlMuLvTpeRxmI6h5nj3rECtP8QET9FD2BHQtx5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zenithal.me; dmarc=pass action=none header.from=zenithal.me;
 dkim=pass header.d=zenithal.me; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenithal.me;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RBNrwz/0avJ0EXO54jVrCGsu7oQ2qKPsNaPtFlGn9A=;
 b=Szce4WaOiUyN9Rk1n0xpN2WR5vjBwJKNO9IvQWQdAbCrSYHIuzmMnm51AT5lizD67Xwsd9wNclKvD+dzQZ6fEBh9CVw/rajZW9MyW1pgTiUYSuXYwrBcdbb1X3h01gdqxwmitt4nRCVpR0BF2Z3AQksM/Q5ekLQJYTEd1usENnw=
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=zenithal.me;
Received: from HK0PR03MB3795.apcprd03.prod.outlook.com (2603:1096:203:3c::10)
 by HK2PR0302MB2452.apcprd03.prod.outlook.com (2603:1096:202:11::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Mon, 31 May
 2021 05:26:34 +0000
Received: from HK0PR03MB3795.apcprd03.prod.outlook.com
 ([fe80::9487:d6b3:c884:b85f]) by HK0PR03MB3795.apcprd03.prod.outlook.com
 ([fe80::9487:d6b3:c884:b85f%3]) with mapi id 15.20.4195.017; Mon, 31 May 2021
 05:26:34 +0000
Date:   Mon, 31 May 2021 13:26:23 +0800
From:   Hongren Zheng <i@zenithal.me>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [RFC] add extack errors for iptoken
Message-ID: <YLRzf6Iuv7Tg/F3o@Sun>
References: <YF80x4bBaXpS4s/W@Sun>
 <20210331204902.78d87b40@hermes.local>
 <YIlbLP5PpaKrE0P2@Sun>
 <YLHf3ETTHj6uaY9Y@Sun>
 <20210530194234.2fd8b269@hermes.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210530194234.2fd8b269@hermes.local>
X-Operating-System: Linux Sun 5.10.41-1-lts 
X-Mailer: Mutt 2.0.7 (481f3800) (2021-05-04)
X-Originating-IP: [2402:f000:6:6009::11]
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To HK0PR03MB3795.apcprd03.prod.outlook.com
 (2603:1096:203:3c::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2402:f000:6:6009::11) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.10 via Frontend Transport; Mon, 31 May 2021 05:26:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0210b9e2-41dd-4420-e2d2-08d923f4a747
X-MS-TrafficTypeDiagnostic: HK2PR0302MB2452:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK2PR0302MB2452CD93C7B5D6674A3A84CABC3F9@HK2PR0302MB2452.apcprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8yGg7idmQRHvnzofWguAa6PmJPQOyCRvH0bAawWpnBnsGd+0T0OoMxvSxheEZp38eukaVbxt1qnOugxPP3Fjo80DsAyvOl0B20biqqfhmvWVHfMnG8kXkg/EXkQVdElFiqaRUnc9WHDhTyWuuPaw+jJFAXFHvwtwhnHL1AfMZYRzQeCLRoWm3Bf5iS1d53a7lCFQ0lv+niw+qZsCRYzI0/+myDznK+ATRCz156Veh2343w7nPKR1S4qJwk1In8JhXSEqo/paEiqcflSnA1hzCo3JarCSzC1dw+ZmOO6FjPCAzfHJ9tHtndUo51+HfxT+P89syfu8OIzgBRX0Cs9plXv17fu9JBsfkaQowp4TCEQxWKxZQlyPfm/w0Z4pth2XW2fAMnb1Un9vSXxnLYjKtpOESD5KYZWvhJaQnFlJSUAs5bYUL2Hj4LT5OlKzYQL8fl1E1WxTBIhtNBv8FEUnm4XPn+akdgNTWIYxdFy4GaXp+2iRTc4eZxU0NDGJglcRKVS+w6Y+WpICbfW/uF0pvp2GxZ5TwzNe7Gh1kMcHpKzMU684lfB59oepcN20RUe0hqNk6aGg+DY9l/EKYtqPJSHzLRtGObixGUXCyEh5n7MxYgBFRzCtYjZs/JVE9vyakaNEGX1nYfNtSOoHWeRm1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR03MB3795.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(136003)(396003)(376002)(39830400003)(346002)(366004)(2906002)(66946007)(16526019)(5660300002)(8676002)(6486002)(66476007)(66556008)(6496006)(52116002)(38100700002)(8936002)(478600001)(33716001)(786003)(316002)(6916009)(9686003)(86362001)(54906003)(6666004)(186003)(83380400001)(4326008)(49092004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6EK2ipqjhChmHrfU0tWm8rv1TTRdQ85UWaQ+vu80byCPsZkaFSx4FEgF24wo?=
 =?us-ascii?Q?OyGp5GE9ur9AA/0TdZhqRRvLC5RQia52a253/8AX7bEs2Wn7OEGvOCnExkBi?=
 =?us-ascii?Q?xZue4dWx6u6JxBksBy7sqlvtqfkvUtRquK8HNwy1e9Bl4Ck0F7rnoR7dESo7?=
 =?us-ascii?Q?70FX9KB8YuiZ8Ur7gbgkPWSJkyKMfbMWkdaC7MMt6uux5+1BUTlHCCJt3MqW?=
 =?us-ascii?Q?pVA7LO3ibYJKFuJFfT7doQ29PC3+ZKQ1GbO8cGar2HOcbaee2nusHCgr53Os?=
 =?us-ascii?Q?JHF9ocOgMI39QqjuqYXAOTGzGqbcw2ti5kLwLqEMwPHaHihs/ndJIpNgB0zx?=
 =?us-ascii?Q?pDUQhi/4C2hiAlEoM36Wdp8f6usmPX+ICJbilq+GIn5h18KPHPyrDR+j+hnF?=
 =?us-ascii?Q?7F7M51qHZ6BFf00tebkPBWAL5e0NIr75jgHi6SC3EDfluS6nLGtMVKkAOAGp?=
 =?us-ascii?Q?2jdHmtawsEqyrXvDBbaYWYQYITXdQX2iA1c5tDhBU8CYhtYklytPiHdLGJHA?=
 =?us-ascii?Q?JigX4AS1F6HpH8Db/UnV7cQqvMo7TLXM59FLfkpg4kyXBy1Ko+0jMCRYHH6W?=
 =?us-ascii?Q?A4gTY+PHBqA8b+Y6saZ8tquADWxNhu+qofQwfzgwXAkzmZNLghRnZnnTDHGW?=
 =?us-ascii?Q?3oxbf0GbmCMDrjx6jApkelzaEaSUowOEa/G0kdLJSQagGKYsPXr+paeX7xDq?=
 =?us-ascii?Q?1AJmFt0hqnhX0vT5z1scJ2OtgekxMv2PW4UGrSdtH39Wx1rjk/QKl1J/awZ6?=
 =?us-ascii?Q?PZFuXPfFAMFfdOMvbuJScAaV1QI0SjfxlNtFrPpukJ59BKd9qaML/hLUjv1y?=
 =?us-ascii?Q?sdsoviuqGYbFwgbIsHOJAPussXRv1xcAkvPxUsOIXAuAkDjBKJGoHY0n6+hZ?=
 =?us-ascii?Q?aWG1E/h0yyo6e7gi/rQ/gsOrEIE4+GdAeM67d5svIzYF1cd58vrBTtcqoSdO?=
 =?us-ascii?Q?srNRDAi9NX1oW0JgSxAynEM2hXC6GZRDuximjJxG/1uy0yIh9OprWrhfkoHJ?=
 =?us-ascii?Q?C15FhqxnkSgdhvRWg3wC2AlMUrgf5gDH6GoeKV2tdnru7ADk6nVL1Xm/qbwo?=
 =?us-ascii?Q?swAy6b7PQUnjw7gEBZw3Txbpdyt99YHbjB5phLJ5kR+Y35dKsMZKONc9RM74?=
 =?us-ascii?Q?0RI4D4wcVuIvx7fxkBJtx0sLOR4720Sv42QHPkD8E/jI5RmTcsa9g+l5ObMB?=
 =?us-ascii?Q?wiWVQJeoZJD91K3PtTsH589CC8zslpdhdlwvfUNPDom0r4dU2OkzUSv4SHD2?=
 =?us-ascii?Q?XZSU659JCc4TuXvZpO+xcgXp5Pg9N5N3MPXFVo+oxgGiG6R78BN+v2qjIJ4S?=
 =?us-ascii?Q?BJ8LLHIbJZjLIVtFmv9atizvWMyGG3pxTx30wzHV3WFJdw=3D=3D?=
X-OriginatorOrg: zenithal.me
X-MS-Exchange-CrossTenant-Network-Message-Id: 0210b9e2-41dd-4420-e2d2-08d923f4a747
X-MS-Exchange-CrossTenant-AuthSource: HK0PR03MB3795.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 05:26:33.9451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 436d481c-43b1-4418-8d7f-84c1e4887cf0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CHKQJ2TtUmINee32s35ObUzJPBq2l2GPtBlOvk7UPpjBCTvWy6FVGcyPrK5OVKeH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR0302MB2452
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 30, 2021 at 07:42:34PM -0700, Stephen Hemminger wrote:
> On Sat, 29 May 2021 14:31:56 +0800
> Hongren Zheng <i@zenithal.me> wrote:
> 
> > On Wed, Apr 28, 2021 at 08:55:08PM +0800, Hongren Zheng wrote:
> > > > Perhaps the following (NOT TESTED) kernel patch will show you how such error messages
> > > > could be added.  
> > > 
> > > Since this patch has been tested, and we have waited a long time for
> > > comments and there is no further response, I wonder if it is the time
> > > to submit this patch to the kernel.  
> > 
> > Is there any updates?
> > 
> > I'm not quite familiar with "RFC" procedure. Should I send this patch to
> > netdev mailing list with title "[PATCH] add extack errors for iptoken" now
> > (I suppose not), or wait for Stephen Hemminger sending it, or wait for
> > more comments?
> > 
> 
> The kernel changes is already upstream with this commit for 5.12 kernel
> 
> commit 3583a4e8d77d44697a21437227dd53fc6e7b2cb5
> Author: Stephen Hemminger <stephen@networkplumber.org>
> Date:   Wed Apr 7 08:59:12 2021 -0700
> 
>     ipv6: report errors for iftoken via netlink extack
>     
>     Setting iftoken can fail for several different reasons but there
>     and there was no report to user as to the cause. Add netlink
>     extended errors to the processing of the request.
>     
>     This requires adding additional argument through rtnl_af_ops
>     set_link_af callback.
>     
>     Reported-by: Hongren Zheng <li@zenithal.me>

No wonder I did not receive this email and kept pinging in this thread.

My email address is i@zenithal.me, not li@zenithal.me

Still thank you for getting this upstreamed!

>     Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
>     Reviewed-by: David Ahern <dsahern@kernel.org>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
