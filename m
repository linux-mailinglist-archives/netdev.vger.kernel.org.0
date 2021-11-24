Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C286645B800
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 11:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238446AbhKXKJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 05:09:42 -0500
Received: from mail-eopbgr130089.outbound.protection.outlook.com ([40.107.13.89]:16420
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232157AbhKXKJj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 05:09:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0n7BdXrMyNJfjGgnfbTbAkvMBJiVGzQHAJO5Hipo23QG6JwzOrc9GT7VujeYFvxbNdAOYOyo96EMbpwBJTz/v45rkMglDZKU+MLKcGf3Etu9u+adBZTTH5QQyQ4wrZhphzyhevFNE7xjbKlafo9mZWFufbRdOjxW+S9X33Rq8mqgtlQhM4qWgQyCD+KLZTfnYqRQgG7AC0D1EnxaVBXKefpGGgnPGI4D5pG3jJqbNcWR2zBCLgHltCK2MsPB+85XYoXbG+d/sVE4lw8z5En3YxBOw0WyGNL9XcgNxozb1KhprK+VtTBk6vaBwp6hxZkWK036jItzOcxpuc/SjhzHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKOzxzLNG6ugzFLWdT45F6e+IO4af/QrZZ0B9pRM9oM=;
 b=eDQU638SzixrZVWiq2JEK/le8qYkkN2e1V2HR0Q02ksSpO+tLqJ1itnfMmRKKW3A+0ywRTrYSQzzollUNlNKh5L4QsTNk7DjtFX+j6VM+67rnSrIE9jBqva1wClxUW+8FpR9Mk43M7yAHazzv+HgrQrrUUcnwj1fGvjNpOJs4fGwbSdm+TMJ4P8CeHIkttrzyPvI/qkKs8fR5kpdRVo8pfs88YCt+lLG6elbq94fx5wZJzUCcX0V77257PFN4K/aFgXsPnDq+vGXAKTCwmXUS0praHauIcpYAGprKt4+mhhO7S4AA1k5K14exJ0YKpdwpy5KEQH/A47uD0nDbu3RYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKOzxzLNG6ugzFLWdT45F6e+IO4af/QrZZ0B9pRM9oM=;
 b=N1XKgLYN9+/bNzM8RhgrLK/prtuHtfFqt792YH07pEOdXLL3fE9inmIn7TtttpgM7GoCRhWK43J2Rsyk0dAYoCgoLLFLO3dWByqwb+5Kw1BxA1n8tP+Dze2nxIpCoFinsAwHyIZs3OB8Tmw6DVcw336YTeDDgikX7zNamhfEyEA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3072.eurprd04.prod.outlook.com (2603:10a6:802:b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 10:06:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 10:06:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Yannick Vignon (OSS)" <yannick.vignon@oss.nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "Sebastien Laveze (OSS)" <sebastien.laveze@oss.nxp.com>,
        Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net] net: stmmac: Disable Tx queues when reconfiguring the
 interface
Thread-Topic: [PATCH net] net: stmmac: Disable Tx queues when reconfiguring
 the interface
Thread-Index: AQHX4JuzJ3vDgWnwEEiIccw05RVf5KwSEHqAgABkMAA=
Date:   Wed, 24 Nov 2021 10:06:27 +0000
Message-ID: <20211124100626.oxsd6lulukwkzw2v@skbuf>
References: <20211123185448.335924-1-yannick.vignon@oss.nxp.com>
 <20211123200751.3de326e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211123200751.3de326e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f9781cd-9675-435c-6d69-08d9af32148c
x-ms-traffictypediagnostic: VI1PR04MB3072:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1PR04MB3072E62DCDD824361DB45530E0619@VI1PR04MB3072.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fFWfYwFfOhkR/yXZ3Vd6h7EQhRAjz0uG8OmdoysZ/OeO0XfHb6qEJyvBSWQICHJxjtHsFjOEx861pwxJKVo7QDJuC6UseYh905OeL5ruwKPHSvuLQz6bXD4Kmg0crURN0QVQZBypN/IhVUGHnpwOJVzCZv2NPq3aVtHdqqdo9PyGJFpDf+RKGOzaJKnHI3VHupDh2lTlRsbnWjPbdaq/8rU9WdWXQv3uETtaArQgBrhp5JGGaO87KgPldZUarqt0ylsl0jCNpTYHG7F+262PbdVSRUAlIZu01lVjBx7FUYP1QcX712gxD47wBVkWWg3sG/bZiXbHo7YyPeIx29lKlD4XCGZx3rTEhHezgKIz24dJ/venpvvigZtoCX+9NA/zUt4r9MDz0LCrP6/+wgeny5c2qSD2pCPBMkjxVjfv1G9OwAeUEvnIbw6A63AFsIauGcO3BY39fDoKthrpJ486nsj3jyZZzbaIkTU6yWbAKmcNS9MXPRy08doLFSNL57xsKuL2aMUvRyYkCG3rlOrRdmEeQ324gDIxm1/L2fB8R8dUx1gj7ndlaQERSe4k4P1A81uTMim2Z2GZB0h4UtQAi4QgpjOaYB444vUrZnOVTW9b1QUMHA9N3vJMuGn0r2SA1s3yE6HSF7pHRDp/KEUgIuAS/yH00voHXcxS5zX+D8LOeM1CD12uqO8y5wUIPQosW6FZTuG99rivQiKZrvNqgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(8936002)(33716001)(38100700002)(186003)(66476007)(6506007)(122000001)(66446008)(66556008)(64756008)(91956017)(9686003)(2906002)(76116006)(66946007)(44832011)(38070700005)(6486002)(71200400001)(508600001)(4326008)(54906003)(86362001)(5660300002)(83380400001)(316002)(8676002)(6916009)(26005)(1076003)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YuieNLYBvDHxswT5cY0jb5En6pD7BNjT7T2zD3sFwWOpYZSXA8NBtY7PRB0e?=
 =?us-ascii?Q?QFJ68Yv+i84fu+f8gGpfDV/A7lvBmagEsMFY98E3T021cjep/zsY4BT0I108?=
 =?us-ascii?Q?p2BbBsVKRMS/EbhKo8Oa6+/0lHqrRkjVr/H+ezLcmc5zaDO77uveX200dDE+?=
 =?us-ascii?Q?V+m/jjP7X60nAwnHSIfWKuGrhB62HcQ5jWc9ixXS73g9HPS1aOJMl9DTmcDm?=
 =?us-ascii?Q?1VipgDPdU2hXHsrrvVdbSQRPeY/yJ2dwzSwCiIGk8Rm0hlXN82bQ7g28PNTm?=
 =?us-ascii?Q?Md95V0CGl0nPQDMXehxTgqSmQ2wVVQbMfBiD9Gtuw3vlUK2gzZ3SYZMDGMVb?=
 =?us-ascii?Q?HSSImm7jon3vEnpgKtEB6FWpuYfLNdcjS41Odcl0tLTq3n6GL1SfAK6NtBGu?=
 =?us-ascii?Q?otd6WKsSRdSImloWEtnDKEIaMZAk+a5M+oMCN5B74zr1f2VA8ma9O+G3DUL8?=
 =?us-ascii?Q?uPkmM83W69fFD1KJsizortmeD/1RoYD/F3F+2gNyeUxeWxvjtkgikQP5ekXm?=
 =?us-ascii?Q?4CnWAPbjTnJ/h+MFWpmgxz/YcX24fLdtVA7OuFKXGEgN9w/MKQuYlNGJ0HIw?=
 =?us-ascii?Q?X5K2R2XWUzS58Nvu9XiwYbJSFweoOSjzyZF1tezpglWVDpVw6ZLm4vtjletn?=
 =?us-ascii?Q?4UdDd4SfWfx8RXyK/J69xR7XjzZtQ/SlwcICgZI+mdmDg42tUzc9QWZ8cY56?=
 =?us-ascii?Q?7OPMjk+Ak0GqszvX+CRL2eIHZVrnDiDMYu+XxpHeAQQ+RmxuQDPz0DilQpPF?=
 =?us-ascii?Q?4PEbPF0djeMnaQ4IocJ3eh6mV1HcR6DWeZK4VT0LCLRuUieCfBv11kbk/gjE?=
 =?us-ascii?Q?j2WDA/CmJcD/VdPKu1PrspCouGWwApS+j/ZQ7YmcB9YoVUQJZvGqRW4mjLwP?=
 =?us-ascii?Q?ImhLEd2bm79Ly1h6DjJL0iKkOFDYpg0pOOKX0dVcrBaYZHfdcVgRKq3kfX/V?=
 =?us-ascii?Q?dWqWCU5YzGGQQCr/KzaN7LW341Q0qO4zSduf1vAotONJew1TTs+pTYEifVkA?=
 =?us-ascii?Q?IGlDmAsCZN50gbq8CYGTBP0Vfs3Qk6kxhZOmaBdtqZ2WXB3GOOO7buMyQNXN?=
 =?us-ascii?Q?gqZXPnrSHTsV2hJuHLubCOQmc53vM2h9+1gDxWMrWhnTbPz7zet2Ww4p0s6g?=
 =?us-ascii?Q?onewh8XxG5wFpR2ctcuTwuzUYF6/PWv4Gj1mVnl69WcK5G9cRJptHNDGZq49?=
 =?us-ascii?Q?+vN3yCa/dGEpvOtLPeauq42AdBL60LoHWRAu03JgynJbDp9jcSwckgLGL97Q?=
 =?us-ascii?Q?H1pAnLqIeSbFBdvnlpuWeeawhx7g3iA2ZtYMr4Uy0is7B4Kxes8Ltd/qQPV9?=
 =?us-ascii?Q?66tVZayWZ4bJdipH4RjMenDt6R4puQ0svFAUl6LMbWTv90N4HtSS41Ual2e/?=
 =?us-ascii?Q?/Gi9cMgsKF1KAu9ozSG+3+qaLf3vdCKe0H8o+k4wtIidkAYmOI/Tftcl+hyX?=
 =?us-ascii?Q?B7DnAjoQmQz7gwocgeMVfAYzEPyFG4fcA9IiMnosFwnqcPuG7+Kx2LciQpPu?=
 =?us-ascii?Q?xk6El+9Lp0TFNMPOCPbLETcThdWcEiUkTf4V9ZcnwuGWt8ZdRRT9Oep5Gz+c?=
 =?us-ascii?Q?KU21CEpFZrxyh9LukDcIW5suksiQEzMhA6NQ/efinprJiuSo4C5x98W+v2K+?=
 =?us-ascii?Q?QpMp+JWKvZoyEFxNsy8SOUA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0271AC29D147EA439B8B2F25A9133E88@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f9781cd-9675-435c-6d69-08d9af32148c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 10:06:27.6019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o4CEVxYbKSPRiqsXAVspOB7sX+KixhGvKP26E8u3Xfe+yyCruNpn5N8v+m3GD4Li1Np74cT2gqA0uU3MsnsXkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3072
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 08:07:51PM -0800, Jakub Kicinski wrote:
> On Tue, 23 Nov 2021 19:54:48 +0100 Yannick Vignon wrote:
> > From: Yannick Vignon <yannick.vignon@nxp.com>
> >=20
> > The Tx queues were not disabled in cases where the driver needed to sto=
p
> > the interface to apply a new configuration. This could result in a kern=
el
> > panic when doing any of the 3 following actions:
> > * reconfiguring the number of queues (ethtool -L)
> > * reconfiguring the size of the ring buffers (ethtool -G)
> > * installing/removing an XDP program (ip l set dev ethX xdp)
> >=20
> > Prevent the panic by making sure netif_tx_disable is called when stoppi=
ng
> > an interface.
> >=20
> > Without this patch, the following kernel panic can be observed when loa=
ding
> > an XDP program:
> >=20
> > Unable to handle kernel paging request at virtual address ffff80001238d=
040
> > [....]
> >  Call trace:
> >   dwmac4_set_addr+0x8/0x10
> >   dev_hard_start_xmit+0xe4/0x1ac
> >   sch_direct_xmit+0xe8/0x39c
> >   __dev_queue_xmit+0x3ec/0xaf0
> >   dev_queue_xmit+0x14/0x20
> > [...]
> > [ end trace 0000000000000002 ]---
> >=20
> > Fixes: 78cb988d36b6 ("net: stmmac: Add initial XDP support")
> > Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
>=20
> Fixes tag: Fixes: 78cb988d36b6 ("net: stmmac: Add initial XDP support")
> Has these problem(s):
> 	- Target SHA1 does not exist

You caught him backporting! Although I agree, things sent to the "net"
tree should also be tested against the "net" tree.=
