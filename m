Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4B62D1E28
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 00:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgLGXNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 18:13:22 -0500
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:17986
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbgLGXNW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 18:13:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfHEZjbe102fV9e4u+82GZyIkHNnUligB/pWBAf4F1jjfKpm6sqKotasETLBbwwKDWLIPuGlRp1qiKCcCnKHGtFsMBHplR/3AE+lbBUs63+8CBtfetifOA4InY+ailz31rcKpSlu/ruMwpgkxCdlYmMLGIzPwrpfVse/cde4vD1hH/rGaZ5OGL++4gDd4X3XyK3aGCBL6vCxOmUDtJxmtxwD+9aErlGw6njrVtWEu26YeqkusVE7/wfmUsQo1GYeJpwRc1do+aVAposahTaeM2VmV+HgDV4Z3lh38t/bJBl4Qw5b6nc7W2144KhxxsmbN79RjXpauI9BPGdF+z+/Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRTpSxdNBemMwgUtSrvpl4ZzfLpcKClhZX8sVHoOngo=;
 b=BIzqtUtKTb+TMEdeFCaFbotokMAU6rAKBM9G82stPMGc1DjBUR3/LCjpAKVHR3sbiTkZOnC1TmmMSqdPwoeUU916gzLjTKUoFlv8ko8PM5hoo2MiVKgSLP5U9fEo6gnteQcgytNpa2HfM1T/wlVtKxq+Eat1xXhM96OgvHFFzjOjjRQOl45qzejyRZ5RwxEqewhjYp7A7fd+pzcScZcI+A2cu/fy4xLL2duqRmyNupU9UjgKTH2Vic4R1A/Py/HZvHILBdKz0dsiBVIyg7PMAL0pdJtTKcuwtY0PhpJ/7wYph9flTJ8oHQfGqKdE3yHjSJE03hbTmCgIhPmZOjrrpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRTpSxdNBemMwgUtSrvpl4ZzfLpcKClhZX8sVHoOngo=;
 b=NDG+X+xuc+o8BS8ywaopt7bB/monWHXR+v2+FjeqKVfGuXdYA2qy2AQnWFFAs7Fz5s8PJPnrMEhPbb6ZFFHBs4A2GjTMy9ipd9+TT9wVg4q4BRVCrxRUJcJVknl/YgVlBVSMoCRY+6MmRHXBg8pChIi4VWWhVIpJ4+d13EpAENg=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2511.eurprd04.prod.outlook.com (2603:10a6:800:50::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 23:12:31 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 23:12:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next v1 0/9] ethtool: Add support for frame preemption
Thread-Topic: [PATCH net-next v1 0/9] ethtool: Add support for frame
 preemption
Thread-Index: AQHWyGcjTxqNudxW/Uq5xtWOatYXManozWWAgAN4RICAAAZnAA==
Date:   Mon, 7 Dec 2020 23:12:31 +0000
Message-ID: <20201207231230.3avhe6yqklsbxsiz@skbuf>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
 <20201205095021.36e1a24d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <87o8j5z0xs.fsf@intel.com>
