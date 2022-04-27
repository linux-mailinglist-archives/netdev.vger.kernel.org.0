Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7BB511E4C
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241544AbiD0QHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241613AbiD0QGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:06:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE603CD58F
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651075384; x=1682611384;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3vek9OYIPrZhLzoVs6j4xikpv3L8ds38H3eGoph32LA=;
  b=ksmEB86YYqoZbbM6oZ4rpHQZHYQeupYr1GXkHHZBa8LMx2Gjh/sobXYf
   FxQFpM6Lt4/GOYgofYtKDR7+20IAijt52Cr8m2V51iKiSYmdnqQMKjPvM
   U03bPqYoGcr4c4hKZ0859ULX76MMLQXMjNk9fgX9tMm1NUpNkQ2ygiHVs
   V1+QOFX1NEU8qIEgWsa7wtWxbW9pOIPjR0YDz4qPrPlViHZb9c4N8f6tT
   +wDBpCZPkO+vk+d+3uRZ5UtA6kDKz78oHek+9Lo2XllJTVxuoseZ/1DHR
   3air40bjI6Id/SNebqifLGWwyJSWTHJe9YhNwMI8AKdA4hN9PsAY3vz7z
   w==;
X-IronPort-AV: E=Sophos;i="5.90,293,1643698800"; 
   d="scan'208";a="156993957"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2022 09:03:03 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 27 Apr 2022 09:03:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Wed, 27 Apr 2022 09:03:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0N7yvrCRs8wUCfwAMqewzeDOBG3CiwOk68VnyxBsn7LKVsxN9VrA41ESZlv8dxFH21BE2LnHeY1ULZjLAYdXruRwPn1yCoAHwHd+ZtCj1eXG6QQVtGeOpuOYMaCf2Q8gevrlYTOraBo87I1Fi4f4xXoqJXCSjk2e8cvHefRophmDazfZl28HN4nfbytpw27iJl9su3NDXqSVtbr7n4V5Xh18dXj3XXC8Y82N61snf9OQG3JHgULQG/Xdmb67q5HWF4uPweaD/KnV1E69E0k+d6REwOkoKQ+xfwmKHPi1f5oO0H+02j6SZ4ETlgNRQfNYAApgO9GrkNgHFx/A6fuLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgLJ7O4gLrAxVbvBHilk8LI+PWSOYP3XYuQITfLZz1g=;
 b=NnXe691BOj7ojKbtxbayQVnO+VvgKY0Kqyy1ZVUHlcQ2Nhdn0xM9T2rwNe/FVaUzg9npBL5JXtUcc2SKq1+CkXh7VurEKTyHucBF9C6fuQpejFXPGjH8u19BhMxqWy6xNrGk+R+pUa3Kc++Xr+s6ZcCBPi6XkK+6qsPhIOgV1mKefova5jaK9Z7hVXxjt5TC4/qxSQ6aUheCsQ89yhnQTmFb9sVVwhPeExmDkDMOo8s88gunUfw1AOPCiB0TtGk6i5hHeehc+/nOx0vDD1qViDeVYSe29S4pVqmgKsDVswUuFHWYlc7FbR3miKHx6DuC4sV6VSao1e9eK77sbrD+qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgLJ7O4gLrAxVbvBHilk8LI+PWSOYP3XYuQITfLZz1g=;
 b=tFhkhpSwUgi28qHZpcYHm3ErVbuTWZKJ5HbR3cQMODS7PVckAV5Vlaax2++GBjMZ9NP2oetbWtPZk3NRXPuMpqrADcFwuNUYph0rm0D5ZGs0EGX5N8ertmPwCaHZ+QYTSocYipksjF8SNK1cdDtZ1eazb7hb6yTYy2I0t0SJ3BI=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by BY5PR11MB4484.namprd11.prod.outlook.com (2603:10b6:a03:1c3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 27 Apr
 2022 16:02:56 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::251b:8192:8a6c:741b]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::251b:8192:8a6c:741b%6]) with mapi id 15.20.5206.013; Wed, 27 Apr 2022
 16:02:56 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <andrew@lunn.ch>
CC:     <Woojung.Huh@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <Ravi.Hegde@microchip.com>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next v2 1/2] net: phy: microchip: update LAN88xx phy
 ID and phy ID mask.
Thread-Topic: [PATCH net-next v2 1/2] net: phy: microchip: update LAN88xx phy
 ID and phy ID mask.
Thread-Index: AQHYWjEjMSibiwm9nEK9Mtud/XfbGq0D5NGAgAABvQA=
Date:   Wed, 27 Apr 2022 16:02:56 +0000
Message-ID: <CH0PR11MB5561E9C01C5500D6301E43728EFA9@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <20220427121957.13099-1-yuiko.oshino@microchip.com>
 <20220427121957.13099-2-yuiko.oshino@microchip.com>
 <YmljDTD9j3REqi47@lunn.ch>
