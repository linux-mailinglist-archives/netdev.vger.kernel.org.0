Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E229174EB
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 11:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfEHJT4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 May 2019 05:19:56 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:49363 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbfEHJT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 05:19:56 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-20-fr8XoZJNPVSqTqULhvI6mg-1; Wed, 08 May 2019 10:19:52 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Wed,
 8 May 2019 10:19:51 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 8 May 2019 10:19:51 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alastair D'Silva' <alastair@au1.ibm.com>,
        "alastair@d-silva.org" <alastair@d-silva.org>
CC:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jose Abreu" <Jose.Abreu@synopsys.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Stanislaw Gruszka" <sgruszka@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        "Enric Balletbo i Serra" <enric.balletbo@collabora.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: RE: [PATCH v2 4/7] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Thread-Topic: [PATCH v2 4/7] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Thread-Index: AQHVBWwP4v5z/92cRUaSHokPgMaM4aZg8Maw
Date:   Wed, 8 May 2019 09:19:51 +0000
Message-ID: <c98a499a4e824bcd824d5ad53d037c67@AcuMS.aculab.com>
References: <20190508070148.23130-1-alastair@au1.ibm.com>
 <20190508070148.23130-5-alastair@au1.ibm.com>
In-Reply-To: <20190508070148.23130-5-alastair@au1.ibm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: fr8XoZJNPVSqTqULhvI6mg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alastair D'Silva
> Sent: 08 May 2019 08:02
> To: alastair@d-silva.org
...
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -480,13 +480,13 @@ enum {
>  	DUMP_PREFIX_OFFSET
>  };
> 
> -extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
> -			      int groupsize, char *linebuf, size_t linebuflen,
> -			      bool ascii);
> -
>  #define HEXDUMP_ASCII			(1 << 0)
>  #define HEXDUMP_SUPPRESS_REPEATED	(1 << 1)

These ought to be BIT(0) and BIT(1)

> +extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
> +			      int groupsize, char *linebuf, size_t linebuflen,
> +			      u64 flags);

Why 'u64 flags' ?
How many flags do you envisage ??
Your HEXDUMP_ASCII (etc) flags are currently signed values and might
get sign extended causing grief.
'unsigned int flags' is probably sufficient.

I've not really looked at the code, it seems OTT in places though.

If someone copies it somewhere where the performance matters
(I've user space code which is dominated by its tracing!)
then you don't want all the function calls and conditionals
even if you want some of the functionality.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

