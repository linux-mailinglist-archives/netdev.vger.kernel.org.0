Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2D1292683
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgJSLmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:42:01 -0400
Received: from mail-eopbgr00077.outbound.protection.outlook.com ([40.107.0.77]:23107
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbgJSLmB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 07:42:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aeOnXS4HQtvq2WbuS1MYEIWzAVcxNSU4PxKx6ewO4hWQQkN3p1HLI8RTunPyyavF27doD8kFKjANY9uwqK3LosjQN/mOooQs+Y2ubrW4ul1yGnzgjeO6PzzAAbU9iT1II2MDSZ1T8lDH0+SGHVzQR51suUtXnm+YnHQBiIBYt1RVDGOcHalMXTZdIlNV3u7Ij5AA+LP4oSIEg74u+5H0ghqu+sMDIjuNt21X8QtXwP94w7nEqjotc+LyD3f9zXq5kSJaju4OTZL5jgtFP1s35vnemwedVggjWdZoLKA8WH1dTM8iSoAXtJGX3H3faUxP8jFSy5E+pOhHYOs+ujN8FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhPruYfZdpCtEtUZDbl9yYsvk0i6jgipGeexXQBNNvo=;
 b=Oph9Xq1oF+TEs6klXKzml+UsRLeUQNRfqD51IZpbnqILCnOZFn/ofCmIILLSIlHWwsbi2qXOHDXJKbyZ1/IhX6zd7C2GQKaLfZvTsp4W2rTZoPFCrqGrsIyHoyq9RW+E/u/lNRCBJKVSvP5OXzqZFuiP2W7bhASBILoCUZZo0akmKNTB3Q9hv20WhEfK7tUHcb4sewvpA2wwENvVKuWTyBCh/zPiR1inf5BcX45T/mD059kH9khfb4eeP3knBIi0fNbP3kF1H9t1Xkmss/+cuKRI+Oad3QAPOdidd45gZyZI3m+6w4yLlP3m6sMambrIefycLAWO16SqUEGUNrrl1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhPruYfZdpCtEtUZDbl9yYsvk0i6jgipGeexXQBNNvo=;
 b=n0V5GUlLB9v6MJFsRNIlBbeOh4jzcEN9qWXOaIrlCxTUtsSkYrXIgvshU5uLe8YcvNHAjO/JgSpNAYOaZxqjGnxAVwFqotB5kWJVfaB/FFhE6Kw0sE3mWik+LGUtkKRb8+1vRRyF9uunKHI/J+KBqa2bvlkNKLlrR+S5B0Gtg+0=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3968.eurprd04.prod.outlook.com (2603:10a6:803:3d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Mon, 19 Oct
 2020 11:41:56 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 11:41:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     David Laight <David.Laight@ACULAB.COM>
CC:     'Florian Fainelli' <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Topic: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Index: AQHWpM2WRVElJamqkEeHVtfDsj9ayamcWGgAgAADBACAAkAAgIAAIMmAgAAMG4CAAAfFgA==
Date:   Mon, 19 Oct 2020 11:41:56 +0000
Message-ID: <20201019114155.lcweo2suwo73eopo@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-3-vladimir.oltean@nxp.com>
 <20201017220104.wejlxn2a4seefkfv@skbuf>
 <d2578c4b-7da6-e25d-5dde-5ec89b82aeef@gmail.com>
 <049e7fd8f46c43819a05689fe464df25@AcuMS.aculab.com>
 <20201019103047.oq5ki3jlhnwzz2xv@skbuf>
 <45ac0c697c164991a99a35a2d981b5db@AcuMS.aculab.com>
In-Reply-To: <45ac0c697c164991a99a35a2d981b5db@AcuMS.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ACULAB.COM; dkim=none (message not signed)
 header.d=none;ACULAB.COM; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 675f3c6e-72f2-4313-0694-08d87423fbaa
x-ms-traffictypediagnostic: VI1PR04MB3968:
x-microsoft-antispam-prvs: <VI1PR04MB39686B462E622814A2B11D53E01E0@VI1PR04MB3968.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xL2hiIktXKgqLzd5qKi5qrrfUU+9CoohJy0ZPo6NZ2RAMg+bUxs82gEmarm1vZF6tZve4p8K+IzZLXt3OgxcJLXEp2nfTFv31Fk096Z5fgBpfBzjUyLGX9QN+P858qw2qP+GKiUL3/X4d2biAbkfTtxI/G3HH9a20Rn67dBvi5oywYv2TnlzkESnjJtaMLPWhXMSLZAm+eMs8iqIOXfdKfPGm661WHlS0Q1WIREuD0qRijUfZ05ypxy6lZdLNdrveVsYo0U5oVpgqE+fBnXMpzUo8DoJMeBQG3UKe79NTtbhZSRWTgPBBlVQxX49XbA4oiLTAy38kgd9FLNEkMBlXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(316002)(6486002)(2906002)(4326008)(6506007)(66476007)(66946007)(91956017)(76116006)(5660300002)(33716001)(478600001)(6916009)(64756008)(66556008)(66446008)(83380400001)(186003)(26005)(71200400001)(86362001)(6512007)(9686003)(8936002)(8676002)(1076003)(44832011)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NXcMRc/Dh0Bm8Y2ZMkkWFVPDhcbSkwhkj2pcg+q0KJk0IXRP8bdSPxSa58pg91XPAdvtGl55PhkNKyxV/646bHTp1T7YnJpIwbt7wNcy8LD8Gvc3oqo7nL89ToeE6IzYIr7cLDhOTeIRxgEf9b+vk1gRFkVTzUufoX26j4bJGgdvjp9crFtIqv3IB5DAvgol1cUlPaf2dW6Qovo9V5fgWQ3FJxFpEbOolMoas+SfU0zCmVIEkUz7UGeTrkYcfdihF34SwzK8hhNCuwKhxjZI6/kfLWPneOHpXXqNrjpYw8y087mrtyVSzzau5dGhKfjYx2sAD6nD4HWoMQ1jNqh7glA8w1Sbklh9TStBjVs95mbnXQpO9cb4J86sibuUvNsVo6PTyGv0WwmVuZvIvczjBfO7gZJ/KH7ul72PMoPQKnvdWh+KgZm2uLffmGkba+8O1hl4Cp154osPJiZE5CRHNCKvECpUR/c2tsaRkf3PwI1mNhocHDO0rBOWFvIsi3NBnXPuHp5kkTQoo2qvgnTFk/I3mpwVQgdLEhhFQQwhJAZ+zbzPWWZVqvAT2Bk2foVxeP6PAHKfG6BKZOPpCuYLYiEz8jfjBpwv/eHhHD/XXSMtrbjAoInlUxGu64KO/5eJDQ9fXIL/X4MMIkrBcPtnSA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D45BC41BAE5BF04F9D880EE97EF9102E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 675f3c6e-72f2-4313-0694-08d87423fbaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 11:41:56.7236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vs7QqS2p8gHovqM2Flxx/FBOvvhdIOElUIGLPMgQ/U8Ir6vARpUmFl/oOTkjqQEEVucRPIDgUzrF+kFNxoJRPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 11:14:07AM +0000, David Laight wrote:
> If the skb are 'cloned' then I suspect you can't even put the MAC address=
es
> into the skb because they might be being transmitted on another interface=
.

No, that's not right. The bridge floods frames by cloning them, and L2
forwarding doesn't need to modify the L2 header in any way. So when you
have a bridge upper, you will get cloned skbs with a valid MAC header in
them.

> OTOH TCP will have cloned the skb for retransmit so may ensure than there
> isn't (still) a second reference (from an old transmit) before doing the
> transmit - in which case you can write into the head/tail space.

In the case of TCP, I suppose the DSA layer will never see cloned skbs
for the reason you mention, true.

> Hmmm... I was thinking you were doing something for a specific driver.
> But it looks more like it depends on what the interface is connected to.

I'm not sure what you mean here.

> If the MAC addresses (and ethertype) can be written into the skb head
> space then it must be valid to rewrite the header containing the tag.
> (With the proviso that none of the MAC drivers try to decode it again.)

This phrase is almost correct.
Hardware TX timestamping also clones the skb, because the clone needs to
be ultimately reinjected into the socket's error queue, for the user
space program to retrieve the timestamp via a cmsg.

> One thing I have noticed is that the size of the 'headroom' for UDP
> and RAWIP (where I was looking) packets depends on the final 'dev'.
> This means that you can't copy the frame into an skb until you know
> the 'dev' - but that might depend on the frame data.
> This is a 'catch-22' problem.
> I actually wonder how much the headroom varies.
> It might be worth having a system-wide 'headroom' value.
> A few extra bytes aren't really going to make any difference.
>
> That might make it far less likely that there isn't the available
> headroom for the tag - in which case you can just log once and discard.

Again, the case of the bridge, and of TX timestamping, and of tail
taggers that need to perform padding, is enough that we need to
reallocate skbs, and can't just drop them when they're not writable or
there isn't enough head/tailroom.=