In-Reply-To: <YmljDTD9j3REqi47@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48be8f4e-851a-4eea-6016-08da286764bc
x-ms-traffictypediagnostic: BY5PR11MB4484:EE_
x-microsoft-antispam-prvs: <BY5PR11MB448428B9F7EDB1DD80949FE48EFA9@BY5PR11MB4484.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2jqEuvA+fL1/k+1IRUJ6/O+ACRGrW2KmBUBNY/cKPEoCKByzu9uxnZ1R+gcypCJ45MDMB7KK5owLmEEddSZXF97YIT4xVdqkiFELzjYik8+LD3i4U8PDlD3ru+mdZQjnHfkVadxoSL5OHQS5l4WIHzai5sTFPjO1wZxrqQndh+zC52dMb/6Y4FbD/dpF+QaHHL+GoGxD6CBoOtjG4ggK6YP9WNOUEPE9heC/XF+441PDz/9jj0YZt7P9AYGveg5cp0hPgHaVmhzh0KRt17ulwxnmL1dpeVXfEL/R26qRwXPcfSiBTZjAiDcEg0WQYKuG8APPaRaSQ50OkXsAwDEODDdNORszhXiyOqsC371vqCvl4s5xR8Z+ifo4xR1IJQIJUlrFfZR5S4dLN4lLJybx/quiRUglWAX+X+prQu5PCYvXuRcthyAIRL5TgYg13SzeKf8pDU+EEJCxsO0YH6HeuXGDbEgQDDWZd6LCPZnCjaszFupz98F3aUBlJm+DTpYOHJJYMVhDvL2GtI1XhbGnCdLReSbWf4Zax2iftbOat0VTukTVlcFBKfTfxFZKKBW/4CTl/RrIfBqGmiAd6qVUAViTAK4vTDXoGcQuO4V+l+NktqPbxseNiIjX1QQoIc+JI8m6vRXrK0s8a02IV9CBDZU0MLuL9dxv+LKwZJdTIoCmPcTSeq2jTbSOnELW2dn3rdcVtYm4Q1tOjvq9muShAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(4326008)(66946007)(76116006)(71200400001)(8676002)(2906002)(122000001)(38100700002)(7696005)(33656002)(54906003)(6916009)(508600001)(15650500001)(55016003)(316002)(6506007)(83380400001)(66556008)(66446008)(64756008)(66476007)(5660300002)(186003)(86362001)(26005)(9686003)(8936002)(52536014)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OqmgFQAPlZ2VE0DoH+yd7H0fY/5dMPeBYQuC0MT2KEaxRPW5L0SxruXJ65Ek?=
 =?us-ascii?Q?volfA3xUK1YmDxvhFEIt/nzf/P4BhJDL6tPTEN+mrkDk58nSwNZmwZYU1hhr?=
 =?us-ascii?Q?RFtKJhijh2VzHsX7KFw80hYdwNMIYy/a6VD2l5omXFU3lvcieulFL5eWva1V?=
 =?us-ascii?Q?hu6YNftzuuS9EWVsnkQbRbQCqsyrcbSOK1PNz7//AOcUlMZ0Hnfq+DnpSjly?=
 =?us-ascii?Q?nm1g4I37UfE1GL+zgTyThYSP5/Ld+EZ9K4fwJF89s449wvgCfvk6k8RAvG8j?=
 =?us-ascii?Q?u6Ixq4w5vx32V95TpoM95WCn+WPRJHYVqNG2QGodx57fxUPZxXZ5mW4yw6kF?=
 =?us-ascii?Q?QsCpI4LTwTo3zlfhr6UheNOLgFT4fWoqxrFsqJpzLoxlWx6vqjVHnS5RvKlx?=
 =?us-ascii?Q?q4ZWzQ0rckm2pa3PZj2RH48vuOfh0OAtmLKSflQLLbJSso9JdBPRsvhoeHdn?=
 =?us-ascii?Q?TkOsHgwEsIesxmxU11xrndiZujDQZ8UddrTIF1NQCyu/Z3TG599VXCjDYcSA?=
 =?us-ascii?Q?hqsugjeGgDQ+GBMk7I42GwvqFU+HDxu/7k7Ah/tmep2TA6Qq+a3/iH3Wtd4R?=
 =?us-ascii?Q?++7aenTtnh3iiqhynnxH3S2TWorPGiydMIy7OnVwUhiWz0LPdY1785gCQgP/?=
 =?us-ascii?Q?JOSZqVvwz0KK9kXI80VgupEg5MZXQpZFh1K3kWTcIXYfhAGPKkYtaj43BEdS?=
 =?us-ascii?Q?kc6Dtyh5wY/HQbw8RQhts9RAs1bjwt8Lg691h/OfSbupIqqxaRBUCtSuPArv?=
 =?us-ascii?Q?CnJkR4/s3e//AD9o6LcqHZ8/zjhyf03KkiTu5AhK+p+FDLNI4N4zz578OEya?=
 =?us-ascii?Q?zzqwajzpT6jxafCR4cNIa3KS/vFkfUje+8Wo7gtxaUukCqSZdaSux3UZg0x/?=
 =?us-ascii?Q?ofJjvDM9fev6anEsPOQ1Txr1KIwlJPILCYxhcZiECKn8haSvWkjhohCD11kZ?=
 =?us-ascii?Q?LveU7vSHw9+mC7FXMzJmkp1/jCYOIuBb3qHnW3lMQDhD3zS7+H15j8NIcgTk?=
 =?us-ascii?Q?KhFzacxNWv5MjXfoUbvhJ2TnE0xIDoxLsoSSW3Xcr5R1ez3QVDTa2iz4Rn9n?=
 =?us-ascii?Q?U2ac2oIIR1D2mBZBAC9X7Wa2RlWQYLPTB4v6MyiwFbBjkXvgHsruef2WUU51?=
 =?us-ascii?Q?ZKVVuQ0VOzipARjwFapuzLO1sk2TSJyQVZk73IU9EG4NswMMgAHoTPe/wd79?=
 =?us-ascii?Q?D7Vte4q/494f1N5EJfbJhrKs6u4lbNaPi6qJo7nyxoD5fOqoFNEc37DcdVxV?=
 =?us-ascii?Q?Ad/HwF6f+2iW465adI9wZ3u20O9arVqdQ+VKwItpKYPbgi7MdfN/NeWCG3yi?=
 =?us-ascii?Q?4W6WltiV2hoIRFAii0506VpQM/28haUUH+U+zWrRVK8bgvhR5lT4HpPV7hW8?=
 =?us-ascii?Q?im0NhFaEViMnWhTFIWUSOfvbZrqMi42EVk5THy5NxPOnNt0XDwn7/q89aSc8?=
 =?us-ascii?Q?HG/QfrZ4vlCIOyD8yrZfo6l5m2IiaW8tGk9uijfhkjuqh1kUu/alxwtIPu77?=
 =?us-ascii?Q?ppUQlTtrb1/gDftUfiUn4HTlDdD8lmYkvDyWxwK3hFQb5GhzXNSIO/ZVT5pQ?=
 =?us-ascii?Q?xF3bfh8cBShdoOLln/0/MgxYDYvZayoI04mFFJs6oaBpt+mI+GfJdpHo5ArQ?=
 =?us-ascii?Q?TQKlHiypZxbG8EWoJcmlsbFwuf6xLbCD9ERUR/iWHjxZ/S7SeUqWbI2K7Pl4?=
 =?us-ascii?Q?qUiXZY6l878CuKMVOgTHy+CaH+7dSJn9mkdkH+hrRx1eRETd1wAwYmpI0U0/?=
 =?us-ascii?Q?lv+5Qgpcd9p2QDkyi169tVx6gf38NP0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48be8f4e-851a-4eea-6016-08da286764bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2022 16:02:56.2687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dVQDDFYXLPn5FPDXYjqLy8wm6fKdXt97Y1I3x+inQpMWeOr5PmOltQldFe3bI8bLCsyPNgOwbrDPHGGmu8/2csI8w7hOgvRaxkHO5wxKAk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4484
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Wednesday, April 27, 2022 11:37 AM
>To: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>
>Cc: Woojung Huh - C21699 <Woojung.Huh@microchip.com>;
>davem@davemloft.net; netdev@vger.kernel.org; Ravi Hegde - C21689
><Ravi.Hegde@microchip.com>; UNGLinuxDriver
><UNGLinuxDriver@microchip.com>
>Subject: Re: [PATCH net-next v2 1/2] net: phy: microchip: update LAN88xx p=
hy ID
>and phy ID mask.
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>content is safe
>
>On Wed, Apr 27, 2022 at 05:19:56AM -0700, Yuiko Oshino wrote:
>> update LAN88xx phy ID and phy ID mask because the existing code conflict=
s
>with the LAN8742 phy.
>>
>> The current phy IDs on the available hardware.
>>         LAN8742 0x0007C130, 0x0007C131
>>         LAN88xx 0x0007C132
>>
>> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
>> ---
>>  drivers/net/phy/microchip.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
>> index 9f1f2b6c97d4..131caf659ed2 100644
>> --- a/drivers/net/phy/microchip.c
>> +++ b/drivers/net/phy/microchip.c
>> @@ -344,8 +344,8 @@ static int lan88xx_config_aneg(struct phy_device
>> *phydev)
>>
>>  static struct phy_driver microchip_phy_driver[] =3D {  {
>> -     .phy_id         =3D 0x0007c130,
>> -     .phy_id_mask    =3D 0xfffffff0,
>> +     .phy_id         =3D 0x0007c132,
>> +     .phy_id_mask    =3D 0xfffffff2,
>
>Just so my comment on the previous version does not get lost, is this the =
correct
>mask, because it is very odd. I think you really want 0xfffffffe?
>
>    Andrew

Hi Andrew,

thank you for your review.
Yes, 0xfffffff2 is correct for us.
We would like to have bits for future revisions of the hardware without upd=
ating the driver source code in the future.
If we use 0xfffffffe, then we need to submit a patch again when we have a n=
ew hardware revision.

Yuiko
