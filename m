Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5090DB00B8
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbfIKQBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:01:50 -0400
Received: from mail-eopbgr130089.outbound.protection.outlook.com ([40.107.13.89]:57358
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728820AbfIKQBu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 12:01:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1IXzANZpG/VBMbvaeDN13lF5VBcGyrw7kPZpKMUIhCh2B8QUSyhO3EV+quMJni0JOs5OQhzM7EdWHUbGjezxmxuNY2oFG+ipS54Oggm4o+9P3PnnbmdQE9uy8Q8+KNDXXOgPckPO9g/D7UVQMxzAraHpYL9gWDmMtMI06LtN7b4br+UlmSEa2hTXNcSUDNcTm+3UyrFy4GjwnYFVIADTK7cvZZ+0uHT0b8POOopkh8apPJ47MuFV3MOWVKgeaAUdYi+T463WoLAxZ4asd7ARM1ffW8IlIfpczThbjIdP4YqljD6ub/eZY3Km9FgPA7Wy0S8P4qIUek7gqbrNLbbgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HaxLKT8k0sH+iD9O69PiGZMmJ15xqB9OLgQkSdmzlfs=;
 b=TYpZshoXIoDs3DAPcCfWC5VAy0e8DEXsVIaug7C/NjCPgJdJNWPIPi4V7aJC86nc5ZRyjYOXTRVJ5dH1IMb0EPXoAWs0QS6ABi5XjULlREoXmZED77Ue11OuEdqc3NcwgkB0rO8Tag0Be/i0XQETjdrU3F0WVXAgngR/fLn4TvmS1NZNEG3uObwtV5wTM/WqiEK7jXpgJkmd1rfhZKEsqX7jRDkkDE/LYa6HKd11wVKpu6sPL00fzWK/jrcrd8HwAYf35Sd5GVZtPRWyZEwuWJbc14VvjdBsJEs8KaEcfsW2NQ3lypFLf1FzD5rlAWh7U10RE29MUNNARexr6BESsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HaxLKT8k0sH+iD9O69PiGZMmJ15xqB9OLgQkSdmzlfs=;
 b=fr3ga9aMuHoW/r9GghmmdaefLBc7OYibgWgPXa4EF2bYd517C+DIOl6wjOMFePqXZObmlnEKq4P0j+XFRmYAVH8TNfwLc4oQW10ktw7NR+MEpPjF2tkwtFaSi7rgiio2Jdtq19s8D7GJqsccGBCbf/DiG23WQgdMiIJrw2y6lY4=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB6157.eurprd04.prod.outlook.com (20.179.27.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Wed, 11 Sep 2019 16:01:46 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::484a:7cd1:5d31:db4d]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::484a:7cd1:5d31:db4d%6]) with mapi id 15.20.2263.015; Wed, 11 Sep 2019
 16:01:46 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/5] enetc: Fix if_mode extraction
Thread-Topic: [PATCH net-next 1/5] enetc: Fix if_mode extraction
Thread-Index: AQHVZL2XLm4ULc70SkKGxUWVBUt4yKcfETWAgARtDSCAAQ9VAIACEYsA
Date:   Wed, 11 Sep 2019 16:01:45 +0000
Message-ID: <VI1PR04MB48805CB7B660EADD62BA347196B10@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
 <1567779344-30965-2-git-send-email-claudiu.manoil@nxp.com>
 <20190906195743.GD2339@lunn.ch>
 <VI1PR04MB48803DB044AB6CF66CACB89E96B70@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <20190910074412.GA31298@lunn.ch>
