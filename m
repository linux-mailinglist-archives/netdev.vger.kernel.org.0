Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3924EBE6E
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 12:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245231AbiC3KNc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 30 Mar 2022 06:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242282AbiC3KNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 06:13:30 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54407165AA4
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 03:11:44 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-304-oB4kqtPMMA6uQJEujX6CkA-1; Wed, 30 Mar 2022 11:11:41 +0100
X-MC-Unique: oB4kqtPMMA6uQJEujX6CkA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Wed, 30 Mar 2022 11:11:39 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Wed, 30 Mar 2022 11:11:39 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xu Yilun' <yilun.xu@intel.com>, Michael Walle <michael@walle.cc>
CC:     Tom Rix <trix@redhat.com>, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
Thread-Topic: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
Thread-Index: AQHYRAJ8rIB0cQMH/kajVzJ0H3I8wazXtB2w
Date:   Wed, 30 Mar 2022 10:11:39 +0000
Message-ID: <5029cf18c9df4fab96af13c857d2e0ef@AcuMS.aculab.com>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
 <20220330065047.GA212503@yilunxu-OptiPlex-7050>
In-Reply-To: <20220330065047.GA212503@yilunxu-OptiPlex-7050>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Yilun
> Sent: 30 March 2022 07:51
> 
> On Tue, Mar 29, 2022 at 06:07:26PM +0200, Michael Walle wrote:
> > More and more drivers will check for bad characters in the hwmon name
> > and all are using the same code snippet. Consolidate that code by adding
> > a new hwmon_sanitize_name() function.
> >
> > Signed-off-by: Michael Walle <michael@walle.cc>
> > ---
> >  Documentation/hwmon/hwmon-kernel-api.rst |  9 ++++-
> >  drivers/hwmon/hwmon.c                    | 49 ++++++++++++++++++++++++
> >  include/linux/hwmon.h                    |  3 ++
> >  3 files changed, 60 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/hwmon/hwmon-kernel-api.rst b/Documentation/hwmon/hwmon-kernel-api.rst
> > index c41eb6108103..12f4a9bcef04 100644
> > --- a/Documentation/hwmon/hwmon-kernel-api.rst
> > +++ b/Documentation/hwmon/hwmon-kernel-api.rst
> > @@ -50,6 +50,10 @@ register/unregister functions::
> >
> >    void devm_hwmon_device_unregister(struct device *dev);
> >
> > +  char *hwmon_sanitize_name(const char *name);
> > +
> > +  char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
> > +
> >  hwmon_device_register_with_groups registers a hardware monitoring device.
> >  The first parameter of this function is a pointer to the parent device.
> >  The name parameter is a pointer to the hwmon device name. The registration
> > @@ -93,7 +97,10 @@ removal would be too late.
> >
> >  All supported hwmon device registration functions only accept valid device
> >  names. Device names including invalid characters (whitespace, '*', or '-')
> > -will be rejected. The 'name' parameter is mandatory.
> > +will be rejected. The 'name' parameter is mandatory. Before calling a
> > +register function you should either use hwmon_sanitize_name or
> > +devm_hwmon_sanitize_name to replace any invalid characters with an
> 
> I suggest                   to duplicate the name and replace ...

You are now going to get code that passed in NULL when the kmalloc() fails.
If 'sanitizing' the name is the correct thing to do then sanitize it
when the copy is made into the allocated structure.
(I'm assuming that the 'const char *name' parameter doesn't have to
be persistent - that would be another bug just waiting to happen.)

Seems really pointless to be do a kmalloc() just to pass a string
into a function.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

