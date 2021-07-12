Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0543C5CEE
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhGLNGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:06:15 -0400
Received: from mail-am6eur05on2063.outbound.protection.outlook.com ([40.107.22.63]:2528
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230000AbhGLNGN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 09:06:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z442ZMk07Br/oDc3lqRfRJaUinYKMdpzLKsPCI+hkDBb4F8TwK4WRzavxwawDH1fNAtfnUWS8GYH1iVjUw+caSaU2MtEAqhw4c3JlhYSR3dMZWmbjxBHpveXQ/Uyj81e+ydSwTHKJZsRKaq1QgllMmYmKmhcbdmRW9MAbXG0Zq3Apx7FfDIffDUYZm38VWHaj2cYFsJTr7+rw3YTWjuI7rK4urGgXUAAdh2+Nb9RE6lDlnAbTSVhAfjiZ6Qc5+3B3aQtF0J4vHjRRDPsgISqeOC3KBjlHBm/kGGuyoP9zsHdXWG1r3P/TwvxmJp/tz2KhZFd0D9lp+wMgksgTNYi3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLY1ujMdI/kkthaVeuepns6SGIIxkE1PEYyt7hAFFBU=;
 b=kzKCvkIL2K/nK9tOSCsVQ5gOKrpGbL+CUHIrTGVWbOCI9XRxPYnOilF8jPJG/qxpobXpc9SWJ9MknoMOvuveQWj8sflSm8TCdM8I1FeD66ZptOquYFCglP7ZHwlvmORgzTSl2TctPWbI2OytNFLL5WT1FJ4Gop4tw5sir823Fyk7hzQILhx2ywdKvzFD7FVcEl/YfDAyUIBsaK95NEd+KT+YAHWIqRsqwu3hvDxAu6CSDO0TsFDMOPUgGJJwSCYpjOiUogyFDWqKHNXeArHrNwOgKwI2i8Hrs1a68aMtqTvrLzSnldi3F9pXYIZYy3v2hk5URTUQ+ZMdDA7ywLT5VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLY1ujMdI/kkthaVeuepns6SGIIxkE1PEYyt7hAFFBU=;
 b=CAo1d4StJSoY7yos3IzXJd3w3JrMKviA29XGd8qkIGrwRwfOheXXc5cbxPpBdAQbCk5vveLUI8dbZgY3k7h9OSo/w4F9E1BPf7GGjjri8gMcExDa5/Kmchpta4gXMKfgf0HoySYnHjbsrbixIXViIBjTsclGgHsuhZ2/YjN2/+4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2511.eurprd04.prod.outlook.com (2603:10a6:800:50::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 13:03:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 13:03:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
CC:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 04/10] net: bridge: switchdev: allow the
 data plane forwarding to be offloaded
Thread-Topic: [RFC PATCH v2 net-next 04/10] net: bridge: switchdev: allow the
 data plane forwarding to be offloaded
Thread-Index: AQHXcAK+Sk3ggVyTikStfTUZ9SvpWas6qSiAgAAO7wCABJrJAIAACa+A
Date:   Mon, 12 Jul 2021 13:03:23 +0000
Message-ID: <20210712130321.ovf2xnvmpgyfs4im@skbuf>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
 <20210703115705.1034112-5-vladimir.oltean@nxp.com>
 <3686cff1-2a80-687e-7c64-cf070a0f5324@ti.com>
 <20210709140940.4ak5vvt5hxay3wus@skbuf> <87r1g37m2t.fsf@waldekranz.com>
In-Reply-To: <87r1g37m2t.fsf@waldekranz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3286514-77d0-4c16-8e5c-08d945356e26
x-ms-traffictypediagnostic: VI1PR0401MB2511:
x-microsoft-antispam-prvs: <VI1PR0401MB251112F91FD8E42C9A7DA882E0159@VI1PR0401MB2511.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AK2knPCAo0wAAxzqD3UFx1oJXj2w5nKR40vigojemLFAY5HegHuDOwWL8OI88gCFRnTNwNfTYJGI6/czgnIn3TFF2P/deMXwDTwudtAubQkWYxh9pMAwlXTOqUDOrMphyuiEyqhz367lND9NQzomV4/GQ2phf8qQlUvELkF6RStcUnW/9F2uTKg+34kzJ+arpCT3iS5k5UEibgBNpVedE93Onpvn0oUUkWAJo4dqvPDcA9Jk4HzT8RM9ahoYspgVTFLUa8vsWaqWdkplirTXacLu7dkiluN9AFQg0VKg/T6w+VbYJ8fx5dGpryNhdfTZpG2Fj3Xu0/tVr3qZJE0S0/0e45KXx+VYLfk6V6Xgtb73cbKsjno5JnK9BtJ6aheuY/GS39TC0H8OrXDiHbij8gBG/37tuBgrxyQ62dG2KYsTEA8rt4K5fVwLwF7fXoT9k8icFktX/BsxQaji1HyJ6dbIeSV0SkIqwahwrmzu1wGBoCBG+DZ+3xb6hjgi/slKAfY8zl/fKTwahJmcShuYM+XW77mMG/JVMHr8N3/azN4CLE3ndEpPP0y6o9eHQnEAdZeNOOAo782dqc7hh4Q9FmKKuzzou4dQgviCoSVfbYai9xVJLocFqdFNilHxGMxxI/8/tvPyDDM3/3EoGWyucQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(66946007)(66476007)(66446008)(86362001)(91956017)(71200400001)(6916009)(316002)(44832011)(7416002)(33716001)(66556008)(6512007)(64756008)(8676002)(2906002)(478600001)(122000001)(4326008)(5660300002)(76116006)(6506007)(6486002)(26005)(8936002)(38100700002)(54906003)(1076003)(186003)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UfnwjjJqGsWBumHpgAlY0wxlkCziSVJEN6L74m9EhrUzFhzMOCgfUTVBNRRv?=
 =?us-ascii?Q?/c3HTppMb+N0Vpk93sWwJqMgxQNTpV7DSkEh9BhyByvCqqAoLf9X9IfMNzbz?=
 =?us-ascii?Q?JBtx5D9oxABdlrDzqAcZU+OQ/0/diZ3xMqTZIxILkNWyvW9CVsduZtWk13++?=
 =?us-ascii?Q?5dhk3Ng+eA1yR/Q0Ye+NSDLHG6TMOPSUwpFrgazMo88lQDuG+GY4tY1Rb6oi?=
 =?us-ascii?Q?KuwX5eWyPor0iPIgoaB8VQKFKU8/w0fSFmgdgZjAUZsozN200q1MyTDF8r4p?=
 =?us-ascii?Q?AlWCzesF8Xtbr/zfYNrV2FhzbnLfOmj9CJxuwCxAUV2uWr7XBhFhJBgHBYsy?=
 =?us-ascii?Q?xRRaOT1tlVRXlW+a3Kw2cIy8U//SvfdQ40PQgt7ASJG2YGDv/7jVO49k97WW?=
 =?us-ascii?Q?y96kPVZ5kXAclxd2EX5cIMekIyyC6YSpXI3tNMPSw6MpqUDC09hTeubtMAY3?=
 =?us-ascii?Q?IhkpQB2VOLDBheGXa3k2v8Hrc5MgIsAZpu/DtAXxvByjkREYF8+STUQMDc8n?=
 =?us-ascii?Q?5N7bGJvKT8bIgSZu/qBGmkjcCkL/riC//P7SaIoHu7pRjtvZf5TBFyFfjLA1?=
 =?us-ascii?Q?ROZDwJWGdjtaNsjcrihMba4dUHQYLy5k5sOD0DFD19IX0KJMTViIputomSvX?=
 =?us-ascii?Q?k46ySLxGAFP2F51oUOmwkM26ahVICPxUzFyZABhK3NuGXYm54f/qpETxNcdc?=
 =?us-ascii?Q?B85GvnHtWzkW36JHozYvuDJuGhYSQDIM4MaTQljHUaH3U1vgLk92uYquCZGV?=
 =?us-ascii?Q?uCgfPZhwDjT7Mik8DpU224M0Ze0GE0k7hk/GKk7iD7WmSgHeCt6YcU2qoGvr?=
 =?us-ascii?Q?/jmlURuihwk3J0FB6diJqcWMAuXr+qaZBm8kmVu/ddWUny4nlgavzowZ+e/o?=
 =?us-ascii?Q?MVmgFDVhoNNK5jw+FOsk6MDlo6u+fBh3Kxv13Bk7kBsu9TYC+nTKaEnX49B3?=
 =?us-ascii?Q?j74vpUmtu9XnB+0LM0rzJvdbJZgR8esN1+FYYI4EnoUr3Wd6aBA+BlHVdZqG?=
 =?us-ascii?Q?ymPN7i01KyefF5Nyl+h8IQ/5w130XkDjAZJjWXo8fMKspc/3IF1bV5SzrXe1?=
 =?us-ascii?Q?4wlTNii3t0ywiEA4B85It6qE4n9/ArBBqZK6dpy+d6Xh0ClgMVbCkx6xbH6U?=
 =?us-ascii?Q?MjxpWyD4XZwxMuv0arH4teBGR+dD7gUUramNwG3xsHsyfPc3iAUHzTlgF1Tm?=
 =?us-ascii?Q?i5KBSkvLCJqxpBvCjqzKL2tF/YmZvGcLmFqv9fGCV77r+7uknMHLuD4yRaG8?=
 =?us-ascii?Q?XHocKJML06p0dS5mgRkfMe0yGVcQq2pLfqCQYizVzoIXOmFpzUnVsX5mgcdw?=
 =?us-ascii?Q?ukzU4wbWLDdV1DFApr3eu6P/?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <106A336E09E7384599E455D27E3AEE7F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3286514-77d0-4c16-8e5c-08d945356e26
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2021 13:03:23.2430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wis0AE5qRA1jM6CG/G6BMApAGk1OTUg42uC/8jeuW6ehvcwLm7ZaIyQ9hoV4/sHW9iIgWOQ78/KSjCeG5XeEzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 02:28:42PM +0200, Tobias Waldekranz wrote:
> > After cutting my teeth myself with Tobias' patches, I tend to agree wit=
h
> > the idea that the macvlan offload framework is not a great fit for the
> > software bridge data plane TX offloading. Some reasons:
>
> I agree. I was trying to find an API that would not require adding new
> .ndos or other infrastructure. You can see in my original RFC cover that
> this was something I wrestled with.
>
> > - the sb_dev pointer is necessary for macvlan because you can have
> >   multiple macvlan uppers and you need to know which one this packet
> >   came from. Whereas in the case of a bridge, any given switchdev net
> >   device can have a single bridge upper. So a single bit per skb,
> >   possibly even skb->offload_fwd_mark, could be used to encode this bit
> >   of information: please look up your FDB for this packet and
> >   forward/replicate it accordingly.
>
> In fact, in the version I was about to publish, I reused
> skb->offload_fwd_mark to encode precisely this property. It works really
> well. Maybe I should just publish it, even with the issues regarding
> mv88e6xxx. Let me know if you want to take a look at it.

I am on it already, I have a 25-patch series that is currently
undergoing testing (yes, it changes all switchdev drivers to call
switchdev_bridge_port_offload() and switchdev_bridge_port_unoffload(),
and it also moves the switchdev object replay helpers to push mode, and
only then it hooks a "bool tx_fwd_offload" argument to the
switchdev_bridge_port_offload() call).
If all goes well and I still have some time today I will publish it for
review. Naturally the final submissions, when net-next reopens, will be
in much smaller chunks.=
