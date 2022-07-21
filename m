Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC8257CB0C
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbiGUNAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbiGUNAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:00:01 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2056.outbound.protection.outlook.com [40.107.20.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96CB4D822;
        Thu, 21 Jul 2022 06:00:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHWAn2W5FtN58EmgWuwJYTBfLwuYfVCkbJ1uvJKOgBvskdOND8UOkZcqHBT+vo96o4CNLaYOaaCt5VKOc0cJY24mvpnyrX2uyGfBiOJuriEJxfY42QYRGNpZapGoJLvtm7tgCpTp1G7ZoIgANKS0WEJyquOH1uk4cClTmBnJDwHqi+gcwDA9TLnv72bBIEVBiuwSyxqEoaWngKFvZM2TuTVOYzXmUWFIZyul6br2s+rVFHu4L2IYrH1G4lgu9D6UbHR1GRByveLoQoZWsJKnehr9uzCEX5sbtbCIHORTRh8zdx9BcwFAdhc0D9dSAM0BmRTT5K4hdQ3ksQYhXX1u9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TehoucVtOCQi6Cvq3HAZenKsqWEm97A0VQ2fCvjjZ0Y=;
 b=WiPze3ish+VIHLe3f3XVfzuwSMH3vHwEKWh/gmdYItBHooSltoqQVvwCN62LHa/bmEVUgAiPf5I9d4Yq3xxYCbe+jvVqLdYSYI+Tupnb4KJWY4qUCjB5/XgwveGI5VUciycUD9q6XzZhcqR4RIsZ5R9bl5wrlZU9qs8ZcIbfXNcPdKX+JODK7EG6LGjm2VwW2VCK0x9QIAaRnAzM7D0DI496aNhpkallMo+58lr4nkqsbsYO0gkcBG0fpA+VyviQVjC9o0YTqglBsYsm+KcFfF5LrNSghp5Bkh92xwdVlE3EOPvpVDiVO6InubWuAK7IM2568AUSNcaVsciNisyeLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TehoucVtOCQi6Cvq3HAZenKsqWEm97A0VQ2fCvjjZ0Y=;
 b=oQsH7hHi00QFrxGHKLCAQ7FW0xtqEQVxMUa2nejVmEsgktQTBVY0caqHWBUUBsynW3/ROCB5cZ9WDC/+opP+PJ2cijMztECzf8jrRjopAXeII0f8zZt+c6U4s3v2eecKDFPMCu4KNXvjF9yo2Wq9BpGwG7bhVfWTGJ+vHHcey34=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VE1PR04MB6671.eurprd04.prod.outlook.com (2603:10a6:803:11f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 12:59:58 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 12:59:58 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net-next v3 26/47] net: fman: Mark mac methods static
Thread-Topic: [PATCH net-next v3 26/47] net: fman: Mark mac methods static
Thread-Index: AQHYmJcSFSyXUJr2gUCC331I2wtlIK2I0kkA
Date:   Thu, 21 Jul 2022 12:59:57 +0000
Message-ID: <VI1PR04MB5807939F3B363BE967B40CBCF2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-27-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-27-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fda5c60a-34d0-4e4b-67d2-08da6b18ea49
x-ms-traffictypediagnostic: VE1PR04MB6671:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BAG9RU/VtdbSAVvPScL/9XeqyoUMbGty6AtMQT38LUqV5H7zqWfnF/X+5aPovvmSyQvox5wMBtDLb9/MqkCSeqmM02aMOhlrAM6iSPe57gcrkzcNJPmURX6BO5aDVO6XtvIYaMtPCDnU+cXV0gL/VNjqFuX3iVoTQG1rc06Au6sx1FssJhcnFBIU+oJlPzFU/krDP+yjearnYoWPPSnVYg9KVFzyHAavG5uaZ1M/HX2obfOznOiHCc/Ixs6k4ZQ+HP1ozO+aCpbI6aNidJAW+wXTXKyDndWOG3HpbBjZ0uNWu21AA42A57NNTZpXrLglijYQydlVAPS6rbJBlXgbUWXl+hLTJf5NTCs71yVLDvxM8DpC515U/hjPF6plKJ6xoQxNdC9gDEKrh2fFwdWX1uYIvP+mcF092I0DC0Z25HQQtjLfn2ZtkaKjmoQ6FZrKjNcm7enC+q1NYwU8pL73a/yxGs8jUNMmzlbZBUoCJzEz4uF7lnTabt0CqKg7AtDsnSX4mBU/eEn87S2q+Axbj5CKtU71uomhFf3aQKxWAfNw3MOuBE+h1bT932S1LrN2VVvrMXLwDFIVgqJF6kSaHInPFLuBAYljlkObGJKIz6ixwDJaJRVpZJPS6CiAycQp2H17HZ/lhu+Zl1XxkHQttUR1Lwnx4kd+lsMJYmo5FUPgXVRsQQ1zeP2Z2w+cLjsyrhpW0S+RgDcrIMAkyWtj/VqJgZkqLW7CxYvoSkdj9VrQbKZA4cR6JYgBsajXpGqA2auCuv00+k1tXwRofshWsUxjFW4ZvbZB5ld9CSk+3+FwSDoliR2kEQHV5HS+Pnqm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(38070700005)(86362001)(83380400001)(38100700002)(33656002)(66476007)(64756008)(8676002)(122000001)(66556008)(66946007)(316002)(4326008)(55016003)(66446008)(54906003)(76116006)(8936002)(52536014)(4744005)(6506007)(26005)(9686003)(7696005)(53546011)(5660300002)(2906002)(55236004)(110136005)(186003)(41300700001)(478600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GTDSCFcV0nWjjej1bQ4Ac4E2RVkrkJ5yToutOcvLxIRpztF5UpixvGM+2LKZ?=
 =?us-ascii?Q?cluxbkFxlwLCLMxmoiTzjmwlGtyk8q63YaT/gWwpQp4uAKs7aklE3KI0dAOG?=
 =?us-ascii?Q?qRSYGC3EI47829PdL6Zoe+dLiZxaLjtE8fFzOCJNcW2PXj7DykgkGZ3HNTQI?=
 =?us-ascii?Q?ducKs+YZZL3uCQpC9eZWul6TRAe+cqppFOTAfzbDToe8yOZfjMuH9H7inQ7v?=
 =?us-ascii?Q?Aplqz9NM2GOWT1nkze9oHTai7b6jcxwwlmLux20YwwJ0PvZeDLWAeDqPaST4?=
 =?us-ascii?Q?xDdKyXby1vKFwFmD8YYWXe2N8bjqZb575BCOaP+Mw5VkR2bzRa67yeKjk/AR?=
 =?us-ascii?Q?gZ75euqnFyJuW0Ua733byocwuX2oUrS2+94moODv2uP2ENxknLWCiC3FHF6c?=
 =?us-ascii?Q?n4jRzZdMGwSoct971Y2s6AhKbCFf2HSdPAgV85AHsrs2sQWnYwOjjzq8T6zh?=
 =?us-ascii?Q?KUmSlmMTtTDtMhvc8X7YRojH4C11HLw2P4g2NLFbuwwYcodJ4FYMKyZjikl3?=
 =?us-ascii?Q?qUeSIhoPTaVJjLsU1oDlBoHVENkaf71Ns+XVL2gBMRgDVaL1Omb36tbBk9it?=
 =?us-ascii?Q?AvNnR7S3m6MlMT3sLLX/8H/7uFgw5U5L1yUs3C3rw2vHjjY/mFjjWvdQMiJB?=
 =?us-ascii?Q?HEZjWA5YhJcXwW9wLjksBM3YQIZzvUl8OZ3H7MoaMVJpY4yNRKu1f9EIOZWE?=
 =?us-ascii?Q?TQy6o2w5YNLijLo8tn+hSHxt7jRv0ovIHwigqMGyRnHOhI9acKSNFyhwROs7?=
 =?us-ascii?Q?z1MvNwbrEmk6iQdcbUrg6GgbMRjGKvbv1EB8q7qyunH9/zKQcY+bdGDJZIyN?=
 =?us-ascii?Q?z1T479ACtkcj2NN28pqazeZCSF/8hl8ZlnvEWMqbg5+sbBG/GRNPnVORGIir?=
 =?us-ascii?Q?YUQroj3jRq42srg11RIjOugBAmU6Bf2zbgV8Jf9/bgkFCjExQfMg2ZRxZPQU?=
 =?us-ascii?Q?Z+9gkWjsU0+dU4mJG2+eR8v92N6nrfgWrDOR/tl/P0fpHoSp/D7wA6ti7LEw?=
 =?us-ascii?Q?C5EqodQO+bcwTeyWk177Qx6GAOFBSJM1EBPkXm68r9p+n3OnNi3jshlJFWIf?=
 =?us-ascii?Q?bTFGMqY27oW56AcXIg7O0WrahNWl7XJgamnbhoOx3KWy+RUrxOFpV2oZUaKn?=
 =?us-ascii?Q?7FLo+EKHTbevhICDOSK1jvC3JLlaygwg4QBnaofvz43Vghv3aIkPkBBVPOJt?=
 =?us-ascii?Q?GTan9j1DLx8quEWL/3SJmUJZeXP6bTR7HuERJVXLNZ5OJe/TO7pfOSRw7Nfj?=
 =?us-ascii?Q?kcwXSdCEwq8dqPU4jrA1DS9gm37RqGnTsBlChLxmioMqmc7N47VjR2aP9a6c?=
 =?us-ascii?Q?pbe39dkpmdZBKNrmHJIPPCltZWpgbOapOv1QTdUh/BQtYtqikL7AMBB2L4i+?=
 =?us-ascii?Q?+7AelUdxbfWI3UtbqSZt5lZwDU0sYxbhzbLbaXFv0y8sv5OAr+CYiKlY3wfG?=
 =?us-ascii?Q?P+Vnd4IFQl31kLrM6sYgJm7R9xrPJ/GrDrjRkHQ7KqqL0i5PJbdVwBF+KGqq?=
 =?us-ascii?Q?9zVxG3IJY5pftv+4f6+4vpbRDt0PO7w4ovwkc2Qtj8y44kgKTOvjS2fq6/o9?=
 =?us-ascii?Q?8J2IwXotmlG6Jn0Z+ZtoHfUmM9m22A+IAKAVjv/h?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fda5c60a-34d0-4e4b-67d2-08da6b18ea49
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 12:59:57.9944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cz6kWRn6EFHWo1t1EywLVIOdg+aFbftcCnflnHvG0oqIxVta/+i1oZmflut9t6k6aJNRiMSqiisNlJSMOy/rGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6671
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 26/47] net: fman: Mark mac methods static
>=20
> These methods are no longer accessed outside of the driver file, so mark
> them as static.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>

