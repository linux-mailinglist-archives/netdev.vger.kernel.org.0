Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4568657D3C6
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 21:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiGUTBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 15:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiGUTBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 15:01:19 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B038149C
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 12:01:18 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d7so2673532plr.9
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 12:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KoKkwdRICU4sQcPsoLDw49CNv3WbsfP0HasODRgjUJU=;
        b=Eu+8dHDoOQUdUFi0DfNodem5PTIgNfkAlh3J6kAreiRFOQ8P+S02Cr7ne5ZAnueN8d
         GM/P14qR4V96V56bGYW9Mq3UoPc/n/uHZbe1zDO+sZLBOfqeNb6MWTcJBNb44gCQ4lg/
         BjX0pNGmZlXkc3ifSPydERzu/eV5HC2wLh++kC6Gq8L6A8gRA2ccCEf9jeVJUxp0rn0o
         jj3aZ82kigYRH5AQQaNoo93KMOpW3fLhnpCO0k8B6+71zBhgtSXa1HZE1Qn1pELoDwQX
         rrU//3tStGbun1Ak9N7o4mCrgWNqkeK1gmnCpDkT2v7mZZrcix4nRXTMPU358J+5fMVK
         lEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KoKkwdRICU4sQcPsoLDw49CNv3WbsfP0HasODRgjUJU=;
        b=2Gelr9LT1JVOt3TLL0fejc1YyH8GncDVP/nWZfysNe7wJc+aQTcd2nPjr7YQ+qLSRj
         hXd30buA4HvnQ1zVEBFXoq+DAdD0ABh5HLYLec3mKxLSdsqU5NuCyx45PmqjH4IoCwSG
         5ilDaCoKiTntLKkeslRtevKlVkkD56/e/OjqhuJ7SplRZY7oIwTVUkb1sfSVF4XD/5Qk
         zjCAbMM8lkq6M4Vqf8E8MUmHeGURTM7vMgQ4ID94UtW2XO+466iG3LdOYNO+PJuTSkAk
         y8dGvh1FAvZTuEaZstfMKAyJ68En2oJvBhLjF7RF4CFst3hx3lNiDEV8+lr+Mb0O+QG0
         irhQ==
X-Gm-Message-State: AJIora+F5K3S45qtmEqjGmPzgRqbseKyQBsmvyw0foQ5TQ7ADzhWDq0g
        KA69l2l/Qr6MJNhQMxOfTrc=
X-Google-Smtp-Source: AGRyM1sTF70oKklnwAeamQO7YM49DYuakR2DtMbIaw+vdgrnfSrNcROs0QDu4VGPZo3E1bQt0cr6bw==
X-Received: by 2002:a17:902:8a8e:b0:16c:66bf:1734 with SMTP id p14-20020a1709028a8e00b0016c66bf1734mr45529537plo.161.1658430077506;
        Thu, 21 Jul 2022 12:01:17 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id 5-20020a621705000000b00525203c2847sm2115254pfx.128.2022.07.21.12.01.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 12:01:16 -0700 (PDT)
Message-ID: <6b4db767-3fbd-66df-79c4-f0d78b27b9ee@gmail.com>
Date:   Fri, 22 Jul 2022 04:01:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: mld: do not use system_wq in the mld
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20220721120316.17070-1-ap420073@gmail.com>
 <CANn89iJjc+jcyWZS1L+EfSkZYRaeVSmUHAkLKAFDRN4bCOcVyg@mail.gmail.com>
 <ea287ba8-89d6-8175-0ebb-3269328a79b4@gmail.com>
 <CANn89iL=sLeDpPfM8OKbDc7L95p+exPynZNz+tUBUve7eA42Eg@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <CANn89iL=sLeDpPfM8OKbDc7L95p+exPynZNz+tUBUve7eA42Eg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/22 03:34, Eric Dumazet wrote:
 > On Thu, Jul 21, 2022 at 7:53 PM Taehee Yoo <ap420073@gmail.com> wrote:
 >>
 >> Hi Eric,
 >> Thank you so much for your review!
 >>
 >
 > ...
 >
 >> I think your assumption is right.
 >> I tested the below scenario, which occurs the real issue.
 >> THREAD0                            THREAD1
 >> mld_report_work()
 >>                                      spin_lock_bh()
 >>                                      if (!mod_delayed_work()) <-- queued
 >>                                              in6_dev_hold();
 >>                                      spin_unlock_bh()
 >> spin_lock_bh()
 >> schedule_delayed_work() <-- return false, already queued by THREAD1
 >> spin_unlock_bh()
 >> return;
 >> //no in6_dev_put() regardless return value of schedule_delayed_work().
 >>
 >> In order to check, I added printk like below.
 >>           if (++cnt >= MLD_MAX_QUEUE) {
 >>
 >>                   rework = true;
 >>
 >>                   if (!schedule_delayed_work(&idev->mc_report_work, 0))
 >>                           printk("[TEST]%s %u \n", __func__, __LINE__);
 >>                   break;
 >>
 >>
 >> If the TEST log message is printed, work is already queued by other 
logic.
 >> So, it indicates a reference count is leaked.
 >> The result is that I can see log messages only when the reference count
 >> leak occurs.
 >> So, although I tested it only for 1 hour, I'm sure that this bug comes
 >> from missing check a return value of schedule_delayed_work().
 >>
 >> As you said, this changelog is not correct.
 >> system_wq and mld_wq are not related to this issue.
 >>
 >> I would like to send a v2 patch after some more tests.
 >> The v2 patch will change the commit message.
 >
 > Can you describe what kind of tests you are running ?
 > Was it a syzbot report ?

I found this bug while testing another syzbot report.
(https://syzkaller.appspot.com/bug?id=ed41eaa4367b421d37aab5dee25e3f4c91ceae93)
And I can't find the same case in the syzbot reports list.

I just use some command lines and many kernel debug options such as 
kmemleak, kasan, lockdep, and others.

a=ns-$RANDOM
b=ns-$RANDOM
ip netns add $a
ip netns add $b
echo 'file net/ipv6/addrconf.c +p' > 
/sys/kernel/debug/dynamic_debug/control
echo 'file net/ipv6/addrconf_core.c +p' > 
/sys/kernel/debug/dynamic_debug/control
echo 'file net/ipv6/mcast.c +p' > 
/sys/kernel/debug/dynamic_debug/control
ip netns exec $a sysctl net.ipv6.mld_max_msf=8024 -w 

ip netns exec $b sysctl net.ipv6.mld_max_msf=8024 -w 

ip netns exec $a ip link add br0 type bridge mcast_querier 1 
mcast_query_interval 100 mcast_mld_version 1
ip netns exec $b ip link add br1 type bridge mcast_querier 1 
mcast_query_interval 100 mcast_mld_version 1
ip netns exec $a ip link set br0 up 

ip netns exec $b ip link set br1 up 


for i in {0..5}
do
         ip netns exec $a ip link add vetha$i type veth peer name vethb$i
         ip netns exec $a ip link set vethb$i netns $b

         ip netns exec $a ip link set vetha$i master br0
         ip netns exec $a ip link set vetha$i up

         ip netns exec $b ip link set vethb$i master br1
         ip netns exec $b ip link set vethb$i up
done

sleep 10
ip netns del $a
ip netns del $b

This script is not a real use case.
It just generates *looping* packets and they contain many mld packets 
due to the bridge query option.
I think a packet generator would be more useful to reproduce this bug.
