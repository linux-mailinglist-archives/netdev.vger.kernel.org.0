Return-Path: <netdev+bounces-7265-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7BF471F673
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 01:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5577E1C21157
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7801247017;
	Thu,  1 Jun 2023 23:17:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D2010FA
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 23:17:23 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2069.outbound.protection.outlook.com [40.107.95.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6E713E;
	Thu,  1 Jun 2023 16:17:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8ZH4j2IM/4qhojMlDHWQsoe8ry8SukonICTfkJgcwlp8qLnGNfftumJZq7Uv33u332hSU+LhQzhlzTAlbaJXYvCLHoxhX7P5uHx/toWxbshUv2Z0mbQnjZaSDnxT2VGtrm/tiRWClFYcC+taY6/lKja+HfrnSRxxO9ijOfMNBZbryC1x821ve6zHq++np8IttVAe0TbgwoDhYS7x5gxiqF9jMxZtAnip7+6EhPAV2L5fWd2VxDEE2nwpyXGFwPB/AIiK/XCQ8rbWsTPzVgGOzm1vxN6pAj7hkEEGnHZcmBPUVZCSeYo7+iIYzGvM806aLv78/CBECxpGSTO7H0ZIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xzxHYDJcZ/mGZRQHG+BQM/P4ANcEJCGAaaWwMljplAg=;
 b=DbnWIJTPfB2kLGsEPt0JMCBT47N8S8XrmtpU3WuAMZ0TMO7QwtdS8/77KZc1Uox/9bO006E2gULWmqJEGsVgFkKnmTW1470oKaigd1rwnyNkBXky+Jqc92Y5TE1J9BtiHQ3/bnXoeub5Qord8thCqzNi8kUA6UR/BQxGVmnFVHksAA/7NtKyjSu2t01SieiIJIBBmLM2xNxt1+/qJMLgq57EkUVCH9wZ9L43kj7iJZR8dvs4AvAiODeyiKRXQV9Q8yyf9zG+wMihXuhSJ9LOeXEYYGMPyl/OYIpZH7zFSvlQqso7VKklrDQligFF1R1xkTIWYNIDteg2tZ8DBRcBzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ooma.com; dmarc=pass action=none header.from=ooma.com;
 dkim=pass header.d=ooma.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ooma.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzxHYDJcZ/mGZRQHG+BQM/P4ANcEJCGAaaWwMljplAg=;
 b=FlPlgmGl/K1+wkMcmbKx/DQxknT5O2yiTkoDrJKXAO2mxbneliIF39K25ZD+pPAidO96T5MEVBLPOqB2Vt+O4xRFlBQnPV+RdL+iPW7JTezfS/eAJLViic54Tg5Osp8FC8BACqbij9GbrJwJUXMoXBTL1UhQqMG/JbYLb037+mc=
Received: from BYAPR14MB2918.namprd14.prod.outlook.com (2603:10b6:a03:153::10)
 by MN6PR14MB7169.namprd14.prod.outlook.com (2603:10b6:208:474::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 1 Jun
 2023 23:17:17 +0000
Received: from BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64]) by BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64%3]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 23:17:17 +0000
From: Michal Smulski <michal.smulski@ooma.com>
To: Russell King <linux@armlinux.org.uk>, "msmulski2@gmail.com"
	<msmulski2@gmail.com>
