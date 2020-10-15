Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32BE28F97E
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391645AbgJOTbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:31:01 -0400
Received: from mail-eopbgr1410119.outbound.protection.outlook.com ([40.107.141.119]:57379
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391629AbgJOTaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 15:30:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QuuJUs7XQL3E1aaiIe4ZFeZi4Nx3f1Ql0JRlp2b2KmLXnleFDMvgytS7xwEadsYmZ0E8LYsF6FdC1c+hO8n6NsSIkdUSQGFEIpX0pccQ18dBwCmyhkjcXelVRpUCM0PG1sJ3CvFBwUqsfNeCrneVT5+I9jpuxVGC18Mgt/I7rYw05uD6/jvAU+eP4uMz61fLc1tdCOEv1LDavf0JcE3T092KfVTphsSB3KdA9fVVlcM39ZGoFNJsjv6hnyGFO5ZpQmysgH9zmuqVw1OCMHdTkSh2A9+3iXwWxeL0OR0qzh0zqLH4tYm2ixNgDtKlrlTXpWe/AsNu/4in+AHfA/VVMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcNt0iaZSqX65/tfimjHAI8Stkofiq/n71E8Ns92TmU=;
 b=TDbCx0c4NLmrFUWdHGVvu/BIxpHgmpaxHOtcsfCG4+pIBw6Fts6lfG6fQZenvw1GDUByjX1b+ONJCgqBC1hbehdwJo3gv8oOq5pz9UBRL3jsE6JPXpqkGIKzXyWzNuK6Xj9o58gxAg6ll9Zh42JXhtanTyh3ubMsiL4bTsrpABJE0ILidch1CLJi/ooN5bBY6X825xfy3S6LycuBN3r3rxXzGdneB6e8vuzW8iM8ZBKmM0e6p4dPCHeIbuVuk6f/h4vQ1gGowD7vQ4vz2LQUDOAzHXCDip3nOnoB7PSnLYQsus2baLknTOqjipEnZaWHh3oGbFSvk/VnJVIqdx8i1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcNt0iaZSqX65/tfimjHAI8Stkofiq/n71E8Ns92TmU=;
 b=oVQEZfQONVmxoA9bbKKCaAYEScfPSqdMqFGX7gVWsmmHIixaFoVaJ7W4LvfZedX/qiiBW1+irKOSrBrHPiRmEDkKcJ2uE/LNyOZ+HHDKCVvN5kimABfSPge7ttzk7slNPwFYzMSTBen6WXmnQW7o1O6Dg3sYcCWhapDbyyx5Ahs=
Received: from OSAPR01MB1780.jpnprd01.prod.outlook.com (2603:1096:603:32::12)
 by OSBPR01MB2583.jpnprd01.prod.outlook.com (2603:1096:604:17::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Thu, 15 Oct
 2020 19:30:52 +0000
Received: from OSAPR01MB1780.jpnprd01.prod.outlook.com
 ([fe80::b1fd:3bf0:af0d:56ae]) by OSAPR01MB1780.jpnprd01.prod.outlook.com
 ([fe80::b1fd:3bf0:af0d:56ae%4]) with mapi id 15.20.3477.021; Thu, 15 Oct 2020
 19:30:51 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Min Li <min.li.xe@renesas.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 3/4] ptp: ptp_idt82p33: use do_aux_work for delay work
Thread-Topic: [PATCH net 3/4] ptp: ptp_idt82p33: use do_aux_work for delay
 work
Thread-Index: AQHWbNOYY6MaRrcEtUGauhEGkbdWIqmZebYg
Date:   Thu, 15 Oct 2020 19:30:51 +0000
Message-ID: <OSAPR01MB1780713D7A363ADDB13C59DBBA020@OSAPR01MB1780.jpnprd01.prod.outlook.com>
References: <1596815885-11094-1-git-send-email-min.li.xe@renesas.com>
In-Reply-To: <1596815885-11094-1-git-send-email-min.li.xe@renesas.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: renesas.com; dkim=none (message not signed)
 header.d=none;renesas.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [173.195.53.163]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2b46f421-3601-4eb3-805c-08d87140d3e4
x-ms-traffictypediagnostic: OSBPR01MB2583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB2583EF9EF3813EEE36ED62A1BA020@OSBPR01MB2583.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: //I04DaBN+L74TAtSg5+7l3mSWNDSAp0b8OyzOs3B4EsqYsrjeinGjMGl54QWwiiVXh0ibezhWhJ1CFb2w/0OitUjK+YDPMijppM2xLGqlOTY1qKxWTp8FEsiaLflTOl5+w+WW5bdM+1FFWoIX01VCyvymtDlfJzd7eRqC1lT7pJ8svNhvU+p82WuTc+sQFXIaK3Ii5yx0s0cwvZEtsQqu5RJRcEDxfXRToCpzJxeObjpQ1Ors6lLyqIpLrk0yCoG9QE9EuKex1l6/rnUS7A2LQchjzP5j+hh57eV+qasNbdaw9hx9uAqg33mr8CRAvy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB1780.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(8936002)(7696005)(186003)(8676002)(55016002)(2906002)(9686003)(54906003)(66946007)(5660300002)(76116006)(316002)(110136005)(26005)(86362001)(64756008)(66476007)(66446008)(66556008)(6506007)(52536014)(53546011)(83380400001)(71200400001)(33656002)(4326008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: P51hq2C7aswZGX+S4iDvxuA3sumluHxV42ERa4Lp8Y+sbwLAGyOPUl0BdiD5rTxZRCYGwv1X0Fa5UVJBJZdeApCn5NqSVeJRNV+ibUqXN5F+sJFi6YzjC5a8BhwHOiF/Bjc/Pj06pZRGWFIINYlr6UGbds8HDYiWx6QBjsepNwKr1zXFzpa7NjLJNai+khNVSc3ID9HZm4doEKgvEiVHBuS4f1r1s4exUuV4yJi0pPr3mf6e1hIDmdCITYJDO56tt118AogY5/UlFDhG6DKlE38ujfwoB/xw9ZKECOhDfQLhozUB5P+ODzMwlQscMBs2/VkwjPgYjtayofhE6/gSojOLr/UrcdWAjMChBlxGAVif4H4QBefBkUm0EnueFlDIt3hlK4zDn5rep1zrO/bBsd+Xs4rG4rQfTd6YJbTSjTXnWeF1Z+5IPou8KKPVl42iKjU+dGhAaVIWI420uGokYmN+pVTe/IuS1nsvuKGkk4l3ThrSBAet2vDc4xsQ53utQ+WKEAREBSPE/syDnO74FlJYmAXrIR33NlpB2XAYrR2XDCld5TkXGVUIvo8BAMMUaNzKaN0QUpdBbBNPhLo/aa4Fgf3RLmct6UwWpGb1ZJU2/ROemcQ+5Ty6BPW8PnnIzgduAX2oKwJSXCh+3YpqJA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB1780.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b46f421-3601-4eb3-805c-08d87140d3e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 19:30:51.8709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p34Fgb4lu8tomDPwNv1gjkk9VBV1ODlRmfUQzPL6TL17XUgUL7L6ZlYZlvMB8dTc/H1Y3jv5EF0AhZY25axj0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2583
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David/Richard

When you have time, can you take a look at this change? Thanks

Min

-----Original Message-----
From: min.li.xe@renesas.com <min.li.xe@renesas.com>=20
Sent: August 7, 2020 11:58 AM
To: richardcochran@gmail.com
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Min Li <min.li.xe=
@renesas.com>
Subject: [PATCH net 3/4] ptp: ptp_idt82p33: use do_aux_work for delay work

From: Min Li <min.li.xe@renesas.com>

Instead of declaring its own delay_work, use ptp_clock provided do_aux_work=
 to configure sync_tod.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c | 24 ++++++++++++------------  drivers/ptp/ptp_=
idt82p33.h |  2 --
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c index =
189bb81..2d62aed 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -531,8 +531,8 @@ static int idt82p33_sync_tod(struct idt82p33_channel *c=
hannel, bool enable)
=20
 	if (enable =3D=3D channel->sync_tod_on) {
 		if (enable && sync_tod_timeout) {
-			mod_delayed_work(system_wq, &channel->sync_tod_work,
-					 sync_tod_timeout * HZ);
+			ptp_schedule_worker(channel->ptp_clock,
+					    sync_tod_timeout * HZ);
 		}
 		return 0;
 	}
@@ -555,24 +555,27 @@ static int idt82p33_sync_tod(struct idt82p33_channel =
*channel, bool enable)
 	channel->sync_tod_on =3D enable;
=20
 	if (enable && sync_tod_timeout) {
-		mod_delayed_work(system_wq, &channel->sync_tod_work,
-				 sync_tod_timeout * HZ);
+		ptp_schedule_worker(channel->ptp_clock,
+				    sync_tod_timeout * HZ);
 	}
=20
 	return 0;
 }
