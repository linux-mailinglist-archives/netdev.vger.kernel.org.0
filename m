Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C971C2BFB
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 14:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgECMCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 08:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727112AbgECMCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 08:02:48 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6956C061A0C
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 05:02:48 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id c16so8653082ilr.3
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 05:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LwYEYv9jX5+IrarLgwN8+Y1BV1svZsAHqKGJl7IUx+E=;
        b=fUElKQ2OyKXgA1yO3+IJqOw83Wq/Xi0MGufOH61NEAFCZh+VqbXbC84QDAaRD65ST0
         3hmSnFy63/KOK9b4CDvR/tp7o8XSnaNqIOmYg8hL+5KSTnqaHqwWxHboGVTS2CV4d/Uc
         vyqYRAYAuU8yIBVljcdEsw298lZtS4mU4We89QqaZVZxsviPD2dxzIc/SV0wvrl04H2c
         Ne6rJKD9AAhXFntW53cftEfmavuo133RfIF4W1q2n8kOIzAewfIz3pA5T1uG2HQEc387
         vS7AQRSBREOvnIAi/is/fEeMIwBQFIN0upbKeijIEVzPZLzDRJq9BKKAg6S7FWiicgXf
         0I+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LwYEYv9jX5+IrarLgwN8+Y1BV1svZsAHqKGJl7IUx+E=;
        b=ZhAfn/IDslqtyhcESzz322WMKnfoRgIo2DmeMUKTtLNnrnaJWsopbanv5YjwkBzjjW
         zOum0zsoocQaOTmYvS0aXxPhP/hlpVnIw4mt1m9jwPcWxB+G4oxCJsQEprjfg9YA1htN
         Z9hEMaO4X0jvV0jugVWc4ocVpuyDefgD9cKgKNptw4QjeRg1UcB5Tawy7vyGO93TjZGm
         j54mcybyfhPz5IHcRbUgOMdOZW5ayswNXBj2eOCJ1mP88pHAxyvmBlDI1nTgkf/BRWbB
         Zl0L/0H0ciI/U/2iCa4cEgkGE3jVpcYCxdrdu24wwVwIOVYQPGkTsOBOng8gtK7+on6z
         vT8w==
X-Gm-Message-State: AGi0PuZijIs0wb94ZfGyngsCTMQXBE5zYfQocY2KkLpw5veVQwoQZ9eg
        LNB8L8XeDNZkUkiI+VAXDNUEYg==
X-Google-Smtp-Source: APiQypIFQO1Is391HJOFEwfiAyLzd/CfYMQjWlTgif/jujIN5gLBpcfhP061uChZRFNKeEqKDmVsjA==
X-Received: by 2002:a92:7303:: with SMTP id o3mr11739353ilc.275.1588507367762;
        Sun, 03 May 2020 05:02:47 -0700 (PDT)
Received: from [10.0.0.125] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id a5sm2753787ioa.47.2020.05.03.05.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2020 05:02:47 -0700 (PDT)
Subject: Re: [Patch net v2] net_sched: fix tcm_parent in tc filter dump
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
References: <20200501035349.31244-1-xiyou.wangcong@gmail.com>
 <7b3e8f90-0e1e-ff59-2378-c6e59c9c1d9e@mojatatu.com>
 <a18c1d1a-20a1-7346-4835-6163acb4339b@mojatatu.com>
 <CAM_iQpWi9MA5DEk7933aah3yeOQ+=bHO8H2-xpqTtcXn0k=+0Q@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <66d03368-9b8e-b953-a3a5-1f61b71e6307@mojatatu.com>
Date:   Sun, 3 May 2020 08:02:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWi9MA5DEk7933aah3yeOQ+=bHO8H2-xpqTtcXn0k=+0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-02 10:28 p.m., Cong Wang wrote:
> On Sat, May 2, 2020 at 2:19 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>
>> On 2020-05-02 4:48 a.m., Jamal Hadi Salim wrote:

[..]
>>> Note:
>>> tc filter show dev dummy0 root
>>> should not show that filter. OTOH,
>>> tc filter show dev dummy0 parent ffff:
>>> should.
> 
> Hmm, but we use TC_H_MAJ(tcm->tcm_parent) to do the
> lookup, 'root' (ffff:ffff) has the same MAJ with ingress
> (ffff:0000).
>

I have some long analysis and theory below.

