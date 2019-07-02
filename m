Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B405DA89
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfGCBQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:16:53 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:36094 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGCBQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:16:51 -0400
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Yuiko.Oshino@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Yuiko.Oshino@microchip.com";
  x-sender="Yuiko.Oshino@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Yuiko.Oshino@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Yuiko.Oshino@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: j4YZvAlPflpWBpJ7/O8OLhqp7IiUwtQqc5KjY42WjRAmqfF66h6S0EYDUrp8+KAhL4v2YHJslP
 1/DwGD8t7JMyCcYOr75MuxOwogBpE/k/PXpyq1zddxnS40L5tgmI5qpCiGyNCNGLkfn0O+s54Q
 iPg37RD077HQN2B3EtIvieuiHpY/8iAXFvaAhzv7Tx2LjSWzLF1i24+IAIBsj2J4pHtz25QEWa
 NaGtRF3xTtDiW2KtiXktFU5jxXhoeos8nGmI9oxky3QiHfuHXAI6TRANuDuVCz+ZvqT54nEY27
 O40=
X-IronPort-AV: E=Sophos;i="5.63,444,1557212400"; 
   d="scan'208";a="41265961"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2019 13:55:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.87.152) by
 chn-vm-ex04.mchp-main.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 2 Jul 2019 13:55:08 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 2 Jul 2019 13:55:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5+XLMPpA3R4VWCfpyewhto5uuzjNfJXlRQsNj0+5/k=;
 b=jsARlScBBmj2VCg1YrOjnX2ta0HGlezyXi30pTzF5OJZShWgkzX2+0GHAgbqIH3S7So991re0kGQ5tIPinPdqEdNQ1rBu66sGtNfQa++C3K1Ei6IAbsmRjg9WIBGT8uE3jcLhGPhpQ5qNLJdWjqHqsJPX/JRljxhaZ5YPWRcd/k=
