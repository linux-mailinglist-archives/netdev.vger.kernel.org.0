Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DADC16EB47
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbgBYQWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:22:06 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]:36664 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYQWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 11:22:06 -0500
Received: by mail-wm1-f51.google.com with SMTP id p17so3769994wma.1
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 08:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d1z35iqXHHz3DCmpspByqRW+sYaaZfog2vGpS6MJ+go=;
        b=xF7wkYB+Dqscrlrus+uV4fbgupRzK2Z5v65/QWMG3ZIdiGpy0WV8fhI68nA21Q1vb5
         KJowvJNp5HknTNhgau3NZpz69Qv3tTRQLuYuCJ6yoW+mOgF/PsgcsJ+zzqo4TAJBJHNB
         iKI+2MDzQ8ne0jaUOc42+m8jEWmOv9M83NlBIBxYDYDiuiWsI1oXguMmf92dmx9BGy9t
         dkvo0jgC0iLqDWc19xPLpDu3v14A4TQFEzYhVR+FFvWU4GVhyLP3cswxC1o4cMhbPKIf
         FqGtKSlVgjoUDMDcXKEDxIBqJjVHQh8MjtkdoOw3ozGTLVVslt4JfwuhDAddhjET8ZYo
         VfDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d1z35iqXHHz3DCmpspByqRW+sYaaZfog2vGpS6MJ+go=;
        b=rTi+Da0wDzxzyQ8bjLPu+V7vVRTdcvTMFo0BNzf9ofEuwcYcwmrXib8xRX3nY14UYb
         Gkgxs2Kjw/mtnWYGoAqUiaXtmLXazBkim7fSRrjPJUlYiLK8wWTyRUIobEYGhzz90eCb
         qWeAP9tT5D2ryd5DKXGQJTM056MDvGHARnfIbj+5aFYNt85kkLXvuvBS6+NN5poZ/pIh
         JtBGR51IldR0SK/zfl1fAkIFoSCPaR59QD2GvsMBWJz/9ukaupVn7cRf+oCXyWsl1vox
         TO6+COrnDEQ4T5SVQNcvOaWczh40K5Lbgfyexh/Bpx5cEgAea+4eccWX73BcRbfInvpK
         OmAg==
X-Gm-Message-State: APjAAAWu9fsjWrDFPejBJzLkARs52fRdOXCxqqlNOSFUxkPS8whNAJxp
        2uxqCBCeog881MclcD8frLz3qA==
X-Google-Smtp-Source: APXvYqwMS8ymCxHvUvqTVkptr478APcZc28p/j4LYu1IJviffoGyJNb+fvCgr/3Xv0Kkdi4RQaABaQ==
X-Received: by 2002:a1c:238e:: with SMTP id j136mr56099wmj.17.1582647724969;
        Tue, 25 Feb 2020 08:22:04 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id n5sm7610258wrq.40.2020.02.25.08.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 08:22:04 -0800 (PST)
Date:   Tue, 25 Feb 2020 17:22:03 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org,
        michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, xiyou.wangcong@gmail.com,
        pablo@netfilter.org, mlxsw@mellanox.com,
        Marian Pritsak <marianp@mellanox.com>
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW
 stats type
Message-ID: <20200225162203.GE17869@nanopsycho>
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
 <20200224131101.GC16270@nanopsycho>
 <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
 <20200224162521.GE16270@nanopsycho>
 <b93272f2-f76c-10b5-1c2a-6d39e917ffd6@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b93272f2-f76c-10b5-1c2a-6d39e917ffd6@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 25, 2020 at 05:01:05PM CET, jhs@mojatatu.com wrote:
