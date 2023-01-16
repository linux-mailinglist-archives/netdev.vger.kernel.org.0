Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FE666C7CB
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbjAPQeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbjAPQeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:34:11 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2095.outbound.protection.outlook.com [40.107.113.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943D632E74;
        Mon, 16 Jan 2023 08:21:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPy8DX/hxHuRyoBbgWWLBSZCA8tTf8Zd324S8HwcVzYz/Ck4Ii7fLofpOgevnAcY93oPAEEuTPmb8YYM4+KTOULXjUgeHnTxJFolW2K+dZzGiKxfKBp71F7RD15lLRn1xpJBpPcyNew9Ae/vpbfPBOAYIwa4Xt2vQafEu7/jDquxDKMcYi9V7KpPM1+k9kntUZFKx7cnLYGajy5qRi1p/VrERSdZybRfvlurCJZ1qq5NqpS2Ji6egL/927XNLZWmhLvZfJVLTVLcU69hRt7g0YbxVlBer+eMb10H0XkyD6pPGSLDBs9J3hyQqVJZbOadzxzvAT8UQAtc5R2sDvigpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axso6bdt/avehu3JLVUeuQqbZ0HH5q4XwVXiI5oqqss=;
 b=T0h2EvhyB4kzeEXLNs5Imz8+ReVTZaMZ8QAK6X3P4O2OhQQUKtW3B97GVJ1Pdvz+EYpqk+KzcWBwHlzHsLtfW5LePOVORG6I47An6PxcZuGnrsWQmWuVQ1JZVhcg1XJhje9v/8W8lmV7DrUBDaQn9uNzCEl74Z4wJ6+deNgPz5JWq1fCWefbP0amLRWDPlHF+71X9kpP+GG5OZBJI/AbyKLen2dc7NX8cdhF+gVBe2nR4/Gg6JwrnkePH+EtXUEBfMvkSQ63RqUPHOig86rE61HJaNdk4zHnhqQK35xTmW3QDuV0/kTFc3XCYamPcsIBq7K3U74+9kFkL1bozKNkdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axso6bdt/avehu3JLVUeuQqbZ0HH5q4XwVXiI5oqqss=;
 b=U5+2V8+qmtjLV4oumKwR0/oSnl9o30H+hKK0pbWMd5xyhOK1V0SiUDgOE9KHjrpf0/U0T50z0YlMg3s+SZVqe4yQUON+unJqCu+l6iY1XzD1AIttY6kULCYv4cIiA86TZypMFnefiNVbIp3uNeoGBw948z0pxzmqdQcSS52KXcs=
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by TYWPR01MB10489.jpnprd01.prod.outlook.com (2603:1096:400:2f9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 16:21:55 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::3bbe:4728:ef74:57e1]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::3bbe:4728:ef74:57e1%4]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 16:21:55 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net 1/2] ptp: idt82p33: Add PTP_CLK_REQ_EXTTS support
Thread-Topic: [PATCH net 1/2] ptp: idt82p33: Add PTP_CLK_REQ_EXTTS support
Thread-Index: AQHY/3UcvDA9UWcGmEum5AqhRbPuA66hjihw
Date:   Mon, 16 Jan 2023 16:21:55 +0000
Message-ID: <OS3PR01MB659319B48D522B615D21E35FBAC19@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <20221123195207.10260-1-min.li.xe@renesas.com>
In-Reply-To: <20221123195207.10260-1-min.li.xe@renesas.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB6593:EE_|TYWPR01MB10489:EE_
x-ms-office365-filtering-correlation-id: aae458ce-eb6e-467a-416f-08daf7ddc8af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bOubyGX4j50am0YQ3jJ8KfhqzeI3I50qTnyjX4eU7QVWSTMHfpDEd/NP0VYQtEiQWPZ+9dkUwyxhCln0TAtMFpchqPKayONQMhoyMK+G/MW6tQ6OXCPWqfIy8q3bu4y39kx8P5h30tYRMmQobQk3hh3Fjpl2A25+6zcqF3bj9a42bVxrXhW1i0XRs7AeGK+LVcpm0xroVZf54DjBHtJwpbOBxzEuIHDtNmbp5g/xy2OLyZIFIYt17b53rZpPycJ1D96UlDb2rjqMCRnq7XH6Cq7zqLqMyIRrVdvhPHPT4WZc0ZcsqTP+VPDw2DHPf/EjsdWE7CAL9LtsVuDAv+o49U5FVP7MsRyU4M3Zvwa72eD/RhaTBXoNpxJ5nak/JGSOyms0FjMetJ40eY1c7B+2hsbCNf1s1wkWSXtQP0wprUwdY8fifVgj+Qta5HbnYOh6QTXTlpeTnwNZUiwzHnui/mmm3Pc7zovYex43Um99I2eFCiiLejiB3Ei7/lLrLrQI9FlbAPGF2EsqcduF7StvaVKjXlSxuQzMUl+4aj222nN38XKHgK36wYZzW/N/xfqEP9J6eAqfMiv3yt8BM9KzdAF8+L6XF06Ul6LnvCj8wqJeyPMEVyLzgZ3uXiSyM9LK0aM9iHyh4RvAEFGL+Uy2ZuSvf5Qt0UE9B1KCbxDtHxomyW915mJacRC4xyUs/4GPqxmlr92OzWYhMmxHENbyfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(451199015)(71200400001)(7696005)(186003)(4326008)(66476007)(8676002)(6916009)(54906003)(66556008)(9686003)(66446008)(76116006)(64756008)(26005)(66946007)(478600001)(6506007)(41300700001)(52536014)(8936002)(5660300002)(30864003)(2906002)(83380400001)(53546011)(316002)(122000001)(38070700005)(33656002)(38100700002)(86362001)(55016003)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EVzq05Hd0l4dzdMk3n5GXua9WUostKzEw6Op1dqsO2nD2tvt0KCSyN+WbMsH?=
 =?us-ascii?Q?Hird5Y4fNNM1vIkk91F1kvD+pGET7yMgR4OKbbnmP9Okvz8HO87MBBnHjI9X?=
 =?us-ascii?Q?Mp+by3mq/0B19xLMFeqQFFB/pBZ9RJGgHYfD2O+ZK5Q9k0/jy9I2g1IARy1Q?=
 =?us-ascii?Q?JksFKl3gtZ5QzzLexY12BcBu/lIaGnwViK2sqVMWCGYIARsY6BbDz5/VZSRW?=
 =?us-ascii?Q?UDqgo0jfa+RyNorGQm+8HYdVR6IDR2/V3DHWtMkKQgDCpPK/kxODUSKI9OKQ?=
 =?us-ascii?Q?S1uEC2z38ih4fKXSCS3ozWFggyRti6IuvJpAiXeUKXWdN0iD65D3CHnK9mKf?=
 =?us-ascii?Q?pwLhuu47gaE8GQauTiHzrVpcgTN+BvJxfaPQZOVw2NLg78vCkM6F9z8d45Be?=
 =?us-ascii?Q?o4ryX6APxIyAQN0UA9YwckgSH/QtGiQgWyv3HzY6NWL9jgVGdJ0jR6qEpnaQ?=
 =?us-ascii?Q?pRoBXA+Pvuu3fxnQ3Qs9F2bt/5noComXY425xz9D9tr88aqq/xJtyLKum+Cf?=
 =?us-ascii?Q?qYcy+ab16H98DuiY8ZLN3O8uWAmPRfRYFv16D+XnN80myXY/aDVziEcJ5x39?=
 =?us-ascii?Q?PzstdHTtTfbjWtXx0j1dkLKN/z2yKbhvcc71VHLoLUzx2aXXZop+K99se7ad?=
 =?us-ascii?Q?7zhqypivF2ym6DIhtpz+P2JQIrBDmW3Fnh4d4dvAkZGqHmanCuG5DfNJPEgi?=
 =?us-ascii?Q?E+4DSdeqvOI//VoU8hrXO0giIU8gmXgHkJbot3o7SbfUavz10nWO35ebOrm6?=
 =?us-ascii?Q?fWIyDyZyplNiFzJS1G1zeWQVGZhboYgQYO9qVR6dP0w4ljMcOUP8Th50uvNo?=
 =?us-ascii?Q?stE9DPvQGf5w/jpKP4i+nZe7GjHR2bM1B0SdXuiNQ9qLxYcXDYs0Kbw3Wcwe?=
 =?us-ascii?Q?f3hiR2mwXIU1KOzHJ+zrGj9Lg6acVeLf0xs0Am1W1Yml0MV+0lY2v+qsMlL7?=
 =?us-ascii?Q?CPvQnQt91yNuNfNLb/jJ9tQ+/sSdBWS1REKvY8rvHfz2m0SYOQsHYf472Nyf?=
 =?us-ascii?Q?6fciKHvLqAva/yxXbkl9FRyvciVY4fUMrpBTP+J71y3OF8aYhR0dC+yELEjW?=
 =?us-ascii?Q?09LZvIkv3HkiavOzfjEEUBYmzLtT7zMcCxrjMv1F8tmzFFXrX+hDOLDF09+Z?=
 =?us-ascii?Q?B79lZATCitpALp7ORibQk6NyR6rSWpae5WX8xU3JDWhsgJ7tP6mEA0FNh9Io?=
 =?us-ascii?Q?JBMODvFrsi3KT92iOe7NcEo7vGxABzyeH8yyHIHwI/lNKgXp1UAX9AncIQoL?=
 =?us-ascii?Q?AIeOmexFbfhBI+M0lm+w5wywPn27lTgGvbcirHyvILDQK/6F7xX7iiaY+4U2?=
 =?us-ascii?Q?XLFfm1cXe1XUnK+1umdeJOGtnlylHRjdqsDFQg62ZzdGYbmRkKGMDDJdIGQa?=
 =?us-ascii?Q?vzAZg3O1uHCXBOrN3kJxUVJZosvx6io7JIrjbA1L/igVQTD8m1bGmDpnePVm?=
 =?us-ascii?Q?mK3tYyGLfav7jianoJTnubzu4XvdNop3qAtPNanhWhoXAoNDOUr7myLy5yND?=
 =?us-ascii?Q?wYVzZHrlsH6w8DXjyf6aqN9vEQUR5XksNF/gqI+nlbTOjo0g/V3b0t6y9PIr?=
 =?us-ascii?Q?6B7vR1Sh1C6tezcTXdkJAD3eiPNoacz0PZjrALm6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aae458ce-eb6e-467a-416f-08daf7ddc8af
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 16:21:55.2640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N5AVD8ryq8vpG4XiIrfr8G7x7PcOUbPUlrsuZ5mLtr+kO2s4DoApaaC4FlfMic+clqJ3lII93Qm5ZY9c1T7zkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10489
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Any progress for this review? Thanks

