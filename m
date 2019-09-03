Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB38A6D7E
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 18:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbfICQGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 12:06:05 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33109 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729653AbfICQGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 12:06:05 -0400
Received: by mail-pg1-f196.google.com with SMTP id n190so9410042pgn.0
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 09:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EL2fd9EDmw/V9xd1iIcy4FvsH4ybya6e+PAXznQJoOc=;
        b=lrfLRdZropQCprNjFLY8ENPyobYGPnZbKNG5lPNTdvbv0SjimzdFHqRV/2veYLBozg
         SqNFJdWRkgpbR9XAk7QS6DPQqfB7b7m2ZuDX8lS292yvIJVqZN5Qwp60E0okVW7+IBwK
         vY3VpMVLrrdnh0IcxYEdOu/LJ1v6fIMjixHPTRYnxxWVLeF3QcthJYztkZZRenkxrSZg
         VIuKg8gzXFlSAn0kfcqqKSY7MlCenlA5JOtQdi+Qg1zZGKTXJ60YEQ0EsCzypxcstxwC
         I2ikfxmF4nxy7hMGZitMPobK4TDZpwkAfgqqroDG2OWbfrZdTcRtGxVLVaI+VmJJEo81
         TiRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=EL2fd9EDmw/V9xd1iIcy4FvsH4ybya6e+PAXznQJoOc=;
        b=GQmqSPsy0GcbEBWq1ALBbytaORaYEThy3wraGqBjwCln/D4vzACqpx7ouY96RITTzG
         cSECJlioiuEXB0/Y3oCvTRJv5CLRws6yhCkL4w8yuzYYOw/Xvs8M+IAS+XeDOL7QIaf2
         6DaeQno0osySPHmH447/dIgLFDPyg7LDV35CdgBmyPu/611+bel2d+0aq/aG3APynNat
         I18jBhieO0ubv1huOnxpTgJqlLWcslnTOm2hut6RELdlq9Eaiis+KnuDuf5VXiOwxZT8
         448IcXI/YDcEprx+UOQrm8vVRFaBbFgEjkhJwt9udJbCb9kGFXQde5fWvvoghfW1gDqH
         T81g==
X-Gm-Message-State: APjAAAW1OskmZGWxL+L8HTa3698BTCyTKIBwoQbZmAbkyXvWGkLrnLtw
        BThUMo/svYQyBf7CDpseeXE=
X-Google-Smtp-Source: APXvYqzTIrWg1amaduNMIQ13NY+l19W4KUO4V3XWmhXvP1tG3cLmGwSBMsHF0aexR7QPL9+zQWinWA==
X-Received: by 2002:a63:8ac4:: with SMTP id y187mr31679350pgd.412.1567526764738;
        Tue, 03 Sep 2019 09:06:04 -0700 (PDT)
Received: from [192.168.1.2] (155-97-234-108.usahousing.utah.edu. [155.97.234.108])
        by smtp.gmail.com with ESMTPSA id c1sm19363908pfb.135.2019.09.03.09.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 09:06:04 -0700 (PDT)
Subject: Re: [PATCH] Clock-independent TCP ISN generation
To:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net
Cc:     shiraz.saleem@intel.com, jgg@ziepe.ca, arnd@arndb.de,
        netdev@vger.kernel.org, sirus@cs.utah.edu
References: <70c41960-6d14-3943-31ca-75598ad3d2d7@gmail.com>
 <fa0aadb3-9ada-fb08-6f32-450f5ac3a3e1@gmail.com>
 <bf10fbfb-a83f-a8d8-fefc-2a2fd1633ef8@gmail.com>
 <2cbd5a8f-f120-a7df-83a3-923f33ca0a10@gmail.com>
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
Message-ID: <e3bf138f-672e-cefa-5fe5-ea25af8d3d61@gmail.com>
Date:   Tue, 3 Sep 2019 10:06:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2cbd5a8f-f120-a7df-83a3-923f33ca0a10@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/19 9:59 AM, Eric Dumazet wrote:
> 
> You could add a random delay to all SYN packets, if you believe your host has clock skews.

In theory yes, but again do you know any practical example with tested
applications and the list of the rules? I'm interested to see an actual example
that somebody has carried out and observed its results.
