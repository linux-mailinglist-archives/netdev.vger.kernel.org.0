Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27A42925D9
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 12:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgJSKaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 06:30:52 -0400
Received: from mail-db8eur05on2075.outbound.protection.outlook.com ([40.107.20.75]:34400
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726791AbgJSKav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 06:30:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYPI2mT1I7LxCB6CAC5cjYHBDi2U8Qjt2iQfL/vMDs/RsGAo+hpmpk9BcHmJgO6cmVgiWsr4f5WgB7lk6QGvyYIxPMzdOHguMRICFRXzSO+AObfRV1cqNVLAVP6Ov8thNw0jm5u6lh8WbMkPtMewDpHfGegsO0efLjACTZX12u7tYSsG7DE6viJ/Mwz7dNQbohEVAxLs1LO54fGombKrSwB3nDuxC47XXa9J7HDZENzjyZHjhZlcaBld0zyPHFvO5P9ljW/G4cSswqTlDn0BFTgXYn2aQ9W3KQ1mxm5bA24Bgfqf0LpWmystjnIpT+TmqPO5CezCv9HoUw9xmD4UwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTUGfpPStRuWArcsdObwXoQHRi8Z1OFonkY1EqNhGYM=;
 b=LmIwc6XQDxl/zazYzsJ7MvvX8t7HwDqGeVnb+GHws4UWAx9iGPxP/8nYqYhbGnWs9/ztqy7cIAb2ApByNNyhOO31RC7lWV+ZJzKKbd+aFAh7kBuBahE4/R/4UYb+Lz+FD+6WV4+9Vjz/WtlrT24Y4F4c+8x/wa4Hzj1dbqqudP692LOslEMu9EkIKBZZ7LrSN40gzFpL7HNgbxV74yDDF7Wf0Txk2PjWWubeu3HkXK84apZZj8HNOdpKQSYxPr/IBFu3+uQQM4AXKe9AZ6TggDvT9kg9IpcVyEuzUziSb9QzX0OI/pLAqKef4dijMd692Ev+lDAsJodLIuL3l3PKag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTUGfpPStRuWArcsdObwXoQHRi8Z1OFonkY1EqNhGYM=;
 b=dUPKtn7isl4kIhWUyNZLfUZv9MvDjGoCB3u2JuJPw/pkXCVT4NFnlehK3X6tOcUea+aHo53nHRFbXozYEIYyEh3joA6UV2bPKuhRaFVS3gje7QE/4ZXitBtyz7hcMgQvGOtvxRUvB5LhaZHbqFBSk/gR4kzto7jch7GdUnBdGZo=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Mon, 19 Oct
 2020 10:30:48 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 10:30:48 +0000
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
Thread-Index: AQHWpM2WRVElJamqkEeHVtfDsj9ayamcWGgAgAADBACAAkAAgIAAIMmA
Date:   Mon, 19 Oct 2020 10:30:47 +0000
Message-ID: <20201019103047.oq5ki3jlhnwzz2xv@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-3-vladimir.oltean@nxp.com>
 <20201017220104.wejlxn2a4seefkfv@skbuf>
 <d2578c4b-7da6-e25d-5dde-5ec89b82aeef@gmail.com>
 <049e7fd8f46c43819a05689fe464df25@AcuMS.aculab.com>
In-Reply-To: <049e7fd8f46c43819a05689fe464df25@AcuMS.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ACULAB.COM; dkim=none (message not signed)
 header.d=none;ACULAB.COM; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bae7f52f-fe77-48b5-04e0-08d8741a0b5a
x-ms-traffictypediagnostic: VI1PR04MB7104:
x-microsoft-antispam-prvs: <VI1PR04MB71043748C87E9B329D55AD86E01E0@VI1PR04MB7104.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T2pcg96W6q6trAfX54xxfgzXWq+ymA/xNiKe7RHt4K9R9uFWAFdSYgwvENEjZvTlRYz9UYfZ1BQYNlpUoScSswKNf6HgVvhqf0NCLLa2tZOdlyXLitgs5dHAZE0BC5Q8ptmpORa2U0VGfpmfisuuEn7/s+8v0tBw/Pzpj+FBaob2Sk4n3mPNKmgTZEBpc/MrfTT3/LeLpzjWra+LSPOqMd2gi51ocm4i+3yDpArBGzb5qDq4tYDXGmqj1XtDeTcLWdeDHWsGSPke+Wk5wIGXRsHUAjs7ItHzpHYZiDAtHF40Nzr8u+FiRdVnEGI1CZuX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(8936002)(33716001)(54906003)(6506007)(8676002)(26005)(6486002)(186003)(316002)(86362001)(71200400001)(76116006)(2906002)(4326008)(6512007)(9686003)(44832011)(6916009)(1076003)(478600001)(5660300002)(91956017)(66446008)(66556008)(66476007)(66946007)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: VGR/GuYd+y1ospjIYpVCbmOIMwCz6cAQeiovM/ws7dSpDTJ4y/DoIQJAno+zDhfjE5iBcaQwxsRA0hQ0aA43BkPfCOYVctFi1GEQPS7AjU4FIPvrex1IDwm3C6hoLPyBhmM9jF2wq6BBDTjVX9vBvZMatvAdXc7e1o3ID9lntKorkP3Vq/FTlZwtIwJBOoZUqwLl+8vojeujLn2pcc6dDYyGS0mLmBJXSc8gVwjYHxma1lPmZe/Vl26I74vH/789zXYQj4FxJRd8OCKdEYDQN2Fu4hWg0Ug3YXy9n85RrKBccf4bb+pOOT9BcNStzn44r1vDShSj9ilFtei2XxDpIPMRvSsn2K2O018NFTqVXrQAERQu24dnE3rKHEPPwwrGfGzfj7YszhWOkM0npK5azLJHItEPs1ALemVTucqTfkQcvTCnsyHZerC3hxtOJ2VNx+vn2ol1ESKeZgNtMn8kO3MISFDlKgLe7D+cUjCUN/Iy24VChdKU/0jpAT9Q6nqqt8QUU/vIYlsCPMIWnh80W4vD4eIDoDc3YecDk/bCNjjnhz3Jbszn+MN6uxo6FvlJih23qCqFwvQNRFIdmb/Lu5PKRPl4mc43vn/AKiTMsFAhrwzrz7TVJxPD1y8Wde0NaBMgPVCLRcrBxJAxKg4ZfQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A1D9E28799D14A4A81A96771363AC594@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bae7f52f-fe77-48b5-04e0-08d8741a0b5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 10:30:48.0126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jSwkVoqLmtwVi6SS0HZRL85cLG5TwJq68Rll2pTiAAGqFryy0vf1SgYLCm8zSf0TUTxohQ7QPV+j/Uh1sWe4FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 08:33:27AM +0000, David Laight wrote:
> Is it possible to send the extra bytes from a separate buffer fragment?
> The entire area could be allocated (coherent) when the rings are
> allocated.
> That would save having to modify the skb at all.
>=20
> Even if some bytes of the frame header need 'adjusting' transmitting
> from a copy may be faster - especially on systems with an iommu.
>=20
> Many (many) moons ago we found the cutoff point for copying frames
> on a system with an iommu to be around 1k bytes.

Please help me understand better how to implement what you're suggesting.
DSA switches have 3 places where they might insert a tag:
1. Between the source MAC address and the EtherType (this is the most
   common)
2. Before the destination MAC address
3. Before the FCS

I imagine that the most common scenario (1) is also the most difficult
to implement using fragments, since I would need to split the Ethernet
header from the rest of the skb data area, which might defeat the
purpose.

Also, simply integrating these 3 code paths into something generic will
bring challenges of its own.

Lastly, I fully expect the buffers to have proper headroom and tailroom
now (if they don't, then it's worth investigating what's the code path
that doesn't observe our dev->needed_headroom and dev->needed_tailroom).
The reallocation code is there just for clones (and as far as I
understand, fragments won't save us from the need of reallocating the
data areas of clones), and for short frames with DSA switches in case
(3).=
