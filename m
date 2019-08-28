Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A90A0BF7
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfH1VDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:03:42 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33404 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfH1VDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:03:42 -0400
Received: by mail-qt1-f193.google.com with SMTP id v38so1253358qtb.0;
        Wed, 28 Aug 2019 14:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=F+lDBcIF18NfqJCdUOLk/eWaW/BajVdL756ooh8T8qM=;
        b=EjRBuz2NhKCYMhSeTP68unwPaTc7RzGySBwWEW/mK+o1ps42Frcf1RtsNl+fnS0bPb
         dlD+lJJcWrSNeOtXKZ1DiikVXvze60PhMVy+F0Nwt8Jqnpj68UVTEGqWtUn019DvGyGV
         4aBowlwjrv7mmqS8prPLuASFXnsJpPbqpQ5cGbUcGQTPsDHJP8VcELehcw4SJZCbP7+h
         A/Wd/EcqM7BmTFejiQf/pN+Bxsov+SkmqpShTnoLEbkZ4J1//HpV7DFGPFsgp7zdtTl5
         lyLyAFW50PPF+glfCUZi1gFQ7jyMIFHckhu0gR18YaaJucYe1lsoOXABF+5rxhxAjuhH
         DPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=F+lDBcIF18NfqJCdUOLk/eWaW/BajVdL756ooh8T8qM=;
        b=s2ikLALUzWw+39vf5Dqi48KWJboC7K6EENUlUESvqHDlUyp08BFZvBHXNUVD7aZW1N
         KaBU2qFhFuYciISzMvs6Xnkd+kmCB7dAfYmHil5EfkFeB1j6SE0SqJ/CUGKhsKjIDY4j
         UhtuS2M+1TRFQVCORvLQtmqUQz31fN8LNEP6qAO7s2Y5yS2q/dB9D1tBDx2puINKsyFg
         W9ezNAxaDnWNzStD0Q2JYSwNYFvKmnEm1HzIYFuiGK1o5RFaHqnSDVH0pizgIjQWQCpn
         X+d5OOQSsxUJDy9+yWIlOjk0QUDDHxcU47iDlB89CdZc2IFi5L3TXNM3KOFGQn0eXPsF
         QS6A==
X-Gm-Message-State: APjAAAW+WxbPLyTCZ9dWnmZcFLeUfV4qh92Pv8Np7YtDdp74ELop+HgU
        DZ0cj76m+Jh3eUx36hFsEq3RELux5Sg=
X-Google-Smtp-Source: APXvYqx3fuf35YGtqMc5FeuEehXepZI/wgpMlnLOfP7ISrODi4cTIpjQq5A6z8mLQdhQutJCLyZaFQ==
X-Received: by 2002:a05:6214:10e1:: with SMTP id q1mr4398531qvt.148.1567026220510;
        Wed, 28 Aug 2019 14:03:40 -0700 (PDT)
Received: from ebpf-metal ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id o9sm178846qtr.71.2019.08.28.14.03.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Aug 2019 14:03:39 -0700 (PDT)
Date:   Wed, 28 Aug 2019 17:03:35 -0400
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next V9 1/3] bpf: new helper to obtain namespace data
 from current task
Message-ID: <20190828210333.itwtyqa5w5egnrwm@ebpf-metal>
References: <20190813184747.12225-1-cneirabustos@gmail.com>
 <20190813184747.12225-2-cneirabustos@gmail.com>
 <13b7f81f-83b6-07c9-4864-b49749cbf7d9@fb.com>
 <20190814005604.yeqb45uv2fc3anab@dev00>
 <9a2cacad-b79f-5d39-6d62-bb48cbaaac07@fb.com>
 <CACiB22jyN9=0ATWWE+x=BoWD6u+8KO+MvBfsFQmcNfkmANb2_w@mail.gmail.com>
 <20190828203951.qo4kaloahcnvp7nw@ebpf-metal>
 <4faeb577-387a-7186-e060-f0ca76395823@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4faeb577-387a-7186-e060-f0ca76395823@fb.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, I'll work on the net/netif_receive_skb selftest using this helper.
