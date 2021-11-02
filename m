Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6D244359F
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbhKBSdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:33:14 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:2398 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbhKBSdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 14:33:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635877838; x=1667413838;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1BikJK+Djo6z1YnSZr0kTaQ1RyZDTaX/Kzf/9OGk/z8=;
  b=2DyPMyifsD484LaGpdEcxUsfUN+VrdgntXgb1r1qve8h373t9TSANKyC
   3yg/EFSvXGUNJCTdm0F/Mu5H/Yr1VrVYdErynoW03nLTM0smGHsQXOFyz
   zSfxEMloqLeJBOJmwNVIwRM34Z9XcrazqDITWuA581GC/TLvhdx4fOg4k
   D6jqVo72Ti45NgFW+o5zsKmSSdldF58+g+5P/LdMXVsJeEaT0VC4Geu7+
   095Eze6ydbqIMgAStd0BdnUZiy2ePC1hoDRg0c9OnBJjvviHKuHYkPHw/
   mMt1u9A4KcPYX8K5+JzJLWvVni1yZ5A9XaYNTAnYg/OCeREg1CDaXd6Z3
   g==;
IronPort-SDR: PhcgIF1yPo2oZd4QbJhJgPgjIGqN1wTY5PDVR79wiCNJAKv2DYX5qKqFLYu4+Xp6MjPbABRA70
 FqpHfs+RbftB6/DTFKNcHX8ctKSWjULV66CKN4oDhZrCJm6QHvuVQzPbXAGS0nktEYYT0CCBzH
 TZifLG4ivP7YN0/Ql418MLIkU735FAtBN2xn8q4Mpj8qIg2XI2Lbtbg1USREaSjxNpWWPlDvz6
 vXCT3nZ98jrgavnvEqgwSkH6iFe161BCGhsrBnDHGfZcsfQFT5eahnKe79HZh0Oa19Z0ERYcqz
 rNKpvOr81O6HCc+GaK2LrUwV
X-IronPort-AV: E=Sophos;i="5.87,203,1631602800"; 
   d="scan'208";a="150462824"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Nov 2021 11:30:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 2 Nov 2021 11:30:37 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14 via Frontend
 Transport; Tue, 2 Nov 2021 11:30:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FkyEzkThCw0PDmZzyizADgto8Sdqc2BLGNgK52zuFqFdLyI3gwTNgN5coAI3hGrM/APLUpfLMq8cPw7zq6XJb5o6X3k9UgufXfeHQv/CfnX8RHWVWqH0Acnar3Y4+ktNySsdjsUR9Rfs87XiSy3tditxAK3a8Dx1Ju+zLEf3RCWd7BvQkw5saJqDtvj959OsLyKHRZU3L3Utr3NaHUyr0ePL1fv/OCxQev2fM48iRNS6mbjFAyziVJ/xUMIueGb0xNq40y39JY/DZbY/5z4VkTYvUpCHlO4y1zUXOiVBPh1+bjNheN0qLkLViC7ppmNx/hBDyUcqHMTeCoroXrvHuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xyfREZakTtLHWfprfdEiF482sqNKc06GzmI/lmqJgbE=;
 b=cSeZfdosLNWsOiNTOMvkwSDNs2OgD1T2P3BdZHaLQBFrg0Sk9Vo2Xk5JfDDWUhe235KOCUeC7yTI4vEu5anKibqWYPT8q6fCMey5hCV+rCKibMsd5jmV24oO9+IMFxQ3vpzsZRCssIxFOPbePPMhNQhq070zWdcZqXU7bmI61xfBK/wTXdqAvQ6VZWwz6qYQ9gU5hMBrhabkPoDIvxwB+7pjDLGyC2K4E+QpOf1WCVX7jR/5IQpIcz2BWew4+m/aFeUGVSCKHh+rLp0rwGHVN69VnySDXml2MIxGrBZ3wS+hlSF1PsOaNovINwLLz87tfgQP5c/4UkbX7HFqUIeKdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyfREZakTtLHWfprfdEiF482sqNKc06GzmI/lmqJgbE=;
 b=jntFO+IskxOM0mspZANfU/hExwUWV5SE0jIkFIcsFDUFbYWvHlGcFfeZ7JGg/mAku2VbiG4osIheS03njwrwPkj4OADDUNzFaPEVaHiRPNGvS1aJrvsvl4LdVVH2WTuD1srzXpzBtlKOxAwijdFdggZ8lzqY8FVLc2VklteRuLc=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by CH0PR11MB5563.namprd11.prod.outlook.com (2603:10b6:610:d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 18:30:23 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::c096:557e:a1b5:bc5c]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::c096:557e:a1b5:bc5c%7]) with mapi id 15.20.4649.019; Tue, 2 Nov 2021
 18:30:23 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <Nisar.Sayed@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next] net: phy: microchip_t1: add
 lan87xx_config_rgmii_delay for lan87xx phy