In-Reply-To: <87o8j5z0xs.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1c02e29c-a37a-4286-0142-08d89b0592ae
x-ms-traffictypediagnostic: VI1PR0401MB2511:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2511D59A319ED409B105006DE0CE0@VI1PR0401MB2511.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kyt8wCAtetBDEiZe3hG3loIAFtsSPdg95sU9pa2dHPPNNPGUHrrKIza+m/UDdv98ts253sJ+Go7kzFixWY47lQlCLt9NHfXCggQsCOc95b6Nq6EbC4IVZWj4ESt/UKYOxPYYg4v+OdGnqhJU9sraPbgMHoYm1oQwEeNM9CH4pwwYiuxogpDJaEVokIhqr2tlcyR/YRUq1Lnf0aVzt3/od7+1kjmT9JxAsqemDG1htCrf5WCssHMM34INa67rGVS9XIuiAcueElUoNH468ic3ieczqoug5I8ymaTiaPx9gEL22YWh+zYdL3fUthkOy7YEkusoyTt51p2Im0S64W0zkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(136003)(346002)(376002)(54906003)(86362001)(5660300002)(76116006)(6486002)(6916009)(2906002)(66556008)(66946007)(9686003)(91956017)(33716001)(1076003)(66476007)(66446008)(83380400001)(64756008)(7416002)(8936002)(8676002)(26005)(6512007)(44832011)(508600001)(4326008)(71200400001)(6506007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZyulpqsCfKeb1450f6XeON1PZstN9Fj/hPypKc2cBusX9XDZ/a3rvB3bNC01?=
 =?us-ascii?Q?VnO0pYf/qXopiK/7ZMys/7MExhOunHMN2nyhVajESEiE5q+LNLeXDBo4Ys1M?=
 =?us-ascii?Q?BQzgtOA7xsVJYjnnaj7XFExzqYbkLG+6pdhSjAdrbbIkSBzelBFPc6t/ybDn?=
 =?us-ascii?Q?Wp6TuFEWp51IrIKavmodpDzCwgeoN9I51qBjYEeYZDg7j8vRLHH+oR66i6Ol?=
 =?us-ascii?Q?BtXDsfArB3uHLVc6wWWqxx6RDT3f3iZXlQ3MmtborpsRX9xzm0sx2K4HTHz4?=
 =?us-ascii?Q?YtSzsJ2cYGu04DICVRQHim6jeEEacZsxyGIvNfSA8Kj7omWWyLEN4wjAq4Rg?=
 =?us-ascii?Q?gWHCJh731KYuo4sQ4zsnhEJKTbpmo61R6fdfihmhz33+HZ1Exj36TXe+2up+?=
 =?us-ascii?Q?XtfX4omUxkxjner8HvGHNltA6EuxH/cgTEUiFv+52sslya/gUfHRiKvo72Qg?=
 =?us-ascii?Q?rzka0rq1NKYZ9ZLBHSYJ2AuQiIvTWiGFVw/t6PVonAUKvpirBcUxSXCS0yis?=
 =?us-ascii?Q?5m80qeTq67Q5L41D/N5vc/MGXtCq3o8UmgBv1LvdHLszv6fBryXpZ85OC82k?=
 =?us-ascii?Q?dcKT9AxTw2bm16jrfVXkaQDPE4JHVe1wjoADlaSoauMm4DXkih+HLsHTOOPT?=
 =?us-ascii?Q?5OQc/iJA17HeAuShkdXZwqR6NrekM4MbGsi4pb2viG4EJg4uOyDUwgRk85sU?=
 =?us-ascii?Q?LGvW2ppG/QS81pqyNbaj5wpoEUwAQtG+d9YpJ79m/enT4kd+W0xFeD6sNawU?=
 =?us-ascii?Q?CKd+pc0n9Y5y26yVkmLSSOO3O1OOye3iBqpmVfNf/WKnx5HROqKHBRiL4bCN?=
 =?us-ascii?Q?48PFihzfFyG1EclSJufsxafjFtVEA0HjotfTUmOp2ON7nmKhZT/flrU1LdF4?=
 =?us-ascii?Q?KGnPjnsjAFpsSJieO5uMMop3EdLdLq15ZfcDv1XA6revkJvsJphtm8GJJ0Yb?=
 =?us-ascii?Q?DG2oV/A6x4SppJl1sYdDkh6EO2rQwuvyNAnuMZ7KdGRtEu7fSZuxPepUPP7Y?=
 =?us-ascii?Q?8ajn?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7FCE58176DE30A40904ACDF1D08D270B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c02e29c-a37a-4286-0142-08d89b0592ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 23:12:31.0214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sIASoWE/95+Fj8ip88jx/4MqB+i6pM2FbzBRlMF/n1A5yfl37IqUzV47xDVbEtx6XauVUXbHQUYpt/sKagBCpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 02:49:35PM -0800, Vinicius Costa Gomes wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
>
> > On Tue,  1 Dec 2020 20:53:16 -0800 Vinicius Costa Gomes wrote:
> >> $ tc qdisc replace dev $IFACE parent root handle 100 taprio \
> >>       num_tc 3 \
> >>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
> >>       queues 1@0 1@1 2@2 \
> >>       base-time $BASE_TIME \
> >>       sched-entry S 0f 10000000 \
> >>       preempt 1110 \
> >>       flags 0x2
> >>
> >> The "preempt" parameter is the only difference, it configures which
> >> queues are marked as preemptible, in this example, queue 0 is marked
> >> as "not preemptible", so it is express, the rest of the four queues
> >> are preemptible.
> >
> > Does it make more sense for the individual queues to be preemptible
> > or not, or is it better controlled at traffic class level?
> > I was looking at patch 2, and 32 queues isn't that many these days..
> > We either need a larger type there or configure this based on classes.
>
> I can set more future proof sizes for expressing the queues, sure, but
> the issue, I think, is that frame preemption has dimishing returns with
> link speed: at 2.5G the latency improvements are on the order of single
> digit microseconds. At greater speeds the improvements are even less
> noticeable.

You could look at it another way.
You can enable jumbo frames in your network, and your latency-sensitive
traffic would not suffer as long as the jumbo frames are preemptible.

> The only adapters that I see that support frame preemtion have 8 queues
> or less.
>
> The idea of configuring frame preemption based on classes is
> interesting. I will play with it, and see how it looks.

I admit I never understood why you insist on configuring TSN offloads
per hardware queue and not per traffic class.=
