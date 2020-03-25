Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35EC51930DD
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgCYTG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:06:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38719 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbgCYTG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:06:27 -0400
Received: from mail-qv1-f72.google.com ([209.85.219.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <gpiccoli@canonical.com>)
        id 1jHBM9-0002Oj-0f
        for netdev@vger.kernel.org; Wed, 25 Mar 2020 19:06:25 +0000
Received: by mail-qv1-f72.google.com with SMTP id a12so2678663qvq.13
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 12:06:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=b1zSQuDcsYxyVjeDNhtG9+0hOXrqAXhQ4Q8lvCYK2Ew=;
        b=nnJOjWaNUqeT0tdFRNLSPBqhDPkHY7EgcoUYV63QQ8sn6sAjCnMeURBa5OvLKlmMjT
         n/e+9Sw/bUMo+ptIapV7yPpI/+0W++WX7739Ls1ORyOBQX6sLItRoBuxICUoUQvyr411
         VhDuPjwLk1H/u4r2x0r79dcAdR5dy5xf61YOrM4HaLqoBy8IJ/0nuUkFhlhT7K4wDqZA
         psGos4aZxRXJzOEByLrJwfaaeKlyUUU7U8ZQQ5lrq6FEbBavSv9XcPvkEuis0z1NwVOv
         VNx/rYaGiDpL9Xsi3Bg884/NaWO3MjvRsxBsD0qdnTHHotCWAPdcTi4IY9uKpJgkcQLz
         95xQ==
X-Gm-Message-State: ANhLgQ3KOnYkgwPcaX8hGVsgLnFsdhIYOvkpvI/XZZNRBFfnRf70W6Ty
        e/ANMk94z/WXy0YLPfiVoQYAoua06sGHOkjgMF70J6khivixTNb2V6R/wkNtt5bklL644lq7iUX
        DVd+zzAeZAkikex4vAqCmaYdapZQCsU66+g==
X-Received: by 2002:a05:620a:1256:: with SMTP id a22mr4329688qkl.439.1585163184211;
        Wed, 25 Mar 2020 12:06:24 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvh0kc4gXTPc2AYeVuwu4Iw+mzibHW6Z6HTLtIsEmnuLZ8Ogaf1gyE3ePnrzNaR+oxt1C27Ww==
X-Received: by 2002:a05:620a:1256:: with SMTP id a22mr4329649qkl.439.1585163183932;
        Wed, 25 Mar 2020 12:06:23 -0700 (PDT)
Received: from [192.168.1.75] (189-47-87-73.dsl.telesp.net.br. [189.47.87.73])
        by smtp.gmail.com with ESMTPSA id v1sm17409895qtc.30.2020.03.25.12.06.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 12:06:22 -0700 (PDT)
Subject: Re: [PATCH] net: ena: Add PCI shutdown handler to allow safe kexec
To:     David Miller <davem@davemloft.net>
Cc:     netanel@amazon.com, akiyano@amazon.com, netdev@vger.kernel.org,
        gtzalik@amazon.com, saeedb@amazon.com, zorik@amazon.com,
        kernel@gpiccoli.net, gshan@redhat.com, gavin.guo@canonical.com,
        jay.vosburgh@canonical.com, pedro.principeza@canonical.com
References: <20200320125534.28966-1-gpiccoli@canonical.com>
 <20200325.120412.734295569199099804.davem@davemloft.net>
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
Message-ID: <0f855cdc-67a9-99e4-8aed-75c7b2fc2be0@canonical.com>
Date:   Wed, 25 Mar 2020 16:06:18 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200325.120412.734295569199099804.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/03/2020 16:04, David Miller wrote:
>[...]
> Applied and queued up for -stable, thank you.
> 

Thanks David and all involved in reviewing and testing the patch!
Cheers,


Guilherme
