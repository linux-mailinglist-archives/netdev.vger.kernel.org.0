Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D355915A3DD
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 09:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgBLItH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 03:49:07 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45643 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728457AbgBLItH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 03:49:07 -0500
Received: by mail-lj1-f196.google.com with SMTP id e18so1310229ljn.12
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 00:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KsXH890iQs0AQkxd7TvO/8AHZ7l/Fhdn024GDtGuR/o=;
        b=ox+v+cRpypAFoD6CuWQEot6Zm7GJq2/l91kITNPxOlsdYlCJN3jxn8N1j8Ua7w0ke/
         K5qkmC3rXgcKUSdm8/Ocl6GW6QAViMGl08JIvqjbxZoxlIGArRf+7GeVWaJiQZohNkle
         LutxGmKj6/NT/7t9FMXfaxKvcZU1LA+iB62y7dwYP+n6o5NgWpYNMaj0N6WySR6PpUS+
         e1EC3mY3pjuapJiM5pFXwC9dcDuPyvSQpUCZNqCiUAexj3QGUE56H0t/cB14+3L8DJjj
         nUY/XhRGXk/UEXr+HeVLVIZjlrKIcykApywnoRYSUEC77L1LOPeql6tyjaxfNx9fr6pT
         lTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KsXH890iQs0AQkxd7TvO/8AHZ7l/Fhdn024GDtGuR/o=;
        b=Pm2iTmEAP6lJWHw05ad4wvaXNXi8E19Ah/W4faqiG6bVv00tON0/0iQx/CYb03fd6C
         6tzkEjkn3yOlR1c+7LLYjO3pdxAdN3hfdDJIuhRAcnz4bM9EFPylOl6eVHy4lPSGyg1/
         8DPn/jR3UczzhdtyvsMioStvMAu7XqC0AS00/36+FPrHlnU8T0NJKvyEeyQdCPGgBHjs
         e8VbCxWtO0+q6flK8ximzz7rPQMXmjA3fLBXVphQAZTI3/cCCpdWSlRma5XLjCZP9xnY
         OYiiA2+XSvpx1bgSj/D1DCzFxbmMH19JsLUw5QhNL+gi5Hx+LlTRCGM4JXGjfiNwq7eL
         Q+5Q==
X-Gm-Message-State: APjAAAU+SoxZ//VbXkIqqMN5o1InTeiFOv4HjngX0yLv63OPR3nTjRSl
        xzWCVXnsAW0VBUnMDmP6CAg=
X-Google-Smtp-Source: APXvYqx027RqH5nJHgXmezqxDKjhocZ/+ydmOCdUZh9l7U5LqyrCQfEgh+jOL4GtbJo30jbdpKdlSw==
X-Received: by 2002:a2e:b80e:: with SMTP id u14mr7219638ljo.17.1581497345096;
        Wed, 12 Feb 2020 00:49:05 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id 21sm3547389ljv.19.2020.02.12.00.49.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 00:49:04 -0800 (PST)
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <20200212082434.GM2159@dhcp-12-139.nay.redhat.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <2bc4f125-db14-734d-724e-4028b863eca2@gmail.com>
Date:   Wed, 12 Feb 2020 09:49:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200212082434.GM2159@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.02.2020 09:24, Hangbin Liu wrote:
> On Wed, Feb 12, 2020 at 08:37:31AM +0100, Rafał Miłecki wrote:
>> Hi, I need some help with my devices running out of memory. I've
>> debugging skills but I don't know net subsystem.
>>
>> I run Linux based OpenWrt distribution on home wireless devices (ARM
>> routers and access points with brcmfmac wireless driver). I noticed
>> that using wireless monitor mode interface results in my devices (128
>> MiB RAM) running out of memory in about 2 days. This is NOT a memory
>> leak as putting wireless down brings back all the memory.
>>
>> Interestingly this memory drain requires at least one of:
>> net.ipv6.conf.default.forwarding=1
>> net.ipv6.conf.all.forwarding=1
>> to be set. OpenWrt happens to use both by default.
>>
>> This regression was introduced by the commit 1666d49e1d41 ("mld: do
>> not remove mld souce list info when set link down") - first appeared
>> in 4.10 and then backported. This bug exists in 4.9.14 and 4.14.169.
>> Reverting that commit from 4.9.14 and 4.14.169 /fixes/ the problem.
>>
>> Can you look at possible cause/fix of this problem, please? Is there
>> anything I can test or is there more info I can provide?
> 
> Hi Rafał,
> 
> Thanks for the report. Although you said this is not a memory leak. Maybe
> you can try a84d01647989 ("mld: fix memory leak in mld_del_delrec()").

Thanks, that commit was also pointed by Eric and I verified it was
backported as:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.9.y&id=df9c0f8a15c283b3339ef636642d3769f8fbc434

So it must be some other bug affecting me.
