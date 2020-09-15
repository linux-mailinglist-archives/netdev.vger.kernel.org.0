Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC4526AA63
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 19:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgIORUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 13:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbgIORUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 13:20:15 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C43C061788
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 10:20:14 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id z17so2342958pgc.4
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 10:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=I+iVT8KgXs3nBI84O7gr7eRuC956h54v3IdKtll29gg=;
        b=Zr+5RRwHltHEtxKPNEP81CgrKO1J/t8w8iFuiaD/sxoJsmxbFdMRF1GD5gjVcpLmRi
         LawPnRIYVrNTtX0Q5wVGHvRdstDC+oaCaQfYbSdbEkJcs2H4Z6Zakv7CL+5vMo5PPIou
         mEj1px3AkJMWtVjWdBtoJP2EXaR+JlDuFxX3UsO2dihXXWPoem2mc7TZfR3hmNv7MIv6
         6zs4DpNVCV0dQOBb/lb5sA2KoAlal4G1+axOJYWjrDIvgeaGYmXknv37CFYQX++283U4
         QueeOmLm41msYNQel7q7n3U9h9MiAS/rQ/KixTokU7ujMbt+wHCACpALPoQhlhANbKj5
         A9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=I+iVT8KgXs3nBI84O7gr7eRuC956h54v3IdKtll29gg=;
        b=m0YsqDylI/FhU3kMmS9Fwe2hzKd7iurc0roKvyA2APbom7ffKKz32kgGirbg2MLaTt
         TmRsxxM8cL/tvkKArAUp52U9cBEfF88FKSRy+eM3mPgaI/3+2hFiF+VQyeV89LdKAy20
         GcruY/x4Q9xJR612pDkhoTAvaqSe1eqoGvxFAknepFVdohpDaGTuRFLRhllfOtyx3LkX
         m+H1V6qL9UOb6owb2qTBaBhwNsqjnxwYNcB5FmZu92lyL2XwkBe6uwNMR5zuh1y4IgUB
         6TXBkyMnzTGU5TfHxMW0ahN52qf1uWBLNea15jyKCOOxJeTVMxPomz6mCkPfjo2E26Xm
         i2kg==
X-Gm-Message-State: AOAM532/9YwZJXI+elulomvvTleJBPAOZiNhQkE7XPAbunoMGWB3zLC0
        HL6a77QzRE1CtJzDIQ2e2sdQBg==
X-Google-Smtp-Source: ABdhPJzPIZMc9LrIp5N7o7AiTnd5xTbWxJK2y44l0y3PfzTGxmDnHeBU07zaxi764YsMYVMUD+YxXg==
X-Received: by 2002:a65:6913:: with SMTP id s19mr14856275pgq.116.1600190413606;
        Tue, 15 Sep 2020 10:20:13 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id y202sm14769889pfc.179.2020.09.15.10.20.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 10:20:12 -0700 (PDT)
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
 <f4e4e9c3-b293-cef1-bb84-db7fe691882a@pensando.io>
 <20200915085045.446b854b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4b5e3547f3854fd399b26a663405b1f8@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <ad9b1163-fe3b-6793-c799-75a9c4ce87f9@pensando.io>
Date:   Tue, 15 Sep 2020 10:20:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <4b5e3547f3854fd399b26a663405b1f8@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/20 9:50 AM, Keller, Jacob E wrote:
>
>> -----Original Message-----
>> From: Jakub Kicinski <kuba@kernel.org>
>> Sent: Tuesday, September 15, 2020 8:51 AM
>> To: Shannon Nelson <snelson@pensando.io>
>> Cc: Keller, Jacob E <jacob.e.keller@intel.com>; netdev@vger.kernel.org;
>> davem@davemloft.net
>> Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
>>
>> On Mon, 14 Sep 2020 18:14:22 -0700 Shannon Nelson wrote:
>>> So now we're beginning to dance around timeout boundaries - how can we
>>> define the beginning and end of a timeout boundary, and how do they
>>> relate to the component and label?  Currently, if either the component
>>> or status_msg changes, the devlink user program does a newline to start
>>> a new status line.  The done and total values are used from each notify
>>> message to create a % value displayed, but are not dependent on any
>>> previous done or total values, so the total doesn't need to be the same
>>> value from status message to status message, even if the component and
>>> label remain the same, devlink will just print whatever % gets
>>> calculated that time.
>> I think systemd removes the timeout marking when it moves on to the
>> next job, and so should devlink when it moves on to the next
>> component/status_msg.

Works for me.  I'll try to note these UI implementation hints somewhere 
useful.

>>
>>> I'm thinking that the behavior of the timeout value should remain
>>> separate from the component and status_msg values, such that once given,
>>> then the userland countdown continues on that timeout.  Each subsequent
>>> notify, regardless of component or label changes, should continue
>>> reporting that same timeout value for as long as it applies to the
>>> action.  If a new timeout value is reported, the countdown starts over.
>> What if no timeout exists for the next action? Driver reports 0 to
>> "clear"?

Yes, that's what I would expect.

>>
>>> This continues until either the countdown finishes or the driver reports
>>> the flash as completed.  I think this allows is the flexibility for
>>> multiple steps that Jake alludes to above.  Does this make sense?
>> I disagree. This doesn't match reality/driver behavior and will lead to
>> timeouts counting to some random value, that's to say the drivers
>> timeout instant will not match when user space reaches timeout.
>>
>> The timeout should be per notification, because drivers send a
>> notification per command, and commands have timeout.
>>
> This is how everything operates today. Just send a new status for every command.
>
> Is that not how your case works?
>
>> The timeout is only needed if there is no progress to report, i.e.
>> driver is waiting for something to happen.
>>
> Right.
>
>>> What should the userland program do when the timeout expires?  Start
>>> counting backwards?  Stop waiting?  Do we care to define this at the moment?
>> [component] bla bla X% (timeout reached)
> Yep. I don't think userspace should bail or do anything but display here. Basically: the driver will timeout and then end the update process with an error. The timeout value is just a useful display so that users aren't confused why there is no output going on while waiting.
>
>

If individual notify messages have a timeout, how can we have a 
progress-percentage reported with a timeout?  This implies to me that 
the timeout is on the component:bla-bla pair, but there are many notify 
messages in order to show the progress in percentage done.  This is why 
I was suggesting that if the timeout and component and status messages 
haven't changed, then we're still working on the same timeout.

sln




