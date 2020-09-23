Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0932763C5
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIWWZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:25:28 -0400
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:36446
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726199AbgIWWZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 18:25:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gt4uhlqfnTTkwu6/rScxAThsYfL65/tnDLQNGsAxgVl71Rlx9+c5YARIPuMw25pZZJQYrjIcTtVZFepIyTLypXf62v/lrVFwg8q0ULNfvBZYubNwdDpBYAnt9A9L2LNZ1HzdyiHfkIS2tLLycur6lfJ456I9O4VF02taWv3L2Iyc/JCF2cq9z2RwzCSFxKqvIc+PLKCDKp07PwykYpuHupvrZ+KuAZaPi9nkmSAkbt39qE0L0ytN2kC21dfzLiLLhxkU/obEXikV9RFp2qrx/aNvnVyO/eJuaev7BEtdIJMVe98dUCqwrO0UV+2lbzcLP7jmrdPLSgI7aYJm5dgZ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79pQKJGV/SIXBKe3WafaWDxLcVSF+kIjKuJnFto37Cw=;
 b=FqIioU/qWr/XVkPn6Kwqc5smA3HXOhAtgX2aR4x+UtGT9yPXRnqA/nnLtTLEFw/oPcc71x0p+Y+QTLqzHaLkRWaMgFQA5wUDs+rSulUYQRyJtTSWkNHtqr1nYR43j9K3YHyTm2795xmftn36WPA6jiBzhnPQpKrK+XLwUhjEzaP69sWFCYNjphb0nJdYkUfUwI05BLlXerATWoI66Hn8RLZsxYLVbd3t+XynyEgX8A3ADaYQ9tlkHTn5JxorH7qFu5DcPUp0GKSgRIM9y86N+xXERgb94Ov22MWwK8WosEbrhoozeoNxNlhalcbQ/RAhiHK3yAaXnNKukrlUiMOhRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79pQKJGV/SIXBKe3WafaWDxLcVSF+kIjKuJnFto37Cw=;
 b=Ucakm3CrR2zCS1FZWHElkpmTQFRaJAHEUlpXmKv0pcCKcI5tBAnaWbQ1zWiAUrxm+9geaS7wkuEr9LiQToT7hJPLdbN4oKOWTS/QKHydPPB3A3CWArZ8iGTbXMA0/edqxtvoSotMWHRf2hSfXhSoFYIK0VUDSvGmafmoKeKpmTc=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Wed, 23 Sep
 2020 22:25:23 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 22:25:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>
Subject: Re: [PATCH net-next v3 1/2] net: dsa: untag the bridge pvid from rx
 skbs
Thread-Topic: [PATCH net-next v3 1/2] net: dsa: untag the bridge pvid from rx
 skbs
Thread-Index: AQHWkfI49n/dW6yWhUaSsyNzEyjVval2wsIAgAAApICAAALZgIAAAXSAgAAAooCAAASgAA==
Date:   Wed, 23 Sep 2020 22:25:22 +0000
Message-ID: <20200923222522.suhyowo4ii3qvvpm@skbuf>
References: <20200923214038.3671566-1-f.fainelli@gmail.com>
 <20200923214038.3671566-2-f.fainelli@gmail.com>
 <20200923214852.x2z5gb6pzaphpfvv@skbuf>
 <7fce7ddd-14a3-8301-d927-1dd4b4431ffb@gmail.com>
 <20200923220121.phnctzovjkiw2qiz@skbuf>
 <c8ca2861-44b2-4333-d63e-638dfe2f06a0@gmail.com>
 <2601834a-2cf2-f0f4-3775-2a5ebccad40a@gmail.com>
