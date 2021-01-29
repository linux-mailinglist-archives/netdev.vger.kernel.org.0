Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27CA309086
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhA2XQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 18:16:59 -0500
Received: from mail-eopbgr40069.outbound.protection.outlook.com ([40.107.4.69]:12816
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231174AbhA2XQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 18:16:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTzDCdz0q1oaIyU+ZG5fbeNDUdUwYka4UZ6WJaMP+BCq1D4yRQ4UFtG9samjEksyO9hS7ChZpuPRG4p9YBMB3VhYc+ujxyQ/bNMt2Kb2pf81a/nNLvcg1RXAJzUgfK+jtsJGlDU3dwIHEsYdSKJVEsiBCdPxXGu0NyUew1jCYkf4T7xoF2kWuIYl2F8WrjaK17u1qSWt5XbGjguqAdLbaSs12tR2CkKvE7dwkecoGk5FpqQDcrbTITVxW6dmcC+czTu89ODSkTsLANDKcyJDZzxnGnnjTqkm97Z//Jls8cIG5CASczF0da9cbaz2dBdLaqV/r6rUA/2RYjzGIqdgBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/dwi8Tt6C9PvToYTwI+YFHmyiGK50JpOqV4t+vFJ/E=;
 b=ED4gcWJUt4JSrqObLKHJZj+F12diWwiTBqJlIhPvHAOaVr35PpP+LoQuOSlAPoBPSgj5y3ggszSd24SPnq4SuDvt7BQbidQ0MFd4AO1XDwIodK+Cw9++DIFFUaAmbZwHZOdo60u1klbjhZHvUPisMN+NH6k/9FtBFFGRpXyJSdV6uVfwmBrQQPyQ6mKyMR8+8taWzkLlGI64lvdI573mK1/+ukdBlacgiIIRvSc0hAv1UbkgvNwB5tHBRCmDIUtzPZqRcrfpKfBP1PO9MdVx3y+Tp/6p/mVMBLGGj3kYxJ6xJgBLiPFepedeF1OgfR3AFmcQ9q/KSc+R4KmTxnPviA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/dwi8Tt6C9PvToYTwI+YFHmyiGK50JpOqV4t+vFJ/E=;
 b=UugP+IewaUK9blu7t94mxSI94sPGImTcjM2oIXL9R+SdkpLoj+w+jP/gVj67Z0OBo0nSTbwRk4eC6pHrRznYU8yUvdmWOIlpUCrnk/4nch3JIUZmK0NTEgZeM8kLpAkdyYtBBBRFObyf2RFZ37imIlYb0tmq7MCH7P0E8DWudI8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3199.eurprd04.prod.outlook.com (2603:10a6:802:3::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 23:16:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%6]) with mapi id 15.20.3805.017; Fri, 29 Jan 2021
 23:16:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 6/8] igc: Add support for tuning frame
 preemption via ethtool
Thread-Topic: [PATCH net-next v3 6/8] igc: Add support for tuning frame
 preemption via ethtool
Thread-Index: AQHW8RBJWWRwM35MG0uYfKaT0XnEyqo5E2SAgAYVkQCAAB5YAA==
Date:   Fri, 29 Jan 2021 23:16:05 +0000
Message-ID: <20210129231604.vzndqnf3tkcgo4ya@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-7-vinicius.gomes@intel.com>
 <20210126003243.x3c44pmxmieqsa6e@skbuf>
 <87pn1nsabj.fsf@vcostago-mobl2.amr.corp.intel.com>
