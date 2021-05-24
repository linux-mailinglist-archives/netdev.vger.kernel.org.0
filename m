Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244EC38F0F6
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 18:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbhEXQHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 12:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236543AbhEXQG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 12:06:59 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0A1C02B303;
        Mon, 24 May 2021 08:37:56 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so11356712pjv.1;
        Mon, 24 May 2021 08:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+nT9isBU54OZ4Gptgzv7nV8Z5fwz1kFz9fkugI6k8C8=;
        b=rJcSDO/TQp0X3rY44BhKdB26FCK5SYPbKfrb4hPVvL2LjrwEkR4O4/7tz1JtAbmXAb
         aS/nDBXFNBxBakwzwTWRsEHXsEnTPV1oQ780sM4dT9fy/fdQXPlOaaP8+uyTlw0Mos0O
         kYZelPUBRYTPQ5qhBcSIVmz65kEX6CgKNBVxMrYkD39gVl7fpd2yLi+vqdLfhWvZ5z60
         ASEOp9v9gk1bKPdYDkHH/Rn6CdzBrzqa+uWtKXCiG8CINnVax4NLsUYWqSUp9xRapSlH
         oswPD/NZnCRcRWXMXymBWpQ0Cw1Dir4YGqJ3BzBAfDUsE7qa/H8wE7p/JwajMcs/XL0z
         +ZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+nT9isBU54OZ4Gptgzv7nV8Z5fwz1kFz9fkugI6k8C8=;
        b=HgLcYawSARkqVBosFOwzl3ALycMvmSZnR9wqoZG1Wed7TFQBMuITVEGdzR/NTrTX4u
         7w4lzKbvw+2FBTj3QDcA+dulvGfVneB/81mwwtgF7c9VgW+Dlnq84nm2WTEp2HavZqjI
         WPnIfGQ/COHRaOAbud+ubxSHtaJvshcP7qnUvBWKvBYXyRUPNWC6HQNfzmaYTyA4aa9/
         uDLX22E3RPakvsOtWlKu49tHW8/KLTD/FJbwGgsqUnxHF/7GlCsQLT8Vu1Pqp34SpqHL
         bxhgnCLO/ZUPm5y9eXU8FQ539PmZ/KSbwMphQ2h9PHYKkVw0Qk+5IYIaI76yDIeI3DVS
         zoqQ==
X-Gm-Message-State: AOAM531azOsc12jiIh4AFZHfM1HdJxtjjMGDPHgtmWt5TX2A6FsnL48w
        pb+f3A9bmKbDN/bC4WTSbZI=
X-Google-Smtp-Source: ABdhPJzVYHLTms7uU0YphKTzlQ50pE8mJsgeDCZfTkHuauFreaJGqzMj1f+zHgcocQa/jtEuT+n55g==
X-Received: by 2002:a17:90a:fa91:: with SMTP id cu17mr25799038pjb.178.1621870675716;
        Mon, 24 May 2021 08:37:55 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u12sm11028188pfh.122.2021.05.24.08.37.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 08:37:55 -0700 (PDT)
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1482eff4-c5f4-66d9-237c-55a096ae2eb4@gmail.com>
Date:   Mon, 24 May 2021 08:37:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524151329.5ummh4dfui6syme3@gilmour>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2021 8:13 AM, Maxime Ripard wrote:
> Hi Florian,
> 
> On Mon, May 24, 2021 at 07:49:25AM -0700, Florian Fainelli wrote:
>> Hi Maxime,
>>
>> On 5/24/2021 6:01 AM, Maxime Ripard wrote:
>>> Hi Doug, Florian,
>>>
>>> I've been running a RaspberryPi4 with a mainline kernel for a while,
>>> booting from NFS. Every once in a while (I'd say ~20-30% of all boots),
>>> I'm getting a kernel panic around the time init is started.
>>>
>>> I was debugging a kernel based on drm-misc-next-2021-05-17 today with
>>> KASAN enabled and got this, which looks related:
>>
>> Is there a known good version that could be used for bisection or you
>> just started to do this test and you have no reference point?
> 
> I've had this issue for over a year and never (I think?) got a good
> version, so while it might be a regression, it's not a recent one.

OK, this helps and does not really help.

> 
>> How stable in terms of clocking is the configuration that you are using?
>> I could try to fire up a similar test on a Pi4 at home, or use one of
>> our 72112 systems which is the closest we have to a Pi4 and see if that
>> happens there as well.
> 
> I'm not really sure about the clocking. Is there any clock you want to
> look at in particular?

ARM, DDR, AXI, anything that could cause some memory corruption to occur
essentially. GENET clocks are fairly fixed, you have a 250MHz clock and
a 125MHz clock feeding the data path.

> 
> My setup is fairly simple: the firmware and kernel are loaded over TFTP
> and the rootfs is mounted over NFS, and the crash always occur around
> init start, so I guess when it actually starts to transmit a decent
> amount of data?

Do you reproduce this problem with KASAN disabled, do you eventually
have a crash pointing back to the same location?

I have a suspicion that this is all Pi4 specific because we regularly
run the GENET driver through various kernel versions (4.9, 5.4 and 5.10
and mainline) and did not run into that.
-- 
Florian
