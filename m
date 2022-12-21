Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD146535CC
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 19:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbiLUSDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 13:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiLUSDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 13:03:30 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86151F5
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 10:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671645805; x=1703181805;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e01a9LM0bNKe3Avcscw+gmimSlNfS5eAcaobvI3qGPk=;
  b=FuFxkbeoJSmMsJUIFvvI+G1Vhb4EiN+WR+TfWgLxszaSIFeAyq05TDnr
   WKXiywNN2hCvj9YXO+XnAzCq+v7yNYPI9p9SYgKfeSyf5yKr2nK/t7zRN
   AgDH5I+JwhkzeBuhnFuB2fn3b2jECrYqfdUcsF3rVxcE3AKBK3t7pnLuP
   ZWw9pn77JDB4qki3Fmalqs+W797rsmeTImhYiSsnhwwxg5sDq9Yjoq6kx
   b6QpGeW2nYoIw5AlbmIc8LanST7TjW4in1VYmfsY0TsP93hM5RP/Sgc+d
   zrsK7E6Hv8WxlpRIH9JvpLP4TWPJypqmG8sy6DFgfgzRrR1c5UgMGHrbu
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,263,1665471600"; 
   d="scan'208";a="194001095"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Dec 2022 11:03:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 21 Dec 2022 11:03:23 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 21 Dec 2022 11:03:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUxF2gTfOtgo4fE+gkKfzNbEheZwzorORBbE5NS5TsM7AS6Ixo5+CgRb0IYuaJnXa3vayvCsSmXwHeEC/Qb8mjF1SXeLzpAu3J4bzi0kmSfrmN4tm0p05c5GfrR/YJZP2rAos8RzD4VbOxfwuyjIW781LpNVF7Z4y1NWzkRBPEIKYAV4PxnBGnjnXdJySjhLnXn8Wd+bCF0PiFedls2Ufzoxk1DU842nxHVkNhFOhjXAyK1Ehl+nW5r23T81MpUcrqc53QY7+mRPKUs3UdvFpNjGwaM7XbjBuovrK0ywf6p1lnT+ohoYAXq7hYaUKnDEF6hI+Oc/gWIj8PlbC4R/Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hESd5tpsVpNGxwrOmiibOQw37M8SIlE/E3IwP0C/8I0=;
 b=GQBNgac3sx2Dj9fnWBwt9bjdzyJGYo6Zh3xvbNv3IZPJ+ZgCfzRCtAcBORYJsQSGZ3gaUutoEcUUZ24/QZkZrNToOsHjfcQaEDSQvqrfsPKn2CCo6lR5ylugliR7Zb4ZSus6wShDAMMRG7xIH4hkCZ4YvQZHgmZpR6bjQMmK/Z8riQFIU628/Eo5ngTzugeQjyiPGRqCDHPzmtHHUiWd6cX7t9Dh5QeO5GRNtrU0beah59sFUVBpCNUA8MN/EiNd6/XbtPgXRp3rYdPgLzoMWKI026ZL/1ouTiRV5htggx8W3BR/A2RDT/H6gFfRzhiN4DfYWDPtUw1WjfVze0VtJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hESd5tpsVpNGxwrOmiibOQw37M8SIlE/E3IwP0C/8I0=;
 b=p/rvDVq4Pm6LKYK0/ZEFPQ9a+OkOYOM4LGseyrlB7DBKCz6IhZIJ0wKao90waJEnOi6asD6yfuSFx93PTIFwEyCu0W47i2EHV7UJU/OShI6M1ZpXfi/+4dc69g1skZKCVom1HSn5MLVpZWi3oyJzVl5jywn8GQh63+b4Fp0hPJM=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by DS0PR11MB8133.namprd11.prod.outlook.com (2603:10b6:8:15b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 18:03:22 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::58f4:512d:ec74:2f31]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::58f4:512d:ec74:2f31%5]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 18:03:22 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <Woojung.Huh@microchip.com>, <andrew@lunn.ch>,
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
CC:     <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>
Subject: RE: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
 phy_disable_interrupts()
