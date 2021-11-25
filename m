Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC14A45DCAC
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354193AbhKYOwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:52:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58213 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355920AbhKYOuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:50:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637851628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0YfT7b8wVOeig/3+IUDAZI2A/DKcXL2UWIWBuICztQ=;
        b=ej9W3Fbf/IUcF9HbEuPoaqklwj3tyoT4a5DQQfJ+2UwZUs/c+3qa4sklIhVj5s+gA/Nvrf
        fhN0bk1hIe0S8/Z5Z2AkqAdOiPPUTo2EWJFC/yl/IOFf60vMMKRjUZw6MOxjrpSQZ0CGW6
        BwXdiuk7fA6WQGi7h++Sb9A/2d1dKZg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-ZmUQSIsTOeq-leszuTPdwQ-1; Thu, 25 Nov 2021 09:47:07 -0500
X-MC-Unique: ZmUQSIsTOeq-leszuTPdwQ-1
Received: by mail-wm1-f69.google.com with SMTP id i131-20020a1c3b89000000b00337f92384e0so5089391wma.5
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:47:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=r0YfT7b8wVOeig/3+IUDAZI2A/DKcXL2UWIWBuICztQ=;
        b=4EA8oJhHoY9bagUeLqJCYe9kqQB1FAhcqLAj7bgGCXdIFdA5qBQFE7QvRrJBfCxDGF
         8LyQjtw4P1Yyk2OozRJlUz9W2nCFD99gyFYy1IvYV0Nc7AyE9BkdYN1jgF8W7CBQ9fUr
         f8ppT1mJxs5VGNJIt7DrUdgbbcbNQjarVPtYVjjg0YAGeR43SaVz4Gq7vSqbZqm/QZuU
         acz/VHRhiy5xjtNTZF81cCWGEHmzPBHaAxLQiz8HB4hfGzozwz09LNnm11+55FKTABwQ
         Ejjtj4XKWk/LRjee/ETjDZo+AyHKemQVjLi9BgA/BZ1ykZiuHyB/GdOfqBzyRtXdXPkz
         Q7Ug==
X-Gm-Message-State: AOAM532isy7CbtP8bwqjXIAkFLIh2cgFbTbqX4bFESr8Mc5TEzEfgzx/
        uMrvb2gurkCflMQ1/vIXTlLvrs0JE10EXiCjR5yaRWLVPpdadHgHTpM9UwMMAnPrl/zLxcZ/1FD
        Ke/xq1T0xt7SRADme
X-Received: by 2002:a7b:c763:: with SMTP id x3mr7962972wmk.31.1637851626023;
        Thu, 25 Nov 2021 06:47:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwWw5wfsPq7LRSM9hRLSA4XFFZZK0hqXGaWJlTIAPX0085VuaF1bzZGOZEdl44rHrNuL6HnNg==
X-Received: by 2002:a7b:c763:: with SMTP id x3mr7962942wmk.31.1637851625817;
        Thu, 25 Nov 2021 06:47:05 -0800 (PST)
Received: from [192.168.3.132] (p5b0c679e.dip0.t-ipconnect.de. [91.12.103.158])
        by smtp.gmail.com with ESMTPSA id be3sm9930088wmb.1.2021.11.25.06.47.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 06:47:05 -0800 (PST)
Message-ID: <68615778-08cc-6216-1def-764dff112a72@redhat.com>
Date:   Thu, 25 Nov 2021 15:47:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] kthread: dynamically allocate memory to store
 kthread's full name
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>
References: <20211120112850.46047-1-laoar.shao@gmail.com>
 <435fab0b-d345-3698-79af-ff858181666a@redhat.com> <YZ+hsx52TyDuHvE1@alley>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <YZ+hsx52TyDuHvE1@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.11.21 15:46, Petr Mladek wrote:
> On Thu 2021-11-25 10:36:49, David Hildenbrand wrote:
>> On 20.11.21 12:28, Yafang Shao wrote:
>>> When I was implementing a new per-cpu kthread cfs_migration, I found the
>>> comm of it "cfs_migration/%u" is truncated due to the limitation of
>>> TASK_COMM_LEN. For example, the comm of the percpu thread on CPU10~19 are
>>> all with the same name "cfs_migration/1", which will confuse the user. This
>>> issue is not critical, because we can get the corresponding CPU from the
>>> task's Cpus_allowed. But for kthreads correspoinding to other hardware
>>> devices, it is not easy to get the detailed device info from task comm,
>>> for example,
>>>
>>>     jbd2/nvme0n1p2-
>>>     xfs-reclaim/sdf
>>>
>>> Currently there are so many truncated kthreads:
>>>
>>>     rcu_tasks_kthre
>>>     rcu_tasks_rude_
>>>     rcu_tasks_trace
>>>     poll_mpt3sas0_s
>>>     ext4-rsv-conver
>>>     xfs-reclaim/sd{a, b, c, ...}
>>>     xfs-blockgc/sd{a, b, c, ...}
>>>     xfs-inodegc/sd{a, b, c, ...}
>>>     audit_send_repl
>>>     ecryptfs-kthrea
>>>     vfio-irqfd-clea
>>>     jbd2/nvme0n1p2-
>>>     ...
>>>
>>> We can shorten these names to work around this problem, but it may be
>>> not applied to all of the truncated kthreads. Take 'jbd2/nvme0n1p2-' for
>>> example, it is a nice name, and it is not a good idea to shorten it.
>>>
>>> One possible way to fix this issue is extending the task comm size, but
>>> as task->comm is used in lots of places, that may cause some potential
>>> buffer overflows. Another more conservative approach is introducing a new
>>> pointer to store kthread's full name if it is truncated, which won't
>>> introduce too much overhead as it is in the non-critical path. Finally we
>>> make a dicision to use the second approach. See also the discussions in
>>> this thread:
>>> https://lore.kernel.org/lkml/20211101060419.4682-1-laoar.shao@gmail.com/
>>>
>>> After this change, the full name of these truncated kthreads will be
>>> displayed via /proc/[pid]/comm:
>>>
>>>     rcu_tasks_kthread
>>>     rcu_tasks_rude_kthread
>>>     rcu_tasks_trace_kthread
>>>     poll_mpt3sas0_statu
>>>     ext4-rsv-conversion
>>>     xfs-reclaim/sdf1
>>>     xfs-blockgc/sdf1
>>>     xfs-inodegc/sdf1
>>>     audit_send_reply
>>>     ecryptfs-kthread
>>>     vfio-irqfd-cleanup
>>>     jbd2/nvme0n1p2-8
>>
>> I do wonder if that could break some user space that assumes these names
>> have maximum length ..
> 
> There is high chance that we will be on the safe side. Workqueue
> kthreads already provided longer names. They are even dynamic
> because the currently handled workqueue name is part of the name,
> see wq_worker_comm().

Great, thanks!


-- 
Thanks,

David / dhildenb

