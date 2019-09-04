Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C296A77EA
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 02:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfIDApK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 20:45:10 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43014 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbfIDApK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 20:45:10 -0400
Received: by mail-pl1-f196.google.com with SMTP id 4so8730092pld.10
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 17:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=APsdY0zI00jYvD/qUozPHZ+wyH0Nn3pe/Bj6fNRsCa8=;
        b=fL0Mz/n85atcMeJU5zmgTkNytyjBRvby5BYVr+hbZj8OOtUy2pRpUmRNnp9h4gi116
         urJSYROWkwbRwe2WIEcaiMV9mnfIBmzMXAf/FzGCQ6VL2sdA80fG9L0dCE4RGnYWSxK+
         vSMrztQmvcmylRoxbjbgBLBNlDe1THq+6Cq4JM+Dw8msEn6dmlkeEKlggc7L1BCWYpg5
         daL3w2y4Iww0PApMaeLkFrxvvr9ro3/Egw2lWG6gPrnZkYEJ4o08oM0b46lIF2dsm1Dp
         ib7tEhgvjmfqqFK0a91nUe57PrGMAL6IzKmmjukuQli1trCGyq8MuuF3Nj3v1CdboWZi
         Pl1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=APsdY0zI00jYvD/qUozPHZ+wyH0Nn3pe/Bj6fNRsCa8=;
        b=VlX2CH6N5neWsthLSUuWFSFRxMkdypXBD5TzOFX0mgWfV2AasNtPrDfTsPtOZa5lE/
         TFDKSW2jPAgiIpU9COr6Ncpzsp6saEWn6oDfQWh468GwIi1AgRhrbndMlDJIbdi/gcaj
         JYCQKl46Ik+YrTLxAuhshzL9enHNiYv2GZXY4kRADNFg5PiIpe7NGOHF1Yiyiiawy/9j
         PO7FXUFjlXlSZVOQQfoj2QsDOCHYH8xH9mGxz2VlwgjIpCViBqQJCcxarRCalcoFND+z
         4xqC29CLFSNfdcW3cyn7Ds48gPSa+71QaICApsjelUvU+6H2XIeC/FHuqeXJam5da8oX
         cJVQ==
X-Gm-Message-State: APjAAAVG7xoUMePPr2LjdbdlmZM8oSjB53Vgb9XuI7GtMjG1rcP1LUHZ
        CoXVAjEl1MB2e/P+CXYjGS354BTfLMhXzg==
X-Google-Smtp-Source: APXvYqxRwhzerU1ZRGvKc+GN8fbjy68DxOTIs62nI2kNzMt2TCKbpKoom6DAyyQmR3jt9bevauE5/w==
X-Received: by 2002:a17:902:33a5:: with SMTP id b34mr37605653plc.286.1567557909453;
        Tue, 03 Sep 2019 17:45:09 -0700 (PDT)
Received: from [192.168.1.2] (155-97-234-108.usahousing.utah.edu. [155.97.234.108])
        by smtp.gmail.com with ESMTPSA id l3sm768820pjq.18.2019.09.03.17.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 17:45:08 -0700 (PDT)
Subject: Re: [PATCH] Clock-independent TCP ISN generation
To:     David Miller <davem@davemloft.net>
Cc:     eric.dumazet@gmail.com, shiraz.saleem@intel.com, jgg@ziepe.ca,
        arnd@arndb.de, netdev@vger.kernel.org, sirus@cs.utah.edu
References: <e3bf138f-672e-cefa-5fe5-ea25af8d3d61@gmail.com>
 <492bb69e-0722-f6fc-077a-2348edf081d8@gmail.com>
 <e02c0aac-05c5-e0a4-9ae1-57685a0c3160@gmail.com>
 <20190903.154553.508717744184330290.davem@davemloft.net>
