Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DF94C15ED
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241844AbiBWO6E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 23 Feb 2022 09:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241902AbiBWO6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:58:02 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C180D5C670
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:57:31 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-93-G1szcwt_MjKPdsB-XVT1DQ-1; Wed, 23 Feb 2022 14:57:29 +0000
X-MC-Unique: G1szcwt_MjKPdsB-XVT1DQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Wed, 23 Feb 2022 14:57:26 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Wed, 23 Feb 2022 14:57:26 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>, Baoquan He <bhe@redhat.com>
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
Thread-Index: AQHYKMFGymqZSBR5G0e43mhWKNvBx6yhN5Ag
Date:   Wed, 23 Feb 2022 14:57:26 +0000
Message-ID: <4771de3911c24966b01fef9cf43f2d33@AcuMS.aculab.com>
References: <20220219005221.634-1-bhe@redhat.com>
 <20220219005221.634-22-bhe@redhat.com> <20220219071730.GG26711@lst.de>
 <20220220084044.GC93179@MiWiFi-R3L-srv> <20220222084530.GA6210@lst.de>
 <YhSpaGfiQV8Nmxr+@MiWiFi-R3L-srv> <20220222131120.GB10093@lst.de>
 <YhToFzlSufrliUsi@MiWiFi-R3L-srv> <20220222155904.GA13323@lst.de>
 <YhV/nabDa5zdNL/4@MiWiFi-R3L-srv> <20220223142555.GA5986@lst.de>
In-Reply-To: <20220223142555.GA5986@lst.de>
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

From: Christoph Hellwig
> Sent: 23 February 2022 14:26
> 
> On Wed, Feb 23, 2022 at 08:28:13AM +0800, Baoquan He wrote:
> > Could you tell more why this is wrong? According to
> > Documentation/core-api/dma-api.rst and DMA code, __dma_alloc_pages() is
> > the core function of dma_alloc_pages()/dma_alloc_noncoherent() which are
> > obviously streaming mapping,
> 
> Why are they "obviously" streaming mappings?
> 
> > why do we need to check
> > dev->coherent_dma_mask here? Because dev->coherent_dma_mask is the subset
> > of dev->dma_mask, it's safer to use dev->coherent_dma_mask in these
> > places? This is confusing, I talked to Hyeonggon in private mail, he has
> > the same feeling.
> 
> Think of th coherent_dma_mask as dma_alloc_mask.  It is the mask for the
> DMA memory allocator.  dma_mask is the mask for the dma_map_* routines.

I suspect it is all to allow for things like:
- A 64bit system with memory above 4G.
- A device that can only generate 32bit addresses.
- Some feature of the memory system (or bus bridges) that restricts
  cache snooping to the low 1G of address space.

So dma_alloc_coherent() has to allocate memory below 1G.
The dma_map functions have to use bounce-buffers for addresses
  above 4G.
dma_alloc_noncoherent() can allocate anything below 4G and so
  avoid bounce buffers later on.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

