Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C48279327
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgIYVU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:20:29 -0400
Received: from mail-db8eur05on2079.outbound.protection.outlook.com ([40.107.20.79]:2273
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbgIYVU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 17:20:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5FWt4zOfZhwCsfRGSr5PCpTwbn7NBQNVRdF6kHCbQ67BVojp2kvfNDIuCm62OfpgK846LtugffMv3G9NWaIlQlaY46q2jdqdJqrJ4E7hIEg/amA2+BdScvXedfMj9H1lYPp6IpztosASMOFzmXjLhXietxmJg/lfbkqBQ1WkBwo8HhnBf2E1OLnIFZRddOra54wrx8bID09lou9erm4lopgkp8cTbwUOD45utrqFlfS4lzoaLAd8u3ZgymujpddiAB4BeXC6pOwpHcGKUI5XHbhgw8faQ+JarKrIexssrznV9N1otS50TgnE3lHaKu1EDTPIsO46bL0HegvSE8p4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Av9x2p2nIbXQUe97xReR/kTJKVQ62VRjM6QsWQ3doJE=;
 b=IPVKN5mcWNvgqnnLApBxABpA9EcLb+odTRGcUXvL6q73wuoApWv8bxwOR+FdtrY7GgGw5ybH/tee03zIEbiZMvtehR5DZ7E728bW0XJNVojs6c7nPnorAd8M6uylJKB2fHwUwUVnWRX1JySUTqUFhphTuFzspm0Ysada55+kf6JYvgEiL+EPM+khV6frLG5K8FuVJ4nyNyQPUeG7UqsKpSApndmsJNn2EB6PMkyfvFRtxdO7E7GEBBL53VBSX2CnlwOG0CyfaNN6aVx01HsDBanor8SRnifkH+th05imfFcbetbw2oyALU/vp7RN0ov/fQKj4QmSHIV7WsViwsHfzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Av9x2p2nIbXQUe97xReR/kTJKVQ62VRjM6QsWQ3doJE=;
 b=RxjxSt7ERX/E8R0r/LqjNshgE22q3mxFTHTfuFpGqHlDunLJGxBLvz53EJ8HIMtDVupkA8+y8+RnNtfeIWMIUraHpUsIlodYedFpGeldjSo2r4RJ/RYSFZ5NqjoEURbza9Qq6ZZY/bX33ex2EhA8UdX/ISpfaKggiU+FJSfzTws=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3070.eurprd04.prod.outlook.com (2603:10a6:802:4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Fri, 25 Sep
 2020 21:20:21 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 21:20:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: vlan: Avoid using BUG() in
 vlan_proto_idx()
Thread-Topic: [PATCH net-next v2] net: vlan: Avoid using BUG() in
 vlan_proto_idx()
Thread-Index: AQHWktK1dn50WyUzM0CepvJlXrMX+6l524cAgAACKwA=
Date:   Fri, 25 Sep 2020 21:20:21 +0000
Message-ID: <20200925212020.5cniszgzxfw3lq7r@skbuf>
References: <20200925002746.79571-1-f.fainelli@gmail.com>
 <20200925.141234.274433220362171981.davem@davemloft.net>
In-Reply-To: <20200925.141234.274433220362171981.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 969be894-eca4-45a9-40c6-08d86198cf55
x-ms-traffictypediagnostic: VI1PR04MB3070:
x-microsoft-antispam-prvs: <VI1PR04MB307007DFD9F6E506535BF511E0360@VI1PR04MB3070.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zGnrs5lJSX1KIaUHHZz9NqbRzAxrrtimkcKmvucspfEVDvDgm9uOdkBRMszQEixPYCI36JH+mMlhW1tUKCu3Cz8DtG33UEdibwrUSPBTjUQ6E4a73TzR+25jQ0psqEvipcxiCPE91scfHiaebMNOM/cT6PTiVUsthI2VPpmUHxSZLo8DLAtLqc1meOsrcrOG8IWa9MkYxNqWN9MXIHyLih04FH/BGY4q07WbtzvYyb9cSGyZrmv2qXvuq9qzXgCt55hM55d2HOGfV8/VT9e/4578kpLvY91EXdAjDWjcoa/tdSQVLQyQV5coBl5ouOqFx0x1IQ0xr+BGoJOjxGuVqaE+bSfPYT0eCwR6TKHcl+e606ldXWjp3O/urmT+eqDt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(136003)(396003)(39850400004)(346002)(376002)(4326008)(6506007)(33716001)(54906003)(71200400001)(6486002)(5660300002)(44832011)(66476007)(76116006)(66946007)(558084003)(6916009)(1076003)(186003)(86362001)(316002)(8676002)(66556008)(478600001)(6512007)(9686003)(66446008)(26005)(8936002)(64756008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 9GbUPK2BTYX8rNwzGTaxk7BJ5YfCSG+CpM1iWac7xQF/T7PfaLpbwoQ2DzK8Q+39HMniHPUAxKCISEUc6wUOln78NepNy/MFiM3h1wo21xQYWFaTxaNfLNvOyJx5us7Dm5S1J0Tq2XXIChLOYmAWIxaoYx3HGWsEjg81HLN3taS9DA28z1Ar13fTlYi+uraqC/Z+3hlOsRpIfcjvb+5u8ylgvIDuSmzKdgDmHxycOet9e4h47uOZA+ABk7kyLQHIUXE1v2rnoK3ryBozN9OdzTuu5wVKYKMXd76AggslHfmSZwy8m+1fuMG1c0t/YPEQgAE7wyRpjkgkdXtQa3d40WO5KjbU6Eu6Tw4pI9z9X24mB35XbK2x2rsziWOznaIY7D4B3Z4eXb9GkZex/fQJR42UDPN3twuucnvc7pQVLD7wQjrNx4+JKSVlcpzh0xj+ztu+nSHwO7VGIr/qrHUtThi+YKU8c/iamPa5Jq/uUpmG8CTYpy5aL0Y6zpLujAMaHi9S6TBtbTXsiQZWmiVPIlrZYqM9eRLoQCfM61iT+PSralA4wif9b8LRoymSn020A+W8mO6om0BiVRzKpx+ET2SzjQ1KZ1KIXieGpR6/RUZtG0ebXHGt0P2JaO9RM2IOtMcy/v8/O8W9wi2k3YFF8Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <39BA77D0A56CFD419C493CBAC6E039EA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 969be894-eca4-45a9-40c6-08d86198cf55
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 21:20:21.2860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p6RuqLeaN1rr7YRMPD58ISbTwZIyv7eHooBKOLYUzx+yZfm/XZlfxDZyrx4j3g0bikVpWywki2rrYyCQB13tNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 02:12:34PM -0700, David Miller wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> Date: Thu, 24 Sep 2020 17:27:44 -0700
>=20
> Applied, thanks Florian.

Uh-oh, that 'negative value stored in unsigned variable' issue that the
build bot reported was on v2, wasn't it?=
