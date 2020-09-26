Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4394A279BA1
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgIZRzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:55:42 -0400
Received: from mail-eopbgr60081.outbound.protection.outlook.com ([40.107.6.81]:18403
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725208AbgIZRzl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:55:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJAD9vfgbl3883en8Fl5nQchQc0zVU1SrzKHc+nSQpOCU3vk4JAEHFo/vOAV6LG+Gwf2IQ26IPS6KpYt5M3sVJEOnwZ6l8aylYMq7TX2GCCIlz2UWridNMyJ4qkZkJValJZhr6fp0TL7Jgkgr3KQbKlGWOf4kycqquiDj/qSBtbuvyaINo0otkKYyMNPs2rCO/T4oqP4qhmhW/fvAQuJI6O05WR4n+piCIaosdk5dLp51fOiO7kKDB/WvIs6vscIWx+t8wiBHpgrKp5S1IBaGilbow9o3mbXdiJy3JxuZduiMWc4SVsboV4ApVMUp3rYrAEsI5ENbS/iz+lnM3kzPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyQNe6e4vQ5GTz7AdMus8kM1ew16BtRbRfn+c4DXFxk=;
 b=mAgPuQO81OHcqO77p2vTrJ9sX7U0lmwXwiMQ1gad+hk/H2d9WYyyy0nOBuRIYaw14X4u5P0W4WvPMlvUmv0DGvX6ZBbhSO/tZuVR8Rdbpa/bDBEMOtai7UA3O+77SsjE0otvbwzUR5DMnn2OyKIrtdgwHaZ9vmDwwYMgHmABMugKWTUk7sno9uXJU9mfDQtplvfRzYjc90Md0Ts0nTMTvGal9KHiJnjWUsAGvKdjwy2wVQXIsLKfLTnNuDzpmD7cNXzxUJ41MDH3g+TBmxeo8rvgne3T6wbl3VAvJea8kMNC8+9tV/M0y5lD2R14cZ7cEbm8uTNkCkYROmQf40L5lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyQNe6e4vQ5GTz7AdMus8kM1ew16BtRbRfn+c4DXFxk=;
 b=Pi+i17Osj6LL33jRSvjuC+g54p525D1BMHnsxvGOJ5OkEFHyaE/nr51kkr4Sw1GRNqaUm9KfFFuBUVnHj6N9roI8y2vVJtPQidtE4isxqTfPB97CPHO4c/iTdLfIz8CkUedlqQ0JyUjPQLYrpXbfphYzX0G72tYT9yjTxY5Dkqk=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Sat, 26 Sep
 2020 17:55:39 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:55:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH v2 net-next 02/16] net: dsa: allow drivers to request
 promiscuous mode on master
Thread-Topic: [PATCH v2 net-next 02/16] net: dsa: allow drivers to request
 promiscuous mode on master
Thread-Index: AQHWlCrazxphPqBDFke6Tvg+PJuWy6l7MbwAgAACaQA=
Date:   Sat, 26 Sep 2020 17:55:39 +0000
Message-ID: <20200926175538.amkogkm4qt6azudc@skbuf>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
 <20200926173108.1230014-3-vladimir.oltean@nxp.com>
 <20200926174700.GB3883417@lunn.ch>
In-Reply-To: <20200926174700.GB3883417@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 33f4e1e7-5083-484d-e058-08d862456104
x-ms-traffictypediagnostic: VI1PR04MB4912:
x-microsoft-antispam-prvs: <VI1PR04MB4912ECF6BADC0A4EBAF4EC7FE0370@VI1PR04MB4912.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ckk6i6yVpnBS6vo0IrDadUS0CJ9BjjNsA/R4oI5d2Fe1hajXZQkqT3Xqz8pQ0B42/OsSopQoq+C3d5Tdx+o45SyAejJW2pUdolhB9tPDTuRbLaKynHtDmxrlhmLMnkZbnwPPSu90wbHVPV30ievcBXaKb4bDfJII7EncrqfaMb0A4QIT5QbBWrfEaZtWER+Gm79c2H1N5+GjkeOBj5RPzven6FLwt13p2bt8EON1x/wJlskz0Pj4ao9AV4oWb9unapLNugx/Z/JpgEFAxCARfHjjzGbymwn94fvwqgUyLulxeQIlHNPnshL2oHDQOcM7gpkEjvVrgkB2ek15QGYJGE9bPBecLYOgknTMj2EABEKW4uNYsD3kpxUVSYU+yNL8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(33716001)(4326008)(66446008)(5660300002)(64756008)(66556008)(66476007)(66946007)(76116006)(91956017)(6916009)(86362001)(83380400001)(4744005)(9686003)(6512007)(1076003)(6486002)(26005)(8676002)(186003)(478600001)(6506007)(8936002)(316002)(71200400001)(2906002)(44832011)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ttVna36hUIg98PQLjbk4tiLkqhlI9l35GNYPJxl/FizMU3Y7TQCmKCfvWGImlUvqZ4IV+rAnU3WSfN0AGorGdJofvAvfoPEOxsbIykyBYFvTod4u/24eKonrMZl25sEWqeJbEf7aUWlLWaeqdqqS7KnvZzHxOQNbnn0ejgap8yJmPvPpzu4DIBau5tVDM5xJA59euz2Q+kzvjTg0x2O6LV7weN7Sza2cijdYJUNszeV9zK2P5afk4LEwv3RreyuRNsBY4MOegwycBrTGSkFkVOCQfoZN+0fS4Yh1reUI9Bay9pP94oboULs3mMNvB06vIoH925xzPrhWuEEVqi+ByX737RiMBU7RwI2uG9XGuuHzPzxoQaqet8wbGU+qCavmE1oDUl/wmZhy1ncK0kgyZh9ut5frpuQanHKj3+Gg941PlFfDSvgeoscX2s5RDvh5Z1zLITi5BSFTBPWXW6rRjiehLDYOMFM+evZr+q2Ya6KglmeWLCXoDe4ySl0V/ARuF22F/svzSZCxcc5fP35kls9A2UVMvppLO5L0K0EY5bEXGYt1SINohlRmVfr49o6y1flhwjJolwPDqm0CDCZfpPn2aZGsUHW7Bx7IC/+yhitzNbhVEx6y4AZY1EofIhiA+sadQelgw5PqgHRmLJlK9g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CD3784EE2ECF204D84D0C65FBBE91053@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f4e1e7-5083-484d-e058-08d862456104
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2020 17:55:39.1201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jlvpp06aW/MG2g1MHHG7N+uHfYyAH08I20e0kmOqLrLDSYV0v4+ecmq/TA1Jc4SQQSnElsx+BZ5KHO4lqeEGnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 07:47:00PM +0200, Andrew Lunn wrote:
> Hi Vladimir
>
> I actually think this is a property of the tagger, not the DSA
> driver. In fact, DSA drivers never handle actual frames, they are all
> about the control plane, not the data plane. So i think this bool
> should be in the tagger structure, dsa_device_ops.

This is actually a good comment that will simplify my future work a
little bit. I need to add a Kconfig-selectable tagger for the Felix
driver (tag_ocelot.c vs a future tag_ocelot_8021q.c) and, predictably
enough, one tagger needs promisc on master while the other doesn't.

If you have no other comments on this series, I'm thinking about
resending it right away with this change, since I made a big blunder and
the people in Cc on the tagger patches were not actually copied to my
emails, since I have supresscc=3Dall in my .gitconfig.=
