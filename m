Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3190342A79
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 05:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCTEY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 00:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhCTEYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 00:24:08 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D006FC061761
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 21:24:07 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id a8so7001682oic.11
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 21:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ByqpZFu8sTXjh5Avg4yz4HQv6NRmWj7GnqGfhe4521g=;
        b=jFjIzXX+4Ov/D+5uOX9+eh5Acf065rYWB4VDX3kGgk5PFlLiVFLvnp6USGVuX8HsRR
         E1b2JLTj05AOMTtmOkwO/JW4tkyOK5s9NbxRFr6svq1eY5I925mvYxFbHm7B/vDpIWIb
         Js7r7SD4sWJiNFMg3EyZB5hP7pEw/K3f9ZGq8doFUjT4jvtHf9lu1ZavX1NY3PubHCgU
         vhf4gZZMk5toMpy04E9fZl4zIMkKL55bUNa+4BTB+0lBnmjcqB7g16yu+NEqy4wdQkBN
         4Jc8MA5SJ4q6AP7cQsq/YKAqfiHz72KLUM3x/wv752sHpLh9okv1ZIqS6x8B89WZQEDO
         9B0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ByqpZFu8sTXjh5Avg4yz4HQv6NRmWj7GnqGfhe4521g=;
        b=aQuMNwYGNOXzEI8NcW4nls3FWAVRNkf5QC+Le7z62nN7aZTZcFV/xsHvMJBUqN3QZi
         m35KXMdspf2w2R+ZITsqwZf+ZadABrK1Aj91KkfmESNZzcWsqWq4NpSRLi+J1zmKOLVQ
         B8gbWR08ag1n0WgOo3sczAcuMWkD/NycNf0LXhdlGqRjS5RGW0WNPM3xQHymn02hlDN7
         Q27O4Fpo8YSsmoVnWM5ykJm0m6oKPPRCTEgOQ+VhVUFwkXa7QzHHP5IjYr5covOj/91X
         tZwYGRyqP9MO+Rr+tH5pmtp0s/RECaAYYv1iF8VNVRo58oSjOEUkqw+eIKekvB1k/r2H
         O0Ig==
X-Gm-Message-State: AOAM531HWm4HzJqLArMQWFU1WsQ93iqCzHLj5SprgDa40olbLKZpBuu9
        whJWS50skaHZGGdyFtZqUxmsemcxMOo=
X-Google-Smtp-Source: ABdhPJwwJOM1LRTqj9P4aD61L9GnE4YtfEnmvxfD/He/7sgVIPer3rBwXatji09vX+RrdDYEDn6Z8A==
X-Received: by 2002:aca:d608:: with SMTP id n8mr3210864oig.127.1616214247154;
        Fri, 19 Mar 2021 21:24:07 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:e449:7854:b17:d432])
        by smtp.googlemail.com with ESMTPSA id z17sm13641ote.77.2021.03.19.21.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 21:24:06 -0700 (PDT)
Subject: Re: [PATCH v3] icmp: support rfc5837
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Ishaan Gandhi <ishaangandhi@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210317221959.4410-1-ishaangandhi@gmail.com>
 <f65cb281-c6d5-d1c9-a90d-3281cdb75620@gmail.com>
 <5E97397E-7028-46E8-BC0D-44A3E30C41A4@gmail.com>
 <45eff141-30fb-e8af-5ca5-034a86398ac9@gmail.com>
 <CA+FuTSd9kEnU3wysOVE21xQeC_M3c7Rm80Y72Ep8kvHaoyox+w@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6a7f33a5-13ca-e009-24ac-fde59fb1c080@gmail.com>
Date:   Fri, 19 Mar 2021 22:24:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CA+FuTSd9kEnU3wysOVE21xQeC_M3c7Rm80Y72Ep8kvHaoyox+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/21 6:53 PM, Willem de Bruijn wrote:
> On Fri, Mar 19, 2021 at 7:54 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 3/19/21 10:11 AM, Ishaan Gandhi wrote:
>>> Thank you. Would it be better to do instead:
>>>
>>> +     if_index = skb->skb_iif;
>>>
>>> or
>>>
>>> +     if_index = ip_version == 4 ? inet_iif(skb) : skb->skb_iif;
>>>
>>
>> If the packet comes in via an interface assigned to a VRF, skb_iif is
>> most likely the VRF index which is not what you want.
>>
>> The general problem of relying on skb_iif was discussed on v1 and v2 of
>> your patch. Returning an iif that is a VRF, as an example, leaks
>> information about the networking configuration of the device which from
>> a quick reading of the RFC is not the intention.
>>
>> Further, the Security Considerations section recommends controls on what
>> information can be returned where you have added a single sysctl that
>> determines if all information or none is returned. Further, it is not a
>> a per-device control but a global one that applies to all net devices -
>> though multiple entries per netdevice has a noticeable cost in memory at
>> scale.
>>
>> In the end it seems to me the cost benefit is not there for a feature
>> like this.
> 
> The sysctl was my suggestion. The detailed filtering suggested in the
> RFC would add more complexity, not helping that cost benefit analysis.
> I cared mostly about being able to disable this feature outright as it has
> obvious risks.
> 
> But perhaps that is overly simplistic. The RFC suggests deciding trusted
> recipients based on destination address. With a sysctl this feature can be
> only deployed when all possible recipients are trusted, i.e., on an isolated
> network. That is highly limiting.
> 
> Perhaps a per-netns trusted subnet prefix?
> 
> The root admin should always be able to override and disable this outright.
> 

sure a sysctl is definitely required for a feature like this.

From my perspective to be useful the control needs to be per interface
(e.g., management interface vs dataplane devices) and that has a higher
cost. Add in the amount of information returned and we know from other
examples that some users will want to limit which data is returned and
that increases the number of sysctls per device.

On top of that there is the logic of resolving what is the right device
and its information to return. There is are multiple layers - nic port,
bond, vlan, bridge, vrf, macvlan - each of which might be relevant. The
RFC referenced unnumbered devices as the ingress device. It seems like a
means for leaking information which comes back to the sysctl for proper
controls.

At the end of the day, what is the value of this feature vs the other
ICMP probing set?