Thread-Topic: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
 phy_disable_interrupts()
Thread-Index: AQHZFHXQaD3fYCnHDUqUrGntzzIs7q522QaAgAAGVgCAAAStAIAACAmAgAASnACAAC8QAIABdSgw
Date:   Wed, 21 Dec 2022 18:03:22 +0000
Message-ID: <CH0PR11MB5561E53FF45F4AB6262671B28EEB9@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
 <20221220131921.806365-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <7ac42bd4-3088-5bd5-dcfc-c1e74466abb5@gmail.com>
 <1721908413.470634.1671548576554.JavaMail.zimbra@savoirfairelinux.com>
 <cc720a28-9e73-7c88-86af-8814b02ee580@gmail.com>
 <1567686748.473254.1671551305632.JavaMail.zimbra@savoirfairelinux.com>
 <Y6Ho5rIlRHYPePEo@lunn.ch>
 <BL0PR11MB29131080A183B94D1E4F1C39E7EA9@BL0PR11MB2913.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB29131080A183B94D1E4F1C39E7EA9@BL0PR11MB2913.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5561:EE_|DS0PR11MB8133:EE_
x-ms-office365-filtering-correlation-id: d6e16dfd-9371-4ff3-a907-08dae37da61c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1jd5WXW8boK9X7pWOOP5UT0DNn+ltRxuDBYLTyihJItb6e8OfXo5DpFoZecS4hPKpgY8KB3EnBmvN0Lh6j/F8iklPFdBbZdATO+2ZKUVG4Dq7pkj1+MsBuJqJq6i6/rZJKyeVQdjyj64vRw2Ywr/oUgMzhiFUPV2e3red8DoxrwKI57nCwXLBJpFJH8eR52LA+gQi8RrTG5r69hU8hqc5WBShooJWy7Ydd/Uyvb7n0ruteoDpCGkqINZ3jxvteO22VDjH0IkOMaM3fU34zXJnWz7e1cc9RAz8MuJtJ3nBcKBzlVBa7kF1MdMLbd0Q1+atejQhIXYjQ1sTZqdVb0FvLuxjVT0yib7Uf15GHnoTsGZyJAuU635YxZmX6rRb+561GomfBsJunIhvMSkLWW/s1bPXTcZw52ZKPe5gtkS3oBSnR5lUMx0c95gwjuaMRh9OHMjnGgIcURgxCBw2hmiG+5HZGl7oh+QgBL80q1oBgtW/DLxS6IaJpc0Ga04E94u4eW6b8p3t7eWQj19eO1QvPMmz6mvUeOKWwgUAyykKiTnnKsq5E1pLIqMl3fr6e4Cnof7GZ3BsZXMt6+GLM65Gl+VOE08/hIyNAsN1hDGcgAkOxfDzMGvznt//c25pv8JNHiWb2ErM/nRSl00H0xj14Q3wv+NKCKMpFqaJ8MJ6UocVnpQWr+j7Y6O4CQ746U7Ysl8NG68VCd2uUp9p5rQqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(55016003)(33656002)(8676002)(76116006)(66476007)(66446008)(4326008)(64756008)(66556008)(83380400001)(8936002)(5660300002)(52536014)(66946007)(53546011)(6506007)(110136005)(7696005)(71200400001)(54906003)(478600001)(26005)(186003)(9686003)(316002)(86362001)(38070700005)(41300700001)(122000001)(2906002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fZLUz5vBNk36fKbugGSawbBL2HIUV0Npax2mHm4ezwsGwMqfdmduh7ZIja4K?=
 =?us-ascii?Q?P/JD0PEI/Ib871PznNvACx5JoWl+CgDTHTd7Mtntt73h3Ix60Qm5pfntwe3U?=
 =?us-ascii?Q?04AQN0GDyeJKo8fVG6QKSevO+khXSUPmhuRQ3UBD0XeI1jdsPT3uLb1dJTys?=
 =?us-ascii?Q?IQ2WK6wxiRX7/iH1bRYqUK2jyPQhs01QQWM58ZHqRiqTs9uCllXw1E8IgIMv?=
 =?us-ascii?Q?8N/Hoh+Q20sG39UkKJS8qENjqVOkV89dOCOv2q4OQKEsztXrMA2nMy2/opJw?=
 =?us-ascii?Q?pAX6F+hzsMM00+gHrlfuNi9A75R8XsmzPGcwSCr+LqEC4YJeIlWkvDyX+jy4?=
 =?us-ascii?Q?ONZYDuoa7oIw+pI/1hCEI4KzqD1nTS7P7kpSOBK2AauFxYIe0RTu+6RF1hB3?=
 =?us-ascii?Q?MI2/r9clVr9gHse/6KgltTXSRwWnTMtWEaRkGWrxEBJoas+Gf03sawTp2WCX?=
 =?us-ascii?Q?G3NhDQjPRjxzcTAsHAYS9S3ggHHI6aI6RIRHHkP8rVTafMnlqR6hFw/j0GM5?=
 =?us-ascii?Q?la5DYaskyjKpBfky2HaJVX8gUnqyW1mdlfyjNNOeAqRFwy5LUlYL4z8SfmxJ?=
 =?us-ascii?Q?IQakcyt/9Ko5QfqRt7Cu0z9XUl59dUrc+u66dMNirGhTft/ltOrwRAdtpyF5?=
 =?us-ascii?Q?+hUib1NBqNvlxW3/XjVVusXpeWChcwxBsIOOKnjmy5uzaRRsBzb9CAw8PRu2?=
 =?us-ascii?Q?5eC9naW4OlgJ/Au6IONejJeLLRCejXC/2DEHeibFHFefrvp+aJfJeg7fhF2z?=
 =?us-ascii?Q?zCmt5ey1zI35H+wdmhFOqUcU5zwj2zeXUSRo7AWiSqfd7KB+JMdBAgWuMkYP?=
 =?us-ascii?Q?PbIg/GqEyhidsj/TxiM2COjbvd2vgrqSGYrbZvLjbdsMKLoOtWUabADUCOTH?=
 =?us-ascii?Q?1CZB9OKxAV9qetR0DtpDetDUNKrsIwEPbPohyPB1g4vlgkkzE5j/OrpqTHB/?=
 =?us-ascii?Q?2NPflGC0GbBfUwwu/5Q6vef3gkTnm4Somih/P1BdTkvqzsG3u/10VQnk355f?=
 =?us-ascii?Q?NMQ1D9LTYV7mL0M6cjegXLNflyh7BqDhE2WDrpmktNpYkVMkYN0gfxKjfi+J?=
 =?us-ascii?Q?c+Xpja9sIhyw1wYzgP23phQXSb8l7CO6MGX6q4rgGyHZq9kPEq69FPHO3B+Z?=
 =?us-ascii?Q?/aEvNhk6RIybojKuQ20A7BHuy0ytU53TIFNuMANibKQv/lZBWZfI5xUhvPE+?=
 =?us-ascii?Q?YDTQ25AKmLQnoIkY1I4UPIA3UXHb2AsCt4ZbOOj8+ZfjxunH5R/IOe1mi1/e?=
 =?us-ascii?Q?+gjLY+1CcVXtwSmcu1E5boFqh7QRiR2e7Kd9e2fMXVvDgqWAVNlN+3SOlNlg?=
 =?us-ascii?Q?nvaeHHB3djXRac7BP2jfNCxO3Cjy9dqHz2KBXMQWGpwe0cTyO7l/ajln5Hht?=
 =?us-ascii?Q?P4t4koWHAcm+mKtKqsl7zAwPOsPVSO+tBSGuHGwF2pZJbZezDcp34EQaROoZ?=
 =?us-ascii?Q?h6+/Wz8Esu66qowQObNd6Dx4qADI0U94y5kXqEnMie4zULTpqMadY4TLNj4s?=
 =?us-ascii?Q?A+SkYctJAm/T5KS3Xgg3cg3N6OlixAa8HpSwZH9PJRVBzopZKWeyqMyhBYOX?=
 =?us-ascii?Q?cbIZ6DbMAFC7QwLfBaAr3jKrH9TPxWQ1HKgkhfc3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e16dfd-9371-4ff3-a907-08dae37da61c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 18:03:22.3347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qpwDQ6OF8ZpJuQSEMuohrW6Am+6/N9mUV29wNkUBQgNGFloSJ7dg2KrGWzVdhmWWY2a7mhmT4ZTg+xEkWjtOUMpqwW98L7ysOqh+kzwduQs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8133
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew and all,

