Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563F111FD79
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 05:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLPEI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 23:08:26 -0500
Received: from esa18.fujitsucc.c3s2.iphmx.com ([216.71.158.38]:56274 "EHLO
        esa18.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726682AbfLPEI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 23:08:26 -0500
IronPort-SDR: GIXlMhe2733KgcrbtkZDtDLqVAva31E6o7daohjNhgI0l8OpZfOYOXwAewPHTOywBKxG0KB+q/
 o+RFWJf7QMlSlD7ouP5AJ90eV3mbTSN5TwhuPjP2oQe99oYbbrM5TUQMckXlYtUXdNwvmWJXbI
 EvbE6far5cmMLwujm1e335MvWjjNdH+YuAg96Je9ll5ktYEsgM0QLGuQPw0NpSj4EbX3nnBLLz
 OEaWMfa6r+ln/L1l3oTfIH5DAVHWe3ucXGeUW4PMeyAYzU2l4Gn6P3gwOvUlsw07y4ah11NKbi
 /Go=
X-IronPort-AV: E=McAfee;i="6000,8403,9472"; a="8557731"
X-IronPort-AV: E=Sophos;i="5.69,320,1571670000"; 
   d="scan'208";a="8557731"
Received: from mail-os2jpn01lp2053.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.53])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 13:01:15 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HC2Mj++TbBdD8aiOrhf6S171AQwfQGFMS/WK/k4KRhN3Gq8Nmc5Hy4psVP/MZgWeEJ5mw22wiyly8VOS7/i3nj0J2IbhLRYTMFx6pC6P34tl8K7o2EFS6ZF663yFtxbTCxvQyULXwB5mw1fgr0W/sKXAR5DxGdh2OCTr19czQajbpO9RTAnTOYPiipLNGPWyErQUUh5SosKNUeraJMoH+TG6r8Ir+FZpUYI0s5MNtOYzZNDlOmjMTZ92XnoF55PUPJqMWC8mJpCOUO1aLM/j7LXGscJl5MBFH668fRQIjYehglU5qrylfTheubwcSFQrhemdJUidftt/PaXHyc5S+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mOcFFh/AGSEzM3rd0CK0jY9/7aObZiz/M8ndldu73A=;
 b=GcK3SfHHfD/Njkxv2bUDxNrFr/U/4W3p0kLcnFrCgfvv3gi28/FUqb+nxZ9lnhCTvPonsuh5rQ0gOf4de85G0BccsgXS8xRfDv3/twq581srKvuvQsvmnJ/X6wqlVuhkG0BrhIQdf3osKf1vkWMmV7s+53ow6ClpzcOfIQCdudNh5X1Hrmmym5NcdY5gDluzkyJxATFs+PqmrWjqCtNiS59oI893hCC+FpWn1ZTT/GFidgaE4xEjX/UNkQ5SGF3kP26ygaeuTEuvMrqceVuGQ8hLVw16zpmMPifyjHt1+ZJz7hLDi6FpdIcYymFn6V0bwaTZD4gcQ3x07Gvx1W/UeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mOcFFh/AGSEzM3rd0CK0jY9/7aObZiz/M8ndldu73A=;
 b=L05jA6JH/wsBhtWMkfFVhmhj0Ngjm3amSGEv3iOiwKN8kL9usJXSUJiRxE93dZ9EYZ/8Z1YLLSOhUW2V4sw7OMskD0nwQ+3KUy4htvhNOelqvilLIl1LIMLY0AWsJH3c2nb+26YVVl8DjWFhNuDO2Ex1d5ZWuHUs9sMZ8TO/B1U=
