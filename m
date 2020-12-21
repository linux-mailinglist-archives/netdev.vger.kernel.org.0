Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565DE2E0231
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 22:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgLUVts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 16:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgLUVtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 16:49:47 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE15C0613D3;
        Mon, 21 Dec 2020 13:49:07 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b5so193067pjl.0;
        Mon, 21 Dec 2020 13:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+FYR4QlIrV7Uo+1R8C6OqoNhPOdSs1swgFiPbk9OqFk=;
        b=tYXHnBSiD10qBUjqnTt6Hwb01VTwo9uBj+wAqoM8ruWPtsYhqGhqBP84jV+vtfb+wi
         WfGrUXalRrlmEZxBt4jR6a4I070pMRTgs5/jVGUVo9W+W9GsP0n+k0N3RivbX4opF9K2
         1fxkduQ9wnUlCPZ1WHs2LlVS1ggG5U1noWq5bBm1QrEmbyKdgUyPFn0C3GWya76hPURA
         cKBvHzSZGqp3MQ8OTFjcQa74sHVI75d2N/z3dURRhT1ELsZ/+Jb/jzdvXlKKsOsRMLP5
         Uc/ZAbXZ8hoLJ0fXeaxeBN+qRFA74FhewzYf6CZYKyyyV+OtGA/EZumyfm3HjVmM3ZKF
         oiuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+FYR4QlIrV7Uo+1R8C6OqoNhPOdSs1swgFiPbk9OqFk=;
        b=XZ0T57HWmNtf/1a9PINvv5LaTSAKZVrMmp/vNelnfs6mxyynv8GN16vQPN0jBcNo2o
         uGDZ5RhLz3HigRjISGLfc1/j+mLcwHFtiXXfUb4Ca7jmXHp3Z4NbJDznAoME/iL3cazJ
         rvgTbz/j44zKYktS6DqbdB5zd3lZilnwbIMPGzREUMZbR2bgtOrm9191f69vTpzRZr7p
         etgqcQuqyZh2Cl+icQlattOlCXjXGA3smALLeoEHVk6yqUdLJs1SyBpvdh1hTpPZcMY0
         RITPh3Rv+i3usA5USnNo+D7fjbOaeT3REQHHDC9joB2tbLRzjJJAq6f33UKyg89G/U+E
         3nUQ==
X-Gm-Message-State: AOAM531WGCTLZZxZOH27DjVGhE6Kezfd9cGuevx0L10gzT/NzjIdexSw
        sYYxTi6YO9u0WrB402SuN/mV2iE1w4c=
X-Google-Smtp-Source: ABdhPJz/KODIFXC6Z3Os4C+wDb7uNyoGDKjqgDhX7r7ij6eBChGBleQaDVvEz3FB+7KXiPmlBS3/Cg==
X-Received: by 2002:a17:902:59dd:b029:db:cda3:39c0 with SMTP id d29-20020a17090259ddb02900dbcda339c0mr18037417plj.81.1608587346341;
        Mon, 21 Dec 2020 13:49:06 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p9sm17989574pfq.109.2020.12.21.13.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 13:49:05 -0800 (PST)
Subject: Re: [PATCH net] net: systemport: set dev->max_mtu to
 UMAC_MAX_MTU_SIZE
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "open list:BROADCOM SYSTEMPORT ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20201218173843.141046-1-f.fainelli@gmail.com>
 <20201218202441.ppcxswvlix3xszsn@skbuf>
 <c178b5db-3de4-5f02-eee3-c9e69393174a@gmail.com>
 <20201218205220.jb3kh7v23gtpymmx@skbuf>
 <b8e61c3f-179f-7d8f-782a-86a8c69c5a75@gmail.com>
 <20201218210250.owahylqnagtssbsw@skbuf>
 <cf2daa3c-8f64-0f58-5a42-2182cec5ba4a@gmail.com>
 <20201218211435.mjdknhltolu4gvqr@skbuf>
 <f558368a-ec7f-c604-9be5-bd5b810b5bfa@gmail.com>
Message-ID: <6d54c372-86bc-b28f-00b0-c22e46215116@gmail.com>
Date:   Mon, 21 Dec 2020 13:49:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <f558368a-ec7f-c604-9be5-bd5b810b5bfa@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/18/2020 1:17 PM, Florian Fainelli wrote:
>>>>>>> SYSTEMPORT Lite does not actually validate the frame length, so setting
>>>>>>> a maximum number to the buffer size we allocate could work, but I don't
>>>>>>> see a reason to differentiate the two types of MACs here.
>>>>>>
>>>>>> And if the Lite doesn't validate the frame length, then shouldn't it
>>>>>> report a max_mtu equal to the max_mtu of the attached DSA switch, plus
>>>>>> the Broadcom tag length? Doesn't the b53 driver support jumbo frames?
>>>>>
>>>>> And how would I do that without create a horrible layering violation in
>>>>> either the systemport driver or DSA? Yes the b53 driver supports jumbo
>>>>> frames.
>>>>
>>>> Sorry, I don't understand where is the layering violation (maybe it doesn't
>>>> help me either that I'm not familiar with Broadcom architectures).
>>>>
>>>> Is the SYSTEMPORT Lite always used as a DSA master, or could it also be
>>>> used standalone? What would be the issue with hardcoding a max_mtu value
>>>> which is large enough for b53 to use jumbo frames?
>>>
>>> SYSTEMPORT Lite is always used as a DSA master AFAICT given its GMII
>>> Integration Block (GIB) was specifically designed with another MAC and
>>> particularly that of a switch on the other side.
>>>
>>> The layering violation I am concerned with is that we do not know ahead
>>> of time which b53 switch we are going to be interfaced with, and they
>>> have various limitations on the sizes they support. Right now b53 only
>>> concerns itself with returning JMS_MAX_SIZE, but I am fairly positive
>>> this needs fixing given the existing switches supported by the driver.
>>
>> Maybe we don't need to over-engineer this. As long as you report a large
>> enough max_mtu in the SYSTEMPORT Lite driver to accomodate for all
>> possible revisions of embedded switches, and the max_mtu of the switch
>> itself is still accurate and representative of the switch revision limits,
>> I think that's good enough.
> 
> I suppose that is fair, v2 coming, thanks!

I was going to issue a v2 for this patch, but given that we don't
allocate buffers larger than 2KiB and there is really no need to
implement ndo_change_mtu(), is there really a point not to use
UMAC_MAX_MTU_SIZE for both variants of the SYSTEMPORT MAC?
-- 
Florian