Microchip team can review the drivers and test affected devices next month.
We will submit additional patches if necessary.

Thank you and best regards,
Yuiko

>-----Original Message-----
>From: Woojung Huh - C21699 <Woojung.Huh@microchip.com>
>Sent: Tuesday, December 20, 2022 2:43 PM
>To: Andrew Lunn <andrew@lunn.ch>; Enguerrand de Ribaucourt <enguerrand.de-
>ribaucourt@savoirfairelinux.com>
>Cc: Heiner Kallweit <hkallweit1@gmail.com>; netdev <netdev@vger.kernel.org=
>;
>Paolo Abeni <pabeni@redhat.com>; davem <davem@davemloft.net>;
>UNGLinuxDriver <UNGLinuxDriver@microchip.com>; Russell King - ARM Linux
><linux@armlinux.org.uk>
>Subject: RE: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
>phy_disable_interrupts()
>
>Hi Andrew,
>
>Let me check with our team.
>
>Best regards,
>Woojung
>
>> -----Original Message-----
>> From: Andrew Lunn <andrew@lunn.ch>
>> Sent: Tuesday, December 20, 2022 11:55 AM
>> To: Enguerrand de Ribaucourt <enguerrand.de-
>> ribaucourt@savoirfairelinux.com>
>> Cc: Heiner Kallweit <hkallweit1@gmail.com>; netdev
>> <netdev@vger.kernel.org>; Paolo Abeni <pabeni@redhat.com>; Woojung Huh
>> - C21699 <Woojung.Huh@microchip.com>; davem <davem@davemloft.net>;
>> UNGLinuxDriver <UNGLinuxDriver@microchip.com>; Russell King - ARM
>> Linux <linux@armlinux.org.uk>
>> Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
>> phy_disable_interrupts()
>>
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know
>> the content is safe
>>
>> On Tue, Dec 20, 2022 at 10:48:25AM -0500, Enguerrand de Ribaucourt wrote=
:
>> > > From: "Heiner Kallweit" <hkallweit1@gmail.com>
>> > > To: "Enguerrand de Ribaucourt" <enguerrand.de-
>> ribaucourt@savoirfairelinux.com>
>> > > Cc: "netdev" <netdev@vger.kernel.org>, "Paolo Abeni"
>> <pabeni@redhat.com>, "woojung huh" <woojung.huh@microchip.com>,
>> > > "davem" <davem@davemloft.net>, "UNGLinuxDriver"
>> <UNGLinuxDriver@microchip.com>, "Andrew Lunn" <andrew@lunn.ch>,
>> > > "Russell King - ARM Linux" <linux@armlinux.org.uk>
>> > > Sent: Tuesday, December 20, 2022 4:19:40 PM
>> > > Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
>> phy_disable_interrupts()
>> > My proposed approach would be to copy the original workaround
>> > actions within link_change_notify():
>> >  1. disable interrupts
>> >  2. reset speed
>> >  3. enable interrupts
>> >
>> > However, I don't have access to the LAN8835 to test if this would
>> > work. I
>> also
>> > don't have knowledge about which other Microchip PHYs could be
>> impacted. Maybe
>> > there is an active Microchip developer we could communicate with to
>> > find
>> out?
>>
>> Woojung Huh added this code, and he sometimes contributes here.
>>
>> Woojung, do you still have access to the hardware?
>>
>>          Andrew
