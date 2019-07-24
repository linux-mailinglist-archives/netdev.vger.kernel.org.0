Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895B772C90
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 12:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfGXKtN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Jul 2019 06:49:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:42485 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbfGXKtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 06:49:13 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-121-dikV7mLRPNyB2jXUZsVXMg-1; Wed, 24 Jul 2019 11:49:04 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 24 Jul 2019 11:49:03 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 24 Jul 2019 11:49:03 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Matthew Wilcox' <willy@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "hch@lst.de" <hch@lst.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 6/7] net: Rename skb_frag_t size to bv_len
Thread-Topic: [PATCH v3 6/7] net: Rename skb_frag_t size to bv_len
Thread-Index: AQHVQQPzRKSNHLNiIkGUqQyrlPNCQabZl3pQ
Date:   Wed, 24 Jul 2019 10:49:03 +0000
Message-ID: <b47b0b19e5594b97af62352dc0dbffcc@AcuMS.aculab.com>
References: <20190723030831.11879-1-willy@infradead.org>
 <20190723030831.11879-7-willy@infradead.org>
In-Reply-To: <20190723030831.11879-7-willy@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: dikV7mLRPNyB2jXUZsVXMg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox
> Sent: 23 July 2019 04:09
> Improved compatibility with bvec
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/skbuff.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 8076e2ba8349..e849e411d1f3 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -312,7 +312,7 @@ typedef struct skb_frag_struct skb_frag_t;
> 
>  struct skb_frag_struct {
>  	struct page *bv_page;
> -	__u32 size;
> +	unsigned int bv_len;
>  	__u32 page_offset;
>  };

This is 'just plain stupid'.
The 'bv_' prefix of the members of 'struct bvec' is there so that 'grep'
(etc) can be used to find the uses of the members.

In a 'struct skb_frag_struct' a sensible prefix might be 'sf_'.

OTOH it might be sensible to use (or embed) a 'struct bvec'
instead of 'skb_frag_struct'.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

