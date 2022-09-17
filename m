Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2A55BB4F0
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 02:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiIQAUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 20:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIQAUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 20:20:37 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2043.outbound.protection.outlook.com [40.107.21.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175194E62D;
        Fri, 16 Sep 2022 17:20:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbTpnQugHxJXWrz61vXbHmN8xZISifJoIao8NfWug1e2MCdmJS78Ka1WpX9V+DqIrM2kMLz3VoGUOHuvM8IhieU7XX3y1NtcTqXy708GNhHAIXW0XiKf3lnnIiavM/uEo/lUpGPNWQMUGez1hvT+2MpOl/ZnUFKUxGsCeEOowGb023pUDatnBTo/SGRcIaXb0mJQdtinDnQ000zZkVZXZK1BF8rT3xZdMTd6XGI8z5gONyQJRQ18cRRJEWQrcei3j6EYq+UwXbsdP73ZAP01yS0hpVZm0e+9ZZvIHlJm+lO9E4fk3CnBJdmij+vp+4MuFSQwAKaRsUm1Ek/ZAN82Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyWv4A2PrIe3ZxjMYNU8ijssZNaqRGo+PM9u2myjLGY=;
 b=khr3mOu+/NHfkpvcHXGEj5ZCQh+qVV/rAe+KqDYKd+PkOu+tnrDMTxrb+iI6A4PDN/W8PuPc+BKYpMrUSCqoaVG03dCHhe9POCXZlu5C1dJrvr5h0v8q87fF3BSPmLpKrBw9/T9HZP2TZP5xF3G782pHcFT7e6Iu2I2Ba82F2KVGp6LzCFpcTXFHWyRyPnO8dkUIaaZib6eYZkNIXn4yrNAf6wCMbdR70sp3V82r07Oz3M7+HI4miGfmlwrhLYBfa2avLcwVy+VUAXWouK4XcO1ehUWRFaqmeptCV4cwFOd7H08mvXsTguv4h67EmyghNdhIFAUCZO6/tiiCx772Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyWv4A2PrIe3ZxjMYNU8ijssZNaqRGo+PM9u2myjLGY=;
 b=HLNDIw/OrxpKf0gIF0FoCb3eErTG6RE9D0oYX5seamxhUZH0I2B80EAbAGONyW5yObwkNgq2kWkksKpHlsVOj8Ye/dlbR4U850Wi/qruFZVI0vjxV59xM+3LT6/9HAypw3JoQbA4vttUICF01QTuLB815fzGR5CeQW2EaHgEUzM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8667.eurprd04.prod.outlook.com (2603:10a6:20b:43e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.17; Sat, 17 Sep
 2022 00:20:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.016; Sat, 17 Sep 2022
 00:20:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v4 0/5] net: ipqess: introduce Qualcomm IPQESS
 driver
Thread-Topic: [PATCH net-next v4 0/5] net: ipqess: introduce Qualcomm IPQESS
 driver
Thread-Index: AQHYxGBV/lOKpVb8gEC8qOCt/3pDRq3izdaA
Date:   Sat, 17 Sep 2022 00:20:31 +0000
Message-ID: <20220917002031.f7jddzi7ppciusie@skbuf>
References: <20220909152454.7462-1-maxime.chevallier@bootlin.com>
In-Reply-To: <20220909152454.7462-1-maxime.chevallier@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM9PR04MB8667:EE_
x-ms-office365-filtering-correlation-id: 421628ef-fc73-408e-73c1-08da98426eb7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qpLdZSNuQviD2QR6IvfusHFqKx2u8aFOn4hC0I2TsWHhICbO2ZdlDfbmkMEgkboKwJDeDM0T/C0X9sLQO8ew/z4AWMPk2Q2zmNwOI9o0gssB0htsnOtyhtFQ7PxQ4vUz0qkzFRcGPAsOaLNCKX8hFnUSOs2u/S0/d2UKzLOZpdP34w6GWmODU94t/le5X/Owgxj5bSFqlqQtJnEGNcCDdjqVXqb3ZBywD1dS5yxltBnfOPwrQLrV86ktYSeuXr31MOkC02sSjws9ult2O7PHNC/L6a0jtk4D9Q2u1hUtLBcWA1CNOLsKCCKkZXW6C+wvwRwvIDJhS3nETIFC5ZWWGFZpO/myTGNZyQ0/zEPqPeEGJRw2FgdjhDRtCxTEE5n90ZgrhJe2A1IjqGkI7qgBP7pMuMZEGHbutK6JmHl2sn9UFo3D9MCVEoAwpnJZbXu7pFl4wKMGnGK8oI/Wm7PGFL3tOdCY13/a3X93z4AJHW7qxBz3pOZ3D8tywq8/5Mxpwhn6YstfqpH6BQTTl8PThbuHi3FBlmc1+Q15VPVVdeJ1vjACeZi03dCpvohTSva9J6+DXw+AB/3rj0gwVCbwFljhp/fTcS/qe4GTMBSWJR0hhK6qtEvF3HMmr2mR+zJnGAeBf3K5gmCjRDIp1ekbuZvIHDrDWyMEygEYnYWTB7rudsHv18Xw888u2KtdcHfn9gkHw9DTcScG5aVE0qhDwov8MqyfZ5maXuziTYxBUpWYTwJYhlYvbjEKXwauIluINsTizVXa209bjtx7KIk5ZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(8936002)(86362001)(2906002)(7416002)(5660300002)(66446008)(64756008)(8676002)(44832011)(66476007)(66556008)(4326008)(66946007)(76116006)(91956017)(4744005)(38070700005)(122000001)(54906003)(316002)(6916009)(38100700002)(6512007)(26005)(9686003)(6506007)(41300700001)(6486002)(33716001)(186003)(1076003)(478600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V76I+Ii/L/MFo/mc9gBJQQcn4kLqiFSDMzPSY7PcOWEjxM7SmMrhNUgCQUne?=
 =?us-ascii?Q?CzQ8yONg1xrKHhSECROZxv3dW2QM6ybrcWv7z5BG5hay/5SFedBLRe63Imoq?=
 =?us-ascii?Q?wAz1uyNsOYy9copFTEL1dF1ofEw9H9GsoF+OYr1OnjUmF1zE+bTZGJGLdAdc?=
 =?us-ascii?Q?GsUSD1l2sEakWxQP9KfKfOhcHfitJzdNQlGc9tH44tArgx0dDyzwwtVq8rLJ?=
 =?us-ascii?Q?jpzitskSQAJG+YUknwNQExFAZMvaFQL6+8QNrtQzXkM/iDGliu0KcBiUPtou?=
 =?us-ascii?Q?6p1wqElpW7aaqPQeNiLI0o612z5WtNs9KVmA5+cc2xGheojx1OR8WdNyVLtk?=
 =?us-ascii?Q?gSwRiTSjead9zAPwMmKcDFFXw9Klyhd/BZrTVdV4aC7ByjM1aHgH/ZcW6tRR?=
 =?us-ascii?Q?ZApYK61BXMboX5tWzrsKbnkS+kcrCsvLYjIYuYvqiPB4U9uDENGm3xqNDli3?=
 =?us-ascii?Q?E4HkDVp/a0uVhjFdJuuutIGuAlHuaDYkHOylV1rObV1ZGjKxBXnDTSi5kHhR?=
 =?us-ascii?Q?dhDSaVpMsaHnoRwwldZ09owa6p7+8DdZIKEfi+Yzk8L0oHmma+/XEMoXEgV1?=
 =?us-ascii?Q?dOGAk582Fi3QQRWbkmPR2PQjoG5bBU4W/gaw3zwqG3NSjfyHDxL64rKimChi?=
 =?us-ascii?Q?A780ZVGYoBcwfctlWFiOti5fwYE+mqaHBkHNdoKRfeKV+AeaWFcBAZruaAxT?=
 =?us-ascii?Q?+P+z12LMSO/ZpA1IaMyRfrR0MLmaIHmctNlvwp0aKpVQx1BumZmOFAwC8MK4?=
 =?us-ascii?Q?5u29y7Drk0cdxBrymRF9hU0BERvRvU/ilW8RF6HIY/4uS/+i5JIsvNLORiPA?=
 =?us-ascii?Q?yP9ywB92NLVPMENbxrO2h1XE4N9geCKzucDrqlaxS4E26VYwW5RZjkm0wFDr?=
 =?us-ascii?Q?eHF7xaovQvtj0B1+vPa9ft14N6IiJD9PoRbo17hBw7gRNYK9ZgDJrdJ3Hc7T?=
 =?us-ascii?Q?rcb7jhDSFIVdeuhkeVcQS5vhjkN36uJZbg+DTtefI3s2O5QOBPOeoywLPf1u?=
 =?us-ascii?Q?KnGKEagGcRZrE2v7wV8bVcwDKJtB6D1SKW55hkJv4HYtXe9Yuflo5kfutqeQ?=
 =?us-ascii?Q?VTqGf3hdLOCXV9etdMq0w3AJ6ffSbpLhhGN3Mkl9kWp5keMTf9Gr8EuwxZvo?=
 =?us-ascii?Q?QNiZMOsDm3CZOiZSHBmEeM5Ck/nQWzui4cPq+41k3k8/5sVDc8pJg2Qifpjp?=
 =?us-ascii?Q?HB/eih3h54v2gv1efv5o2kxmYg+3IHqQUdjB6ynzDAodHb69jdSFjcuOTSMI?=
 =?us-ascii?Q?2UxujfJbTZ7UW56zoDh8E1qx6rY73ZXXIAah+A8Z16AJ6L6Ri1GIuIGaJGXc?=
 =?us-ascii?Q?CDI+hE9Eo5L5oIJFnz6QxgXfOf7tBh03xBPvv7xi9tREI5iJe0ynaNpFT+Gg?=
 =?us-ascii?Q?ywyf41F9UiYPck/8VE3Qp9BtzIwZ1BNBf/xeO8D/3cNnmXgV736lzXKoZeB8?=
 =?us-ascii?Q?Ndc6q4/8AHEMGx/xW3cyuFQdGXhbmZjUkvb+MZPn0utd0V6UQ9uP0sSjoPbj?=
 =?us-ascii?Q?WbrRQ6inxs6DLL5fEOfj56uXQjeFZNIBE83iyNwHXK3HHUrvVH8iWLzeN2hY?=
 =?us-ascii?Q?n3mwiY8oSsSJbDDfd3z+wEosYxfINzzxX0qxqNjLGVJ9T9fg4ctqTi11ccmE?=
 =?us-ascii?Q?Iw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ECB66C3F6A36D24CA9C9BF182F94A5A3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 421628ef-fc73-408e-73c1-08da98426eb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2022 00:20:31.8970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HwPa4FrJ+9/1ICyggIqW6sh+LIh0FDlGWj3GHDi38O79OYIPZqS/LVCgIGC2WZkI9TF7jT95dvsuCDjNYm2U6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8667
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 05:24:49PM +0200, Maxime Chevallier wrote:
> The DSA out-of-band tagging is still using the skb->headroom part, but
> there doesn't seem to be any better way for now without adding fields to
> struct sk_buff.

Are we on the same page about what is meant by "skb extensions"? See
what is provided by CONFIG_SKB_EXTENSIONS, I did not mean it as in
"extend struct sk_buff with new fields".=
