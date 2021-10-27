Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29E243CC06
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhJ0OZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:25:17 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:23446 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242526AbhJ0OZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 10:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635344563; x=1666880563;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=arQZksmwBlv/0YXrihYbKBrTNhJup2dKWIMHT8t75CE=;
  b=brfLG4UJc0sE1rNXHuLdZgnRwLLK5o+2POLdyqEFqN92F5ZSkVP4ZMYW
   /Uh7+uAkzWc8mmqcXSiSJbYzt/82rO+EYKdRRLrNGbW+18BU259ABfiUd
   SrDDEueCnTiQcsiuK5avt8ds+2FKlqFG11MGYl5QeANibelAOMfTR0s3f
   Ec/zTtts4wppELlZATyBfrrsGH8kPxw3veoGRzWfhRKFKmxFeh7RQRT1O
   lno8G62x2g54oFACbMbxj02AE07LDBpXHd4A6+7Bpmwjr56IqP1zhM9mA
   YDMhDqyn1qB/PSF9iJX9WSQ9BDZkKIcVYFBL944s474S4+ikUpcQAoYkr
   w==;
IronPort-SDR: g2CWSkq3ik5m7RnmeQQfL9mKcWZHqvjGT9btGLihxdhWAme5jvqrywwNoXz4QtB8WBZIVzWI3c
 fEB77UB7uOouYMiKCDJWpkcDKIkQamG5ydK9niUjOtf70NfUZbuPv0BPibG9zOncpXUjpF4Ghy
 83thsPCktXCxiu0LbK//T2as43s9YPJOq89wLUkMMCVNff+XStPX9aXudbwOtD7LG/rQms365t
 l6uAr93tnfhE0JwG6IL/pQpM2B+HkWTMALO2S2q5joNZzY4wS3bvnRrGXqcThmKaQ8eN/Y12OQ
 gmOBMlJgudophzaTzFwHJZrW
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="137061816"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2021 07:21:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 27 Oct 2021 07:21:55 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14 via Frontend Transport; Wed, 27 Oct 2021 07:21:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2Ozl7bSrscT23wNvJZlLYtqMXzurpxVV/VndmLuz8ELFVvdSwMLRTXCcKxRaqDkeqcq2iKXwZBbBZwykszmJwj4Kj+DQaM6yaLl+5vHA3bg/GPZzmET+4GAwH56lgr0xaK1B8niMBYPpXFESuy0wVofv47dWBaWqokYOTIN6h92LzwNdY0oRH89iGvVOUIW6I3//1ceVUN5qFvuvIT2iSVdajpuu0zamDp1uQxr8PEFlObC8rtWZZ7ZjRN/ce5YLZkTpF274T2yoQL4HYL7IRY9KOZTjvBz+7QlZcTOiABcTjOHDOB1rVqbnguFDLiPHnQO8sHc8m7NYWgw+C1LSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VGgjr4kKwMtVY5e0yHPaeu1mlWaOPg2Z7tvgbCqcuVA=;
 b=GCs3hiyg8gVhbxM7Grm67TK4N62vuz9sTsMR9J9IsWDMHOcJf3HdR3vuy/iI/Jmg/BZoep4i2CLaI+ICZ5VHY6Cl0z35YrlqYqu/r77JoXmgdvEsQKif9rz8vD1LOL3DbLKkGlnepDAbITldlbhzpeCf6NF1W2kp0f8IqII5K16BgJY+ZSfBI7piwauyxI7efdSWe93wC13W9zI4nbFJSPh30l3JY0xIsggjcO3h2PARi8/mXOkSIgp/RSu6H1Q3ibHVAGrIrHACy74Wvb4ZYwyhUXs9AW6CM8BFDVlrRjt6FAGAfB9oojFjfBIGOj9Z+LD35R04XISrNWGhDkxsOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGgjr4kKwMtVY5e0yHPaeu1mlWaOPg2Z7tvgbCqcuVA=;
 b=Kvfvy5CurURAKtjgS0ojcAT/MYeXJmM+sdChg7JI2ZXCgoyz7/ldK6UsT6iDZm2uc13UbzjoaQCblp/5poqnJ9bxfGekaFxOXcGiFYX0EwMH+DZSswTtK9VNTbqKZ/zt6f7kXLQhYLT7izyjNDx5Y2UcsaSwSlWKhSVVa3yBfxE=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by CH0PR11MB5564.namprd11.prod.outlook.com (2603:10b6:610:d7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 14:21:50 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::4907:3693:d51c:af7e]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::4907:3693:d51c:af7e%9]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 14:21:50 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <Nisar.Sayed@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next] net: phy: microchip_t1: add cable test support
 for lan87xx phy
