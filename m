Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE1018F68E
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 15:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgCWOJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 10:09:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55688 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728378AbgCWOJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 10:09:32 -0400
Received: from mail-qk1-f199.google.com ([209.85.222.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <gpiccoli@canonical.com>)
        id 1jGNli-0006Ed-HY
        for netdev@vger.kernel.org; Mon, 23 Mar 2020 14:09:30 +0000
Received: by mail-qk1-f199.google.com with SMTP id g25so2449291qka.0
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 07:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uD9UTB4eUqzPpXhU/pSICGzXLIkypVUoDRfT0epdLnI=;
        b=Gfe1xkGm6MK7pfb6tEyKQRGBMny0OHwfphRHsKeRL0/gA7gqH9VGhvVD/hRnuVQp6f
         cynSBJvTWJhod8vKXD+lAjU8JNHwAbIAlBiDqOWzS8ALivuBOqzOAhLIV/NQEl7ujzHW
         ooRyCZczsQc7CYVJ29M3pkKmwMnfvKWwN2478cZAAI2UD483oyvBDgqTofCuRGq3F3Ze
         /3tZ60c5SWJV+AJVdY6DDDwf7PK2LeNRSGCU6UGNKgRd+tRbpILgmrd35PR9LnI1pcR2
         dqvHpE2WPo2C4Ru96nIoewhBnGfzM7lak598eaJE8CRrRxLsULHUR8HlvnZWQWloR6FN
         gM6w==
X-Gm-Message-State: ANhLgQ2rSOZJD6zaRM5fCiDjmj9jpZ1vmDUJfGIlWSMtZa5LP1Ma0h91
        KsScbjzZbIk9LdRdOmaVEo2wYq5ZYjihxqz/ZaQkfev48ZGaFJOFMKuvDi/H+JJbMhCX7LJRTa7
        U49zK+T/5bBgv4ZZdDYQRcquFjXeBOCMBmg==
X-Received: by 2002:a37:8502:: with SMTP id h2mr21413376qkd.223.1584972569654;
        Mon, 23 Mar 2020 07:09:29 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuJqPJB4iEIpQYb0jon939GQGBMkOlpP233dLHl8r+JSPyVQOYX67MfhwKqqmMWJkFdyVYwvA==
X-Received: by 2002:a37:8502:: with SMTP id h2mr21413345qkd.223.1584972569409;
        Mon, 23 Mar 2020 07:09:29 -0700 (PDT)
Received: from [192.168.1.75] (189-47-87-73.dsl.telesp.net.br. [189.47.87.73])
        by smtp.gmail.com with ESMTPSA id c40sm12694113qtk.18.2020.03.23.07.09.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Mar 2020 07:09:28 -0700 (PDT)
Subject: Re: [PATCH] net: ena: Add PCI shutdown handler to allow safe kexec
To:     "Jubran, Samih" <sameehj@amazon.com>
Cc:     "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "gavin.guo@canonical.com" <gavin.guo@canonical.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>,
        "pedro.principeza@canonical.com" <pedro.principeza@canonical.com>
References: <f350a2ee513f4e3fb2a2cfa633dc0806@EX13D11EUB003.ant.amazon.com>
From:   "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Openpgp: preference=signencrypt
Autocrypt: addr=gpiccoli@canonical.com; prefer-encrypt=mutual; keydata=
 mQENBFpVBxcBCADPNKmu2iNKLepiv8+Ssx7+fVR8lrL7cvakMNFPXsXk+f0Bgq9NazNKWJIn
 Qxpa1iEWTZcLS8ikjatHMECJJqWlt2YcjU5MGbH1mZh+bT3RxrJRhxONz5e5YILyNp7jX+Vh
 30rhj3J0vdrlIhPS8/bAt5tvTb3ceWEic9mWZMsosPavsKVcLIO6iZFlzXVu2WJ9cov8eQM/
 irIgzvmFEcRyiQ4K+XUhuA0ccGwgvoJv4/GWVPJFHfMX9+dat0Ev8HQEbN/mko/bUS4Wprdv
 7HR5tP9efSLucnsVzay0O6niZ61e5c97oUa9bdqHyApkCnGgKCpg7OZqLMM9Y3EcdMIJABEB
 AAG0LUd1aWxoZXJtZSBHLiBQaWNjb2xpIDxncGljY29saUBjYW5vbmljYWwuY29tPokBNwQT
 AQgAIQUCWmClvQIbAwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRDOR5EF9K/7Gza3B/9d
 5yczvEwvlh6ksYq+juyuElLvNwMFuyMPsvMfP38UslU8S3lf+ETukN1S8XVdeq9yscwtsRW/
 4YoUwHinJGRovqy8gFlm3SAtjfdqysgJqUJwBmOtcsHkmvFXJmPPGVoH9rMCUr9s6VDPox8f
 q2W5M7XE9YpsfchS/0fMn+DenhQpV3W6pbLtuDvH/81GKrhxO8whSEkByZbbc+mqRhUSTdN3
 iMpRL0sULKPVYbVMbQEAnfJJ1LDkPqlTikAgt3peP7AaSpGs1e3pFzSEEW1VD2jIUmmDku0D
 LmTHRl4t9KpbU/H2/OPZkrm7809QovJGRAxjLLPcYOAP7DUeltveuQENBFpVBxcBCADbxD6J
 aNw/KgiSsbx5Sv8nNqO1ObTjhDR1wJw+02Bar9DGuFvx5/qs3ArSZkl8qX0X9Vhptk8rYnkn
 pfcrtPBYLoux8zmrGPA5vRgK2ItvSc0WN31YR/6nqnMfeC4CumFa/yLl26uzHJa5RYYQ47jg
 kZPehpc7IqEQ5IKy6cCKjgAkuvM1rDP1kWQ9noVhTUFr2SYVTT/WBHqUWorjhu57/OREo+Tl
 nxI1KrnmW0DbF52tYoHLt85dK10HQrV35OEFXuz0QPSNrYJT0CZHpUprkUxrupDgkM+2F5LI
 bIcaIQ4uDMWRyHpDbczQtmTke0x41AeIND3GUc+PQ4hWGp9XABEBAAGJAR8EGAEIAAkFAlpV
 BxcCGwwACgkQzkeRBfSv+xv1wwgAj39/45O3eHN5pK0XMyiRF4ihH9p1+8JVfBoSQw7AJ6oU
 1Hoa+sZnlag/l2GTjC8dfEGNoZd3aRxqfkTrpu2TcfT6jIAsxGjnu+fUCoRNZzmjvRziw3T8
 egSPz+GbNXrTXB8g/nc9mqHPPprOiVHDSK8aGoBqkQAPZDjUtRwVx112wtaQwArT2+bDbb/Y
 Yh6gTrYoRYHo6FuQl5YsHop/fmTahpTx11IMjuh6IJQ+lvdpdfYJ6hmAZ9kiVszDF6pGFVkY
 kHWtnE2Aa5qkxnA2HoFpqFifNWn5TyvJFpyqwVhVI8XYtXyVHub/WbXLWQwSJA4OHmqU8gDl
 X18zwLgdiQ==
Message-ID: <408dd4c7-9f84-3314-1123-f308098e53e4@canonical.com>
Date:   Mon, 23 Mar 2020 11:09:23 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <f350a2ee513f4e3fb2a2cfa633dc0806@EX13D11EUB003.ant.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [...] 
> 
> Hi 
> Guilherme,
> 
> Thank you for the patch, we are currently looking into your patch and testing it.
> 
> Thanks,
> Sameeh
> 

Thanks a lot Sameeh! If you have any suggestions, let me know and I can
quickly respin a V2.

Cheers,


Guilherme
