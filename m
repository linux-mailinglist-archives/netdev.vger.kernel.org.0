Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3988A26F9A3
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 11:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgIRJx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 05:53:26 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:43518
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725882AbgIRJxZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 05:53:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnVt+UBDmKDhM5OULHCBmNz1pvIL4SixKHL4hDfQ65k9BRYAoULS/2czJ0ml826RPQ0fZUuwSF7w08U5uEE6qfX/724qjDpNulCp4Oj3EUGFiJpA4V8wrwOr+W3i0N1fc3RQzDxlvoFy72zDxjB5aVKU8I6AZtsOCelc/pFCUZmD0cLDZoTiuh642LXy5RPrl5IkSAPOlrhsqYb6zpP1GPu/dkBrjOaZOBtE59mXC8W29QclD+4LmKMDEQYk/txreWiPo+hnDaUZf5WMyhPy/HORPAWAIxEutj5vW5H9CtAb6MD4W6NEjePEU/apdknDNhB/i6pMbKyOFkmw/+HUaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+hk1X7btq6UbmlvLL1QtDXi6IU1oa7suJjt92SFzus=;
 b=f6ZpVs4+okwgdGIi+w40C6v5GlyCueIbeQl82QOzqQw1G3NvT08kz2gVEgaRen8wQqe58KvDjiNhMz4Z/MhorHRh9SYzNkGnvb38FACaSFHMwmdH5/CSpHbsYIM67t6FbvTtN7U4O5kwP670drXDCwi1yGTsUdQsF2NYbCspZSbL6PXRSi8LguYOE4k33ZnKw+tkuzcGC+mr/gl0Q+j3JJFcAHtA7qYfhnXohyUHzVXKID1DxchT64NzU9tFdD/r2HQDeS+WbejkH1Hf1VTQDyU2aLnvKh/eJ2ZYgs6v9L5YtN2UflmKXJ0DsChR8bhz2HN4CZpQs7EQNutnDX0c0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+hk1X7btq6UbmlvLL1QtDXi6IU1oa7suJjt92SFzus=;
 b=TmiIUQAczlrQE9CcuSD3voymfHGKdzr3Pfiujmwot2q+/Px7BjsHUrUae3U224Mr0ydVQwBL508la1CDbaXigQ10VHyzmKKURkIAq6EMsj5Fn4GbcFHzblIAqebxU/y1TktSO6epz2LcmkZkwGT7suo6GA2J9LNBSuaER1s7VWA=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM6PR0402MB3830.eurprd04.prod.outlook.com (2603:10a6:209:1d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 18 Sep
 2020 09:53:21 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99%7]) with mapi id 15.20.3391.019; Fri, 18 Sep 2020
 09:53:21 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: RE: [PATCH 2/2] ptp_qoriq: support FIPER3
Thread-Topic: [PATCH 2/2] ptp_qoriq: support FIPER3
Thread-Index: AQHWiLYnS60GwCLmLkeYj1HDTaCRqalknT0AgAmUBlA=
Date:   Fri, 18 Sep 2020 09:53:21 +0000
Message-ID: <AM7PR04MB6885A9F3BFE14C21B2F905C0F83F0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200912033006.20771-1-yangbo.lu@nxp.com>
 <20200912033006.20771-3-yangbo.lu@nxp.com>
 <20200912073548.c3yb7fe7mhi6cews@skbuf>
