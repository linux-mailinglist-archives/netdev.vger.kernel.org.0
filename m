Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C542F952
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 11:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfE3JWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 05:22:44 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39555 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfE3JWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 05:22:43 -0400
Received: by mail-lj1-f196.google.com with SMTP id a10so2135614ljf.6
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 02:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MZLYGTyIcU65t5L2uyp6Otqtskjo+juH9YbDeDOrWoQ=;
        b=z9gMudh7d9JcCGlrp8eWDNV2yJxcWLzjkU8oQz0Dg0eByjAW1m0O38+oMguoLKRC/T
         s9zVhaIawSMhlsxObZ/J08tyjEfJWbD+Hmj9VWnbCGr7t23kteJSTuqJZNSFeG1DRkQ+
         c5wM4s2VYLG7vMSnohAP/Bqy6NkCGL3cbrNe+ggkBCOUxa7zIHpELT96fmR3MZP9wDLJ
         r3QkGtnNIgZFOjgqWVTVaG8fJUXQ/HIeqbXgyY4ZiimZZ+4CkuWcQ14Xj7JBTcEoneOd
         SwGXPfjZuCeec5/tQYe9wj2ccqIB1uAmG9eTS7SgVmrBGF8p6nNh2LOYTZiKFwmSRU/k
         30lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MZLYGTyIcU65t5L2uyp6Otqtskjo+juH9YbDeDOrWoQ=;
        b=iHXRQo4PHAgha9sk3U+gmBQDZc6Io5rpGrh9ETyGuiH+n6QagsAnMCIZhpM3xOSxAT
         QMGyRZxHyT0Q1Hvsd+sij9qscAXARR3qvVM2JGlR/BSmzcJRYEwKADrk2NPTnAUJPfpP
         fdlNFZTuoCN8QpMVupyT24fMI8X4kGyTFhbL/I8+JFlSOVMSwj3yjQeYJxgEwilfkzEY
         SmgpPo2c84wufTf+rrY2rfaufIwVZ0zMlzewpQs+buxkbZP2cp9P7T3NU8+c1lutMEsP
         F1Aqmd4yAo0S74vUGupN/Qr30UxpbkKA6PYH9Fu8smX/CcjGi3MjwFssONx7NxelT6dr
         X27g==
X-Gm-Message-State: APjAAAXCFkzdFhoTppcs9F2K0q4DqU3V5JnVrx/59Xf+CStwR1E3Dy/A
        xPj2Sz8HhLP0nuVveMr6f1q4cKve+LI=
X-Google-Smtp-Source: APXvYqyHeVE+PGHkoaUgjK/ZO4PctnMSdwN6Cw2za6u3NMAMmvxeQ7DeKjPAN0omhfrQEbdTmJs9BQ==
X-Received: by 2002:a2e:b0d0:: with SMTP id g16mr1460905ljl.132.1559208161804;
        Thu, 30 May 2019 02:22:41 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.85.229])
        by smtp.gmail.com with ESMTPSA id j5sm367557ljc.67.2019.05.30.02.22.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 02:22:41 -0700 (PDT)
Subject: Re: [PATCH] hooks: fix a missing-check bug in selinux_add_mnt_opt()
To:     Gen Zhang <blackgod016574@gmail.com>
Cc:     paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org,
        ccross@android.com, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20190530080602.GA3600@zhanggen-UX430UQ>
 <e92b727a-bf5f-669a-18d8-7518a248c04c@cogentembedded.com>
 <20190530091848.GA3499@zhanggen-UX430UQ>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <236195a3-b607-5cf6-ac60-8c5ea2e95b41@cogentembedded.com>
Date:   Thu, 30 May 2019 12:22:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530091848.GA3499@zhanggen-UX430UQ>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.05.2019 12:18, Gen Zhang wrote:

>> On 30.05.2019 11:06, Gen Zhang wrote:
>>
>>> In selinux_add_mnt_opt(), 'val' is allcoted by kmemdup_nul(). It returns
>>
>>     Allocated?

> Thanks for your reply, Sergei. I used 'allocated' because kmemdup_nul()
> does some allocation in its implementation. And its docs descrips:

    Describes?

> "Return: newly allocated copy of @s with NUL-termination or %NULL in
> case of error". I think it is proper to use 'allocated' here. But it
> could be 'assigned', which is better, right?

    I was only trying to point out the typos in this word. :-)

> Thanks
> Gen
>>
>>> NULL when fails. So 'val' should be checked.
>>>
>>> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
>> [...]

MBR, Sergei
