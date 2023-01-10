Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32E3663F8B
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjAJLxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238154AbjAJLxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:53:47 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F969551D2;
        Tue, 10 Jan 2023 03:53:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqpo0KfdXeGsQ4nISNU5NSjAwpUgldVRdg+Q4AXK/CFnHd9nLmYoAqSwdODqCQFoA9SlYIM3OU8UrAm16UtADu7zpbJFN4pF8ToGwpVFjjmgErpLAbHVBjm9E0ufEJj84qnVVjMFo2BXoI1ql/UXqfNxDdSeJV5phApUuro/mO124PUokXnJar+GF7GwmvWAfFkRxAEsBuGS6I4UDBdcoQodUUpXU11LwKPadHCA5yZ+MhpDxY8PH49LYyFsGe0Kx9Cb9AGQZM720LAJszRICm2VCvO1Ku4Ed6gzkWzy0kSr4ubCxL5BwvgEOS++oBrpFp5Ve5hbe5IP6kSwZqPjTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1gX2zNo0oOuvsVVoDa3EDw/0hIA15IJWGodU3/3PNhQ=;
 b=nq+le74ZtbB5gR60ed8Fe9kLPEI6RplmQKIDzXLsFlz0en2jGMH4yKgZf5XXzwaJ1zvxvDv05IkYz3QHAoCVuTbNIfDtiVNUpHZbwihGouR0hLEOk6Y4erOxELh2yhipehr6scU1FqMvzEdrEsrSrsRx2T1bxDwx0FuH3zq0rfy2xXIP1qQsNeqY0calafSC5sVp2h/13TO5sqaE7vcGYI/nKsAwTQJpeDPjkcEGQHjHS+Vx/WZRrTBJCOzWTrkVX6RW9B0sapG0mHAo2jODJcUjV04aS+lrtnteZ37lilidV3uWbb8HDs5boigMV3ZpL4Hoyl4Z07GD0JTS1ici0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gX2zNo0oOuvsVVoDa3EDw/0hIA15IJWGodU3/3PNhQ=;
 b=lJd6li0zvf057f5Nc333UUi3MRg4lat0233nQRKXTVFn2ECRHdq8RO/9lKl/PjeTaCNEdabbDHfj/OV8CYHW9+66WmE6+0BZflza1175mAw3xiDMJl46MTx6O5+o3IeKOU6itR0rtMpOQndK9jZhD5MDA2QcJtb6r79DVSUDFLY=
