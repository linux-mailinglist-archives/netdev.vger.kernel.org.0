Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED67216FF58
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 13:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgBZMwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 07:52:24 -0500
Received: from mail-il1-f182.google.com ([209.85.166.182]:33540 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBZMwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 07:52:24 -0500
Received: by mail-il1-f182.google.com with SMTP id s18so2291562iln.0
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 04:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X3rB0gf0zhaIdOb+lwYeGRxUQUfRNbGblUm96Z35laQ=;
        b=G7GKNDlxtZ9rgChnBRF44TWUF+NRqAhmvgPE167wdFEnNq1rbpnWeWUSf8IKRXkUJC
         f3k6PLkcxwlxkBGLJe9JkQEO6ZA//PFdSMlRJMJJc8wKmJFYlDCEa09N8M51Cp+berSy
         cO+7rzfgOSy+J/S2MIvMs7NPHy+eYBt2/EIIJ/W9RxIIffsUiVNDySZLA/cshhk2YzJN
         xctz3xPnHaxYqRh4fckazmMfXSh7YJOeWQreAl/1Kz/n+IU20RWqz9s00z+bEX3FcFOE
         riBauE93ysSFQv7rL0G97YFzxwpDekLdHD9NjIKxkHzHlH5jGrET98y4TAubWNFYZozh
         HunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X3rB0gf0zhaIdOb+lwYeGRxUQUfRNbGblUm96Z35laQ=;
        b=b+uAoCuRR4Sho7idrwt2xcgPEjP+4FAB6vHF/yPtMMhNoAUI1IJv5Imo6KAuzQFI2C
         yPbawHJGTKMB655637NkqasiVxQiicTwnQBIova9vokjOUpUn+qMamminhCVE7I89w3C
         TufDOGvYThShsVVFKDMx0ZT/wMyNFQMuK6jTTVISquwtyFnaYomrHHXgctULd/UyplAD
         5MzAtlVOym7CBr4mAQSXt3cY+7EgTgfX8LKm3FXDdCFH2qC4z2x5XBncaDo1ux3zobXS
         eqvmIXu8jZN7nIQNGHrqKKmC7wMcBeFS1jZe92H2gSY4aoFII3UGZUE/f8viDX8QoeNZ
         EI0w==
X-Gm-Message-State: APjAAAVfrbNmRXRVazXLqxHBkxBoQdskg3CzAduy1b7vU5+fyxyVS1hy
        Q6f8ZDQa0FnY0CzFvk1aKzwRag==
X-Google-Smtp-Source: APXvYqzJK7j2s5q2MTni6uXCKUIYjHl6s+QxVvz5pLEVUpqS0X4aA8EXY3yielStgidiVzi/nnAkog==
X-Received: by 2002:a05:6e02:690:: with SMTP id o16mr4875443ils.267.1582721543162;
        Wed, 26 Feb 2020 04:52:23 -0800 (PST)
Received: from [192.168.0.101] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id v3sm698232ili.0.2020.02.26.04.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 04:52:22 -0800 (PST)
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW stats
 type
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org,
        michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, xiyou.wangcong@gmail.com,
        pablo@netfilter.org, mlxsw@mellanox.com,
        Marian Pritsak <marianp@mellanox.com>
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
 <20200224131101.GC16270@nanopsycho>
 <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
 <20200224162521.GE16270@nanopsycho>
 <b93272f2-f76c-10b5-1c2a-6d39e917ffd6@mojatatu.com>
 <20200225162203.GE17869@nanopsycho>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7c753f81-f659-02c0-7011-9522547b19db@mojatatu.com>
Date:   Wed, 26 Feb 2020 07:52:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225162203.GE17869@nanopsycho>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-25 11:22 a.m., Jiri Pirko wrote:
> Tue, Feb 25, 2020 at 05:01:05PM CET, jhs@mojatatu.com wrote:
>> +Cc Marian.
>>



>> So for the shared mirror action the counter is shared
>> by virtue of specifying index 111.
>>
>> What tc _doesnt allow_ is to re-use the same
>> counter index across different types of actions (example
>> mirror index 111 is not the same instance as drop 111).
>> Thats why i was asking if you are exposing the hw index.
> 
> User does not care about any "hw index". That should be abstracted out
> by the driver.
> 

My main motivation is proper accounting (which is important
for the billing and debugging of course). Example:
if i say "get stats" I should know it is the sum of both
h/w + s/w stats or the rules are clear in regards to how
to retrieve each and sum them or differentiate them.
If your patch takes care of summing up things etc, then i agree.
Or if the rules for accounting are consistent then we are fine
as well.

>> So i am guessing the hw cant support "branching" i.e based on in
>> some action state sometime you may execute action foo and other times
>> action bar. Those kind of scenarios would need multiple counters.
> 
> We don't and when/if we do, we need to put another counter to the
> branch point.
>

Ok, that would work.
> 
>>> and we report stats from action_counter for all the_actual_actionX.
>>
>> This may not be accurate if you are branching - for example
>> a policer or quota enforcer which either accepts or drops or sends next
>> to a marker action etc .
>> IMO, this was fine in the old days when you had one action per match.
>> Best is to leave it to whoever creates the policy to decide what to
>> count. IOW, I think modelling it as a pipe or ok or drop or continue
>> and be placed anywhere in the policy graph instead of the begining.
> 
> Eh, that is not that simple. The existing users are used to the fact
> that the actions are providing counters by themselves. Having and
> explicit counter action like this would break that expectation.
 >
> Also, I think it should be up to the driver implementation. Some HW
> might only support stats per rule, not the actions. Driver should fit
> into the existing abstraction, I think it is fine.
>

Reasonable point.
So "count" action is only useful for h/w?

>>> Note that I don't want to share, there is still separate "last_hit"
>>> record in hw I expose in "used X sec". Interestingly enough, in
>>> Spectrum-1 this is per rule, in Spectrum-2,3 this is per action block :)
>>
>> I didnt understand this one..
> 
> It's not "stats", it's an information about how long ago the act was
> used.

ah. Given tc has one of those per action, are you looking to introduce
a new "last used" action?

cheers,
jamal
