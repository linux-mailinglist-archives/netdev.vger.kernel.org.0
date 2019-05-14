Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 554F11C3D6
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 09:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfENHcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 03:32:36 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52599 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfENHcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 03:32:36 -0400
Received: by mail-wm1-f66.google.com with SMTP id y3so1668757wmm.2
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 00:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2BFyXqonKKLqgfMXLB8iohnEvkSe7GrOc8jcuONaa7Q=;
        b=IIgxfjJMBB985j2UYnxxMoU49Y1FnHXeafKsE4o+k/NR6aS+H1aOmnjWUzPa92sK+y
         xxl+6VBsDc1NKTAsK0IGgxB306w/MsdmGDVk9AGFtihE31jOU/yfwgSXtC6kWz9LREJJ
         9v71O+FFCnhgBFjKMrKW0i68xdyrOfWUf7SGVk0LGiGX3ajvee/dX0+hjW5624EO6YG0
         9Bpuvk0g+2Aow1cys5yWl/p8beXfh+uat5TzoJrh3R1QD2BSiqEK0cUYDoZZVaJa45aq
         CjUZv35P8UQGjRopMCJqMhNJqqQhFo+b/JnXCoaO70g4NXQI8FTCs4P7vPwTxUkX4EcR
         w5QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2BFyXqonKKLqgfMXLB8iohnEvkSe7GrOc8jcuONaa7Q=;
        b=ezPCggolQ8cBN535j/Xev1cWWEac1FYAYYYpPWcw7baB9ZXDgSbJzrvXCh2c5UqayN
         1WxXIkN7QesEPEblXBKjpTZ1T/+L/7Z4vQ8vVbkkpi7g1EniPwZz+jB7m+8X3XCcl4Bc
         skCkJSyKPAk0Xe+YFoemMoSZl/nBRZ/KTdPgmRaj9X5t3crBG261wc7HZbSwLnzF1bQV
         1aIKy1wsvPYD5A3uZn7/fISE0L+si68gpyMR/bI1siaqmCm5YPQgWAPB1Q48AoKx04EB
         /iwvj7xvpboSk8tQlcL5tGduHejqMz8HC3TlDyqBFjCkbdnyc5ITDGNdWGs0TWnj5BMm
         q6/A==
X-Gm-Message-State: APjAAAWqS5CkujSekOeEl4Q9LRF7XKZTDwaIA4KLQ8llqXQnQKkFt/Dg
        v7xQT08hmELcQqHSJdhhJGFzc14nEa0=
X-Google-Smtp-Source: APXvYqxvcbAOvOBUOPDoGtn7ABcXEiFTnhxZQP0AEtob+baMVqme3v9W1UC+GcuImpxIllLIzm6n5w==
X-Received: by 2002:a1c:e702:: with SMTP id e2mr4798191wmh.38.1557819153551;
        Tue, 14 May 2019 00:32:33 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:64b3:e115:e5ef:6e9d? ([2a01:e35:8b63:dc30:64b3:e115:e5ef:6e9d])
        by smtp.gmail.com with ESMTPSA id c131sm1973665wma.31.2019.05.14.00.32.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 00:32:32 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Dan Winship <danw@redhat.com>
References: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
 <b89367f0-18d5-61b2-2572-b1e5b4588d8d@6wind.com>
 <20190513150812.GA18478@bistromath.localdomain>
 <771b21d6-3b1e-c118-2907-5b5782f7cb92@6wind.com>
 <20190513214648.GA29270@bistromath.localdomain>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <65c8778c-9be9-c81f-5a9b-13e070ca38da@6wind.com>
Date:   Tue, 14 May 2019 09:32:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190513214648.GA29270@bistromath.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 13/05/2019 à 23:46, Sabrina Dubroca a écrit :
> 2019-05-13, 17:13:36 +0200, Nicolas Dichtel wrote:
>> Le 13/05/2019 à 17:08, Sabrina Dubroca a écrit :
>>> 2019-05-13, 16:50:51 +0200, Nicolas Dichtel wrote:
>>>> Le 13/05/2019 à 15:47, Sabrina Dubroca a écrit :
>>>>> Currently, nla_put_iflink() doesn't put the IFLA_LINK attribute when
>>>>> iflink == ifindex.
>>>>>
>>>>> In some cases, a device can be created in a different netns with the
>>>>> same ifindex as its parent. That device will not dump its IFLA_LINK
>>>>> attribute, which can confuse some userspace software that expects it.
>>>>> For example, if the last ifindex created in init_net and foo are both
>>>>> 8, these commands will trigger the issue:
>>>>>
>>>>>     ip link add parent type dummy                   # ifindex 9
>>>>>     ip link add link parent netns foo type macvlan  # ifindex 9 in ns foo
>>>>>
>>>>> So, in case a device puts the IFLA_LINK_NETNSID attribute in a dump,
>>>>> always put the IFLA_LINK attribute as well.
>>>>>
>>>>> Thanks to Dan Winship for analyzing the original OpenShift bug down to
>>>>> the missing netlink attribute.
>>>>>
>>>>> Analyzed-by: Dan Winship <danw@redhat.com>
>>>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>>>> I would say:
>>>> Fixes: 5e6700b3bf98 ("sit: add support of x-netns")
>>>>
>>>> Because before this patch, there was no device with an iflink that can be put in
>>>> another netns.
>>>
>>> That tells us how far back we might want to backport this fix, but not
>>> which commit introduced the bug. I think Fixes should refer to the
>>> introduction of the faulty code, not to what patch made it visible (if
>>> we can find both).
>> No sure to follow you. The problem you describe cannot happen before commit
>> 5e6700b3bf98, so there cannot be a "faulty" patch before that commit.
> 
> What about macvlan devices?
> 
> From commit b863ceb7ddce ("[NET]: Add macvlan driver"):
> 
> static int macvlan_init(struct net_device *dev)
> {
> ...
>         dev->iflink             = lowerdev->ifindex;
> ...
> }
> 
> vlan devices also had an iflink assigned since commit ddd7bf9fe4e5.
> 
> What am I missing?
You miss the fact that netns have been introduced after both commits.

What about this one?
Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between network
namespaces.")



Regards,
Nicolas
