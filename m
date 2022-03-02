Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EB24CA716
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 15:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242599AbiCBOFJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Mar 2022 09:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242674AbiCBOFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 09:05:05 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7A5B8933A
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 06:04:18 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-196-4Li6Fux3PdyQ14Lo-DMf3A-1; Wed, 02 Mar 2022 14:04:10 +0000
X-MC-Unique: 4Li6Fux3PdyQ14Lo-DMf3A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Wed, 2 Mar 2022 14:04:06 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Wed, 2 Mar 2022 14:04:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xiaomeng Tong' <xiam0nd.tong@gmail.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "bjohannesmeyer@gmail.com" <bjohannesmeyer@gmail.com>,
        "c.giuffrida@vu.nl" <c.giuffrida@vu.nl>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "h.j.bos@vu.nl" <h.j.bos@vu.nl>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jakobkoschel@gmail.com" <jakobkoschel@gmail.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
        <kgdb-bugreport@lists.sourceforge.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "v9fs-developer@lists.sourceforge.net" 
        <v9fs-developer@lists.sourceforge.net>
Subject: RE: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Thread-Topic: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Thread-Index: AQHYLhg9+DU/OogLf0+tiSFmjztyUKysHu+Q
Date:   Wed, 2 Mar 2022 14:04:06 +0000
Message-ID: <1077f17e50d34dc2bbfdf4e52a1cb2fd@AcuMS.aculab.com>
References: <CAHk-=whLK11HyvpUtEftOjc3Gup2V77KpAQ2fycj3uai=qceHw@mail.gmail.com>
 <20220302093106.8402-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220302093106.8402-1-xiam0nd.tong@gmail.com>
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
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaomeng Tong
> Sent: 02 March 2022 09:31
> 
> On Mon, 28 Feb 2022 16:41:04 -0800, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But basically to _me_, the important part is that the end result is
> > maintainable longer-term.
> 
> I couldn't agree more. And because of that, I stick with the following
> approach because it's maintainable longer-term than "type(pos) pos" one:
>  Implements a new macro for each list_for_each_entry* with _inside suffix.
>   #define list_for_each_entry_inside(pos, type, head, member)

I think that it would be better to make any alternate loop macro
just set the variable to NULL on the loop exit.
That is easier to code for and the compiler might be persuaded to
not redo the test.

It also doesn't need an extra variable defined in the for() statement
so can be back-ported to older kernels without required declaration
in the middle of blocks.

OTOH there may be alternative definitions that can be used to get
the compiler (or other compiler-like tools) to detect broken code.
Even if the definition can't possibly generate a working kerrnel.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

