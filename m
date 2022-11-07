Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1F261F3D8
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 14:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbiKGNAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 08:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiKGNAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 08:00:34 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2066.outbound.protection.outlook.com [40.107.21.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D2A13F79;
        Mon,  7 Nov 2022 05:00:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxGeF2wigfvTLyYJ48PIJT7SRZ+P+doXVXM02MmeoSaWCBddlzk1gjFVmMsRtd97JU44+PDo+U1OayjZ1XX67sSa7N1rHp9ARUbmaRtMHxG+eGcQaHee3MxNMa7tAlh1hVJyfoI4yF2l0uLvw5RTepF9/ltOUhYWagHxtU01JbJUSXz369Wy7L37uOnBH5yZWMXKZ3dlogQL1awcQrFwiCez+ZQm25RY7/TSAi4QBGAieTlF50J/DU3ZG2KU5/ZVJDfCBIKkVc57Z9elvXbbLcHAWQ7+qgt3qT+MehAOasBTbkR65mPpU1Ztf1RGJnKHvXyGi9GMWmakwTda0wZecA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Y7hXv082RRO177Jkx3+duI0Rsbs+ddNcXnKRWErdsk=;
 b=AAPdl6/eg9sNdbXY2rdqENO2KgO+6H9NyuGabbxmsuNO8D8o70H6/UAuT+hT0IjcR8oJ5/Cu4lHM8RSxIZz2llJz4bktlu4DLXc+SjIFFzCill1JYf88q0cokQkJXLCBgRP+tK5Kx3ap01T4RUUL+0VMbmKd2AYbqWfnWeVkMckXEz7WUDYES6Cmd8q2UujTpNG/T/ikoB99jaSUsNA3lZEb0PxaY/bnRCzwwiOcd3Aj0y8kDWI0XmPnmzl0sLlg53dQOVIcn5d2TYALuCCmSeGdj2YDFwqpCRjZlV1ONNC9Sp85fd49gSj8RMsbGFpLhf+RK61u5D0ACBSpmwf4NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Y7hXv082RRO177Jkx3+duI0Rsbs+ddNcXnKRWErdsk=;
 b=E3D9+FuGVq63URE0UJVOkJSFwmOGqW5DXrju50AbvAK02HpLApi/ALZvSCtm72Tf1AXtk/f3E5P35s1pZWTLiH1+1k/t1WMpwetBUUpu3Uy/OO6B9CLC8Q4SpgBoAptuOVZWeF6pyrztDmPUdYWVJAUl1o+TFZUxmrsVY9b0mHc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7548.eurprd04.prod.outlook.com (2603:10a6:10:20c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 13:00:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d%7]) with mapi id 15.20.5791.024; Mon, 7 Nov 2022
 13:00:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
CC:     Joyce Ooi <joyce.ooi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Snook <chris.snook@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: remove explicit phylink_generic_validate()
 references
Thread-Topic: [PATCH net-next] net: remove explicit phylink_generic_validate()
 references
Thread-Index: AQHY8HDMdl+vkQ7h8UWdK3AxPmtmWw==
Date:   Mon, 7 Nov 2022 13:00:27 +0000
Message-ID: <20221107130027.5itc5uqljcs4eath@skbuf>
References: <E1or0FZ-001tRa-DI@rmk-PC.armlinux.org.uk>
 <E1or0FZ-001tRa-DI@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1or0FZ-001tRa-DI@rmk-PC.armlinux.org.uk>
 <E1or0FZ-001tRa-DI@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DBBPR04MB7548:EE_
