Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18BE5E987F
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 06:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbiIZEqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 00:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiIZEqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 00:46:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED5625295;
        Sun, 25 Sep 2022 21:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664167602; x=1695703602;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xMm4UwJoW2sdmfl/BzsueKd0YNC/+7jtG8TF20NI0qk=;
  b=GEecrHgihRLwlZhc14w5Ha+R+aa7qS48ftDGWMHP8Y1WMUmQAjNbr3g9
   2py5fTy0CkLWvbPuCuxYQfha/rdNYzb4GnaF6QFmfEsxGOjJ2I7kdMc8a
   AH16d8AfQDACJEI+3w7COr1EbZ/zK5ZRWxKuA4D7teIoWLwMbTpVJJSX+
   0jpHQZ5LzFpFR53KzZVplfTkTMyb4jv9/SJe5ocggIVFG+Ue9fHMBOcoX
   pHPQhv7HJRnimNM2PD9kG14BXKMlLBoMr/3e3RsbnS4H90Ta3p4BQTrwq
   1d/kZXGh/UcfymvBWKH+JKZqx57jLkjtNcA81IJ8VhQUI9wY2/C8vpKvW
   g==;
X-IronPort-AV: E=Sophos;i="5.93,345,1654585200"; 
   d="scan'208";a="192432483"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Sep 2022 21:46:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 25 Sep 2022 21:46:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Sun, 25 Sep 2022 21:46:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cK34g0gA03n/Z54N/1IGoSqYq5hLkA8YFYHU0UjtqE3JP7yvN1YdwqyP8KsO15D0K3rGohC6fcR5DsmBj1LPoBHa9+kfMEaVpQSlYl8OFbBiklElgLQ2MoIpE9dcZ6BML1zppGD5ytIxuPl9BIi6RnIQJVPvplyZa4+ZfkTJ4gi7ti1XgUbu2Yv7ZuNdbOZmdyFAq5Birbvc3UMGdXmM2ziOjZDEO3bykq6a5dNsnVTk59+MaxUtfBfLnerVI1nBvlZWON1ndPekIVifZUaWTRhlARn1KfD/7Cvz9ynGE7TCuWpJaojnUpiao45cy7nEmfv3zzNeWklEO9D5ScFwUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axzq8xLbuJ3I4EjRnzz9dcT8d5kvizPM4eJbXWJ+buU=;
 b=X1rQULWwAROgeCOg3ypmVC5en+6Kz2u2CbwVHJm5HkjTO9dYqOfJEa766Mggc1iKjYyaARxWZ//q5b3oNC5a75AzlT8FIRcZtUt1J1e3ywwH9B/3188xSdXNlWRDr7NNlPJz2t5oOFdqocN7SASDcs/kh8YCEmEnljmG0wykFK8n67pTBoccqfyTGoI4ETEz9xi1439qtu86XM1fkM7IsOJm2PyVESroKadsaHHlcLHxZXfCEe/5X/PJd/creLn4bJxSCpgNClAxqfe2ljbIAwKpnNuAHX8GqcduDYTvm9SAohAf/63kNlRwy+/cX/GHQLEkBsXUaCvcyE2WjKHDOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axzq8xLbuJ3I4EjRnzz9dcT8d5kvizPM4eJbXWJ+buU=;
 b=RNUxx6VS3eM5HaU9h8IpENVR69YJTg9e6UPy0O7kn5bYXvpPM5BXKtGAwUjL/t7HajzCzkDJZi/H70B62lNJ6XCpAFlT+dJgYC+mJc8LTdYzWk1tw5aXAfSDeJDs83/DkypQMT7+MuL929Bo5ttzJEyuLzUD6OBzbrQz0z+/dcE=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MW4PR11MB5800.namprd11.prod.outlook.com (2603:10b6:303:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 04:46:35 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5c17:f27f:fd3:430c]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5c17:f27f:fd3:430c%5]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 04:46:35 +0000
