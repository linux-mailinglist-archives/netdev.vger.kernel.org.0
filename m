Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D106A6FFB
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 18:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbfICQfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 12:35:43 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46386 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730927AbfICQ1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 12:27:43 -0400
Received: by mail-pg1-f194.google.com with SMTP id m3so9399320pgv.13
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 09:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bioVF4WKpKR4Pw6fWqrjzsqZ+TyHbFDL6fESqKDoUKs=;
        b=DuK7NQNL2TdAus86x13/MoDlTM/WFYk3xFpW+G7AgaVo1AW59lNe4NmuIhV1ZHMi50
         JcXOwWWIWY2xtzetbCZRR2csRs/DPR+fXeDYu7q7gq0MbHED7IHGZ+m6gVuruDezsNwi
         uo5/LtGYz8TEbzLYedgftsAqmzWubC/XMxuD/YBiZJatR3iItknmSH6w9gg2R9WRlJgb
         gabDQ8kCswo5FdaKw4ELSHf1FDxy8rBs1CQNI7uOoLbOecHisDWetkRYRerNQxypC/hY
         6AHn9oLmHIeWdmiOEoVXjveWPivp9znrucQ3CbboDL7RXvEX3wTX/Gjla4DkusIWbwwh
         XX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bioVF4WKpKR4Pw6fWqrjzsqZ+TyHbFDL6fESqKDoUKs=;
        b=ECVIrbba93Nh101HkABU8QDuQNSXMezyTlhjuI3ZJxp0iLu2LpLnJ9Y5hWZ0sbO8B4
         fN6nt/lf8/RVFedefdz/Vkw8ZSx2fz84JyHhhHhzn50ASMK/2KN5KYggyX3/Ry8fP9b8
         +KqWnOFgAoHZuwE6wV/m62mjjqp1PoTk88uNIB0MdDYgiusZ/qkjk1rlC3y5s73GySNu
         jrnhl695jPTVfJdrUYSwziDs9LUBhpLryfZkhWaCNEZo43tiP9afZ0lG4nCkdJkW0Sy9
         c9+bXk0PESZkl/t8UqAk8ZtRQL7fPpYcmPDBSruHdRtMKj3WsxeePq4u3b4Ohtzig+82
         OXHQ==
X-Gm-Message-State: APjAAAV+BzsiugR9Aj6+nFXJ6fwyUMQZvkn8IsyH3f95bWbcCbX6y0yf
        hRCVxrn+c82R+GbD+EXN6y0=
X-Google-Smtp-Source: APXvYqzjoGISfAGxm3gJy7Yj3Pb79gfo86j1qO//uAIZK1sxMwjjwPI0PAFUinIsuYj0N0p8iqO15w==
X-Received: by 2002:a17:90a:4483:: with SMTP id t3mr120901pjg.59.1567528062824;
        Tue, 03 Sep 2019 09:27:42 -0700 (PDT)
Received: from [192.168.1.2] (155-97-234-108.usahousing.utah.edu. [155.97.234.108])
        by smtp.gmail.com with ESMTPSA id 143sm20563247pgc.6.2019.09.03.09.27.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 09:27:42 -0700 (PDT)
Subject: Re: [PATCH] Clock-independent TCP ISN generation
To:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net
Cc:     shiraz.saleem@intel.com, jgg@ziepe.ca, arnd@arndb.de,
        netdev@vger.kernel.org, sirus@cs.utah.edu
References: <70c41960-6d14-3943-31ca-75598ad3d2d7@gmail.com>
 <fa0aadb3-9ada-fb08-6f32-450f5ac3a3e1@gmail.com>
 <bf10fbfb-a83f-a8d8-fefc-2a2fd1633ef8@gmail.com>
 <2cbd5a8f-f120-a7df-83a3-923f33ca0a10@gmail.com>
 <e3bf138f-672e-cefa-5fe5-ea25af8d3d61@gmail.com>
 <492bb69e-0722-f6fc-077a-2348edf081d8@gmail.com>
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
Message-ID: <e02c0aac-05c5-e0a4-9ae1-57685a0c3160@gmail.com>
Date:   Tue, 3 Sep 2019 10:27:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <492bb69e-0722-f6fc-077a-2348edf081d8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/19 10:17 AM, Eric Dumazet wrote:

> Do you have a real program showing us how this clock skew can be used practically ?
This is a well studied issue. You can take a look at this presentation as an
example:
http://caia.swin.edu.au/talks/CAIA-TALK-080728A.pdf

> You will have to convince people at IETF and get a proper RFC 
No I won't. A lot of these standards have been written at a time that anonymity
networks were not of big importance. Now that they are, we try to lessen the
negative impacts of some RFC deficiencies by improving the implementation. It's
up to you whether to want to keep using a problematic code that may endanger
users or want to do something about it since we won't insist on having a patch
accepted.
