Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB6464728E
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLHPMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiLHPL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:11:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CABF45ECA
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670512262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z7QM7VnSXhYRErVFWrMtPHxAXgKBFpUIn8aruAsuTMU=;
        b=CrQx0qHT+SIelfbyZz5D+/GaUeybSRbLVPgxOesl8FErC7j7GTFSLAKg4aP5Qk/wyh5zOk
        Uo6FwQ3/oFJv3A+TUigX5xWImSjs2pZWkj7OB1h6nxF5hDOQbxuFwy+Dc54Hn91OrSDDyk
        Zw7fGqLnIGKmOjdteg/xsuAwzqFZmSU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-142-PCWLpYWzO8GgTvwrW7P3Kw-1; Thu, 08 Dec 2022 10:11:00 -0500
X-MC-Unique: PCWLpYWzO8GgTvwrW7P3Kw-1
Received: by mail-ed1-f72.google.com with SMTP id g14-20020a056402090e00b0046790cd9082so1086668edz.21
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 07:11:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:to:content-language:subject:cc:user-agent
         :mime-version:date:message-id:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z7QM7VnSXhYRErVFWrMtPHxAXgKBFpUIn8aruAsuTMU=;
        b=DxiwDvkIIVVe1t1JEFKWPqbf0Oq2py8QXKSB90/QjdbKEerjAWA1qKVtOtsosEXzNO
         hQ5XJ/SO2BJOxqv7hc+RsV130jDQ2Ku5bsdUu/AZ1H5NcF82MNfEKcNwFGzScJsVccVp
         ARzc9a2FL/gf313VzkNFqrBz+5EO1Yluguykv0dFdPN1H3WT80yK3aTYgxquX05VIHmf
         ZeJoLxQALZxeLIcWiC6NhFdUBZ7s7n51NYUf7/rPAZgZmJ3laWNLRdNntgKuh+mlqiIu
         A7FKOR1pgE2YxIkk8TDVVpO8eTNe91MUhaLrQuKNBLrNOO8UG288WhkPKqszi5KIm3Ie
         7rCQ==
X-Gm-Message-State: ANoB5pmxGFhwlDsRKUnnqclbxbmzFQaPbvtd/b9wCkanK+ua9wbymja3
        RXq89AJxxKCa7u816fdLcBwwIRKkS/xi6Bnbz11y3hQ0HoFviVWYCcW9aYX7nw1Kbcxkx7CLiAN
        Rohf822kU/VHqnGT7
X-Received: by 2002:a17:907:a642:b0:78d:f459:716f with SMTP id vu2-20020a170907a64200b0078df459716fmr2934190ejc.26.1670512259448;
        Thu, 08 Dec 2022 07:10:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5IGUZ5lODuEXEkdl2sifutp1yzBSbWNlQQMCsSoX5qjQsBxqxpoOb+IGlUPhytcgMBjKSfAw==
X-Received: by 2002:a17:907:a642:b0:78d:f459:716f with SMTP id vu2-20020a170907a64200b0078df459716fmr2934176ejc.26.1670512259236;
        Thu, 08 Dec 2022 07:10:59 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id 12-20020a170906300c00b007c10d47e748sm3084109ejz.36.2022.12.08.07.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 07:10:58 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: multipart/mixed; boundary="------------YEHMoPqAHhhES2QDvyijB1bA"
Message-ID: <9153be2e-76bc-3760-be31-4f0f96acd38c@redhat.com>
Date:   Thu, 8 Dec 2022 16:10:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 26/26] mlx5: Convert to netmem
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20221130220803.3657490-1-willy@infradead.org>
 <20221206160537.1092343-2-willy@infradead.org>
In-Reply-To: <20221206160537.1092343-2-willy@infradead.org>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------YEHMoPqAHhhES2QDvyijB1bA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 06/12/2022 17.05, Matthew Wilcox (Oracle) wrote:
> Use the netmem APIs instead of the page_pool APIs.  Possibly we should
> add a netmem equivalent of skb_add_rx_frag(), but that can happen
> later.  Saves one call to compound_head() in the call to put_page()
> in mlx5e_page_release_dynamic() which saves 58 bytes of text.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  10 +-
>   .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   4 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  23 ++--
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   2 +-
>   .../net/ethernet/mellanox/mlx5/core/en_main.c |  12 +-
>   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 130 +++++++++---------
>   6 files changed, 93 insertions(+), 88 deletions(-)