From:   <Divya.Koppera@microchip.com>
To:     <Divya.Koppera@microchip.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>
Subject: RE: [patch v2 net-next] net: phy: micrel: PEROUT support in lan8814
Thread-Topic: [patch v2 net-next] net: phy: micrel: PEROUT support in lan8814
Thread-Index: AQHYycZv7yw2t2efAUuY4Fx+L/Bn5a3xMimA
Date:   Mon, 26 Sep 2022 04:46:35 +0000
Message-ID: <CO1PR11MB47713D1140834D937435A6CBE2529@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220916121809.16924-1-Divya.Koppera@microchip.com>
In-Reply-To: <20220916121809.16924-1-Divya.Koppera@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4771:EE_|MW4PR11MB5800:EE_
x-ms-office365-filtering-correlation-id: 43944111-7be9-4499-3b6e-08da9f7a177e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2qmUB+UBmvBtBU3Xudr5cuxClYLQ2QLKfiKYRxTdkueT3tJoOuoaU36ihPYp6NNmFWmjWiD9BGP1+nGIOBP7gQhlK4oNk3WOOUFo872rsu6UdF52dLvDa6L5JAo/ys96dZk9lVa+Bc/SoX9t93rYbpnqiLz36uAkLoGJ+4vc/CvksEuMcu/aZdx1xUNO3XabLJqQpF45hWanSaSuGBn8UGDHwyrY4iR0+K1hGf61OyvBrdIrxi+BFcucJIj3fCdFfkRoPWDmw8bCKMAcfd50FkM/U72qKikUYiwBcaZ0Qg7qSKpaehqBxd68gYHkcuWBGTjd0D8ObMU62aDZtSOiCK/onDeJqJJkC1N0HPl5brqgymNMZZQwlUNTGmxhhkdo5eY48Vqf+qn9hqRIelPkZfZxEGHg3TcFKQQjviC0R2D5AtVc8RmKX+Sfcy7nQxuAbBJkpkEWp2YdHJ4L6ai53Wk3Upyx6c+woW1wey1GlHtzCKRXtZt1p4ZOVSIFjjrjjUwd8l/ugHHPr6XfEUBhdNVP3c/s4sde6mlnQxMPj7HOHwOLHqSs8RrKUN45sRoIAhpfqDbDThMmsJa8D6UCkM7JWRkLYhRNDL/FFeyJ31HA/7FVp/OTcnFLupbo7LdY3/VpY6jevmtKgujjtony3fsxjvbf2w6zenlwpmUaCZjn+Y6qcuANgqtbc0Gubo3cw4oEZtGqth9OUVAXEwghSSr/SJS6aU1u7iSzwjkdwckC9qfOB22GRN826BTn0auNaml5S23jnL1QeosXs3dnb+r7682SZugQJn1+KTmONXg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199015)(2906002)(66574015)(33656002)(186003)(83380400001)(921005)(38070700005)(122000001)(38100700002)(55016003)(86362001)(76116006)(66556008)(66476007)(66446008)(64756008)(66946007)(8676002)(316002)(478600001)(110136005)(4326008)(8936002)(53546011)(6506007)(7696005)(30864003)(52536014)(26005)(9686003)(7416002)(71200400001)(5660300002)(107886003)(41300700001)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jhtzqGxvOJRke501zaEpR6C+BGr/91XdolHxIV5fEjMOOsUk54u61wsF38nz?=
 =?us-ascii?Q?cZMmVDTmFL82qxW7nU6k7ILSe+hgf9fvxwSXo9AVMJAnMJsmak5Rvz3eFaED?=
 =?us-ascii?Q?UWOHOeySO6J0GlhkPABeG/+486B+K2W8PbfhMvyEEsa/l/eze/skdePEj3Se?=
 =?us-ascii?Q?4Hkz4kbtKdScWBnArt7Xa7d2Lb4jK/fBFC4am1JvBG/xwY/X4DJJPPRUFFWf?=
 =?us-ascii?Q?XJQWd18w8BzuAZMP4FCwGkZhYUGIde+s9bhjwxAeZkALleCaiaUOwUgXC/Ij?=
 =?us-ascii?Q?oTl2A1r5EB+z8GED8XyhygpzInJO/5Lq6Mi17xmkZuhViIn4CSoaTQCznOmU?=
 =?us-ascii?Q?i5riY0P+mKFK1V1KGGTyMNPaZ+93KFg30SVKK9t1ifpBitL7+bUh4fvmoHrm?=
 =?us-ascii?Q?rAGkZS7rSKsyE4Crdq02xRqkLW6ebGQtyBRDsw2ZqvUd6eT01F+acrqjUIHS?=
 =?us-ascii?Q?ZRYLQUWDOgi97aBToUZ1zePKnVsY9L+95g0OXCEUFlSykP8EIhYyUTQS23Jt?=
 =?us-ascii?Q?08X00h6gam+x5wG9n58v03P/gn3NoXXfJ02OKeIjWkTurKukRUkIwllgr3q/?=
 =?us-ascii?Q?FmEZbXu45mqhMu1ctedJfwIS+c35G8qqLKrGfQHSm8wllmDu1K/W5NH+jcYX?=
 =?us-ascii?Q?Xu/qdDeBR0C61pH00293aBvfqZMQqkgmnSX6PPkzMk8/HOqLCDnpGpHtaTu8?=
 =?us-ascii?Q?nREgiMsyTi3a0rUoGzhouhWdFJKZYRRozp2Mx5nZT4myDc6PvCxV44xvmdxE?=
 =?us-ascii?Q?5uHQGuildhqzRdDPP6uoIKX3r6fFnhISXNcd2NQ3pOueAmVPVOQl8aBLEB7e?=
 =?us-ascii?Q?EQZIl2nRX0DKKkAz0Z/1U7pg4ZkGuN5iG2gEqohi5XPny+/n7NgKmUq2fjhn?=
 =?us-ascii?Q?uaH+tzYykqJOvKfvXmkhNEiC7VTpVWb9dzxDwY6dxufVcjezGrzkynw6O0vA?=
 =?us-ascii?Q?RV+/nts8KfyDdngyqEMcBWTgwrWIpTou2tm0m+SxUZ7cfy6naH/ePs7Znvau?=
 =?us-ascii?Q?ecAWlKiZQRhIVMvbCxUoyUokSFS8jufUGUxoj5bccHM1ooHYVloppf8WmquY?=
 =?us-ascii?Q?Zb8OatUhfMpJg220h8gTHg/K/GVGNq4M3NJzBanpS2MUU6K8IpuXhtTsV+L7?=
 =?us-ascii?Q?OistOR5hvT96tFuAyZP/vA8lxAKqbJzV966pqqkRMOq88ZWknGr4LWDMugTZ?=
 =?us-ascii?Q?2pGJfNrahB7KDEj4Iku+bdivlrxTDMIPtGLhE0ynx7tIdtGkdT/8+dFMTBAe?=
 =?us-ascii?Q?j4ndbUHlVQ7MHns2aHGaDzLdDLMraflMT96NUGiChURpJ44ZKg5gGQF/L1de?=
 =?us-ascii?Q?kP7uIIXyOVRs420F6Jg0v9eZXtcjbvqyp7cM7BmRWnVQO/P12Jl3kxWXI+Nl?=
 =?us-ascii?Q?QhUGi5bHw+O6Pck1866GLdTbzeXQS6jRVPXj3TcwLrkCVDP7xHtfjZjvBRoz?=
 =?us-ascii?Q?X5+AF9ieOy2bxFxCtBpBsShSNjaDGjm+crMxA66Y8u5AnkLOk3KQOMmSGlVL?=
 =?us-ascii?Q?IR54ebVuwwVn2xEbKSKyfuB6U9PKtrUqWE7yyPn9h777PMWqnkdk7w/JYIhy?=
 =?us-ascii?Q?kwb2De6gBJnYDC1LDhSSH4RJ6d7pua4t3lIvoWee1LwzzRRETLZJl9JeWHKu?=
 =?us-ascii?Q?iQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43944111-7be9-4499-3b6e-08da9f7a177e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 04:46:35.4696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5nGMIvC/26MaPQitXVczsP6fFwULsdO2iNYvT9atPNc4g7sGYhkHvjLfHEOa2OYCkeY2kNF7+Uc2OuLWizTk00Tdabf6Ji2eqE8HshZHS1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5800
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Divya Koppera <Divya.Koppera@microchip.com>
> Sent: Friday, September 16, 2022 5:48 PM
> To: andrew@lunn.ch; hkallweit1@gmail.com; linux@armlinux.org.uk;
> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; richardcochran@gmail.com
> Cc: UNGLinuxDriver <UNGLinuxDriver@microchip.com>
> Subject: [patch v2 net-next] net: phy: micrel: PEROUT support in lan8814
>=20
> Support Periodic output from lan8814 gpio
>=20
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> ---
> v1 -> v2
> - Adding PTP maintainer
> - Given line space between Macro and function.
> ---
>  drivers/net/phy/micrel.c | 408
> ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 384 insertions(+), 24 deletions(-)
>=20