> -----Original Message-----
> From: Min Li <min.li.xe@renesas.com>
> Sent: November 23, 2022 2:52 PM
> To: richardcochran@gmail.com
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; Min Li
> <min.li.xe@renesas.com>
> Subject: [PATCH net 1/2] ptp: idt82p33: Add PTP_CLK_REQ_EXTTS support
>=20
> 82P33 family of chips can trigger TOD read/write by external signal from
> one of the IN12/13/14 pins, which are set user space programs by calling
> PTP_PIN_SETFUNC through ptp_ioctl
>=20
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  drivers/ptp/ptp_idt82p33.c | 683
> +++++++++++++++++++++++++++++++++----
>  drivers/ptp/ptp_idt82p33.h |  20 +-
>  2 files changed, 640 insertions(+), 63 deletions(-)
>=20
> diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c inde=
x
> 97c1be44e323..aece499c26d4 100644
> --- a/drivers/ptp/ptp_idt82p33.c
> +++ b/drivers/ptp/ptp_idt82p33.c
> @@ -27,6 +27,8 @@ MODULE_VERSION("1.0");  MODULE_LICENSE("GPL");
> MODULE_FIRMWARE(FW_FILENAME);
>=20
> +#define EXTTS_PERIOD_MS (95)
> +
>  /* Module Parameters */
>  static u32 phase_snap_threshold =3D SNAP_THRESHOLD_NS;
> module_param(phase_snap_threshold, uint, 0); @@ -36,6 +38,8 @@
> MODULE_PARM_DESC(phase_snap_threshold,
>  static char *firmware;
>  module_param(firmware, charp, 0);
>=20
> +static struct ptp_pin_desc pin_config[MAX_PHC_PLL][MAX_TRIG_CLK];
> +
>  static inline int idt82p33_read(struct idt82p33 *idt82p33, u16 regaddr,
>  				u8 *buf, u16 count)
>  {
> @@ -121,24 +125,270 @@ static int idt82p33_dpll_set_mode(struct
> idt82p33_channel *channel,
>  	return 0;
>  }
>=20
> -static int _idt82p33_gettime(struct idt82p33_channel *channel,
> -			     struct timespec64 *ts)
> +static int idt82p33_set_tod_trigger(struct idt82p33_channel *channel,
> +				    u8 trigger, bool write)
> +{
> +	struct idt82p33 *idt82p33 =3D channel->idt82p33;
> +	int err;
> +	u8 cfg;
> +
> +	if (trigger > WR_TRIG_SEL_MAX)
> +		return -EINVAL;
> +
> +	err =3D idt82p33_read(idt82p33, channel->dpll_tod_trigger,
> +			    &cfg, sizeof(cfg));
> +
> +	if (err)
> +		return err;
> +
> +	if (write =3D=3D true)
> +		trigger =3D (trigger << WRITE_TRIGGER_SHIFT) |
> +			  (cfg & READ_TRIGGER_MASK);
> +	else
> +		trigger =3D (trigger << READ_TRIGGER_SHIFT) |
> +			  (cfg & WRITE_TRIGGER_MASK);
> +
> +	return idt82p33_write(idt82p33, channel->dpll_tod_trigger,
> +			      &trigger, sizeof(trigger));
> +}
> +
> +static int idt82p33_get_extts(struct idt82p33_channel *channel,
> +			      struct timespec64 *ts)
> +{
> +	struct idt82p33 *idt82p33 =3D channel->idt82p33;
> +	u8 buf[TOD_BYTE_COUNT];
> +	int err;
> +
> +	err =3D idt82p33_read(idt82p33, channel->dpll_tod_sts, buf,
> +sizeof(buf));
> +
> +	if (err)
> +		return err;
> +
> +	/* Since trigger is not self clearing itself, we have to poll tod_sts *=
/
> +	if (memcmp(buf, channel->extts_tod_sts, TOD_BYTE_COUNT) =3D=3D 0)
> +		return -EAGAIN;
> +
> +	memcpy(channel->extts_tod_sts, buf, TOD_BYTE_COUNT);
> +
> +	idt82p33_byte_array_to_timespec(ts, buf);
> +
> +	if (channel->discard_next_extts) {
> +		channel->discard_next_extts =3D false;
> +		return -EAGAIN;
> +	}
> +
> +	return 0;
> +}
> +
> +static int map_ref_to_tod_trig_sel(int ref, u8 *trigger) {
> +	int err =3D 0;
> +
> +	switch (ref) {
> +	case 0:
> +		*trigger =3D HW_TOD_TRIG_SEL_IN12;
> +		break;
> +	case 1:
> +		*trigger =3D HW_TOD_TRIG_SEL_IN13;
> +		break;
> +	case 2:
> +		*trigger =3D HW_TOD_TRIG_SEL_IN14;
> +		break;
> +	default:
> +		err =3D -EINVAL;
> +	}
> +
> +	return err;
> +}
> +
> +static bool is_one_shot(u8 mask)
> +{
> +	/* Treat single bit PLL masks as continuous trigger */
> +	if ((mask =3D=3D 1) || (mask =3D=3D 2))
> +		return false;
> +	else
> +		return true;
> +}
> +
> +static int arm_tod_read_with_trigger(struct idt82p33_channel *channel,
> +u8 trigger)
>  {
>  	struct idt82p33 *idt82p33 =3D channel->idt82p33;
>  	u8 buf[TOD_BYTE_COUNT];
> +	int err;
> +
> +	/* Remember the current tod_sts before setting the trigger */
> +	err =3D idt82p33_read(idt82p33, channel->dpll_tod_sts, buf,
> +sizeof(buf));
> +
> +	if (err)
> +		return err;
> +
> +	memcpy(channel->extts_tod_sts, buf, TOD_BYTE_COUNT);
> +
> +	err =3D idt82p33_set_tod_trigger(channel, trigger, false);
> +
> +	if (err)
> +		dev_err(idt82p33->dev, "%s: err =3D %d", __func__, err);
> +
> +	return err;
> +}
> +
> +static int idt82p33_extts_enable(struct idt82p33_channel *channel,
> +				 struct ptp_clock_request *rq, int on) {
> +	u8 index =3D rq->extts.index;
> +	struct idt82p33 *idt82p33;
> +	u8 mask =3D 1 << index;
> +	int err =3D 0;
> +	u8 old_mask;
>  	u8 trigger;
> +	int ref;
> +
> +	idt82p33  =3D channel->idt82p33;
> +	old_mask =3D idt82p33->extts_mask;
> +
> +	/* Reject requests with unsupported flags */
> +	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
> +				PTP_RISING_EDGE |
> +				PTP_FALLING_EDGE |
> +				PTP_STRICT_FLAGS))
> +		return -EOPNOTSUPP;
> +
> +	/* Reject requests to enable time stamping on falling edge */
> +	if ((rq->extts.flags & PTP_ENABLE_FEATURE) &&
> +	    (rq->extts.flags & PTP_FALLING_EDGE))
> +		return -EOPNOTSUPP;
> +
> +	if (index >=3D MAX_PHC_PLL)
> +		return -EINVAL;
> +
> +	if (on) {
> +		/* Return if it was already enabled */
> +		if (idt82p33->extts_mask & mask)
> +			return 0;
> +
> +		/* Use the pin configured for the channel */
> +		ref =3D ptp_find_pin(channel->ptp_clock, PTP_PF_EXTTS,
> channel->plln);
> +
> +		if (ref < 0) {
> +			dev_err(idt82p33->dev, "%s: No valid pin found for
> Pll%d!\n",
> +				__func__, channel->plln);
> +			return -EBUSY;
> +		}
> +
> +		err =3D map_ref_to_tod_trig_sel(ref, &trigger);
> +
> +		if (err) {
> +			dev_err(idt82p33->dev,
> +				"%s: Unsupported ref %d!\n", __func__, ref);
> +			return err;
> +		}
> +
> +		err =3D arm_tod_read_with_trigger(&idt82p33-
> >channel[index], trigger);
> +
> +		if (err =3D=3D 0) {
> +			idt82p33->extts_mask |=3D mask;
> +			idt82p33->channel[index].tod_trigger =3D trigger;
> +			idt82p33->event_channel[index] =3D channel;
> +			idt82p33->extts_single_shot =3D
> is_one_shot(idt82p33->extts_mask);
> +
> +			if (old_mask)
> +				return 0;
> +
> +			schedule_delayed_work(&idt82p33->extts_work,
> +
> msecs_to_jiffies(EXTTS_PERIOD_MS));
> +		}
> +	} else {
> +		idt82p33->extts_mask &=3D ~mask;
> +		idt82p33->extts_single_shot =3D is_one_shot(idt82p33-
> >extts_mask);
> +
> +		if (idt82p33->extts_mask =3D=3D 0)
> +			cancel_delayed_work(&idt82p33->extts_work);
> +	}
> +
> +	return err;
> +}
> +
> +static int idt82p33_extts_check_channel(struct idt82p33 *idt82p33, u8
> +todn) {
> +	struct idt82p33_channel *event_channel;
> +	struct ptp_clock_event event;
> +	struct timespec64 ts;
> +	int err;
> +
> +	err =3D idt82p33_get_extts(&idt82p33->channel[todn], &ts);
> +	if (err =3D=3D 0) {
> +		event_channel =3D idt82p33->event_channel[todn];
> +		event.type =3D PTP_CLOCK_EXTTS;
> +		event.index =3D todn;
> +		event.timestamp =3D timespec64_to_ns(&ts);
> +		ptp_clock_event(event_channel->ptp_clock,
> +				&event);
> +	}
> +	return err;
> +}
> +
> +static u8 idt82p33_extts_enable_mask(struct idt82p33_channel *channel,
> +				     u8 extts_mask, bool enable)
> +{
> +	struct idt82p33 *idt82p33 =3D channel->idt82p33;
> +	u8 trigger =3D channel->tod_trigger;
> +	u8 mask;
>  	int err;
> +	int i;
> +
> +	if (extts_mask =3D=3D 0)
> +		return 0;
> +
> +	if (enable =3D=3D false)
> +		cancel_delayed_work_sync(&idt82p33->extts_work);
> +
> +	for (i =3D 0; i < MAX_PHC_PLL; i++) {
> +		mask =3D 1 << i;
> +
> +		if ((extts_mask & mask) =3D=3D 0)
> +			continue;
> +
> +		if (enable) {
> +			err =3D arm_tod_read_with_trigger(&idt82p33-
> >channel[i], trigger);
> +			if (err)
> +				dev_err(idt82p33->dev,
> +					"%s: Arm ToD read trigger failed, err
> =3D %d",
> +					__func__, err);
> +		} else {
> +			err =3D idt82p33_extts_check_channel(idt82p33, i);
> +			if (err =3D=3D 0 && idt82p33->extts_single_shot)
> +				/* trigger happened so we won't re-enable it
> */
> +				extts_mask &=3D ~mask;
> +		}
> +	}
>=20
> -	trigger =3D TOD_TRIGGER(HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
> -			      HW_TOD_RD_TRIG_SEL_LSB_TOD_STS);
> +	if (enable)
> +		schedule_delayed_work(&idt82p33->extts_work,
> +				      msecs_to_jiffies(EXTTS_PERIOD_MS));
>=20
> +	return extts_mask;
> +}
> +
> +static int _idt82p33_gettime(struct idt82p33_channel *channel,
> +			     struct timespec64 *ts)
> +{
> +	struct idt82p33 *idt82p33 =3D channel->idt82p33;
> +	u8 old_mask =3D idt82p33->extts_mask;
> +	u8 buf[TOD_BYTE_COUNT];
> +	u8 new_mask =3D 0;
> +	int err;
>=20
> -	err =3D idt82p33_write(idt82p33, channel->dpll_tod_trigger,
> -			     &trigger, sizeof(trigger));
> +	/* Disable extts */
> +	if (old_mask)
> +		new_mask =3D idt82p33_extts_enable_mask(channel,
> old_mask, false);
>=20
> +	err =3D idt82p33_set_tod_trigger(channel,
> HW_TOD_RD_TRIG_SEL_LSB_TOD_STS,
> +				       false);
>  	if (err)
>  		return err;
>=20
> +	channel->discard_next_extts =3D true;
> +
>  	if (idt82p33->calculate_overhead_flag)
>  		idt82p33->start_time =3D ktime_get_raw();
>=20
> @@ -147,6 +397,10 @@ static int _idt82p33_gettime(struct
> idt82p33_channel *channel,
>  	if (err)
>  		return err;
>=20
> +	/* Re-enable extts */
> +	if (new_mask)
> +		idt82p33_extts_enable_mask(channel, new_mask, true);
> +
>  	idt82p33_byte_array_to_timespec(ts, buf);
>=20
>  	return 0;
> @@ -165,19 +419,16 @@ static int _idt82p33_settime(struct
> idt82p33_channel *channel,
>  	struct timespec64 local_ts =3D *ts;
>  	char buf[TOD_BYTE_COUNT];
>  	s64 dynamic_overhead_ns;
> -	unsigned char trigger;
>  	int err;
>  	u8 i;
>=20
> -	trigger =3D TOD_TRIGGER(HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
> -			      HW_TOD_RD_TRIG_SEL_LSB_TOD_STS);
> -
> -	err =3D idt82p33_write(idt82p33, channel->dpll_tod_trigger,
> -			&trigger, sizeof(trigger));
> -
> +	err =3D idt82p33_set_tod_trigger(channel,
> HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
> +				       true);
>  	if (err)
>  		return err;
>=20
> +	channel->discard_next_extts =3D true;
> +
>  	if (idt82p33->calculate_overhead_flag) {
>  		dynamic_overhead_ns =3D ktime_to_ns(ktime_get_raw())
>  					- ktime_to_ns(idt82p33->start_time);
> @@ -202,7 +453,8 @@ static int _idt82p33_settime(struct
> idt82p33_channel *channel,
>  	return err;
>  }
>=20
> -static int _idt82p33_adjtime(struct idt82p33_channel *channel, s64
> delta_ns)
> +static int _idt82p33_adjtime_immediate(struct idt82p33_channel
> *channel,
> +				       s64 delta_ns)
>  {
>  	struct idt82p33 *idt82p33 =3D channel->idt82p33;
>  	struct timespec64 ts;
> @@ -226,6 +478,60 @@ static int _idt82p33_adjtime(struct
> idt82p33_channel *channel, s64 delta_ns)
>  	return err;
>  }
>=20
> +static int _idt82p33_adjtime_internal_triggered(struct idt82p33_channel
> *channel,
> +						s64 delta_ns)
> +{
> +	struct idt82p33 *idt82p33 =3D channel->idt82p33;
> +	char buf[TOD_BYTE_COUNT];
> +	struct timespec64 ts;
> +	const u8 delay_ns =3D 32;
> +	s32 remainder;
> +	s64 ns;
> +	int err;
> +
> +	err =3D _idt82p33_gettime(channel, &ts);
> +
> +	if (err)
> +		return err;
> +
> +	if (ts.tv_nsec > (NSEC_PER_SEC - 5 * NSEC_PER_MSEC)) {
> +		/*  Too close to miss next trigger, so skip it */
> +		mdelay(6);
> +		ns =3D (ts.tv_sec + 2) * NSEC_PER_SEC + delta_ns + delay_ns;
> +	} else
> +		ns =3D (ts.tv_sec + 1) * NSEC_PER_SEC + delta_ns + delay_ns;
> +
> +	ts =3D ns_to_timespec64(ns);
> +	idt82p33_timespec_to_byte_array(&ts, buf);
> +
> +	/*
> +	 * Store the new time value.
> +	 */
> +	err =3D idt82p33_write(idt82p33, channel->dpll_tod_cnfg, buf,
> sizeof(buf));
> +	if (err)
> +		return err;
> +
> +	/* Schedule to implement the workaround in one second */
> +	(void)div_s64_rem(delta_ns, NSEC_PER_SEC, &remainder);
> +	if (remainder !=3D 0)
> +		schedule_delayed_work(&channel->adjtime_work, HZ);
> +
> +	return idt82p33_set_tod_trigger(channel,
> HW_TOD_TRIG_SEL_TOD_PPS,
> +true); }
> +
> +static void idt82p33_adjtime_workaround(struct work_struct *work) {
> +	struct idt82p33_channel *channel =3D container_of(work,
> +							struct
> idt82p33_channel,
> +							adjtime_work.work);
> +	struct idt82p33 *idt82p33 =3D channel->idt82p33;
> +
> +	mutex_lock(idt82p33->lock);
> +	/* Workaround for TOD-to-output alignment issue */
> +	_idt82p33_adjtime_internal_triggered(channel, 0);
> +	mutex_unlock(idt82p33->lock);
> +}
> +
>  static int _idt82p33_adjfine(struct idt82p33_channel *channel, long
> scaled_ppm)  {
>  	struct idt82p33 *idt82p33 =3D channel->idt82p33; @@ -233,25
> +539,22 @@ static int _idt82p33_adjfine(struct idt82p33_channel
> *channel, long scaled_ppm)
>  	int err, i;
>  	s64 fcw;
>=20
> -	if (scaled_ppm =3D=3D channel->current_freq_ppb)
> -		return 0;
> -
>  	/*
> -	 * Frequency Control Word unit is: 1.68 * 10^-10 ppm
> +	 * Frequency Control Word unit is: 1.6861512 * 10^-10 ppm
>  	 *
>  	 * adjfreq:
> -	 *       ppb * 10^9
> -	 * FCW =3D ----------
> -	 *          168
> +	 *       ppb * 10^14
> +	 * FCW =3D -----------
> +	 *         16861512
>  	 *
>  	 * adjfine:
> -	 *       scaled_ppm * 5^12
> -	 * FCW =3D -------------
> -	 *         168 * 2^4
> +	 *       scaled_ppm * 5^12 * 10^5
> +	 * FCW =3D ------------------------
> +	 *            16861512 * 2^4
>  	 */
>=20
> -	fcw =3D scaled_ppm * 244140625ULL;
> -	fcw =3D div_s64(fcw, 2688);
> +	fcw =3D scaled_ppm * 762939453125ULL;
> +	fcw =3D div_s64(fcw, 8430756LL);
>=20
>  	for (i =3D 0; i < 5; i++) {
>  		buf[i] =3D fcw & 0xff;
> @@ -266,26 +569,84 @@ static int _idt82p33_adjfine(struct
> idt82p33_channel *channel, long scaled_ppm)
>  	err =3D idt82p33_write(idt82p33, channel->dpll_freq_cnfg,
>  			     buf, sizeof(buf));
>=20
> -	if (err =3D=3D 0)
> -		channel->current_freq_ppb =3D scaled_ppm;
> -
>  	return err;
>  }
>=20
> +/* ppb =3D scaled_ppm * 125 / 2^13 */
> +static s32 idt82p33_ddco_scaled_ppm(long current_ppm, s32 ddco_ppb) {
> +	s64 scaled_ppm =3D div_s64(((s64)ddco_ppb << 13), 125);
> +	s64 max_scaled_ppm =3D div_s64(((s64)DCO_MAX_PPB << 13), 125);
> +
> +	current_ppm +=3D scaled_ppm;
> +
> +	if (current_ppm > max_scaled_ppm)
> +		current_ppm =3D max_scaled_ppm;
> +	else if (current_ppm < -max_scaled_ppm)
> +		current_ppm =3D -max_scaled_ppm;
> +
> +	return (s32)current_ppm;
> +}
> +
> +static int idt82p33_stop_ddco(struct idt82p33_channel *channel) {
> +	int err;
> +
> +	err =3D _idt82p33_adjfine(channel, channel->current_freq);
> +	if (err)
> +		return err;
> +
> +	channel->ddco =3D false;
> +
> +	return 0;
> +}
> +
> +static int idt82p33_start_ddco(struct idt82p33_channel *channel, s32
> +delta_ns) {
> +	s32 current_ppm =3D channel->current_freq;
> +	u32 duration_ms =3D MSEC_PER_SEC;
> +	s32 ppb;
> +	int err;
> +
> +	/* If the ToD correction is less than 5 nanoseconds, then skip it.
> +	 * The error introduced by the ToD adjustment procedure would be
> bigger
> +	 * than the required ToD correction
> +	 */
> +	if (abs(delta_ns) < DDCO_THRESHOLD_NS)
> +		return 0;
> +
> +	/* For most cases, keep ddco duration 1 second */
> +	ppb =3D delta_ns;
> +	while (abs(ppb) > DCO_MAX_PPB) {
> +		duration_ms *=3D 2;
> +		ppb /=3D 2;
> +	}
> +
> +	err =3D _idt82p33_adjfine(channel,
> +				idt82p33_ddco_scaled_ppm(current_ppm,
> ppb));
> +	if (err)
> +		return err;
> +
> +	/* schedule the worker to cancel ddco */
> +	ptp_schedule_worker(channel->ptp_clock,
> +			    msecs_to_jiffies(duration_ms) - 1);
> +	channel->ddco =3D true;
> +
> +	return 0;
> +}
> +
>  static int idt82p33_measure_one_byte_write_overhead(
>  		struct idt82p33_channel *channel, s64 *overhead_ns)  {
>  	struct idt82p33 *idt82p33 =3D channel->idt82p33;
>  	ktime_t start, stop;
> +	u8 trigger =3D 0;
>  	s64 total_ns;
> -	u8 trigger;
>  	int err;
>  	u8 i;
>=20
>  	total_ns =3D 0;
>  	*overhead_ns =3D 0;
> -	trigger =3D TOD_TRIGGER(HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
> -			      HW_TOD_RD_TRIG_SEL_LSB_TOD_STS);
>=20
>  	for (i =3D 0; i < MAX_MEASURMENT_COUNT; i++) {
>=20
> @@ -307,8 +668,41 @@ static int
> idt82p33_measure_one_byte_write_overhead(
>  	return err;
>  }
>=20
> +static int idt82p33_measure_one_byte_read_overhead(
> +		struct idt82p33_channel *channel, s64 *overhead_ns) {
> +	struct idt82p33 *idt82p33 =3D channel->idt82p33;
> +	ktime_t start, stop;
> +	u8 trigger =3D 0;
> +	s64 total_ns;
> +	int err;
> +	u8 i;
> +
> +	total_ns =3D 0;
> +	*overhead_ns =3D 0;
> +
> +	for (i =3D 0; i < MAX_MEASURMENT_COUNT; i++) {
> +
> +		start =3D ktime_get_raw();
> +
> +		err =3D idt82p33_read(idt82p33, channel->dpll_tod_trigger,
> +				    &trigger, sizeof(trigger));
> +
> +		stop =3D ktime_get_raw();
> +
> +		if (err)
> +			return err;
> +
> +		total_ns +=3D ktime_to_ns(stop) - ktime_to_ns(start);
> +	}
> +
> +	*overhead_ns =3D div_s64(total_ns, MAX_MEASURMENT_COUNT);
> +
> +	return err;
> +}
> +
>  static int idt82p33_measure_tod_write_9_byte_overhead(
> -			struct idt82p33_channel *channel)
> +		struct idt82p33_channel *channel)
>  {
>  	struct idt82p33 *idt82p33 =3D channel->idt82p33;
>  	u8 buf[TOD_BYTE_COUNT];
> @@ -368,7 +762,7 @@ static int
> idt82p33_measure_settime_gettime_gap_overhead(
>=20
>  static int idt82p33_measure_tod_write_overhead(struct idt82p33_channel
> *channel)  {
> -	s64 trailing_overhead_ns, one_byte_write_ns, gap_ns;
> +	s64 trailing_overhead_ns, one_byte_write_ns, gap_ns,
> one_byte_read_ns;
>  	struct idt82p33 *idt82p33 =3D channel->idt82p33;
>  	int err;
>=20
> @@ -388,12 +782,19 @@ static int
> idt82p33_measure_tod_write_overhead(struct idt82p33_channel
> *channel)
>  	if (err)
>  		return err;
>=20
> +	err =3D idt82p33_measure_one_byte_read_overhead(channel,
> +						      &one_byte_read_ns);
> +
> +	if (err)
> +		return err;
> +
>  	err =3D idt82p33_measure_tod_write_9_byte_overhead(channel);
>=20
>  	if (err)
>  		return err;
>=20
> -	trailing_overhead_ns =3D gap_ns - (2 * one_byte_write_ns);
> +	trailing_overhead_ns =3D gap_ns - 2 * one_byte_write_ns
> +			       - one_byte_read_ns;
>=20
>  	idt82p33->tod_write_overhead_ns -=3D trailing_overhead_ns;
>=20
> @@ -462,6 +863,20 @@ static int idt82p33_sync_tod(struct
> idt82p33_channel *channel, bool enable)
>  			      &sync_cnfg, sizeof(sync_cnfg));  }
>=20
> +static long idt82p33_work_handler(struct ptp_clock_info *ptp) {
> +	struct idt82p33_channel *channel =3D
> +			container_of(ptp, struct idt82p33_channel, caps);
> +	struct idt82p33 *idt82p33 =3D channel->idt82p33;
> +
> +	mutex_lock(idt82p33->lock);
> +	(void)idt82p33_stop_ddco(channel);
> +	mutex_unlock(idt82p33->lock);
> +
> +	/* Return a negative value here to not reschedule */
> +	return -1;
> +}
> +
>  static int idt82p33_output_enable(struct idt82p33_channel *channel,
>  				  bool enable, unsigned int outn)
>  {
> @@ -524,6 +939,10 @@ static int idt82p33_enable_tod(struct
> idt82p33_channel *channel)
>  	struct timespec64 ts =3D {0, 0};
>  	int err;
>=20
> +	/* STEELAI-366 - Temporary workaround for ts2phc compatibility */
> +	if (0)
> +		err =3D idt82p33_output_mask_enable(channel, false);
> +
>  	err =3D idt82p33_measure_tod_write_overhead(channel);
>=20
>  	if (err) {
> @@ -546,14 +965,15 @@ static void
> idt82p33_ptp_clock_unregister_all(struct idt82p33 *idt82p33)
>  	u8 i;
>=20
>  	for (i =3D 0; i < MAX_PHC_PLL; i++) {
> -
>  		channel =3D &idt82p33->channel[i];
> -
> +		cancel_delayed_work_sync(&channel->adjtime_work);
>  		if (channel->ptp_clock)
>  			ptp_clock_unregister(channel->ptp_clock);
>  	}
>  }
>=20
> +
> +
>  static int idt82p33_enable(struct ptp_clock_info *ptp,
>  			   struct ptp_clock_request *rq, int on)  { @@ -564,7
> +984,8 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
>=20
>  	mutex_lock(idt82p33->lock);
>=20
> -	if (rq->type =3D=3D PTP_CLK_REQ_PEROUT) {
> +	switch (rq->type) {
> +	case PTP_CLK_REQ_PEROUT:
>  		if (!on)
>  			err =3D idt82p33_perout_enable(channel, false,
>  						     &rq->perout);
> @@ -575,6 +996,12 @@ static int idt82p33_enable(struct ptp_clock_info
> *ptp,
>  		else
>  			err =3D idt82p33_perout_enable(channel, true,
>  						     &rq->perout);
> +		break;
> +	case PTP_CLK_REQ_EXTTS:
> +		err =3D idt82p33_extts_enable(channel, rq, on);
> +		break;
> +	default:
> +		break;
>  	}
>=20
>  	mutex_unlock(idt82p33->lock);
> @@ -634,13 +1061,22 @@ static int idt82p33_adjfine(struct
> ptp_clock_info *ptp, long scaled_ppm)
>  	struct idt82p33 *idt82p33 =3D channel->idt82p33;
>  	int err;
>=20
> +	if (channel->ddco =3D=3D true)
> +		return 0;
> +
> +	if (scaled_ppm =3D=3D channel->current_freq)
> +		return 0;
> +
>  	mutex_lock(idt82p33->lock);
>  	err =3D _idt82p33_adjfine(channel, scaled_ppm);
> +
> +	if (err =3D=3D 0)
> +		channel->current_freq =3D scaled_ppm;
>  	mutex_unlock(idt82p33->lock);
> +
>  	if (err)
>  		dev_err(idt82p33->dev,
>  			"Failed in %s with err %d!\n", __func__, err);
> -
>  	return err;
>  }
>=20
> @@ -651,14 +1087,21 @@ static int idt82p33_adjtime(struct
> ptp_clock_info *ptp, s64 delta_ns)
>  	struct idt82p33 *idt82p33 =3D channel->idt82p33;
>  	int err;
>=20
> +	if (channel->ddco =3D=3D true)
> +		return -EBUSY;
> +
>  	mutex_lock(idt82p33->lock);
>=20
>  	if (abs(delta_ns) < phase_snap_threshold) {
> +		err =3D idt82p33_start_ddco(channel, delta_ns);
>  		mutex_unlock(idt82p33->lock);
> -		return 0;
> +		return err;
>  	}
>=20
> -	err =3D _idt82p33_adjtime(channel, delta_ns);
> +	/* Use more accurate internal 1pps triggered write first */
> +	err =3D _idt82p33_adjtime_internal_triggered(channel, delta_ns);
> +	if (err && delta_ns > IMMEDIATE_SNAP_THRESHOLD_NS)
> +		err =3D _idt82p33_adjtime_immediate(channel, delta_ns);
>=20
>  	mutex_unlock(idt82p33->lock);
>=20
> @@ -703,8 +1146,10 @@ static int idt82p33_settime(struct ptp_clock_info
> *ptp,
>  	return err;
>  }
>=20
> -static int idt82p33_channel_init(struct idt82p33_channel *channel, int
> index)
> +static int idt82p33_channel_init(struct idt82p33 *idt82p33, u32 index)
>  {
> +	struct idt82p33_channel *channel =3D &idt82p33->channel[index];
> +
>  	switch (index) {
>  	case 0:
>  		channel->dpll_tod_cnfg =3D DPLL1_TOD_CNFG; @@ -730,22
> +1175,60 @@ static int idt82p33_channel_init(struct idt82p33_channel
> *channel, int index)
>  		return -EINVAL;
>  	}
>=20
> -	channel->current_freq_ppb =3D 0;
> +	channel->plln =3D index;
> +	channel->current_freq =3D 0;
> +	channel->idt82p33 =3D idt82p33;
> +	INIT_DELAYED_WORK(&channel->adjtime_work,
> +idt82p33_adjtime_workaround);
> +
> +	return 0;
> +}
>=20
> +static int idt82p33_verify_pin(struct ptp_clock_info *ptp, unsigned int =
pin,
> +			       enum ptp_pin_function func, unsigned int chan)
> {
> +	switch (func) {
> +	case PTP_PF_NONE:
> +	case PTP_PF_EXTTS:
> +		break;
> +	case PTP_PF_PEROUT:
> +	case PTP_PF_PHYSYNC:
> +		return -1;
> +	}
>  	return 0;
>  }
>=20
> -static void idt82p33_caps_init(struct ptp_clock_info *caps)
> +static void idt82p33_caps_init(u32 index, struct ptp_clock_info *caps,
> +			       struct ptp_pin_desc *pin_cfg, u8 max_pins)
>  {
> +	struct ptp_pin_desc *ppd;
> +	int i;
> +
>  	caps->owner =3D THIS_MODULE;
>  	caps->max_adj =3D DCO_MAX_PPB;
> -	caps->n_per_out =3D 11;
> -	caps->adjphase =3D idt82p33_adjwritephase;
> +	caps->n_per_out =3D MAX_PER_OUT;
> +	caps->n_ext_ts =3D MAX_PHC_PLL,
> +	caps->n_pins =3D max_pins,
> +	caps->adjphase =3D idt82p33_adjwritephase,
>  	caps->adjfine =3D idt82p33_adjfine;
>  	caps->adjtime =3D idt82p33_adjtime;
>  	caps->gettime64 =3D idt82p33_gettime;
>  	caps->settime64 =3D idt82p33_settime;
>  	caps->enable =3D idt82p33_enable;
> +	caps->verify =3D idt82p33_verify_pin;
> +	caps->do_aux_work =3D idt82p33_work_handler;
> +
> +	snprintf(caps->name, sizeof(caps->name), "IDT 82P33 PLL%u",
> index);
> +
> +	caps->pin_config =3D pin_cfg;
> +
> +	for (i =3D 0; i < max_pins; ++i) {
> +		ppd =3D &pin_cfg[i];
> +
> +		ppd->index =3D i;
> +		ppd->func =3D PTP_PF_NONE;
> +		ppd->chan =3D index;
> +		snprintf(ppd->name, sizeof(ppd->name), "in%d", 12 + i);
> +	}
>  }
>=20
>  static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
> @@ -758,7 +1241,7 @@ static int idt82p33_enable_channel(struct
> idt82p33 *idt82p33, u32 index)
>=20
>  	channel =3D &idt82p33->channel[index];
>=20
> -	err =3D idt82p33_channel_init(channel, index);
> +	err =3D idt82p33_channel_init(idt82p33, index);
>  	if (err) {
>  		dev_err(idt82p33->dev,
>  			"Channel_init failed in %s with err %d!\n", @@ -
> 766,11 +1249,8 @@ static int idt82p33_enable_channel(struct idt82p33
> *idt82p33, u32 index)
>  		return err;
>  	}
>=20
> -	channel->idt82p33 =3D idt82p33;
> -
> -	idt82p33_caps_init(&channel->caps);
> -	snprintf(channel->caps.name, sizeof(channel->caps.name),
> -		 "IDT 82P33 PLL%u", index);
> +	idt82p33_caps_init(index, &channel->caps,
> +			   pin_config[index], MAX_TRIG_CLK);
>=20
>  	channel->ptp_clock =3D ptp_clock_register(&channel->caps, NULL);
>=20
> @@ -805,17 +1285,46 @@ static int idt82p33_enable_channel(struct
> idt82p33 *idt82p33, u32 index)
>  	return 0;
>  }
>=20
> +static int idt82p33_reset(struct idt82p33 *idt82p33, bool cold) {
> +	int err;
> +	u8 cfg =3D SOFT_RESET_EN;
> +
> +	if (cold =3D=3D true)
> +		goto cold_reset;
> +
> +	err =3D idt82p33_read(idt82p33, REG_SOFT_RESET, &cfg, sizeof(cfg));
> +	if (err) {
> +		dev_err(idt82p33->dev,
> +			"Soft reset failed with err %d!\n", err);
> +		return err;
> +	}
> +
> +	cfg |=3D SOFT_RESET_EN;
> +
> +cold_reset:
> +	err =3D idt82p33_write(idt82p33, REG_SOFT_RESET, &cfg, sizeof(cfg));
> +	if (err)
> +		dev_err(idt82p33->dev,
> +			"Cold reset failed with err %d!\n", err);
> +	return err;
> +}
> +
>  static int idt82p33_load_firmware(struct idt82p33 *idt82p33)  {
> +	char fname[128] =3D FW_FILENAME;
>  	const struct firmware *fw;
>  	struct idt82p33_fwrc *rec;
>  	u8 loaddr, page, val;
>  	int err;
>  	s32 len;
>=20
> -	dev_dbg(idt82p33->dev, "requesting firmware '%s'\n",
> FW_FILENAME);
> +	if (firmware) /* module parameter */
> +		snprintf(fname, sizeof(fname), "%s", firmware);
> +
> +	dev_info(idt82p33->dev, "requesting firmware '%s'\n", fname);
>=20
> -	err =3D request_firmware(&fw, FW_FILENAME, idt82p33->dev);
> +	err =3D request_firmware(&fw, fname, idt82p33->dev);
>=20
>  	if (err) {
>  		dev_err(idt82p33->dev,
> @@ -863,6 +1372,46 @@ static int idt82p33_load_firmware(struct
> idt82p33 *idt82p33)
>  	return err;
>  }
>=20
> +static void idt82p33_extts_check(struct work_struct *work) {
> +	struct idt82p33 *idt82p33 =3D container_of(work, struct idt82p33,
> +						 extts_work.work);
> +	struct idt82p33_channel *channel;
> +	int err;
> +	u8 mask;
> +	int i;
> +
> +	if (idt82p33->extts_mask =3D=3D 0)
> +		return;
> +
> +	mutex_lock(idt82p33->lock);
> +
> +	for (i =3D 0; i < MAX_PHC_PLL; i++) {
> +		mask =3D 1 << i;
> +
> +		if ((idt82p33->extts_mask & mask) =3D=3D 0)
> +			continue;
> +
> +		err =3D idt82p33_extts_check_channel(idt82p33, i);
> +
> +		if (err =3D=3D 0) {
> +			/* trigger clears itself, so clear the mask */
> +			if (idt82p33->extts_single_shot) {
> +				idt82p33->extts_mask &=3D ~mask;
> +			} else {
> +				/* Re-arm */
> +				channel =3D &idt82p33->channel[i];
> +				arm_tod_read_with_trigger(channel,
> channel->tod_trigger);
> +			}
> +		}
> +	}
> +
> +	if (idt82p33->extts_mask)
> +		schedule_delayed_work(&idt82p33->extts_work,
> +				      msecs_to_jiffies(EXTTS_PERIOD_MS));
> +
> +	mutex_unlock(idt82p33->lock);
> +}
>=20
>  static int idt82p33_probe(struct platform_device *pdev)  { @@ -885,25
> +1434,33 @@ static int idt82p33_probe(struct platform_device *pdev)
>  	idt82p33->pll_mask =3D DEFAULT_PLL_MASK;
>  	idt82p33->channel[0].output_mask =3D
> DEFAULT_OUTPUT_MASK_PLL0;
>  	idt82p33->channel[1].output_mask =3D
> DEFAULT_OUTPUT_MASK_PLL1;
> +	idt82p33->extts_mask =3D 0;
> +	INIT_DELAYED_WORK(&idt82p33->extts_work,
> idt82p33_extts_check);
>=20
>  	mutex_lock(idt82p33->lock);
>=20
> -	err =3D idt82p33_load_firmware(idt82p33);
> +	/* cold reset before loading firmware */
> +	idt82p33_reset(idt82p33, true);
>=20
> +	err =3D idt82p33_load_firmware(idt82p33);
>  	if (err)
>  		dev_warn(idt82p33->dev,
>  			 "loading firmware failed with %d\n", err);
>=20
> +	/* soft reset after loading firmware */
> +	idt82p33_reset(idt82p33, false);
> +
>  	if (idt82p33->pll_mask) {
>  		for (i =3D 0; i < MAX_PHC_PLL; i++) {
> -			if (idt82p33->pll_mask & (1 << i)) {
> +			if (idt82p33->pll_mask & (1 << i))
>  				err =3D idt82p33_enable_channel(idt82p33, i);
> -				if (err) {
> -					dev_err(idt82p33->dev,
> -						"Failed in %s with err %d!\n",
> -						__func__, err);
> -					break;
> -				}
> +			else
> +				err =3D idt82p33_channel_init(idt82p33, i);
> +			if (err) {
> +				dev_err(idt82p33->dev,
> +					"Failed in %s with err %d!\n",
> +					__func__, err);
> +				break;
>  			}
>  		}
>  	} else {
> @@ -928,6 +1485,8 @@ static int idt82p33_remove(struct
> platform_device *pdev)  {
>  	struct idt82p33 *idt82p33 =3D platform_get_drvdata(pdev);
>=20
> +	cancel_delayed_work_sync(&idt82p33->extts_work);
> +
>  	idt82p33_ptp_clock_unregister_all(idt82p33);
>=20
>  	return 0;
> diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h inde=
x
> 0ea1c35c0f9f..cddebf05a5b9 100644
> --- a/drivers/ptp/ptp_idt82p33.h
> +++ b/drivers/ptp/ptp_idt82p33.h
> @@ -13,6 +13,8 @@
>=20
>  #define FW_FILENAME	"idt82p33xxx.bin"
>  #define MAX_PHC_PLL	(2)
> +#define MAX_TRIG_CLK	(3)
> +#define MAX_PER_OUT	(11)
>  #define TOD_BYTE_COUNT	(10)
>  #define DCO_MAX_PPB     (92000)
>  #define MAX_MEASURMENT_COUNT	(5)
> @@ -60,8 +62,18 @@ struct idt82p33_channel {
>  	struct ptp_clock	*ptp_clock;
>  	struct idt82p33		*idt82p33;
>  	enum pll_mode		pll_mode;
> -	s32			current_freq_ppb;
> +	/* Workaround for TOD-to-output alignment issue */
> +	struct delayed_work	adjtime_work;
> +	s32			current_freq;
> +	/* double dco mode */
> +	bool			ddco;
>  	u8			output_mask;
> +	/* last input trigger for extts */
> +	u8			tod_trigger;
> +	bool			discard_next_extts;
> +	u8			plln;
> +	/* remember last tod_sts for extts */
> +	u8			extts_tod_sts[TOD_BYTE_COUNT];
>  	u16			dpll_tod_cnfg;
>  	u16			dpll_tod_trigger;
>  	u16			dpll_tod_sts;
> @@ -76,6 +88,12 @@ struct idt82p33 {
>  	struct idt82p33_channel	channel[MAX_PHC_PLL];
>  	struct device		*dev;
>  	u8			pll_mask;
> +	/* Polls for external time stamps */
> +	u8			extts_mask;
> +	bool			extts_single_shot;
> +	struct delayed_work	extts_work;
> +	/* Remember the ptp channel to report extts */
> +	struct idt82p33_channel	*event_channel[MAX_PHC_PLL];
>  	/* Mutex to protect operations from being interrupted */
>  	struct mutex		*lock;
>  	struct regmap		*regmap;
> --
> 2.37.3