This doesn't compile... patch that fix this is attached.
(I've boot it, but not run any mlx5 XDP tests, yet)

--Jesper

--------------YEHMoPqAHhhES2QDvyijB1bA
Content-Type: text/plain; charset=UTF-8; name="27-mlx5-fix"
Content-Disposition: attachment; filename="27-mlx5-fix"
Content-Transfer-Encoding: base64

bWx4NTogZml4IHVwIHBhdGNoCgpGcm9tOiBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIDxicm91
ZXJAcmVkaGF0LmNvbT4KClNpZ25lZC1vZmYtYnk6IEplc3BlciBEYW5nYWFyZCBCcm91ZXIg
PGJyb3VlckByZWRoYXQuY29tPgotLS0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbi90eHJ4LmggfCAgICAyICstCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMgIHwgICAgMyArKy0KIDIgZmlsZXMgY2hhbmdl
ZCwgMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi90eHJ4LmggYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdHhyeC5oCmluZGV4IGFhMjMx
ZDk2YzUyYy4uNjg4ZDNlYTlhYTM2IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdHhyeC5oCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbi90eHJ4LmgKQEAgLTY1LDcgKzY1LDcgQEAgaW50
IG1seDVlX25hcGlfcG9sbChzdHJ1Y3QgbmFwaV9zdHJ1Y3QgKm5hcGksIGludCBidWRnZXQp
OwogaW50IG1seDVlX3BvbGxfaWNvX2NxKHN0cnVjdCBtbHg1ZV9jcSAqY3EpOwogCiAvKiBS
WCAqLwotdm9pZCBtbHg1ZV9wYWdlX2RtYV91bm1hcChzdHJ1Y3QgbWx4NWVfcnEgKnJxLCBz
dHJ1Y3QgbmV0bWVtICpubWVtKTsKK3ZvaWQgbWx4NWVfbm1lbV9kbWFfdW5tYXAoc3RydWN0
IG1seDVlX3JxICpycSwgc3RydWN0IG5ldG1lbSAqbm1lbSk7CiB2b2lkIG1seDVlX3BhZ2Vf
cmVsZWFzZV9keW5hbWljKHN0cnVjdCBtbHg1ZV9ycSAqcnEsIHN0cnVjdCBuZXRtZW0gKm5t
ZW0sIGJvb2wgcmVjeWNsZSk7CiBJTkRJUkVDVF9DQUxMQUJMRV9ERUNMQVJFKGJvb2wgbWx4
NWVfcG9zdF9yeF93cWVzKHN0cnVjdCBtbHg1ZV9ycSAqcnEpKTsKIElORElSRUNUX0NBTExB
QkxFX0RFQ0xBUkUoYm9vbCBtbHg1ZV9wb3N0X3J4X21wd3FlcyhzdHJ1Y3QgbWx4NWVfcnEg
KnJxKSk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW4veGRwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW4veGRwLmMKaW5kZXggOGU5MTM2MzgxNTkyLi44NzhlNGU5ZjBmOGIgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94ZHAuYwor
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMK
QEAgLTMyLDYgKzMyLDcgQEAKIAogI2luY2x1ZGUgPGxpbnV4L2JwZl90cmFjZS5oPgogI2lu
Y2x1ZGUgPG5ldC94ZHBfc29ja19kcnYuaD4KKyNpbmNsdWRlICJlbi90eHJ4LmgiCiAjaW5j
bHVkZSAiZW4veGRwLmgiCiAjaW5jbHVkZSAiZW4vcGFyYW1zLmgiCiAKQEAgLTE4MCw3ICsx
ODEsNyBAQCBib29sIG1seDVlX3hkcF9oYW5kbGUoc3RydWN0IG1seDVlX3JxICpycSwgc3Ry
dWN0IG5ldG1lbSAqbm1lbSwKIAkJX19zZXRfYml0KE1MWDVFX1JRX0ZMQUdfWERQX1hNSVQs
IHJxLT5mbGFncyk7CiAJCV9fc2V0X2JpdChNTFg1RV9SUV9GTEFHX1hEUF9SRURJUkVDVCwg
cnEtPmZsYWdzKTsKIAkJaWYgKHhkcC0+cnhxLT5tZW0udHlwZSAhPSBNRU1fVFlQRV9YU0tf
QlVGRl9QT09MKQotCQkJbWx4NWVfcGFnZV9kbWFfdW5tYXAocnEsIG5tZW0pOworCQkJbWx4
NWVfbm1lbV9kbWFfdW5tYXAocnEsIG5tZW0pOwogCQlycS0+c3RhdHMtPnhkcF9yZWRpcmVj
dCsrOwogCQlyZXR1cm4gdHJ1ZTsKIAlkZWZhdWx0Ogo=

--------------YEHMoPqAHhhES2QDvyijB1bA--

