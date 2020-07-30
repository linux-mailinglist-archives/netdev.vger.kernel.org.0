Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9ECA23386E
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 20:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgG3SgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 14:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3SgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 14:36:23 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5670CC061574;
        Thu, 30 Jul 2020 11:36:23 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k13so7131449plk.13;
        Thu, 30 Jul 2020 11:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k6bmctTVblpwuRx6dkbrvHULuxrJOWF9XF1cvoRZiTY=;
        b=RqCOiWrVPQjy6IlZEk/qXb0QV4B32B7qwyXF6DwZ5qDCkDGMV8GRbm66+Rnh8K/2CZ
         soK9XDNO8KRVHmzwipg1I9+HqF60twAnDPrNTElm1Aslww4bPr8tYBhPx8oU3BGYkUd8
         TFJuNmtfbjjKN1mjHmqVRvifprn0rEkfIjnsCgtda1lkAuOzR2pF54jxRcDL4iCilrNP
         XxjZhBdr9Y2ZMmRZtF2aacb5v+/fv8NWHZukMpTdhY2ejYiq2Z5Mkn1h5GAyN6ySnTH4
         lQ12P5J0Nx5MW2tHNCw68bRE/TuFcrHGqJNrtCpCty4j/xd/0r8crIAb6FbKnIdvYRx/
         z9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k6bmctTVblpwuRx6dkbrvHULuxrJOWF9XF1cvoRZiTY=;
        b=BlGiGfjnr5yMgPv2ZncLsjDMBIu7cK/kkQC0vYp/U7DpQaHrXKZy6Gon2hMM9+Nqvx
         We0b7r8fc9Hn5yglunh6lglbT6k4KXZ95ZxxRB90ZPiEB+oAnNk07Xj/ZG82URG4UEk0
         i3FCISwReKv6b7wTOiQZVzX3tcQSBAM0Zt6tTYgkhrKH7K38NIOp+/+4NemV3ShtrZ94
         4mropjaevHb+pSF7VWP4S9A1A+AzssnpVbGLEcNe7coyc1iqbdvNSSX3B1zqj2yzRgH1
         smnDLuoTxnzf95s708kGmzTMaXKEwuw3F1IkYlS+0NY0F4d+EmdxEI9yUvtg3Ie1r0JR
         v8AA==
X-Gm-Message-State: AOAM531K8e9ppVQE2o16l4aBxTW3xXbNqaOJjuxFGET+yw3nAXdkPCsg
        AWbXBpLWpBKQYgtG4wvwTVs=
X-Google-Smtp-Source: ABdhPJwhW08/c7vJi/2IhzixLVqb/1fWz7Po2kgE+huzqVdnz6aneVFNeDfjjk+7S4WjjPqGATx8Mw==
X-Received: by 2002:a17:90a:2a02:: with SMTP id i2mr405933pjd.157.1596134182792;
        Thu, 30 Jul 2020 11:36:22 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p19sm7188470pgj.74.2020.07.30.11.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 11:36:21 -0700 (PDT)
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogSU5GTzogcmN1IGRldGVjdGVkIHN0YWxsIGluIHRj?=
 =?UTF-8?Q?=5fmodify=5fqdisc?=
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     "Zhang, Qiang" <Qiang.Zhang@windriver.com>,
        syzbot <syzbot+9f78d5c664a8c33f4cce@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
References: <0000000000006f179d05ab8e2cf2@google.com>
 <BYAPR11MB2632784BE3AD9F03C5C95263FF700@BYAPR11MB2632.namprd11.prod.outlook.com>
 <87tuxqxhgq.fsf@intel.com>
 <CACT4Y+ZMvaJMiXikYCm-Xym8ddKDY0n-5=kwH7i2Hu-9uJW1kQ@mail.gmail.com>
 <87pn8cyk2b.fsf@intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3fc2ce1b-553a-e6de-776c-7e4d668c6ecb@gmail.com>
Date:   Thu, 30 Jul 2020 11:36:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87pn8cyk2b.fsf@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/20 10:44 AM, Vinicius Costa Gomes wrote:
> Hi,
> 
> Dmitry Vyukov <dvyukov@google.com> writes:
> 
>> On Wed, Jul 29, 2020 at 9:13 PM Vinicius Costa Gomes
>> <vinicius.gomes@intel.com> wrote:
>>>
>>> Hi,
>>>
>>> "Zhang, Qiang" <Qiang.Zhang@windriver.com> writes:
>>>
>>>> ________________________________________
>>>> 发件人: linux-kernel-owner@vger.kernel.org <linux-kernel-owner@vger.kernel.org> 代表 syzbot <syzbot+9f78d5c664a8c33f4cce@syzkaller.appspotmail.com>
>>>> 发送时间: 2020年7月29日 13:53
>>>> 收件人: davem@davemloft.net; fweisbec@gmail.com; jhs@mojatatu.com; jiri@resnulli.us; linux-kernel@vger.kernel.org; mingo@kernel.org; netdev@vger.kernel.org; syzkaller-bugs@googlegroups.com; tglx@linutronix.de; vinicius.gomes@intel.com; xiyou.wangcong@gmail.com
>>>> 主题: INFO: rcu detected stall in tc_modify_qdisc
>>>>
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    181964e6 fix a braino in cmsghdr_from_user_compat_to_kern()
>>>> git tree:       net
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12925e38900000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f87a5e4232fdb267
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=9f78d5c664a8c33f4cce
>>>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>>>> syz repro:
>>>> https://syzkaller.appspot.com/x/repro.syz?x=16587f8c900000
>>>
>>> It seems that syzkaller is generating an schedule with too small
>>> intervals (3ns in this case) which causes a hrtimer busy-loop which
>>> starves other kernel threads.
>>>
>>> We could put some limits on the interval when running in software mode,
>>> but I don't like this too much, because we are talking about users with
>>> CAP_NET_ADMIN and they have easier ways to do bad things to the system.
>>
>> Hi Vinicius,
>>
>> Could you explain why you don't like the argument if it's for CAP_NET_ADMIN?
>> Good code should check arguments regardless I think and it's useful to
>> protect root from, say, programming bugs rather than kill the machine
>> on any bug and misconfiguration. What am I missing?
> 
> I admit that I am on the fence on that argument: do not let even root
> crash the system (the point that my code is crashing the system gives
> weight to this side) vs. root has great powers, they need to know what
> they are doing.
> 
> The argument that I used to convince myself was: root can easily create
> a bunch of processes and give them the highest priority and do
> effectively the same thing as this issue, so I went with a the "they
> need to know what they are doing side".
> 
> A bit more on the specifics here:
> 
>   - Using a small interval size, is only a limitation of the taprio
>   software mode, when using hardware offloads (which I think most users
>   do), any interval size (supported by the hardware) can be used;
> 
>   - Choosing a good lower limit for this seems kind of hard: something
>   below 1us would never work well, I think, but things 1us < x < 100us
>   will depend on the hardware/kernel config/system load, and this is the
>   range includes "useful" values for many systems.
> 
> Perhaps a middle ground would be to impose a limit based on the link
> speed, the interval can never be smaller than the time it takes to send
> the minimum ethernet frame (for 1G links this would be ~480ns, should be
> enough to catch most programming mistakes). I am going to add this and
> see how it looks like.
> 
> Sorry for the brain dump :-)


I do not know taprio details, but do you really need a periodic timer ?

Presumably there is no need to fire a timer before next packet departure time ?


