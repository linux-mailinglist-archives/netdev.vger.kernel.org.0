Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448231C48BF
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 23:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgEDVDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 17:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgEDVDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 17:03:18 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B51C061A0E;
        Mon,  4 May 2020 14:03:17 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g13so152330wrb.8;
        Mon, 04 May 2020 14:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n0gWd/LKEKfbFqunt27R8+2BYVGb8cKLklv+je6aFbk=;
        b=LmR4y6bUzadG9TaDR2YViM86obTCNs5PL7ve0409Y2bFpIIpoy0SpP8Xbi84p1Hahm
         yPK/AA/H9XMFLgd/6lIpf0fCyuY6+bnvRIF0IR9keaEbYibbhINA226PjfFTCWtXQ+ss
         TiB0XRBVM/xs2Ifs+8TqYcqI+vVjpBkpTpngfbg+CkJTpNjtYDf+SxhXzVOHcqIllh4g
         oGZqUG247TO6j4PFV5OMt4imAoXNhzs7oaCdk2qA7Jn6h/OJkiqvyc74NdtJGs9Dtjc4
         UlIkbPvknNXGwXTruZvhbqphUFfxL0Cs2hxF4kq/OuWqdjWB3zeY+QDQi+sXNsQeDEBX
         XWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n0gWd/LKEKfbFqunt27R8+2BYVGb8cKLklv+je6aFbk=;
        b=kRqUDrOIwC+fImVC4u/bsSBY/AyRETk+z1jxi6zoWdWZ0aFd25VsSYQdAJqBW3v8Jw
         /GaTaCzHtUHW+CGEI+4prkFzV1PMdwmqosEcPQU0rT0GOfkHk+LizjIVJUwsnYCAm3Q5
         EAIf4cmy6Xl+cWyYOxk1civ+zCp3wvyHz81CjnriEEMsxXLkS7413wEMfmzbKexo8wNz
         opsV++m1Cmi9spTGgCCeU8yVpxI4dLA10h4MhinFCFseXkxHvxt3pvOJwG4HIxEWMErK
         FMKwMKZMa07/maRyiUBJPxRtZx04aM+T41Gm/2gfYczUFAAWCoALAP6lAbg9/d9jojFT
         UJ8w==
X-Gm-Message-State: AGi0PuaTa5PoLejnohZBcoaxPGzp1eRbf1+CsrU6eBy8UjBtd8xKrFso
        RcMjukeDici7gfoyAEITzafwlbHo
X-Google-Smtp-Source: APiQypJzkKLT2kMEemfvan89ukp/i0ZeR5T1FDjZwlEnyqDg6E3kHj4mcha3VCheoZAMEd3nYVmSQg==
X-Received: by 2002:a5d:650b:: with SMTP id x11mr982279wru.405.1588626196291;
        Mon, 04 May 2020 14:03:16 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y63sm259719wmg.21.2020.05.04.14.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 14:03:15 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: Do not leave DSA master with NULL
 netdev_ops
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, allen.pais@oracle.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200504201806.27192-1-f.fainelli@gmail.com>
 <CA+h21ho50twA=D=kZYxVuE=C6gf=8JeXmTEHhV30p_30oQZjjA@mail.gmail.com>
 <b32f205a-6ff3-e1db-33d1-6518091f90b4@gmail.com>
 <CA+h21hpObEHt04igBBbX40niuqON=41=f35zTgYNOTZZscbivQ@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9ed48660-8b43-6661-1794-aa6eedbed3cc@gmail.com>
Date:   Mon, 4 May 2020 14:03:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hpObEHt04igBBbX40niuqON=41=f35zTgYNOTZZscbivQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 1:49 PM, Vladimir Oltean wrote:
> On Mon, 4 May 2020 at 23:40, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 5/4/2020 1:34 PM, Vladimir Oltean wrote:
>>> Hi Florian,
>>>
>>> On Mon, 4 May 2020 at 23:19, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>>>
>>>> When ndo_get_phys_port_name() for the CPU port was added we introduced
>>>> an early check for when the DSA master network device in
>>>> dsa_master_ndo_setup() already implements ndo_get_phys_port_name(). When
>>>> we perform the teardown operation in dsa_master_ndo_teardown() we would
>>>> not be checking that cpu_dp->orig_ndo_ops was successfully allocated and
>>>> non-NULL initialized.
>>>>
>>>> With network device drivers such as virtio_net, this leads to a NPD as
>>>> soon as the DSA switch hanging off of it gets torn down because we are
>>>> now assigning the virtio_net device's netdev_ops a NULL pointer.
>>>>
>>>> Fixes: da7b9e9b00d4 ("net: dsa: Add ndo_get_phys_port_name() for CPU port")
>>>> Reported-by: Allen Pais <allen.pais@oracle.com>
>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>> ---
>>>
>>> The fix makes complete sense.
>>> But on another note, if we don't overlay an ndo_get_phys_port_name if
>>> the master already has one, doesn't that render the entire mechanism
>>> of having a reliable way for user space to determine the CPU port
>>> number pointless?
>>
>> For the CPU port I would consider ndo_get_phys_port_name() to be more
>> best effort than an absolute need unlike the user facing ports, where
>> this is necessary for a variety of actions (e.g.: determining
>> queues/port numbers etc.) which is why there was no overlay being done
>> in that case. There is not a good way to cascade the information other
>> than do something like pX.Y and defining what the X and Y are, what do
>> you think?
>> --
>> Florian
> 
> For the CPU/master port I am not actually sure who is the final
> consumer of the ndo_get_phys_port_name, I thought it is simply
> informational, with the observation that it may be unreliable in
> transmitting that information over.
> Speaking of which, if "informational" is the only purpose, could this
> not be used?

Yes, I had not considered devlink would expose that information,
ndo_phys_port_name() is there now though and since it is exposed through
sysfs so reverting would be an ABI breakage.

> 
> devlink port | grep "flavour cpu"
> pci/0000:00:00.5/4: type notset flavour cpu port 4
> spi/spi2.0/4: type notset flavour cpu port 4
> spi/spi2.1/4: type notset flavour cpu port 4
> 
> Thanks,
> -Vladimir
> 

-- 
Florian
