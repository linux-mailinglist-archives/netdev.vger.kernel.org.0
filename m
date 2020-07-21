Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF6F228531
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgGUQUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbgGUQUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 12:20:15 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8A8C061794;
        Tue, 21 Jul 2020 09:20:14 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id o4so12012040lfi.7;
        Tue, 21 Jul 2020 09:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Groro3SyYJWphwceTkpNDYDrIfmBoLsMEqqiSFl6lVU=;
        b=paVwZZrESP/VwnUw67pGD0aF7K2NqOxjCGIe6FZvasfd6FTb2J2XEc1NEgGIBdSL0p
         FnckrJY3O/5lscjH+s3g8IrlzM9MiMo/kL8CuZgdBFpCTSLPmF9LYgkDEA1+evUHw6U5
         YjdqDQ1xpDAapf6UfWYP8pmjvniRgerQj7DKxl8nFGtYCu+CzX55iMwGi0dWmnySMKZ6
         czWiT78D8F1Xh2Bac4wjwqwEFqxyZZULs9x7GycAqoSAbCarNdbZHlIILiMdeCF471+G
         X5EO2m3CKLKL5K6hKLu9zuvhwbdwlcJ5stgwoFWBJVJiGcqW8k03FFxoMuQ1vRkNpma5
         DXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Groro3SyYJWphwceTkpNDYDrIfmBoLsMEqqiSFl6lVU=;
        b=eGHW4xzD9ckdhSgHkX+9N34VB3SvEF8SBmfrSsRiQtdZ4v1HF6+NnN1j1c1O8Fei8j
         U7FOveODKl/006mUTlRONjo1yciPDW/qI6/KJ1erFoPDw1nhnke3t028duTR+k8D9Pm4
         vwA0DK0hQg3RyTP3o5sTk4cxLfh3lXMPLWPotn2WPN15cNlhqp/jXUnfgKQ/E54gCYaE
         cVGhgUWkgXaEZLrEgN9IcUhEC8b0OWzBR/o63fe7e6Pvy7Qf1wQYEb0mi1wO2QmcrCgN
         adrds9g4RN5axnRZzNhtP8+iZqgElpaGO1MS1EMjgSL5jVkRkzffKX5r52PAmph+h2sP
         gTdg==
X-Gm-Message-State: AOAM533ZFjZuOGlbzvv6VVLFLinLVQ+VEk3T/DH+0Zzk5JtOo35Awulr
        AiEQ7qx7KWiLyaRuXwBwASuKZa9ZsXs1ytZOcBs=
X-Google-Smtp-Source: ABdhPJyHb2JLW+ucwR3k91mAjb0EzCI+hZk+2d8O0FCv8vZTJgInB7YdK5zllSk2E9C0igvRMz5oQ/poDvXl5QrHIyg=
X-Received: by 2002:a19:815:: with SMTP id 21mr13598099lfi.119.1595348413371;
 Tue, 21 Jul 2020 09:20:13 -0700 (PDT)
MIME-Version: 1.0
References: <e54f2aabf959f298939e5507b09c48f8c2e380be.1595170625.git.lorenzo@kernel.org>
 <87zh7tw4dh.fsf@cloudflare.com>
In-Reply-To: <87zh7tw4dh.fsf@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Jul 2020 09:20:02 -0700
Message-ID: <CAADnVQJzu1KbeCTCwn0dYe_yKHK=Fx+DV58eqJKL8_xOb7popw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: cpumap: fix possible rcpu kthread hung
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        lorenzo.bianconi@redhat.com, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 3:26 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Sun, Jul 19, 2020 at 05:52 PM CEST, Lorenzo Bianconi wrote:
> > Fix the following cpumap kthread hung. The issue is currently occurring
> > when __cpu_map_load_bpf_program fails (e.g if the bpf prog has not
> > BPF_XDP_CPUMAP as expected_attach_type)
> >
> > $./test_progs -n 101
> > 101/1 cpumap_with_progs:OK
> > 101 xdp_cpumap_attach:OK
> > Summary: 1/1 PASSED, 0 SKIPPED, 0 FAILED
> > [  369.996478] INFO: task cpumap/0/map:7:205 blocked for more than 122 seconds.
> > [  369.998463]       Not tainted 5.8.0-rc4-01472-ge57892f50a07 #212
> > [  370.000102] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  370.001918] cpumap/0/map:7  D    0   205      2 0x00004000
> > [  370.003228] Call Trace:
> > [  370.003930]  __schedule+0x5c7/0xf50
> > [  370.004901]  ? io_schedule_timeout+0xb0/0xb0
> > [  370.005934]  ? static_obj+0x31/0x80
> > [  370.006788]  ? mark_held_locks+0x24/0x90
> > [  370.007752]  ? cpu_map_bpf_prog_run_xdp+0x6c0/0x6c0
> > [  370.008930]  schedule+0x6f/0x160
> > [  370.009728]  schedule_preempt_disabled+0x14/0x20
> > [  370.010829]  kthread+0x17b/0x240
> > [  370.011433]  ? kthread_create_worker_on_cpu+0xd0/0xd0
> > [  370.011944]  ret_from_fork+0x1f/0x30
> > [  370.012348]
> >                Showing all locks held in the system:
> > [  370.013025] 1 lock held by khungtaskd/33:
> > [  370.013432]  #0: ffffffff82b24720 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x28/0x1c3
> >
> > [  370.014461] =============================================
> >
> > Fixes: 9216477449f3 ("bpf: cpumap: Add the possibility to attach an eBPF program to cpumap")
> > Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
>
> Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

Applied. Thanks