Received: from BL0PR11MB3251.namprd11.prod.outlook.com (10.167.234.87) by
 BL0PR11MB3203.namprd11.prod.outlook.com (10.167.233.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Tue, 2 Jul 2019 20:55:07 +0000
Received: from BL0PR11MB3251.namprd11.prod.outlook.com
 ([fe80::dd00:5175:ab46:ddae]) by BL0PR11MB3251.namprd11.prod.outlook.com
 ([fe80::dd00:5175:ab46:ddae%2]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 20:55:07 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <u.kleine-koenig@pengutronix.de>
CC:     <netdev@vger.kernel.org>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <kernel@pengutronix.de>, <hkallweit1@gmail.com>,
        <Ravi.Hegde@microchip.com>, <Tristram.Ha@microchip.com>
Subject: RE: net: micrel: confusion about phyids used in driver
Thread-Topic: net: micrel: confusion about phyids used in driver
Thread-Index: AQHVBqYRcOEIH9dyL0OD1BCO0lH586ZjRcWAgAADbYCAAKvSgIBUKAwAgAAGD0A=
Date:   Tue, 2 Jul 2019 20:55:07 +0000
Message-ID: <BL0PR11MB3251651EB9BC45DF4282D51D8EF80@BL0PR11MB3251.namprd11.prod.outlook.com>
References: <20190509202929.wg3slwnrfhu4f6no@pengutronix.de>
 <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
 <20190509210745.GD11588@lunn.ch>
 <20190510072243.h6h3bgvr2ovsh5g5@pengutronix.de>
 <20190702203152.gviukfldjhdnmu7j@pengutronix.de>
In-Reply-To: <20190702203152.gviukfldjhdnmu7j@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b0b6f04-483c-416c-32e5-08d6ff2f90d1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BL0PR11MB3203;
x-ms-traffictypediagnostic: BL0PR11MB3203:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BL0PR11MB3203615F682415ABA33873258EF80@BL0PR11MB3203.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(346002)(376002)(396003)(39860400002)(13464003)(199004)(189003)(68736007)(6116002)(81156014)(3846002)(256004)(4326008)(81166006)(107886003)(8936002)(305945005)(7736002)(14444005)(26005)(102836004)(486006)(316002)(229853002)(99286004)(14454004)(54906003)(74316002)(8676002)(66066001)(6246003)(2906002)(186003)(71200400001)(7696005)(33656002)(446003)(64756008)(66574012)(476003)(53546011)(6506007)(76176011)(86362001)(966005)(66556008)(66476007)(73956011)(6436002)(6306002)(55016002)(66946007)(72206003)(9686003)(53936002)(11346002)(6916009)(76116006)(71190400001)(66446008)(478600001)(5660300002)(25786009)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR11MB3203;H:BL0PR11MB3251.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8ic3xS1huSqVBkbP3JURX12+tqpOKItHIdk5thz7nacOHKoIuo6mALZB8eTjlPMuNy7EDEd8whfubnWAKEh0iUqiVknZwCWBVT/mDH2b3l9SKSEs1HFeS+Tuka32+ytfAEJd7uUUXI1K983VOL7lg9cTy3yt0LVf+aUZhcyg4rBkcRsWP/QiKp/DKo9faq0Sr3PpJQlJ83fVndtEeKBakrA1LKddQhH8mU+HB9JOGmaA3xa+2cSKPPEShF6OeV+7HKTHHtxfPhDXVk+FdkPY71x9JtfSeJJqgQd3fvmnvrjb735vvAWdx4MUkqPtn8TzaFW27P1iTzCTQmIkwUsw6awEjtSQc4X9Pln5a5um9cEI880mlnOsa4h6Fr7MM7W6fttZ0UwIxoEsJyw3w0ZFI/HZMg+kQAqbXpppcqDWCAM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b0b6f04-483c-416c-32e5-08d6ff2f90d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 20:55:07.5919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yuiko.oshino@microchip.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3203
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>Sent: Tuesday, July 2, 2019 4:32 PM
>To: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>
>Cc: netdev@vger.kernel.org; Andrew Lunn <andrew@lunn.ch>; Florian Fainelli
><f.fainelli@gmail.com>; kernel@pengutronix.de; Heiner Kallweit
><hkallweit1@gmail.com>
>Subject: Re: net: micrel: confusion about phyids used in driver
>
>External E-Mail
>
>
>Hello Yuiko Oshino,
>
>On Fri, May 10, 2019 at 09:22:43AM +0200, Uwe Kleine-K=F6nig wrote:
>> On Thu, May 09, 2019 at 11:07:45PM +0200, Andrew Lunn wrote:
>> > On Thu, May 09, 2019 at 10:55:29PM +0200, Heiner Kallweit wrote:
>> > > On 09.05.2019 22:29, Uwe Kleine-K=F6nig wrote:
>> > > > I have a board here that has a KSZ8051MLL (datasheet:
>> > > > http://ww1.microchip.com/downloads/en/DeviceDoc/ksz8051mll.pdf,
>phyid:
>> > > > 0x0022155x) assembled. The actual phyid is 0x00221556.
>> > >
>> > > I think the datasheets are the source of the confusion. If the
>> > > datasheets for different chips list 0x0022155x as PHYID each, and
>> > > authors of support for additional chips don't check the existing
>> > > code, then happens what happened.
>> > >
>> > > However it's not a rare exception and not Microchip-specific that
>> > > sometimes vendors use the same PHYID for different chips.
>>
>> From the vendor's POV it is even sensible to reuse the phy IDs iff the
>> chips are "compatible".
>>
>> Assuming that the last nibble of the phy ID actually helps to
>> distinguish the different (not completely) compatible chips, we need
>> some more detailed information than available in the data sheets I have.
>> There is one person in the recipents of this mail with an
>> @microchip.com address (hint, hint!).
>
>can you give some input here or forward to a person who can?
>
>Best regards
>Uwe
>
>--
>Pengutronix e.K.                           | Uwe Kleine-K=F6nig           =
 |
>Industrial Linux Solutions                 | http://www.pengutronix.de/  |


Hello Uwe,

I forward this to the team.

Best regards,
Yuiko
