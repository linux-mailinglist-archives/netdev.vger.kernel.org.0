Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744EF218590
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgGHLHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgGHLHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:07:48 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A950C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:07:48 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dp18so49928988ejc.8
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dn4KfVoCLeYZdf/dIimkVBTP9PVxTOpzNLHMkhdzcqM=;
        b=YQCAm/KFzpwMHDTr6KpilBn7W0KwcAxQjXma5AsHjXj8vuDGnPgIRLBvDxPTMKfwQM
         wVlSoI641bAEoeYgTWpWolnkETImiSMvrEmWcUdi4hMn3PbiF7Pp5BnUvIcUqsqVDLc8
         HmEnSyEU0KBjO2C2UDy6TDlJZSMLZ7dvlF3lQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dn4KfVoCLeYZdf/dIimkVBTP9PVxTOpzNLHMkhdzcqM=;
        b=DcVH6M2F7o3Dp8GdhkT+4Z7wRUFs+zHA5BfkWVJpdHixhpyMBhwbllmHS5r/snATPG
         Hp4LqNBixrAGHA2EMZonav8AUDWm76bRLXYAhbV5M5BzzBUVVEyGY37pmsO7SzPE9KHW
         kF3l++soxvgKz4/vBaRZFFw3Glf0AxcVU3wujCvQt+Ucb80hXEBzo5F201GnE8tspqxu
         L9XPwUKnZrFSEbExvWmKLnR2fvUFsyEGw1+6USlEkrBh84R6b7v2XMG+KPoPNPCYo8mr
         jTmLh+dYJlJdq58tjnMUlPXxWHg1mKkqZCezbKQ41rFYNFEIuFrl4MwEp5PfFZJ08RW4
         cuYQ==
X-Gm-Message-State: AOAM531/KtRYJbDBww7UASPYPu2Pay5U2uoj9fELx4AwBBr8TqOvh1mi
        8nlmGLC4eFMY9efYVRnogbQfLHJ7l0zDRw==
X-Google-Smtp-Source: ABdhPJwbkB0v010yPkeBR/fV3GO8ZXlcNI8XP7Bb1h5cVlmdEZl4IVb/ISjUYwhDdZahMK3rdd/lvA==
X-Received: by 2002:a17:906:8542:: with SMTP id h2mr50218531ejy.517.1594206466305;
        Wed, 08 Jul 2020 04:07:46 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id y2sm30286181eda.85.2020.07.08.04.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:07:45 -0700 (PDT)
Subject: Re: What is the correct way to install an L2 multicast route into a
 bridge?
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     roopa@cumulusnetworks.com, netdev@vger.kernel.org
References: <20200708090454.zvb6o7jr2woirw3i@skbuf>
 <6e654725-ec5e-8f6d-b8ae-3cf8b898c62e@cumulusnetworks.com>
 <20200708094200.p6lprjdpgncspima@skbuf>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <0d554adb-29c3-3b4a-d696-4d4bfd567767@cumulusnetworks.com>
Date:   Wed, 8 Jul 2020 14:07:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200708094200.p6lprjdpgncspima@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/07/2020 12:42, Vladimir Oltean wrote:
> On Wed, Jul 08, 2020 at 12:16:27PM +0300, Nikolay Aleksandrov wrote:
>> On 08/07/2020 12:04, Vladimir Oltean wrote:
>>> Hi,
>>>
>>> I am confused after reading man/man8/bridge.8. I have a bridge br0 with
>>> 4 interfaces (eth0 -> eth3), and I would like to install a rule such
>>> that the non-IP multicast address of 09:00:70:00:00:00 is only forwarded
>>> towards 3 of those ports, instead of being flooded.
>>> The manual says that 'bridge mdb' is only for IP multicast, and implies
>>> that 'bridge fdb append' (NLM_F_APPEND) is only used by vxlan. So, what
>>> is the correct user interface for what I am trying to do?
>>>
>>> Thank you,
>>> -Vladimir
>>>
>>
>> Hi Vladimir,
>> The bridge currently doesn't support L2 multicast routes. The MDB interface needs to be extended
>> for such support. Soon I'll post patches that move it to a new, entirely netlink attribute-
>> based, structure so it can be extended easily for that, too. My change is motivated mainly by SSM
>> but it will help with implementing this feature as well.
>> In case you need it sooner, patches are always welcome! :)
>>
>> Current MDB fixed-size structure can also be used for implementing L2 mcast routes, but it would
>> require some workarounds. 
>>
>> Cheers,
>>  Nik
>>
>>
> 
> Thanks, Nikolay.
> Isn't mdb_modify() already netlink-based? I think you're talking about
> some changes to 'struct br_mdb_entry' which would be necessary. What
> changes would be needed, do you know (both in the 'workaround' case as
> well as in 'fully netlink')?
> 
> -Vladimir
> 

That is netlink-based, but the uAPI (used also for add/del/dump) uses a fixed-size struct
which is very inconvenient and hard to extend. I plan to add MDBv2 which uses separate
netlink attributes and can be easily extended as we plan to add some new features and will
need that flexibility. It will use a new container attribute for the notifications as well.

In the workaround case IIRC you'd have to add a new protocol type to denote the L2 routes, and
re-work the lookup logic to include L2 in non-IP case. You'd have to edit the multicast fast-path,
and everything else that assumes the frame has to be IP/IPv6. I'm sure I'm missing some details as
last I did this was over an year ago where I made a quick and dirty hack that implemented it with proto = 0
to denote an L2 entry just as a proof of concept.
Also you would have to make sure all of that is compatible with current user-space code. For example
iproute2/bridge/mdb.c considers that proto can be only IPv4 or IPv6 if it's not v4, i.e. it will
print the new L2 entries as :: IPv6 entries until it's fixed.

Obviously some of the items for the workaround case are valid in all cases for L2 routes (e.g. fast-path/lookup edit).
But I think it's not that hard to implement without affecting the fast path much or even at all.

Cheers,
 Nik



