Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8268C269AED
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgIOBO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgIOBOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 21:14:25 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED166C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 18:14:24 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s65so1116523pgb.0
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 18:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=0f+4Q4owrjhEBqJ5PTJehYQ9NJ8Be/gO1XpCdYvxr8I=;
        b=sSBHgOaPcBRZKK08WZU3wB1tiTPLgMjbcCxdFd9OqRj5jYw6LVVmy8Fzc8zVIHvxli
         MOn2fzsYDnGlZ6kbbf2VMzxZ+TS0HI4oAquIpvGg4L2gA3rGzOgmCdwlkTJ2+Gln0V3B
         vu6LVvWuem3KAPNkxW9g4PCTHGqbrBllzdJniTQJahkuVY+67PxqxGkjMEvjwDGKLj3t
         sVWl4HoxyajTpbrdSHK74iJuVAFQTe+JjnTJgP6omOIgUchUzOhEAE2AXD2c+SzhqP2U
         v/xN3lMH0x1ivOi5Z+u5XZTfVlQ2V0mjwooNlkNdNMgdaHcM6wDgA4/9jsoDrHOA03be
         2Wbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=0f+4Q4owrjhEBqJ5PTJehYQ9NJ8Be/gO1XpCdYvxr8I=;
        b=eKGKEer0xKqrgFvCTDctOXVz1cu/lWeOsWFkpCe6zNy4EgVqhf9WEINv1FxQlok2r+
         uM6pQ18YeLbHhDpaCHTHL43E7uxqOeJt9MnnkibVXQ2c/kFplfvC962txAB3ObZ9ikCe
         KDlY0xvpYjv2VayPGX5NTPIrN6+OX6QmTgVcua4SiUw60uDwgHr3zsjvPOfDtrpe1Yz6
         pfjksDUE0AlfAkNy+OlTFGuH/NIXcp2i2PRNVEEgwPfxp1U24UyGTjPJvHKPkHBcVHJD
         UW0zyJ7Bc/vDxabysUiGBZnJsmaRxmpSVGLKMcd/mo5Pqdcl+3sqfkr7F5Xaob3WI+AR
         jROA==
X-Gm-Message-State: AOAM531qp815EOe9JiSzcS5o80SDshpHt321j2bXbFk8Fk/StoeieCOg
        82iPIZqHq9XbnzeovIh+pcYEGA==
X-Google-Smtp-Source: ABdhPJwl9JyFuRJ1N6ETEWIKcdDRmsUUKGvz1VIEJwbrPMwxIT1vtH0DUdS9+r+NcxPScM8i/k5IwQ==
X-Received: by 2002:a62:1a95:0:b029:13c:1611:6539 with SMTP id a143-20020a621a950000b029013c16116539mr15010251pfa.11.1600132464344;
        Mon, 14 Sep 2020 18:14:24 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id r16sm9475pfc.217.2020.09.14.18.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 18:14:23 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20200908224812.63434-1-snelson@pensando.io>
 <20200908224812.63434-3-snelson@pensando.io>
 <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
 <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
 <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
 <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a04313f7-649e-a928-767c-b9d27f3a0c7c@intel.com>
 <20200914163605.750b0f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3b18d92f-3a0a-c0b0-1b46-ecfd4408038c@pensando.io>
 <7e44037cedb946d4a72055dd0898ab1d@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <f4e4e9c3-b293-cef1-bb84-db7fe691882a@pensando.io>
Date:   Mon, 14 Sep 2020 18:14:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <7e44037cedb946d4a72055dd0898ab1d@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/20 5:53 PM, Keller, Jacob E wrote:
>
>> -----Original Message-----
>> From: Shannon Nelson <snelson@pensando.io>
>> Sent: Monday, September 14, 2020 4:47 PM
>> To: Jakub Kicinski <kuba@kernel.org>; Keller, Jacob E <jacob.e.keller@intel.com>
>> Cc: netdev@vger.kernel.org; davem@davemloft.net
>> Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
>>
>> On 9/14/20 4:36 PM, Jakub Kicinski wrote:
>>> On Mon, 14 Sep 2020 16:15:28 -0700 Jacob Keller wrote:
>>>> On 9/10/2020 10:56 AM, Jakub Kicinski wrote:
>>>>> IOW drop the component parameter from the normal helper, cause almost
>>>>> nobody uses that. The add a more full featured __ version, which would
>>>>> take the arg struct, the struct would include the timeout value.
>>>>>
>>>> I would point out that the ice driver does use it to help indicate which
>>>> section of the flash is currently being updated.
>>>>
>>>> i.e.
>>>>
>>>> $ devlink dev flash pci/0000:af:00.0 file firmware.bin
>>>> Preparing to flash
>>>> [fw.mgmt] Erasing
>>>> [fw.mgmt] Erasing done
>>>> [fw.mgmt] Flashing 100%
>>>> [fw.mgmt] Flashing done 100%
>>>> [fw.undi] Erasing
>>>> [fw.undi] Erasing done
>>>> [fw.undi] Flashing 100%
>>>> [fw.undi] Flashing done 100%
>>>> [fw.netlist] Erasing
>>>> [fw.netlist] Erasing done
>>>> [fw.netlist] Flashing 100%
>>>> [fw.netlist] Flashing done 100%
>>>>
>>>> I'd like to keep that, as it helps tell which component is currently
>>>> being updated. If we drop this, then either I have to manually build
>>>> strings which include the component name, or we lose this information on
>>>> display.
>>> Thanks for pointing that out. My recollection was that ice and netdevsim
>>> were the only two users, so I thought those could use the full __*
>>> helper and pass an arg struct. But no strong feelings.
>> Thanks, both.
>>
>> I'd been going back and forth all morning about whether a simple single
>> timeout or a timeout for each "chunk" would be appropriate. I'll try to
>> be back in another day or three with an RFC.
>>
>> sln
> For ice, a timeout for each message/chunk makes the most sense, but I could see  a different reasoning when you have multiple steps all bounded by the same timeout
>
> Thanks,
> Jake
>

So now we're beginning to dance around timeout boundaries - how can we 
define the beginning and end of a timeout boundary, and how do they 
relate to the component and label?  Currently, if either the component 
or status_msg changes, the devlink user program does a newline to start 
a new status line.  The done and total values are used from each notify 
message to create a % value displayed, but are not dependent on any 
previous done or total values, so the total doesn't need to be the same 
value from status message to status message, even if the component and 
label remain the same, devlink will just print whatever % gets 
calculated that time.

I'm thinking that the behavior of the timeout value should remain 
separate from the component and status_msg values, such that once given, 
then the userland countdown continues on that timeout.  Each subsequent 
notify, regardless of component or label changes, should continue 
reporting that same timeout value for as long as it applies to the 
action.  If a new timeout value is reported, the countdown starts over.  
This continues until either the countdown finishes or the driver reports 
the flash as completed.  I think this allows is the flexibility for 
multiple steps that Jake alludes to above.  Does this make sense?

What should the userland program do when the timeout expires?  Start 
counting backwards?  Stop waiting?  Do we care to define this at the moment?

sln

