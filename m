Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA66263AFA
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbgIJB6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 21:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgIJBfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 21:35:21 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E127C061375
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 18:35:01 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z19so3678939pfn.8
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 18:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=R53gMV+cYjn8Rf4Tc8K6SSXb22jjr34qngd8UPUtaIg=;
        b=z9FOZMLCq+CQ25npC8ZZ3lUpDUVGVr0uRs2KEsmyph8+D24HYOqm+3IWl+nwZSGqex
         ETkoM3n2TjFaNu1xvbaRjhmIkgFg6wAux2Ixn8QRT4b/d4QQdIVW4gfdDM01q1Kwx4+5
         tk5gRwkuUYXnFFWrOOh9bO0NjzaMTZoTfNYpbFDisMgGg0drNTIuVUiDGfGkrSZJa0kE
         kUTsXVHCLnhFtp0f7He/IKdUkZybSh2ziH0uh2KE09Burj5tkS9ygGJsCld/mzZIKjgl
         AlxOlXD9AJY583ldgaFk7Wqw9xNmOyKMpMMkb6tpqwrY97bDZjgzMSF8U6iDf4JWF6JW
         D1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=R53gMV+cYjn8Rf4Tc8K6SSXb22jjr34qngd8UPUtaIg=;
        b=pQEaVpyHAi1kGfac9BbXv1wqGiP8FdVTTSVLw+4MYIzUvnyjCTtugLTBiZlsjl6UVu
         6k9PJVUhkDRABXYsFQTYiRwYFslABXIxm2czy+iDec9B/KeGxzdWsWx3qMWkR+zSQuJc
         HbYhtBqgTFB4Fe7Z3zhr9apGEMUXhonlErdHTFeTQyHv+Dj4YOEzwYe54fdHoIixfY2b
         9KrIgf9v0BO4bEuUAnEe5QkohewT4ond8Q+d/HewEDb+BdtoIspnFPHnKT/AEq7yrTPe
         ocy7/3xztaIW0M29nSMbm+Bj+w0VXLptiTppX7IY9io7RnkXrq+tICh7YJlwEVzLW8Ir
         rD5g==
X-Gm-Message-State: AOAM5338H/T55EDgJ0XQVr7i1qU64u973oDxamjZydWl9Kl/zWgJGb2G
        pbk67MVmutdkljcg7/gVhjio1w==
X-Google-Smtp-Source: ABdhPJzKVDHpe3SS2Ekp9xGD+bEgy7Bs7a/z8bKHkftZSr9nZ399hNMe+coUyBTduLj5gSY63JTIQg==
X-Received: by 2002:aa7:9ac9:0:b029:13e:d13d:a133 with SMTP id x9-20020aa79ac90000b029013ed13da133mr3181995pfp.27.1599701700701;
        Wed, 09 Sep 2020 18:35:00 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id q65sm3264864pga.88.2020.09.09.18.34.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 18:35:00 -0700 (PDT)
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
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
Date:   Wed, 9 Sep 2020 18:34:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/20 12:22 PM, Jakub Kicinski wrote:
> On Wed, 9 Sep 2020 10:58:19 -0700 Shannon Nelson wrote:
>>
>> I'm suggesting that this implementation using the existing devlink
>> logging services should suffice until someone can design, implement, and
>> get accepted a different bit of plumbing.  Unfortunately, that's not a
>> job that I can get to right now.
> This hack is too nasty to be accepted.

Your comment earlier was

 > I wonder if we can steal a page from systemd's book and display
 > "time until timeout", or whatchamacallit, like systemd does when it's
 > waiting for processes to quit. All drivers have some timeout set on the
 > operation. If users knew the driver sets timeout to n minutes and they
 > see the timer ticking up they'd be less likely to think the command has
 > hanged..

I implemented the loop such that the timeout value was the 100%, and 
each time through the loop the elapsed time value is sent, so the user 
gets to see the % value increasing as the wait goes on, in the same way 
they see the download progress percentage ticking away. This is how I 
approached the stated requirement of user seeing the "timer ticking up", 
using the existing machinery.  This seems to be how 
devlink_flash_update_status_notify() is expected to be used, so I'm a 
little surprised at the critique.

> So to be clear your options are:
>   - plumb the single extra netlink parameter through to devlink
>   - wait for someone else to do that for you, before you get firmware
>     flashing accepted upstream.
>

Since you seem to have something else in mind, a little more detail 
would be helpful.

We currently see devlink updating a percentage, something like:
Downloading:  56%
using backspaces to overwrite the value as the updates are published.

How do you envision the userland interpretation of the timeout ticking?  
Do you want to see something like:
Installing - timeout seconds:  23
as a countdown?

So, maybe a flag parameter that can tell the UI to use the raw value and 
not massage it into a percentage?

Do you see this new netlink parameter to be a boolean switch between the 
percentage and raw, or maybe a bitflag parameter that might end up with 
several bits of context information for userland to interpret?

Are you thinking of a new flags parameter in 
devlink_flash_update_status_notify(), or a new function to service this?

If a new parameter to devlink_flash_update_status_notify(), maybe it is 
time to make a struct for flash update data rather than adding more 
parameters to the function?

Should we add yet another parameter to replace the '%' with some other 
label, so devlink could print something like
Installing - timeout in:  23 secs

Or could we use a 0 value for total to signify using a raw value and not 
need to plumb a new parameter?  Although this might not get along well 
with older devlink utilities.

Thoughts?

sln

