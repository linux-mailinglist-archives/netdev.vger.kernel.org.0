Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 554D0109A7
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfEAOwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:52:45 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33044 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfEAOwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:52:43 -0400
Received: by mail-pf1-f194.google.com with SMTP id z28so3405102pfk.0;
        Wed, 01 May 2019 07:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oWROtRdPBWTf7HTlcFeLvHN8moYEACZeaHhy/xJiSv0=;
        b=L1aBWvxy2K+R3sMxmTz7GhC3sns+1WyTpaeuGZ0wjKCrk9xzgtACf0ijI5RHnG5F7T
         K4gxPCeVPvHbm/PC6gaehD3NSEyogbDn4a6cAEYc0F4z5hQSJu60LnDdVC1H2v3Zlubt
         isIxmGloKem4FUOw5j15O2ZPoDDB1FpzqL5+bWsFZwK0pFHXBGS2SJgR51jwdHUdNK8S
         fqfBnbldFbG7qXj0oElml4Sz7dMWlX4HQ4Cf7vwNsravbptRTh+0DJzAR6NNacj01r1W
         m+R7kJO2OIIso1c8XYcCgCMxzn+3bCznvYOmkqd61vkIU2mfgPsMyxyI8rwdYfiQf1+Z
         Y8cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oWROtRdPBWTf7HTlcFeLvHN8moYEACZeaHhy/xJiSv0=;
        b=Zlt74aulX6xvwSeTdLnaTwq7eElWZNzlxxiHhsCb4z4zuPYYO6fD7mWbO4PX+25oBh
         PXjahoyANZ5x5SszvmyudlyW+8K2i32RKaEOt+gFNttAPhHVYZYQuWa+6AF9Pal+is3H
         ubTJQLWI63wVu8LUxUUQ9ArGjn8/RvbG9zosSio52NMEmHLryybTWRl4/VE1YLv+zi9W
         /mRoGjcqkLJ1LFMBnZ+lpzV9yoL278MNdenhXc14KLKg2OoEzFvPmkH7Xwgc7myZQalG
         UIL4f9m3hOjcIAr44LRb8qNfYEtUX+vraf7qsx3gdQ/WYpYgW0+OgzxfexF6McrordqV
         YKwg==
X-Gm-Message-State: APjAAAVJcpAmPWGo5xrdNr5tJwj1Q08oZ5T2bfpyQ2IUvoXz7A/Sb2j5
        agnPnys2tVzIp2aFQSYxulE=
X-Google-Smtp-Source: APXvYqzS2NLovEFoo71ZXdlfy+C1Ekszn7LBSp60zvJC49KCN2jjwa0O/cUTe5CtRQP7pQXSimKQNQ==
X-Received: by 2002:aa7:99c7:: with SMTP id v7mr19874361pfi.103.1556722362514;
        Wed, 01 May 2019 07:52:42 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:950d:299e:8124:b280? ([2601:282:800:fd80:950d:299e:8124:b280])
        by smtp.googlemail.com with ESMTPSA id m131sm984427pfc.25.2019.05.01.07.52.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 07:52:41 -0700 (PDT)
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Julian Anastasov <ja@ssi.bg>, Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000007d22100573d66078@google.com>
 <alpine.LFD.2.20.1808201527230.2758@ja.home.ssi.bg>
 <4684eef5-ea50-2965-86a0-492b8b1e4f52@I-love.SAKURA.ne.jp>
 <9d430543-33c3-0d9b-dc77-3a179a8e3919@I-love.SAKURA.ne.jp>
 <920ebaf1-ee87-0dbb-6805-660c1cbce3d0@I-love.SAKURA.ne.jp>
 <cc054b5c-4e95-8d30-d4bf-9c85f7e20092@gmail.com>
 <15b353e9-49a2-f08b-dc45-2e9bad3abfe2@i-love.sakura.ne.jp>
 <057735f0-4475-7a7b-815f-034b1095fa6c@gmail.com>
 <6e57bc11-1603-0898-dfd4-0f091901b422@i-love.sakura.ne.jp>
 <f71dd5cd-c040-c8d6-ab4b-df97dea23341@gmail.com>
 <d56b7989-8ac6-36be-0d0b-43251e1a2907@gmail.com>
 <117fcc49-d389-c389-918f-86ccaef82e51@i-love.sakura.ne.jp>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <70be7d61-a6fe-e703-978a-d17f544efb44@gmail.com>
Date:   Wed, 1 May 2019 08:52:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <117fcc49-d389-c389-918f-86ccaef82e51@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/19 7:38 AM, Tetsuo Handa wrote:
> On 2019/04/30 3:43, David Ahern wrote:
>>> The attached patch adds a tracepoint to notifier_call_chain. If you have
>>> KALLSYMS enabled it will show the order of the function handlers:
>>>
>>> perf record -e notifier:* -a -g &
>>>
>>> ip netns del <NAME>
>>> <wait a few seconds>
>>>
>>> fg
>>> <ctrl-c on perf-record>
>>>
>>> perf script
>>>
>>
>> with the header file this time.
>>
> 
> What is the intent of your patch? I can see that many notifiers are called. But
> how does this help identify which event is responsible for dropping the refcount?
> 

In a previous response you stated: "Since I'm not a netdev person, I
appreciate if you can explain that shutdown sequence using a flow chart."

The notifier sequence tells you the order of cleanup handlers and what
happens when a namespace is destroyed.

The dev_hold / dev_put tracepoint helps find the refcnt leak but
requires some time analyzing the output to match up hold / put stack traces.
