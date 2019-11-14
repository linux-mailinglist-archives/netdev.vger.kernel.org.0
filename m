Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 516D8FC8E1
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 15:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfKNO2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 09:28:39 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40501 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfKNO2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 09:28:39 -0500
Received: by mail-pf1-f193.google.com with SMTP id r4so4361224pfl.7
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 06:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/yJkWRHTJCwNu6KkVPSUDuHQtY8tsHFS93PMt6yJnpk=;
        b=eectuFoMseyC2GH4k5tC3hrq2sxzAlgNwUMis+UY02aaF5JJtpBcNEaGXfDKKIVbfO
         z/8p5sw7PuolZGG88S9pO7h6o0xztGhA/ZAdsHCILiQ6dCYZOhgySwHZ6F5zBCZwta89
         b0kraDjb9fG7ZO00mUOW/TwlkCI8FdHUtf8FtO3Tp5bsKMTQoiuW3wStHIysx27XyLiC
         BRceVGKrjcc/3Kogg8wSSpRJmh8FjRz34vqp/f50+kzlX+BkF+WrRFg8m3/QwydaOad8
         UzoEoYdbgYBk8w7qSmAWRsI/BdguEQjktU8yzVMTaLpooYoqmL5ppPqQ3GRwvA466YEs
         DG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/yJkWRHTJCwNu6KkVPSUDuHQtY8tsHFS93PMt6yJnpk=;
        b=PMlyvtddcVBrxqIJl86L3IaBkNQp73GnmE3uEMXhdhJBb0EEEh4QFuLXGyed0XwZyv
         w17Rs/bGp4fxOT1gpjvOg2hKd3P8TzW0HgOVwu83Kd3rmakbTo+xnrBZEtxScKrutCPS
         X7aW0yDX16aNJ3gR79Jsv5PcH2pcA7fzTibjqu3Znf+miC5EiVtegsVyPVvuWlrs9Hew
         1W/g0jLrHtiAl2iAQqmq4SA4GXRIcm8FrTF2u9TMn4iCJjZRS1UHe4iLSNWYabUbmjPS
         l1ENVYa2S0uUe/imRuvIDNfmA0K2G73z6Go0TqCWlD+RxF3tZet91ely2dQ8iS+4HE7x
         nkxQ==
X-Gm-Message-State: APjAAAXzzL7UH4j5AfGY5n0xCBEnzcBYAvJmfIi9Q21lfeY+yRt6FmZv
        zWW2FtE4fKNWVhZxUyDa4jM=
X-Google-Smtp-Source: APXvYqw/nhHItQY1xYIHk5chjo+2g+P4rqMRDfaqoQDgT2cftZip9zyFRne76ICyW/P6arjuxf6DSQ==
X-Received: by 2002:a63:fc09:: with SMTP id j9mr1774014pgi.272.1573741718710;
        Thu, 14 Nov 2019 06:28:38 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l18sm3340672pff.79.2019.11.14.06.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 06:28:37 -0800 (PST)
Subject: Re: [PATCH net] tcp: switch snprintf to scnprintf
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>
References: <20191114102831.23753-1-liuhangbin@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <557b2545-3b3c-63a9-580c-270a0a103b2e@gmail.com>
Date:   Thu, 14 Nov 2019 06:28:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191114102831.23753-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/14/19 2:28 AM, Hangbin Liu wrote:
> snprintf returns the number of chars that would be written, not number
> of chars that were actually written. As such, 'offs' may get larger than
> 'tbl.maxlen', causing the 'tbl.maxlen - offs' being < 0, and since the
> parameter is size_t, it would overflow.
> 
> Currently, the buffer is still enough, but for future design, use scnprintf
> would be safer.
>

Why is it targeting net tree ?

How have you checked that it was actually safer ?

This looks unnecessary code churn to me, and it might hide an error in the future.

We need to properly size the output buffers before using them,
we can not afford truncating silently the output.