>+Cc Marian.
>
>On 2020-02-24 11:25 a.m., Jiri Pirko wrote:
>> Mon, Feb 24, 2020 at 04:45:57PM CET, jhs@mojatatu.com wrote:
>> > On 2020-02-24 8:11 a.m., Jiri Pirko wrote:
>> > > Mon, Feb 24, 2020 at 12:38:20PM CET, ecree@solarflare.com wrote:
>> > > > On 22/02/2020 06:38, Jiri Pirko wrote:
>> > 
>
>> > There's also a requirement for the concept of "sharing" - think
>> > "family plans" or "small bussiness plan".
>> > Counters may be shared across multiple filter-action chains for example.
>> 
>> In hardware, we have a separate "counter" action with counter index.
>
>Ok, so it is similar semantics.
>In your case, you abstract it as a speacial action, but in most
>abstractions(including P4) it looks like an indexed table.
>From a tc perspective you could abstract the equivalent to
>your "counter action" as a gact "ok" or "pipe",etc depending
>on your policy goal. The counter index becomes the gact index
>if there is no conflict.
>In most actions "index" attribute is really mapped to a
>"counter" index. Exception would be actions with state
>(like policer).
>
>> You can reuse this index in multiple counter action instances.
>
>That is great because it maps to tc semantics. When you create
>an action of the same type, you can specify the index and it
>is re-used. Example:
>
>sudo tc filter add dev lo parent ffff: protocol ip prio 8 u32 \
>match ip dst 127.0.0.8/32 flowid 1:8 \
>action vlan push id 8 protocol 802.1q index 8\
>action mirred egress mirror dev eth0 index 111
>
>sudo tc filter add dev lo parent ffff: protocol ip prio 8 u32 \
>match ip dst 127.0.0.15/32 flowid 1:10 \
>action vlan push id 15 protocol 802.1q index 15 \
>action mirred egress mirror index 111 \
>action drop index 111
>
>So for the shared mirror action the counter is shared
>by virtue of specifying index 111.
>
>What tc _doesnt allow_ is to re-use the same
>counter index across different types of actions (example
>mirror index 111 is not the same instance as drop 111).
>Thats why i was asking if you are exposing the hw index.

User does not care about any "hw index". That should be abstracted out
by the driver.


>
>> However, in tc there is implicit separate counter for every action.
>> 
>
>Yes, and is proving to be a challenge for hw. In s/w it makes sense.
>It seemed sensible at the time; existing hardware back then
>(broadcom 5691 family and cant remember the other vendor, iirc)
>hard coded the actions with counters. Mind you they would
>only support one action per match.
>
>Some rethinking is needed of this status quo.
>So maybe having syntaticaly an index for s/w vs h/w may make
>sense.
>Knowing the indices is important. As an example, for telemetry
>you may be very interesting in dumping only the counter stats
>instead of the rule. Dumping gact has always made it easy in
>my use cases because it doesnt have a lot of attributes. But it
>could make sense to introduce a new semantic like "dump action stats .."
>
>> The counter is limited resource. So we overcome this mismatch in mlxsw
>> by having action "counter" always first for every rule inserted:
>> rule->action_counter,the_actual_action,the_actual_action2,...the_actual_actionN
>> 
>
>So i am guessing the hw cant support "branching" i.e based on in
>some action state sometime you may execute action foo and other times
>action bar. Those kind of scenarios would need multiple counters.

We don't and when/if we do, we need to put another counter to the
branch point.


>> and we report stats from action_counter for all the_actual_actionX.
>
>This may not be accurate if you are branching - for example
>a policer or quota enforcer which either accepts or drops or sends next
>to a marker action etc .
>IMO, this was fine in the old days when you had one action per match.
>Best is to leave it to whoever creates the policy to decide what to
>count. IOW, I think modelling it as a pipe or ok or drop or continue
>and be placed anywhere in the policy graph instead of the begining.

Eh, that is not that simple. The existing users are used to the fact
that the actions are providing counters by themselves. Having and
explicit counter action like this would break that expectation.
Also, I think it should be up to the driver implementation. Some HW
might only support stats per rule, not the actions. Driver should fit
into the existing abstraction, I think it is fine.


>
>> > Sharing then becomes a matter of specifying the same drop action
>> > with the correct index across multiple filters.
>> > 
>> > If you dont have enough hw counters - then perhaps a scheme to show
>> > separate hardware counter index and software counter index (aka action
>> > index) is needed.
>> 
>> I don't, that is the purpose of this patchset, to be able to avoid the
>> "action_counter" from the example I wrote above.
>
>IMO, it would make sense to reuse existing gact for example and
>annotate s/w vs h/w indices as a starting point. It keeps the
>existing approach intact.
>
>> Note that I don't want to share, there is still separate "last_hit"
>> record in hw I expose in "used X sec". Interestingly enough, in
>> Spectrum-1 this is per rule, in Spectrum-2,3 this is per action block :)
>
>I didnt understand this one..

It's not "stats", it's an information about how long ago the act was
used.


>
>cheers,
>jamal
