Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FED04BF45E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 10:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiBVJHU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Feb 2022 04:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiBVJHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 04:07:19 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD048148667
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 01:06:53 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-308-GmoSOj60Pgiu_y5_NLHrDQ-1; Tue, 22 Feb 2022 09:06:50 +0000
X-MC-Unique: GmoSOj60Pgiu_y5_NLHrDQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Tue, 22 Feb 2022 09:06:49 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Tue, 22 Feb 2022 09:06:48 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>
CC:     Baoquan He <bhe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>,
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
Subject: RE: [PATCH 22/22] mtd: rawnand: Use dma_alloc_noncoherent() for dma
 buffer
Thread-Topic: [PATCH 22/22] mtd: rawnand: Use dma_alloc_noncoherent() for dma
 buffer
Thread-Index: AQHYJ8i+SkBT2V8OuE+2tEasDwiwNayfRZ0Q
Date:   Tue, 22 Feb 2022 09:06:48 +0000
Message-ID: <fe8deb6dd0b44a8a839820747451c37c@AcuMS.aculab.com>
References: <20220219005221.634-1-bhe@redhat.com>
 <20220219005221.634-23-bhe@redhat.com> <20220219071900.GH26711@lst.de>
 <YhDSAJG+LksZSnLP@ip-172-31-19-208.ap-northeast-1.compute.internal>
 <20220222084652.GB6210@lst.de>
In-Reply-To: <20220222084652.GB6210@lst.de>
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
> Sent: 22 February 2022 08:47
...
> > Hmm.. for this specific case, What about allocating two buffers
> > for DMA_TO_DEVICE and DMA_FROM_DEVICE at initialization time?
> 
> That will work, but I don't see the benefit as you'd still need to call
> dma_sync_single* before and after each data transfer.

For systems with an iommu that should save all the iommu setup
for every transfer.
I'd also guess that it saves worrying about the error path
when the dma_map fails (eg because the iommu has no space).

OTOH the driver would be 'hogging' iommu space, so maybe
allocate during open() (or equivalent).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

