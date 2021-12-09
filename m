Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E80946E72F
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbhLILCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 06:02:42 -0500
Received: from mail-eopbgr60065.outbound.protection.outlook.com ([40.107.6.65]:6626
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236328AbhLILCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 06:02:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YuSAWOSWkWdg3ADV1Ntx5VOd0aq2ZeJ+RAej42hKVs1DfFHl/7725esT6CNneEXRcyisv0lj0d70GHuJcxe6Reh3W51uu3pkPHPM+/8MiDO+DfCq+JYQwRfzlf+SCWEJ1OnKil7TErFCFIyTJxtJfoiqNLnRASyJ89U2TYiQJN5YBQMq0DylKzJ3U9foYtKEoB5H7kAPAsklmxaPy6ZqJ7CMJKZfFAY3uJHPHLWxC+JjwmO3sHDniLWDWxhHbgbDCjBKzYYDhNswhTVsJwwfa928rPmfpbcsn1nAe0hdsfUw9JzN9eOmc9sUW/abS+qDhNGZOOV219Gx5u3For9l+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s28wkk24/qLLsJDfsYjI55v0cyUYucZrhz6tiFQ0zhs=;
 b=oRBIEY0oK7DVSOrbtU4KuepiYikWCp7DzJ9XYbVCwzDdYC0UtczUv8RncCRNZgLBaLU63CgpyLeLfdTjACWxwrx1sgUILa6velDgeNtHXsErflkxeH6O2k2xZlVhqEqP3LEo8xl+zhmtybhIk4paaT7fj7s5qJN7B9G4l+yzejRQyATq5QQvSP60ul/QA6VWwYeKb/sySZQa0hrQ2FEu5iZkjPkrUneE3WCEyXrULohQeGLe52b06DVzf21bv6kli1Z6C0wFGpWMiBUfECrxftVhJXgw3QyrMiQAIGJ/ptHBCSIBpbpKZcByM9fdnj13GWomp8rF0jWm4x4XO1/k0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s28wkk24/qLLsJDfsYjI55v0cyUYucZrhz6tiFQ0zhs=;
 b=UDRIbwFp98H1AK5VFoM3xlXWI32mszuL08j2b/xW3YuzMG2KTRlUMUgFrfG9TsTDyxqkEuJY7UKeXvel0MnoHxOvF7ylIaECae1VKGVRoXX/TUGQdIOKLNT2Gvp0cIeRq4sb+tTZr8yjriaPwoNQfFkxfaBzsUynvddFH+6ZhRo=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB4738.eurprd04.prod.outlook.com (2603:10a6:208:cc::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 10:58:58 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 10:58:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 2/6] dt-bindings: net: lan966x: Extend with
 the analyzer interrupt
Thread-Topic: [PATCH net-next v3 2/6] dt-bindings: net: lan966x: Extend with
 the analyzer interrupt
Thread-Index: AQHX7OGhd+X5RJxwmEebfZUvbnLxIqwp/cOA
Date:   Thu, 9 Dec 2021 10:58:58 +0000
Message-ID: <20211209105857.n3mnmbnjom3f7rg3@skbuf>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-3-horatiu.vultur@microchip.com>
In-Reply-To: <20211209094615.329379-3-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf8fa601-4bf7-4683-024d-08d9bb02e6e3
x-ms-traffictypediagnostic: AM0PR04MB4738:EE_
x-microsoft-antispam-prvs: <AM0PR04MB47385622861B6BAD4BA92974E0709@AM0PR04MB4738.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QSTaSoSlG1Ffr+JOMOSlhfO98Evdtzh5JApEIeh2eJpuYDg7ZQdK+si5388jS4MVxSF1qjtqbQe27qPI+rUaD3piGdeDF6jduKVP6IybNnnl3xgl5u4PTKLh9uFDEvofPQZtAkwJXXdG60JOD7e5HFdvru8a7jSY8V49IhoBCM5/4/StkiSSgnrQBk72z9o2U1lx2wnrUPJu+br9bnjpXwbiGA/4rfiY3Z2ggoXdE8TAo+uBzrZQdvskCpoLcisF4uAQbIz+qlfuiGyugRtOD1y32auhiQlsVrHMd5EJhbbpTgvkfzh0SOpdaYh1JhPFDB+KARmwnlCYLlCWcgM23yil9LCJuOi3Saf2Gx+14oVIMnvgBs8JXFK44dDCsbpIXe2Uz1IvtF5dU7cMuQez83THNUYzfJB5LyX5smTpTgQfbtjIwnGKcakUUCyLuon5A443ygsjPH7YNSLkGKrz436gIMLFtSB/2abFL5QEgBB2pnqK0RHivM5YTt+ZCXHvoHKL24Y1xTHckxEfISUKZELp9MHu18WMgwtmr9No9teTbDagwI6VU9e2CY7ftJLL1B8+5WRY375jHJZau18kPLGK7NxgU+Qokz2RdCboOkYgLkzUZkBKRu58ibEfMWfCyiejXwRGKcZNfVe/PRKTzzomd29xluKZRPoth1Mu6704pPf4JmdvlZovLqe+JshfrG2FN1NrZkEX3MwDEvLv6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(186003)(9686003)(8676002)(1076003)(4326008)(44832011)(33716001)(7416002)(38100700002)(316002)(71200400001)(122000001)(6512007)(38070700005)(54906003)(86362001)(66946007)(91956017)(76116006)(66476007)(66446008)(64756008)(66556008)(6916009)(508600001)(6486002)(5660300002)(2906002)(8936002)(6506007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q3ufzZfvicIbn+oYwBfEwLES4DPBahqn7W2Ud8PVsK87Imym5/FEb52UqAb5?=
 =?us-ascii?Q?N06b9s9qco3rp8xHlsAdGMhgJvf6CIM+ebkDrmOmFa+gSzqxpuR4O36e/KDt?=
 =?us-ascii?Q?IPvKNgGZ7MxOC3UQbKHW+wNG1SQ9pocbRpSI9SICiQh1vd3flC6f8dYNLBNN?=
 =?us-ascii?Q?cZP/7cnWfq0ai3lSZr/Jsy91JsWqJxAzA1aWBT17XxqK+67YSkqdblE+uyRF?=
 =?us-ascii?Q?kvw4273mqukBbwU8yGZzSJ2mkWK+kRTYQES95ZgxBuV1tlhcQStMHvJLRTqk?=
 =?us-ascii?Q?N3jxhVp60nW9eFjfCOUURgSzlKDjNBhUIkTDHfpor138VAyRFzKRz/6SHZv5?=
 =?us-ascii?Q?YnWItbz8vaMyQjEOib317EwuSHTBmRcZ5yI11yXMA68SiPOZZpjGjpy7b6D9?=
 =?us-ascii?Q?PDIY9xmxLPopXspipKPaizUm8v7h9RBpjc9DRKrePrMo3wKB3IUz+4uhZHnf?=
 =?us-ascii?Q?bJWpGKPaQolWyuVSF0lEPbBx6TuL9Mdon5J7KqPl9OG6/6bV8nrL9l3svqd8?=
 =?us-ascii?Q?PAo+vEgvH07R87LSGROv9n1LNeDPn+XlCrVyQn/sdKDuRwiQ97MxtDrI+S6E?=
 =?us-ascii?Q?acFOHZr1SBcR+6XUgrYBHHqOkQSfcZokEVOm1PFd4YQoOLNFZ5ya3lfSVPvV?=
 =?us-ascii?Q?Hfp8Qth1Y6+yu7NOxmWbrXxC6YmqsRP3C2ZTkAXks+vnIMEd48GIGpuIFWia?=
 =?us-ascii?Q?XgbqLrASz68rip0t3TKqxzNOwFbTe2IitqvS9Q/LX7qQxukDHYACIFPpWTp2?=
 =?us-ascii?Q?p5jsvrAyGHhzmylPC+9Fwhg0YfIrbme1vVKwsCdGSUP9OPusk2srKi38ehG6?=
 =?us-ascii?Q?s5EUmmX14s/zIcG284oOm/X8p7ji470o0sf/a7xMOzJHXELk3hEyiMcljzwV?=
 =?us-ascii?Q?bhlX2dRb7bcqPNeado4FkeK7/Uq5O152PjBtM8OUSnSaarV2RBtYLXSC2BPb?=
 =?us-ascii?Q?lvBfReBsxn5N4WqekJWzz0JnVrzfVE68qqyzCJpB+ALnM6HYLj1HxA6JUvSR?=
 =?us-ascii?Q?oEfs7mLrSnmhkgc4MIdNI5Nw+9mnqwkUcBG1KAiYxZQn8hwSIPuzfORObSD/?=
 =?us-ascii?Q?xUvOO7k4h0ShxxejIWnyQS8FZbtCVWFP49ZmWLhEMvnqezb5gvEFCaq2G0pV?=
 =?us-ascii?Q?zfnXPazOmYdjctBJVCA7A1yRwFZ9q0K1uhO12mPvV948v/wOPsMKxKiOarpa?=
 =?us-ascii?Q?MZQkAqROnRzIqEC/rBaaNoE5dyK3Xw9QnKwdIYwErT9d9W9hmH8uedu8/UWp?=
 =?us-ascii?Q?Ulu5tN80JbtSFPJzJIZk+B8F6urOSPHGnpYb0WG5VIbD+KjFFGEpSYzlW/xP?=
 =?us-ascii?Q?zt3xubF6YKnCsLBxi5OT4reJEUXzpaSryqCn93kiqPu9odBFW5NQkX+9Xle6?=
 =?us-ascii?Q?zUWR6t4Zd84dEUJP9olCCdv+It7h5Vrd67opfWUWEdHAbUIXropUM7kNKqBn?=
 =?us-ascii?Q?xmMlhqUi4er76d3yVBqT3DBO4CtwhfDPC32QJ+TjHyDW3iBezXKydDDwbGix?=
 =?us-ascii?Q?Q1+RA+haKc7KajEt+4fzR44rn9QavE7ODReniLW3aaPn475zzpnfI1WIF7a0?=
 =?us-ascii?Q?eJJPWHGCrU64k21y2se26TESYzA/819MZEVfgTlHpHmNAoGGoq6OTv3xUEi6?=
 =?us-ascii?Q?tE71bcBCvtkZz4YybHrpQ8s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1CEC80D0D41FAF45B57D2F73A9FC967B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf8fa601-4bf7-4683-024d-08d9bb02e6e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 10:58:58.6781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A2KNsS+Iz4eIh6G4TZNLzQCQTu4DpBzgopxBNz3WrSJLi+PvUhNlgbNlu74YJ/WBKGVzbVqz5MRzSlSnlmfiSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4738
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 10:46:11AM +0100, Horatiu Vultur wrote:
> Extend dt-bindings for lan966x with analyzer interrupt.
> This interrupt can be generated for example when the HW learn/forgets
> an entry in the MAC table.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Why don't you describe your hardware in the device tree all at once?
Doing it piece by piece means that every time when you add a new
functionality you need to be compatible with the absence of a certain
reg, interrupt etc.

>  .../devicetree/bindings/net/microchip,lan966x-switch.yaml       | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-swit=
ch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.ya=
ml
> index 5bee665d5fcf..e79e4e166ad8 100644
> --- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> @@ -37,12 +37,14 @@ properties:
>      items:
>        - description: register based extraction
>        - description: frame dma based extraction
> +      - description: analyzer interrupt
> =20
>    interrupt-names:
>      minItems: 1
>      items:
>        - const: xtr
>        - const: fdma
> +      - const: ana
> =20
>    resets:
>      items:
> --=20
> 2.33.0
>=
