Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7211217008F
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 14:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgBZN4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 08:56:54 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:39418 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgBZN4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 08:56:54 -0500
Received: by mail-wr1-f51.google.com with SMTP id y17so3131428wrn.6
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 05:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kQDNC6yapmI/GW8O195WaF+Fc3cLJNs40DCVr0F1S/U=;
        b=VcvkNYtLb7PCmvgHr/ILwBcDv1sERqTXaZf7a4h85GTnkG7JXZ6pObvnRuRHb5Hbvi
         EL+zVs7Eg6igdjDxhe/p1d1Nl0UElQcVwKE5FMBPHylY1IEFEBGcaW4f+KvITpIKfGvA
         EFJHGGmPeUg0K5SvPlFhLyayTpjDTkVx89+kJss62MdNWulzppABCFNVkyaykiLxMzD0
         8InyjoFkc7s1/M+gh/r4lY2r2eZMhDcZKU1n5DGfmHjQ56beUW7TJoQBStFw9LbAjtqy
         XkOlf0V1xcapv51pZ2iAs9Fqvf2xrKMlweU5LHQBrgMNa1e2L/xgHT6OHqMIEHE8IXa+
         dpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kQDNC6yapmI/GW8O195WaF+Fc3cLJNs40DCVr0F1S/U=;
        b=a8NnFmQEPJV6+onIehIICtYQTg2LS71Cku5vLIyfV2MEvGq69CA2oFpRZXz8/Y3twD
         rXIczKcUxI4soPwKWiIohksnnW6W5L5B4GREEuhlUdQd7xbXgS1fK/505zxBKd6FmyEH
         xTu/oXHqnvBEfaQ8Ia0D2qmA0fwnc0kWY0JfsBVXazcFbmRrcUdlY4SxzRrfDxoVEJeY
         A5ef4xy1Uo0rnDXpW5iwwNWheCM31sUyWaQAKO/PGbH1XoPSdxX4czNarkNYMKneR0Ff
         NM1JH3C8giSB5FfD+zI+Z3hu5rGUtheb4WObl/7VB+ka0Q1PnFhoV00BUtGwlyV6umG5
         MOWQ==
X-Gm-Message-State: APjAAAXvQKUYXh/X76T7h8WnSIpKRjHDmRGL+fpFUeyQzeDe69L8Ekls
        89Osl03Zj3If6eO9g4MfkQ1hvg==
X-Google-Smtp-Source: APXvYqwXtPl/4kD/J5aBt82o+cYp07wtw6zjgJZXuVx7bxaUlHhd2HIUCjwCz1puvNfHdgnYcqI4Kg==
X-Received: by 2002:a5d:6986:: with SMTP id g6mr5747726wru.421.1582725411589;
        Wed, 26 Feb 2020 05:56:51 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id i2sm2925871wmb.28.2020.02.26.05.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 05:56:51 -0800 (PST)
Date:   Wed, 26 Feb 2020 14:56:50 +0100
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
Message-ID: <20200226135650.GA26061@nanopsycho>
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
 <20200224131101.GC16270@nanopsycho>
 <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
 <20200224162521.GE16270@nanopsycho>
 <b93272f2-f76c-10b5-1c2a-6d39e917ffd6@mojatatu.com>
 <20200225162203.GE17869@nanopsycho>
 <7c753f81-f659-02c0-7011-9522547b19db@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c753f81-f659-02c0-7011-9522547b19db@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 26, 2020 at 01:52:20PM CET, jhs@mojatatu.com wrote:
>On 2020-02-25 11:22 a.m., Jiri Pirko wrote:
>> Tue, Feb 25, 2020 at 05:01:05PM CET, jhs@mojatatu.com wrote:
>> > +Cc Marian.
>> > 
>
>
>
>> > So for the shared mirror action the counter is shared
>> > by virtue of specifying index 111.
>> > 
>> > What tc _doesnt allow_ is to re-use the same
>> > counter index across different types of actions (example
>> > mirror index 111 is not the same instance as drop 111).
>> > Thats why i was asking if you are exposing the hw index.
>> 
>> User does not care about any "hw index". That should be abstracted out
>> by the driver.
>> 
>
>My main motivation is proper accounting (which is important
>for the billing and debugging of course). Example:
>if i say "get stats" I should know it is the sum of both
>h/w + s/w stats or the rules are clear in regards to how
>to retrieve each and sum them or differentiate them.
>If your patch takes care of summing up things etc, then i agree.

The current state implemented in the code is summing up the stats. My
patchset has no relation to that.


>Or if the rules for accounting are consistent then we are fine
>as well.
>
>> > So i am guessing the hw cant support "branching" i.e based on in
>> > some action state sometime you may execute action foo and other times
>> > action bar. Those kind of scenarios would need multiple counters.
>> 
>> We don't and when/if we do, we need to put another counter to the
>> branch point.
>> 
>
>Ok, that would work.
>> 
>> > > and we report stats from action_counter for all the_actual_actionX.
>> > 
>> > This may not be accurate if you are branching - for example
>> > a policer or quota enforcer which either accepts or drops or sends next
>> > to a marker action etc .
>> > IMO, this was fine in the old days when you had one action per match.
>> > Best is to leave it to whoever creates the policy to decide what to
>> > count. IOW, I think modelling it as a pipe or ok or drop or continue
>> > and be placed anywhere in the policy graph instead of the begining.
>> 
>> Eh, that is not that simple. The existing users are used to the fact
>> that the actions are providing counters by themselves. Having and
>> explicit counter action like this would break that expectation.
>>
>> Also, I think it should be up to the driver implementation. Some HW
>> might only support stats per rule, not the actions. Driver should fit
>> into the existing abstraction, I think it is fine.
>> 
>
>Reasonable point.
>So "count" action is only useful for h/w?

There is no "count" action and should not be.


>
>> > > Note that I don't want to share, there is still separate "last_hit"
>> > > record in hw I expose in "used X sec". Interestingly enough, in
>> > > Spectrum-1 this is per rule, in Spectrum-2,3 this is per action block :)
>> > 
>> > I didnt understand this one..
>> 
>> It's not "stats", it's an information about how long ago the act was
>> used.
>
>ah. Given tc has one of those per action, are you looking to introduce
>a new "last used" action?

No.


>
>cheers,
>jamal
