Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3D361F3B3
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 13:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbiKGMvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 07:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiKGMva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 07:51:30 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80047.outbound.protection.outlook.com [40.107.8.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359F9B4A9;
        Mon,  7 Nov 2022 04:51:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iqnd0EC7ITKsgRG/RrVqR0j1xzR3KV9vACxCPBeNUT8hI0cn9NIiBtKfG61gTUIU3iUq12dJE2zDBT7XbNsFzVzparvhrMm7m8aZbXH2nPQjkZSra/Mr3p+8RmWfm4+SleWvoy62Ca6P7fTV/h017LsDlzdylhNyHxcwwA6QyCpuvUNuuwk6zt/Ikfxr/6ZnpLT44A/WF4TBwm+Kf9TjXC8U0AW6M0y2iXNLA3MIiLS5xS6DHdM4vWZlYIY/Oos/uZVWxdu76/KaI1bgdrpeFOx1/Ltw9qFtKouIJQpMKCypqvFNzpaTJDwxo04OKRj4uLNWFnZs6qX66HbLx9qfCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLTEngR/lOkrL1A/NWiUOZMbhGe0O/lNj2T78YtFp0s=;
 b=Ke5icpacgDz3A8ldLytcucy2Y7vXZr9PxwVN6i2PHQrSAHfalVtqHuq2/7hfe6nx6pZtOpB2UKo2ED7QgoeCOB5FWctn6YS2sQgb89qr9dlBgmVkhYHE9EJMSu26aVY6NJrh5k0a1y5N5Kgr9O/tLLHR5YNESYcc1+jFLYsgU+poQxjrGtO0DoP5dxNoJts7/qh68vfD7025PyQP6Jo0JKxocpHmiGdN9BFQ/QEQ1lmRzh3dwlyrARz+G7lmxZz2LcZFS7zPvJ1Q0lUJ5HkQPElxKpWp8wvaFb0U8bUkpaT0LpFVh2dbBPdA1JQl7f/Yk218puIL6ZlLXBxf26Apig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLTEngR/lOkrL1A/NWiUOZMbhGe0O/lNj2T78YtFp0s=;
 b=UVlsKl1Cg5fVcGOa94kgNkJ2bw6yi/o5Xim228bzci4OM0mHxZL/TSB2rDgZ40L70vNhFeOXV1qIaUrWofKuikM5pyM+0cGWYT1/EDjjGR215HdmYoD4sA46Eo0lGuNKTlV4tfxM1EfGOdnARhvQwMdhe+ecgxTySN3zIJ9FEPY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9457.eurprd04.prod.outlook.com (2603:10a6:20b:4e9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 12:51:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d%7]) with mapi id 15.20.5791.024; Mon, 7 Nov 2022
 12:51:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
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
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: Re: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Topic: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Index: AQHY8HTAfetHoGxM5E6HcRPQNrr8s64vpgIAgAOw8wCAABdsAA==
Date:   Mon, 7 Nov 2022 12:51:26 +0000
Message-ID: <20221107125126.py5n244zk3inawsx@skbuf>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
 <20221104174151.439008-4-maxime.chevallier@bootlin.com>
 <20221104200530.3bbe18c6@kernel.org> <20221107112736.mbdfflh6z37sijwg@skbuf>
