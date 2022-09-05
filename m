Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29B45AD7F8
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbiIERAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235938AbiIERAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:00:33 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60044.outbound.protection.outlook.com [40.107.6.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A445C9D6
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 10:00:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCzfdA1tblj25mg5V9sIV01uWGPaYhVbkdVsThfI5j/9NNqrgguvgVe1JM8mZx+ski/mTg73R62xUJi2OM8MRSk1VgrvXoFRbb4eawutquiGGgqIwz9CUOneHuhWU+BI2VEOVnisrH+l9Byte+D01dAUowPkzo4gWT9SomBiw53nAhfkzFidKvY0Bhy4EN7sEjEY9664GBNe5P+X9HDh9LeJtHQpRdS6gO7XIhfDM8FWTmTrClAi81q1Sfth0ORObT4ExbGOjvJUBaUOo4P1/Vk1ePsg1odLJiXLhGG3kFS+MWh4iFBmvtuQM5TM/mAdV0Qphkvm9wkIOLO/ABC8Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ObOYq1EkpYDAiBYyzTRuIs3+PK2zCD8MFkte7iclVeY=;
 b=OokX4l7tOMhO6jripmWf3RYmtFTntcCKcW17Pi/m3hizjsneFB4SOgp32iPElQZbhNsEIi6TFaxxIYCBKBlRGoRzClWu4py121aIX1gW4VyzOkgZ8pshD2H0FtqzS+fg2VmhsnqDZDu7eV3BQ7BE2SoBnMhlUpwe3dZSWbLXstfvvjlVy1e6A/ED7e7gmtbthg47suduOBdRKgBlCuePxIUrfyoAnJlzBqsc9QEStkmXOVHVeZqyf2xXVikjupnI/uNvy38Yj3c3/Pnfgmp+taGWEgGHPe9i6aiBwDsgbCgtK8S63YCiQVcqpJyYaQKUzT/XZfSjXEbyAxs+Q1YT+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObOYq1EkpYDAiBYyzTRuIs3+PK2zCD8MFkte7iclVeY=;
 b=Q5hw+YyEwekhL+dV1AvK+1itGxbinBvglOuG9PqnGP7SKAzGe6N71NAP5aMf46b57HdaOmNXaUbe4aOLWcJDI4U7Itod7El5IcOMSjOtbH+2FchroBu+FnSGBQA0q7VBRZ3/rs7c6Imo8te661dqNDT5orVZrfHBmixZOB6epEA=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by DB8PR04MB6793.eurprd04.prod.outlook.com (2603:10a6:10:11a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Mon, 5 Sep
 2022 17:00:28 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::b9df:164b:d457:e8c0]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::b9df:164b:d457:e8c0%4]) with mapi id 15.20.5588.018; Mon, 5 Sep 2022
 17:00:28 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net] net: phy: aquantia: wait for the suspend/resume
 operations to finish
Thread-Topic: [PATCH net] net: phy: aquantia: wait for the suspend/resume
 operations to finish
