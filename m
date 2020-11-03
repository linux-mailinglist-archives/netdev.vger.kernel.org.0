Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4BF2A4E1B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgKCSPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:15:36 -0500
Received: from mail-eopbgr10050.outbound.protection.outlook.com ([40.107.1.50]:30087
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727706AbgKCSPg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 13:15:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfeWi7rPp6GLW19FBF7kB6zLmGg/p96kAEJOP3fLPKsYmfTASYxd2f94++CvZc0PJrZdZVRelrg2nvS6LVDkcUpSv1oDDLMhcmm39kX+WoqOfkawVjEuR5XW17e2T3vJfAal55YmaYaYX9V5dFf+91I/YZSZ/RlwZ0Ojdm0Uj6pXbLPd8ZCMzP/fO8Z1v1j9wtxVxijsbIstyC3HudnE2xSbiPHXK5UIn3q9j4zJ7wJu3GyPxtRAygabD1eGRIZwqH+/YVbfdxl9+nE/Xk/7j0CqJcbSGel3OfauPMd7rEFohKDtkI5ANMgGSes6mYNJiFcvK+1zTLesbXL37VI0MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4z3Qde5l+6ECLnQK+V3i66ryjmnNN8A1aHbuzYHY9h0=;
 b=I6HgraL7/M1rW+Rz4BBJLSty3NLd6vMzURYFQPy09P82/H20pKhgfiVJSaS8YbbQ/974OWdhfIarWz2HdI+gs+n9pOMbU01x/qf/K1o8mucebKQZ3RnhdNgvnRnba4+RYjhm+cf15xh90g8wIzc07a/ASeOHtrioqvTOK4xkqNCJ2J93feJO/q3/n2Xn39i+UR7NyqDKbADKRluUfR94JpFd7rTn0wjlDGDa4MqJWC73MRXQUnyryo1kldILW+XLTMfRXhdZuHI4lbuwa+qxQe91oOooepzMhdOjNijGpQB9YoUnyZSJWy4n/MQMJco8IRgQ5Ccu2qDjcUcwnfhGjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4z3Qde5l+6ECLnQK+V3i66ryjmnNN8A1aHbuzYHY9h0=;
 b=Aj+FEr9TfsFG/YOOVY5OMyHrjOZI/CgI4WL2/gxgp+KvR/5UwIwMkSjnjdIR0NeoVgmArRRf3jkn+xbGo3a0V/E6oev3gxc6KugqsL1QrVnYrXAn/AERRS8RTo+eYMa0/jmEzTA1sZw6akJbLd4Igl9sHsM19aWF8kCAv6pGIZ4=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3552.eurprd04.prod.outlook.com (2603:10a6:803:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 18:15:29 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 18:15:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v3 net-next 09/12] net: dsa: tag_brcm: let DSA core deal
 with TX reallocation
Thread-Topic: [PATCH v3 net-next 09/12] net: dsa: tag_brcm: let DSA core deal
 with TX reallocation
Thread-Index: AQHWsIORA0PhHKt4BUWPz2Nre8xYCKm1TgOAgADvY4CAAGhFgIAAE+sA
Date:   Tue, 3 Nov 2020 18:15:29 +0000
Message-ID: <20201103181528.tyvythhy2ynyjx4a@skbuf>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-10-vladimir.oltean@nxp.com>
 <10537403-67a4-c64a-705a-61bc5f55f80e@gmail.com>
 <20201103105059.t66xhok5elgx4r4h@skbuf>
 <20201103090411.64f785cc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201103090411.64f785cc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: af14d565-782b-4904-e3f0-08d880247230
x-ms-traffictypediagnostic: VI1PR0402MB3552:
x-microsoft-antispam-prvs: <VI1PR0402MB355293E246BE089CB0F4607DE0110@VI1PR0402MB3552.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T6lyzJgGxqvsoDCk37OEnUL0oQD03gVDCyGcH/6CaxFs3Uovv6GDzncGiJVNfh9+HKMKhOFOjcFChcYBVj6jUMUZocWa2lJ/rnSS1gVEuKa1SI4MMlfzx1kg2dsIbjPoHLzsylQx/zqS+PCLJrnjuMVjRqRTpP1RvkCx/brMtsestlggHLI5O49wXs7prN1NbUSqvMYLcR3jxKbrmM8fwGI307f5bzEtarh5shL8Azy2p2MJzVXU+ds2AfTfLhscM7Ixryo1+BDmH+kv2svqw/ggP6FH5nL+bggznIm8NDiyBr6W0kxfXlWyfF6qB2rs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(136003)(366004)(376002)(39850400004)(396003)(64756008)(66446008)(8676002)(8936002)(91956017)(66556008)(316002)(66476007)(66946007)(4326008)(86362001)(1076003)(76116006)(54906003)(5660300002)(6512007)(478600001)(6916009)(2906002)(6506007)(33716001)(26005)(186003)(71200400001)(6486002)(44832011)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: y0AFeNMu3YnxS4UjjC2iwlp+xE7UgOR0SjT2h43KxkjzKgNI4LTLvE0n1pmQ3IfAWhtDpMSuTiTFBEtfOWMbxTCejW/beJJwhC6vI235zJ+waWAQOqrCL49MjnJ4Hb90LKZDmD0RkkqrR08s49BkPqjKTswF5qoWKz0G9IJrrKo7Lvsl75tUovMZNcbeUIiM0QqNaknyxZoitIDcD6lzB2nW4bQntxYB3N3bu8/c9m79/a2GL9rrNrBnrIW07Uv5s1DLUdbe/aOBvodY4Ubc7EJ/6U+MW2ELqL2+V6bgFzXQzKOA0h1ekFTCsb41kvS9B440y69lgbtF4RsTQSNLMm+LrenKWjFHQQbhS6SoxDnO69Dj/F1yeFM5gSsnZymR/6Nt+QDDTRNBQVGnlcVe2MeTlAd+Qw0BShAHsSGQZdNC/YQYTF9gqxatQjZr6wjs1cpZNQRniKQVJNHnRaDcZtgTqOqnTTLxvDA6VK+x+WSehIfuCkfOWWhRVTNSWaEqcSd/zenzaJ8Az0NxuoRVfPtTNnBMKo+sM38gEb0Wx5TdeWQ223vi9leInBA+W8+1nrsaT4F/mV788kCmMOtpJ8vfHoBap1HOJPuB/wTcXAyfuG1NtgojepSx8J0ndmI5peKaE6VBH0VX+vfw3c8+Mg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BBC1D66B546D4F4EAEABC039D8CDCC10@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af14d565-782b-4904-e3f0-08d880247230
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 18:15:29.5090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MeAi+MUlnJVAX12NuDwajY40q4Uz1tkQMSgR30fInDYCYe+r2so2d9ruE92xqIox8l7e6ecXXnEpKQ7hTVXWlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 09:04:11AM -0800, Jakub Kicinski wrote:
> In a recent discussion I was wondering if it makes sense to add the
> padding len to struct net_device, with similar best-effort semantics
> to needed_*room. It'd be a u8, so little worry about struct size.

What would that mean in practice? Modify the existing alloc_skb calls
which have an expression e that depends on LL_RESERVED_SPACE(dev), into
max(e, dev->padding_len)? There's a lot of calls to alloc_skb to modify
though...

> You could also make sure DSA always provisions for padding if it has to
> reallocate, you don't need to actually pad:
>=20
> @@ -568,6 +568,9 @@ static int dsa_realloc_skb(struct sk_buff *skb, struc=
t net_device *dev)
>                 /* No reallocation needed, yay! */
>                 return 0;
> =20
> +       if (skb->len < ETH_ZLEN)
> +               needed_tailroom +=3D ETH_ZLEN;
> +
>         return pskb_expand_head(skb, needed_headroom, needed_tailroom,
>                                 GFP_ATOMIC);
>  }
>=20
> That should save the realloc for all reasonable drivers while not
> costing anything (other than extra if()) to drivers which don't care.

DSA does already provision for padding if it has to reallocate, but only
for the case where it needs to add a frame header at the end of the skb
(i.e. "tail taggers"). My question here was whether there would be any
drawback to doing that for all types of switches, including ones that
might deal with padding in some other way (i.e. in hardware).=