In-Reply-To: <87pn1nsabj.fsf@vcostago-mobl2.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e8bf8440-fc44-40e7-58b3-08d8c4abdaa3
x-ms-traffictypediagnostic: VI1PR04MB3199:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB3199076BEC1390F0C2B7FCDDE0B99@VI1PR04MB3199.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cyBhF2sa7s0i5bV8lSx6baUVWTkJVz97cLqQuMT2/XNwP+ICaQ1JRQqU3F+tiZ3FPY18eq0C/Y99ZWdXmHVMPVT+8bF4SZYnnt/Sypi7dNo5lfegsHwi4i/jfrbelxWcs5oZnNAh2F6NR5jh+/QuPdiNmC8Bi7ecoyqSY+YJuH9R38GBQP2B1kZedGNYC/U8nVqfomh+SUMCwqe2sxXvXqvxojfF2Uj405ezkDmggvhND9/qwKpQ0Tx0g2kiKiLoWK3/IpmIqUPuhNqoIAE/aoCdvowGLigP971Mfy/1s8nGHZ8imlDcUKu7TpxSDcC7gc3wUpRCd0mTfvkqpFnbmM4EX4OTwR7xgffxoEvFVyBr6+V3k02VzBqCnWVlxD/a0yI2RneR7jj6O1HuRRxrEyUN5geYuwR+LKwmUyYzMD5rWpPfGGvlint4C/U8cb+HwGSwkv+DxrqHsXFdFzONQOEmTa91Af6oEya2tZK4oISfbta/q9g6Z7pftoum8LVzqxFNjRDdKefjAJ87r53zkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(86362001)(6916009)(8936002)(7416002)(2906002)(54906003)(9686003)(6512007)(33716001)(44832011)(8676002)(26005)(478600001)(6486002)(4326008)(66946007)(66476007)(76116006)(316002)(66446008)(64756008)(6506007)(186003)(71200400001)(1076003)(66556008)(83380400001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9tOJCYHR2SbF7b5pZWjppn4mKkiklyCx2OMucYQkIE50c0GTJgui7LyaHP1y?=
 =?us-ascii?Q?wKYr6pB4x4EQtihs2XI6OZdj4UrcfA7q4eJYRUYuXNgTfshmNvoHfXBsZ/3m?=
 =?us-ascii?Q?jNy7Ye5TLALVe+RmyhrxrJGCT4tH4UDmV6WEiuQlheBIitnT8pxw4vqECuKP?=
 =?us-ascii?Q?8ljpMjNjxUcQzRcY5YZDMBKuLD0l7J9uCsN0OQqNVnyPTYTMUQK/B2Gxb566?=
 =?us-ascii?Q?XPrBx3/xG/gAD1epFzKyHS5ZXMwPQAgCp6ex2t95KhrcrOClDdjkdPVg3p3T?=
 =?us-ascii?Q?L0GC8m1+KKBkt7bCmpsMLo6m7439IhWCkF9bq1cesLH+AYWgZKdd/UOQ7q2n?=
 =?us-ascii?Q?I1AuzkdLOzXk/bgbmkom76kXVlHpsbyAWqhYLbq2T+jrvbUPRXSGKTszuCVF?=
 =?us-ascii?Q?x+vNdXrKIPt4IIKObxXDpFMjMubyAkkjq5U2fGsYKYqYN+jkX3AN+kv/ocvF?=
 =?us-ascii?Q?P8gvmNsx4vmg5/GU1987aChnEWNQlrvsZyB4GyP+5rwB71YuXN6YBhBy5VDH?=
 =?us-ascii?Q?OLLpe0kP9cG8ox0Wl/6L7NK2PYvKHjZ7waFGgZyjWmwXbT0YAKvwBlkB3p3X?=
 =?us-ascii?Q?m4FEMsK+J1uYTh2Up/JZ2sZMyxMFb7YAG5F0HnkCpy4/Ob9JU+l5413kFWnB?=
 =?us-ascii?Q?htxlK0VOdsjRxpC/qYKwhU7zQT4+J87AZwRs4v+RFaeCZhsbxy7WJeKilRQL?=
 =?us-ascii?Q?Zd6OWpWk/QEKJ4y3UaVw5Qq29OXvbNkSRKU+Ek/ZbIL8ufga3BkmodUvCteR?=
 =?us-ascii?Q?WPqONhqeO9jNfY/8n1MZaTJDJ/zcDCamJk38LiA8LeRGpTLYuNmYjrrzUgEa?=
 =?us-ascii?Q?m6RRetuFQJX7pav2Thao2JVMWPIgVwx3DT7qlrFPN3iN5FeCqYREKSe0vF90?=
 =?us-ascii?Q?d1YGebTQtJOYVfYTjjJZYTRzDWEafLe/3PZWI5Vfz5N3fNffv6ACvstMPb6V?=
 =?us-ascii?Q?UaRyx1w400Z6O+xtLZ5pSB0VmdxViqEtScJDb6pGpr3WtB4hl7l9uGSg+vHW?=
 =?us-ascii?Q?8slg9Jy266+FlcRPUy72VTnEEg2K+P9ihMsw+BmmTAcmdb+N1wBIIJI+8zwF?=
 =?us-ascii?Q?wzK7qZbT?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A3A5D4D14383F4468A064388D81119CE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8bf8440-fc44-40e7-58b3-08d8c4abdaa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2021 23:16:05.8515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5R4cNQ0saOBpDMVsrQEO6v4+h94Sst883zEYwrqGINY1WInyKgGfjGWU3vwSew8uu7eGyq1tgti4kxOEq7OkCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3199
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 01:27:28PM -0800, Vinicius Costa Gomes wrote:
> >> +static int igc_ethtool_set_preempt(struct net_device *netdev,
> >> +				   struct ethtool_fp *fpcmd,
> >> +				   struct netlink_ext_ack *extack)
> >> +{
> >> +	struct igc_adapter *adapter =3D netdev_priv(netdev);
> >> +	int i;
> >> +
> >> +	if (fpcmd->add_frag_size < 68 || fpcmd->add_frag_size > 260) {
> >> +		NL_SET_ERR_MSG_MOD(extack, "Invalid value for add-frag-size");
> >> +		return -EINVAL;
> >> +	}
> >
> > This check should belong in ethtool, since there's nothing unusual abou=
t
> > this supported range.
> >
> > Also, I believe that Jakub requested the min-frag-size to be passed as
> > 0, 1, 2, 3 as the standard specifies it, and not its multiplied
> > version?
>=20
> Later, Michal Kubechek suggested using the multiplied value, to be
> future proof and less dependent on some specific standard version.

Imagine you're adding frame preemption to some LLDP agent and you want
to pass that data to the kernel. Case (a) you read the value as {0, 1,
2, 3} and you pass it to the kernel as {0, 1, 2, 3}. Case (b) you read
the value as {0, 1, 2, 3}, you prove to the kernel that you're a smart
boy and you know the times 64 multiplication table minus 4, and if you
pass the exam, the kernel calls ethtool_frag_size_to_mult again, to
retrieve the {0, 1, 2, 3} form which it'll use to program the hardware
with (oh and btw, ethtool_frag_size_to_mult allows any value to be
passed in, so it tricks users into thinking that any other value except
60, 124, 188, 252 might have a different effect, cause them to wonder
what is 123 even rounded to, etc).
And halfway through writing the user space code for case (b), you're
thinking "good thing I'm making this LLDP TLV more future-proof by
multiplying it with 64..."

Also, so shady this specific standard called IEEE 802.3-2018.....
Frame preemption is past draft status, it's safe to say it won't change
in backwards-incompatible ways, this isn't Python. If anything, we'll
give them another reason not to.

> >> +	adapter->frame_preemption_active =3D fpcmd->enabled;
> >> +	adapter->add_frag_size =3D fpcmd->add_frag_size;
> >> +
> >> +	if (!adapter->frame_preemption_active)
> >> +		goto done;
> >> +
> >> +	/* Enabling frame preemption requires TSN mode to be enabled,
> >> +	 * which requires a schedule to be active. So, if there isn't
> >> +	 * a schedule already configured, configure a simple one, with
> >> +	 * all queues open, with 1ms cycle time.
> >> +	 */
> >> +	if (adapter->base_time)
> >> +		goto done;
> >
> > Unless I'm missing something, you are interpreting an adapter->base_tim=
e
> > value of zero as "no Qbv schedule on port", as if it was invalid to hav=
e
> > a base-time of zero, which it isn't.
>=20
> This HW has specific limitations, it doesn't allow a base_time in the
> past. So a base_time of zero can be used to signify "No Qbv".

Oh and by past you mean future?

	/* If we program the controller's BASET registers with a time
	 * in the future, it will hold all the packets until that
	 * time, causing a lot of TX Hangs, so to avoid that, we
	 * reject schedules that would start in the future.
	 */
	if (!is_base_time_past(qopt->base_time, &now))
		return false;

Buggy hardware notwithstanding, but you wrote in "man 8 tc-taprio" that

       base-time
              Specifies the instant in nanoseconds, using the reference
              of clockid, defining the time when the schedule starts. If
              'base-time' is a time in the past, the schedule will start
              at

              base-time + (N * cycle-time)

              where N is the smallest integer so the resulting time is
              greater than "now", and "cycle-time" is the sum of all the
              intervals of the entries in the schedule

Does that not apply to schedules offloaded on Intel hardware?
You're okay with any base-time in the past (your hardware basically
requires them) but the base-time of zero is somehow special and not
valid because?

> > Out of curiosity, where is the ring to traffic class mapping configured
> > in the igc driver? I suppose that you have more rings than traffic clas=
ses.
>=20
> The driver follows the default behaviour, that netdev->queue[0] maps to
> ring[0], queue[1] to ring[1], and so on. And by default ring[0] has
> higher priority than ring[1], ring[1] higher than ring[2], and so on.
>=20
> The HW only has 4 rings/queues.

I meant to ask: is the priority of rings 0, 1, 2, 3 configurable? If so,
where is it configured by the driver? I want to understand better the
world that you're coming from, with this whole "preemptable rings"
instead of "preemptable traffic classes" thing.
IEEE 802.1Q-2018 clause 12.30.1.1.1 framePreemptionAdminStatus talks
about reporting preemption status per priority/traffic class, not per
queue/ring. Granted, I may be trapped in my own strange world here, but
say a driver has 16 rings mapped to 8 priorities like enetc does, I
think it's super odd that taprio calls tc_map_to_queue_mask before
passing the gate_mask to ndo_setup_tc. It's the kind of thing that makes
you wonder if you should put some sort of paranoid conflict resolution
checks in the code, what if queues 0 and 1, which have the same
priority, have different values in the gate_mask, what do I program into
my hardware which operates per priority as the standard actually says?=
