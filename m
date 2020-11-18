Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49F22B7398
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgKRBMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727288AbgKRBMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:12:35 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12234C061A48
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 17:12:35 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id s10so267454ioe.1
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 17:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wEXCS7fln5JmQRcdbX8/pm/swjvok1VPDmb5j7lIfbY=;
        b=qN9PaWDAZ2wbW2qjgfpGsTwlPAfg/edElEnCi13u8Q6VKeltzHiQKrPLE6EWTEHh9w
         EBXf+KjjUXCsf77ql2GsE9/tfUbLwbnni4Y1OXzrIQfDN8wUQP16QtvhirepoqF0jF4B
         TuNUh2BbRFnDwAcLkfSRwq99Og8K4u7X7+Kxc9cb04nT0o+tL11IsThIU1ctTSe+F0ET
         /U/dyVRELBFTucj/kgjUUPsXsqHgo5wJxSGZiR2jSD4YP0Lb4p9HiPxL9SQNxvvl8LO4
         QFlpKG6sUjqH99pPHLAcNDVKJ5XFhLHyHuNJI/LLL8wnNBlfcQ+PUOFj/+V/jHUDM5Ce
         95dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wEXCS7fln5JmQRcdbX8/pm/swjvok1VPDmb5j7lIfbY=;
        b=UwHw1T1l96/R2C/o0Osk3CPyJoVp9yZ9xfyv4ANn5gmvtpYm4onQXERaI4F0YJat/g
         QBMuKsnHSj2lQc7e1Wgf0VdEe43ED7bku0e6hgAYVJaa2IYJD8LWb/ZmAs28lW2REm51
         4DNKnbkc2LuHGVETsaYU1DgE5V13Ni0zDjyuoMHT5ylHiP7fQQCbYLyencPWpynNjamh
         Y01OOluFH3gpmJtIll0MDuDa3jbR48R7lHmYLJkPqKnZzhFplNMpSL4v1ngNKcMwXa/W
         k1zrGQNK0P7U6cUIHzpuI2fcVlD3rAToQfCIrzR0IaQ2m3B0OoyMuNbBI91baHbHeEt1
         rXwA==
X-Gm-Message-State: AOAM531KsfDpokVZi54UAH3pgjqmcGgVC3tm3c/vYHh0apY5FQ/hiUtE
        YGi0+o9Gw+9FMwF4nM8NBlM=
X-Google-Smtp-Source: ABdhPJy+EJU9wwjm6Tg16VKjXK5XnYOvMdT9RZ0FuB21gMAF0xhZ+ldSVBg7Bjzqjo5xEm5IhawRmA==
X-Received: by 2002:a05:6638:3f1:: with SMTP id s17mr6087741jaq.102.1605661954398;
        Tue, 17 Nov 2020 17:12:34 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:c472:ae53:db1e:5dd0])
        by smtp.googlemail.com with ESMTPSA id s134sm10380845ilc.64.2020.11.17.17.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 17:12:33 -0800 (PST)
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be
 controlled
To:     =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS1?=
         =?UTF-8?B?4KS+4KSwKQ==?= <maheshb@google.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
 <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
 <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9ji24VkLipTCFSAU+L8yqKt9nfPSNfks9_V1Tnb0ztPrfA@mail.gmail.com>
 <20201117171830.GA286718@shredder.lan>
 <CAF2d9jhJq76KWaMGZLTTX4rLGvLDp+jLxCG9cTvv6jWZCtcFAA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b3445db2-5c64-fd31-b555-6a49b0fa524e@gmail.com>
Date:   Tue, 17 Nov 2020 18:12:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <CAF2d9jhJq76KWaMGZLTTX4rLGvLDp+jLxCG9cTvv6jWZCtcFAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/20 1:53 PM, Mahesh Bandewar (महेश बंडेवार) wrote:
> On Tue, Nov 17, 2020 at 9:18 AM Ido Schimmel <idosch@idosch.org> wrote:
>>
>> On Mon, Nov 16, 2020 at 01:03:32PM -0800, Mahesh Bandewar (महेश बंडेवार) wrote:
>>> On Mon, Nov 16, 2020 at 12:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>
>>>> On Mon, 16 Nov 2020 12:02:48 -0800 Mahesh Bandewar (महेश बंडेवार) wrote:
>>>>>>> diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
>>>>>>> index a1c77cc00416..76dc92ac65a2 100644
>>>>>>> --- a/drivers/net/loopback.c
>>>>>>> +++ b/drivers/net/loopback.c
>>>>>>> @@ -219,6 +219,13 @@ static __net_init int loopback_net_init(struct net *net)
>>>>>>>
>>>>>>>       BUG_ON(dev->ifindex != LOOPBACK_IFINDEX);
>>>>>>>       net->loopback_dev = dev;
>>>>>>> +
>>>>>>> +     if (sysctl_netdev_loopback_state) {
>>>>>>> +             /* Bring loopback device UP */
>>>>>>> +             rtnl_lock();
>>>>>>> +             dev_open(dev, NULL);
>>>>>>> +             rtnl_unlock();
>>>>>>> +     }
>>>>>>
>>>>>> The only concern I have here is that it breaks notification ordering.
>>>>>> Is there precedent for NETDEV_UP to be generated before all pernet ops
>>>>>> ->init was called?
>>>>> I'm not sure if any and didn't see any issues in our usage / tests.
>>>>> I'm not even sure anyone is watching/monitoring for lo status as such.
>>>>
>>>> Ido, David, how does this sound to you?
>>>>
>>>> I can't think of any particular case where bringing the device up (and
>>>> populating it's addresses) before per netns init is finished could be
>>>> problematic. But if this is going to make kernel coding harder the
>>>> minor convenience of the knob is probably not worth it.
>>>
>>> +Eric Dumazet
>>>
>>> I'm not sure why kernel coding should get harder, but happy to listen
>>> to the opinions.
>>
>> Hi,
>>
>> Sorry for the delay. Does not occur to me as a problematic change. I ran
>> various tests with 'sysctl -qw net.core.netdev_loopback_state=1' and a
>> debug config. Looks OK.
> 
> Thanks for the confirmation Ido. I think Jian is getting powerpc
> config build fixed to address the build-bots findings and then he can
> push the updated version.
> 

If there is no harm in just creating lo in the up state, why not just do
it vs relying on a sysctl? It only affects 'local' networking so no real
impact to containers that do not do networking (ie., packets can't
escape). Linux has a lot of sysctl options; is this one really needed?
