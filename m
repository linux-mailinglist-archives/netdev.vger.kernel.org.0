Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B45178BA4
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 08:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgCDHoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 02:44:34 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45109 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728486AbgCDHoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 02:44:34 -0500
Received: by mail-lj1-f193.google.com with SMTP id e18so847209ljn.12
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 23:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XzXyuRZmi2ineNNnRHnggrwYRu3yURFlK1CjvGMHiK0=;
        b=ft9InShSsVcmZ07pgNCq/uJPtA2TyHKU6BDLzOg6tGru0Ps7llSFk5OGpGuuD1NguR
         ll9ZM80AKC8YrUL9WGznCdDGiXA+zvKJzkCX4nMxAWE3HjSDcPnZKLCtCp27Bsz2tajH
         gA2ETv7pU6PU/mle2ZE/999dkFOKg0BUys2OwPYPumTkOdg68Bv26trjNVAVGqmpi6h4
         HQV1rLMhQ84DnuuaocBjcYGCjukUeIRToNNpVnr5lY1Azhj5ETPkEIMvBAC9auAKyMIl
         NgOTFz4Mkzcaw21ndUZ+WZPJXyykXXVh39MR6PMncXd5gk8ke0OnEykqP/WgrRdRkyNP
         3Cbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XzXyuRZmi2ineNNnRHnggrwYRu3yURFlK1CjvGMHiK0=;
        b=DZFmgkJOlIcJ99DxcJin7AyBkUXA28zSeYoqhk2E6nEYLhfWVA0jcE6soNDf7jyvuj
         4N9hOF4pW1+Cbz2G3lscn/JDaxa6VNkfNAFIMPA+SgVqwCIHRMiyhfpxlzCU6qFx01Kl
         MTshwZiGaD2RmdBy7U0NvjxUc0tWpEs3Zb/24W1kCG6n1WmWF+GlJy7cJqylc+12IIuh
         A9e2CjMDzrFvzOoJZkzaJnISWlS6NJYhU1pqxzZoN8eiKHtEXy7XDZDZv0maCwj9Mu2I
         XuV0huSFf4RfRWS8CJ7lgOSdZka7uux5xW0TJA9qda8xdEjR9IloM8VXCBqyNKmBOlQy
         UZiA==
X-Gm-Message-State: ANhLgQ01l5i110aQKoPxG0ea5fdyJNz173T7506ICMuOGuEFtqlelGKs
        8IEtQUtZUCWAXod7JC5spYM=
X-Google-Smtp-Source: ADFU+vsmouCvg746o9vSalv74q8QRvktptY7UMteb77hqK3BKYbpde3w1EmVd/DGKej0rKLncSy4mw==
X-Received: by 2002:a2e:87d7:: with SMTP id v23mr267706ljj.10.1583307872382;
        Tue, 03 Mar 2020 23:44:32 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id p24sm12303103lfo.93.2020.03.03.23.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 23:44:31 -0800 (PST)
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
 <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
 <20200303090035.GV2159@dhcp-12-139.nay.redhat.com>
 <20200303091105.GW2159@dhcp-12-139.nay.redhat.com>
 <bed8542b-3dc0-50e0-4607-59bd2aed25dd@gmail.com>
 <20200304064504.GY2159@dhcp-12-139.nay.redhat.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <d34a35e0-2dbe-fab8-5cf8-5c80cb5ec645@gmail.com>
Date:   Wed, 4 Mar 2020 08:44:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304064504.GY2159@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.03.2020 07:45, Hangbin Liu wrote:
> On Tue, Mar 03, 2020 at 10:23:12AM +0100, Rafał Miłecki wrote:
>> On 03.03.2020 10:11, Hangbin Liu wrote:
>>> On Tue, Mar 03, 2020 at 05:00:35PM +0800, Hangbin Liu wrote:
>>>> On Tue, Mar 03, 2020 at 07:16:44AM +0100, Rafał Miłecki wrote:
>>>>> It appears that every interface up & down sequence results in adding a
>>>>> new ff02::2 entry to the idev->mc_tomb. Doing that over and over will
>>>>> obviously result in running out of memory at some point. That list isn't
>>>>> cleared until removing an interface.
>>>>
>>>> Thanks Rafał, this info is very useful. When we set interface up, we will
>>>> call ipv6_add_dev() and add in6addr_linklocal_allrouters to the mcast list.
>>>> But we only remove it in ipv6_mc_destroy_dev(). This make the link down save
>>>> the list and link up add a new one.
>>>>
>>>> Maybe we should remove the list in ipv6_mc_down(). like:
>>>
>>> Or maybe we just remove the list in addrconf_ifdown(), as opposite of
>>> ipv6_add_dev(), which looks more clear.
>>>
>>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>>> index 164c71c54b5c..4369087b8b74 100644
>>> --- a/net/ipv6/addrconf.c
>>> +++ b/net/ipv6/addrconf.c
>>> @@ -3841,6 +3841,12 @@ static int addrconf_ifdown(struct net_device *dev, int how)
>>>                   ipv6_ac_destroy_dev(idev);
>>>                   ipv6_mc_destroy_dev(idev);
>>>           } else {
>>> +               ipv6_dev_mc_dec(dev, &in6addr_interfacelocal_allnodes);
>>> +               ipv6_dev_mc_dec(dev, &in6addr_linklocal_allnodes);
>>> +
>>> +               if (idev->cnf.forwarding && (dev->flags & IFF_MULTICAST))
>>> +                       ipv6_dev_mc_dec(dev, &in6addr_linklocal_allrouters);
>>> +
>>>                   ipv6_mc_down(idev);
>>>           }
>>
>> FWIW I can confirm it fixes the problem for me!
>>
>> Only one ff02::2 entry is present when removing interface:
>>
>> [  105.686503] [ipv6_mc_destroy_dev] idev->dev->name:mon-phy0
>> [  105.692056] [ipv6_mc_down] idev->dev->name:mon-phy0
>> [  105.696957] [ipv6_mc_destroy_dev -> __mld_clear_delrec] kfree(pmc:c64fd880) ff02::2
> 
> Hi Rafał,
> 
> When review the code, I got confused. On the latest net code, we only
> add the allrouter address to multicast list in function
> 1) ipv6_add_dev(), which only called when there is no idev. But link down and
>     up would not re-create idev.
> 2) dev_forward_change(), which only be called during forward change, this
>     function will handle add/remove allrouter address correctly.

Sharp eye! You're right, I tracked (with just a pr_info) all usages of
in6addr_linklocal_allrouters and none gets triggered during my testing
routine. I'm wondering if I should start blaming my OpenWrt user space
now.


> So I still don't know how you could added the ff02::2 on same dev multi times.
> Does just do `ip link set $dev down; ip link set $dev up` reproduce your
> problem? Or did I miss something?

A bit old-fashioned with ifconfig but basically yes, that's my test:

iw phy phy0 interface add mon-phy0 type monitor
for i in $(seq 1 10); do ifconfig mon-phy0 up; ifconfig mon-phy0 down; done
iw dev mon-phy0 del