Received: from OSBPR01MB3784.jpnprd01.prod.outlook.com (20.178.97.203) by
 OSBPR01MB2696.jpnprd01.prod.outlook.com (52.134.255.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 04:01:12 +0000
Received: from OSBPR01MB3784.jpnprd01.prod.outlook.com
 ([fe80::bc41:1f80:22a5:2779]) by OSBPR01MB3784.jpnprd01.prod.outlook.com
 ([fe80::bc41:1f80:22a5:2779%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 04:01:12 +0000
From:   "mizuta.takeshi@fujitsu.com" <mizuta.takeshi@fujitsu.com>
To:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'davem@davemloft.net'" <davem@davemloft.net>
CC:     "mizuta.takeshi@fujitsu.com" <mizuta.takeshi@fujitsu.com>
Subject: [PATCH iproute2 v5 2/2] ip-link: Add white space to "xstats" display
 result
Thread-Topic: [PATCH iproute2 v5 2/2] ip-link: Add white space to "xstats"
 display result
Thread-Index: AdWzvDtzRMSyxMt2SLeVHAV81kaMLA==
Date:   Mon, 16 Dec 2019 04:01:12 +0000
Message-ID: <OSBPR01MB3784E1EE94AB7FDC7D381C7D8E510@OSBPR01MB3784.jpnprd01.prod.outlook.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mizuta.takeshi@fujitsu.com; 
x-originating-ip: [210.170.118.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf882d70-07c4-4086-739e-08d781dc9760
x-ms-traffictypediagnostic: OSBPR01MB2696:|OSBPR01MB2696:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB26964F9155D7EE96A21371D08E510@OSBPR01MB2696.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(199004)(189003)(71200400001)(4326008)(33656002)(66946007)(5660300002)(186003)(316002)(66476007)(66556008)(8936002)(52536014)(66446008)(64756008)(55016002)(9686003)(8676002)(81166006)(76116006)(81156014)(7696005)(6506007)(85182001)(110136005)(86362001)(26005)(107886003)(2906002)(478600001)(777600001)(491001);DIR:OUT;SFP:1101;SCL:1;SRVR:OSBPR01MB2696;H:OSBPR01MB3784.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Br2poTxd1xVWWrx2vuCGxq7oU+2fDbuuGfEjxNCqvPp+xpY2lO3clpO4mAXert6SQAekLqaFxF2ZIYjgJXJoqEGG+RXA/XUk/ptnLg6uWJjhzlsFmCaYuKCoWjcmhFq9AoaWjLupxhwaaULEk6tJ3Mai0l7+NkuJhCJQoDXROUBR86hCAAi8fLbaW8tqKz916TQu3WcPW5TSmGJX2T3YGf45G0I9fCODHmaCeLyngRDNpalnpmFiJkIvQSmJLtwAjw/qvr3DiQjBiLKN78zf8v6HyHOH1SelG9c0ZtSIn91oNIlZDetVHkxovfpHKsUZbYEipfzoWAE2StiwqaNjwgS9gB0eEgHuVXRbXH3KWY5wqV5g+EAzoPBAp38XXxIqVkf4cw8fenegN79al2XOGdg3jWkl1N77JaERIi9c2rkUfrKSTl8Gp4cjVR29x/YgJyCRDQf5UnFxO9TVJEEOOtsk6QTRTnffnUUOBKEP0Fp3hjTDIIXRjng6tI+LH53S
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf882d70-07c4-4086-739e-08d781dc9760
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 04:01:12.7973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a+Lfx8GE7f0C/E5Fd5gM0Qgke56MpIm56AbGLYKFxx89ePM2iAcd7txDqnXr2SrNbQc4RT1MhUZZ9DfccW2tyHswzy7bWKSmMNt7oVZlGi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2696
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running "ip link xstats type bridge" shows the result of truncating white s=
pace.

  $ ip link xstats type bridge
  <snip>
                      IGMP reports:
                        RX: v1 0 v2 0 v3 0
                        TX: v1 0 v2 0v3 0

iproute2 v4 prints one line at a time, but iproute2 v5 prints one line at m=
ultiple times.
It seems that the white space in IGMP TX: was lost during this change.

Signed-off-by: MIZUTA Takeshi <mizuta.takeshi@fujitsu.com>
---
 ip/iplink_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index 06f736d..868ea6e 100644
--- a/ip/iplink_bridge.c
+++ b/ip/iplink_bridge.c
@@ -742,7 +742,7 @@ static void bridge_print_stats_attr(struct rtattr *attr=
, int ifindex)
                        print_string(PRINT_FP, NULL, "%-16s      ", "");
                        print_u64(PRINT_ANY, "tx_v1", "TX: v1 %llu ",
                                  mstats->igmp_v1reports[BR_MCAST_DIR_TX]);
-                       print_u64(PRINT_ANY, "tx_v2", "v2 %llu",
+                       print_u64(PRINT_ANY, "tx_v2", "v2 %llu ",
                                  mstats->igmp_v2reports[BR_MCAST_DIR_TX]);
                        print_u64(PRINT_ANY, "tx_v3", "v3 %llu\n",
                                  mstats->igmp_v3reports[BR_MCAST_DIR_TX]);
--
2.24.0