x-ms-office365-filtering-correlation-id: 8379f2b8-f0ad-4486-a6ab-08dac0c00b0f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DxQFl1JEwQoxGUKvmIRgjgq0/HJgmfyYCJtoXSm3p+E5BgFoxX0tTp+qdNdhtKy1xJqcnpAWm6lUku3blX2lAfq1YDoyDwg7Py+lpiKy55rTreIOANiK+TN0fX1g66Kex7Cw35bSogKqAvhi3W3NMiHoyu3+zKL/tNN/suW72uaQI1sC7poys9PoCF598nNd9NXK1LPS+qkzYJaBEdvcWxRh9bjSEwSOose8ptZld++Xrq3N99XUIBKY7ahFK0dUmtlYZKcCHhEfGQoer3V9WeXvH879LMtW1fzacGFh+oYRsnf9hlz2Bvtlt7mVMPai1tJOvs5bY8J2LdZbvNi1sWdAvWEXEJOnYY2HzAQ6LyXfsQhhD3L0afh4Cg7sfE1qMS/4KZyPOa0YdwqdlYqIkJdy39+ZJEOxuZWF7HH8T3jiY0nF26O2S/o9OigZVDFiJUu1K25suFAwDTd1tuyXVl+KDYZT4RBjL6M6s2UpOnOOy57x729wbgSe3cSLipZ0lKBMqI7PIC3Rw9ydIRswvY8HnBYU0i0zfkL9+jUCkMk1cUd6nXmk6VXER+oelDuGMbGlmWWVRrJ65RK2UFat59EZv8Njbb8001XkWjC0mUxxH+rJxXqExvYZhsK2jbDFhzpJ6UAgnQkh/I3sdb9VcAcv1cn//IaI8EGfd7bAvheyz55cw8iYkh0AWyTfGYXf2WEEqidhftlZf9bcOSRoaEthbZ30bDp5e20vLAStVXnEFqrGY5yJAdKgOnijk2qhFBXmYN0Pf5n9y9iyGDrPL/nvozRKoOn2pWRD2V4hzu8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199015)(26005)(6512007)(9686003)(1076003)(6506007)(186003)(122000001)(83380400001)(44832011)(4744005)(2906002)(8676002)(7406005)(7416002)(33716001)(478600001)(54906003)(71200400001)(38100700002)(6486002)(41300700001)(5660300002)(8936002)(91956017)(4326008)(316002)(76116006)(66446008)(66946007)(66556008)(64756008)(66476007)(38070700005)(86362001)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h3I6vsmX68czQxu9DGCd7jkrk/jQBKJSRsTpk98uPf0jgERPs6UnQLwS84sm?=
 =?us-ascii?Q?q+X7moCF2lT/glSJrrUs0uaSLyJRPFs7glgg8Beyqe+JMA5w5ZKvwqo/t2RL?=
 =?us-ascii?Q?0pjiQa/OkhffwNzTCiFzjC/rFjOq40tYeRzAxFX/lBUhZD6Jq66k9GrogiRd?=
 =?us-ascii?Q?Ua11NV4hLY2uevS1LJWnmpnAVRqaRSqAcKkTFvgZlaIECQxevnixIvhLM5Iq?=
 =?us-ascii?Q?dIHdbc2L18ndi+xcMzTcUHrOraFtvnLgjVvAx0jHahulRIhsz2GPkL46ioLU?=
 =?us-ascii?Q?kapg4pMCuOlCYzOszMkuHZTbOlBa+W5eSGSC/UkMTkxraWcQua6+MHLS7nZk?=
 =?us-ascii?Q?xb08nWzcHt4qrieCk5k1GhQbTAP8ckf4UISpdhfDowXuhvoz7RiywEec/mJe?=
 =?us-ascii?Q?BC7/eC9JtLpcyACwMCUH7Wp8Y6VtpoEQj5fXYrt37sRp4pYGdi9rWjvwjKot?=
 =?us-ascii?Q?zL3mQgn1piAsVympLkVcSEwwIh7lveYZK01TXTJsMUpz3nYih49wbv8rXxHz?=
 =?us-ascii?Q?BOctaFpq6uYxW2T0Z072nCuCPLRqcKH53eemZCssGi+Zuf3gNL/fiXPwABR8?=
 =?us-ascii?Q?y0bPCXPMeVlI3O/jx60B3dMxSwBgUWgl9eiVIbl/VYLkF/q0yPGhs90oefVZ?=
 =?us-ascii?Q?yIakqd67Fe6o2DjY0rGqdYInXPv7L98roPeoav/fzbEM46Xp/toki1ICdbZs?=
 =?us-ascii?Q?YJETCrKiG+joGOghMaiXJKeMfajEPhzvwgcJLJBhhDp8qCKsKc1oiRzTwbHA?=
 =?us-ascii?Q?/hiRwbXUa956MwcQkUcHNZ5+r4tEnIekQ0CkYnKxo8w+vjy/+aaS7bfh/1bD?=
 =?us-ascii?Q?tTRrum1f5Uc0E1E3jzZyDk7GoqGVGlKcMnfRLwCUzhlhIf/oX3sXax2/1DRO?=
 =?us-ascii?Q?wzIlOR0NVING7g0uPYhnAk+JAJtsBzeU0HyN0lP3rxNnt+MAKVTD/1UaIzOe?=
 =?us-ascii?Q?wDL79hdxmZqXRTritWRSDhsjYGzSHRae3hYBvQwobiiL7RAVOLMCVlYHy3QL?=
 =?us-ascii?Q?wtpnnyBmgvtkzejDGGUJmidu3id9E6RGDurmsvhsCltjLEyw2VcIhqlmXJdU?=
 =?us-ascii?Q?pYQrYvLhKf9SvVEF0rBDqe+4F2gtgvqnah8bAxyzAkf+34Nb05gr1650OlgG?=
 =?us-ascii?Q?SuFLZX39hT++wj9GtDbUUif8+KJprnRnLieFeJy64VLFWXRkW/1oIz/m0GvW?=
 =?us-ascii?Q?HrR6Wv+zxw/A/YhK0IA4goAI8L5+opNfOHwBbolFYeVMqOcBOJI13MWduwm8?=
 =?us-ascii?Q?MYE6hOqihGY9fEG/5aFgjoBYl0fGp0MLoi1XDxWwvwVvAGdmA2fOLubJh6RY?=
 =?us-ascii?Q?BQojctrcXkWAjHVLGGiaWOJ2NsX4ZAEu7D9chwVCGPmiGz6EN1pQyTgfEYYS?=
 =?us-ascii?Q?bg4Qnq01nl4ic2qOnTloJ55G+QS5NR4hWyLhjyJMD3Ukv7J8tVqKwa0bOraI?=
 =?us-ascii?Q?CfBCLRWoMSbT2/46fqsBzQrC3/0GZnB3FBaZUbwVc8tqz0EtwGIEozceUFxz?=
 =?us-ascii?Q?kq0ofepBO5w/wix8vA3F6h3qHRTdDvAYpB//rFx8cglTZHb2isqSZ1asSWS2?=
 =?us-ascii?Q?LTBHmw+r3B9Z0lXjUlE0p826Gi8MhCmajUOziZFzKSXiFMYi8cjtqv/8HPUT?=
 =?us-ascii?Q?cg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A158BAF6A45039439EFFF98CA61228A9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8379f2b8-f0ad-4486-a6ab-08dac0c00b0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 13:00:27.8019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1fmwY1au33an5lCPHExcDIMs0WlYNWEWT1Q7c1nIotVpdUp2jT3PjeUG230VmkwZKurFzkBha31ijgKTuvM1XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7548
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 05:13:01PM +0000, Russell King (Oracle) wrote:
> Virtually all conventional network drivers are now converted to use
> phylink_generic_validate() - only DSA drivers and fman_memac remain,
> so lets remove the necessity for network drivers to explicitly set
> this member, and default to phylink_generic_validate() when unset.
> This is possible as .validate must currently be set.
>=20
> Any remaining instances that have not been addressed by this patch can
> be fixed up later.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
