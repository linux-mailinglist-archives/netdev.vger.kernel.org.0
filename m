Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF2345F36A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 19:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236758AbhKZSJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 13:09:50 -0500
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:3815
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233632AbhKZSHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 13:07:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H12Vbjgf9pK8qIv1jk25300i1yHXVxfKbadzzB4dTAEWRfr9OLN5yQfX775wymWQDzlv5pXBJxUM7bl95dcP6VNjrz1zZB+dhcqTerDSvz2pU6Nn18m58RCkcXLfmbfKD2J80pz3WHuDMtGFZOxgiwXTZMg/OS51qjb/CkW6UgV5dB53sg5jshEiM+Dy0J8FSJ0W48356gIXZ7N7AAJ+8vHMDP14PB6+Z62K8UHE0WjaeZGuxjcZSyoqgXWPlqt/pumblSObyj/ob6ZC7fEe9vdCvvqeQzg9lc2dadVXUvW0X3iwCouMpY7m1fDE0hUdKJMjNI6Am1Fk5FpNtBqwsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxKIGly8Lxe7HKTtlr9hVbxDNLRJ0FdhyTKBu+fW7xs=;
 b=lPvQQxUesU3orLcbAuFZYDlVDPPiptUnUS2f6+odcO2W7chQp7Y9foPQSfSsCgpkTWmFf4biTBLqtKmcjjRy8OtCpeEkEr73KGKd/VuLSUChqnXHpvPRyaArqzo4vs9kq5fIXyK0+u5gILtGYdN8Pb92WLPpjvNb1PXf40ei8nFhQTww4x7zFPHOEKt24iMnwmqR/ZU/v/SfVV8a6L9JxPPGuYoTuaYCDpfrhcCBsfsidq2GBNa/8SKVCwMoBJwLUdiUP7JcDemWnpdeBdnZcLFMfBoTbvX4Q3fVfa7Ov4ZQA/5Ya7GMA+7D7RVJ7tpqExXrTTKbylWfW6jl9EQT+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxKIGly8Lxe7HKTtlr9hVbxDNLRJ0FdhyTKBu+fW7xs=;
 b=VNFivOFWjrvb+OSARVpxOPBbXTwCPTfecizzCkAZXBOKpLytqNL8KU53xG8jCHNCHbo4WDeKf4n9rifv1GzOlJBdrrny3s7MgxH3qfYLlBgIme2nF7qg0bko6dHA0s0fzYjQIci/fovoPaBLxeHfyuT7vyKTYg6shjZ9YOcOOG0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Fri, 26 Nov
 2021 18:04:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 18:04:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>
Subject: Re: [PATCH net-next v3 1/4] dt-bindings: net: mscc,vsc7514-switch:
 convert txt bindings to yaml
Thread-Topic: [PATCH net-next v3 1/4] dt-bindings: net: mscc,vsc7514-switch:
 convert txt bindings to yaml
Thread-Index: AQHX4uryalRRqJ6wdEegqX4WYakZdqwWFj8AgAADCICAAAECgA==
Date:   Fri, 26 Nov 2021 18:04:31 +0000
Message-ID: <20211126180431.x23dcsipmwot5l6o@skbuf>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
 <20211126172739.329098-2-clement.leger@bootlin.com>
 <20211126175004.6dsumhtepek4m36h@skbuf> <20211126190055.1911a142@fixe.home>