Gentle ping.

> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c index
> 7b8c5c8d013e..91e5bf04f652 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -243,6 +243,50 @@
>  #define PS_TO_REG				200
>  #define FIFO_SIZE				8
>=20
> +#define LAN8814_GPIO_EN1			0x20
> +#define LAN8814_GPIO_EN2			0x21
> +#define LAN8814_GPIO_DIR1			0x22
> +#define LAN8814_GPIO_DIR2			0x23
> +#define LAN8814_GPIO_BUF1			0x24
> +#define LAN8814_GPIO_BUF2			0x25
> +
> +#define LAN8814_GPIO_EN_ADDR(pin)	((pin) > 15 ?
> LAN8814_GPIO_EN1 : LAN8814_GPIO_EN2)
> +#define LAN8814_GPIO_EN_BIT_(pin)	BIT(pin)
> +#define LAN8814_GPIO_DIR_ADDR(pin)	((pin) > 15 ?
> LAN8814_GPIO_DIR1 : LAN8814_GPIO_DIR2)
> +#define LAN8814_GPIO_DIR_BIT_(pin)	BIT(pin)
> +#define LAN8814_GPIO_BUF_ADDR(pin)	((pin) > 15 ?
> LAN8814_GPIO_BUF1 : LAN8814_GPIO_BUF2)
> +#define LAN8814_GPIO_BUF_BIT_(pin)	BIT(pin)
> +
> +#define LAN8814_N_GPIO				24
> +
> +/* The number of periodic outputs is limited by number of
> + * PTP clock event channels
> + */
> +#define LAN8814_PTP_N_PEROUT			2
> +
> +/* LAN8814_TARGET_BUFF: Seconds difference between LTC and target
> register.
> + * Should be more than 1 sec.
> + */
> +#define LAN8814_TARGET_BUFF			3
> +
> +#define LAN8814_PTP_GENERAL_CONFIG			0x0201
> +#define LAN8814_PTP_GENERAL_CONFIG_LTC_EVENT_X_MASK_(channel)
> \
> +				((channel) ? GENMASK(11, 8) : GENMASK(7,
> 4))
> +
> +#define LAN8814_PTP_GENERAL_CONFIG_LTC_EVENT_X_SET_(channel,
> value) \
> +				(((value) & 0xF) << (4 + ((channel) << 2)))
> +#define LAN8814_PTP_GENERAL_CONFIG_RELOAD_ADD_X_(channel)
> 	((channel) ? BIT(2) : BIT(0))
> +#define LAN8814_PTP_GENERAL_CONFIG_POLARITY_X_(channel)
> 	((channel) ? BIT(3) : BIT(1))
> +
> +#define LAN8814_PTP_CLOCK_TARGET_SEC_HI_X(channel)
> 	((channel) ? 0x21F : 0x215)
> +#define LAN8814_PTP_CLOCK_TARGET_SEC_LO_X(channel)
> 	((channel) ? 0x220 : 0x216)
> +#define LAN8814_PTP_CLOCK_TARGET_NS_HI_X(channel)
> 	((channel) ? 0x221 : 0x217)
> +#define LAN8814_PTP_CLOCK_TARGET_NS_LO_X(channel)
> 	((channel) ? 0x222 : 0x218)
> +#define LAN8814_PTP_CLOCK_TARGET_RELOAD_SEC_HI_X(channel)
> 	((channel) ? 0x223 : 0x219)
> +#define LAN8814_PTP_CLOCK_TARGET_RELOAD_SEC_LO_X(channel)
> 	((channel) ? 0x224 : 0x21A)
> +#define LAN8814_PTP_CLOCK_TARGET_RELOAD_NS_HI_X(channel)
> 	((channel) ? 0x225 : 0x21B)
> +#define LAN8814_PTP_CLOCK_TARGET_RELOAD_NS_LO_X(channel)
> 	((channel) ? 0x226 : 0x21C)
> +
>  struct kszphy_hw_stat {
>  	const char *string;
>  	u8 reg;
> @@ -267,13 +311,10 @@ struct lan8814_shared_priv {
>  	struct phy_device *phydev;
>  	struct ptp_clock *ptp_clock;
>  	struct ptp_clock_info ptp_clock_info;
> +	struct ptp_pin_desc *pin_config;
> +	s8 gpio_pin;
>=20
> -	/* Reference counter to how many ports in the package are enabling
> the
> -	 * timestamping
> -	 */
> -	u8 ref;
> -
> -	/* Lock for ptp_clock and ref */
> +	/* Lock for ptp_clock and gpio_pin */
>  	struct mutex shared_lock;
>  };
>=20
> @@ -2091,8 +2132,6 @@ static int lan8814_hwtstamp(struct
> mii_timestamper *mii_ts, struct ifreq *ifr)  {
>  	struct kszphy_ptp_priv *ptp_priv =3D
>  			  container_of(mii_ts, struct kszphy_ptp_priv,
> mii_ts);
> -	struct phy_device *phydev =3D ptp_priv->phydev;
> -	struct lan8814_shared_priv *shared =3D phydev->shared->priv;
>  	struct lan8814_ptp_rx_ts *rx_ts, *tmp;
>  	struct hwtstamp_config config;
>  	int txcfg =3D 0, rxcfg =3D 0;
> @@ -2155,20 +2194,6 @@ static int lan8814_hwtstamp(struct
> mii_timestamper *mii_ts, struct ifreq *ifr)
>  	else
>  		lan8814_config_ts_intr(ptp_priv->phydev, false);
>=20
> -	mutex_lock(&shared->shared_lock);
> -	if (config.rx_filter !=3D HWTSTAMP_FILTER_NONE)
> -		shared->ref++;
> -	else
> -		shared->ref--;
> -
> -	if (shared->ref)
> -		lanphy_write_page_reg(ptp_priv->phydev, 4,
> PTP_CMD_CTL,
> -				      PTP_CMD_CTL_PTP_ENABLE_);
> -	else
> -		lanphy_write_page_reg(ptp_priv->phydev, 4,
> PTP_CMD_CTL,
> -				      PTP_CMD_CTL_PTP_DISABLE_);
> -	mutex_unlock(&shared->shared_lock);
> -
>  	/* In case of multiple starts and stops, these needs to be cleared */
>  	list_for_each_entry_safe(rx_ts, tmp, &ptp_priv->rx_ts_list, list) {
>  		list_del(&rx_ts->list);
> @@ -2325,6 +2350,293 @@ static int lan8814_ptpci_gettime64(struct
> ptp_clock_info *ptpci,
>  	return 0;
>  }
>=20
> +static void lan8814_gpio_release(struct lan8814_shared_priv *shared, s8
> +gpio_pin) {
> +	struct phy_device *phydev =3D shared->phydev;
> +	int val;
> +
> +	/* Disable gpio alternate function, 1: select as gpio, 0: select alt fu=
nc
> */
> +	val =3D lanphy_read_page_reg(phydev, 4,
> LAN8814_GPIO_EN_ADDR(gpio_pin));
> +	val |=3D LAN8814_GPIO_EN_BIT_(gpio_pin);
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_GPIO_EN_ADDR(gpio_pin), val);
> +
> +	val =3D lanphy_read_page_reg(phydev, 4,
> LAN8814_GPIO_DIR_ADDR(gpio_pin));
> +	val &=3D ~LAN8814_GPIO_DIR_BIT_(gpio_pin);
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_GPIO_DIR_ADDR(gpio_pin),
> +val);
> +
> +	val =3D lanphy_read_page_reg(phydev, 4,
> LAN8814_GPIO_BUF_ADDR(gpio_pin));
> +	val &=3D ~LAN8814_GPIO_BUF_BIT_(gpio_pin);
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_GPIO_BUF_ADDR(gpio_pin),
> +val); }
> +
> +static void lan8814_gpio_init(struct lan8814_shared_priv *shared) {
> +	struct phy_device *phydev =3D shared->phydev;
> +
> +	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_DIR1, 0);
> +	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_DIR2, 0);
> +	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_EN1, 0);
> +
> +	/* By default disabling alternate function to GPIO 0 and 1
> +	 * i.e., 1: select as gpio, 0: select alt func
> +	 */
> +	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_EN2, 0x3);
> +	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_BUF1, 0);
> +	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_BUF2, 0); }
> +
> +static void lan8814_gpio_config_ptp_out(struct lan8814_shared_priv
> *shared,
> +					s8 gpio_pin)
> +{
> +	struct phy_device *phydev =3D shared->phydev;
> +	int val;
> +
> +	/* Set as gpio output */
> +	val =3D lanphy_read_page_reg(phydev, 4,
> LAN8814_GPIO_DIR_ADDR(gpio_pin));
> +	val |=3D LAN8814_GPIO_DIR_BIT_(gpio_pin);
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_GPIO_DIR_ADDR(gpio_pin),
> +val);
> +
> +	/* Enable gpio 0:for alternate function, 1:gpio */
> +	val =3D lanphy_read_page_reg(phydev, 4,
> LAN8814_GPIO_EN_ADDR(gpio_pin));
> +	val &=3D ~LAN8814_GPIO_EN_BIT_(gpio_pin);
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_GPIO_EN_ADDR(gpio_pin), val);
> +
> +	/* Set buffer type to push pull */
> +	val =3D lanphy_read_page_reg(phydev, 4,
> LAN8814_GPIO_BUF_ADDR(gpio_pin));
> +	val |=3D LAN8814_GPIO_BUF_BIT_(gpio_pin);
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_GPIO_BUF_ADDR(gpio_pin),
> +val); }
> +
> +static void lan8814_set_clock_target(struct phy_device *phydev, s8
> gpio_pin,
> +				     s64 start_sec, u32 start_nsec) {
> +	if (gpio_pin < 0)
> +		return;
> +
> +	/* Set the start time */
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_PTP_CLOCK_TARGET_SEC_LO_X(gpio_pin),
> +			      lower_16_bits(start_sec));
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_PTP_CLOCK_TARGET_SEC_HI_X(gpio_pin),
> +			      upper_16_bits(start_sec));
> +
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_PTP_CLOCK_TARGET_NS_LO_X(gpio_pin),
> +			      lower_16_bits(start_nsec));
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_PTP_CLOCK_TARGET_NS_HI_X(gpio_pin),
> +			      upper_16_bits(start_nsec) & 0x3fff); }
> +
> +static void lan8814_set_clock_reload(struct phy_device *phydev, s8
> gpio_pin,
> +				     s64 period_sec, u32 period_nsec) {
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_PTP_CLOCK_TARGET_RELOAD_SEC_LO_X(gpio_pin),
> +			      lower_16_bits(period_sec));
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_PTP_CLOCK_TARGET_RELOAD_SEC_HI_X(gpio_pin),
> +			      upper_16_bits(period_sec));
> +
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_PTP_CLOCK_TARGET_RELOAD_NS_LO_X(gpio_pin),
> +			      lower_16_bits(period_nsec));
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_PTP_CLOCK_TARGET_RELOAD_NS_HI_X(gpio_pin),
> +			      upper_16_bits(period_nsec) & 0x3fff); }
> +
> +static void lan8814_general_event_config(struct phy_device *phydev, s8
> +gpio_pin, int pulse_width) {
> +	u16 general_config;
> +
> +	general_config =3D lanphy_read_page_reg(phydev, 4,
> LAN8814_PTP_GENERAL_CONFIG);
> +	general_config &=3D
> ~(LAN8814_PTP_GENERAL_CONFIG_LTC_EVENT_X_MASK_(gpio_pin));
> +	general_config |=3D
> LAN8814_PTP_GENERAL_CONFIG_LTC_EVENT_X_SET_(gpio_pin,
> +
> pulse_width);
> +	general_config &=3D
> ~(LAN8814_PTP_GENERAL_CONFIG_RELOAD_ADD_X_(gpio_pin));
> +	general_config |=3D
> LAN8814_PTP_GENERAL_CONFIG_POLARITY_X_(gpio_pin);
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_PTP_GENERAL_CONFIG,
> +general_config); }
> +
> +static void lan8814_ptp_perout_off(struct lan8814_shared_priv *shared,
> +				   s8 gpio_pin)
> +{
> +	struct phy_device *phydev =3D shared->phydev;
> +	u16 general_config;
> +
> +	/* Set target to too far in the future, effectively disabling it */
> +	lan8814_set_clock_target(phydev, gpio_pin, 0xFFFFFFFF, 0);
> +
> +	general_config =3D lanphy_read_page_reg(phydev, 4,
> LAN8814_PTP_GENERAL_CONFIG);
> +	general_config |=3D
> LAN8814_PTP_GENERAL_CONFIG_RELOAD_ADD_X_(gpio_pin);
> +	lanphy_write_page_reg(phydev, 4,
> LAN8814_PTP_GENERAL_CONFIG,
> +general_config);
> +
> +	lan8814_gpio_release(shared, gpio_pin); }
> +
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_200MS_	13
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100MS_	12
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_50MS_	11
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_10MS_	10
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_5MS_	9
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_1MS_	8
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_500US_	7
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100US_	6
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_50US_	5
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_10US_	4
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_5US_	3
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_1US_	2
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_500NS_	1
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100NS_	0
> +
> +static int lan88xx_get_pulsewidth(struct phy_device *phydev,
> +				  struct ptp_perout_request
> *perout_request,
> +				  int *pulse_width)
> +{
> +	struct timespec64 ts_period;
> +	s64 ts_on_nsec, period_nsec;
> +	struct timespec64 ts_on;
> +
> +	ts_period.tv_sec =3D perout_request->period.sec;
> +	ts_period.tv_nsec =3D perout_request->period.nsec;
> +
> +	ts_on.tv_sec =3D perout_request->on.sec;
> +	ts_on.tv_nsec =3D perout_request->on.nsec;
> +	ts_on_nsec =3D timespec64_to_ns(&ts_on);
> +	period_nsec =3D timespec64_to_ns(&ts_period);
> +
> +	if (period_nsec < 200) {
> +		phydev_warn(phydev, "perout period too small, minimum is
> 200ns\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (ts_on_nsec >=3D period_nsec) {
> +		phydev_warn(phydev, "pulse width must be smaller than
> period\n");
> +		return -EINVAL;
> +	}
> +
> +	switch (ts_on_nsec) {
> +	case 200000000:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_200MS_;
> +		break;
> +	case 100000000:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100MS_;
> +		break;
> +	case 50000000:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_50MS_;
> +		break;
> +	case 10000000:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_10MS_;
> +		break;
> +	case 5000000:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_5MS_;
> +		break;
> +	case 1000000:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_1MS_;
> +		break;
> +	case 500000:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_500US_;
> +		break;
> +	case 100000:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100US_;
> +		break;
> +	case 50000:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_50US_;
> +		break;
> +	case 10000:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_10US_;
> +		break;
> +	case 5000:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_5US_;
> +		break;
> +	case 1000:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_1US_;
> +		break;
> +	case 500:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_500NS_;
> +		break;
> +	case 100:
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100NS_;
> +		break;
> +	default:
> +		phydev_warn(phydev, "Using default pulse width of
> 100ns\n");
> +		*pulse_width =3D
> LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100NS_;
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int lan8814_ptp_perout(struct lan8814_shared_priv *shared, int on=
,
> +			      struct ptp_perout_request *perout_request) {
> +	unsigned int perout_ch =3D perout_request->index;
> +	struct phy_device *phydev =3D shared->phydev;
> +	int pulse_width;
> +	int ret;
> +
> +	/* Reject requests with unsupported flags */
> +	if (perout_request->flags & ~PTP_PEROUT_DUTY_CYCLE)
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&shared->shared_lock);
> +	shared->gpio_pin =3D ptp_find_pin(shared->ptp_clock,
> PTP_PF_PEROUT,
> +					perout_ch);
> +	if (shared->gpio_pin < 0) {
> +		mutex_unlock(&shared->shared_lock);
> +		return -EBUSY;
> +	}
> +
> +	if (!on) {
> +		lan8814_ptp_perout_off(shared, shared->gpio_pin);
> +		shared->gpio_pin =3D -1;
> +		mutex_unlock(&shared->shared_lock);
> +		return 0;
> +	}
> +
> +	ret =3D lan88xx_get_pulsewidth(phydev, perout_request,
> &pulse_width);
> +	if (ret < 0) {
> +		shared->gpio_pin =3D -1;
> +		mutex_unlock(&shared->shared_lock);
> +		return ret;
> +	}
> +
> +	/* Configure to pulse every period */
> +	lan8814_general_event_config(phydev, shared->gpio_pin,
> pulse_width);
> +	lan8814_set_clock_target(phydev, shared->gpio_pin,
> perout_request->start.sec,
> +				 perout_request->start.nsec);
> +	lan8814_set_clock_reload(phydev, shared->gpio_pin,
> perout_request->period.sec,
> +				 perout_request->period.nsec);
> +	lan8814_gpio_config_ptp_out(shared, shared->gpio_pin);
> +	mutex_unlock(&shared->shared_lock);
> +
> +	return 0;
> +}
> +
> +static int lan8814_ptpci_verify(struct ptp_clock_info *ptp, unsigned int=
 pin,
> +				enum ptp_pin_function func, unsigned int
> chan) {
> +	if (chan !=3D 0 || (pin !=3D 0 && pin !=3D 1))
> +		return -1;
> +
> +	switch (func) {
> +	case PTP_PF_NONE:
> +	case PTP_PF_PEROUT:
> +		break;
> +	default:
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int lan8814_ptpci_enable(struct ptp_clock_info *ptpci,
> +				struct ptp_clock_request *request, int on) {
> +	struct lan8814_shared_priv *shared =3D container_of(ptpci, struct
> lan8814_shared_priv,
> +							  ptp_clock_info);
> +
> +	switch (request->type) {
> +	case PTP_CLK_REQ_PEROUT:
> +		return lan8814_ptp_perout(shared, on, &request->perout);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  static int lan8814_ptpci_settime64(struct ptp_clock_info *ptpci,
>  				   const struct timespec64 *ts)
>  {
> @@ -2333,6 +2645,8 @@ static int lan8814_ptpci_settime64(struct
> ptp_clock_info *ptpci,
>  	struct phy_device *phydev =3D shared->phydev;
>=20
>  	mutex_lock(&shared->shared_lock);
> +	lan8814_set_clock_target(phydev, shared->gpio_pin,
> +				 ts->tv_sec + LAN8814_TARGET_BUFF, 0);
>  	lan8814_ptp_clock_set(phydev, ts->tv_sec, ts->tv_nsec);
>  	mutex_unlock(&shared->shared_lock);
>=20
> @@ -2342,12 +2656,16 @@ static int lan8814_ptpci_settime64(struct
> ptp_clock_info *ptpci,  static void lan8814_ptp_clock_step(struct phy_dev=
ice
> *phydev,
>  				   s64 time_step_ns)
>  {
> +	struct lan8814_shared_priv *shared =3D phydev->shared->priv;
> +	int gpio_pin =3D shared->gpio_pin;
>  	u32 nano_seconds_step;
>  	u64 abs_time_step_ns;
>  	u32 unsigned_seconds;
>  	u32 nano_seconds;
>  	u32 remainder;
>  	s32 seconds;
> +	u32 tar_sec;
> +	u32 nsec;
>=20
>  	if (time_step_ns >  15000000000LL) {
>  		/* convert to clock set */
> @@ -2359,6 +2677,8 @@ static void lan8814_ptp_clock_step(struct
> phy_device *phydev,
>  			unsigned_seconds++;
>  			nano_seconds -=3D 1000000000;
>  		}
> +		lan8814_set_clock_target(phydev, gpio_pin,
> +					 unsigned_seconds +
> LAN8814_TARGET_BUFF, 0);
>  		lan8814_ptp_clock_set(phydev, unsigned_seconds,
> nano_seconds);
>  		return;
>  	} else if (time_step_ns < -15000000000LL) { @@ -2374,6 +2694,8 @@
> static void lan8814_ptp_clock_step(struct phy_device *phydev,
>  			nano_seconds +=3D 1000000000;
>  		}
>  		nano_seconds -=3D nano_seconds_step;
> +		lan8814_set_clock_target(phydev, gpio_pin,
> +					 unsigned_seconds +
> LAN8814_TARGET_BUFF, 0);
>  		lan8814_ptp_clock_set(phydev, unsigned_seconds,
>  				      nano_seconds);
>  		return;
> @@ -2428,6 +2750,11 @@ static void lan8814_ptp_clock_step(struct
> phy_device *phydev,
>  					      PTP_LTC_STEP_ADJ_DIR_ |
>  					      adjustment_value_hi);
>  			seconds -=3D ((s32)adjustment_value);
> +
> +			lan8814_ptp_clock_get(phydev,
> &unsigned_seconds, &nsec);
> +			tar_sec =3D unsigned_seconds - adjustment_value;
> +			lan8814_set_clock_target(phydev, gpio_pin,
> +						 tar_sec +
> LAN8814_TARGET_BUFF, 0);
>  		} else {
>  			u32 adjustment_value =3D (u32)(-seconds);
>  			u16 adjustment_value_lo, adjustment_value_hi;
> @@ -2443,6 +2770,11 @@ static void lan8814_ptp_clock_step(struct
> phy_device *phydev,
>  			lanphy_write_page_reg(phydev, 4,
> PTP_LTC_STEP_ADJ_HI,
>  					      adjustment_value_hi);
>  			seconds +=3D ((s32)adjustment_value);
> +
> +			lan8814_ptp_clock_get(phydev,
> &unsigned_seconds, &nsec);
> +			tar_sec =3D unsigned_seconds + adjustment_value;
> +			lan8814_set_clock_target(phydev, gpio_pin,
> +						 tar_sec +
> LAN8814_TARGET_BUFF, 0);
>  		}
>  		lanphy_write_page_reg(phydev, 4, PTP_CMD_CTL,
>  				      PTP_CMD_CTL_PTP_LTC_STEP_SEC_);
> @@ -2783,11 +3115,16 @@ static void lan8814_ptp_init(struct phy_device
> *phydev)
>  	ptp_priv->mii_ts.ts_info  =3D lan8814_ts_info;
>=20
>  	phydev->mii_ts =3D &ptp_priv->mii_ts;
> +
> +	/* Enable ptp to run LTC clock for ptp and gpio 1PPS operation */
> +	lanphy_write_page_reg(ptp_priv->phydev, 4, PTP_CMD_CTL,
> +			      PTP_CMD_CTL_PTP_ENABLE_);
>  }
>=20
>  static int lan8814_ptp_probe_once(struct phy_device *phydev)  {
>  	struct lan8814_shared_priv *shared =3D phydev->shared->priv;
> +	int i;
>=20
>  	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
>  	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> @@ -2796,19 +3133,41 @@ static int lan8814_ptp_probe_once(struct
> phy_device *phydev)
>  	/* Initialise shared lock for clock*/
>  	mutex_init(&shared->shared_lock);
>=20
> +	shared->pin_config =3D devm_kmalloc_array(&phydev->mdio.dev,
> +						LAN8814_N_GPIO,
> +						sizeof(*shared->pin_config),
> +						GFP_KERNEL);
> +	if (!shared->pin_config)
> +		return -ENOMEM;
> +
> +	for (i =3D 0; i < LAN8814_N_GPIO; i++) {
> +		struct ptp_pin_desc *ptp_pin =3D &shared->pin_config[i];
> +
> +		memset(ptp_pin, 0, sizeof(*ptp_pin));
> +		snprintf(ptp_pin->name,
> +			 sizeof(ptp_pin->name), "lan8814_ptp_pin_%02d", i);
> +		ptp_pin->index =3D i;
> +		ptp_pin->func =3D  PTP_PF_NONE;
> +	}
> +
> +	shared->gpio_pin =3D -1;
> +
>  	shared->ptp_clock_info.owner =3D THIS_MODULE;
>  	snprintf(shared->ptp_clock_info.name, 30, "%s", phydev->drv-
> >name);
>  	shared->ptp_clock_info.max_adj =3D 31249999;
>  	shared->ptp_clock_info.n_alarm =3D 0;
>  	shared->ptp_clock_info.n_ext_ts =3D 0;
> -	shared->ptp_clock_info.n_pins =3D 0;
> +	shared->ptp_clock_info.n_pins =3D LAN8814_N_GPIO;
>  	shared->ptp_clock_info.pps =3D 0;
> -	shared->ptp_clock_info.pin_config =3D NULL;
> +	shared->ptp_clock_info.pin_config =3D shared->pin_config;
> +	shared->ptp_clock_info.n_per_out =3D LAN8814_PTP_N_PEROUT;
>  	shared->ptp_clock_info.adjfine =3D lan8814_ptpci_adjfine;
>  	shared->ptp_clock_info.adjtime =3D lan8814_ptpci_adjtime;
>  	shared->ptp_clock_info.gettime64 =3D lan8814_ptpci_gettime64;
>  	shared->ptp_clock_info.settime64 =3D lan8814_ptpci_settime64;
>  	shared->ptp_clock_info.getcrosststamp =3D NULL;
> +	shared->ptp_clock_info.enable =3D lan8814_ptpci_enable;
> +	shared->ptp_clock_info.verify =3D lan8814_ptpci_verify;
>=20
>  	shared->ptp_clock =3D ptp_clock_register(&shared->ptp_clock_info,
>  					       &phydev->mdio.dev);
> @@ -2829,6 +3188,7 @@ static int lan8814_ptp_probe_once(struct
> phy_device *phydev)
>  	lanphy_write_page_reg(phydev, 4, PTP_OPERATING_MODE,
>  			      PTP_OPERATING_MODE_STANDALONE_);
>=20
> +	lan8814_gpio_init(shared);
>  	return 0;
>  }
>=20
> --
> 2.17.1

