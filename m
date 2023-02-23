Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F131B6A0B7E
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 15:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbjBWOGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 09:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbjBWOGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 09:06:08 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12B716AF8;
        Thu, 23 Feb 2023 06:06:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HC5LxkCTiz1quN5Dg5TDBUko/TCjf+S8maoWAb8NxqWmxicPZgHQTJLKeZJ9Nj1Z9hp6s80wbQfKskmdCslp9l0ZL23xuLmqgJ1SQ63a+HjSUES0m2dZ6Z3g+B8IiwbDuQBXG/+oUWsxYd3+u+VpjJXQE/cVA1fz1t0c3n6p8GpxaH+fs2Nk0e99Ua4Hy6zy1bGifqSkbl+nQd7pt46CDe2FrKH3EATLgycmm0rJ4yZ3qi8ledZ1cRfW6H48R9z/kXNVQclhO2nASRTFAwj6vyCa+6l5Ttasgwyt6DN5oxhM2D1rHhcbn+c9t3uk3v6EWM6Y4L0S5V1KhpAbj9CpMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8yVexv1h0fY3GZBTWspSWDmDnb3BccryIhV30Ly6thc=;
 b=kiWUCqGgwt5gsmS64JY6X2aHqz3BWr99GFaIRwDE6AeoNF37wRG9JLz4t9jvmADveVN5Chat2OsHxhR/GESygBx264A+8UihmLU8xkf+GwwIZodfG2IOJC/1h2ZfI6U/EhUOmGvG+LAJ6mn0BQ1Tgirs8n55cyudQVjTScIpzd6Wl9Em0poIj65oXDn6GzpGG7b6xx10KCZKQ10QhvmY64NlC/qQW0DqwwwuhQOW9aCt0rA57kJtDXDGMHUvLS6FoqXYkHbksc5y6U1PMdER70Rc9OC610k+4qagggk3c8KxI0IQ/VavWQ6NqHnJrCBDMlgaYTkCWqtiU4xCsdnyHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yVexv1h0fY3GZBTWspSWDmDnb3BccryIhV30Ly6thc=;
 b=b2hmYBaKRNJMkCRAjOVsOunpBSqQlrfGD/7f24xz5Usi48IGFjh0gqJOnaht/05dNgsJdijPE5IbqosY6+7b4wdGiaNAUvf9XNNeztjRifN5i5yH1jkcbeUcHlGiZW0dDvkjDUYgSe7aFU3vn7BjC+fHumOahaBgUuFPU2Sk4i8=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM0PR04MB7155.eurprd04.prod.outlook.com (2603:10a6:208:194::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 14:06:01 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%9]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 14:06:01 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v5] Bluetooth: NXP: Add protocol support for NXP Bluetooth
 chipsets
Thread-Topic: [PATCH v5] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Index: AQHZR4/1Uya9NEuwq0+Oa9nMQHXKXA==
Date:   Thu, 23 Feb 2023 14:06:01 +0000
Message-ID: <AM9PR04MB8603E91F193819FDF23BECFAE7AB9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230223103614.4137309-1-neeraj.sanjaykale@nxp.com>
 <20230223103614.4137309-4-neeraj.sanjaykale@nxp.com>
 <Y/dEa6UJ2pXWsyOV@kroah.com>
 <AM9PR04MB8603BD23BC407407316E928AE7AB9@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <Y/dx+y8enikEP9iu@kroah.com>