=20
-static void idt82p33_sync_tod_work_handler(struct work_struct *work)
+static long idt82p33_sync_tod_work_handler(struct ptp_clock_info *ptp)
 {
 	struct idt82p33_channel *channel =3D
-		container_of(work, struct idt82p33_channel, sync_tod_work.work);
+			container_of(ptp, struct idt82p33_channel, caps);
 	struct idt82p33 *idt82p33 =3D channel->idt82p33;
+	int ret;
=20
 	mutex_lock(&idt82p33->reg_lock);
=20
-	(void)idt82p33_sync_tod(channel, false);
+	ret =3D idt82p33_sync_tod(channel, false);
=20
 	mutex_unlock(&idt82p33->reg_lock);
+
+	return ret;
 }
=20
 static int idt82p33_pps_enable(struct idt82p33_channel *channel, bool enab=
le) @@ -659,10 +662,8 @@ static void idt82p33_ptp_clock_unregister_all(stru=
ct idt82p33 *idt82p33)
=20
 		channel =3D &idt82p33->channel[i];
=20
-		if (channel->ptp_clock) {
+		if (channel->ptp_clock)
 			ptp_clock_unregister(channel->ptp_clock);
-			cancel_delayed_work_sync(&channel->sync_tod_work);
-		}
 	}
 }
