Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAF74082CD
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 04:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbhIMCVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 22:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbhIMCVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 22:21:42 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED779C061574
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 19:20:26 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id v2so12112247oie.6
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 19:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Rkbg1z2jp/WrtBim6mGGAn7tjmczTjLfm1uvxszXIVM=;
        b=PMUr495n2vvsyERUNlCkHLzoozmmnkoC7DtNOziS6gD/iB07e6sQDRAS2We9NCwAue
         tzX/rLI/zL9YsFLdou17Y58aPnXiNwvEpDsLYBvrk75lxi3iG3cm+IAIRGNtsBE6uTsR
         EwtQKIrwy81IEhRSg29E19ARc9TyjYc14eYY+rmhrgI3PDocrrpG1gw5u5766NgASZVi
         KQz3CxQLYx5LnW2wgo/ikL5f01zx02qmOKXT/ylXwCer7WO1LUYwvkD6t21JGHmnRIW8
         3TD6F+JgvW09qCjdlxrA8YxMBJLo1nrDkRSJvnNefcF7dnlJ3meAlradguH6NCcydl5c
         KLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Rkbg1z2jp/WrtBim6mGGAn7tjmczTjLfm1uvxszXIVM=;
        b=u4h53/Ydlqh7+1DnQIQPKM9DKoL/MfSP+nH1lcJdHQkWKgkBK6Kf+6Xi86rk6eaIFC
         rAmM4wWxKW/NcWtFi49I9/asK3Aaxi0ROTy/uT2ZhiKs3pqNJf9P20hHQcAy6RfV9fDP
         E8yBcMPwapmA0dNyrzIuJVi//IuDMw2NSKjGeR1FnCKtXe8zZ2UCVL3JKaIXtsbGyH33
         YtUjIcF3PK8GQ0FoMwfG6hvAeMx6Z8GWnt/hXvzi2uZ4h8mu3/c27f66uRPy0k8qAB/a
         VKgUSOfCx2CvEqCAgzJeS7qa7aeGO1gU56u4cTwtaez9mtbEha0bajbRJ+WAD8jYiFvg
         1TEg==
X-Gm-Message-State: AOAM533WG/lubFk0/7F7AsXRbbMnkXWYBdDOCMuizpPo2v/AYn4lW+PE
        FubyvmqB6u268OfossewlVk=
X-Google-Smtp-Source: ABdhPJytF4E37+s8UUCd3M1iVRXX8LMPrcTAnpMAcyfNyb+bZv3WpXghRna/H97t9p1A5Mk2kCvv6Q==
X-Received: by 2002:aca:ac13:: with SMTP id v19mr6178291oie.93.1631499626198;
        Sun, 12 Sep 2021 19:20:26 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:a5c0:7e4b:65a3:3ba6? ([2600:1700:dfe0:49f0:a5c0:7e4b:65a3:3ba6])
        by smtp.gmail.com with ESMTPSA id q26sm1537180otf.39.2021.09.12.19.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 19:20:25 -0700 (PDT)
Message-ID: <37a4bef7-68de-f618-f741-d0de49c88e82@gmail.com>
Date:   Sun, 12 Sep 2021 19:20:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH net] net: dsa: flush switchdev workqueue before
 tearing down CPU/DSA ports
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210912160015.1198083-1-vladimir.oltean@nxp.com>
 <5223b1d0-b55b-390c-b3d3-f6e6fa24d6d8@gmail.com>
 <20210912161913.sqfcmff77ldc3m5e@skbuf>
 <6af5c67f-db27-061c-3a33-fbc4cede98d1@gmail.com>
 <20210912163341.zlhsgq3uvkro3bem@skbuf>
 <763e2236-31f9-8947-22d1-cf0b48d8a81a@gmail.com>
 <20210913021235.hlq2q2tx5iteho3x@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210913021235.hlq2q2tx5iteho3x@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/12/2021 7:12 PM, Vladimir Oltean wrote:
> On Sun, Sep 12, 2021 at 07:06:25PM -0700, Florian Fainelli wrote:
>>
>>
>> On 9/12/2021 9:33 AM, Vladimir Oltean wrote:
>>> On Sun, Sep 12, 2021 at 09:24:53AM -0700, Florian Fainelli wrote:
>>>>
>>>>
>>>> On 9/12/2021 9:19 AM, Vladimir Oltean wrote:
>>>>> On Sun, Sep 12, 2021 at 09:13:36AM -0700, Florian Fainelli wrote:
>>>>>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>>>
>>>>>> Did you post this as a RFC for a particular reason, or just to give
>>>>>> reviewers some time?
>>>>>
>>>>> Both.
>>>>>
>>>>> In principle there's nothing wrong with what this patch does, only
>>>>> perhaps maybe something with what it doesn't do.
>>>>>
>>>>> We keep saying that a network interface should be ready to pass traffic
>>>>> as soon as it's registered, but that "walk dst->ports linearly when
>>>>> calling dsa_port_setup" might not really live up to that promise.
>>>>
>>>> That promise most definitively existed back when Lennert wrote this code and
>>>> we had an array of ports and the switch drivers brought up their port in
>>>> their ->setup() method, nowadays, not so sure anymore because of the
>>>> .port_enable() as much as the list.
>>>>
>>>> This is making me wonder whether the occasional messages I am seeing on
>>>> system suspend from __dev_queue_xmit: Virtual device %s asks to queue
>>>> packet! might have something to do with that and/or the inappropriate
>>>> ordering between suspending the switch and the DSA master.
>>>
>>> Sorry, I have never tested the suspend/resume code path, mostly because
>>> I don't know what would the easiest way be to wake up my systems from
>>> suspend. If you could give me some pointers there I would be glad to
>>> look into it.
>>
>> If your systems support suspend/resume just do:
>>
>> echo mem > /sys/power/state
>> or
>> echo standby > /sys/power/state
>>
>> if they don't, then maybe a x86 VM with dsa_loop may precipitate the
>> problem, but since it uses DSA_TAG_PROTO_NONE, I doubt it, we would need to
>> pass traffic on the DSA devices for this warning to show up.
> 
> I figured out a working combination in the meanwhile, I even found a bug
> in the process:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210912192805.1394305-1-vladimir.oltean@nxp.com/
> 
> However I did not see those messages getting printed while pinging after
> system resume (note that none of the DSA switch drivers I tested with
> did implement .suspend or .resume), with net-next or with linux-stable/linux-5.14.y.
> 
> Is there more to your setup to reproduce this issue?

All switch ports are brought up with a DHCP client, the issue is 
definitively intermittent and not frequent, I don't have suspend/resume 
working on 5.14.y yet, but going as far back as 5.10.y should let you 
see the same kind of messages.
-- 
Florian
