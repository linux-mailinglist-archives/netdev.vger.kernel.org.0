Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D9139460D
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 18:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbhE1Qvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 12:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236475AbhE1Qum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 12:50:42 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80008C061574;
        Fri, 28 May 2021 09:48:17 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c12so3683247pfl.3;
        Fri, 28 May 2021 09:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f4jz1sy05gHDrPQFFfHgBCP1ldZwBJqEEWVLg5ho68I=;
        b=t2Mx2o3QBi9XPOGLo7Lc4Ok8QHlICIMzOKsJJPDc26CIfadBkWgemAnXj6JVzkGsbl
         QOrpHIKE/bqHW9u30vukIKTea8MD1P0tfNseiZNY/L70MaMjHWRNkHpgFvQr8BFz7IL3
         KWT7iSswS3Q5DEPNsgqD4yfj9oHfJGDxmYLVkFgz0BaUMsyOEmOydgR7IEVkCWyMYaBW
         AGkUE7pyWMJweHO8MqP+b0ORCu7lm1zRS7CQa7Th6W0pkLr07VKmBnfRdUUJIRHDTYHR
         dsqtBUDRKUYkHCIQHIsXIdrhP794pNCGT2aSl9SCMnN2p+guZHAIYev8UsvxGQ27iPbb
         Oyqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f4jz1sy05gHDrPQFFfHgBCP1ldZwBJqEEWVLg5ho68I=;
        b=fvtITJtdcDpz3BHjPKwUE+lrqyN5O9WBj21GBeq96YP67qAciI/f4hw3ibzerJO4Q6
         Nrn3KnKsSc1B5P62YKEVF8ls9Ao0GWrH5gT/gj9oPe6Zrom3rumNuIL2Y7F7evGv/Uua
         FOAfwUd/vDhFCpBdDm+a21oS1dTLxrlrwOEZWHpUGIOKtXsuXJ5e+UE6ba/qSLOR9SXs
         ApyCIu6X9BCqhGsD8WUf6KTONCaaglnnDWBEk0SNA+qA1r2W/jAQIZdOYS4iCz4tRPkA
         HkTs/vLCjctZIieRTptzWLp+sDO7RZuobkE9AtinyZSOzMCfrjicxY6+lZNizNp/CZ2/
         MOAA==
X-Gm-Message-State: AOAM533q8o4ZnTpt2Bp4YuSuMY6aPVbP2w+9kWyTKWoABlTkUCA7fsup
        /8TZtxj7IMD5CMPUjPTF3H8=
X-Google-Smtp-Source: ABdhPJyiHR+qJog4kzgL9iQ3dfdD1uTIn+Vc9MlCFByAahmhyaYyAwh9+vmozG8Z2tTw+l4j8Cv7oA==
X-Received: by 2002:a62:148e:0:b029:2e4:e5a5:7e33 with SMTP id 136-20020a62148e0000b02902e4e5a57e33mr4723130pfu.9.1622220496748;
        Fri, 28 May 2021 09:48:16 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x23sm4793240pje.52.2021.05.28.09.48.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 May 2021 09:48:15 -0700 (PDT)
Subject: Re: Kernel Panic in skb_release_data using genet
To:     Maxime Ripard <maxime@cerno.tech>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenz@kernel.org>
References: <20210524130147.7xv6ih2e3apu2zvu@gilmour>
 <a53f6192-3520-d5f8-df4b-786b3e4e8707@gmail.com>
 <20210524151329.5ummh4dfui6syme3@gilmour>
 <1482eff4-c5f4-66d9-237c-55a096ae2eb4@gmail.com>
 <6caa98e7-28ba-520c-f0cc-ee1219305c17@gmail.com>
 <20210528163219.x6yn44aimvdxlp6j@gilmour>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <77d412b4-cdd6-ea86-d7fd-adb3af8970d9@gmail.com>
Date:   Fri, 28 May 2021 09:48:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210528163219.x6yn44aimvdxlp6j@gilmour>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 9:32 AM, Maxime Ripard wrote:
> hi Florian,
> 
> On Fri, May 28, 2021 at 09:21:27AM -0700, Florian Fainelli wrote:
>> On 5/24/21 8:37 AM, Florian Fainelli wrote:
>>>
>>>
>>> On 5/24/2021 8:13 AM, Maxime Ripard wrote:
>>>> Hi Florian,
>>>>
>>>> On Mon, May 24, 2021 at 07:49:25AM -0700, Florian Fainelli wrote:
>>>>> Hi Maxime,
>>>>>
>>>>> On 5/24/2021 6:01 AM, Maxime Ripard wrote:
>>>>>> Hi Doug, Florian,
>>>>>>
>>>>>> I've been running a RaspberryPi4 with a mainline kernel for a while,
>>>>>> booting from NFS. Every once in a while (I'd say ~20-30% of all boots),
>>>>>> I'm getting a kernel panic around the time init is started.
>>>>>>
>>>>>> I was debugging a kernel based on drm-misc-next-2021-05-17 today with
>>>>>> KASAN enabled and got this, which looks related:
>>>>>
>>>>> Is there a known good version that could be used for bisection or you
>>>>> just started to do this test and you have no reference point?
>>>>
>>>> I've had this issue for over a year and never (I think?) got a good
>>>> version, so while it might be a regression, it's not a recent one.
>>>
>>> OK, this helps and does not really help.
>>>
>>>>
>>>>> How stable in terms of clocking is the configuration that you are using?
>>>>> I could try to fire up a similar test on a Pi4 at home, or use one of
>>>>> our 72112 systems which is the closest we have to a Pi4 and see if that
>>>>> happens there as well.
>>>>
>>>> I'm not really sure about the clocking. Is there any clock you want to
>>>> look at in particular?
>>>
>>> ARM, DDR, AXI, anything that could cause some memory corruption to occur
>>> essentially. GENET clocks are fairly fixed, you have a 250MHz clock and
>>> a 125MHz clock feeding the data path.
>>>
>>>>
>>>> My setup is fairly simple: the firmware and kernel are loaded over TFTP
>>>> and the rootfs is mounted over NFS, and the crash always occur around
>>>> init start, so I guess when it actually starts to transmit a decent
>>>> amount of data?
>>>
>>> Do you reproduce this problem with KASAN disabled, do you eventually
>>> have a crash pointing back to the same location?
>>>
>>> I have a suspicion that this is all Pi4 specific because we regularly
>>> run the GENET driver through various kernel versions (4.9, 5.4 and 5.10
>>> and mainline) and did not run into that.
>>
>> I have not had time to get a set-up to reproduce what you are seeing,
>> could you share your .config meanwhile? Thanks
> 
> Sorry, I didn't have the time to check how the clock were behaving.
> 
> You'll find attached my config.txt file and .config
> 
> I'm booting the board entirely from TFTP (which might introduce some
> issues in the "handoff" from the bootloader to the kernel), you'll find
> some guide there:
> 
> https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/net_tutorial.md

That is also how I boot my Pi4 at home, and I suspect you are right, if
the VPU does not shut down GENET's DMA, and leaves buffer addresses in
the on-chip descriptors that point to an address space that is managed
totally differently by Linux, then we can have a serious problem and
create some memory corruption when the ring is being reclaimed. I will
run a few experiments to test that theory and there may be a solution
using the SW_INIT reset controller to have a big reset of the controller
before handing it over to the Linux driver.
-- 
Florian