In-Reply-To: <20190910074412.GA31298@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80cd2c56-fa1e-458b-609c-08d736d158b4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB6157;
x-ms-traffictypediagnostic: VI1PR04MB6157:|VI1PR04MB6157:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6157CD3E5EF5E940A840365D96B10@VI1PR04MB6157.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(51914003)(54534003)(13464003)(199004)(189003)(6246003)(11346002)(478600001)(229853002)(66066001)(76176011)(81166006)(6116002)(54906003)(66946007)(14454004)(74316002)(476003)(4326008)(8676002)(81156014)(76116006)(52536014)(561944003)(99286004)(7736002)(5660300002)(6916009)(33656002)(316002)(305945005)(71190400001)(71200400001)(486006)(186003)(14444005)(66446008)(3846002)(53936002)(86362001)(26005)(446003)(44832011)(6506007)(8936002)(66556008)(256004)(6436002)(55016002)(9686003)(7696005)(25786009)(102836004)(64756008)(66476007)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6157;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MkEe+3adgb0NYNMf7QuRZ6G9w8WWRa0NE+LFms552rFU3z8AWcJ6DORNCVjddDSoKC01VRdmZfZ3GQhmU4M7XIxQJru0ehQV0RWhuKYLpGpN40AXOIw1//4cIVaR3TCkc85mbQlVCKFSQ3xi8Bl/5vMnVagJAbVWIiLsvMRr3S9AYE6c6JWLUrA6tctfQEddM+5zsUa1Mxypm5auG0Hw3EEJVpGKHkbne3w8AGNKNROc5cUxJZgoKniyAC6tL5ZFvcojgI+tNvkX4Iaoq3WHiyx2+ZaSne5fIBZ+Ahbu7HMOdfe/lnTT8v8y9szRVaxQbsU8xneNGJgpobR+xbK1mcS0KLGsMUqMAZHCTiB8IMn5qD4rAVQqDnIpux3AUu4xIlZvRJ3Vk9Ht4n0VO2kwCxije3h9WYHHQ3hrr98OBM8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80cd2c56-fa1e-458b-609c-08d736d158b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 16:01:45.9685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jl0nNf7snYo/YTeIfb5vf3/0grtRvls96NJ6B19s9eB++yOu1M51m/l0FYcr440RWoTUL0bTsywJwhfKzQRPKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Tuesday, September 10, 2019 10:44 AM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>
>Cc: David S . Miller <davem@davemloft.net>; Alexandru Marginean
><alexandru.marginean@nxp.com>; netdev@vger.kernel.org
>Subject: Re: [PATCH net-next 1/5] enetc: Fix if_mode extraction
>
>On Mon, Sep 09, 2019 at 04:24:01PM +0000, Claudiu Manoil wrote:
[...]
>>
>> Hi Andrew,
>>
>> The MAC2MAC connections are defined as fixed-link too, but without
>> phy-mode/phy-connection-type properties.  We don't want to de-register
>> these links.  Initial code was bogus in this regard.
>
>Hi Claudiu
>
>This is what is not clear in the change log. That this code is removed
>because it is wrong. Please could you expand the explanation to make
>this clearer.
>

I agree, but I also need to modify the patch to handle both the error case
of invalid phy-mode for mdio and normal fixed link phy connections, and
the mac2mac connection case.  The mac2mac connection case can be also
deferred to a later patch, when the switch driver - Felix - will be availab=
le
(there's no use for it in the current enetc upstream driver).

>> Current proposal is:
>> 			ethernet@0,2 { /* SoC internal, connected to switch port 4 */
>> 				compatible =3D "fsl,enetc";
>> 				reg =3D <0x000200 0 0 0 0>;
>> 				fixed-link {
>> 					speed =3D <1000>;
>> 					full-duplex;
>> 				};
>> 			};
>> 			switch@0,5 {
>> 				compatible =3D "mscc,felix-switch";
>> 				[...]
>> 				ports {
>> 					#address-cells =3D <1>;
>> 					#size-cells =3D <0>;
>>
>> 					/* external ports */
>> 					[...]
>> 					/* internal SoC ports */
>> 					port@4 { /* connected to ENETC port2 */
>> 						reg =3D <4>;
>> 						fixed-link {
>> 							speed =3D <1000>;
>> 							full-duplex;
>> 						};
>> 					};
>
>So this connection between the SoC and the switch does not use tags?
>Can it use tags? Does the hardware allow you to have two CPU ports,
>and load balance over them?
>

Unfortunately the switch can handle only one port with tags.  There's only
one CPU port, switch port 4 is just like another front panel port.  On top =
of
that, the CPU port is not capable of flow control (pause frames don't work =
with
tagged traffic on the switch side).  So we may be forced to use port 4 to m=
itigate
this.  Note that the switch is inside the SoC.

>This second half is just standard DSA. This looks good.
>

Thanks for the confirmation and the rest of the review, all valid findings.

Regards,
Claudiu
