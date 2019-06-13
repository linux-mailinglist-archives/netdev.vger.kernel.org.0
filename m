Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8D543BAC
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbfFMPah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:30:37 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36839 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728699AbfFMLLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 07:11:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id u8so9681127wmm.1
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 04:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l5O3ZbHPTNATOyk0AZKZTtGFgjZMaMFhSxd61K+M44k=;
        b=uvITb8gp4TnZyF50y9+SLt+YD0uOwh8Bbiv/qgv5/5ndE3w1cyJmH8WxkjbFruvcIT
         clDfUTzyKPlNruYhDJ1qpB7lZliFHZXWlL4p1OMRoa9CllDOF+9Z7HOaMGKwCg967doP
         NRjfTMguL2iXkGkeypo0X15OjnrBJLjCGTPHLox0TWJWGvlriEXtptMp4fSM9h+QHMO6
         VQN54CjaEc7hLF0vYBdZx13nAoOKnbL+XSUeBpJmgCeIey09P/3LnT239hfAGHN1KxZM
         +FfSRwYj6JmfBo1wmBEIv/ekRNj7Gq53qZFHEQatzldV7nDouKQb2H5UAqnfTjGtr71/
         j7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l5O3ZbHPTNATOyk0AZKZTtGFgjZMaMFhSxd61K+M44k=;
        b=tUvCmV94MD7CLsyupu0hHW0X2kPUbrScHNtqwCAmIaFIDKEA5Z15h8YCE524hdZFco
         RjVHTm4OI4lFiRkdCYLYQ9Wo7gnH8N8EPq0qg10AMgcPC0eB4UDegO6z7KIws9iab2pi
         KIXbetc+DkvpcVZ+xCKU3ctB+leYdnBv/wJa8qePmmbHuAiHuIipCXrQ/QZrW5AMvTf5
         wV9oMhS5DNXeA4U/crHC+n42ReFaeTDijL5Wb2yliJrOJVgRj+PQyY8NaY6em5Ngn2xp
         6jcefNeEUd24fkeX2NfZP6D7rWtTebPuXGUuYW3XsXhliCDooLCzzyxQzH5nSCvWNAmR
         gXnQ==
X-Gm-Message-State: APjAAAU3Co1fS7TMY2EDCQDqY3n4YOFoadG22pOH/jJluFheYfWGeBiN
        mTgxEFbc8OHNlmxYR+FIHmjQ2Q==
X-Google-Smtp-Source: APXvYqwomXDhN384n2mFSwBc6taHEjXveebeitg14+IjhV52eOyV8Y59IUR1av7MluGQ6N+aseLZNA==
X-Received: by 2002:a1c:a002:: with SMTP id j2mr3261879wme.131.1560424297368;
        Thu, 13 Jun 2019 04:11:37 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g8sm1423265wme.20.2019.06.13.04.11.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 04:11:36 -0700 (PDT)
Date:   Thu, 13 Jun 2019 13:11:35 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>, mlxsw <mlxsw@mellanox.com>,
        Alex Kushnarov <alexanderk@mellanox.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: tc tp creation performance degratation since kernel 5.1
Message-ID: <20190613111135.GA2201@nanopsycho.orion>
References: <20190612120341.GA2207@nanopsycho>
 <20190613081152.GC2254@nanopsycho.orion>
 <vbfblz123vt.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vbfblz123vt.fsf@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 13, 2019 at 12:09:32PM CEST, vladbu@mellanox.com wrote:
