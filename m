Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B722A031
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732099AbfEXVD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:03:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41891 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfEXVD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 17:03:27 -0400
Received: by mail-pf1-f194.google.com with SMTP id q17so1155358pfq.8;
        Fri, 24 May 2019 14:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=veCSDwIU7Xf8XfmuNtrrDmEH89bB2GKhK9A6gPb0QBQ=;
        b=Xvnk4WTmydtuFb0RyGDZKhWc3ExxFqVv7ezG/mmUmkVCCtF/hUKBOl8UVVEHqoTZjr
         TW5Af5FcpTcmy5+sW/IQm8EyyF1mD9A2B3bA4Nuv/k8XRCA9M+7pu9wTJOLeLsFOV2RR
         N4Yu077B5V8hQVtKNnDA3B5NFq+KTAl6JfPBEdVsn/1EurfX6X511EiATEcQzceWWk1g
         n0JDHHrlNWnPzKnPj/sjphXkrRosoIMqqvg0bfJQW0WTxwwJrcONCdQzmkOWQNqUJkW6
         sTiMfuXkgYHbbxX59nBcLJRCoY4Kfor6nrwx8VJNTSkEwX/NNOV3OCkca3Q6PYR/hpgL
         RNzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=veCSDwIU7Xf8XfmuNtrrDmEH89bB2GKhK9A6gPb0QBQ=;
        b=TYE4sSNKC1bYpvCCwaqsE8rqNuowMSi5w1Ec5lfIkmOwL9BCdoga7f1iVMs/M2eaKm
         g61Jt0xDGxQVuPCCxnNZ92oQGQaJ+wjLt4ZzbiL6VLP9jAs937aVkOsvLKeW8e7SYrqV
         6hHH9Afbh0V5iQqMsbCoUvSVcte5l5s58xpN3wRBdozpdj2dkiFOJxLoLiMtRRhryfa0
         dBEGBo9rVTSYnxkimmdqfQLdUA28HOV1Wp7FwDDUcrU3YhuEfTZY0sZp5JcdZQq1nhQn
         51uDpcGRDpNAaEDTCMHVHHW40kDtf4Y+GXk/YRFC6tc57kHJ/dB9m0deYpkpJRTA6i4m
         oByw==
X-Gm-Message-State: APjAAAVYqdcQ/U3NgWarmxfbBEuO3l7nPpR+2n255UZp9DLIw0NSIO6F
        T6iw9b6MoQJpQ7NBqAvXdzs=
X-Google-Smtp-Source: APXvYqw42MFYkbCooFVMUAGBY57ttz0aR8EW2m0ewulYbSLfJYwi9uLvW1I2bXMi/7GygcEDbx3qWA==
X-Received: by 2002:a17:90a:8e86:: with SMTP id f6mr11922584pjo.66.1558731806109;
        Fri, 24 May 2019 14:03:26 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::93e9])
        by smtp.gmail.com with ESMTPSA id x23sm3369575pfn.160.2019.05.24.14.03.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 14:03:25 -0700 (PDT)
Date:   Fri, 24 May 2019 14:03:23 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roman Gushchin <guro@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, kernel-team@fb.com,
        cgroups@vger.kernel.org, Stanislav Fomichev <sdf@fomichev.me>,
        Yonghong Song <yhs@fb.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 bpf-next 0/4] cgroup bpf auto-detachment
Message-ID: <20190524210321.tzpt7ilaasaagtou@ast-mbp.dhcp.thefacebook.com>
References: <20190523194532.2376233-1-guro@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523194532.2376233-1-guro@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 12:45:28PM -0700, Roman Gushchin wrote:
> This patchset implements a cgroup bpf auto-detachment functionality:
> bpf programs are detached as soon as possible after removal of the
> cgroup, without waiting for the release of all associated resources.

The idea looks great, but doesn't quite work:

$ ./test_cgroup_attach
#override:PASS
[   66.475219] BUG: sleeping function called from invalid context at ../include/linux/percpu-rwsem.h:34
[   66.476095] in_atomic(): 1, irqs_disabled(): 0, pid: 21, name: ksoftirqd/2
[   66.476706] CPU: 2 PID: 21 Comm: ksoftirqd/2 Not tainted 5.2.0-rc1-00211-g1861420d0162 #1564
[   66.477595] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
[   66.478360] Call Trace:
[   66.478591]  dump_stack+0x5b/0x8b
[   66.478892]  ___might_sleep+0x22f/0x290
[   66.479230]  cpus_read_lock+0x18/0x50
[   66.479550]  static_key_slow_dec+0x41/0x70
[   66.479914]  cgroup_bpf_release+0x1a6/0x400
[   66.480285]  percpu_ref_switch_to_atomic_rcu+0x203/0x330
[   66.480754]  rcu_core+0x475/0xcc0
[   66.481047]  ? switch_mm_irqs_off+0x684/0xa40
[   66.481422]  ? rcu_note_context_switch+0x260/0x260
[   66.481842]  __do_softirq+0x1cf/0x5ff
[   66.482174]  ? takeover_tasklets+0x5f0/0x5f0
[   66.482542]  ? smpboot_thread_fn+0xab/0x780
[   66.482911]  run_ksoftirqd+0x1a/0x40
[   66.483225]  smpboot_thread_fn+0x3ad/0x780
[   66.483583]  ? sort_range+0x20/0x20
[   66.483894]  ? __kthread_parkme+0xb0/0x190
[   66.484253]  ? sort_range+0x20/0x20
[   66.484562]  ? sort_range+0x20/0x20
[   66.484878]  kthread+0x2e2/0x3e0
[   66.485166]  ? kthread_create_worker_on_cpu+0xb0/0xb0
[   66.485620]  ret_from_fork+0x1f/0x30

Same test runs fine before the patches.

