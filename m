Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D55C226CAB
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgGTQ7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:59:14 -0400
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:56709
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728903AbgGTQ7N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 12:59:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K62S6lgu1oKXYQUz58nWaScmFF+G6w//nAENbvtopCzENfwdN/3Y7/prTk6z+156dKQsv/EOjLSIuD7Y4QQKl3k9EJpakqz3H+sdUgtVWWAsLjueCBZvBRFd1GIv9eKPAqnJ3J3NNMYWQ+ncYaz0P9a6DCL5t3LwHQYgsvFxb8fHclNbi1DjdxcPvFjgtYsRI0ZorR4lrBR+t8Vc0e+9waiLJK0sB1hz7eV+Z8KEWdPXOT314duwNJySawdBMBwNb2jC9Ffnv5qbfq4rdgT6JCUz+P0LIOD0kMwuiL9eirEKS7yscbYlTdJFRLavQ3JCwBscrkx4m68Ly6DMA7Yaig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFGDssD0tny9uPmRqWOSwrIJMTSXUfOMNsrWemYSXgA=;
 b=amNIPCZA8+HNnkqqIYT1A+cicRAsrHll5BBQor/cIECnG8u5otCLeO5PEb8h/fLxxBC0nlYO9QVn7WYx+3b4oxM3NM3X+iiGtBq1VyCxUnlb7bLik71hhm0dp8tbb32lVwrPAK2xHxaitNIVn47W9ZBZ5IMcIkMbc+f+ZG+koc9YknMBngLMRElxj4ddTXuwqVma45nPEG/2CvuehZWfGN3KH8lc4ram3elvTZJhvAS2JDh3Yhdpku2E4bbr3ibI0z97kJufjUACelBHcmDKLXhd/04Glpg89H8NscJbj/DFXnQTloUcD4rARlXzkqwvLeckRkiAkZAv671bj6ErYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFGDssD0tny9uPmRqWOSwrIJMTSXUfOMNsrWemYSXgA=;
 b=FzxuuC5O6tO2IKzMK1fCYr/trNIlHLWzBT8H61DuT0aKEL+3EX0tCmwoORqavipWWz27+C/SAoECQb2YnJVnpOJwaMqoTYFyedYBXnOa53YfjbUgk0EuyAPMbjMUMH002Pxh4mAKuE5Fs7ouLANGw8STSXoyPyAlXwSBRW47ccs=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB4302.eurprd04.prod.outlook.com
 (2603:10a6:803:3f::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Mon, 20 Jul
 2020 16:59:09 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba%4]) with mapi id 15.20.3195.025; Mon, 20 Jul 2020
 16:59:09 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC net-next 12/13] net: phylink: add struct phylink_pcs
Thread-Topic: [PATCH RFC net-next 12/13] net: phylink: add struct phylink_pcs
Thread-Index: AQHWTuri0oj85lgbdkeFoRazHWzWkQ==
Date:   Mon, 20 Jul 2020 16:59:08 +0000
Message-ID: <VI1PR0402MB387129A07C77AD9D08871F18E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHGO-0006QN-Hw@rmk-PC.armlinux.org.uk>
 <VI1PR0402MB3871010E01CD0C6BADC04520E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200720162600.GW1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.219.134]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 306be686-bbf7-45aa-1caf-08d82cce382f
