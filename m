Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A7159BC4
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfF1Mke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:40:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55520 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfF1Mkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 08:40:33 -0400
Received: from mail-qk1-f199.google.com ([209.85.222.199])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <gpiccoli@canonical.com>)
        id 1hgqB5-0003IZ-Bi
        for netdev@vger.kernel.org; Fri, 28 Jun 2019 12:40:31 +0000
Received: by mail-qk1-f199.google.com with SMTP id n190so6292501qkd.5
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 05:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6QZNYZ7T4oKi3Chj9wu06NNscOPwa7TKxsSAv+ick+A=;
        b=MouwZcRSHJRUfh+XkwnZ9cqfeRjdAEYSufrrPl78M6fnqHIZAJEfZ+oMlAoxKaDjLP
         GAAeIWDq9XULQf6Qj+Wtm2SXgqA3TDHJWNI/9qydciQbFiIJV0T/o00Y+0q+b8vr0Gmd
         M0mL3AJBgAz3xeNSvNQJFHjeujJ7h4tjqoPzQ14TSC6ZvT8SznNohPKhpzXNHKeFHQGU
         TNzsAmZx8JrIbWWFEVyX0IKXOEaDtMI9/p17f5YvazKqYvGAfUMQPNF4Nral5p03apTn
         DBr0lJxu4U4y069zHc1M7/YqgvK09GWQYZgjPuffzB02MjVMv+b0Orr/zXLOkMg0pgLP
         9y6g==
X-Gm-Message-State: APjAAAWfR8I80ESadlJXB0ByFayjMw1+Vm3zAhCeJN4uAY84ImPhXOCr
        2DpJNeuNEHzYGplgKF1+w3vA+wSIKunoDfpsX2yWm3RbXu1oUPTWVelJw22XdiWwbq8o6EAiTan
        F5mlZulwyoOaJ7LDIM93edBeH/OWWsQ5Qjg==
X-Received: by 2002:a0c:b04d:: with SMTP id l13mr8095163qvc.104.1561725630638;
        Fri, 28 Jun 2019 05:40:30 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwYQABwi7KQPdv5dtOO99sXd3KKt1AbHTD9efMX9lbQWk6YxG3nxtKZdeEkHbgOCnfiB0fa8w==
X-Received: by 2002:a0c:b04d:: with SMTP id l13mr8095148qvc.104.1561725630488;
        Fri, 28 Jun 2019 05:40:30 -0700 (PDT)
Received: from [192.168.1.204] ([179.110.97.158])
        by smtp.gmail.com with ESMTPSA id 18sm991619qke.131.2019.06.28.05.40.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 05:40:29 -0700 (PDT)
Subject: Re: [EXT] [PATCH V4] bnx2x: Prevent ptp_task to be rescheduled
 indefinitely
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>, davem@davemloft.net
Cc:     GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>
References: <20190627163133.5990-1-gpiccoli@canonical.com>
 <MN2PR18MB25287DF4D53BCD651E5AC97FD3FC0@MN2PR18MB2528.namprd18.prod.outlook.com>
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
Message-ID: <44c04c0b-f4dc-8486-41bc-7964e95bf48e@canonical.com>
Date:   Fri, 28 Jun 2019 09:40:24 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <MN2PR18MB25287DF4D53BCD651E5AC97FD3FC0@MN2PR18MB2528.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/06/2019 02:22, Sudarsana Reddy Kalluru wrote:
> [...]
> Thanks for the changes.
> 
> Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> 

Thanks a lot Sudarsana!


David, do you think it's still possible to get this merged as a fix in
5.2 cycle, or it's gonna go in 5.3?

Thanks,

Guilherme
