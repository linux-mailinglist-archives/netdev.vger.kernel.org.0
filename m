Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663E3402D2B
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 18:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345111AbhIGQvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 12:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbhIGQvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 12:51:01 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ED2C061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 09:49:55 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g14so8630977pfm.1
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 09:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9N+ExPhRykdM3TRRPPk3ngd52DAcoq+9fBmp6ScGg2g=;
        b=ZCP4tXgfDSRtisGjvD6VANUn3efEr3CTdMpg4cWf7bINv+dU9zQdyLepHsARilSM/c
         JCgG7UgpFtqNapt4ysAfxBKSn4/rFAd1V6PgW1Bg+ipqpRuy4jGtj1AzW6Nq6O9BZq0W
         XVt724O70+2ZsMqjKq3xB1L/Is4Vz64i5lEy5rsGM/AEcGCKQCvr+RCkSUyrX0G3LRSj
         kYB3XFmkbVy9klBaKTAhrnmBLSvBaYvJrSg1HZXrsVFhIiDDL9Xv4WtOMbijKss/eq4/
         WxBy+aawfkoKCmVahhX1PS6BOK80X5y8l5VAU5C4o0AWfL6tdMRQMlHCh3crOzHathRm
         NDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9N+ExPhRykdM3TRRPPk3ngd52DAcoq+9fBmp6ScGg2g=;
        b=S+nQOxRILwkAwikl5a1N3xEvv8hRF2/5Q+eeod2IBQwRSg/LvikYm2jxHZxdjes8dT
         kZfr3pbcX+h/Lsjee0Pj9m1nbeP+kqAPncVBodzEEWncHfsSHRNqXF28koIioTDIYcre
         nrVk2pG20lrM+dyEbU4sRJPItdfSUj57aEDvK2NUcoQXIKEMJsEWqaqyGjkAdZW1m8d6
         L7A/UvW7CxLX2FHwx0Wo5HaaXyyuDt6ZQSocdZWnvKYppeu8AxA+9SFSCgo0VfRHVDxq
         TSupwbzKe6+UJ2VCdlyF24HeQDVV2uHsKbZ6ALzTop/Og9u1PFVujKCCD3lMNa9+iwFE
         w/kg==
X-Gm-Message-State: AOAM530bfVczOauI3COerFNQd03OgGBMVOpx+Vg8VZ2gV5sOsH+MpIJd
        hSI/mYIY6pxrTbTZ8rCao4o=
X-Google-Smtp-Source: ABdhPJykrE8rleoe2kEhNrQm1QoR0Nh7RuWtpwbQ/G8UWxWZwyZybv5G7/ZmvCEcM91q0geHY1P2cQ==
X-Received: by 2002:a05:6a00:7ca:b0:3f5:1a6d:bcf8 with SMTP id n10-20020a056a0007ca00b003f51a6dbcf8mr17047076pfu.55.1631033394847;
        Tue, 07 Sep 2021 09:49:54 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d5sm11701113pfd.142.2021.09.07.09.49.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 09:49:54 -0700 (PDT)
Message-ID: <a71d0e0c-159e-e82e-36f2-bf3434445343@gmail.com>
Date:   Tue, 7 Sep 2021 09:49:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>
References: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
 <YTRswWukNB0zDRIc@unreal> <20210905084518.emlagw76qmo44rpw@skbuf>
 <YTSa/3XHe9qVz9t7@unreal> <20210905103125.2ulxt2l65frw7bwu@skbuf>
 <YTSgVw7BNK1e4YWY@unreal> <20210905110735.asgsyjygsrxti6jk@skbuf>
 <20210907084431.563ee411@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ac8e1c9e-5df2-0af7-2ab4-26f78d5839e3@gmail.com> <YTeWmq0sfYJyab6d@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YTeWmq0sfYJyab6d@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2021 9:43 AM, Andrew Lunn wrote:
> On Tue, Sep 07, 2021 at 08:47:35AM -0700, Florian Fainelli wrote:
>>
>>
>> On 9/7/2021 8:44 AM, Jakub Kicinski wrote:
>>> On Sun, 5 Sep 2021 14:07:35 +0300 Vladimir Oltean wrote:
>>>> Again, fallback but not during devlink port register. The devlink port
>>>> was registered just fine, but our plans changed midway. If you want to
>>>> create a net device with an associated devlink port, first you need to
>>>> create the devlink port and then the net device, then you need to link
>>>> the two using devlink_port_type_eth_set, at least according to my
>>>> understanding.
>>>>
>>>> So the failure is during the creation of the **net device**, we now have a
>>>> devlink port which was originally intended to be of the Ethernet type
>>>> and have a physical flavour, but it will not be backed by any net device,
>>>> because the creation of that just failed. So the question is simply what
>>>> to do with that devlink port.
>>>
>>> Is the failure you're referring to discovered inside the
>>> register_netdevice() call?
>>
>> It is before, at the time we attempt to connect to the PHY device, prior to
>> registering the netdev, we may fail that PHY connection, tearing down the
>> entire switch because of that is highly undesirable.
>>
>> Maybe we should re-order things a little bit and try to register devlink
>> ports only after we successfully registered with the PHY/SFP and prior to
>> registering the netdev?
> 
> Maybe, but it should not really matter. EPROBE_DEFER exists, and can
> happen. The probe can fail for other reasons. All core code should be
> cleanly undoable. Maybe we are pushing it a little by only wanting to
> undo a single port, rather than the whole switch, but still, i would
> make the core handle this, not rearrange the driver. It is not robust
> otherwise.

Well yes, in case my comment was not clear, I was referring to the way 
that DSA register devlink ports, not how the mv88e6xxx driver does it. 
That is assuming that it is possible and there was not a reason for 
configuring the devlink ports ahead of the switch driver coming up.
-- 
Florian
