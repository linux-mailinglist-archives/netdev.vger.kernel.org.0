Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7F2BF5F7B
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 15:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfKIORR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 09:17:17 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37260 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbfKIORQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 09:17:16 -0500
Received: by mail-lj1-f194.google.com with SMTP id l21so1825286ljg.4
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 06:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=373hZQFjGDkdP8oWwEgNTTKymtleYEbU8x1y8O7m7Q4=;
        b=G256I2sIoSp6v7Pgth5vlVFlVoNGTVPdzMlc+3iK7wEv4frU9HiIPJFWiqwBOY9WwK
         HxMTz32p4o/eL6ukrBwl9ru4dsUUSa61aZ35ukgQIzLsPmgckom0Iz5FnRKUh8KUPelF
         xBuz+RUymPh5FFnf84dnfpXwjUYnel12NkhwwhW4rUvf5yQ4Myf8z2nw8FBaNIIKimrA
         3A1L13Lld8jLBZewoRFJ41NlHZ3jmsS5Uat+QjH7zRAjsQv9RKFxgEcWMxIaTrAPet7u
         T408IpfO1XZCqM7lD878r4U53Qci25wV2MtiXat2NeVKkXzUPrUh5tPVfF+i/9/UIwqc
         HYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=373hZQFjGDkdP8oWwEgNTTKymtleYEbU8x1y8O7m7Q4=;
        b=EGNQYjX2fPelG2YDC15vOENcRwp95/TNRv2FYRFSpwXhCZQaDSFdk+OPtm1/iyCKIM
         bbB87grxmpBQx/2AtUbDnhnIWHCiRN7Y72JwVY4usVTNf4872OvweGh1bn8Rz8XiV3fM
         dzQIXPeLTaSoy5e7bTLhJ1dZf7BM2JANYFOkBwktmpFiYULixUA07tNOQFwJg+DAn1zQ
         Lkjfa0Hhp2l8YLWI8BBeZ2rSaK60SVT2wBTqnUh3Rc3OqT2/kgkfeVf4LQbUjBKBNrTD
         +vuFtxTrhl1LGS9Psd8JDK0oTCsKPP3rmsa1qNHkUFqKLk6bZ+1CzlIvka67SfxqgdZL
         QPaQ==
X-Gm-Message-State: APjAAAVUsby7Q7h3edpTIFNkM+vEer6Y/y4pVJwNYkfF2jfvXlYiIToz
        O6dY7blcvaLnvNlpsvUug80HZQ==
X-Google-Smtp-Source: APXvYqy9v9IeeMY/RwXclXlMYoDeFscZzbeSaXvNZA+Emm8++78lNlt1HEcL7vhe27PXMGBFF7N3iQ==
X-Received: by 2002:a2e:9208:: with SMTP id k8mr10578421ljg.14.1573309034029;
        Sat, 09 Nov 2019 06:17:14 -0800 (PST)
Received: from [192.168.1.169] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s7sm4101921ljo.98.2019.11.09.06.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Nov 2019 06:17:13 -0800 (PST)
Subject: Re: [PATCH v3 1/6] rtnetlink: allow RTM_SETLINK to reference other
 namespaces
To:     =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS1?=
         =?UTF-8?B?4KS+4KSwKQ==?= <maheshb@google.com>
Cc:     nicolas.dichtel@6wind.com, linux-netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
References: <20191107132755.8517-1-jonas@norrbonn.se>
 <20191107132755.8517-2-jonas@norrbonn.se>
 <CAF2d9jjRLZ07Qx0NJ9fi1iUpHn+qYEJ+cacKgBmeZ2FvZLObEQ@mail.gmail.com>
 <fff51fa7-5c42-7fa7-6208-d911b18bd91e@norrbonn.se>
 <CAF2d9jib=Qdn9uB=kKn4CTbqvqOiGs+FGh4427=o+UySLf=BwA@mail.gmail.com>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <7a2038c8-d3a6-2144-f11d-965394d1b420@norrbonn.se>
Date:   Sat, 9 Nov 2019 15:17:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAF2d9jib=Qdn9uB=kKn4CTbqvqOiGs+FGh4427=o+UySLf=BwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mahesh,