In-Reply-To: <20200912073548.c3yb7fe7mhi6cews@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4a8169c3-018d-45b9-e21e-08d85bb8adb2
x-ms-traffictypediagnostic: AM6PR0402MB3830:
x-microsoft-antispam-prvs: <AM6PR0402MB383084DE730A5F4C926AF4F2F83F0@AM6PR0402MB3830.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qhG+cOkHesml98GBCGDj0ddMN/s5WSn8NcBFchZTdyNelrHSVh3OLMT0XAQQihH58K1Sc/f732vV4jizyPZJ+vO0N8XugfORy3GLP8TsjY3j7AJrIFm3TeujWc35yLCV2J2/xfBG4gnhMeMzXXERwHrkgxurEEZOxg602fTpOmy0EFVuhcQtuRzUdjxyJG5rlynMZIdIedJt/dzlOzNjkxikXwfvgxUr8lxFJyPkMrZ0efLE5zoQJh9/2mWf2uJJmGN+G+DK7AbKLetgpnCku6liYBokUUTS5iReu2NtG82Wl1D2M2jxjMUbz7PfwdCawIJqkeSTaHtuuEhpWhNdzTonRg0r3uh1WPbUBeAiHWOFh+rW8IkxZPBuRykJP4iW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(396003)(346002)(376002)(136003)(6916009)(52536014)(86362001)(66446008)(64756008)(66476007)(66556008)(66946007)(76116006)(5660300002)(54906003)(478600001)(7696005)(9686003)(55016002)(33656002)(8936002)(2906002)(316002)(26005)(71200400001)(83380400001)(4326008)(53546011)(6506007)(8676002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: MqyJJQD8jgJ0W1XgrSuh4zaxVYDbnvOClCLpfudl8XwjVpVt3ncWMCGbRCnfiZhw21t+JA5qdmmbgQnq5wn0K/PNa68gDIyc/mAVmkxOoIB53lZIe+zsx7xFS8Am5U202tybciJhzffjAOUPof0x+wTcS+x2OD4I1PA4w8xYMjRDKrWCiE4X+PS9nt4Z/OAbBy2PCfroAEspMbye6o6bnPkaZSfNRHw2qF4MVPNDMD2XybCEznET847QBTc57WZ/t/64ovpbSgTiyWsBbJ73eaJn0+XeCJAnsSjuu//d3vHYMPs19XqWKfm1KKj+X1jp3WREgi7f+qfV8NIgEzJ4g15/tUR6qt1tG6S7FHZv9TJMG20sZH85BeVxGObAzgR5M0xGMt5fLHwNZ9DqxXA+/9Fsq4YP5jASLN+8a6r6AcdTc/b7JjyRcvwqlsERgAn9xnRpKqlnR0+eIigaIoStcNz+lxGidjOHcu3YpiwYjA0zpPOrTc13LdM0vMesNg19c50k4iWkxUhEMx9yc5uHTAyHQPWjpyp0+i9r24opl+Ya+HYWTf8dFIYPZfnTCJaFsE60Wh2LfoqvbbPan0FYuqWmaCy1QoWb+0vLYJPtAP/b7/nvdeZC03zyFmVxsWj2YtlxxGw+mg6aiOmoqr4p3A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a8169c3-018d-45b9-e21e-08d85bb8adb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 09:53:21.8838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aMBxcsoXzWbU9JTqntw9SgAazV7PIYnhImzzO9uW5/3HS58+TaGXhMRukRciGDPY3BH7C3DDyV7y6uBVOyT5ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3830
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Saturday, September 12, 2020 3:36 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: netdev@vger.kernel.org; devicetree@vger.kernel.org; David S . Miller
> <davem@davemloft.net>; Richard Cochran <richardcochran@gmail.com>; Rob
> Herring <robh+dt@kernel.org>; Mark Rutland <mark.rutland@arm.com>
> Subject: Re: [PATCH 2/2] ptp_qoriq: support FIPER3
>=20
> Hi Yangbo,
>=20
> On Sat, Sep 12, 2020 at 11:30:06AM +0800, Yangbo Lu wrote:
> > The FIPER3 (fixed interval period pulse generator) is supported on
> > DPAA2 and ENETC network controller hardware. This patch is to support
> > it in ptp_qoriq driver.
> >
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> > ---
> >  drivers/ptp/ptp_qoriq.c       | 23 ++++++++++++++++++++++-
> >  include/linux/fsl/ptp_qoriq.h |  3 +++
> >  2 files changed, 25 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
> > index c09c16be..68beb1b 100644
> > --- a/drivers/ptp/ptp_qoriq.c
> > +++ b/drivers/ptp/ptp_qoriq.c
> > @@ -72,6 +72,10 @@ static void set_fipers(struct ptp_qoriq *ptp_qoriq)
> >  	set_alarm(ptp_qoriq);
> >  	ptp_qoriq->write(&regs->fiper_regs->tmr_fiper1, ptp_qoriq->tmr_fiper1=
);
> >  	ptp_qoriq->write(&regs->fiper_regs->tmr_fiper2, ptp_qoriq->tmr_fiper2=
);
> > +
> > +	if (ptp_qoriq->fiper3_support)
> > +		ptp_qoriq->write(&regs->fiper_regs->tmr_fiper3,
> > +				 ptp_qoriq->tmr_fiper3);
> >  }
> >
> >  int extts_clean_up(struct ptp_qoriq *ptp_qoriq, int index, bool
> update_event)
> > @@ -366,6 +370,7 @@ static u32 ptp_qoriq_nominal_freq(u32 clk_src)
> >   *   "fsl,tmr-add"
> >   *   "fsl,tmr-fiper1"
> >   *   "fsl,tmr-fiper2"
> > + *   "fsl,tmr-fiper3" (required only for DPAA2 and ENETC hardware)
> >   *   "fsl,max-adj"
> >   *
> >   * Return 0 if success
> > @@ -412,6 +417,7 @@ static int ptp_qoriq_auto_config(struct ptp_qoriq
> *ptp_qoriq,
> >  	ptp_qoriq->tmr_add =3D freq_comp;
> >  	ptp_qoriq->tmr_fiper1 =3D DEFAULT_FIPER1_PERIOD -
> ptp_qoriq->tclk_period;
> >  	ptp_qoriq->tmr_fiper2 =3D DEFAULT_FIPER2_PERIOD -
> ptp_qoriq->tclk_period;
> > +	ptp_qoriq->tmr_fiper3 =3D DEFAULT_FIPER3_PERIOD -
> ptp_qoriq->tclk_period;
> >
> >  	/* max_adj =3D 1000000000 * (freq_ratio - 1.0) - 1
> >  	 * freq_ratio =3D reference_clock_freq / nominal_freq
> > @@ -446,6 +452,13 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq,
> void __iomem *base,
> >  	else
> >  		ptp_qoriq->extts_fifo_support =3D false;
> >
> > +	if (of_device_is_compatible(node, "fsl,dpaa2-ptp") ||
> > +	    of_device_is_compatible(node, "fsl,enetc-ptp")) {
> > +		ptp_qoriq->fiper3_support =3D true;
> > +	} else {
> > +		ptp_qoriq->fiper3_support =3D false;
> > +	}
>=20
> Since struct ptp_qoriq is kzalloc()-ed, maybe you can skip the "else"
> branch?

Right. Let me remove it.

>=20
> > +
> >  	if (of_property_read_u32(node,
> >  				 "fsl,tclk-period", &ptp_qoriq->tclk_period) ||
> >  	    of_property_read_u32(node,
> > @@ -457,7 +470,10 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq,
> void __iomem *base,
> >  	    of_property_read_u32(node,
> >  				 "fsl,tmr-fiper2", &ptp_qoriq->tmr_fiper2) ||
> >  	    of_property_read_u32(node,
> > -				 "fsl,max-adj", &ptp_qoriq->caps.max_adj)) {
> > +				 "fsl,max-adj", &ptp_qoriq->caps.max_adj) ||
> > +	    (of_property_read_u32(node,
> > +				 "fsl,tmr-fiper3", &ptp_qoriq->tmr_fiper3) &&
> > +	     ptp_qoriq->fiper3_support)) {
>=20
> Could you check for the "ptp_qoriq->fiper3_support" boolean first, so
> that a useless device tree property lookup is not performed?

Ok.

>=20
> >  		pr_warn("device tree node missing required elements, try automatic
> configuration\n");
> >
> >  		if (ptp_qoriq_auto_config(ptp_qoriq, node))
> > @@ -502,6 +518,11 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq,
> void __iomem *base,
> >  	ptp_qoriq->write(&regs->ctrl_regs->tmr_prsc, ptp_qoriq->tmr_prsc);
> >  	ptp_qoriq->write(&regs->fiper_regs->tmr_fiper1, ptp_qoriq->tmr_fiper1=
);
> >  	ptp_qoriq->write(&regs->fiper_regs->tmr_fiper2, ptp_qoriq->tmr_fiper2=
);
> > +
> > +	if (ptp_qoriq->fiper3_support)
> > +		ptp_qoriq->write(&regs->fiper_regs->tmr_fiper3,
> > +				 ptp_qoriq->tmr_fiper3);
> > +
> >  	set_alarm(ptp_qoriq);
> >  	ptp_qoriq->write(&regs->ctrl_regs->tmr_ctrl,
> >  			 tmr_ctrl|FIPERST|RTPE|TE|FRD);
> > diff --git a/include/linux/fsl/ptp_qoriq.h b/include/linux/fsl/ptp_qori=
q.h
> > index 884b8f8..01acebe 100644
> > --- a/include/linux/fsl/ptp_qoriq.h
> > +++ b/include/linux/fsl/ptp_qoriq.h
> > @@ -136,6 +136,7 @@ struct ptp_qoriq_registers {
> >  #define DEFAULT_TMR_PRSC	2
> >  #define DEFAULT_FIPER1_PERIOD	1000000000
> >  #define DEFAULT_FIPER2_PERIOD	1000000000
> > +#define DEFAULT_FIPER3_PERIOD	1000000000
> >
> >  struct ptp_qoriq {
> >  	void __iomem *base;
> > @@ -147,6 +148,7 @@ struct ptp_qoriq {
> >  	struct dentry *debugfs_root;
> >  	struct device *dev;
> >  	bool extts_fifo_support;
> > +	bool fiper3_support;
> >  	int irq;
> >  	int phc_index;
> >  	u32 tclk_period;  /* nanoseconds */
> > @@ -155,6 +157,7 @@ struct ptp_qoriq {
> >  	u32 cksel;
> >  	u32 tmr_fiper1;
> >  	u32 tmr_fiper2;
> > +	u32 tmr_fiper3;
> >  	u32 (*read)(unsigned __iomem *addr);
> >  	void (*write)(unsigned __iomem *addr, u32 val);
> >  };
> > --
> > 2.7.4
> >
>=20
> With that,
>=20
> Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Thanks for doing this!
> -Vladimir