In-Reply-To: <20221107112736.mbdfflh6z37sijwg@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS4PR04MB9457:EE_
x-ms-office365-filtering-correlation-id: eb02bb5f-3c51-4ff4-5d72-08dac0bec8ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8DYPHsza4rkrGKIaebI/j3luSYq6WUiIWpZ5lxzvqOqWHq9QtffU1LBiHDrzAR3iMKMjb3QngxyG9I77ooyavG79GqV/rZ69E2ooTxK1JGcB7DDyoCQPrnU2k1At4Ls+sch4IF7+2hGXMmq+gsomEGPlxGNTmBZ9XEgBxxyVjFhL1ODvqoa/ZjDVI4DW/u+SNh8zVq7GODC6QkGMtPtfFAOofssa0FgYTup2nNLK1zZJ3oV6Hq+ILUlxyTF6INxvS9IWSOvmYPQSLWJtqALt2rdgEGDorrst+UKG1S8ihs0+fRBUY+Gl2BMRrLZMZZO0m4zTMu0MLugLT3gHfZGeE6VwTCPhJn8w6mNaRAw0dRRcxpnC5Y3gXI/0iKxmBEmgq2eNutfTQtlXzyqjO0mwtqNjuKW3PVoSXQeX98TLfKqIuhElhmPOVm+NEUDwGX2NmGxKkZoCs0D57CkdY+CNw6k0KMOpau6yn8CVckOpZmxJnAk66TCHaAllvZps21Jy+jCL4iCz1EFrBNvko/v6uX1cu/UmgPdMg1nVFzwMlRUdI9fwgvsjSRT67dfkpebPjQlTiLAaKaKP0NyDpkQaiJTcMEkq+d96t0+Ubwz0vShsvUfQV9w8WxbNY2zlUZcscggLF56L1qqf4VXBRyqcMHY2gysZIccvHOResSCG1JhCtTBj5BX2NnmQ9S52ePPcLiyyUtMCFcbjkfYYQaOzdCI6kV7YS4VgO0vQQHxAdEhiTDldun21ttDgu/Cxrq2KrieWYF9Xjrw3h0i/EAlLnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199015)(26005)(9686003)(6512007)(41300700001)(38100700002)(122000001)(2906002)(7416002)(4744005)(5660300002)(33716001)(8936002)(38070700005)(186003)(1076003)(44832011)(71200400001)(6506007)(478600001)(76116006)(4326008)(64756008)(66476007)(66946007)(91956017)(66446008)(8676002)(86362001)(66556008)(6486002)(316002)(6916009)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LyIqk2fAf2RNXSHLKrt11GGA4wdZLZEkSUy3e5j1iKQJyg5tzf3fn6Oxr2p+?=
 =?us-ascii?Q?LuOHOHioenoDrXdayiugKk/FknuqIDGqkfyLhaOL9Db2trgy/xCFZ1JCntLx?=
 =?us-ascii?Q?TiwUGCklZGmkN9XlZG1m2zUAmDo2JV6rwMWVKjf2Fd903Gg9IAzwSQfOBrNR?=
 =?us-ascii?Q?ZZdZvNHdHVQU6KZUSjNEB/fVhpHN2Hppe2K1WFNfN8gkK598jlucOUsWoDHg?=
 =?us-ascii?Q?f2uFte/q2aPiVKn7ktcYXkiWcZg1MY0l5bYny/EA1iCEzrnpMTuEqTb8rhyA?=
 =?us-ascii?Q?/XShuGPHY95kr3MCFhC8Og5xFDHJSAkk5gsZppKSuLxqnuOk5m5eEa+A1eVf?=
 =?us-ascii?Q?12ofnXFM6nVEz+m/PH0tgoAWxrQZo1xzMtdnzQl2e3MV+b+kypWLkw+rcKm9?=
 =?us-ascii?Q?XzNiM2ge9DgEMAmWhWrQ8PE7al6ywxhHe+HoL6gJ/jylQPgj6IElh5C9DBl8?=
 =?us-ascii?Q?LOPZSs7zxjnmUuSx+MLuiDMtTMMUtF6lqiH8b2ictDz4d19qlCvKH3ch0cBt?=
 =?us-ascii?Q?LHCDWvfE3HmO+hMwVHWz1zFMeaJfCJEJ17O4u54RYTwiJVgzeu5Kw+8woqTL?=
 =?us-ascii?Q?WmBV/HFe53nIP9sG6O7tUi2KDpc2vLbNycNGPnPrn115fGlhyLW7RSto5moP?=
 =?us-ascii?Q?TRVNBTGA2xkEZIExE04kEK6gTyWbFtXWo5gcjYr5NJ45mNP66FBCihLmmIJS?=
 =?us-ascii?Q?NeYbha2R+7ZJBZngIvPCra7sgChKE73wtgaXzOZoczr5sQhzj3cqmLckO8WX?=
 =?us-ascii?Q?w+oVqxe8T8ZazX8yMEvtb0eL0yYIAa/cFSG0D1e0JO2iL5vapL0EC6xKqOKb?=
 =?us-ascii?Q?1xet6YLbq2eH0mN9wdX+wAPA6a1eDNFy/WL6ytX19Srev9GiqnZHeKMoqmRF?=
 =?us-ascii?Q?jpvY1VcqEQ5jrAg/MulI/7+uGN+oRtqHdaxXLsKzpQxZbQGZWYkIUWbT/S6l?=
 =?us-ascii?Q?Bk7FQtxKJVuAKJDI07L4q1TG2lOJD9SP33sx7SrLrHT3p5q/x1vwn83fP6CW?=
 =?us-ascii?Q?p+zafyTDjRtMpcC3h+fzMns5rxKp9Saq4hubA8nbP/GIt2TAPG/L9s4IJg3k?=
 =?us-ascii?Q?xfnapxzUjWXp1OLyoBEQSQbaiRrK0Cc0Qo6tWERJlHbIX4xHwQ8keP0y3rBx?=
 =?us-ascii?Q?rRta3yxAeIuk7ZKtaOyzHmP//1oBVnASJgTaclrCBUURqK0mYMwUpU5VPsq9?=
 =?us-ascii?Q?Hfy9ycgaRSw6KQxag4za5xvtbDERw3qUlYRApU6UVFSRDr92WlO8MjeQIfAs?=
 =?us-ascii?Q?8GskQl6OFiIP7DRJ7No8Bz+SfC30VJSRo2my+E8UHhqxbpOsBKANYbPK/6E1?=
 =?us-ascii?Q?zEsYsPFWxsC4eEwtXB3pQAkyRi3UDhyECthDNOw42nt/3NEwkweZtUxyEx4g?=
 =?us-ascii?Q?S6ub0GtNY8cJnPknc8zxTNcICPzgJlW1ES9URsMlF3w+MrVexqgs8SMDgpDg?=
 =?us-ascii?Q?/u47oitO9t75j2GSmLTZF6IG65pijr4VhUUFKR2dKRX4Ctn0VbM1+6SnS2EA?=
 =?us-ascii?Q?B5xYmZnayNR8/69sk9no6lQsGTF0Vu0bPv3dHlVwMRzhzsNZb/sFs/KyvAJO?=
 =?us-ascii?Q?d+rBxdLAOqDgXJNig2gQ6QkDKfFEBmA+VtLhViM6E3TeOOhhrTQAo+hKV1jI?=
 =?us-ascii?Q?Cg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EF581A91748802409FABBC6285D88166@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb02bb5f-3c51-4ff4-5d72-08dac0bec8ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 12:51:26.9183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LzuHL5oyPpH4kg/j0hS6Mf0mh5ClA6o/vPyxLcwd/J0YA71lWXVDM1C/qVHhCTi+oN4psafzeVti42bux6Q0CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9457
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 01:27:36PM +0200, Vladimir Oltean wrote:
> Hi Jakub,
> (...)

There is also another problem having to do with future extensibility of
METADATA_HW_PORT_MUX for DSA. I don't know how much of this is going to
be applicable for qca8k, but DSA tags might also carry such information
as trap reason (RX) or injection type (into forwarding plane or control
packet; the latter bypasses port STP state) and the FID to which the
packet should be classified by the hardware (TX). If we're going to
design a mechanism which only preallocates metadata dst's for ports,
it's going to be difficult to make that work for more information later on.=