In-Reply-To: <20211126190055.1911a142@fixe.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9adacb12-1ad1-45e6-49e6-08d9b107328d
x-ms-traffictypediagnostic: VE1PR04MB6511:
x-microsoft-antispam-prvs: <VE1PR04MB6511434ACD613364348F83E1E0639@VE1PR04MB6511.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k5UWEmZdJGWxr6I3AccUdGHx2yFbYsbFzUqR/TlYfGdPM8zHn/yUCgSLQ6CrTinI0x3wY2AGO4O471s1VJ1qtcExd05TDBpYn/se/FIKwSwlTHczWQQjJweHH87amsqx4KrGCFnnaRWmapanTawDNtytt3R7LwOPfGhE/E4Bl0brNC5yf+eUfBpvppPBV0pCcUIZf2dEZvpE1I+qvqaOdtcEX5S0DMlhdSHynporTXxKSNJpwEt5qfWpSdEz5oscEtUqge7SLB31E9UMBb/dTqdR8h7W8POWRfLQW9q7vUzSK2BAuqTpNtS1pnxoylGbS9w6d40k7zr8ygu4m9qV4wmetBs0pZ3pXX7fsXP2dhKup0RHO4caB+9IQp4IHpHmgErINfPw52D6I7Ue62GkjMoBT4DWzpPFyf5WyLzyvtbpByuQSt25WM4qI/dVImOrg6Ls/KIKu3kz61P/fmNgh/z13kURwhI/WIbKxG2NatZ2//pRJOD7zSMf/U5foO0+Gy7Ps2TUfGoZyQ7qDwJzGYikmaNFbekSnsGGXFUVpzZQJwbzaNXpI3InMG7+ByArUkbRgex5dYFSkHE65JzJ6FwUMpOl7YLOtxJ9HgikD3KKVWxukt/0hEnGe218JMSnhIkYKbCe2OczyLXF6xROzB6rqDTl/jpRdAYgG0keqmEk0cJyALehHQ7UIWbY5wl8/m0NTlo0ANhmpf4U6TrDBmXFcasXh7FOA73m9SRmaeoKdJHpfdCG7Xro3UlQd/z1/7jTqtrmIOcuPluvWZNPqqaEwsZeCaSb6puVtrzCe7U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(9686003)(66476007)(6512007)(33716001)(5660300002)(64756008)(122000001)(66946007)(91956017)(86362001)(7416002)(54906003)(66446008)(8676002)(6506007)(6916009)(76116006)(316002)(966005)(4326008)(2906002)(66556008)(508600001)(6486002)(186003)(1076003)(38100700002)(8936002)(44832011)(38070700005)(71200400001)(26005)(66574015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Q9ULkegf+UkAkyN6/8xWHIG0Bu9CgX7LLG1R76gNSXePZydAYchXJ1hQdZ?=
 =?iso-8859-1?Q?k+lDf+txG/4ufdOoxayLhf9xRFP3S4KHQiO8mhQ2R4JHnJq9rBwPCl+KGK?=
 =?iso-8859-1?Q?AEQeep1zvhK1eeuPdmEL9JUUq6ZN9n1pgSbWFtIW/U20tZGbVvGVWOxNKX?=
 =?iso-8859-1?Q?NjLg6VeAv5pk3PYHrBABsmTnFAZOliHtSiR12gV0vwEwzB6azeeP7x9E1V?=
 =?iso-8859-1?Q?43ZdwpQkVzRqI35bGFVDMJJbhOBHup3gn0qLh//fdaHjiG6egruZEjtw6t?=
 =?iso-8859-1?Q?qiKfuxyx6/Rju9TqZGPPdsqfqXv6ELeH9I+Bu2feou8/xR9jv+9rBEFMBv?=
 =?iso-8859-1?Q?0D+6XJBt9hmWHnmeb02Qs+NlkYjELDdsiBlfAg6QmIz3bzuc7attN0Z5dt?=
 =?iso-8859-1?Q?Fb9jQsIe5uTNUAW8lt1DyEUth/vtIElPtoEQZ/NeopGnL38kwmeqB3kzjz?=
 =?iso-8859-1?Q?28NkJ7Eeyt0WTUxEk7K1ZWd0t4Q7METUqPBl1t7qXUcAcLC7Ias7PX68Vg?=
 =?iso-8859-1?Q?lLDwmUIILcyZTKXZDF2vscKYSjl4zmL8x6fPMGy8NEm4HJQRrwqQdiSDXk?=
 =?iso-8859-1?Q?c2+hvAMCdXsb6hyCal7BJkoQITLgQwCRFqQMLIVgvCHgDHJiR6l1ogP1eC?=
 =?iso-8859-1?Q?ek90s4T3EtyTOfLfd/rhpsA9BDn8wg5Z31n4pWh0CcccaopM6XgEGRm3/C?=
 =?iso-8859-1?Q?eZf8ta3b7dSJszbyQ3tR/C7gBBcsOriQZsArhMPoT326a0mjHtAdoi3TA1?=
 =?iso-8859-1?Q?ZyNP7BFvcrBdc1JnXv+Eg8eDMXONZVqkwnBNIhbCY8IuZz4HjyTqOoo84H?=
 =?iso-8859-1?Q?JZklyXSnoPdkKoWbiNyDZicUBuiwQYBJW2shQnunxuwcVPAX4GZFUiL6K/?=
 =?iso-8859-1?Q?S08mBIaBhrRYN7owgzMhUMOWf+aH+btFxQiguXGS3XjbdfjJ6VQ0ju3gTf?=
 =?iso-8859-1?Q?DHUeIiK+4r+jdGmK0qQTAPnL5yQy6shsoJ/ELQe1z5/F3yoD+dIGvkpD3B?=
 =?iso-8859-1?Q?ZLUhotPhGwSTjfypWG5Olz7sQ12rtjDoQaVsTJfoEsfx5tvyNO61LWmjSY?=
 =?iso-8859-1?Q?ei0c1nsoFitDz83Td5Q9WuLh0Vki5vRe0IDznYZhrz+h/gC7sVfBNZbpMZ?=
 =?iso-8859-1?Q?ds0lQoAw0i1fqEuGxxi1O+Lm/MqT6Zym5GZpaQVuX1CGr8vvYwJSAwusz6?=
 =?iso-8859-1?Q?uLH0l/COmhFK7/kOJ4r4TnNuD4LjM6zf5Ie7SPN1H3fwIaAz6fY34ImQa6?=
 =?iso-8859-1?Q?sQrqAuxFyqrzOir30fc8tQxSofvC1hSGwaY/E/E3PndRumbdBVCS6xs63B?=
 =?iso-8859-1?Q?g3RgvxeR/ugM1V3cJQM5UDLAOEW115QJa+PDURgmZU1y7ABXfS8KIKZNwE?=
 =?iso-8859-1?Q?7S5Jpb85sMz6a3A/xxTp2XOyioZNU0TU0j0TcPLMUVqmN/mEYz9M/+vIgJ?=
 =?iso-8859-1?Q?pDFOxzFtwHwlJHuX/sv/Owpmn1cww2WUUwcHSROL51zDdFimbubnWs8Oq6?=
 =?iso-8859-1?Q?BkZgjOUKru6JPoqOjFdovOqZ8DsnbF5vznH+9xE37JWdQDIGs2+WJmh1pA?=
 =?iso-8859-1?Q?G/VeZZh77ryZBCttOgwzmcZ57Prvbuv6OLK7CHLqC6JMNH54tz8qaYwpHH?=
 =?iso-8859-1?Q?iTuF/FTGYWSOK9bRbqI7ZX/bNHjYDRy5lL/XQLAhz08iewOkTSEF8VAtdU?=
 =?iso-8859-1?Q?fAU846SciGKFdaM0zwY=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <F40E4C09DA066046AF27F4525BFF64FF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9adacb12-1ad1-45e6-49e6-08d9b107328d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 18:04:31.9854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YgZVDY+04BL8nvhsQW99bdz5SDhPCFW+2tTLmsVLY6im1JhhfBl6T+ne0056lbJJBKfLZM6hAYS6rSwAp0HUDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 07:00:55PM +0100, Cl=E9ment L=E9ger wrote:
> Le Fri, 26 Nov 2021 17:50:05 +0000,
> Vladimir Oltean <vladimir.oltean@nxp.com> a =E9crit :
>=20
> > On Fri, Nov 26, 2021 at 06:27:36PM +0100, Cl=E9ment L=E9ger wrote:
> > > +  ethernet-ports:
> > > +    type: object
> > > +
> > > +    properties:
> > > +      '#address-cells':
> > > +        const: 1
> > > +      '#size-cells':
> > > +        const: 0
> > > +
> > > +    additionalProperties: false
> > > +
> > > +    patternProperties:
> > > +      "^port@[0-9a-f]+$":
> > > +        type: object
> > > +        description: Ethernet ports handled by the switch
> > > +
> > > +        $ref: ethernet-controller.yaml#
> > > +
> > > +        unevaluatedProperties: false
> > > +
> > > +        properties:
> > > +          reg:
> > > +            description: Switch port number
> > > +
> > > +          phy-handle: true
> > > +
> > > +          phy-mode: true
> > > +
> > > +          fixed-link: true
> > > +
> > > +          mac-address: true
> > > +
> > > +        required:
> > > +          - reg
> > > +
> > > +        oneOf:
> > > +          - required:
> > > +              - phy-handle
> > > +              - phy-mode
> > > +          - required:
> > > +              - fixed-link =20
> >=20
> > Are you practically saying that a phy-mode would not be required with
> > fixed-link? Because it still is...
>=20
> I tried to get it right by looking at a binding you probably know
> (dsa.yaml), but none of them are using a oneOf property for these
> properties so I tried to guess what was really required or not. I will
> add the phy-mode property in the required field since it seems always
> needed:

So if it works without a phy-mode it is probably because of this in
ocelot_port_phylink_create():

	/* DT bindings of internal PHY ports are broken and don't
	 * specify a phy-mode
	 */
	if (phy_mode =3D=3D PHY_INTERFACE_MODE_NA)
		phy_mode =3D PHY_INTERFACE_MODE_INTERNAL;

but yeah, remove that and try out a fixed-link with no phy-mode, see
that you'll get an error.

>=20
> +        required:
> +          - reg
> +          - phy-mode
> +
> +        oneOf:
> +          - required:
> +              - phy-handle
> +          - required:
> +              - fixed-link =20

Looks good to me.

>=20
> Does it looks good to you ?
>=20
> Thanks,
>=20
> >=20
> > > +
> > > +required:
> > > +  - compatible
> > > +  - reg
> > > +  - reg-names
> > > +  - interrupts
> > > +  - interrupt-names
> > > +  - ethernet-port =20
>=20
>=20
>=20
> --=20
> Cl=E9ment L=E9ger,
> Embedded Linux and Kernel engineer at Bootlin
> https://bootlin.com/=
