Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0114CB374
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 01:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiCCAL0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Mar 2022 19:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiCCALY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 19:11:24 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CA7C15A11
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 16:10:40 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-9-TaJDYF8zPkim1JgaaMOOTA-1; Thu, 03 Mar 2022 00:10:37 +0000
X-MC-Unique: TaJDYF8zPkim1JgaaMOOTA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Thu, 3 Mar 2022 00:10:36 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Thu, 3 Mar 2022 00:10:36 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Krzysztof Kozlowski' <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RESEND PATCH v2 4/6] nfc: llcp: use test_bit()
Thread-Topic: [RESEND PATCH v2 4/6] nfc: llcp: use test_bit()
Thread-Index: AQHYLmtWg0E/2bVm5kqjDz1/h/f2VKysyObA
Date:   Thu, 3 Mar 2022 00:10:36 +0000
Message-ID: <7fc4cb250bb8406cadf80649e366b249@AcuMS.aculab.com>
References: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
 <20220302192523.57444-5-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220302192523.57444-5-krzysztof.kozlowski@canonical.com>
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

From: Krzysztof Kozlowski
> Sent: 02 March 2022 19:25
> 
> Use test_bit() instead of open-coding it, just like in other places
> touching the bitmap.

Except it isn't a bitmap, it is just a structure member that contains bits.
So all the other places should be changes to use C shifts and masks (etc).

	David

> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  net/nfc/llcp_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
> index 5ad5157aa9c5..b70d5042bf74 100644
> --- a/net/nfc/llcp_core.c
> +++ b/net/nfc/llcp_core.c
> @@ -383,7 +383,7 @@ u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
>  			pr_debug("WKS %d\n", ssap);
> 
>  			/* This is a WKS, let's check if it's free */
> -			if (local->local_wks & BIT(ssap)) {
> +			if (test_bit(ssap, &local->local_wks)) {
>  				mutex_unlock(&local->sdp_lock);
> 
>  				return LLCP_SAP_MAX;
> --
> 2.32.0

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