I hope I could complete this work this week.

Bests.

On Wed, Aug 28, 2019 at 08:53:25PM +0000, Yonghong Song wrote:
> 
> 
> On 8/28/19 1:39 PM, Carlos Antonio Neira Bustos wrote:
> > Yonghong,
> > 
> > Thanks for the pointer, I fixed this bug, but I found another one that's triggered
> > now the test program I included in  tools/testing/selftests/bpf/test_pidns.
> > It's seemed that fname was not correctly setup when passing it to filename_lookup.
> > This is fixed now and I'm doing some more testing.
> > I think I'll remove the tests on samples/bpf as they are mostly end on -EPERM as
> > the fix intended.
> > Is ok to remove them and just focus to finish the self tests code?.
> 
> Yes, the samples/bpf test case can be removed.
> Could you create a selftest with tracpoint net/netif_receive_skb, which 
> also uses the proposed helper? net/netif_receive_skb will happen in
> interrupt context and it should catch the issue as well if 
> filename_lookup still get called in interrupt context.
> 
> > 
> > Bests
> > 
> > On Wed, Aug 14, 2019 at 01:25:06AM -0400, carlos antonio neira bustos wrote:
> >> Thank you very much!
> >>
> >> Bests
> >>
> >> El mié., 14 de ago. de 2019 00:50, Yonghong Song <yhs@fb.com> escribió:
> >>
> >>>
> >>>
> >>> On 8/13/19 5:56 PM, Carlos Antonio Neira Bustos wrote:
> >>>> On Tue, Aug 13, 2019 at 11:11:14PM +0000, Yonghong Song wrote:
> >>>>>
> >>>>>
> >>>>> On 8/13/19 11:47 AM, Carlos Neira wrote:
> >>>>>> From: Carlos <cneirabustos@gmail.com>
> >>>>>>
> >>>>>> New bpf helper bpf_get_current_pidns_info.
> >>>>>> This helper obtains the active namespace from current and returns
> >>>>>> pid, tgid, device and namespace id as seen from that namespace,
> >>>>>> allowing to instrument a process inside a container.
> >>>>>>
> >>>>>> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> >>>>>> ---
> >>>>>>     fs/internal.h            |  2 --
> >>>>>>     fs/namei.c               |  1 -
> >>>>>>     include/linux/bpf.h      |  1 +
> >>>>>>     include/linux/namei.h    |  4 +++
> >>>>>>     include/uapi/linux/bpf.h | 31 ++++++++++++++++++++++-
> >>>>>>     kernel/bpf/core.c        |  1 +
> >>>>>>     kernel/bpf/helpers.c     | 64
> >>> ++++++++++++++++++++++++++++++++++++++++++++++++
> >>>>>>     kernel/trace/bpf_trace.c |  2 ++
> >>>>>>     8 files changed, 102 insertions(+), 4 deletions(-)
> >>>>>>
> >>> [...]
> >>>>>>
> >>>>>> +BPF_CALL_2(bpf_get_current_pidns_info, struct bpf_pidns_info *,
> >>> pidns_info, u32,
> >>>>>> +    size)
> >>>>>> +{
> >>>>>> +   const char *pidns_path = "/proc/self/ns/pid";
> >>>>>> +   struct pid_namespace *pidns = NULL;
> >>>>>> +   struct filename *tmp = NULL;
> >>>>>> +   struct inode *inode;
> >>>>>> +   struct path kp;
> >>>>>> +   pid_t tgid = 0;
> >>>>>> +   pid_t pid = 0;
> >>>>>> +   int ret;
> >>>>>> +   int len;
> >>>>>
> >>>>
> >>>> Thank you very much for catching this!.
> >>>> Could you share how to replicate this bug?.
> >>>
> >>> The config is attached. just run trace_ns_info and you
> >>> can reproduce the issue.
> >>>
> >>>>
> >>>>> I am running your sample program and get the following kernel bug:
> >>>>>
> >>>>> ...
> >>>>> [   26.414825] BUG: sleeping function called from invalid context at
> >>>>> /data/users/yhs/work/net-next/fs
> >>>>> /dcache.c:843
> >>>>> [   26.416314] in_atomic(): 1, irqs_disabled(): 0, pid: 1911, name: ping
> >>>>> [   26.417189] CPU: 0 PID: 1911 Comm: ping Tainted: G        W
> >>>>> 5.3.0-rc1+ #280
> >>>>> [   26.418182] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> >>>>> BIOS 1.9.3-1.el7.centos 04/01/2
> >>>>> 014
> >>>>> [   26.419393] Call Trace:
> >>>>> [   26.419697]  <IRQ>
> >>>>> [   26.419960]  dump_stack+0x46/0x5b
> >>>>> [   26.420434]  ___might_sleep+0xe4/0x110
> >>>>> [   26.420894]  dput+0x2a/0x200
> >>>>> [   26.421265]  walk_component+0x10c/0x280
> >>>>> [   26.421773]  link_path_walk+0x327/0x560
> >>>>> [   26.422280]  ? proc_ns_dir_readdir+0x1a0/0x1a0
> >>>>> [   26.422848]  ? path_init+0x232/0x330
> >>>>> [   26.423364]  path_lookupat+0x88/0x200
> >>>>> [   26.423808]  ? selinux_parse_skb.constprop.69+0x124/0x430
> >>>>> [   26.424521]  filename_lookup+0xaf/0x190
> >>>>> [   26.425031]  ? simple_attr_release+0x20/0x20
> >>>>> [   26.425560]  bpf_get_current_pidns_info+0xfa/0x190
> >>>>> [   26.426168]  bpf_prog_83627154cefed596+0xe66/0x1000
> >>>>> [   26.426779]  trace_call_bpf+0xb5/0x160
> >>>>> [   26.427317]  ? __netif_receive_skb_core+0x1/0xbb0
> >>>>> [   26.427929]  ? __netif_receive_skb_core+0x1/0xbb0
> >>>>> [   26.428496]  kprobe_perf_func+0x4d/0x280
> >>>>> [   26.428986]  ? tracing_record_taskinfo_skip+0x1a/0x30
> >>>>> [   26.429584]  ? tracing_record_taskinfo+0xe/0x80
> >>>>> [   26.430152]  ? ttwu_do_wakeup.isra.114+0xcf/0xf0
> >>>>> [   26.430737]  ? __netif_receive_skb_core+0x1/0xbb0
> >>>>> [   26.431334]  ? __netif_receive_skb_core+0x5/0xbb0
> >>>>> [   26.431930]  kprobe_ftrace_handler+0x90/0xf0
> >>>>> [   26.432495]  ftrace_ops_assist_func+0x63/0x100
> >>>>> [   26.433060]  0xffffffffc03180bf
> >>>>> [   26.433471]  ? __netif_receive_skb_core+0x1/0xbb0
> >>>>> ...
> >>>>>
> >>>>> To prevent we are running in arbitrary task (e.g., idle task)
> >>>>> context which may introduce sleeping issues, the following
> >>>>> probably appropriate:
> >>>>>
> >>>>>           if (in_nmi() || in_softirq())
> >>>>>                   return -EPERM;
> >>>>>
> >>>>> Anyway, if in nmi or softirq, the namespace and pid/tgid
> >>>>> we get may be just accidentally associated with the bpf running
> >>>>> context, but it could be in a different context. So such info
> >>>>> is not reliable any way.
> >>>>>
> >>>>>> +
> >>>>>> +   if (unlikely(size != sizeof(struct bpf_pidns_info)))
> >>>>>> +           return -EINVAL;
> >>>>>> +   pidns = task_active_pid_ns(current);
> >>> [...]
> >>>
