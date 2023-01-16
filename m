Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0673766BA55
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbjAPJ3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjAPJ2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:28:51 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2052.outbound.protection.outlook.com [40.107.6.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B735166D1;
        Mon, 16 Jan 2023 01:28:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZY9Wo6IjqMUGqdA69IGuE0HcDS1nqC5jh9xnmrU0A/qsPPyB8yA6ZWlvzlZb/bSHJwtZ6QZ41HNR7t2iKJUvaFfREdeYHIrXW8XYCVAniom3uLgg8xvr8k6ThLKX9QRJTviY69T7q0cOe77Uns3hFDGdgHZdxlZf15e/AmPmhNMWI3oWqF+r+ZL2F9BMdE0OHTmLIzCIivBORa9kh5r76wUd42N8aHlE2R/uzA8eNeKlzkTsKuQFbdzdQXs4HqHEyEhYAeSOOXSVwK3UmYGnJRhtL/8sf7ixwP3GDqMpIyan/EoROTMOZOm91guNeS7+xwmI9uI97pzD/04Tz8yGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kn3YS7BPAn9V3tbkBPLwuiwEvxpAqotPyHl5oLE3CQw=;
 b=ggToe4yNCGjBPCowmUKGhejouxVB3uNlmZ3vSJixS/nx3iktN18iOZtf7sxOijFouhFxZVI6eBJ9sfHqFFab9KgL8bD7B057ngunokH9pxjZx3XR6VUCn7UpKYDIyzLnAEom84oI5+2a5A9FH6Xa9NdZxjvVTxJK9FAfeGt57Fz2euj/7N9LkJWlnk1s1RHyJfviceIEVgo7PjrB8QEx1s4jHVlu12W3h8Ve8mtx4gVUbd8OMAp7MOWDZviOgZNGnx8bGH7+JafY/wTcNE31JiBG7VmdW4D96+88lSeSqSDjTGNmRIWPqt8jC9yMumdJ4NeXXa86DWnWqYeRqGoZ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn3YS7BPAn9V3tbkBPLwuiwEvxpAqotPyHl5oLE3CQw=;
 b=kYBe4FHO71Jd47+nsmactzmSJ0YkA4Uw2ArF8b/LLzRwIS05GB1xdgDR0gkScqNRkJklZJaw+HkVwwal/Mo9cFSQmz56pTn/jGah5n/VZ+vNFkEXeRC4kYb7YwFmJGZfEva4fIeMsCiX4IrZMvI2941bu7Nler4m8ewe838tIvY=
Received: from PAXPR04MB8334.eurprd04.prod.outlook.com (2603:10a6:102:1cc::8)
 by DU0PR04MB9348.eurprd04.prod.outlook.com (2603:10a6:10:358::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Mon, 16 Jan
 2023 09:28:33 +0000
Received: from PAXPR04MB8334.eurprd04.prod.outlook.com
 ([fe80::f9bf:492a:7e9a:e183]) by PAXPR04MB8334.eurprd04.prod.outlook.com
 ([fe80::f9bf:492a:7e9a:e183%7]) with mapi id 15.20.6002.013; Mon, 16 Jan 2023
 09:28:33 +0000
From:   Nikhil Gupta <nikhil.gupta@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "Y.B. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vakul Garg <vakul.garg@nxp.com>,
        Rajan Gupta <rajan.gupta@nxp.com>
Subject: [PATCH net-next] ptp_qoriq: fix latency in ptp_qoriq_adjtime()
 operation.
Thread-Topic: [PATCH net-next] ptp_qoriq: fix latency in ptp_qoriq_adjtime()
 operation.
Thread-Index: AQHZKYznla/Dp23Qw0eCqL193nMgEA==
Date:   Mon, 16 Jan 2023 09:28:33 +0000
Message-ID: <PAXPR04MB8334ECB5CC3FC603AE57FE368BC19@PAXPR04MB8334.eurprd04.prod.outlook.com>
References: <20230110113024.7558-1-nikhil.gupta@nxp.com>
 <20230111210856.745ef17c@kernel.org>
In-Reply-To: <20230111210856.745ef17c@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB8334:EE_|DU0PR04MB9348:EE_
x-ms-office365-filtering-correlation-id: b5b2cbf8-d206-4029-6ce6-08daf7a409a0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kTyGv3o8LQjHjwQnJ7ePhLbdJCXZcOJ93t4im0H2eeNoX/7b51gTMh3gwcafBmZfum9nC07WAAbT9gzTCOhwuPMYRgaflgQkK5x/eFUAcGT4m3coPsLZcprbFm/0UzwoPNLJpIcI3LSQx2GVoCOvl+SaqmZO7qHA92us3BhRPCxIUv7lPBIM2HhWzwq/y4C6OW2WTB7snFqgSzlK6kJd+T0Jop9BmGZAFjGDgjvYhlzZc4a4xJiRPC3sYfbdw6A0GiBk/miVxROHxTz+HyGX/4AF1LJHDylh9NrHcGi9zE0Qt1ry6pzn7wPnYW/iQGGYx9uqiR5l9QdkMQnS+RCB+qk9SrqA/O8Y+mgcr4Hv+drur1VIFvbwUopIqr+i2IAn9d12QKxteIQQRV6Ha5Z+I0SJNdLcj+kL3HBgqn9Dbambk6/OV5I1xENxM9kPcDp+GUftYSHQeSIrza1PtqtbnEsC+1uDWBKJ7M91o5AYbiizLKV+6eFrRTlJccOTNNWws1JVs09BsUe17ga8vyiF08YdF0SX2VmVdfmLtpVqshbsvBu4WfGkR3p8Sv0BjtN5WPYOE24E8kSg/RDHz41ouUYP8SH5fcgLNSUFuul7hAujMbCKydOlk4wMJeHNIZa41NfyxAnK0ub7RR2i6tsdujYIGijB2XvdL3eDvkfAXOlBHTU46tC2SvtRj/6JeJ9om+qWMWEp5GgwI+k2JX8Jww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8334.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199015)(6506007)(2906002)(53546011)(86362001)(4326008)(76116006)(64756008)(66946007)(8676002)(66476007)(66556008)(66446008)(478600001)(9686003)(44832011)(186003)(26005)(122000001)(316002)(6916009)(41300700001)(54906003)(5660300002)(71200400001)(7696005)(38100700002)(33656002)(52536014)(8936002)(83380400001)(55016003)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2X7kxS5m4aLl17CYSlxw9hU/pyrBlRtzNocrG23UfNaGd0pUjPcgZfuGUzZu?=
 =?us-ascii?Q?hJ+F2KrkbcLYflLgyclnmTLemX/9SNN6QPYdFezRm6l3vSgKAn3lUteidiTR?=
 =?us-ascii?Q?buf8ZKQPFBRH+eK0OBKPgnCxsk9FTq9ON65woWjQjFqv4OKqmHMj4C7nBQ5Q?=
 =?us-ascii?Q?/frsFeORcLL9RKTnAvQ6cme0IpdKLSH9MzhEUpVh1FWSwxsW93+u5Ck3Aerl?=
 =?us-ascii?Q?yKF8Nlpc/6EN75zzp67Pj3TYjZN72EQPX6HqXOqZNtnXjHa4C/zGmd1dOIne?=
 =?us-ascii?Q?JYkHqhNz59zZJg+fv64H5Oj3EwssDIGNo2J4ACIk5VaHpBSD0UXNPq++vGaH?=
 =?us-ascii?Q?q3wM6lgbKPz1YrnjlYmFfhJWZQVr1YMhKnHcEqhGWQaTv3YkBiAB4yEflot8?=
 =?us-ascii?Q?lPlig2RpoCyWex3WKVRH+bMCndOOJQq4WDCqvfgTG55WUQFgUmSNVwWKFU8D?=
 =?us-ascii?Q?8Rzrppx6mmFtWDfHfOoxX+yHoUOjUnDNKIu4T5BDAYt/M8ybQOF3bmCH2Rqx?=
 =?us-ascii?Q?9GbSAoiIUcBLRh2FsgAVVwhfC5KXW3vWAnZGMxrSgVjWVtDg1JYMceRNKpXl?=
 =?us-ascii?Q?PezkjQlfYudG7tFa69drGtxf17i620PDHWyv9gxI4KA1PzvFVjEHgpo6Juzc?=
 =?us-ascii?Q?yPEGNy2PM5ySMgGpGxL7IDAy1GrmxtGo7ecU37kDyMywnjWdXRO8/+TL/Z0I?=
 =?us-ascii?Q?PNvtHgfQVEAFIYKaxAQIIRvOBk++v6B3/cA19VyU+RUCiRHrEbXyeBgTL7Kl?=
 =?us-ascii?Q?8VgQZTfK5SWUtaRcSRKqT5LheG1ndmOc6nmBSVZH23rwRXUBUsH3nn0ukb5D?=
 =?us-ascii?Q?ct8mC8Y78qvmQxj4LTVkwtDp9SLoGUSGIc2QXtqeWmwQCc4jybXk1HETLCvN?=
 =?us-ascii?Q?1NziYPkRZ0i0IWonpQRrN1uTHtFMwQ1Q0cpEAIXbQ7t0wz8Ff/+W6OEe2utd?=
 =?us-ascii?Q?4Lm2itSj0NlZDrX8aRQArr3FIdSSfmexcdxUB4arXwBnKwGx8gV41dRfPu/x?=
 =?us-ascii?Q?fYcxmJP1rDBw190PQoVfstK0vswgoWIcm4c0K88unPo50Jyu/RjZI0gBVIZd?=
 =?us-ascii?Q?XRkk7iMfYmeoT8ITNzn67YzZ6NOysC7QJ+iKuPuWuDP2eFIrkm6UuSJpr6B8?=
 =?us-ascii?Q?TJN/ltpXWdXxTDdKfTTMTUq0uWKQlXEmejw/KDUTQkHJ7VNwBtfQ8Rcjhp45?=
 =?us-ascii?Q?B+Ca24vg4mtTgajddiR1MFD04PLEqkHXKkJKNc1BOLCnWCWcyqNWZ4nSXIxU?=
 =?us-ascii?Q?FM57+bvJycGBeds9rHe4yaC3yveSFkkmC0GBURZsJj3dQL7B3C5vTV5lLAJ2?=
 =?us-ascii?Q?cotY6ekVroEYCi8/nWM0rmOLN6Bu0VB2ln85hfP4ECYKIAhbPPtWxfSmRCFr?=
 =?us-ascii?Q?OYMKknR1a52WWYTAc9O3ojnQDvevGFBc90V2auSZg/eKV9+axhACfgqwc3y+?=
 =?us-ascii?Q?eQZPAsdZoXP6XjLFMMwdJEg1vcP4cxDh/t3uV0hSD57rOVxcADFKlEbQz1o8?=
 =?us-ascii?Q?eQplzB1hckpsD6GiIbgof5L7ebRNkgIE4CXSv16+g31Tekx2xuSd4FQLkjSH?=
 =?us-ascii?Q?7OIMjZ0RsYZ6TJhU8OkV31UeH+qcFSRoQ88rRsFb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8334.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b2cbf8-d206-4029-6ce6-08daf7a409a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 09:28:33.3927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9l4GEgADYAxWHTjTsJ+DX0C7tA9L/8Hg37DEzIDsxz+IKv+a9rsQJeeDWuSVn7jVdeCRWmdZeqAf7IeBL60x6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9348
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Thursday, January 12, 2023 10:39 AM
To: Nikhil Gupta <nikhil.gupta@nxp.com>
Cc: linux-arm-kernel@lists.infradead.org; Y.B. Lu <yangbo.lu@nxp.com>; netd=
ev@vger.kernel.org; linux-kernel@vger.kernel.org; Vakul Garg <vakul.garg@nx=
p.com>; Rajan Gupta <rajan.gupta@nxp.com>
Subject: [EXT] Re: [PATCH] ptp_qoriq: fix latency in ptp_qoriq_adjtime() op=
eration.

Caution: EXT Email

please put [PATCH net-next] in the subject.

On Tue, 10 Jan 2023 17:00:24 +0530 nikhil.gupta@nxp.com wrote:
> From: Nikhil Gupta <nikhil.gupta@nxp.com>
>
> 1588 driver loses about 1us in adjtime operation at PTP slave.
> This is because adjtime operation uses a slow non-atomic=20
> tmr_cnt_read() followed by tmr_cnt_write() operation.

So far so good..

> In the above sequence, since the timer counter operation loses about 1us.

s/operation/keeps incrementing after the read/ ?

but frankly I don't think this sentence adds much

> Instead, tmr_offset register should be programmed with the delta=20
> nanoseconds

missing full stop at the end.
You should describe what the tmr_offset register does.
[Nikhil] : current time is calculated by adding TMROFF_H/L with the timer's=
 counter TMR_CNT_H/L register.

> This won't lead to timer counter stopping and losing time while=20
> tmr_cnt_write() is being done.

Stopping? The timer was actually stopping?

> This Patch adds api for tmr_offset_read/write to program the

Use imperative mood.

> delta nanoseconds in the Timer offset Register.
>
> Signed-off-by: Nikhil Gupta <nikhil.gupta@nxp.com>
> Reviewed-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
>  drivers/ptp/ptp_qoriq.c | 36 ++++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c index=20
> 08f4cf0ad9e3..5b6ea6d590be 100644
> --- a/drivers/ptp/ptp_qoriq.c
> +++ b/drivers/ptp/ptp_qoriq.c
> @@ -48,6 +48,29 @@ static void tmr_cnt_write(struct ptp_qoriq *ptp_qoriq,=
 u64 ns)
>       ptp_qoriq->write(&regs->ctrl_regs->tmr_cnt_h, hi);  }
>
> +static void tmr_offset_write(struct ptp_qoriq *ptp_qoriq, u64=20
> +delta_ns) {
> +     struct ptp_qoriq_registers *regs =3D &ptp_qoriq->regs;
> +     u32 hi =3D delta_ns >> 32;
> +     u32 lo =3D delta_ns & 0xffffffff;
> +
> +     ptp_qoriq->write(&regs->ctrl_regs->tmroff_l, lo);
> +     ptp_qoriq->write(&regs->ctrl_regs->tmroff_h, hi); }
> +
> +static u64 tmr_offset_read(struct ptp_qoriq *ptp_qoriq) {
> +     struct ptp_qoriq_registers *regs =3D &ptp_qoriq->regs;
> +     u64 ns;
> +     u32 lo, hi;

Order variable lines longest to shortest

> +     lo =3D ptp_qoriq->read(&regs->ctrl_regs->tmroff_l);
> +     hi =3D ptp_qoriq->read(&regs->ctrl_regs->tmroff_h);
> +     ns =3D ((u64) hi) << 32;
> +     ns |=3D lo;
> +     return ns;
> +}
> +
>  /* Caller must hold ptp_qoriq->lock. */  static void set_alarm(struct=20
> ptp_qoriq *ptp_qoriq)  { @@ -55,7 +78,9 @@ static void=20
> set_alarm(struct ptp_qoriq *ptp_qoriq)
>       u64 ns;
>       u32 lo, hi;
>
> -     ns =3D tmr_cnt_read(ptp_qoriq) + 1500000000ULL;
> +     ns =3D tmr_cnt_read(ptp_qoriq) + tmr_offset_read(ptp_qoriq)
> +                                  + 1500000000ULL;
> +
>       ns =3D div_u64(ns, 1000000000UL) * 1000000000ULL;
>       ns -=3D ptp_qoriq->tclk_period;
>       hi =3D ns >> 32;
> @@ -207,15 +232,12 @@ EXPORT_SYMBOL_GPL(ptp_qoriq_adjfine);
>
>  int ptp_qoriq_adjtime(struct ptp_clock_info *ptp, s64 delta)  {
> -     s64 now;
>       unsigned long flags;
>       struct ptp_qoriq *ptp_qoriq =3D container_of(ptp, struct=20
> ptp_qoriq, caps);
>
>       spin_lock_irqsave(&ptp_qoriq->lock, flags);
>
> -     now =3D tmr_cnt_read(ptp_qoriq);
> -     now +=3D delta;
> -     tmr_cnt_write(ptp_qoriq, now);
> +     tmr_offset_write(ptp_qoriq, delta);

Writes to the offset register result in an add operation?
Or it's a pure write? What will the offset be after a sequence of following=
 adjtime() calls:
  adjtime(+100);
  adjtime(+100);
  adjtime(+100);
?
[Nikhil] : It's a pure write operation, I will be sending the updated versi=
on of the patch.
	  Wherein retaining  the earlier offset value and adding to the new.

>       set_fipers(ptp_qoriq);
>
>       spin_unlock_irqrestore(&ptp_qoriq->lock, flags); @@ -232,7=20
> +254,7 @@ int ptp_qoriq_gettime(struct ptp_clock_info *ptp, struct=20
> timespec64 *ts)
>
>       spin_lock_irqsave(&ptp_qoriq->lock, flags);
>
> -     ns =3D tmr_cnt_read(ptp_qoriq);
> +     ns =3D tmr_cnt_read(ptp_qoriq) + tmr_offset_read(ptp_qoriq);
>
>       spin_unlock_irqrestore(&ptp_qoriq->lock, flags);
>
> @@ -251,6 +273,8 @@ int ptp_qoriq_settime(struct ptp_clock_info *ptp,
>
>       ns =3D timespec64_to_ns(ts);
>
> +     tmr_offset_write(ptp_qoriq, 0);

Shouldn't this be under the lock?
[Nikhil] : will update this.
>       spin_lock_irqsave(&ptp_qoriq->lock, flags);
>
>       tmr_cnt_write(ptp_qoriq, ns);