>On Thu 13 Jun 2019 at 11:11, Jiri Pirko <jiri@resnulli.us> wrote:
>> I made a mistake during measurements, sorry about that.
>>
>> This is the correct script:
>> -----------------------------------------------------------------------
>> #!/bin/bash
>>
>> dev=testdummy
>> ip link add name $dev type dummy
>> ip link set dev $dev up
>> tc qdisc add dev $dev ingress
>>
>> tmp_file_name=$(date +"/tmp/tc_batch.%s.%N.tmp")
>> pref_id=1
>>
>> while [ $pref_id -lt 20000 ]
>> do
>>         echo "filter add dev $dev ingress proto ip pref $pref_id flower action drop" >> $tmp_file_name
>>         #echo "filter add dev $dev ingress proto ip pref $pref_id matchall action drop" >> $tmp_file_name
>>         ((pref_id++))
>> done
>>
>> start=$(date +"%s")
>> tc -b $tmp_file_name
>> stop=$(date +"%s")
>> echo "Insertion duration: $(($stop - $start)) sec"
>> rm -f $tmp_file_name
>>
>> ip link del dev $dev
>> -----------------------------------------------------------------------
>>
>> Note the commented out matchall. I don't see the regression with
>> matchall. However, I see that with flower:
>> kernel 5.1
>> Insertion duration: 4 sec
>> kernel 5.2
>> Insertion duration: 163 sec
>>
>> I don't see any significant difference in perf:
>> kernel 5.1
>>     77.24%  tc               [kernel.vmlinux]    [k] tcf_chain_tp_find
>>      1.67%  tc               [kernel.vmlinux]    [k] mutex_spin_on_owner
>>      1.44%  tc               [kernel.vmlinux]    [k] _raw_spin_unlock_irqrestore
>>      0.93%  tc               [kernel.vmlinux]    [k] idr_get_free
>>      0.79%  tc_pref_scale_o  [kernel.vmlinux]    [k] do_syscall_64
>>      0.69%  tc               [kernel.vmlinux]    [k] finish_task_switch
>>      0.53%  tc               libc-2.28.so        [.] __memset_sse2_unaligned_erms
>>      0.49%  tc               [kernel.vmlinux]    [k] __memset
>>      0.36%  tc_pref_scale_o  libc-2.28.so        [.] malloc
>>      0.30%  tc_pref_scale_o  libc-2.28.so        [.] _int_free
>>      0.24%  tc               [kernel.vmlinux]    [k] __memcpy
>>      0.23%  tc               [cls_flower]        [k] fl_change
>>      0.23%  tc               [kernel.vmlinux]    [k] __nla_validate_parse
>>      0.22%  tc               [kernel.vmlinux]    [k] __slab_alloc
>>
>>
>>     75.57%  tc               [kernel.kallsyms]  [k] tcf_chain_tp_find
>>      2.70%  tc               [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
>>      1.13%  tc_pref_scale_o  [kernel.kallsyms]  [k] do_syscall_64
>>      0.87%  tc               libc-2.28.so       [.] __memset_sse2_unaligned_erms
>>      0.86%  ip               [kernel.kallsyms]  [k] finish_task_switch
>>      0.67%  tc               [kernel.kallsyms]  [k] memset
>>      0.63%  tc               [kernel.kallsyms]  [k] mutex_spin_on_owner
>>      0.52%  tc_pref_scale_o  libc-2.28.so       [.] malloc
>>      0.48%  tc               [kernel.kallsyms]  [k] idr_get_free
>>      0.46%  tc               [kernel.kallsyms]  [k] fl_change
>>      0.42%  tc_pref_scale_o  libc-2.28.so       [.] _int_free
>>      0.35%  tc_pref_scale_o  libc-2.28.so       [.] __GI___strlen_sse2
>>      0.35%  tc_pref_scale_o  libc-2.28.so       [.] __mbrtowc
>>      0.34%  tc_pref_scale_o  libc-2.28.so       [.] __fcntl64_nocancel_adjusted
>>
>> Any ideas?
>
>Thanks for providing reproduction script!
>
>I've investigate the problem and found the root cause. First of all I
>noticed that CPU utilization during problematic tc run is quite low
>(<10%), so I decided to investigate why tc sleeps so much. I've used bcc
>and obtained following off-CPU trace (uninteresting traces are omitted
>for brevity):
>
>~$ sudo /usr/share/bcc/tools/offcputime -K -p `pgrep -nx tc`
>Tracing off-CPU time (us) of PID 2069 by kernel stack... Hit Ctrl-C to end.
>...
>    finish_task_switch
>    __sched_text_start
>    schedule
>    schedule_timeout
>    wait_for_completion
>    __wait_rcu_gp
>    synchronize_rcu
>    fl_change
>    tc_new_tfilter
>    rtnetlink_rcv_msg
>    netlink_rcv_skb
>    netlink_unicast
>    netlink_sendmsg
>    sock_sendmsg
>    ___sys_sendmsg
>    __sys_sendmsg
>    do_syscall_64
>    entry_SYSCALL_64_after_hwframe
>    -                tc (2069)
>        142284953
>
>As you can see 142 seconds are spent sleeping in synchronize_rcu(). The
>code is in fl_create_new_mask() function:
>
>	err = rhashtable_replace_fast(&head->ht, &mask->ht_node,
>				      &newmask->ht_node, mask_ht_params);
>	if (err)
>		goto errout_destroy;
>
>	/* Wait until any potential concurrent users of mask are finished */
>	synchronize_rcu();
>
>The justification for this is described in comment in
>fl_check_assign_mask() (user of fl_create_new_mask()):
>
>	/* Insert mask as temporary node to prevent concurrent creation of mask
>	 * with same key. Any concurrent lookups with same key will return
>	 * -EAGAIN because mask's refcnt is zero. It is safe to insert
>	 * stack-allocated 'mask' to masks hash table because we call
>	 * synchronize_rcu() before returning from this function (either in case
>	 * of error or after replacing it with heap-allocated mask in
>	 * fl_create_new_mask()).
>	 */
>	fnew->mask = rhashtable_lookup_get_insert_fast(&head->ht,
>						       &mask->ht_node,
>						       mask_ht_params);
>
>The offending commit is part of my series that implements unlocked
>flower: 195c234d15c9 ("net: sched: flower: handle concurrent mask
>insertion")
>
>The justification presented in it is no longer relevant since Ivan
>Vecera changed mask to be dynamically allocated in commit 2cddd2014782
>("net/sched: cls_flower: allocate mask dynamically in fl_change()").
>With this we can just change fl_change() to deallocate temporary mask
>with rcu grace period and remove offending syncrhonize_rcu() call.
>
>Any other suggestions?

So basically you just change synchronize_rcu() to kfree_rcu(mask),
   correct?