Thread-Topic: [PATCH net-next] net: phy: microchip_t1: add cable test support
 for lan87xx phy
Thread-Index: AQHXx3OiBAiK8WCZ6kqAisnfUJKPX6vfbI8AgAd/7eA=
Date:   Wed, 27 Oct 2021 14:21:50 +0000
Message-ID: <CH0PR11MB55611B20B0E62E95C74027338E859@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <20211022183632.8415-1-yuiko.oshino@microchip.com>
 <YXMVdkXIenVuD3gV@lunn.ch>
In-Reply-To: <YXMVdkXIenVuD3gV@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bf9ba1c-ed08-424e-4d32-08d999551e1c
x-ms-traffictypediagnostic: CH0PR11MB5564:
x-microsoft-antispam-prvs: <CH0PR11MB55643D48EEB4E1CE80D2FEF98E859@CH0PR11MB5564.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ahXkNB/TDsw19d/czlCNX6AhOz5csenk6mG/o4hvyWZ4Wv2s50Gq2ZqpnzR/6n3eGuI/mYI19o5hpkssbWKXfAtam8dwoS+ur3F5nKmxvWj3rR0aDN6vm/YqTx+l+qHirXRdON+4Z3NBwx6XCCPfsdb8gcRGJALAIo92G9h5pDwBFs6a4F7NXU8c38nqjDTshwLjkYgdKGQkWTT6+oWfk3wTiehXBKRuffCvZX6YeciwrkIiQEbnVxaLXdYSHCv/kYK9IIbwVZW6VTnLQbfMpu75qRfkSoC5UfH2Q92IXZU3onOcM6Sinmg+/O/e3EuTW5VXRfeojCVvUxKX/3/1fYTsUU16dLB/rEm+YG6WTdyyKWM0TPuECEpIHWV/YlCCGXAfjNUpxYc/EEaYh3MNaSj45X5vVsKk/MGHbr1RRPtBg9ZVPhYD/cZtvI1UKLHxfA0K3rYHpVgiZlXm7AsGdvXhw5JHdZX45NHudiDjwSgIMAmjtk0qdWG0IJ5JUZNPedpr00J9QUY2bDhOM+ncMcKqshvTAoFeAXPN8ycyEIIKI8aXnGd0z/57GVqt3scVofO0yPs/hutMJ1Vx1V6RElfTpvhvXeAS4Aya/uncadYc789Kew5BZZxFEyRTo21mZ0NtJuTK7M5nV1OfFcQ2G5P+wvQ9SxkbpSCtFacU03PxlywGG22TTOj56BY/AlP3IjIWijxsHn7h0+I2UJMJIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(508600001)(66446008)(38070700005)(6916009)(66946007)(7696005)(86362001)(52536014)(64756008)(186003)(66556008)(66476007)(4326008)(8676002)(26005)(55016002)(83380400001)(71200400001)(5660300002)(122000001)(107886003)(33656002)(316002)(76116006)(54906003)(4744005)(38100700002)(6506007)(2906002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Pn8dNaftmJyEPffg8rvTa64aw/O8rIdG42yQdo9vITA7I+cH0grxs6P8RP8A?=
 =?us-ascii?Q?DJkE3SHTjeeu89Gc4tgS7e351FXHqdY4Iy2OMnu3QAtXfKYFENn/TfmFNuTo?=
 =?us-ascii?Q?vMoEAu/x0nntZLFY3oyO68fZgSh5B8lJJXFmQGAc27gi0xSwFA/D6ybI04AD?=
 =?us-ascii?Q?kl4flUXyMsBAK3ITrDP5ayNyjBMtJGaP9pTnQtAyIvHa0gPGpLWIbt004yRV?=
 =?us-ascii?Q?st69JWaZFVbM59xDUpGtLqMUNBbeIgPwc6hncASDQOB2QOMK6sAyus7+fuDR?=
 =?us-ascii?Q?S2PPeOWy24XO+2YM3qLYvSl2r2gCGBCtLz7+EHmufLCO/FDnUtXQCzLaD966?=
 =?us-ascii?Q?ekHALUAYVsGP4wNJv1sHE17CzBP4XuCrGSEr1OhbXgbvj6HDPQ2IzFfJKShO?=
 =?us-ascii?Q?NOtcuoLph4WaGNCJeya66EJeXOK9wksfC/EnDLyRmyUvkCxghn4lvzd45C0u?=
 =?us-ascii?Q?v9zQlPsZBiGuZdLtXNOIuK1p6G1ZdDMLFEN1R/MJ3r1g/kO9G52cEWobZ256?=
 =?us-ascii?Q?EQY+u/fbSannZZTE8DR81HrBGY7bnkidS3yZoP9hxTUwdKeNgLddQB5ZWKlY?=
 =?us-ascii?Q?+mNYFZ/S3TfJpRHC64jcZexOAPGc0fSxmOmF102rIj8XqAb6/Yurlo/jTqfA?=
 =?us-ascii?Q?C+VnAy6X7F2aPRROXx6K0hm5B0fjA8+zoJwcXQ7FHwcN/05OR/moj/gEFIJO?=
 =?us-ascii?Q?o32HJfwANMZK6U9S8Ek5QYssqadFOpkDsDaQp3k74dH3wM0SLj3h7OizV/tp?=
 =?us-ascii?Q?Vny/EPHe4Yy6s00qJyamdhVh4/WAJpulF3eqODr3sTl9y+j5uwDOFV6rKdfI?=
 =?us-ascii?Q?hQo9M8rXW72GMJM/1rSWSwJKlONW0hTytTMohg/tGzNH6S5H/a5bgq3gyqOD?=
 =?us-ascii?Q?V9wmbCUc4KkXJNksJHRIA4ulN69VtbDJ8b1jBjRuQAtxHEFkV/2owYSmHSSC?=
 =?us-ascii?Q?db9FUZZxtTjHJUHSb39cJAwKB5o/WIQJjPITyC6o1zlhW1/gFEE+K0g+YODl?=
 =?us-ascii?Q?ymuU2FtfdSP1gZNj1M9S8rLxY3qZm0Nwk6HBan6kyWw0bnqutLQtERTudSkm?=
 =?us-ascii?Q?ImpqnR71nfBGWHWz6eVQ0tzHTDsYNBFpopBgoGNM78v/j4gTR8HZe49f79OV?=
 =?us-ascii?Q?lX9ehvBo2eXhveZPM2l/ru+hbu5NmZpb0dqNHA+AwOa4wXSB3tiZ/8GV74W3?=
 =?us-ascii?Q?ppakopMiSBhw4zEOqUET6SdkiT2ouW0EQ0TRmAEcKfIXDU1XyWTDTlIO3roi?=
 =?us-ascii?Q?ZcUDvrvVgwKUA61T0FRbT0lVV/eLO1mK5zjXSMyYuC0d5inUllDwO1aAhNkm?=
 =?us-ascii?Q?rvNcNJyiJYu6wA/D69WDWumSsr+NBrEj4IOR4FDnpr2yaSEArHgrkY2F3Xhv?=
 =?us-ascii?Q?dP8OSEpXHhLOc/AM4K2+jgz2bc6fJludp3PsOo9uNsJQiileI/HIczRtaD3H?=
 =?us-ascii?Q?2DLMdDgvsLiegJ2y8Rq/Et0JwhlnA/ZpILsQW3zs3zenQyJn8+DLnLCcgqcf?=
 =?us-ascii?Q?ZM2jbkz1jTDTQfOjmK8fuMGW/3Q12oZVXpZAWAqSE2iZrFNzPdrlIvpvUlny?=
 =?us-ascii?Q?/1YyZ8UTzuj7+6M42aR+xCQGuwV8zKpGzAEfsE6+YTrdRNORzvSTolp2Z/zL?=
 =?us-ascii?Q?9z8yugtWhQpx5Jn/JIyQPV5CWxLehD7Xe2BA4e0xL9uujmutJrWdDDGm84EI?=
 =?us-ascii?Q?Hrmo3Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf9ba1c-ed08-424e-4d32-08d999551e1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 14:21:50.4563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IIBVD3QYSmdiTmtiTzQcyYgT8l+BCEuqVzzoxBf/nR/FmNShL9u/zL16IqkAqkDLhF6m++UKFeCW+vsM5g4cLoEjj1x3J2XCxDqxM+gvwyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5564
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Friday, October 22, 2021 3:48 PM
>To: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>
>Cc: davem@davemloft.net; netdev@vger.kernel.org; Nisar Sayed - I17970
><Nisar.Sayed@microchip.com>; UNGLinuxDriver
><UNGLinuxDriver@microchip.com>
>Subject: Re: [PATCH net-next] net: phy: microchip_t1: add cable test suppo=
rt for
>lan87xx phy
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>content is safe
>
>> +/* MISC Control 1 Register */
>> +#define LAN87XX_CTRL_1                          (0x11)
>> +#define LAN87XX_MASK_RGMII_TXC_DLY_EN           (0x4000)
>> +#define LAN87XX_MASK_RGMII_RXC_DLY_EN           (0x2000)
>
>Interesting to know, but not used in this patch.
>
>Please can you write a patch to actually make use of these bits, and do th=
e right
>thing when phydev->interface is one of the four PHY_INTERFACE_MODE_RGMII
>values.
>
>         Andrew

Thank you, Andrew.
We will consider to make a use of these in another patch.
Yuiko
