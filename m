Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8D356CB29
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 20:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiGIS6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 14:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIS6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 14:58:19 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2043.outbound.protection.outlook.com [40.107.22.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BCC23158;
        Sat,  9 Jul 2022 11:58:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ueopmod6KIr0Kf287NAMTM4gHa7QrGVC4fbK9TsYzVfmT94sebiQ4nQ3Yubv9phYtFpIO2bh9ITADQdAArdp4qAGiFu5fJhqSnUVJrW/+SpHAKh40USOV2+pXEbe/8Z2twiL6C5pwO0BdjaeGsh1UAZ1CxERwSdLFzwqF/J2en3hAEV6Jnj2zpbJcHEaQ5/j6yDPeleJZVWFE6ovcKS7bYOxlEup1EkvXqXOlKkW8Rq/9e8CgqePuHCk1hJga78v4rOFQR8ThEMX5Ge7TczDE23oc66nymluVwZ5XDMLD/1fC7iK3DmVgHcEBIM9DcdlS6DtqwuiRb3bqAS87e6LLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e1ZWKabjWtQ1gL2QKNbwnCAGeIvy2q4gf6PK+SyoVxg=;
 b=SoWOaauG4UOOFAj5c4VPWmzLkbKC/sktLIW1cOLiyFBbJdgx8zEVK+YtGBJHZ/81CDN1OYlqVXX+TG8cqaF5WCVmNk2mrywxs53L07iGgXC4eGBJmUunSndCPdso6totDFLb3+o53tvHJl0wLENjVhVtN/SIpGFhFO81m5eYydz1UgSiCWOk0ELLh9zq0YgZvFb/qFUAR4P4cJH0XUBBPW+uRri/uifReTOZx4FiOvc5xlPpWHKl7ysb+AsmxpIkIUXYBKdKl93CmQ+3hCa3YXZrTQaYvuAuPMzBHMYBa8dK+jbOVA8y2VjG9mlNLfOHh0n+EWtWL7OC+5kMzaJmeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1ZWKabjWtQ1gL2QKNbwnCAGeIvy2q4gf6PK+SyoVxg=;
 b=Fl4P1OC45gFQqRowj5vLKMhQl4snLkZXBlUtodTe74R1lpY25TrPvw3vpD0l9l4qhkwHNEMfIDkWAf+FNlQQeBJ+1pm9rkYec/Rz2tMbKghO2BqVOB9fpnG3Bwb+pUrBswyDSykNk7AGq9dJbvGInuvjXTqbR4aZfoKH0SKMCQk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9462.eurprd04.prod.outlook.com (2603:10a6:102:2aa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Sat, 9 Jul
 2022 18:58:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5417.020; Sat, 9 Jul 2022
 18:58:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [PATCH v13 net-next 6/9] pinctrl: microchip-sgpio: add ability to
 be used in a non-mmio configuration
Thread-Topic: [PATCH v13 net-next 6/9] pinctrl: microchip-sgpio: add ability
 to be used in a non-mmio configuration
Thread-Index: AQHYkLCOYxMcf2PE9U+65pA+4wlAq612ak6A
Date:   Sat, 9 Jul 2022 18:58:16 +0000
Message-ID: <20220709185815.fwquy2actlcxit75@skbuf>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220705204743.3224692-7-colin.foster@in-advantage.com>
In-Reply-To: <20220705204743.3224692-7-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f8fd504-6ce9-4201-b738-08da61dcfb82
x-ms-traffictypediagnostic: PA4PR04MB9462:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p4FUeqbzmXazUX+50Rxbeaw5+hZGNw0oQsj7u4rzLBhRZ6IbD4Pm+p6vkkfprd/DiJzeB1raHe3p1qF3es+IZH7crvcTBgFkUVcmi5ffy606bSziXkkWCABl7bx9oWt6Co+bUCtOFjRRA81BqNOyooYPDFuioCozZFDOoBB+pH3YndkFDdTXyJ9QbuMadhN0tTV/hypQxtY65wNLfQ49VNuCapu73/94WFDiMwlkJhAfbUXEH34zuvcjIhQYQPh+ZfaEowTHzxIPSUwShtnPOej0MzcEmbBdjtljGMJJtGzYEdvN7WRErt8EsP8SLuRFywoPmBjYaJQVh0Hlp6UjIANOuxqJ/+n3Q895LhnZzhkD9fNBFCOAtVSkAEkbpFzjgxj6CKo3NKgirHO90SB/o+K8Xzk88KOO/Wun96j173BEv0UXFTBNzewf2uIOqfIAlh8hjSnsl5X2Y3BOZcXqXeccg+jffsjDWuPUnah5puK1/SELyk7LQHOBf9Mj5i+d1Faod294ELxhljahNJ1HQol7cbv1q9vGH1m4XFbj1c1BlLpF1/n8oQN39nA/vQsY9MTMmlNWMZJRJN1vw43EetwEsZu9EVafYb9d637s2VHEr3iiN1ekgTrXwvPgTQ3KMdcND72maFHCMHc304O4IvcS2bqT1IFKeupKQRDdKYOmVRqHIHG2qlyVWBK+m6OFArl3xNxLcGUuTsFONosND2027odn+uXPgVujxkOKX6IrUqJGD1wirnQplXbw1vueD8UMTBgcISv1b6ZyQ+xWYKRWBBAUuLZhQdpfqZxfw24H6lK0s879ihkt0lgNg6+x
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(41300700001)(71200400001)(186003)(33716001)(2906002)(91956017)(1076003)(6916009)(54906003)(316002)(26005)(86362001)(122000001)(38100700002)(38070700005)(6512007)(9686003)(478600001)(7416002)(66476007)(66446008)(5660300002)(8676002)(4326008)(8936002)(64756008)(66556008)(66946007)(44832011)(4744005)(6486002)(6506007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U7R4KkpzNeCJJeNyZ+yZ2HttXsg2idMRWqxkcoTjiTLFCuadH/Y9ckZEQGE/?=
 =?us-ascii?Q?1COGhttpbwwjtO++amAdajups4Z4r8NWyL9gAgVLVLBTU/nbQM8k4n9k0W2Z?=
 =?us-ascii?Q?/2UN3ngnokhOFvAqsaBmPUMfxfGADxd0ocLlHXL85BT6GgmE10ohMAT3H6t6?=
 =?us-ascii?Q?RTSKrTFGP6Oqtna5hwOAOgFG1+ZaQfmJBUyMxhFp/yIU9sy87RowlUe+od+u?=
 =?us-ascii?Q?M7jFgLptViE/85pXd600tT3twdBscwBtR+4zHMTWuw3bpje1AK0fKRQM6kQ6?=
 =?us-ascii?Q?oMdN8+i86VvdNOO/fWVcqMgmyNDQ56B8zosl857a19elOt2W488CHhFBY5Tf?=
 =?us-ascii?Q?aecHECDRsgGiCXAa8ncwEz39JOr/L273f57uIR0LnHJvP5IVMocpanz4Xi17?=
 =?us-ascii?Q?O9nrKCzCBXm3sk4gM1Ol0Oc0aGqnWWVRkT/Hl1EKUcUKM5P66x1NDE190EwF?=
 =?us-ascii?Q?yLUTfx4/BhzkQsxb7KxM7roPpSR4jBZ+CV5tMXDeKygDiUcIwJoG7y+QuBt3?=
 =?us-ascii?Q?PUlFHquh9H/nk8/mdOUdS0aEVvYA//xUFlS+4VuhZBQn+4tvgNKusKKHadTQ?=
 =?us-ascii?Q?a6pGGVNKt5031NB2MNfuok4Wisn4jJ89uIOxq65WbMy1lcSHrcf3eQDRD4HU?=
 =?us-ascii?Q?83kMoM0beAmqcry0O3rHH5ZKe018mK4w1HBMdqbwWFBZ/rP+vTalhr3SV19e?=
 =?us-ascii?Q?01TyfMsap6+ebLCfufLiYjZw3SBSiE7HeciPJzMVDDNrmVaOuorGnYO+0rZQ?=
 =?us-ascii?Q?Th6Q0Eq6T0E0SatBIH7Eb5IXUpUf1ST490e/JEP0hw2jU15krJ0lVL1hYzBO?=
 =?us-ascii?Q?mssDp6gFLsc4I1Psm1nd3ZrLf5AQNa1VYwI/NI3/OCdz3sF2bkt5YJZ+XV5O?=
 =?us-ascii?Q?Li67YykYtql/PmzASiFH5AK108T1UyGLXuWWRylHq8OTn8CZu4ISVeZM0NNB?=
 =?us-ascii?Q?E1wx3Ks2zqTxcUcBXs9l0/saSeBVOOWbK03v8mzavFnw2Jb2qX6L/ZvJlYl1?=
 =?us-ascii?Q?EmcK8/o1CXpD8EzvA9pUuR5j5nJIAoIgTI9fXEEL/qaSwpIRZ1pQqJjE50Fd?=
 =?us-ascii?Q?XsSMxhaLdD89Aj3yCjCCtAGE3+s1wVddP5rwdSyAJ4vt4yYkYPfb9XVnBryQ?=
 =?us-ascii?Q?LjPiqKO1GT7IihpAwUn05/HNavCBi4HF7/gYW+pOf3JsCURRPAJScgWBqnt9?=
 =?us-ascii?Q?HV6SijtU1LuCvplLT7xFuApthkMo1a3fFYLrFLWQzPqwg5SISSrL3vCUIKzJ?=
 =?us-ascii?Q?fwKomYmSPbwfb6q+n8neKw8DKzbWc9/SETAUcc8XMdAKa3PGcL7Ig1sf8JpA?=
 =?us-ascii?Q?92z4BMS9iKPI3klqOxdsGW6JAEYev2P2MUi0D4sQKekj3Gp0q3TAn1iTCiW9?=
 =?us-ascii?Q?N5xTfNF/BXYmrwOczfncBwZWFxNDAFeoDRUbhNyFmcAKzV1kwPp1+BeSUpGJ?=
 =?us-ascii?Q?KgylqgpSFKeCRlNIj54kXPc8lJLuoSmYvj9A6MU5F7XFPTc5i9uAURXMzWwk?=
 =?us-ascii?Q?330FcTqzJqL67At4CgqlMbO5pFkkUs6M9VN8qnB2ePJ1Lkhwd3uBCQvPswQO?=
 =?us-ascii?Q?qjUPi3UrQC5QlPeq9eAgufT0bdugL3xIkpKLlkIXtPOWKp7KsY9m6WdptJBu?=
 =?us-ascii?Q?ag=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <58630EDD6DEB72419E470CD40EC2AA1A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f8fd504-6ce9-4201-b738-08da61dcfb82
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 18:58:16.6068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bymDYyEQOKYsyA2X8WYC/JTzHUUg44fjeKFokxLxB5oynZLYAzClacW+NWp0FZ4CF34dVtyY1Dg2zNuseMyUfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9462
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 01:47:40PM -0700, Colin Foster wrote:
> There are a few Ocelot chips that can contain SGPIO logic, but can be
> controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
>=20
> Add support for these non-memory-mapped configurations.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
