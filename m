Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A267269881
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 00:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgINWC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 18:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgINWCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 18:02:22 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC0EC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 15:02:21 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id f18so686103pfa.10
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 15:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=PAYihDEegTLxYb6U+lubvd0PhPo75aIgN+aHjsMr0OE=;
        b=VECy3cwLZi/I2qoV1xzzDxYVNtPwIuzYLfL11kAcNnpGnf315yEyjCAyVrGHC/sbQR
         4/2wJLse6cz9uUdO7UuRjns9iL+U9HQAoVXrbFE1nOLoeNPil20ui7AQ3O4uxVJozSk6
         ziTKKoOaiIAXhQhcEiB97eCiE7qIIyihu2ZU8ocdIp4BRNhEdn2QL6q51/gvfPcCaJl1
         1rRTP4UKNtqZa/Gq4naIhhQVYhyE3Nw33spfkf61l4AFACGub/umuyPeg9qamtQ+xnpu
         bPoAA1DzjNSlpPugVMAg9raGd/Qccx/Nrznoj8WR3fq1FgysqVNrwcwuz94uWnnYO8oG
         so0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PAYihDEegTLxYb6U+lubvd0PhPo75aIgN+aHjsMr0OE=;
        b=m33LHH8y4tkq7iRe76j3UQ6sFyXmhRO8j5ZONTlvAAaVrofZMcBFJ/3tXCPEu+yXRU
         UtorpKm8MlFpvJ7IHHsyhFW4EgbUtVy36xcK2l8rL+2mkPXueyny+PKg+wfb2V8jHLBL
         YWb1dWwLF8HFMOA/cKAkQIZLhuGPC39eQGTlMPIUC7B8y5BiC8VthNC3W4mJBXsqxsS4
         d2YuF3CIK5LUDUHObLUdN3nV5X3FELEDP1JecrLdH1vU97GudZh7angccvnHZZOKr+jb
         nv8kTnvLD8P2suabLZkFZaDW3l1axwUatpH5mT+mXsiVQ4RUWXOf2SWBHjc1FTPUc9h2
         rYBg==
X-Gm-Message-State: AOAM530P+fdXkBPIPaxS8bJQtnh7TdqiuKgB2UeOxwGuzmfiDWUHspsn
        GdNNEUMxIE0Yzi4lfLtXi31XcQ==
X-Google-Smtp-Source: ABdhPJzIFCQJzsKCPbO1pareu43FzU43yWuvmjo33TGBtJSch6EGxEH1X9qjiCbfFvnRmlVWktwPmw==
X-Received: by 2002:a62:15c2:0:b029:13f:c196:c219 with SMTP id 185-20020a6215c20000b029013fc196c219mr10245601pfv.12.1600120941267;
        Mon, 14 Sep 2020 15:02:21 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id r123sm11506034pfc.187.2020.09.14.15.02.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 15:02:20 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200908224812.63434-1-snelson@pensando.io>
 <20200908224812.63434-3-snelson@pensando.io>
 <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
 <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
 <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
 <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <99ce6f1f-a8e9-3242-a584-e06756d6c606@pensando.io>