Thread-Topic: [PATCH net-next] net: phy: microchip_t1: add
 lan87xx_config_rgmii_delay for lan87xx phy
Thread-Index: AQHXz0FNWvJWgQlw5kCiQbjn7Q8X7qvweZYAgAAW4FA=
Date:   Tue, 2 Nov 2021 18:30:22 +0000
Message-ID: <CH0PR11MB5561190F0D11131AE6FCF52F8E8B9@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <20211101165610.29755-1-yuiko.oshino@microchip.com>
 <YYFwNAy8uynS+A+G@lunn.ch>
In-Reply-To: <YYFwNAy8uynS+A+G@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b324f32e-1fa4-466c-ee40-08d99e2ed551
x-ms-traffictypediagnostic: CH0PR11MB5563:
x-microsoft-antispam-prvs: <CH0PR11MB55639E277CD5758BEDD7F2B58E8B9@CH0PR11MB5563.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kiQ9rIHKy7n/3jfuLxHxeXCVXJVf0kJShxhjtZSeDW+v4fGq3ZNre6ipzVcH2kp/K+7QuVhKDIg55lMu0/NvWM3i7cjnRsezbXT8ProsSQhwpBIYFZ1ly6MEMUdkDq3GrIuRtHy98vukE8KLlvSCq/xo9trIE4p5pjDfNK1vin5ghtQ7gtF+0w8nI5k4zEoteZBsM6w48v/BeeKT56clYZ3aEFEzMz/dbDC+CaT5jRNAZIJiXbM0WGRu0NvDlCXGyc+FJu9WtwZRg9cFUTfFNLy+a7mm3t7WFe4STAbiiKCo+RGPSCIhP1xzZ8mwiH4KK0m+kURnblW3nytxrnsrvmxcfOKRKn1nIWlaJwVzwmvLqRW1VybGIKmmHUSrbr9CjNlGRlj867scTXTE9PrmLC1C+BaCRwGzAQ1ZvoajB1q+q7YcSbb0zwfCKd/UqXK6jLV17d/koieLAGxNAjq5RqfaqsBKYtzY6HBFnEByLjwi/zaJSiZPjUGSQVOa0gWLrHJCMtuO/lnjrHRjLfKoza75MlT6Nr2XuvHgLTZyDHLiMCTOgLO51jmkRUANwx9HaJKsLRi4rU1cJ6W6Tro5okXXjrNF5AMOYvHRCT/vkj2GWLUMhvbMOcBNBHBez78OfYcUms7UWuZD9MmIo5OloiZ5vGJ4Z2GBS+KnEBLWMYAlniUBw1mayn8vApdgtZL1aOEroY2V/zikiet9MGF1dQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(9686003)(71200400001)(26005)(8676002)(6916009)(55016002)(66446008)(76116006)(66556008)(66946007)(4744005)(66476007)(5660300002)(86362001)(122000001)(186003)(38100700002)(107886003)(52536014)(83380400001)(64756008)(38070700005)(33656002)(4326008)(7696005)(2906002)(54906003)(508600001)(6506007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bBfe7rvm/beOWcfh3IOtXqSOsBtnBctBh9z9dwKsO6a8UHMWKhW3vSMKDhKs?=
 =?us-ascii?Q?uo7vOYAuCChwHnsCfJUfWcNwFzQxqBXcPiiBARemVS4pMoCUA2xhFQuOcQdi?=
 =?us-ascii?Q?cKysu+lueicIw+UpcxnysadwIUdEiUQEMiY5wa7BZwZA2T1R/SbYOXXg9iz8?=
 =?us-ascii?Q?biH8dm/kJ9zcEpwcpM8MthW1MG1SunQyWonDklDagRgVB/x/rPJrGry9prvX?=
 =?us-ascii?Q?HGtXd9b664ast2ts5ugLeIQyYrj/2hbRK+SuzwDkoGhT2sPi5q0HIyCXyHHB?=
 =?us-ascii?Q?2vb7LFVadjXNUHygspnfnsrjDqGv1kuuATNJUxk7RYjFQZZKgKMmIMIxxndb?=
 =?us-ascii?Q?tQHrz06jnmGHdEJ/dhx7HMjbxD6zFtEpqycQe7Dj7mmlCROqOepgd2GWcpNi?=
 =?us-ascii?Q?XrHjvXc7VINAja/+knBXg1aC0BdpIMy0fOuY07r76unBzC0IRZASN1Ii+ES9?=
 =?us-ascii?Q?UQzjgqLCzOzoIDEm1Wjsr11uH5sfpRK1oqhJxtFdabR5OqmZcsKuLuFuoeON?=
 =?us-ascii?Q?P66Ev+/lPDcDev05J8X0L8o/fzOylIf69XIHZUa5jGELS2kJ7IfIaddXcXmg?=
 =?us-ascii?Q?v3FfbqNp3Zacb5PQs9hooVowz2OrKM3tv/WeLbB4QGq9NrK4LnbETnF9ex13?=
 =?us-ascii?Q?942RQMDmbS3XmuneVMDWSb+MHCgHQWI4ryxW5BBLNOOuDrXVK/BgAeJI7cvC?=
 =?us-ascii?Q?AxI2dNNXXZzoL5KzFiVhfLwzo+c53V1YgIJZZEl0sgLrEpB2QVvhzwnwvGrg?=
 =?us-ascii?Q?/YW4avJ3LCDyskBXH/1EqSN7Bp2ela8957DJpFrvsskw7MMbKtzKuuGMz+wW?=
 =?us-ascii?Q?+2pSzH//UilzRKafYFxus7fVD790w2uYPOHBu2GAb4vxMBwEzyhN4q3toEaE?=
 =?us-ascii?Q?QRogN7e7rDVll8zNU82Sv16QKr6Dqxv7ySNqyoe/6HV3+jd+mSAeK4Hm553v?=
 =?us-ascii?Q?cdvw8b+C05zxvt9W15C0pU4CVMbyr+lGpWP2N2GVVcFqe9h3U+wUkCNWJ2A+?=
 =?us-ascii?Q?0AM3xtzORfQegsglzWMztYrhxpuzgbezsHNTOIcEF4tvnPBM2Oa1nScc6odA?=
 =?us-ascii?Q?YAQZ/QlC9YEY1jhGPbxi/bNAFFyEiUNwqeE+S/Mjt1m/V43kYKIGFBBAwHgW?=
 =?us-ascii?Q?hXV9ZnR0mdUhsGs7B8K3ooTXzFfJzsaDqO3ROFscRu0wVcKkWycka/BBNjlt?=
 =?us-ascii?Q?1j5kljQ/4B3KVQ94q5FA8nsLHPFX8jcZ7RVsSkVxCozspsrsHKSZkmvn87sq?=
 =?us-ascii?Q?WM9Oq8hHTEiL7biloDaQdZkZTzxSnFWNFlQ7NoGTjapvjaX+Vm1B52KtTvOg?=
 =?us-ascii?Q?VCSNhMqEdmDO9WjmHnxVovpflTcG+yteLXz/UR2b0rIx6RNLvNgkZeMhDQo4?=
 =?us-ascii?Q?+ZXM3W4dPTlo5vqRWbg/tfBQE177pPEe/4Qhb/bBpICKNWFnQFhTweYBAMWP?=
 =?us-ascii?Q?XVwKSnX51zViBVxWrI495t3c+36Dvh6sFjbi15TYnqaZYH7CRChOxAi9G9BT?=
 =?us-ascii?Q?OoIWP/JGGPlzJ8n8dS7Fl7z9VAasQ5/NVV+9fLEmBq85AUHdiWWztqXOjKEV?=
 =?us-ascii?Q?NNfUrx50gJ4ZAVxa7nty+UTTbxP1rgdnAdlGSXwBmjmrer9AYW7m1vyVzJ4F?=
 =?us-ascii?Q?P6xj282bcvuYyEZPapimLnuwTChTlgIvH7EWYH6/RF7ijVAuEgXQrmI87BSq?=
 =?us-ascii?Q?L2GRCw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b324f32e-1fa4-466c-ee40-08d99e2ed551
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 18:30:23.3091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BIq1nMosCV6pEn1qRcRs6s1gzCYwA4aTknO7xXcrJDyhKsjzuzOZkk19oxwh1vdVcsbA4TVEtjo5JaYM9j21pEBsZzXuidbdaD+hrt5CDUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5563
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

I forgot to add "PATCH" in the first version of the subject.
Sorry to confuse you. I was not sure where I should mention that I forgot i=
t.

Thank you for your review.
Best regards,
Yuiko

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Tuesday, November 2, 2021 1:07 PM
>To: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>
>Cc: davem@davemloft.net; netdev@vger.kernel.org; Nisar Sayed - I17970
><Nisar.Sayed@microchip.com>; UNGLinuxDriver
><UNGLinuxDriver@microchip.com>
>Subject: Re: [PATCH net-next] net: phy: microchip_t1: add
>lan87xx_config_rgmii_delay for lan87xx phy
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>content is safe
>
>On Mon, Nov 01, 2021 at 12:56:10PM -0400, Yuiko Oshino wrote:
>> Add a function to initialize phy rgmii delay according to phydev->interf=
ace.
>
>How does this differ to the first version you posted?
>
>    Andrew
