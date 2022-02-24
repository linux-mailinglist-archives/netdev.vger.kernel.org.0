Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7294C2E69
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbiBXO1i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Feb 2022 09:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbiBXO1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:27:37 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2253D66CA2
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 06:27:06 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-196-WFPNFewdOROHOFf201Jvtg-1; Thu, 24 Feb 2022 14:27:04 +0000
X-MC-Unique: WFPNFewdOROHOFf201Jvtg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Thu, 24 Feb 2022 14:27:02 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Thu, 24 Feb 2022 14:27:02 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Baoquan He' <bhe@redhat.com>, Christoph Hellwig <hch@lst.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>,
        "42.hyeyoo@gmail.com" <42.hyeyoo@gmail.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "iamjoonsoo.kim@lge.com" <iamjoonsoo.kim@lge.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "david@redhat.com" <david@redhat.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "michael@walle.cc" <michael@walle.cc>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "wsa@kernel.org" <wsa@kernel.org>
Subject: RE: [PATCH 1/2] dma-mapping: check dma_mask for streaming mapping
 allocs
Thread-Topic: [PATCH 1/2] dma-mapping: check dma_mask for streaming mapping
 allocs
Thread-Index: AQHYKYhjymqZSBR5G0e43mhWKNvBx6yiv4Mw
Date:   Thu, 24 Feb 2022 14:27:02 +0000
Message-ID: <1fead34bceda468cbe34077a28c4a4b1@AcuMS.aculab.com>
References: <20220219005221.634-22-bhe@redhat.com>
 <20220219071730.GG26711@lst.de> <20220220084044.GC93179@MiWiFi-R3L-srv>
 <20220222084530.GA6210@lst.de> <YhSpaGfiQV8Nmxr+@MiWiFi-R3L-srv>
 <20220222131120.GB10093@lst.de> <YhToFzlSufrliUsi@MiWiFi-R3L-srv>
 <20220222155904.GA13323@lst.de> <YhV/nabDa5zdNL/4@MiWiFi-R3L-srv>
 <20220223142555.GA5986@lst.de> <YheSBTJY216m6izG@MiWiFi-R3L-srv>
In-Reply-To: <YheSBTJY216m6izG@MiWiFi-R3L-srv>
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

From: Baoquan He
> Sent: 24 February 2022 14:11
...
> With my understanding, there are two kinds of DMA mapping, coherent
> mapping (which is also persistent mapping), and streaming mapping. The
> coherent mapping will be handled during driver init, and released during
> driver de-init. While streaming mapping will be done when needed at any
> time, and released after usage.

The lifetime has absolutely nothing to do with it.

It is all about how the DMA cycles (from the device) interact with
(or more don't interact with) the cpu memory cache.

For coherent mapping the cpu and device can write to (different)
words in the same cache line at the same time, and both will see
both updates.
On some systems this can only be achieved by making the memory
uncached - which significantly slows down cpu access.

For non-coherent (streaming) mapping the cpu writes back and/or
invalidates the data cache so that the dma read cycles from memory
read the correct data and the cpu re-reads the cache line after
the dma has completed.
They are only really suitable for data buffers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

