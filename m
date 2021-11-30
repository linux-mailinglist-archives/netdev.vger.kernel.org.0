Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AAD462FDD
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 10:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240307AbhK3JnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 04:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbhK3JnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 04:43:04 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B921C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 01:39:45 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id q15-20020adfbb8f000000b00191d3d89d09so3424718wrg.3
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 01:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kELG4qNiHubyqw+GHawv5id0iTgcwVQeZoU1KiAX7cg=;
        b=cYKsBgum6CbGbNMXiRqSOGmUnmKPlZzir9ODQnP7ZSMf3OGZzNIl9ljLw92DPQ5lzE
         EheFwtJyJ1EEWc8oLh7FIEf1S0y+gb0/dgUTmH8NMBQytFUUpPKbE5Gz4irO68YSFdcb
         d+NWwWTEDQWpi1Qcc3tpOXUn2RaeBK0rfBUIjvUOM/aoqFwRSy92bzleyWkrfEjK1glN
         OaGc9hb/H62u5Y9go4YbWbiIH8SXjbKVMPoPC1cyW49JINpABcwpgNZ1o6YPFpr03hZz
         iehENzMCefRcitFBvG3oh2ZmQZpOt6KepGx00cFYhfa3eNh0JY4GhbamutPZ4fXGpehc
         8y7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kELG4qNiHubyqw+GHawv5id0iTgcwVQeZoU1KiAX7cg=;
        b=y9SrwYtRMEBXH4WUi4W9N+RI04n79wJzDJjgVRpYZ0Ozorr7K4ialFJTIvrMIqWqfF
         tx3zo+/h/msiN7P0dwYv5rbSLMUQURnMZX7yop+05+SE9XiIzgtr05lTaHR3EHNn3/ri
         YPhtynERt2CujEHc9UPVYChVhxf0uDHTZpT565cRefdkbH8Q0vvR1U5Y+fPEQAIJ8vQe
         eYqEWR1GagjxpOHzPpqvmh3sVdO9L35CGwGsnM+RZ3qh9Ml8+s93yeuN6elOkUPbgaxh
         dhxQW1AXXhqkJqLtXnibexdUL0sTXAbtBvbogDB0eniL71qToKCvjhC4AkfLnOAi9NEF
         kI8Q==
X-Gm-Message-State: AOAM531cikEnc/zgeKoof/lC/XiIMSYbW0sulb3MBIobakVI5cCZWkdd
        XZethkqMkeFgWhv+rePZREA6t0tC5zzA
X-Google-Smtp-Source: ABdhPJzP07EGlbfgMOkGabHIaXfvMk3ZPzmr0ipqOJR5t06BpGMFsKoCThWTsi90O/5cJjKGLojv34CNVgoX
X-Received: from dvyukov-desk.muc.corp.google.com ([2a00:79e0:15:13:1e84:81dc:2c2c:50e2])
 (user=dvyukov job=sendgmr) by 2002:a5d:64eb:: with SMTP id
 g11mr39838154wri.438.1638265183653; Tue, 30 Nov 2021 01:39:43 -0800 (PST)
Date:   Tue, 30 Nov 2021 10:39:39 +0100
In-Reply-To: <20211117192031.3906502-2-eric.dumazet@gmail.com>
Message-Id: <20211130093939.4092417-1-dvyukov@google.com>
Mime-Version: 1.0
References: <20211117192031.3906502-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: Re: [RFC -next 1/2] lib: add reference counting infrastructure
From:   Dmitry Vyukov <dvyukov@google.com>
To:     eric.dumazet@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Nice! Especially ref_tracker_dir_print() in netdev_wait_allrefs().

> +	*trackerp = tracker = kzalloc(sizeof(*tracker), gfp);

This may benefit from __GFP_NOFAIL. syzkaller will use fault injection to fail
this. And I think it will do more bad than good.

We could also note this condition in dir, along the lines of:

	if (!tracker) {
		dir->failed = true;

To print on any errors and to check in ref_tracker_free():

int ref_tracker_free(struct ref_tracker_dir *dir,
		     struct ref_tracker **trackerp)
{
...
	if (!tracker) {
		WARN_ON(!dir->failed);
		return -EEXIST;
	}

This would be a bug, right?
Or:

	*trackerp = tracker = kzalloc(sizeof(*tracker), gfp);
	if (!tracker) {
		*tracker = TRACKERP_ALLOC_FAILED;
		 return -ENOMEM;
	}

and then check TRACKERP_ALLOC_FAILED in ref_tracker_free().
dev_hold_track() ignores the return value, so it would be useful to note
this condition.

> +	if (tracker->dead) {
> +		pr_err("reference already released.\n");

This and other custom prints won't be detected as bugs by syzkaller and other
testing systems, they detect the standard BUG/WARNING. Please use these.

ref_tracker_free() uses unnecesary long critical sections. I understand this
is debugging code, but frequently debugging code is so pessimistic that nobody
use it. If we enable this on syzbot, it will also slowdown all fuzzing.
I think with just a small code shuffling critical sections can be
significantly reduced:

	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
	tracker->free_stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);

	spin_lock_irqsave(&dir->lock, flags);
	if (tracker->dead)
		...
	tracker->dead = true;

	list_move_tail(&tracker->head, &dir->quarantine);
	if (!dir->quarantine_avail) {
		tracker = list_first_entry(&dir->quarantine, struct ref_tracker, head);
		list_del(&tracker->head);
	} else {
		dir->quarantine_avail--;
		tracker = NULL;
	}
	spin_unlock_irqrestore(&dir->lock, flags);

	kfree(tracker);

> +#define REF_TRACKER_STACK_ENTRIES 16
> +	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
> +	tracker->alloc_stack_handle = stack_depot_save(entries, nr_entries, gfp);

The saved stacks can be longer because they are de-duped. But stacks insered
into stack_depot need to be trimmed with filter_irq_stacks(). It seems that
almost all current users got it wrong. We are considering moving
filter_irq_stacks() into stack_depot_save(), but it's not done yet.