In-Reply-To: <2601834a-2cf2-f0f4-3775-2a5ebccad40a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4ad19ea2-a503-43c4-e381-08d8600f901e
x-ms-traffictypediagnostic: VE1PR04MB6638:
x-microsoft-antispam-prvs: <VE1PR04MB66387EC676D8D1F39F977296E0380@VE1PR04MB6638.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6rNkJjjpomFW2vG+4lK5cuDXtK5pJ61+sgI0YF983EEFWjKBZo78UqMhbZjO1MRR6zxG7CEqZ84UELDX3ZA/xGdU6ySwv9AsUcR2dG+jbNe+bvsvA3SYSwLtia8BqMQhf3K8Sj/nwht4QZtMv1T2cyMAoKH5KaJZ2+W36tMIjxbZc0Z74eLFe4IgACvFZfMJoX7HZ4b5kGhBqmQ7D+QU98DT8K1DxpKiFKTvOajT84BmO5oLUg+82XFqRtaJA2OD+mcJ/o1p3vKbD598EZg0A6J1wW/lecqQG3taaS00WaKH7juwB5yYdhDfTiVi7Bk1Y08YOQHsVCq8YVPy3WoQ0L9F6jI5Ds4FWff/BEorHLFDlTy9ZcbzVcqWEA735LWv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(86362001)(66946007)(44832011)(6916009)(478600001)(5660300002)(6486002)(8676002)(1076003)(9686003)(91956017)(83380400001)(4326008)(54906003)(76116006)(2906002)(6506007)(186003)(64756008)(66476007)(6512007)(66446008)(26005)(71200400001)(316002)(66556008)(8936002)(53546011)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: CnyiY+FBJ9SIXMxW2sFPoiQpOfLM2zj5o6EFGQBZs2LC79r2sKmv3fSLWIZ0dsoOuXHTUHrFZd1rJJO1XhXxQLynru3nTaQDVq/VLLftf0nvSDD3MAC+RXGR7kEwo8GSHeyRbInHekMPVJYCSY2RcxAG0XNvBukayRXze4fYnBGcvKGkol4eLhQK3hoZyDQ2mWwbQ04oteWBEv/Am46+tkbNjnAJqrYQl/xjS4bT7tE49TEShfcmRH5c9GHc6nYJCLF4bzg58sTHmLP+JoVrro3nkXKhXrjkYkqkhgQ9AkVzg2/HbPjIGCCHjbrNf0dh1uvLhF/O9LAHrlbDSUP/Cq7R5zSVLKrkaApP5ndjFg2nYw45k4i+SQH1JmfTfQPzUOuba/itkvxcmbZkRzRmT2ONg/sM3CuaNuH/rbHPpgVtNEsLcgBOIxudS4H9WnLcRDWRhTqavZWuBC9F2pJDa6kR2wCgUY5hjfEcOitcWH3pmoyiLZ/QoZVajsFkgn5rzRmk25z+YcrCZUjZjzWW9t3UP7cDMN7BZGk1HcEjcJFTX3Ie2ib3t9uN7GlePZTO2IA2kaQPtI7lH8cmabturHFkaGu6N+7vCGz1t6sXgYz58rJp0LqfTnJ9RtWGKtIFlRVURgDDYXlk0ODFhtk7sw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CA72B6FA2AA1B749966DC82B2D757BC1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad19ea2-a503-43c4-e381-08d8600f901e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 22:25:22.9605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ++0Ywm/fNV6HbvF9JhycfTmUd1Sn66zsZTIvx4YkBNxYp55A9A2+Qgf8WX9J5KZ++t00hJj90AURRT/7WiHoUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 03:08:49PM -0700, Florian Fainelli wrote:
> On 9/23/20 3:06 PM, Florian Fainelli wrote:
> > On 9/23/20 3:01 PM, Vladimir Oltean wrote:
> >> On Wed, Sep 23, 2020 at 02:51:09PM -0700, Florian Fainelli wrote:
> >>> Speaking of that part of the code, I was also wondering whether you
> >>> wanted this to be netdev_for_each_upper_dev_rcu(br, upper_dev, iter) =
and
> >>> catch a bridge device upper as opposed to a switch port upper? Either
> >>> way is fine and there are possibly use cases for either.
> >>
> >> So, yeah, both use cases are valid, and I did in fact mean uppers of t=
he
> >> bridge, but now that you're raising the point, do we actually support
> >> properly the use case with an 8021q upper of a bridged port? My
> >> understanding is that this VLAN-tagged traffic should not be switched =
on
> >> RX. So without some ACL rule on ingress that the driver must install, =
I
> >> don't see how that can work properly.
> >
> > Is not this a problem only if the DSA master does VLAN receive filterin=
g
> > though?

I don't understand how the DSA master is involved here, sorry.

> > In a bridge with vlan_filtering=3D0 the switch port is supposed to
> > accept any VLAN tagged frames because it does not do ingress VLAN ID
> > checking.
> >
> > Prior to your patch, I would always install a br0.1 upper to pop the
> > default_pvid and that would work fine because the underlying DSA master
> > does not do VLAN filtering.

Yes, but on both your Broadcom tags, the VLAN header is shifted to the
right, so the master's hardware parser shouldn't figure out it's looking
at VLAN (unless your master is DSA-aware). So again, I don't see how
that makes a difference.

>
> This is kind of a bad example, because the switch port has been added to
> the default_pvid VLAN entry, but I believe the rest to be correct though.

I don't think it's a bad example, and I think that we should try to keep
br0.1 working.

Given the fact that all skbs are received as VLAN-tagged, the
dsa_untag_bridge_pvid function tries to guess what is the intention of
the user, in order to figure out when it should strip that tag and when
it shouldn't. When there is a swp0.1 upper, it is clear (to me, at
least) that the intention of the user is to terminate some traffic on
it, so the VLAN tag should be kept. Same should apply to br0.1. The only
difference is that swp0.1 might not work correctly today due to other,
unrelated reasons (like I said, the 8021q upper should 'steal' traffic
from the bridge inside the actual hardware datapath, but without
explicit configuration, which we don't have, it isn't really doing
that). Lastly, in absence of any 8021q upper, the function should untag
the skb to allow VLAN-unaware networking to be performed through the
bridge, because, presumably, that VLAN was added only as a side effect
of driver internal configuration, and is not desirable to any upper
layer.=