CC: "andrew@lunn.ch" <andrew@lunn.ch>, "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>, "olteanv@gmail.com" <olteanv@gmail.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "kabel@kernel.org" <kabel@kernel.org>
Subject: RE: [PATCH net-next v5 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Thread-Topic: [PATCH net-next v5 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Thread-Index: AQHZlNN1eDQSqEvxBUmqiQPij08lWa92iyAAgAAJFUA=
Date: Thu, 1 Jun 2023 23:17:17 +0000
Message-ID:
 <BYAPR14MB2918FA8456C076C05B054E0CE349A@BYAPR14MB2918.namprd14.prod.outlook.com>
References: <20230601215251.3529-1-msmulski2@gmail.com>
 <20230601215251.3529-2-msmulski2@gmail.com>
 <ZHke6JqvcWZsOdX5@shell.armlinux.org.uk>
In-Reply-To: <ZHke6JqvcWZsOdX5@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ooma.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR14MB2918:EE_|MN6PR14MB7169:EE_
x-ms-office365-filtering-correlation-id: 560ed436-38c7-4f0a-d96b-08db62f65782
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 KvnE+vcKbwJcTy9lioeOAwD+DuSnCWD2+quXagDFOlZ5UnpOx54Zd9TZzaJLanc5DF52gD3ds8tFqBFhH19WUA+kG45Q97d40lw8rq+3go/63Ce3njLfIP0kePGq/o3uKplSB8DAb6NLX1IJZrOKQYekia7dtpDIZ4Ek+C4DNTvVe/GurKPGUNPDb/CMXrmhv1s9Kkm9LviL9lPoQCILRBFvy+1kHNPD2DBw9FJ0VeABfOnTANq5gwM4TX7pxSeRKiiB2OstXopArueMUxZXxb03wW4tSuPFju1T4+1BuiWPBvoIx+vjCAhiIcR5nIfFp1dFAe1lrnMxiArv7fOnWv2GDRbXiD0QzyUYZgdW0h4/Q4hBarQrB9o+jXxdhavXtw+hTymEuffaDAolSlr/Ca83JJEJpd4shN/0SRneLL4NaFvlgC5X+LfZPo7xye7bXyO8C5OWwWSNHEZMpFcI5hvcK6KGn21coC0Ug+2zxVqpXXyJs9C7ITCh1N/A2jQ2AkDuZ3G/ep3zu+RRraBMyU3r+qoAh1KFhyp4c9cOsaWxfqbjTU25nCE2UH+PJk/uW4xL+T5ows1ojT7XTzd4pqkVnibXy0iWHzmWpPFae1Ttoy+RNZqKVO1zVUnL5jXlnpl/k4okBksDUxfUDq4qFg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR14MB2918.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(366004)(136003)(39850400004)(451199021)(54906003)(478600001)(110136005)(66946007)(5660300002)(8936002)(52536014)(4326008)(71200400001)(66476007)(66556008)(66446008)(76116006)(64756008)(8676002)(7696005)(316002)(41300700001)(966005)(122000001)(38100700002)(55016003)(7416002)(83380400001)(6506007)(53546011)(9686003)(26005)(86362001)(38070700005)(33656002)(44832011)(2906002)(186003)(138113003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zNtzfKvCtm3avk9sJXYcnRiAgpZLw276vsWiSD44PUhJ4sGKkn/OTRhWRJiD?=
 =?us-ascii?Q?o/4l/xIRY+VsNoq295ccQ4Op9Mn8bjvUjBV1E923rtoHSjKqHoxiwBDf6MnB?=
 =?us-ascii?Q?XUbqRCi4kFXEphsH+v6BHv8l710Z/jPPYc5OYwL0MGJat97mVEQxj0ltO1PA?=
 =?us-ascii?Q?UFb0PKC0JA7qfu3DRGEnXap9tMZbcr5Q2/JJWxzMypdEj5BXxcwJhhTjM/8V?=
 =?us-ascii?Q?eIJGnxWHi86gzFvMesjgX0K72cq6TlXb1VfyP3ZDnOFGj6YzhO64fstLqvZf?=
 =?us-ascii?Q?v+TKoszWjuS8eMXVAJt4v47uXd+GlVxhqQhI7sVOkONgnOAGOo3OKPajTZzF?=
 =?us-ascii?Q?RYby2w92jXc4nWJ+wXR/eFB2Z9SQsV3xwQHOHyxPD+E4fxjcIwYgohp619Y3?=
 =?us-ascii?Q?kblrZr7KZm5j8ccNOybmdArK0yKy7v0cp8gGChwoygWgEfMcHWILfDUiboUX?=
 =?us-ascii?Q?eomvxFlPAH/gUXMcUh5ztPDqPeJ2EcjJr7EMPnMdkl5l8PVGQlEuoBd0yyCv?=
 =?us-ascii?Q?5YJRAbYl2SAet2kxsT80vgh17vH+FI3s4hSMMQvC8cdDln7bB9rcVjDZK+0D?=
 =?us-ascii?Q?iRkaIGhWXMcKgQjaIfaJ8XAwfXaGoWsV2EDB3D/j1btedwBLCuoogIsdckdJ?=
 =?us-ascii?Q?4bxY2EH28KZqwbGf9l0wYb59krc4ZjOA8z+r7LE6bMVTXc66bZS84/Emy9Oe?=
 =?us-ascii?Q?+g6LqtuWKDKEtKFk6AeFrfrkAq8rCpI175XDyCsMdY4qpBfkTfsk4wnGfsaq?=
 =?us-ascii?Q?Z6B1v796gOYb7zA9kZlPQnrXpsDcH7WfcWej4C0KPYCwNzP/WT1HRksweZXw?=
 =?us-ascii?Q?bCE8SIx2Gg1hMq5fMcwQ7Pq20bxu4krNbWBPdHckLVeWB+KQK07O2YAc8KKE?=
 =?us-ascii?Q?HQ39KY36P/H2tdxH8j4JmybFQfBQWExyGpGM9WTkXIzD4QPcE0ohOZ2asrdb?=
 =?us-ascii?Q?2BS4vfEA6l8tHfyzfo5Q8YgIvlatAME3n0meaamTchP8dzIFWn0ALSxVXAaf?=
 =?us-ascii?Q?u+UrAcUAGPCmSqyjHGenrTjdUtMT5IpGbNBYqR/sNET2Vm+6sjPY6D++otl7?=
 =?us-ascii?Q?zwBOXm4qBZ2dlCmk8PzMT7Bt4iIOj9BkKl9ANQhG1Uk941kWBuQc4m/6j7Px?=
 =?us-ascii?Q?Ic4vbQ4YPDww5JUkZj1PWciyLt4OWeWmMZtARpsoZ3B14EWvix/BNH6vAiNn?=
 =?us-ascii?Q?FStOzSmTj22Jb73p3vDpDWNsB8JEKfF6jtS1dLtCR1FJ0zEowzM+MpRzhmxy?=
 =?us-ascii?Q?w8TBaR1I4m+DlgiJ9QGLNzb5g56M37SiamGW3oV3Nz9IUlAdlBEtASHALZ58?=
 =?us-ascii?Q?bDnYGg6s6Y73LpcKBQnwtc6NuxIrlPjEiU1xfmDn4L/kisdNXTIpPRyQeZvA?=
 =?us-ascii?Q?xFYrK12PtWyqYpPbUx5ZLjBEuq8oBBGXtHxpmPS+UniGmgUkN1Gr2wZc7ttX?=
 =?us-ascii?Q?8Qn+oZ7KvVPKQAyqDP0wx7S5jTSg958h8NaZPOj2H/Dk6QuIMbAnYgvmw3eO?=
 =?us-ascii?Q?o0YlJ5H5qYX/AYc4Jdiq/USyqxLU3YEXxXBgf2wpFsA4uIb6feCGGaVsIYeZ?=
 =?us-ascii?Q?2U2jI1EMZPU304yyfe3r4Ji/7lJVP9KT+FOZs39O?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ooma.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR14MB2918.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560ed436-38c7-4f0a-d96b-08db62f65782
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 23:17:17.2512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2d44ad66-e31e-435e-aaf4-fc407c81e93b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gZY1Qi1Dxvybit6pPRFiFfgyXDUDRqzId/2/zoCMxNNRcGl4w7y2ok2FDAf4o6e4h/pvz48SeicsDLSt0eLMiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR14MB7169
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I was not aware of phylink_decode_usxgmii_word(). I would be happy to re-do=
 this patch and remove #defines as per your comments.

Regards,
Michal


-----Original Message-----
From: Russell King <linux@armlinux.org.uk>=20
Sent: Thursday, June 1, 2023 3:43 PM
To: msmulski2@gmail.com
Cc: andrew@lunn.ch; f.fainelli@gmail.com; olteanv@gmail.com; davem@davemlof=
t.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; netdev@vger=
.kernel.org; linux-kernel@vger.kernel.org; simon.horman@corigine.com; kabel=
@kernel.org; Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v5 1/1] net: dsa: mv88e6xxx: implement USXGMII=
 mode for mv88e6393x

CAUTION: This email is originated from outside of the organization. Do not =
click links or open attachments unless you recognize the sender and know th=
e content is safe.


On Thu, Jun 01, 2023 at 02:52:51PM -0700, msmulski2@gmail.com wrote:
> +/* USXGMII */
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_MASK      GENMASK(11, 9)
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_5000      0xa00
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_2500      0x800
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_10000     0x600
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_1000      0x400
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_100       0x200
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_10        0x000
> +#define MV88E6390_USXGMII_PHY_STATUS_DUPLEX_FULL     BIT(12)
> +#define MV88E6390_USXGMII_PHY_STATUS_LINK            BIT(15)

How is this different from the definitions in include/uapi/linux/mdio.h
(see MDIO_USXGMII_*). Have you considered using
phylink_decode_usxgmii_word() to decode these instead of reinventing the
wheel?

It would be nice to wait until we've converted 88e6xxx to phylink PCS
before adding this support, which is something that's been blocked for
a few years but should be unblocked either at the end of this cycle,
or certainly by 6.5-rc1. Andrew, would you agree?

--
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