Date:   Mon, 14 Sep 2020 15:02:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/10/20 10:56 AM, Jakub Kicinski wrote:
> On Wed, 9 Sep 2020 18:34:57 -0700 Shannon Nelson wrote:
>> On 9/9/20 12:22 PM, Jakub Kicinski wrote:
>>> On Wed, 9 Sep 2020 10:58:19 -0700 Shannon Nelson wrote:
>>>> I'm suggesting that this implementation using the existing devlink
>>>> logging services should suffice until someone can design, implement, and
>>>> get accepted a different bit of plumbing.  Unfortunately, that's not a
>>>> job that I can get to right now.
>>> This hack is too nasty to be accepted.
>> Your comment earlier was
>>
>>   > I wonder if we can steal a page from systemd's book and display
>>   > "time until timeout", or whatchamacallit, like systemd does when it's
>>   > waiting for processes to quit. All drivers have some timeout set on the
>>   > operation. If users knew the driver sets timeout to n minutes and they
>>   > see the timer ticking up they'd be less likely to think the command has
>>   > hanged..
>>
>> I implemented the loop such that the timeout value was the 100%, and
>> each time through the loop the elapsed time value is sent, so the user
>> gets to see the % value increasing as the wait goes on, in the same way
>> they see the download progress percentage ticking away.
> Right but you said that in most cases the value never goes up to 25min,
> so user will see the value increment from 0 to say 5% very slowly and
> then jump to 100%.
>
>> This is how I approached the stated requirement of user seeing the
>> "timer ticking up", using the existing machinery.  This seems to be
>> how devlink_flash_update_status_notify() is expected to be used, so
>> I'm a little surprised at the critique.
> Sorry, I thought the systemd reference would be clear enough, see the
> screenshot here:
>
> https://images.app.goo.gl/gz1Uwg6mcHEd3D2m7
>
> Systemd prints something link:
>
> bla bla bla (XXs / YYs)
>
> where XX is the timer ticking up, and YY is the timeout value.
>
>>> So to be clear your options are:
>>>    - plumb the single extra netlink parameter through to devlink
>>>    - wait for someone else to do that for you, before you get
>>> firmware flashing accepted upstream.
>>>   
>> Since you seem to have something else in mind, a little more detail
>> would be helpful.
>>
>> We currently see devlink updating a percentage, something like:
>> Downloading:  56%
>> using backspaces to overwrite the value as the updates are published.
>>
>> How do you envision the userland interpretation of the timeout
>> ticking? Do you want to see something like:
>> Installing - timeout seconds:  23
>> as a countdown?
> I was under the impression that the systemd format would be familiar
> to users, hence:
>
> Downloading:  56% (Xm Ys / Zm Vz)
>
> The part in brackets only appearing after a few seconds without a
> notification, otherwise the whole thing would get noisy.
>
>> So, maybe a flag parameter that can tell the UI to use the raw value
>> and not massage it into a percentage?
>>
>> Do you see this new netlink parameter to be a boolean switch between
>> the percentage and raw, or maybe a bitflag parameter that might end
>> up with several bits of context information for userland to interpret?
>>
>> Are you thinking of a new flags parameter in
>> devlink_flash_update_status_notify(), or a new function to service
>> this?
>>
>> If a new parameter to devlink_flash_update_status_notify(), maybe it
>> is time to make a struct for flash update data rather than adding
>> more parameters to the function?
>>
>> Should we add yet another parameter to replace the '%' with some
>> other label, so devlink could print something like
>> Installing - timeout in:  23 secs
>>
>> Or could we use a 0 value for total to signify using a raw value and
>> not need to plumb a new parameter?  Although this might not get along
>> well with older devlink utilities.
> I was thinking of adding an extra timeout parameter to
> devlink_flash_update_status_notify() - timeout length in seconds.
> And an extra netlink attr for that.
>
> We could perhaps make:
>
> static inline void
> devlink_flash_update_status_notify( const char *status_msg,
> 				    unsigned long done, unsigned long total)
> {
> 	struct ..._args = {
> 		.status_msg = status_msg,
> 		.done = done,
> 		.total = total,
> 	}
>
> 	__devlink_flash_update_status_notify(devlink, &.._args);
> }
>
> IOW drop the component parameter from the normal helper, cause almost
> nobody uses that. The add a more full featured __ version, which would
> take the arg struct, the struct would include the timeout value.
>
> If the timeout is lower than 15sec drivers will probably have little
> value in reporting it, so simplified helper should be nice there to save LOC.
>
> The user space can do the counting up trivially using select(),
> or a syscall timeout. The netlink notification would only carry timeout.
> (LMK if this is problematic, I haven't looked at the user space part.)

What if we simplify this idea to adding a timeout variant of the 
devlink_flash_update_begin_notify()?  Perhaps something like
     devlink_flash_update_begin_notify_timeout(struct devlink *devlink, 
unsigned int timeout_seconds)
This can pass up a timeout parameter at the beginning of the flash and 
the userland utility can do what it needs at that point to set up the UI 
display.

I think using a struct internally to devlink.c/h might still have merit, 
but I'm not sure there's a need to mess with the rest of the API just yet.

sln