Thread-Index: AQHYwS+o4fOc7GUfh0KBoHXbHje8/q3RD50A
Date:   Mon, 5 Sep 2022 17:00:27 +0000
Message-ID: <20220905170026.ddiosfweckkwklhf@skbuf>
References: <20220905135833.1247547-1-ioana.ciornei@nxp.com>
In-Reply-To: <20220905135833.1247547-1-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 970ff5a6-3b76-41b2-86c8-08da8f602248
x-ms-traffictypediagnostic: DB8PR04MB6793:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qu4WCWvDjAecVwwk61x25J/yNzrmF4MpDnrzHzxSh0dKkjj3W/XoUQiIngUpKhDYs7suTQybrjbn7aH2Bc36YK3elVbf4Wu2QpzH9H181BPOUel8U3S/FvdEW9S3VWpYyyu8v2AXiW31HjvwHjcV4EX6yNUXcY6wvuDPuPKhPpMkZEPuCgH9gjCHYX0U+J1eeFekOhlkm5ZLnbw/2eb1kRfoVTggDrOoHLuK8B541FYU7+iFs/pWbUMYzvVyNjw0yQVysXaZpi/7xSntGFmM/t5zzQs6XUxT73tm8bmjaLmtsKN30J9VKbNEuGGMWFtkx7EdET57jZwoDjec+mW1/w7zs4xiFHmOq0/URAo831q9Xk09n4xyWuVJ3+D7BZcm1Leumre+tDtkOAqLkDoPxeNLu+GhI2X6cPjHwAKNxENUeG1y+81nOnayrn6GYSmw1TgyxHKKP5Mp94p30zUe8mE6FXSns/djnvZ9BP7Z0vDRm6ap0GHYi4FFlQtqXrkv3egYZRwP1G1KikWPYWUU2loVAxl5wLQ6w9NWoHTplGPkDxxos1ObMUMkH/2HCAxubhOXxRhpSqX1j4Jd3m5p7wQnJih6guC0RRgKaOgO9SuzTozeK+LqlLqIYA7K9+Jpp/lKFiu0IZ9vAEyDDQ2MfhuuInByZqHOc0fLR+7FnlnIZxaS2vmHQA/7y9oowRfYD2a03zYwwnZfAPxHotZvCStDjJWqZKBtHl1uQYVleWPPgYPEZlt3/d/qyURn8mztSaEX/PbAdc+EA43MCWIkig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(122000001)(33716001)(38100700002)(71200400001)(186003)(54906003)(110136005)(1076003)(316002)(91956017)(8936002)(6486002)(6506007)(66476007)(76116006)(66446008)(478600001)(5660300002)(4326008)(64756008)(3716004)(8676002)(66946007)(86362001)(15650500001)(38070700005)(83380400001)(66556008)(44832011)(26005)(9686003)(2906002)(41300700001)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oj9cUXpaGGye3LjFWAxrPkT3l4svVra1jCsfEhYRkHfW8NFPsog/rz1v2rXb?=
 =?us-ascii?Q?VpEYiFaxlqE5OK/GE9olhG6FZS/xr9BE9FrZz50Wingo3ohU+9vqthSBzdSy?=
 =?us-ascii?Q?3A1P3/I2yeyAOhTR/1PCth0fd+kFf+PTBqhMNizk/7T2ibeqRLCs1OzP8TmO?=
 =?us-ascii?Q?MhsCNBsvoOEt40niZt30zbgy6RUyfzCoxjbR2wZcURQWzxtvW93VGwFRIiKK?=
 =?us-ascii?Q?ykohLw7ps+XT4yzCFOrq1SejaWow+Ydfqj8krcweeoJHN78JV9YqBZfHjYla?=
 =?us-ascii?Q?OgRwaDMT5YMbvScwjUT9Gm6F2l3jZe0QNIt7fbJWt/4rlPSe+M/0J2QLZVe2?=
 =?us-ascii?Q?caIt+A7pPCIBTt4eBm0Bt7pc0GTarGgAubgIoJKk1C1bxmTRcSAbAOxXxVM2?=
 =?us-ascii?Q?47Yaivq5Rcj2snJZMDrKW6sDPXfYbax++c1kIFtnWYW/aU0VX+ljthOcDWuT?=
 =?us-ascii?Q?Ogf1kHfOG83fRP4+048Z1pw3VXcj5IyovGSLx7ikvBsUljA029jLmIwaS347?=
 =?us-ascii?Q?GYgcfZHfFbbSDwg41wxcyg0EEJLdWwPCxC5YhCMh1//ZiD/fJLnScadQtaGZ?=
 =?us-ascii?Q?8coSb0tI6R5dyGujRSG9uOK+mbgqANCGsCA7lq09f8ZIK+vMSDuoVhEChbf+?=
 =?us-ascii?Q?IgHZHHf9PZKmoCZbympyuI0kmJIu5s6XAx76LyagwJufsA4J+FCBAyGuuaGh?=
 =?us-ascii?Q?lPZRhou87dzufep6dNCkuliRouFQgrUYu9qo9o+xZmtli8EXpvVwTeXea23V?=
 =?us-ascii?Q?V4X5N8ivjB6gv7MylW90pHCDccDCP5NRjkxPCOGP8S3z0IlSOWj+Kzyamrha?=
 =?us-ascii?Q?DmkEuWWusL/x41IQ+3IqIjK7vTQI0y/9XpMhgUuDknY7C4Xd/3GDhQe46xOJ?=
 =?us-ascii?Q?Oa7vQQQcivLiLserJ9p2qkUYRsj1FENbzkEBhy9DBBCyqTBFD/IQdEV0WuOy?=
 =?us-ascii?Q?M0lTq4VMNahgHIP90Eo/kYFGjvT4b3Iv7SfrcqgWVp3mb+4OzxXEMnPwrS8x?=
 =?us-ascii?Q?3wywNWZJVUw7ZVeW+R3GR9HPrgO1WrCD/XCWJjna6f7YoTIIy4NhQpSdNu73?=
 =?us-ascii?Q?d7JSdILHnoYzJHaKBT+tt8S8NSliy4TQQagjkUofq3ca2Jj6+A2/A65EYKc5?=
 =?us-ascii?Q?ss17IVWjduCLHBuHVdKTz/vQFhW6dtsMtRhXSZtqB6HBTWSD6gqT6ItkdhBw?=
 =?us-ascii?Q?kPdcTC7kCRF6bR5MSMQpFcPVnxLVQThk8LTmjHuobh8hg0AB4KsHDWzG5hlR?=
 =?us-ascii?Q?mOrB3ubuFPtOjY87Tie3gXxUp/a3VaOChGglMff0JojBFW387b4YSYzuuLZQ?=
 =?us-ascii?Q?ISyxibwSVSmLmZ0uGa7Y/ir3yUPtTrMP094egskpJ/FVSKuCBA+x9qsiyPNm?=
 =?us-ascii?Q?NXPeysakyKiu0BqSaCGk3TOogbTlYA3+3/EBnIgcqA4LdmxDfS0Dzrbjeudu?=
 =?us-ascii?Q?FJs+rWLZVwuJh9jCwPua1C9EJ5nL2/sEKNTKxJ7lpv50Non6vMm7b4WlxWWy?=
 =?us-ascii?Q?rl0TbyGGo4qC4JwBiFV09AXBPmzt0itbCKL97meNLz1lYthPbQrGjhODyO0U?=
 =?us-ascii?Q?tnVN2rWbaQfOFDGZQecUgtF84GSBR6P3kWtnxDRPYV1vzZRXgYeYSicaN6kc?=
 =?us-ascii?Q?OA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <44C48CB27C08D843A7DECD05D87071E8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 970ff5a6-3b76-41b2-86c8-08da8f602248
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 17:00:28.1001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b/ORU7N+YrHx0aa1d2Ja2K4zJ1rZcYGt1Tau50a0dl4KxVdf7jl2cWXZipBnDRKmuVQSRJAmgVLzgCwPVsmwzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6793
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 05, 2022 at 04:58:33PM +0300, Ioana Ciornei wrote:
> The Aquantia datasheet notes that after issuing a Processor-Intensive
> MDIO operation, like changing the low-power state of the device, the
> driver should wait for the operation to finish before issuing a new MDIO
> command.
>=20
> The new aqr107_wait_processor_intensive_op() function is added which can
> be used after these kind of MDIO operations. At the moment, we are only
> adding it at the end of the suspend/resume calls.
>=20
> The issue was identified on a board featuring the AQR113C PHY, on
> which commands like 'ip link (..) up / down' issued without any delays
> between them would render the link on the PHY to remain down.
> The issue was easy to reproduce with a one-liner:
>  $ ip link set dev ethX down; ip link set dev ethX up; \
>  ip link set dev ethX down; ip link set dev ethX up;
>=20
> Fixes: ac9e81c230eb ("net: phy: aquantia: add suspend / resume callbacks =
for AQR107 family")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

I just stumbled upon the phy_read_mmd_poll_timeout() API which takes
care of polling on an MDIO register without having to declare a separate
read function.

I'll send a v2 on this with the change later today or tomorrow.

Ioana
