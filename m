Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D85D4942FE
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 23:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357540AbiASWZM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jan 2022 17:25:12 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:58939 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357528AbiASWZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 17:25:05 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-3-gc2FjgmsNLmz-uRweWCGWA-1; Wed, 19 Jan 2022 22:25:02 +0000
X-MC-Unique: gc2FjgmsNLmz-uRweWCGWA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Wed, 19 Jan 2022 22:25:00 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Wed, 19 Jan 2022 22:25:00 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andy Shevchenko' <andy.shevchenko@gmail.com>
CC:     'Steven Rostedt' <rostedt@goodmis.org>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        =?iso-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>, Eryk Brol <eryk.brol@amd.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "Raju Rangoju" <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: RE: [PATCH 1/3] lib/string_helpers: Consolidate yesno()
 implementation
Thread-Topic: [PATCH 1/3] lib/string_helpers: Consolidate yesno()
 implementation
Thread-Index: AQHYDUVmV8sHy8JfXU2yTPkp1VbmK6xqitzAgAAAVLCAAC4ygIAAMm1Q
Date:   Wed, 19 Jan 2022 22:25:00 +0000
Message-ID: <2978e422e33f48f0bd07d937cdab13a5@AcuMS.aculab.com>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <20220119072450.2890107-2-lucas.demarchi@intel.com>
 <CAHp75Vf5QOD_UtDK8VbxNApEBuJvzUic0NkzDNmRo3Q7Ud+=qw@mail.gmail.com>
 <20220119100102.61f9bfde@gandalf.local.home>
 <06420a70f4434c2b8590cc89cad0dd6a@AcuMS.aculab.com>
 <9c26ca9bf75d494ea966059d9bcbc2b5@AcuMS.aculab.com>
 <YehlEe1prbwhxZEv@smile.fi.intel.com>
In-Reply-To: <YehlEe1prbwhxZEv@smile.fi.intel.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > except '"no\0\0yes" + v * 4' works a bit better.
> 
> Is it a C code obfuscation contest?

That would be:
	return &(v * 3)["no\0yes"];

:-)

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

