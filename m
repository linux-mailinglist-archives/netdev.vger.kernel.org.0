Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3068756CB31
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 21:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiGITAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 15:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGITAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 15:00:44 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2057.outbound.protection.outlook.com [40.107.22.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576E9101D6;
        Sat,  9 Jul 2022 12:00:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lq114ijgNwyb4fSraEnODzG/AO7OLEdjVN0lcJJkw1RHoojBP1fGu2MXeyTH1V/nz77gZ6aZg8ybREVv1KyrkUZZWeyOAdqkONI4yqcc/gLPSYrY3X2+ATfpGltxZHrWydKF4fDNFK/OFHTsMOYz72FUgFYWWROESWB8HFuq6br6JsswBUPDdL+6vieyfP3c6omaBqklfMkDJFtVGXQZF8GlkNdTo+vbUmfIp9cUMtbHZgknwMf9qgWuBpXyLpaxr2uS2kHvC05a4f9uIQ3CZQlxm2K4MCFYCuoktAT1AWpirlhVOwpswjp4TC6VIi14pXnJjnYOXKxLEAH/f5IpCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UGgoWXf4DL4hXtfNjks1A9Q5D/Bh5yH84e1vW3rqZak=;
 b=BYkXIVNVlaIzuYo8dpVtTagdxq3Ys6YjGCl+g+ejA5Piw3oU5R0bSI8Qrbod0l4jWvApKmnep/Vm0j0j7YPoRTCl/K7jWRy5wSmWsq+cOeyUCj+IhNE/jE5+JXsvHgtHzMm0RbZHD1w4jY1IM7EdXYEj4mi9BkafoC2sHNJ1IemyxdbSJgHdh1jn6N5NssNyGmQ+GCnZSg3NIzSjHvABracmyrpWS4dm/lniKROsymM0v5fyR5vMYqXDNJg72cBADPPxB7s7DqCIPl4WqR7m2Le7NHCOpz4p73q8DARrLSqTRveL0S+WRosc+Q5W8vV9FuL1UjYLSEslC1ZBIs2YDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UGgoWXf4DL4hXtfNjks1A9Q5D/Bh5yH84e1vW3rqZak=;
 b=OgzQGXOxnTHLDT16Lgftlm3w1hH3ch034ykqENySkQlrTY3w41eletc7Xhd+1YZuZ81201STvgnG4bMjcmtQfWHcHsk2Z4FrDWchuIa9TR/BLAPbqqVN+mz9sh1UhzpO8z71+v2PijWDgkhnReLdXRuyvwOMscwWC+AMzArJE/8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9462.eurprd04.prod.outlook.com (2603:10a6:102:2aa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Sat, 9 Jul
 2022 19:00:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5417.020; Sat, 9 Jul 2022
 19:00:41 +0000
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
Subject: Re: [PATCH v13 net-next 7/9] resource: add define macro for register
 address resources
Thread-Topic: [PATCH v13 net-next 7/9] resource: add define macro for register
 address resources
Thread-Index: AQHYkLCOPS+xQ1o4CUWNiyTR5V/8Pa12avsA
Date:   Sat, 9 Jul 2022 19:00:41 +0000
Message-ID: <20220709190040.givfkiq2qlocbyab@skbuf>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220705204743.3224692-8-colin.foster@in-advantage.com>
In-Reply-To: <20220705204743.3224692-8-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f321ea7e-4727-419e-6f53-08da61dd5191
x-ms-traffictypediagnostic: PA4PR04MB9462:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TKsiHxyT38Wc38VCy1tw6tSAs1kc4emC76eEf8aLFvjeBW0bi1v4/NMNHJaJEUy5PmEyt7+zTbfHXmas1z1989yMDl7cPrIciH8twNfoK3xeVcafXWkZsP4Mjqc+gyR8vCFSdNHgEfkry/MgqLpSddccqrcAfL7JGwQdMv9QNQ12HcfbiV5SCOkoz7QmNXybLl2+XCT5lxJ/kkLk/k81dhBA8PVAE4Os4idAMfsBLYvoxB5mwdSjKJ0HidRrU+SjpBmpKfn9Qsixv/tsQYoLnrWTMiuoS05WLU2LGSbj4C/UAOwTjFgMpDXtJO4hv78xKaxTKDmZm4XbP6D0SvZmrIQ35frsGnfmQwpnJmJsCvKClFkLrvNLn3mhMzFOvONgoxW6Ta6FH0icK1qoPImZoykOa15VZpLz9lQSt2mnmPw3hqJQ44if6gGBEF0maxD6ykx6OO2OLwUcwQaNQ8LrDuWDjTLp1bQCECT0N0lvTw4gHryk23qknzicD9naIWmvfVOtKzn9B4h6NV4gqUUbOg2OStBtz5dVWnSw7VYsSbHJQfgkoper8xhyZOVCaFqUSL8USG9zmHVQFAt+sG5u9eGAaT6hnmimpUsXV4LbyBPf33q7T8kF+17EKn8qcpZ7sd5FLNQyehYBRx3ou/ZX2F8dGs5VG5pXtpSoXsPK/ut2jW+51uZGMvNp3fhqHg+aBivlw1fU26SzTWG8TkwM04hfPWooelz93HY0BnojnrEUZVSH4JER69jlGxmJ/97J0YbWRxseo5cH3uhDu58hcLPQXFQWTXpM8rHR1yasEQqgyKH2bOHGpddjp4i1dq+9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(41300700001)(71200400001)(186003)(33716001)(2906002)(91956017)(1076003)(6916009)(54906003)(316002)(26005)(86362001)(122000001)(38100700002)(38070700005)(6512007)(9686003)(478600001)(7416002)(66476007)(66446008)(5660300002)(8676002)(4326008)(8936002)(64756008)(66556008)(66946007)(44832011)(4744005)(6486002)(6506007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J7W5O52vJP3HibH8GNexauCjpS1dgM+q6KduTCuyg9JK+3F3drX2Zz3l0rrG?=
 =?us-ascii?Q?Z7uRJI1FClYE6AQy7lczxjNU9483X9Kqcg1860hAKNymDE2w/jopg+DXsGM/?=
 =?us-ascii?Q?lmU/jDZSMhMeOxuq5rAtJ5GzxbdUIklnXbAam5hPHnuQzkvpAZZiR+0Neram?=
 =?us-ascii?Q?D0SgUHwc45h0G2dE3mHqN7G28jHVO4pKVQvboND4SptaHB3BaT7qtWkILZaC?=
 =?us-ascii?Q?YNjDLFZmHuzPMz7QNaPf2grwibXUyleAj1P8Kz4pfIKhiKuY1zBOZxPIlEXJ?=
 =?us-ascii?Q?exT0OQniqqt1xdodceZ/KSKch33DM5M0e2fzI5EriP3F1Eokvllc9YwXM0O9?=
 =?us-ascii?Q?3bp6DjgglbS0+v5zbXB9uUx0S9RstoUSIBrTONQG/kEQd5oIp1vM7qo/+hta?=
 =?us-ascii?Q?66y3x1ns6gJbhkEvdsxhzjTfcMmOdZY5JHQqs0T6I9Exo2apg9nuG+b0+npd?=
 =?us-ascii?Q?K947Y3w5D3+zMfMvqYKkhzVmGHQmPjKlljPHNCDm/j97uYBbheENfFJnoOUh?=
 =?us-ascii?Q?SrghUqQZtlo7RZWK0J6t/16sEaFc3v3nReSPYMEUShPGMrtwT53So9Yyiihu?=
 =?us-ascii?Q?7l2xfFifbzjzWIcyz/h5zQR6fpiaoNTW4bSPQXZNZDn6CCNpzZbiiccMZRKz?=
 =?us-ascii?Q?dSOseQMUBkXvwy7xY7EUImKow1xBThZZs7DXYdDQeRQozqDDd+x7CF6/vMjQ?=
 =?us-ascii?Q?7XWTR48RBFbFGzJEpfWwRxhuv5Jbi+cHAi9QNceNFbpvsLdspAOTidZDWzZm?=
 =?us-ascii?Q?1kX0gOZQoJnrOWGr+aL4NgMB1cuvb1cdr1EhYzgUB4nQ4RODiHzrA7K46UC1?=
 =?us-ascii?Q?RBr9ck7h9ZxhwRWQjGkpMWcP8QD+B69z8dGH+cQgtBhl+eStjOnzfg/UktPW?=
 =?us-ascii?Q?zn/0b2mjKJNBE6HvDoYCe8Lxxw9tjt8wYaKEzY/0qgGTXWikDaFa5gBmzTK9?=
 =?us-ascii?Q?sjajAeMRJ8M04VKcUTlS414WiTS8GeHNszgxMJDEhpJgh90mhHQK7DDs/jZ9?=
 =?us-ascii?Q?A3hRsf0YJi4MbjDwS+qyJi4TrbZDyMJu81T66SGIj8ioZaXq4t9GgebF58ze?=
 =?us-ascii?Q?3AI/vmnufIzita44zwDB1p6qCIHPl819AhXQLTNco/6x/W+6PQs52yeV4o3G?=
 =?us-ascii?Q?V85Gw1VKozjXHAUkOQmMpuv+rrqFyByHK8wHnLFM0hyEIEFux/amHddpkzhY?=
 =?us-ascii?Q?oGuxRd+S06Y0XQJip1tfE13tjQzsQ1zAaU8p+Hy9kOnud4hyDfAADFKb7y1u?=
 =?us-ascii?Q?oOOKKjiaIiPc6UlYFk8ScaEGs106tMoiTu6uzyfXHH9xtXRJJS4Ahc4yEuAJ?=
 =?us-ascii?Q?oGZunMnWCAGSjusS4AIQUfa904Y+SRMpjFZU0bcFlqXz7c8PCCyCCghxJQQ9?=
 =?us-ascii?Q?S/2p82/pvmZChwhkegAR2Y2BlZ/+9buNwDs1nQPWbjJKEQbfMIKTk9TNJhxE?=
 =?us-ascii?Q?rtqBg9fSByo5Tbwj8FDGTdH0c0zP8yuh9KysK9L5JEBFFhUpiwZ7NL8jniKA?=
 =?us-ascii?Q?nO/2JZuFH0eXqjJ771qEZn6E6S39WuX3pgf3SaIpucgxv6pAPnxsPlPurOp2?=
 =?us-ascii?Q?WpdMBWEamJ14yvKXtBf4W9Pkna7n3x+J3+lPLwubceRRiuzaifwCLSWRrNEk?=
 =?us-ascii?Q?NQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6EFE78D0E3B49B4399D85675EF6A1CAD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f321ea7e-4727-419e-6f53-08da61dd5191
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 19:00:41.0342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RjgPN8nzqnR7uXYtyb2hxWanwSgjsHBb4nxUb2cen5Fg0xAgA+oUUH4K1rWaXlnr/xYgghOxbV66tz7zLcJJqw==
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

On Tue, Jul 05, 2022 at 01:47:41PM -0700, Colin Foster wrote:
> DEFINE_RES_ macros have been created for the commonly used resource types=
,
> but not IORESOURCE_REG. Add the macro so it can be used in a similar mann=
er
> to all other resource types.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