From:   Cyrus Sh <sirus.shahini@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=sirus.shahini@gmail.com; prefer-encrypt=mutual; keydata=
 mQENBFeVDCUBCADQxg44Jls52jg8sAvXE2CC8BKZBXxjI2SbHtWkYdchayCiOOhSn7P+aW8F
 OEiI6qJD8/jcq5F7xQv4LZSm5KRG7RbHhfk2ZgB/yM9GksXS4lZdzu+mR1YoIc9/rtgLQ+bv
 mIfbXSyI0zidQ3mpZAmfIxLg8aNNAbW6AIafCwmUS847cK3vadzu1Jc5j3VLFATkh4eb0HXR
 tbwtqqvLLKqXBfre4sMysUFK/0bcF4FtGBw89iMD9CpXKtTF+UmJ8Ir7/eK4qUIPMvCCvpcO
 wH38xP1biWKzknmK0NDgDmUOVAgPB82puYJHZwGLHB2K1Wl+kBR0td1LrOP7+XCMUELjABEB
 AAG0IkN5cnVzLlNoIDxzaXJ1cy5zaGFoaW5pQGdtYWlsLmNvbT6JATgEEwECACIFAleVDCUC
 GwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJELUzPfwK/ZGvHn4H/iSfPYufKTwJU9DD
 ynx5/HsyMOGh5JKXyDu84WE3+8jlNXKNCpPAHylvCE1CgIF6d4W60Zy7sSgOep3svKSdo9A0
 qbajUttEv2xSuv4il+8Z3QcdVnHw11IoQxj/ayxsctPDDYvk/7vPmVXMZEnpIbDw/nPzR+Jt
 axa/xWOp8kufOSc7DdP2OiRTXLqddCM6uWqL/ckvmvBB58BP4QYedUEZxxaMj3/ErzEGEjUY
 tke796IU8HWcc/venQfPEEuHgNsfgbXtUiKu4UBAhVmXwCRgrUodd+9ZJlqYOY56e9y6bLjj
 gw3Ls8Du7SsRP/apFwnbQMbLpxiPOSUWYngNGOK5AQ0EV5UMJQEIAMLFZAP8zwnD8Q/smVtJ
 8ltJn1w1gNuUTEQvIzGTYVTW1E5LqZZB+RLte+UH+uZ04ii2/Qm+//xk23gq+4wQvlX8Vpxj
 gEyaZl2QibaUWDzh+1w4XcLHs9su37kSQoBljm86fk4qgnyTDxTa4sUACZzj+dT6tvxM+yYg
 WM2rglpFQ2d4boAa0/ScEXOVhPKV7D8jVSerK8Jb1jDjG3zovS8h6+Sv3II50K2Fwg+qLz6r
 KQRcxqM7FTBrurug8HGpYXwUs96ZtkOvdBr0Rll9ibi/3ksNbVJVJqKixIHxHwoddfDqS3Xc
 t1F0spHPkZK1FB5Kj7gvlFq8Fd8N7S2tescAEQEAAYkBHwQYAQIACQUCV5UMJQIbDAAKCRC1
 Mz38Cv2Rr6ZXB/9M3Er23Hu5/aHHceCTwPbQIsM1GzQ7vCzzb7+L908tjlc5mj1S7wNyBg+J
 XhaK3N1QYgc4ZEQiY91h3lAgiAw1fghDK9CEEcVV9RgakfLbhfMsQQj0TnhZ/afSAD84h8gZ
 K0Ilqi1XNb0quwm3lGE8SJqbM3yFV5ArMFG5QZN7O+TK+uC9Ruj3kV6hqV4LXaNJ4lug76yx
 tPbu9w6p2nOJ8d2Gv5T6K0uSoUCfplZa0hmX8ZZBYSQZLrEk0KrlorH0GZfvr1Rv2gXa6/Ne
 I9Sdj0Bd/WQRUnr8l6HlVPHA/diIFwSzo5taOqx62QXI1RbSozDjJ7QoR/gTilEDF18C
Message-ID: <473f1808-464b-eed9-903f-a4718ea70422@gmail.com>
Date:   Tue, 3 Sep 2019 18:45:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903.154553.508717744184330290.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/19 4:45 PM, David Miller wrote:

> At least our problematic code, unlike your patch, compiles.

I obviously compiled and tested the code before sending along and this should be
easy to understand. Even I published the results in the link that I mentioned in
the initial message. Now I'm not sure what you're doing that you're unable to
compile the code. What compilation error message do you get? This patch has
been written for kernel 5.3-rc7. 
Further the reason that I asked for a specific practical example was that I
wanted to actually test different techniques and see their effectiveness. (Again
should be easy to understand, I don't know why it's not for you and why it made
you upset)

