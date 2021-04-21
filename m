Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4FE366E7E
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243681AbhDUOwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:52:10 -0400
Received: from mail-co1nam11on2059.outbound.protection.outlook.com ([40.107.220.59]:57024
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234550AbhDUOwJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 10:52:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ann57bPZoqe0sH/q3qSUG67qBZtgLVrHZuIxkyoMdctnEYsCetA6g/NPmi06Em37gUEgVlfwtbA//MW74MQmCTqojujuQ9GuYGncyM4JNMOGXzz/kS3+vMsI2rOshBQ0eCX0/pkLuLgqKPy1VjfPqUh7htUi2UFqvKVFhmDsBe9+bDaj1AIF5bTrEL6Ve/uv93tvjC5cOGKvJdDcEa3l5j36zBm/DUpfXh+iNjIYodgdrLn4TAijytKzZe4BQxqHSuJD6btLb4AhyerkP4oAjwoSagCYva3uP6sO0UmHftgBQfYs5yQtqTW7b6D4gEaqpehPAuevS7Mng0E+Esl1Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+11aCm1e3T6/R2EyORgdqBbNjlehDeHsJ14E4eXm1Sw=;
 b=lVTvwt9Iul3ad+79LKekCSL2qgtwym1Dy4hQwQflQ2MG5fD5FGZX46Fn2P4jQRd4A/4D3fuh5LSIJ58U8TONy9+z63uAgSy7uDhZKuhFKwTyhtJHKKmPS8lDW3xsQG68KpfCOZ+giI0RyW4UgtXzqqNQbS56Nq6MfN2E/AGx1GSKpblFI8nPTkBT2XaaL13H/qWjVYCBjoUMHuVsLZDVLsvRQbKHb2SMkeSgL9cTdGW5Sodow5EYKjcWCOUHscSIjF+K3cJplms0fITbyfdkkeJ0Wak/JzCBQU+MGudsIIj6G9MtDDMC5YFrxnl2HAFVLzO1nL6oQfdI2O6eNely6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+11aCm1e3T6/R2EyORgdqBbNjlehDeHsJ14E4eXm1Sw=;
 b=kicKopLknSm5WI2s/fkvGewDFFoN6FhDfUvI+mFtkzXH2nMy4/Z08o2mnQqlNCpbIGi1rtt5pVauK8lDKTCoDxBHHAhjpQFXTMvuT71dkRuznWGAb6+EE5LpFhrZiCGBXeEdtOrJEkAf4ur3JiptFyBV+s45buZmOU/niAfV9Eg=
Received: from DM6PR11MB3964.namprd11.prod.outlook.com (2603:10b6:5:19c::28)
 by DM5PR1101MB2121.namprd11.prod.outlook.com (2603:10b6:4:50::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Wed, 21 Apr
 2021 14:51:34 +0000
Received: from DM6PR11MB3964.namprd11.prod.outlook.com
 ([fe80::3156:d3e2:eb8e:d82d]) by DM6PR11MB3964.namprd11.prod.outlook.com
 ([fe80::3156:d3e2:eb8e:d82d%6]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 14:51:34 +0000
From:   "Xue, Ying" <Ying.Xue@windriver.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH RESEND][next] tipc: Fix fall-through warnings for Clang
Thread-Topic: [PATCH RESEND][next] tipc: Fix fall-through warnings for Clang
Thread-Index: AQHXEaFxo2BHz0QaeEKXUNd+t+OJ3aq/VSvA
Date:   Wed, 21 Apr 2021 14:51:33 +0000
Message-ID: <DM6PR11MB3964D94D53B98CBA9A25892484479@DM6PR11MB3964.namprd11.prod.outlook.com>
References: <20210305092504.GA140204@embeddedor>
In-Reply-To: <20210305092504.GA140204@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [147.11.252.42]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 372355a6-f2b8-42df-94d8-08d904d4f546
x-ms-traffictypediagnostic: DM5PR1101MB2121:
x-microsoft-antispam-prvs: <DM5PR1101MB21215349813CBAAEF3F0CC5084479@DM5PR1101MB2121.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rPkMIKsPC+8vCcguz/cwxl5FYr9j3tFej6Spk6JJ6LZgjP0ouf4YNzfAyH6j6lwGIAInWv+yul9tNSJHANn9/LMJ0fsJKJn9adPm+b1Gb5tI32ioLVem98wL2YRZegWRvpFn+4Wna4aYXPBtLxZex9ZPPcYVMY90QqOPUsCAglHyuJVIzUA9E44M0cMIFjLa9de9HwMIPhNs1wcDSAb9UrNauWHhH85eKaZodtXSDfCjMXF4cbnlviKWP4cXO+99EIkZVccWBlo1NriLrkKY7Z/FrYlTSe8jK7tywy86Hi+pZfSz2XnARrOUhFpzr6VBaMsQYNQYIO8jbukrK8sseArUXsyocURIBwiAS0Ko/sp4gOUFLLZPNA++cWrhsEahKYtdu2KLGuXJbX+7m5nzdSi5Mu5ITJVDMP+AE+q/QlSSxCp1q51fLrg6gsdBYLF93Mj2IDFZXXVEN6G9aFjxh8PuIXZy4RVja8UOtyBYVZKm0SGE85R9uytW5oeA1cnHKJPMYro8MCfr2UZUTYFKUB6NlgCdiCiM4RlkZBsmWps55Jey5Y5VnSoSSYTrV4ep+2UVOrAoCC5LMvRsmHSNDPeBMYm2drcaGAtepsqvSxhuJ359TUytPvPwRq5eFG1lQa7HbErBzeWXtMHOm9kLvJCIZJJ0SSxT7MbX01KDdU4PmBVw7vfjgksXXEoFYxTz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39830400003)(8676002)(64756008)(55016002)(478600001)(5660300002)(186003)(66476007)(2906002)(6506007)(66446008)(54906003)(33656002)(53546011)(316002)(66556008)(83380400001)(26005)(8936002)(66946007)(71200400001)(4326008)(122000001)(9686003)(7696005)(86362001)(966005)(110136005)(76116006)(52536014)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7rRmJRFFGBgwyeKOoxoKTbZ6oofm5w5M082OPWUyM0jQOo41Ah7C3BvAI6sD?=
 =?us-ascii?Q?MPpegZgX3i5pICQ2gJeGV9YoKX7tJPtFC/Hr/qQGpJ64taUMZesRNgowYdxM?=
 =?us-ascii?Q?e+IopjxkcH+yUH/1RMJP3vMyzOToRmIykooxPc+R8OzdOs0Yy92h10wKF9iC?=
 =?us-ascii?Q?Im9gX/wVHOZle6k9pc2zThddxBazJsjN8x2BNfyJ4EOcylNb369vmaVLXM+S?=
 =?us-ascii?Q?3XlLR1EaAvQuWCgsyQ3z3gPsJFgTCXCvfTOJFbzEyxlqr0+qawQomUrtxdQK?=
 =?us-ascii?Q?3rqwE9Q6E/9vtshDwk8dmdwdYD34GMzL+qZ1ICM0Xk7eoROpef1ZL/vC4QxJ?=
 =?us-ascii?Q?BPizhU5j9tZzML9hGEPqeBIDBKpOYR8cKRTBuogfnjoDtz+Y2Gll1rbC2w5S?=
 =?us-ascii?Q?Qjt8ChCntq0nJJpYQlHU1ti6tnAxZECdsaMliRfLQ4l8GhkW3Fo7NmrfiLSB?=
 =?us-ascii?Q?qVmeRn0f4RzVN85iG1NPHkeuJL6Nh53wdrGKRpe8JMIJuE0KlU1JdoQ+DdKu?=
 =?us-ascii?Q?RwhUBvJ/ZJneG1Lb8DY5KYhbJIHz2yCo3nD6OeXrL85Oon7n4vJfIkqGtlIy?=
 =?us-ascii?Q?xKOczKyKWigSyxweMn2+eovMAlMR/o+NGrap3nxyiStr6ssQL4wVRtnzEDSL?=
 =?us-ascii?Q?14MkwfqQv4d9eRUvYej+T+ZIYcoJWQ15GkYLOL4birCffad3opvCmH+2LBGm?=
 =?us-ascii?Q?AQsHE42LQO0jDwpJe0qyGvQDggm8dcQZz30s2mTmFU15jjT6qbmie3OoxRqw?=
 =?us-ascii?Q?O0qUoCaWaLlJtG1U8WimN2HctZbBL0Zz8DJwcrtwmcKx3Ilg/UD2ccB6leGQ?=
 =?us-ascii?Q?bKNO/+Z5oUcvEI0vb0GxZdMxQ/v5Kt+l01tYTxoDGBszTzbGJK2k94E1n7Fu?=
 =?us-ascii?Q?Z1CigvXqNPn6Yr6fnFasg95GK9jrHwkfYbBSgrcG9NkdcMvE1zOxuMARs4c9?=
 =?us-ascii?Q?5QKJON/K8RGS4TtTYE4KgGR+cjb2lx4mwV1QWiSVDetiP2KhQxu2T238nDS1?=
 =?us-ascii?Q?JaHJ8Ca4zWJ6xZRu9PXmAoG5zWtM/SVSqryScFT7vNYmSjKD5FI9UQx8BH+d?=
 =?us-ascii?Q?X3FHrr2CNY2h+Souxo2J0/i08ZvERqzxHsUeqMRWLd9fqOzsEmj0euV2e5PT?=
 =?us-ascii?Q?x2NsI96X8iyOQH3VOz12kouH89oWAtYDVNCBP9Lz+334CNw2HNCxR7fbF1+q?=
 =?us-ascii?Q?WWjrxewjPqaWB2/G3nBjOm54/PouXyXJqs3MyeHm9bv2wSlOD4TUKBtaF83C?=
 =?us-ascii?Q?QOEYcQKD+F262Apx+G3NPpyrwxAyvf5Yh48Bhvw/L2D6WpLexdHZtTtEutF4?=
 =?us-ascii?Q?dDkcURZlNVhHTTjCNW8OACRF?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 372355a6-f2b8-42df-94d8-08d904d4f546
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 14:51:34.3467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QwPKEaSC9ZdmLHqGHzkWlovsl0Xq72UDKlpxwdWmAugjPbQoZwWL4rJF/1SUjef1JqwrILBmtuRHdElCEB8HDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch looks good to me.

-----Original Message-----
From: Gustavo A. R. Silva <gustavoars@kernel.org>=20
Sent: Friday, March 5, 2021 5:25 PM
To: Jon Maloy <jmaloy@redhat.com>; Xue, Ying <Ying.Xue@windriver.com>; Davi=
d S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org; tipc-discussion@lists.sourceforge.net; linux-ke=
rnel@vger.kernel.org; Gustavo A. R. Silva <gustavoars@kernel.org>; linux-ha=
rdening@vger.kernel.org
Subject: [PATCH RESEND][next] tipc: Fix fall-through warnings for Clang

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning by=
 explicitly adding a break statement instead of letting the code fall throu=
gh to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/tipc/link.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/link.c b/net/tipc/link.c index 115109259430..bcc426e1=
6725 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -649,6 +649,7 @@ int tipc_link_fsm_evt(struct tipc_link *l, int evt)
 			break;
 		case LINK_FAILOVER_BEGIN_EVT:
 			l->state =3D LINK_FAILINGOVER;
+			break;
 		case LINK_FAILURE_EVT:
 		case LINK_RESET_EVT:
 		case LINK_ESTABLISH_EVT:
--
2.27.0