> And qdisc_lookup() started to search for ingress since 2008,
> commit 8123b421e8ed944671d7241323ed3198cccb4041.
> 
> So it is likely too late to change this behavior even if it is not
> what we prefer.
> 

My gut feeling is that whatever broke (likely during block addition
maybe even earlier during clsact addition) is in the code
path for adding filter. Dumping may have bugs but i would
point a finger to filter addition first.
More below.... (sorry long email).


Here's what i tried after applying your patch:

----
# $TC qd add dev $DEV ingress
# $TC qd add dev $DEV root prio
# $TC qd ls dev $DEV
qdisc noqueue 0: dev lo root refcnt 2
qdisc prio 8008: dev enp0s1 root refcnt 2 bands 3 priomap 1 2 2 2 1 2 0 
0 1 1 1 1 1 1 1 1
qdisc ingress ffff: dev enp0s1 parent ffff:fff1 ----------------
-----

egress i.e root is at 8008:
ingress is at ffff:fff1

If say:
---
# $TC filter add dev $DEV root protocol arp prio 10 basic action pass
----

i am instructing the kernel to "go and find root (which is 8008:)
and install the filter there".
IOW, I could install that filter alternatively as:
----
# $TC filter add dev $DEV parent 8008: protocol arp prio 11 basic action 
pass
---

Basically these two filters are equivalent and should end in the
same qdisc.

To test, I added those two filters (the prio is useful to visualize
in the dump).

Lets see the dump:

-------
# $TC filter show dev $DEV root
filter protocol arp pref 10 basic chain 0
filter protocol arp pref 10 basic chain 0 handle 0x1
	action order 1: gact action pass
	 random type none pass val 0
	 index 1 ref 1 bind 1
---------

I was hoping i'd see both filters, but alas there's only
one.

Lets try a different dump explicitly specifying root qdisc id:
---------
# $TC filter show dev $DEV parent 8008:
filter protocol arp pref 11 basic chain 0
filter protocol arp pref 11 basic chain 0 handle 0x1
	action order 1: gact action pass
	 random type none pass val 0
	 index 2 ref 1 bind 1
---------

Again i was hoping to see both filters.

This sounds like the two filters are anchored
at two different qdiscs instead of the same one
(i.e root). Hence my suspicion...

Lets add a filter at ingress:
-----
$TC filter add dev $DEV parent ffff:fff1 protocol arp basic action pass
-------

Ok lets dump this from ingress:

-----
# $TC filter show dev $DEV parent ffff:fff1
filter protocol arp pref 10 basic chain 0
filter protocol arp pref 10 basic chain 0 handle 0x1
	action order 1: gact action pass
	 random type none pass val 0
	 index 1 ref 1 bind 1

filter protocol arp pref 49152 basic chain 0
filter protocol arp pref 49152 basic chain 0 handle 0x1
	action order 1: gact action pass
	 random type none pass val 0
	 index 3 ref 1 bind 1
-------------

Same result if i said "root".
I was only expecting to see the one with pref 49152 in
the above output.

It _feels_ like those two filters(ingress and egress) are
installed in the same struct.

Ok, last dump without specifying a parent, which should
pick root qdisc per code:
------
# $TC filter show dev $DEV
filter parent 8008: protocol arp pref 11 basic chain 0
filter parent 8008: protocol arp pref 11 basic chain 0 handle 0x1
	action order 1: gact action pass
	 random type none pass val 0
	 index 2 ref 1 bind 1
----

Semantically this should have dumped all 3 filters and
not just pick root. But that issue has been there
for a decade like you said. So it is reasonable to specify
parent ffff:fff1 for dumping just ingress side.
Also reasonable not to see ingress when dumping root.

> If parent is not specified, only egress will be shown, as
> we just assign q = dev->qdisc.
>

Which is the root egress qdisc.
That is the "$TC filter show dev $DEV" scenario.
See my comment above.

> I agree, 'root' should mean the root qdisc on egress, matching
> ingress with 'root' doesn't make much sense to me either.
> 
> But I am afraid it is too late to change ,if this behavior has been
> there for 12+ years.
> 

Although i cant pinpoint exactly when - this used to work (I dont think
its 12+ years but I could be wrong). These semantics are really broken.

Do you have time to look at the theory that things break at install?
If you dont have time i could try to debug it by Tuesday.

cheers,
jamal