x-ms-traffictypediagnostic: VI1PR04MB4302:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4302A077276F2AA1DA6BACD3E07B0@VI1PR04MB4302.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AzUTig7HuMTZ2M6fYTn9rjTyLl+85CwZ9ARjx1vNPFvVcY/ivMKINZ1zr6qCXeS5+JN8absJiZLRcjdHBqY9LWHCC/ipjCtBQP5KR5bjggOR6Vyf5EuDsxtunNKke3c6sQiIxHLLwXGWItPbldaNA1SMNWGkfM7jcQaoM5b5Bxlo/1fCEtKoqQOQIhODMWcr89ovvZFR+6lH+O3DOEMHWeX7N0JbbkFUXcUbG65dRiLPZMAncg/7uwMDfDhxjK+xmVNve3fS0jF7/njx5sOy14/YxOOrL7ck4f8eHiR1zCtIrmyPF3iiy4g+o7KvqjTetnbP1wOFg+EsHfBnPuhnQ/NDu9xVnwpZhxCYnLyrEFaGdAIflv9630PJxIaqxvz+7sA/oSfuBCZZZyQKhbCERw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(6506007)(53546011)(186003)(2906002)(66476007)(8936002)(9686003)(316002)(55016002)(33656002)(4326008)(26005)(76116006)(91956017)(54906003)(478600001)(86362001)(5660300002)(44832011)(52536014)(66446008)(64756008)(66556008)(66946007)(83380400001)(6916009)(7696005)(8676002)(71200400001)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /Mn7d9tRc9HXIEvi9x8QmejLEJ2m4mNdgD7Ywy2SCtaanJzcvRRSudpeErLU7bIf4ROtIbHU5No2GfjwGv7mj3C048rI8uSX30yoGG/tgTWkb30TWYJpLA/lgd4SW6gis9AYqR7QdyWMirnmCadOPhr+bG3rxKsC40iP0Vw7kIQ4tbwZ/6doStybYw9Gc47P7+gZgnp1YcRbY84VAYa5bBuepa4N9bmFoBnDp8802HkovnMOaGoCQ0aYn/3uL+fTyHyH5sr+iIwC09jS/07DxSsGGUUl6VmXCBVcuutZ10Walqnum/XlVVo1I40ftYFmJoiVCufBlAtvVM8Vq8LCr79Fq8GOHZkgz1YJj5NSyU5FOB/AhjILifRcB3TtsV52EEd6h54SUU/Bwqv23p+nqu8VW1XzDybX3/esuznlWOOnNr8XkbESxJJdYFiIDf1RZFqfDJlwZEV6f1aVzX5V+PqRmha7cC+KyxGJ4ier4j8WwP8AwWaNDW6h2Ecj0pMw
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 306be686-bbf7-45aa-1caf-08d82cce382f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 16:59:08.9262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vpk6SHnZVlH5ej/qS71EB9Ld+0DVix91RYPdxi4bxxgPPw5UvcsU5O1VxGS7ujnO2CozwXZfEogBobT0WeCmFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4302
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/20 7:26 PM, Russell King - ARM Linux admin wrote:=0A=
> On Mon, Jul 20, 2020 at 03:50:57PM +0000, Ioana Ciornei wrote:=0A=
>> On 6/30/20 5:29 PM, Russell King wrote:=0A=
>>> Add a way for MAC PCS to have private data while keeping independence=
=0A=
>>> from struct phylink_config, which is used for the MAC itself. We need=
=0A=
>>> this independence as we will have stand-alone code for PCS that is=0A=
>>> independent of the MAC.  Introduce struct phylink_pcs, which is=0A=
>>> designed to be embedded in a driver private data structure.=0A=
>>>=0A=
>>> This structure does not include a mdio_device as there are PCS=0A=
>>> implementations such as the Marvell DSA and network drivers where this=
=0A=
>>> is not necessary.=0A=
>>>=0A=
>>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>=0A=
>>=0A=
>> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>=0A=
>>=0A=
>> I integrated and used the phylink_pcs structure into the Lynx PCS just=
=0A=
>> to see how everything fits. Pasting below the main parts so that we can=
=0A=
>> catch early any possible different opinions on how to integrate this:=0A=
>>=0A=
>> The basic Lynx structure looks like below and the main idea is just to=
=0A=
>> encapsulate the phylink_pcs structure and the mdio device (which in some=
=0A=
>> other cases might not be needed).=0A=
>>=0A=
>> struct lynx_pcs {=0A=
>>          struct phylink_pcs pcs;=0A=
>>          struct mdio_device *mdio;=0A=
>>          phy_interface_t interface;=0A=
>> };=0A=
>>=0A=
>> The lynx_pcs structure is requested by the MAC driver with:=0A=
>>=0A=
>> struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio)=0A=
>> {=0A=
>> (...)=0A=
>>          lynx_pcs->mdio =3D mdio;=0A=
>>          lynx_pcs->pcs.ops =3D &lynx_pcs_phylink_ops;=0A=
>>          lynx_pcs->pcs.poll =3D true;=0A=
>>=0A=
>>          return lynx_pcs;=0A=
>> }=0A=
>>=0A=
>> And then passed to phylink with something like:=0A=
>>=0A=
>> phylink_set_pcs(pl, &lynx_pcs->pcs);=0A=
>>=0A=
>>=0A=
>> For DSA it's a bit less straightforward because the .setup() callback=0A=
>> from the dsa_switch_ops is run before any phylink structure has been=0A=
>> created internally. For this, a new DSA helper can be created that just=
=0A=
>> stores the phylink_pcs structure per port:=0A=
>>=0A=
>> void dsa_port_phylink_set_pcs(struct dsa_switch *ds, int port,=0A=
>>                                struct phylink_pcs *pcs)=0A=
>> {=0A=
>>          struct dsa_port *dp =3D dsa_to_port(ds, port);=0A=
>>=0A=
>>          dp->pcs =3D pcs;                                         but I =
do=0A=
>> }=0A=
>>=0A=
>> and at the appropriate time, from dsa_slave_setup, it can really install=
=0A=
>> the phylink_pcs with phylink_set_pcs.=0A=
>> The other option would be to add a new dsa_switch ops that requests the=
=0A=
>> phylink_pcs for a specific port - something like phylink_get_pcs.=0A=
> =0A=
> It is entirely possible to set the PCS in the mac_prepare() or=0A=
> mac_config() callbacks - but DSA doesn't yet support the mac_prepare()=0A=
> callback (because it needs to be propagated through the DSA way of=0A=
> doing things.)=0A=
> =0A=
> An example of this can be found at:=0A=
> =0A=
> http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=3Dmcbin&id=3D593d=
56ef8c7f7d395626752f6810210471a5f5c1=0A=
> =0A=
> where we choose between the XLGMAC and GMAC pcs_ops structures=0A=
> depending on the interface mode we are configuring for.  Note that=0A=
> this is one of the devices that the PCS does not appear as a=0A=
> distinctly separate entity in the register set, at least in the=0A=
> GMAC side of things.=0A=
> =0A=
=0A=
Thanks for the info, I didn't get that this is possible by reading the =0A=
previous patch. Maybe this would be useful in the documentation of the =0A=
callback?=0A=
=0A=
Back to the DSA, I don't feel like we gain much by setting up the =0A=
phylink_pcs from another callback: we somehow force the driver to =0A=
implement a phylink_mac_prepare dsa_switch_ops just so that it sets up =0A=
the phylink_pcs, which for me at least would not be intuitive.=0A=
=0A=
Ioana=0A=
