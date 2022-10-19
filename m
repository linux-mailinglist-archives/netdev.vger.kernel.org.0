Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE010603B0D
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 10:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiJSIBW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Oct 2022 04:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiJSIBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 04:01:19 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3F579A76
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 01:01:18 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-241-WaNyEYqdNq6hso3JXfeYOA-1; Wed, 19 Oct 2022 09:01:15 +0100
X-MC-Unique: WaNyEYqdNq6hso3JXfeYOA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 19 Oct
 2022 09:01:13 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Wed, 19 Oct 2022 09:01:13 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andy Shevchenko' <andriy.shevchenko@linux.intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: RE: [PATCH] wifi: rt2x00: use explicitly signed type for clamping
Thread-Topic: [PATCH] wifi: rt2x00: use explicitly signed type for clamping
Thread-Index: AQHY4zYIcJpfOcwDCEuT6Ou0/5HWoa4VWgQQ
Date:   Wed, 19 Oct 2022 08:01:13 +0000
Message-ID: <0ca418f756a94859a6d32325c063f2a5@AcuMS.aculab.com>
References: <202210190108.ESC3pc3D-lkp@intel.com>
 <20221018202734.140489-1-Jason@zx2c4.com>
 <Y08PVnsTw75sHfbg@smile.fi.intel.com> <Y08SGz/xGSN87ynk@zx2c4.com>
 <Y08TQwcY3zL3kGHR@smile.fi.intel.com>
 <CAHmME9qQAqXYR0+K=32otECgrni51Z0c38iO3h1VRM4Xf3o2=Q@mail.gmail.com>
 <Y08WL6kcTH4uehHx@smile.fi.intel.com>
In-Reply-To: <Y08WL6kcTH4uehHx@smile.fi.intel.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko
> Sent: 18 October 2022 22:10
....
> It's not a hot path as far as I understand and keeping data types aligned seems
> to me worth it even if codegen is changed. IS it so awful with short?

(without looking at the generated code)
Why is it even short, what is wrong with int?
It is extremely unlikely that the code requires any
calculation results be masked to 8 (or 16) bits, but
using s8 or s16 requires the compiler emit code to mask
any calculated values.

Remember, all C arithmetic requires promoting the values
to (at least) int.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