=20
@@ -862,8 +863,6 @@ static int idt82p33_channel_init(struct idt82p33_channe=
l *channel, int index)
 		return -EINVAL;
 	}
=20
-	INIT_DELAYED_WORK(&channel->sync_tod_work,
-			  idt82p33_sync_tod_work_handler);
 	channel->sync_tod_on =3D false;
 	channel->current_freq_ppb =3D 0;
=20
@@ -881,6 +880,7 @@ static void idt82p33_caps_init(struct ptp_clock_info *c=
aps)
 	caps->gettime64 =3D idt82p33_gettime;
 	caps->settime64 =3D idt82p33_settime;
 	caps->enable =3D idt82p33_enable;
+	caps->do_aux_work =3D idt82p33_sync_tod_work_handler;
 }
=20
 static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index) d=
iff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h index 9=
d46966..1dcd2c0 100644
--- a/drivers/ptp/ptp_idt82p33.h
+++ b/drivers/ptp/ptp_idt82p33.h
@@ -119,8 +119,6 @@ struct idt82p33_channel {
 	struct ptp_clock	*ptp_clock;
 	struct idt82p33	*idt82p33;
 	enum pll_mode	pll_mode;
-	/* task to turn off SYNC_TOD bit after pps sync */
-	struct delayed_work	sync_tod_work;
 	bool			sync_tod_on;
 	s32			current_freq_ppb;
 	u8			output_mask;
--
2.7.4