Received: from PAXPR04MB8334.eurprd04.prod.outlook.com (2603:10a6:102:1cc::8)
 by AM8PR04MB7298.eurprd04.prod.outlook.com (2603:10a6:20b:1df::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 11:53:43 +0000
Received: from PAXPR04MB8334.eurprd04.prod.outlook.com
 ([fe80::f9bf:492a:7e9a:e183]) by PAXPR04MB8334.eurprd04.prod.outlook.com
 ([fe80::f9bf:492a:7e9a:e183%5]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 11:53:43 +0000
From:   Nikhil Gupta <nikhil.gupta@nxp.com>
To:     Nikhil Gupta <nikhil.gupta@nxp.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "Y.B. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Vakul Garg <vakul.garg@nxp.com>, Rajan Gupta <rajan.gupta@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH] ptp_qoriq: fix latency in ptp_qoriq_adjtime() operation.
Thread-Topic: [PATCH] ptp_qoriq: fix latency in ptp_qoriq_adjtime() operation.
Thread-Index: AQHZJObx5fqW49H2DEuLikyff7cYQa6XigMA
Date:   Tue, 10 Jan 2023 11:53:43 +0000
Message-ID: <PAXPR04MB83349FD89696C79A18F87DA58BFF9@PAXPR04MB8334.eurprd04.prod.outlook.com>
References: <20230110113024.7558-1-nikhil.gupta@nxp.com>
In-Reply-To: <20230110113024.7558-1-nikhil.gupta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB8334:EE_|AM8PR04MB7298:EE_
x-ms-office365-filtering-correlation-id: 888cd0cf-d21b-48db-3fc9-08daf30152c0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O10kFOi1VlbhHTt+jxwMRG7S8XZMZmb+ef2292XKipSE/TnxBIwlVVX7Ecih0Ia/uWDhA5lFLGfbyqUBTBWGx8mERZLQLCUL2q2L+yPt6Xrc639JVGhZm+u3Fm8x2yfEehtH7e81ITQF0SDfwAe/s+sjYl1sBCp66wI2o8CNnKd6O4USldEBkv2cHaO6Z5XH6+P/S8JS7+7itmrDv3a1230U6hqGFMRR0NgnhvndMCR9XhstYkzkpB8wbFMy3jLTJXwV4lLQi7N5l4snDCd4kFW3SZS0ghe2j/6kNi+UkabFJSSznfixNsW+NNqdfzHgcNV3AkH/aSftnBfxwQ6NVIBOysVWsVslxs1huP+kstvhIJdjAcZtdKQ7RilxebuO70ZqmXhN4Uco9ZNevf6L23ViFvWDg5fitHsL942em3MZ0By5XAaQKow/nyuW55g9ZVPVstf79mDdqByT7lxPcyOzBQ3VmkwHp2QAOcWR2VV6fK1WAthoIcptCi0W1wcW99b4Ecd6ALbMJFw0WhCl6QFWUlmNAegXsTbVJgvb77RqBqZioMsWFX51e7aEy+vOaR7YYXb1SFicNLm3yy92ApPXKBXZfiGOdLoSXhgNJ5m/QXErUVi2H0iiZEeQoWjEuSFmCICtcVFZresr9qMmFVJ8496C8vPxrBCwcAdNKo3ZjaPUqBs6HTdEP25P4OEs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8334.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199015)(66476007)(8676002)(76116006)(66946007)(316002)(66556008)(7696005)(64756008)(4326008)(66446008)(71200400001)(110136005)(54906003)(38070700005)(44832011)(2906002)(8936002)(52536014)(5660300002)(41300700001)(186003)(86362001)(478600001)(83380400001)(53546011)(6506007)(55236004)(33656002)(122000001)(55016003)(38100700002)(26005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q82HSscUGMy9hCA9N7D6YuNmjzg/nXA8Vo7LEaSV0LWSOoUufjUWvYlSw6fw?=
 =?us-ascii?Q?2kztCDKz1d0C3EJH/xsa2kAGc257Q25XgzQ9pMbJlTXYjwirqVrpUy8Edo86?=
 =?us-ascii?Q?NWubso2kD70nTYvByUfUE9TbncrnNUuEhDzVASNkBcgWWiH1CC0TmkVCcOkC?=
 =?us-ascii?Q?y7jmbpUp5ieT6Sw5ViZj59TkBUgr8v7C1W4s6ID84FZCShuh+YnOaT/TGOlW?=
 =?us-ascii?Q?3TqcXAtslFlqccAtirgEUh15aUEPsWOHOBAPD01j7OuTZ0ImjsbcfGfT19bF?=
 =?us-ascii?Q?PX67rn6I7B2sMhX1j5MYBPNqtg8lkbTDEAUoMSc3tGEOu9NE9GE/WV2lsjH3?=
 =?us-ascii?Q?3REByn1dGJVOwM7wep3IosJQoHQbXBcRxTvutgcR2Yh8rSYRY51684zTddR8?=
 =?us-ascii?Q?AABPwJDEIUpAjNkArmQuciNgh1Yx1kzZwFLaoYY35R+K7G+8pf7cruLMhhkJ?=
 =?us-ascii?Q?rxU4a22wnIQFUcIs0w0wPdv6SbA63tYdAPyvfUYFDXwmkldiHIHgeycMhgdK?=
 =?us-ascii?Q?2j0efAIPPrTJyeuXef0Nn5i5jU3Dtf0UrZlYv+kvoegXhl4gy9jG0BdqYg9O?=
 =?us-ascii?Q?5KkM95pLbKIZ3/yzs0HwiImniBjCbwJTH/fOI9b2w5wcYaRCZUG+xLsRVrlI?=
 =?us-ascii?Q?7SgmJ0MUhkXBYbxOlHcfG7e6YHtHne1AKAKA5cmcG1QmD97k+PckDG33cvGN?=
 =?us-ascii?Q?6hhHZpjr+7yioVcgMWrg6FnYY9c935bO2xnVBvBsP7KZVEafssYYfrzbaWyA?=
 =?us-ascii?Q?JDIbhE4w4CtOcozVxdtHsngVt2rwnInSXr555FfJSBXfUCM7HsBLGsWq7l6R?=
 =?us-ascii?Q?vRyD01LrEBasmcqkllOqDoXru+roUiiZK0iKc2FQITBcZvxij9UT8CNwQWFC?=
 =?us-ascii?Q?gyOYN9ToHg9cFkDwX5BfP6OIZvtG1y5S6XCAdmhu8RarherveM6rcAkdsjAj?=
 =?us-ascii?Q?tbEn1rdZGDvTFMp1rUuTqgGOQfTNqaVjgU9c73UAL6WCw4p8gJK3yzahB9NR?=
 =?us-ascii?Q?ZBlGKQcZik6ltgXbccI5jU57LBVvctcNNLAJETwZyj98LsViDCK4vpyduC2i?=
 =?us-ascii?Q?Mf6skVyQglvVJdCq9V4mLQiva6bTs6Us3KQypiplSQTpp9Xpuc+v9Dmjks0w?=
 =?us-ascii?Q?AFesTm4B6sJQL3qQEjXgHFrDtaByR4t7hs+7G/+zMPLmT67ELPRj7+TWEqIC?=
 =?us-ascii?Q?aeib8XPU0ycwVI0wDVoppmS/sVOrG60LQSLFlY1mOOzQ/P6zyYUnmtnWCkiL?=
 =?us-ascii?Q?CPWAjo+Aj+RFn15dd+hpoGwLy7ZA1VoupHL4ct8iJpHLQfYE64TdxkNjt4P+?=
 =?us-ascii?Q?oDCBR49UrzTcXEbv3CFfbDXdLtxRH3mtQEZG/Ab1dEF2JqSaCDmCpeBft74I?=
 =?us-ascii?Q?nQjDPc4UXo4gNYsBqcwrGiKtUw9pdvImzmEiaIwmsLgQouD62hqKBfnruVo9?=
 =?us-ascii?Q?S8V9T9jj7p8tzcGKV5lH780fVExMJgkN4x+vWG2qFoONXf0bzIPmNOEE3/aE?=
 =?us-ascii?Q?LOvPI1q05m/y0kzYIsQlcwtBH5incxgwgE47rbNjOzs+URlVil6oKEbBYRQH?=
 =?us-ascii?Q?XeoZVwEBUcZdEmk02SkZbAscPUFAD82A7/2Gq2vl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8334.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 888cd0cf-d21b-48db-3fc9-08daf30152c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 11:53:43.4569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xlX1ryMTTB0oeJ9txOXa6UHIOA68+CrYsYntWUG1bbLMKjFlyD5F6W4Jx5RUYQSSflmF/q7ncee9vyCMTQW9rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7298
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

++ Richard Cochran

-----Original Message-----
From: nikhil.gupta@nxp.com <nikhil.gupta@nxp.com>=20
Sent: Tuesday, January 10, 2023 5:00 PM
To: linux-arm-kernel@lists.infradead.org; Y.B. Lu <yangbo.lu@nxp.com>; netd=
ev@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Vakul Garg <vakul.garg@nxp.com>; Rajan Gupta <rajan.gupta@nxp.com>; Nik=
hil Gupta <nikhil.gupta@nxp.com>
Subject: [PATCH] ptp_qoriq: fix latency in ptp_qoriq_adjtime() operation.

From: Nikhil Gupta <nikhil.gupta@nxp.com>

1588 driver loses about 1us in adjtime operation at PTP slave.
This is because adjtime operation uses a slow non-atomic tmr_cnt_read() fol=
lowed by tmr_cnt_write() operation.
In the above sequence, since the timer counter operation loses about 1us.
Instead, tmr_offset register should be programmed with the delta nanosecond=
s This won't lead to timer counter stopping and losing time while tmr_cnt_w=
rite() is being done.
This Patch adds api for tmr_offset_read/write to program the delta nanoseco=
nds in the Timer offset Register.

Signed-off-by: Nikhil Gupta <nikhil.gupta@nxp.com>
Reviewed-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/ptp/ptp_qoriq.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c index 08f4cf=
0ad9e3..5b6ea6d590be 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -48,6 +48,29 @@ static void tmr_cnt_write(struct ptp_qoriq *ptp_qoriq, u=
64 ns)
 	ptp_qoriq->write(&regs->ctrl_regs->tmr_cnt_h, hi);  }
=20
+static void tmr_offset_write(struct ptp_qoriq *ptp_qoriq, u64 delta_ns)=20
+{
+	struct ptp_qoriq_registers *regs =3D &ptp_qoriq->regs;
+	u32 hi =3D delta_ns >> 32;
+	u32 lo =3D delta_ns & 0xffffffff;
+
+	ptp_qoriq->write(&regs->ctrl_regs->tmroff_l, lo);
+	ptp_qoriq->write(&regs->ctrl_regs->tmroff_h, hi); }
+
+static u64 tmr_offset_read(struct ptp_qoriq *ptp_qoriq) {
+	struct ptp_qoriq_registers *regs =3D &ptp_qoriq->regs;
+	u64 ns;
+	u32 lo, hi;
+
+	lo =3D ptp_qoriq->read(&regs->ctrl_regs->tmroff_l);
+	hi =3D ptp_qoriq->read(&regs->ctrl_regs->tmroff_h);
+	ns =3D ((u64) hi) << 32;
+	ns |=3D lo;
+	return ns;
+}
+
 /* Caller must hold ptp_qoriq->lock. */  static void set_alarm(struct ptp_=
qoriq *ptp_qoriq)  { @@ -55,7 +78,9 @@ static void set_alarm(struct ptp_qor=
iq *ptp_qoriq)
 	u64 ns;
 	u32 lo, hi;
=20
-	ns =3D tmr_cnt_read(ptp_qoriq) + 1500000000ULL;
+	ns =3D tmr_cnt_read(ptp_qoriq) + tmr_offset_read(ptp_qoriq)
+				     + 1500000000ULL;
+
 	ns =3D div_u64(ns, 1000000000UL) * 1000000000ULL;
 	ns -=3D ptp_qoriq->tclk_period;
 	hi =3D ns >> 32;
@@ -207,15 +232,12 @@ EXPORT_SYMBOL_GPL(ptp_qoriq_adjfine);
=20
 int ptp_qoriq_adjtime(struct ptp_clock_info *ptp, s64 delta)  {
-	s64 now;
 	unsigned long flags;
 	struct ptp_qoriq *ptp_qoriq =3D container_of(ptp, struct ptp_qoriq, caps)=
;
=20
 	spin_lock_irqsave(&ptp_qoriq->lock, flags);
=20
-	now =3D tmr_cnt_read(ptp_qoriq);
-	now +=3D delta;
-	tmr_cnt_write(ptp_qoriq, now);
+	tmr_offset_write(ptp_qoriq, delta);
 	set_fipers(ptp_qoriq);
=20
 	spin_unlock_irqrestore(&ptp_qoriq->lock, flags); @@ -232,7 +254,7 @@ int =
ptp_qoriq_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
=20
 	spin_lock_irqsave(&ptp_qoriq->lock, flags);
=20
-	ns =3D tmr_cnt_read(ptp_qoriq);
+	ns =3D tmr_cnt_read(ptp_qoriq) + tmr_offset_read(ptp_qoriq);
=20
 	spin_unlock_irqrestore(&ptp_qoriq->lock, flags);
=20
@@ -251,6 +273,8 @@ int ptp_qoriq_settime(struct ptp_clock_info *ptp,
=20
 	ns =3D timespec64_to_ns(ts);
=20
+	tmr_offset_write(ptp_qoriq, 0);
+
 	spin_lock_irqsave(&ptp_qoriq->lock, flags);
=20
 	tmr_cnt_write(ptp_qoriq, ns);
--
2.17.1

