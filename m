Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A9B3562C5
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344910AbhDGEz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbhDGEzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 00:55:52 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784EFC06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 21:55:42 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f29so9635607pgm.8
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 21:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/U6PLGStFAplzsLaDEJQ6UzXBLJeG6vo9B5XzZOZEs0=;
        b=ALJt/V6ePPaP0gNho02LEO3G2jw4gYmuxwbLw8OLTiJPAHq8TuNLkcGNWU/65er+h+
         vr/Bh24M85eodVVWiyEjgD3xtUMyQoWHw99AjbsnXM+GxMN6wG+SvtXHa68Uh5VGKxGz
         DsGcbpEMX25XMe9mIHK0jWyrK3QcK85JpbwRM3H3vVJXChh4/sgBebpwzuM2rW/v9/jG
         wzpg6rmgZV8pjur4EqJT06psMQWYRnkfMT9RjivnAhoyHz0jNDA7pcT7IXrXFS+Cx+qc
         fFhgZPbpV19PSGkff15iQCQHZFAbkHiYakZeO1nHGO2qFDREYX+kSZ/iJOUrQMRsIakz
         u0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/U6PLGStFAplzsLaDEJQ6UzXBLJeG6vo9B5XzZOZEs0=;
        b=FMQD/fcH4vnCus9/Cqh2DDVUnZiIOEPipCeDLbHIBcnqKdsEur7j9ToYgY/OTAiRjx
         3o8hEEGHEwd8KxkWkLrMwPaiGCiny2aA2KsJy50jn0PAKEe5NnAMYQPwjZiMcCK1LxON
         yLBWS1CCOGBQWUUgHxAAcSpnn2ArWYenpLp/R78xuTMfe5W1GRhxyJxG4BkmbRqOgnsW
         Xe4iWPPwnLNWwbV2efE7sDIpW1ZTUIKrejvho3VWy3ayvRWSC3dcV7kgl7vAYpdlLugP
         bs0blZmrIZ7JUh53D5GlkbgryfyJ+rZ8qGCrsWbo9n0FeK3afV6n8ggx83PxvcLBjwzm
         FnxQ==
X-Gm-Message-State: AOAM532hADVdjKlJx5kVaUMNGiWNgAmK+qdLZGLlNvBKlH2c18STlckk
        qHVvDtM1ta/RmRUOK0vg3cLEdQ==
X-Google-Smtp-Source: ABdhPJxyQhSSzKhZJcUXt1QHXJvRMhpJbrqFocTvvPfBn6Ezi5Va2bbJYjOmi4tFng07SVioFZUCQw==
X-Received: by 2002:a62:187:0:b029:241:fc67:d41f with SMTP id 129-20020a6201870000b0290241fc67d41fmr1166405pfb.55.1617771341961;
        Tue, 06 Apr 2021 21:55:41 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id m9sm19934189pgt.65.2021.04.06.21.55.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 21:55:41 -0700 (PDT)
Subject: Re: [PATCH net-next 05/12] ionic: add hw timestamp support files
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-6-snelson@pensando.io>
 <20210404230526.GB24720@hoboy.vegasvil.org>
 <9b5d20f4-df9f-e9e1-bc6d-d5531b87e8c4@pensando.io>
 <20210405181719.GA29333@hoboy.vegasvil.org>
 <ac71c8ad-e947-9b16-978f-c320c709615e@pensando.io>
 <20210407002734.GA30525@hoboy.vegasvil.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <fc385b43-06e4-d235-210a-337a846868bb@pensando.io>
Date:   Tue, 6 Apr 2021 21:55:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407002734.GA30525@hoboy.vegasvil.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/21 5:27 PM, Richard Cochran wrote:
> On Tue, Apr 06, 2021 at 04:18:00PM -0700, Shannon Nelson wrote:
>> On 4/5/21 11:17 AM, Richard Cochran wrote:
>>> On Mon, Apr 05, 2021 at 09:16:39AM -0700, Shannon Nelson wrote:
>>>> On 4/4/21 4:05 PM, Richard Cochran wrote:
>>>>> This check is unneeded, because the ioctl layer never passes NULL here.
>>>> Yes, the ioctl layer never calls this with NULL, but we call it from within
>>>> the driver when we spin operations back up after a FW reset.
>>> So why not avoid the special case and pass a proper request?
>> We do this because our firmware reset path is a special case that we have to
>> handle, and we do so by replaying the previous configuration request.
>> Passing the NULL request gives the code the ability to watch for this case
>> while keeping the special case handling simple: the code that drives the
>> replay logic doesn't need to know the hwstamp details, it just needs to
>> signal the replay and let the hwstamp code keep track of its own data and
>> request history.
>>
>> I can update the comment to make that replay case more obvious.
> No, please, I am asking you to provide a hwtstamp_config from your
> driver.  What is so hard about that?
>

What I think you are asking is that we not extend the current assumption 
that *ifr will always be a useful pointer, a perfectly reasonable 
request.  Our ioctl() handler follows this as expected. It is our 
internal usage that might look like an extension.

We'd like to keep the replay related code and data to a minimum, and 
this current implementation is a simple way to do so, keeping the state 
and config info within the ptp side.

I suppose one alternative is that we pull the copy_from_user() bits into 
ionic_ioctl() and hand a hwtstamp_config struct pointer to 
ionic_lif_hwstamp_set().  In our reset case we can either hand a NULL 
pointer to ionic_lif_hwstamp_set() or add a reset parameter to the call 
where ionic_lif_hwstamp_set() simply won't inspect the hwtstamp_config 
pointer.

Another alternative would be to split the top layer of 
ionic_lif_hwstamp_set() into two different functions, one called by the 
ioctl handler with an *ifr, the other called by the fw reset logic 
without an *ifr, that both call into the remaining with a 
hwtstamp_config pointer.  This seems somewhat similar to the ixgbe approach.

Either way, in the end it seems like extra code to get to the same result.

sln

