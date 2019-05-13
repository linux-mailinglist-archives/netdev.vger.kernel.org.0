Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79C9D1B9A2
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 17:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbfEMPNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 11:13:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56152 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfEMPNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 11:13:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id x64so3043999wmb.5
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 08:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CiBFBXYWYqvmkbtepgV7xTn8x0QSeVWrN7gb9JjkMxE=;
        b=RLLLAGimQ/xwLd9K08mCz40oau1+6uPuq5D8VIsWP8S7vbIKNASO+6rvlPRlxtVtaf
         1hDW6YRGHtma1qAhg95JHCO9nmBIOonbw0iJ4DS2iGLY2p3IiIuW1PTHur3Bo/nq+y33
         f0MHDzMoU0qXv7g/RtnS1JimW9cZmb5DHdJGCsjr0+YqLbwqszQ25mFhEbQoHdSzl7cN
         i62MzmQNmg1WnSJvoSki7UALOOk9QCJPLx6h1Pkf7M3RWpB5lUA6iWv4CfdD3s6ClaUM
         khf7j0zWQiNIm3347aL6iLjLsPv/FfT8g+n5yXuVVxeysprtZmlwlr/rLTIenv2it7LS
         RyVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=CiBFBXYWYqvmkbtepgV7xTn8x0QSeVWrN7gb9JjkMxE=;
        b=CM7x4KKITp6sFi+++u9dfjYBfI4scdRFwRkZ6NqqlxZ6OAj/yrcKLXhpv9kjKEngOB
         WL7rFQ6GQWeK2Xq3PNjKuLyEvzTPyJ5N8WrcM7B0AzUBUmykSJYJOdTZBE0jqskwUOSU
         AdgjzYkDBFwYeisGyqlgCBxM17OEkIzbzkbg93teNU0BBk6xRUp27MkNGGYrOajQZ+Qq
         pPzqhrynvAtGblS+r1WhPDEFz2lMuq+uM+cV9uMcDaBARXqVyEJE1gZR736L7n//ikug
         9WOvKs0zMYVZ1SPUKVokFHuKgmTfgecqxbX9lGjzXX8lgzgi2EgbbZDs+hkx5UOMUlhq
         Er6Q==
X-Gm-Message-State: APjAAAUeQCi+9KAD78MiI6dWrSOrh7wHDmhtcXCFllsBWXVMKBI0TbgW
        rg4eLYS1fe2fqIKNaCeeIPzlF22J79M=
X-Google-Smtp-Source: APXvYqwDkMND0be0gzaFE39yoqERZT+iYYWbX9+AwAhrwQ2REeZnZmex2sekQTwycCUG6koiRVFn0w==
X-Received: by 2002:a1c:e912:: with SMTP id q18mr15674003wmc.137.1557760418413;
        Mon, 13 May 2019 08:13:38 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:d07d:5e75:4e14:205c? ([2a01:e35:8b63:dc30:d07d:5e75:4e14:205c])
        by smtp.gmail.com with ESMTPSA id v184sm21280302wma.6.2019.05.13.08.13.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 08:13:37 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Dan Winship <danw@redhat.com>
References: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
 <b89367f0-18d5-61b2-2572-b1e5b4588d8d@6wind.com>
 <20190513150812.GA18478@bistromath.localdomain>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <771b21d6-3b1e-c118-2907-5b5782f7cb92@6wind.com>
Date:   Mon, 13 May 2019 17:13:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190513150812.GA18478@bistromath.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 13/05/2019 à 17:08, Sabrina Dubroca a écrit :
> 2019-05-13, 16:50:51 +0200, Nicolas Dichtel wrote:
>> Le 13/05/2019 à 15:47, Sabrina Dubroca a écrit :
>>> Currently, nla_put_iflink() doesn't put the IFLA_LINK attribute when
>>> iflink == ifindex.
>>>
>>> In some cases, a device can be created in a different netns with the
>>> same ifindex as its parent. That device will not dump its IFLA_LINK
>>> attribute, which can confuse some userspace software that expects it.
>>> For example, if the last ifindex created in init_net and foo are both
>>> 8, these commands will trigger the issue:
>>>
>>>     ip link add parent type dummy                   # ifindex 9
>>>     ip link add link parent netns foo type macvlan  # ifindex 9 in ns foo
>>>
>>> So, in case a device puts the IFLA_LINK_NETNSID attribute in a dump,
>>> always put the IFLA_LINK attribute as well.
>>>
>>> Thanks to Dan Winship for analyzing the original OpenShift bug down to
>>> the missing netlink attribute.
>>>
>>> Analyzed-by: Dan Winship <danw@redhat.com>
>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> I would say:
>> Fixes: 5e6700b3bf98 ("sit: add support of x-netns")
>>
>> Because before this patch, there was no device with an iflink that can be put in
>> another netns.
> 
> That tells us how far back we might want to backport this fix, but not
> which commit introduced the bug. I think Fixes should refer to the
> introduction of the faulty code, not to what patch made it visible (if
> we can find both).
No sure to follow you. The problem you describe cannot happen before commit
5e6700b3bf98, so there cannot be a "faulty" patch before that commit.
Anyway, both commits are very old, so it doesn't matter.


Thank you,
Nicolas
