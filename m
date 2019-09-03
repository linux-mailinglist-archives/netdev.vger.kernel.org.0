Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE90A6D0A
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 17:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbfICPjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 11:39:04 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38599 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbfICPjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 11:39:04 -0400
Received: by mail-pl1-f196.google.com with SMTP id w11so8085222plp.5
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 08:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kQn9w2GUbw4Sz/6a+4pL2pv0kNpvi9fRGSZQZ1riE+Y=;
        b=sgBnOP5onX37jN4EoNtu7Tk83liLw9KUkd2KLspO1MYDsPXGbZ8DC8kiE+u9aPZKmn
         X8JQ2vJYvUQa2P8n6lSJ+/eMJecAHE911dNR8s5ni6RouI4eqZC3BmXUql+pDkXeUjAF
         7+JpgPqgWA6Cody/bCBNah8pyRkwq/YmUH3Htj7re1AyrD5exNGaZ5p0bYKJ5ySQW2tV
         ZfiUxHd7sPtyKRv16iJmW46zPf66CJlz3CQb4oLjPptfIQlJFhNebRLxazpEw9jv6GPA
         EMOXgRPGT9f5U1phJJsR2Gn5AcyAMt8Q4eXWGpKXF0fF+RD1NXgiuazm6uofUK6HavNG
         2VxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kQn9w2GUbw4Sz/6a+4pL2pv0kNpvi9fRGSZQZ1riE+Y=;
        b=XIcE+ROevRTIHUHhg1yzC8Gn2YTgcwGzj9DdDgtdYmDQAkWTgOuaZDWOxTT3lN/0/p
         IXULuvvLQmdY3+n/Y+L4M1olTRxqaZZKAuttVSa9PpEGYQDlJNMHx51J51hm9D4RYCVs
         WZqXb/jAwt3Pn8v/BUGuHo7bCmEFxn1rcLayvN/cf2CEMpwvaA2UI2l1OTf8TAOJRakc
         Mb4sBtt0KOnf0xi2f5EZA/Cfuzy1Y8yfrAfUxUuqmp8s+z7j84FQM+E9FHTzMpjR6Ina
         rmFPPJglUIDbDf214rClhXsfUpkICAuULQeO6J984oQJSpDcDQYDapLdKBRskBj9Cgoo
         wysg==
X-Gm-Message-State: APjAAAVqnhESyvacCt9QZ0F1ZAZnB15pV0kPjZI8xvoqyv2jwcdUdFVy
        4IDXpR1Bw7m2djUYeRywAts=
X-Google-Smtp-Source: APXvYqzZoEgWuN7F0dVDbhnWNSaTQA7gN1CGTnGv0+ZcyNmMd0p+kPpkZ2war0qK1theV6MDmhQiyg==
X-Received: by 2002:a17:902:b691:: with SMTP id c17mr1776096pls.265.1567525143875;
        Tue, 03 Sep 2019 08:39:03 -0700 (PDT)
Received: from [192.168.1.2] (155-97-234-108.usahousing.utah.edu. [155.97.234.108])
        by smtp.gmail.com with ESMTPSA id 193sm1489969pfc.59.2019.09.03.08.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 08:39:03 -0700 (PDT)
Subject: Re: [PATCH] Clock-independent TCP ISN generation
To:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net
Cc:     shiraz.saleem@intel.com, jgg@ziepe.ca, arnd@arndb.de,
        netdev@vger.kernel.org, sirus@cs.utah.edu
References: <70c41960-6d14-3943-31ca-75598ad3d2d7@gmail.com>
 <fa0aadb3-9ada-fb08-6f32-450f5ac3a3e1@gmail.com>
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
Message-ID: <bf10fbfb-a83f-a8d8-fefc-2a2fd1633ef8@gmail.com>
Date:   Tue, 3 Sep 2019 09:39:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fa0aadb3-9ada-fb08-6f32-450f5ac3a3e1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/19 1:41 AM, Eric Dumazet wrote:
> Clock skew seems quite secondary. Some firewall rules should prevent this kind of attacks ?

Can you provide any reference to somewhere that explains these firewall rules
and how to exactly use them to prevent this specific type of attack?
