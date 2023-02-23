Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA0B6A06E0
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 12:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbjBWLAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 06:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBWLAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 06:00:34 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2044.outbound.protection.outlook.com [40.107.7.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D980F52DE8;
        Thu, 23 Feb 2023 03:00:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqt4vn9fWKHj44FweVLGtyGldPI3POUPRmdmxxCSppIDvAqdthg4eUMcSyZKCGSN3vf7Bn081gd3aaFR7CE3fI2J7TqYOEPJOq6pVLxVnLcbwdX+1W4Wtvj9JyckqzDGpbkVIFImU8DCxmD1jZ4m4LSVoolU2e7eOom6Bppg/Eo2BAEbEA9eJz3UosiMjin2uyAq8+MSKxnwaJY27b2Y2xjcePXNs+DKAXx2qyScnow6JsTzwxtFnDqmLU0/RVDcirUvVjBcPc9yP2ZWN5SHVXs8XdvUXzg0cTuM/UB8gC9Wk/D9sl7Kse8MgWX3LtjmJXafWLKJjq+rZDxs6ptZ2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SNx9OEPJZeS7/UbORf4IqDnYFFtv2haRDKc5PGTDB1Q=;
 b=l6PgiO0x+kXOP8GtoOUE5nTBKaQtJ41Dlr+l9oeeCj0IcKb4Ft7uCXhwVCK8JLsI911JgEbSyM+GKd23c6oOtNPkO3jft6XDyBb3AYgjTdlRwgXbYB+K6hZO3vMxzMSZzZUWH4iWEHo0WS98qIevbyDfGfL1uW4wwQoS+FVCZ6Y+qL20fjzdSn/yCBd43a6/k/fUn2L1kHzTWWniLbeniBXz3zOqL98vYmQiCAjqHuBgW5zSN3/gEWmT2qIskI7slG/bv0YMUk9HpGoQQ51AWPdmi1gNPmISIeCh49u9LDCdfqquimM3MigcKrQTkRMxLnHqM/VM3GdJB8GiIpGIRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNx9OEPJZeS7/UbORf4IqDnYFFtv2haRDKc5PGTDB1Q=;
 b=sNFDnyv8LvrRc5t/0Ev+r9CjoWtDwwtBuOsSgXw3dYGYTY+LFdz+1sudbrUL3RrCtNXPpLgGS62sAh7QlWEE7kYjHOb+YD9lssNLjg9v7hf36eg3xHraBHJrORa8pprc5C4yHHXTKsmr3k5OiTdom+LNxeZAiEwugojuMaOaK/8=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM9PR04MB8793.eurprd04.prod.outlook.com (2603:10a6:20b:408::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 11:00:30 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%9]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 11:00:30 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v4 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth
 support
Thread-Topic: [PATCH v4 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth
 support
Thread-Index: AQHZR3YLu/OL7KREHk+ciGqO0e7Ycw==
Date:   Thu, 23 Feb 2023 11:00:30 +0000
Message-ID: <AM9PR04MB86032C020C9C7DCB5D84B6E7E7AB9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230221162541.3039992-1-neeraj.sanjaykale@nxp.com>
 <20230221162541.3039992-3-neeraj.sanjaykale@nxp.com>
 <ef019382-61a8-c663-773b-21791413889d@linaro.org>
In-Reply-To: <ef019382-61a8-c663-773b-21791413889d@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|AM9PR04MB8793:EE_
x-ms-office365-filtering-correlation-id: d3350c04-6c68-4442-1e95-08db158d2d94
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HSPpNxXVy/OMVO5HzHikVoeOvmfTx+Wav+LVtc0mhjnzyIocYoR0IP/ZAOmH9gbJZl2QLSd2bTCXQFK29lfWG07Tl0sp6GqAZbK2oY2RUjQIc3EAysp9tW2D3qQyWaG/ObvjTpl9jVwrmY33sV5S0Pu+81qb6TPg613QYvr5WyAJXV6YybxwwXEHMN8lRbV+rNNJE1pIwE8XpG8Y2Yr7N+jla+Gs8AKEyU4UkrEjtyJSOhC3qJUb5z9TFbxxWbkwwN+/Tu3wRetQwwDw9Y/lSXUxblZjVRAOXvCZcKhs1QVUoqNm8AwiffyyYVGiT6iB2vzPhOYb4aJuaQrsMbParBFFVmfOIGb5d+excovqplXpMTqWeDy7YwyM/ZB2oac0KOf4Xuko39MCvZCxd9y1KkRxlfB7+/zjucZbBgQ86UZslQOiKaB4ot3/na4ODgUafWY5AYBaQW8LeKDiV9FFcmYaFiFmmmypE1B16PvQZbW5KpWcNn99G9c0sP0zReNP7OsP0v7k0PTYNWELL0N/+AgsbZeQAu4G/E/153fXSSIPiERChXI6ivsflvTfAYeNe5rdXkEpbJEKqbhTEj/FPkCMTvaEEC1LYdWqOABQypBhU575Eng4GABqsv4e1xpy041ZkYfTSUMav4vmfAT3ju58VEG29VBhLBVIRtsZmsLFvyrHvBgSrFMPMHGgDcqWd7IjOifphE2FXJooJjNMfW7RzcXtImalgRwg/9PSnls=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(451199018)(921005)(478600001)(7696005)(54906003)(316002)(71200400001)(86362001)(33656002)(122000001)(38100700002)(38070700005)(110136005)(6506007)(2906002)(66446008)(66476007)(4326008)(76116006)(41300700001)(8676002)(66946007)(64756008)(55016003)(66556008)(52536014)(8936002)(26005)(4744005)(7416002)(5660300002)(9686003)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3waX7u1Qbi+s40F8uy9w29qqhYkzTIuD2o4sIAHjwKBVLPCRKeg/V8biPYsQ?=
 =?us-ascii?Q?o+9F9iId3HDxbI2WZdGrmvaC8IQPLVoPXmKt7KnMSd3lLBhJBh094J9EE0Dv?=
 =?us-ascii?Q?LRM4MRN/yU+oTdfeZfmHI3kjAhafkDSjNeKGdxv6j0G9gz13tZVy3KzOfvJe?=
 =?us-ascii?Q?TcsI9ZV7NuAMIJJ/wgXF05fUK3TuSNhwvJBjWCBiaWkVoOeV6XRK/SzPAqv3?=
 =?us-ascii?Q?ubRFHNMj3alf8Pt+2M0tHZo14HMBm4HRPSvjWM9TwQoR22hEdW19JXS1n1k5?=
 =?us-ascii?Q?BfafuP2RREIZz4TWcWzsrv+P05h2ayOl88YpdMwvD6C11SlC1xJCiP1LCbNS?=
 =?us-ascii?Q?r47MSZjY7BGpFXCml4othXXfKTHB337cPwHuaLnkxxIocuPuVLH1y9F6yB7A?=
 =?us-ascii?Q?8XLhJ4SDm6iTuCn7BjD/G2nbnJC5e0hEaAydWklhgsx0hkp3EDGCSkZBNQli?=
 =?us-ascii?Q?+kjxF+bcmY84vSyrPz41NJm+LLmWMRCm4iX/GsK/ZQ0QmljR0D6qgDFEfqbe?=
 =?us-ascii?Q?alwkgcl5XG4li2z3FZFgWlPOrq9hr2BKOhbmR3pYZguva/ZXvx/hXemaCi84?=
 =?us-ascii?Q?NjJVDL6A4as+yGVcWVewM4OsdtO9RvhSM+MpvBszWUe2tPgAHQT8OYHMw8f0?=
 =?us-ascii?Q?tgt3o6DQzQ0ZDF4y70mYfbepXAKV9r+bLpnw6hxrYMBTPde13I5iQyyy90yA?=
 =?us-ascii?Q?aoiGQY9EvKQEHmF7QcEouq5Vzb+stoeHOjxDDJNYA1eOwRKLcB31P9Y6ZUW6?=
 =?us-ascii?Q?tIrT1rj+T79/37u4FhUxfFBV2YZbLIgetXG/RVHrBF+k+k3h1BTuDMmA/RWA?=
 =?us-ascii?Q?b46OtBTxUIiyPr5y9XuVdb5FnrLh1Ce9W7U15PDEZ5oz+B2arV4yvFeHBLo+?=
 =?us-ascii?Q?DFSoaqt2XkM+8/Di8Q7znyodMkjjc9orEYoW6GiMtRac9GQEolF9eNxl8iyC?=
 =?us-ascii?Q?F4HuNQm4UOxcTSnAbsl3p+Q0tWvEYrgsF/P/ihONYgLUyrylV5jVGNF0E9CW?=
 =?us-ascii?Q?8sH8GHnE9l6HZtGKtLpZauhlkDSV+XfDgpY9GJ8AQtzI6tCLbi+tTi5FxlIO?=
 =?us-ascii?Q?KJl11Bjo+LrUcIwOgp87iGB6IpVH6xkB/wWhR1h1YPOBK50lsyMBCqR2L9qQ?=
 =?us-ascii?Q?ow4vWVh8LjzdCq/usrnyFKirvBrIZFwJxHbXhIhDRV+ey1JOoe4neoJScwGl?=
 =?us-ascii?Q?LhkVUVm8tYuNF1rlhQ6xq54wgtsco/qyGXC4zCpA/L6lYyTNKWxQZMGjYqrd?=
 =?us-ascii?Q?VmaQaWvHnaWOFe9CWcTAkAWpoWYhfFBza0OQlFQVWlupb2rYy9F5RQmdzUwe?=
 =?us-ascii?Q?fPdc0ss4xVCd2TcA4RLFaH4+oMhA3eGubnLLU0XtUDrCOfjt7hMUBcaSx/qF?=
 =?us-ascii?Q?6Gsy1xZwXcpcB8phFXIRq/W3mMhE4SW9bqwWT3SuIKWNHZc6Aa8DnvdfN5b+?=
 =?us-ascii?Q?+pJfjs5UTOaEr9G6NtL/anUD1I0mE4WKcP0jte3u8tF+U8H193K2NfKhqsAq?=
 =?us-ascii?Q?hcyZDYKa2gnOSzI+RRAS23mi1C85jtpjD4qhvWXJidqoOCeejAHLYJprrrvR?=
 =?us-ascii?Q?fqdHvgD2mUH2HYzpIWYKZmTwUz2J2ILfYSEWRGY9U26azcSLR0IQYO7XYgNf?=
 =?us-ascii?Q?Sw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3350c04-6c68-4442-1e95-08db158d2d94
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 11:00:30.1686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z/MawPt1QrdSii77vyFIWvOjsmiMJjg4UJdrsZH/I42cD4F04AJ3Bk7AV8TCtOaU6iwNbEKZusKJH8NRHMHnCzZayHLXnci/sATqb6PwABU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8793
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

Thank you for reviewing this patch.

>=20
> I think list of compatibles changed... now they are nxp,88w8987-bt, so
> shouldn't the filename be "nxp,88w8987-bt.yaml"?
Updated file name.

> > +examples:
> > +  - |
> > +    uart2 {
>=20
> This is a friendly reminder during the review process.
>=20
> It seems my previous comments were not fully addressed. Maybe my
> feedback got lost between the quotes, maybe you just forgot to apply it.
> Please go back to the previous discussion and either implement all reques=
ted
> changes or keep discussing them.
>=20
Changed "uart2" to "serial" in v5 patch.

Thanks,
Neeraj