In-Reply-To: <Y/dx+y8enikEP9iu@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|AM0PR04MB7155:EE_
x-ms-office365-filtering-correlation-id: 67d9cb8d-748a-4538-fab5-08db15a7186e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TQUhUDYEb7P6xR9GUcxK1CIHB8YaoN4LFoAGo7d3MeVLnVAx8dDvVvyI9CD0z5ejP8moSh3ixIqg2rtjAXHgf3HNfMr8H66nV8jTlW/Bfa9qhgwvzGNk6HlFpKnAw1bpSiY1WOoXhmwXfwMjuFca1jkS0EIpDP6J3tdrXcVchYU4Tj+u7M8jz6RBo+uhU/IdWUnPu5tL4DE46LAI+G3/yFFHdtdz3GNlAbjSsJiw1CfaqZyWbFi47blujGBr/4Y3ZvCQvLdn3PIv0scOjI3e9REw4WxHKkmUfiKyBAVVmjn8oLHcelfTZg4ypOfxkwrNa2pvooQAYZQbEAb6fQ8ifYIKzvApC1kYrnDGN9HnR05+xsTKVk3CYwNVv+fT/R7m2WeMnGZSrjQhyZQPToDsMAJ+PxeXLtAn9ENvIMZigQ9m0eKxBAXk3GXfG0ddO6E7dbsv4SkvlEn8UR5G3N+cVrvK1z7/aLnVz4QLmSdPZ4JuHFKMTEwuLiMwA/ub7aXHab0pVeed74lIy+tWIalE6nTfzV4ouWvePkxEktDpFU/7r0wXlk8jQWXXT+4e7SUt+uQMfrRYajfyhej9HkZ1vgd14BnZmZI3EPN/OZ3kLDoY0mWNYwjfuZK7TKibduz1UiVHr4RVgE/3dYO6lZQa82KZi2IpsTH0Ja79gVBCMTxKsujFNDZ8XSl2a8Kot0XDuCrHp/15DQ2xGCEgawvMZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199018)(33656002)(71200400001)(66556008)(122000001)(38100700002)(38070700005)(7696005)(478600001)(5660300002)(83380400001)(7416002)(8936002)(52536014)(6506007)(41300700001)(316002)(2906002)(54906003)(4326008)(6916009)(8676002)(86362001)(66476007)(55016003)(66946007)(76116006)(66446008)(64756008)(186003)(26005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AJAhupkSgxWyszlDxcvPepFSJABRyCxcPBRv+imC61J2Z/gOdi+iqne5LHbZ?=
 =?us-ascii?Q?hoT6H4I1kNaNIzined0l8OMExmFjmz/4wsklyG1ojChCtCHS8FgMFU1yTImY?=
 =?us-ascii?Q?0PLY9ds1aFtJAsjx+fFywTftG3SWkPEtGReC/9ssCUEz9HM4LS79NSPOdotg?=
 =?us-ascii?Q?rjOIOOBKmV1mz6SA4tq1uXXeRTPxXkA08cvHS+xhJeVibWHlHWmw6DddyONI?=
 =?us-ascii?Q?L2Mxq+WOM2kUbLWA2Y40u3OyiTTgJyQmusU6EdKBVBfOsF8OrVyEupRs3Cq8?=
 =?us-ascii?Q?5CqjjszS6hyWPExWLYju5E+/I/5VRwK6FOO0G7zxwkBR4UqWaYAnbWBGZyjD?=
 =?us-ascii?Q?0VKoSP10x8TG+VqYhONceFs3b2O4Jc3mdoEfTliFKil7tit6HIqCV1h84WV3?=
 =?us-ascii?Q?acAIvaLc6aD5c03Lx8CLafucpjKwBoge0CedPDqj53DAZKO6E7aFH5cYvKA+?=
 =?us-ascii?Q?pp1YDvVVAP9sHzGnaLi7CFhFEScT5q4LJ9a/P1QS0IspazlgDhG2TsFtlgiZ?=
 =?us-ascii?Q?07Kmtfr8tfB0ms2eOS0C3jdPmeuYdhDdnJEXeYxp3xJGMv/gPcsf4tQVs7kc?=
 =?us-ascii?Q?ubv8lXPJshPcv8fhYr/ZVLe0wBqnK0AJyqTf4tSyfI0c9++wMCjZ7rRz++3Z?=
 =?us-ascii?Q?F0166y6HJ/3S3L28dnX8otb/bCNpwiqhDEeKmYEcLL7Cs7cZ7iFE5/4NuKYg?=
 =?us-ascii?Q?RPz156k/zr6SvphafJcImA7ab+Y0pz+fpyf0L08X1Y6AJxMiSJbj0K/5tUV3?=
 =?us-ascii?Q?YN5B26vsXlMh1eI4PHfewL0k3bvpO6J2v3U4iqrUrnC/kTg6Cj7lTzW3obwq?=
 =?us-ascii?Q?dJYO/bAD+CQ2UmKqWeXo5AbiS5dObgxfmlIN7sf2mGLCunTa0VbL+9GORe7U?=
 =?us-ascii?Q?Pn448UWS0TPfQm6wXP1r1NlrmQkg05nkU09u635q7Nc8NX13rZXTKOUxY61M?=
 =?us-ascii?Q?W50jDXCXfj8ubkifeiWeE9s3UGdKoL0DAMkY1wUbAy+OiQNWoCeFTcOPWn8t?=
 =?us-ascii?Q?P9okLkxMkA5jKMOyZoRhO9c0m1k2LbtBFxX7ZU+tTv1S0+l7XN+HXHWVykkJ?=
 =?us-ascii?Q?i2gpyG0sKfUSZ1MeFzjyHbi6xk66Kh53eSWFPzuIAMCws48IjqOQLpFRMyHk?=
 =?us-ascii?Q?f6SJ0dNSK3lZSjhXTncAtZcI3NbDYYxeMAjac9A2z3WpSdzFrW3WNaTSElge?=
 =?us-ascii?Q?PcVIYcNZi7yTUpVGOAxIPHObsID7eMyZpPRbEHeApCr5PwS+v36sRs3XdEm6?=
 =?us-ascii?Q?M/ZCzzmui/ToX6vqUBdZpQZGIxs9R07bldrDxzTPZCfmxPOTc1d8VnXN9H/M?=
 =?us-ascii?Q?540ivzW3PMWaX30N3Q6TR+qKAeyieIzrLExa3IfXMPMe9/L7+81Cu/TBd3BZ?=
 =?us-ascii?Q?iQRJTXH+8lrYGl7Rz2ISI7i+QRKZOViaref8fcZfYnq7bZ7kyCDsmRKOZJGO?=
 =?us-ascii?Q?kBjlDK82TifV1XSQTN17VQAxRihT8gnpUg4lGuQLVvnqdhGxKCzfQLKRIT2/?=
 =?us-ascii?Q?MTQUCC9DeeXkrOoDDvI0VuGOowj1GdGUB+762nrB72PYVxWnWXiJAknQuoIU?=
 =?us-ascii?Q?IAenLWLWWJMnmb4oDAGHU/QpOXuden+nrBO1Uueq045yxijtFjP3UP7umum0?=
 =?us-ascii?Q?3Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d9cb8d-748a-4538-fab5-08db15a7186e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 14:06:01.6080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IgjIS79PdQTLzLeKg/LVYzQDVEqMj91VecJHBwAtmdOfdRgUp8OZUSMpLm0B+8X5rvD+7EDdCtWcobu6YlWFwZi/3SUXtOPet2iWvH1QMjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7155
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Greg,

Thank you again for the feedback.
I will work on this and submit a new patch again.

Thanks,
Neeraj

>=20
> On Thu, Feb 23, 2023 at 01:57:58PM +0000, Neeraj sanjay kale wrote:
> > Hi Greg,
> >
> > Thank you for your feedback.
> >
> > >
> > > > +
> > > > +static int init_baudrate =3D 115200;
> > >
> > > and neither will this, as you need to support multiple devices in
> > > the system, your driver should never be only able to work with one
> device.
> > > Please make these device-specific things, not the same for the whole
> driver.
> > >
> >
> > I am using this init_baudrate as a module parameter static int
> > init_baudrate =3D 115200; module_param(init_baudrate, int, 0444);
> > MODULE_PARM_DESC(init_baudrate, "host baudrate after FW download:
> > default=3D115200");
>=20
> Ah, totally missed that.
>=20
> That is not ok, sorry, this is not the 1990's, we do not use module param=
eters
> for drivers as that obviously does not work at all for when you have mult=
iple
> devices controlled by that driver.  Please make this all dynamic and "jus=
t
> work" properly for all devices.
>=20
> > We need this parameter configurable since different chip module vendors
> using the same NXP chipset, configure these chips differently.
>=20
> Then you are pushing the configuration to userspace for someone else to p=
ut
> on their boot command line?  that's crazy, please never do that.
>=20
> > For example, module vendor A distributes his modules based on NXP
> 88w8987 chips with a different configuration compared to module vendor B
> (based on NXP 88w8987), and the init_baudrate is one of the important
> distinctions between them.
>=20
> Then put that logic in DT where it belongs.
>=20
> > If we are able to keep this init_baudrate configurable, while compiling
> btnxpuart.ko as module, we will be able to support such baudrate variatio=
ns.
>=20
> Again, no, that's not how tty or serial devices work.
>=20
> thanks,
>=20
> greg k-h