Thanks for the detailed response.  It provided valuable insight.

On 08/11/2019 19:55, Mahesh Bandewar (महेश बंडेवार) wrote:
> Hi Jonas, thanks for the response.
> 
> On Fri, Nov 8, 2019 at 12:20 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>>
>> Hi Mahesh,
>>
>> On 07/11/2019 21:36, Mahesh Bandewar (महेश बंडेवार) wrote:
>>> On Thu, Nov 7, 2019 at 5:30 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>>>>
>>>>
>>>> +       /* A hack to preserve kernel<->userspace interface.
>>>> +        * It was previously allowed to pass the IFLA_TARGET_NETNSID
>>>> +        * attribute as a way to _set_ the network namespace.  In this
>>>> +        * case, the device interface was assumed to be in the  _current_
>>>> +        * namespace.
>>>> +        * If the device cannot be found in the target namespace then we
>>>> +        * assume that the request is to set the device in the current
>>>> +        * namespace and thus we attempt to find the device there.
>>>> +        */
>>> Could this bypasses the ns_capable() check? i.e. if the target is
>>> "foo" but your current ns is bar. The process may be "capable" is foo
>>> but the interface is not found in foo but present in bar and ends up
>>> modifying it (especially when you are not capable in bar)?
>>
>> I don't think so.  There was never any capable-check for the "current"
>> namespace so there's no change in that regard.

I was wrong on this point.  There IS a capable-check for the "current" 
net.  The code to create interfaces in 'other' namespaces was already in 
place before my patch and that code does the right thing with respect to 
checking NS capabilities on the "destination" and "link" nets.

My patch is mostly just accounting for the "setlink" aspect of NEWLINK 
where the device already exists in a foreign namespace and needs to be 
searched for there.  Even in that code path, all the ns-capable checks 
are in place and the behaviour is the same as before.

>>
> not having capable-check seems wrong as we don't want random
> not-capable processes to alter settings. However, it may be at the API
> entry level, which will provide necessary protection (haven't
> checked!). Having said that, this could be bad for the stuff that you
> are implementing since I could be in "foo" and attempting to change
> "bar". For this I must be capable in "bar" but the top-level capable
> check will by default check me in "foo" as well which is not required
> and could potentially block me from performing legal operation in
> "bar".
> 
> Not saying this is a problem, but without having an implementation to
> use this would be hard to try. You would most likely have a way to
> verify this, so please check it.

The above shouldn't be an issue with the current implementation.

> 
>> I do think there is an issue with this hack that I can't see any
>> workaround for.  If the user specifies an interface (by name or index)
>> for another namespace that doesn't exist, there's a potential problem if
>> that name/index happens to exist in the "current" namespace.  In that
>> case, one many end up inadvertently modifying the interface in the
>> current namespace.  I don't see how to avoid that while maintaining the
>> backwards compatibility.
>>
> This could very well be the case always for single digit ifindex
> values. (We recently suffered a local scare because of something very
> similar).
> 
>> My absolute preference would be to drop this compat-hack altogether.
>> iproute2 doesn't use a bare TARGET_NETNSID in this manner (for changing
>> namespaces) and I didn't find any other users by a quick search of other
>> prominent Netlink users:  systemd, network-manager, connman.  This
>> compat-hack is there for the _potential ab-user_ of the interface, not
>> for any known such.
>>
> what is forcing you keeping you keeping / implementing this hack? I
> would also prefer simple solution without creating a potential problem
> / vulnerability (problem: potentially modifying unintended interface,
> vulnerability: potentially allow changing without proper credentials;
> both not proven but are possibilities) down the line. One possibility
> is to drop the compatibility hack and keep it as a backup if something
> breaks / someone complains.

OK, this would be my preference, too.  If we can work on the assumption 
that this isn't actually providing compatibility for anybody in 
practice, then we can drop it.  With that, the potential problem of 
inadvertently modifying the wrong device disappears.  There's no problem 
of being able to access a namespace that one isn't capable in, but 
leaving a hole through which the user may end up doing something 
unexpected is pretty ugly.

I'll remove this and repost the series.

Thanks for your insight into this issue.  It was helpful.

/Jonas
