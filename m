Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845022909FA
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 18:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410590AbgJPQu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 12:50:26 -0400
Received: from mail-am6eur05on2072.outbound.protection.outlook.com ([40.107.22.72]:61792
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2409837AbgJPQu0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 12:50:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+bE0eSWejoLPebC8bJLUrs3bMd8JaTdHyXBg4rLaRRnFDQCwiJI+m/f7N+KAp9QIeZgh2MO369nri0AAG0I7sFRdTw1pcgxyL5Xu1Pqrn01SMWUVLWW6ezAW2MpZp/gpMxErB1TB3zuuoh82FA0sFtNE3DV6fyZisJ2gFjvEKD/i4wgfEHU6Twd4Fm7Hsd4d1Si5lQ+MNtBvncwUgR8tgUi+KscBs7PoPDMJbilqMY8TIrlzknMu7tzs6hOI45Hkg80cCtc0ttIKpP/WtZeEnGqM+wWp/L7l9aU1gNPamP2Z7zz6PHZXfo562vTsOOPZLghjprNT1mcjS2fCxESlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiFr4UXVWRFb/6C8p7jnlDkwt3rG7oVdtJXfRKbpS0M=;
 b=ZD4lzl8v4ylIsqy9uIIbHxDbFrAN614ttLu/nIctcpnAdxKVJFlpCGNhBn1DKGZXMEJHdMJlbahkSIldcMAfTNPjDl8vRqf5nj7pXlqFMVzQOHh6xS9WqEM+dwqZNVON/8SS8UnKs4kFwALjpZJRpfaE/0iuLNAmTXGja0GmQR4vV+/yD5FRVUILhkZTpTT2u1opWvaRvjEprXHld7wKRiqAc0RiCOCXzkmq8/F42vnbLGLJS7qXb5G4cP1+9rNsUfs1JHGEBAETlsrRW7PQuY/SBMQwUjt5+R+0G9vgnt7OZ/ZchgqFfK6Wzt0P9zPLJCLGwg6+R37Aw+839je3Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiFr4UXVWRFb/6C8p7jnlDkwt3rG7oVdtJXfRKbpS0M=;
 b=p0tvaTV/X0+RNgHLJ9m/n9RT+blHeMGQ+HP0Zoqro62XuDIEja/9hJ5bZQyj+6CuxtM+bqOPAJ8x+KqnxUhAGZdtJCGTaJce/SzpKYSKC4YiA2Bz+hMLwdHG9JHQbGz7c7Pd0bRBLCSnGsxjsEkbQ67OhssT8Z2Nh6k4BG3r6kw=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Fri, 16 Oct
 2020 16:50:23 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Fri, 16 Oct 2020
 16:50:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [RFC PATCH] net: bridge: call br_multicast_del_port before the
 port leaves
Thread-Topic: [RFC PATCH] net: bridge: call br_multicast_del_port before the
 port leaves
Thread-Index: AQHWoxlk3CgJjcYqVUG5/aECg5LB0qmaPloAgAA0UYA=
Date:   Fri, 16 Oct 2020 16:50:22 +0000
Message-ID: <20201016165021.fjrxiwofwfqespei@skbuf>
References: <20201015173355.564934-1-vladimir.oltean@nxp.com>
 <ed19387091755aee165c074983776f37f2b87892.camel@nvidia.com>
In-Reply-To: <ed19387091755aee165c074983776f37f2b87892.camel@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6b901356-18ec-4e6d-4aec-08d871f39315
x-ms-traffictypediagnostic: VE1PR04MB7343:
x-microsoft-antispam-prvs: <VE1PR04MB73434973C7C2689C7A193882E0030@VE1PR04MB7343.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NKBX/mKebfYKEvIA3G7l0Y9pOY1OE2IfrbbDuyu2JsanVu6ikrp7/ENaIjaV92N/i5fFpWnuOkByt7IgcCsJHWt4D1Q8tcmLoFKn8cSAWHSYB8PtzQZyFoBDlfYGI807oPbV7Rg4NP+vhD5pgiPYSsB8yIEYjDcwK+VX11sId+Ti50ZrBoUbMbFeqe80t9UwB8rnOCXfJyPBEbW4VzI7JxmGgIEgZW2u0DXulWukTWl0ZK/EyCXkQMLZrb+YbcH9yaCMXFtEiY7eLqAFcVF6sTyUQ4PYnuDHAXtppyUQjLpspeM3IsFdfmKSDOuw3Xk2m1T+yPStN9kp7UyDX3ga3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(186003)(6486002)(1076003)(4326008)(8676002)(8936002)(6506007)(2906002)(26005)(86362001)(71200400001)(6916009)(5660300002)(66556008)(316002)(33716001)(91956017)(478600001)(66476007)(6512007)(76116006)(66946007)(66446008)(44832011)(54906003)(3716004)(83380400001)(64756008)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: PuJ5Opea8tMIbWtYePpf06urNL2iJ4x4MfRAAga3RG7PGm8a/yV+R9M6JxtTiZFFgpKMc2/1LYXY6UmlzW1Qng4loaMCUPcxNMXrBopmAFljiqNxY4ZJd7xISpT3H/4CyTeYOo/4PMX4A20XZGmZiKahWF33J4eg7XGZkzQc47uEQXcUonIqb6sgJzXuGTV6yVNJCQoHVjDy6OLPepRHsRP/3QtRArWIOqOOpaJ+AE6CMQ0ZHyp1gHiK9DOK/1hT/wEv+Fhujj9ftmNgN+HYtApsKruplJ2IKGiOl7ft75mpTMMnQ/iLTR/mm0Mh2KLB7cb4jGDtfUCFad4wz5FxMdOreAG4bGjWw/fcqIi7a5A+MUIVBL+9YJMuXFjaiaYWta9uG+gn4qXAxlhQu4KoKEpHaAxncdc0vg/wCTMxCeXCJ9MJRHBEJuzAAG3bP/aghkYtmyFLMagMVzFVSsIQV8kAQpnbF0ux7hhUXxP2jv6R83LVnDO/kmPG8AOBVf9+NVsrJ5l0wRtXYGaaijx81Q7sJGiuGmz4mRGVukYKTd5TrFMg+RFApW8sg9NNDjxaf08mFMziIfSsZYMWfix3IIP1whHdjLRV+4R7Hyh62dTxLltw+giP7U2g2WIZZeb1pE6qE0eFZzU2zvapWLgtag==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <01BB5C912E1F944C867A03D3C92DBCC5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b901356-18ec-4e6d-4aec-08d871f39315
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 16:50:23.0573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iz9ByR2avXDSVJUV+fGRB/q/i9BH0Xfpic8Fb1dSYkFlS5+ZAq2QFoBWy+narTM/3jddh7riHbb1IHfHp46Gzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 01:43:06PM +0000, Nikolay Aleksandrov wrote:
> It can potentially use after free, multicast resources (per-cpu stats) ar=
e freed
> in br_multicast_del_port() and can be used due to a race with port state
> sync on other CPUs since the handler can still process packets. That has =
a
> chance of happening if vlans are not used.

Interesting, thanks for pointing this out, I haven't observed
use-after-free in my limited testing of this patch.

> Interesting that br_stp_disable_port() calls br_multicast_disable_port() =
which
> flushes all non-permanent mdb entries, so I'm guessing you have problem o=
nly
> with permanent ones?

Indeed, I'm testing out your L2 multicast patch.

> Perhaps we can flush them all before. Either by passing an argument to
> br_stp_disable_port() that we're deleting the port which will be
> passed down to br_multicast_disable_port() or by calling an additional
> helper to flush all which can be re-used by both disable_port() and
> stop_multicast() calls. Adding an argument to br_stp_disable_port() to
> be passed down sounds cleaner to me. What do you think?

That sounds a bit complicated, to be honest.
In fact, the reason why I submitted this as RFC only is because it isn't
solving all my problems. You know that saying "- it hurts when I do that
- then don't do that"? I think I can just change the ocelot driver to
stop remapping the untagged MDB entries to its pvid, and then I can drop
all my charges to the bridge driver.=
