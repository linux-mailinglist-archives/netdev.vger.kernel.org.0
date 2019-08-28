Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F00A0BAC
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfH1UkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:40:00 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40131 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfH1UkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:40:00 -0400
Received: by mail-qt1-f195.google.com with SMTP id g4so1118487qtq.7;
        Wed, 28 Aug 2019 13:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=LN6I+wmkOUjNvboiLmQ4C8v9hct75PjdpPpBQSjLorY=;
        b=b+L4vN1gv5nzgoWLJOvf5JkWyLaeHVnLI15Jv3oD8LKiG/lmf7nTjQj23avEl5ig4s
         2P3z/8c/HS7TntLMxSnQKMV/NVItwRXUnX61bL9nhvGoSUROUcYSC/Iz2gfGQUh2x1Mp
         gLssKl7ZrxGs8laQAg8HAqsSgoHY10cz+TWaPQwzcoMvKz5syIddRlb4U5le5SHepTkW
         Qr9xDmpg+xnVUZwv8caYNq6I/YKHbzuDQ4EZtfOerVDHdKBz/v1lc3EjQDqsvruxaaP9
         I8LScCQrWLoTAmK84Xutph/3TqJOt48HGDonbPGd0EMkkpEuJZEjsYoaGpZJ2qoHz1HF
         u3Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=LN6I+wmkOUjNvboiLmQ4C8v9hct75PjdpPpBQSjLorY=;
        b=hNsqC4Q3G9CEs+togx3VcxUI27uhkJnyASYVZP22LVCQRJt3X4MgluoanEcqR6vrcF
         H0q+ycJBGuXCDcBAKxQ81afzcte75ldR9evhLuUWnjinMIz4A5q+8rwE6YD7SMIViqMO
         NcA20XnHd0hYVQs133a4UTCQNmZ8WvG974IMsoa71wm1pErSYTbudN6kMIebUxcjePHB
         AHIp4p2uBgPDUNoQF+sSwxb1UMsjBgp36cUx80k1qys4pEXwzvXzrEo0aixuYHiZa2um
         PeL7A2pxh16pp1uPyTFzbeAJCeQtfx09/A786yGGz3lm1mBwPY8z8V4zFyefdHR0vqx/
         J7yQ==
X-Gm-Message-State: APjAAAXIKJLIq8fkN8AZbLUZ1NYtwBeJwYI4PXWJ1eyVlhhDbaB9QJon
        OeOy15mSIX+my5icImlH7q8=
X-Google-Smtp-Source: APXvYqzr3cZcQQZ7Jab7CUJx9Ujq4Bq8JsfpSWAD/r5SmKwlX0wC9xx1oE/c7ttafaD3Z8UptTNNHQ==
X-Received: by 2002:a0c:92ca:: with SMTP id c10mr4436312qvc.108.1567024798639;
        Wed, 28 Aug 2019 13:39:58 -0700 (PDT)
Received: from ebpf-metal ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id y5sm161232qkj.64.2019.08.28.13.39.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Aug 2019 13:39:58 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:39:54 -0400
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     netdev@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next V9 1/3] bpf: new helper to obtain namespace data
 from current task
Message-ID: <20190828203951.qo4kaloahcnvp7nw@ebpf-metal>
References: <20190813184747.12225-1-cneirabustos@gmail.com>
 <20190813184747.12225-2-cneirabustos@gmail.com>
 <13b7f81f-83b6-07c9-4864-b49749cbf7d9@fb.com>
 <20190814005604.yeqb45uv2fc3anab@dev00>
 <9a2cacad-b79f-5d39-6d62-bb48cbaaac07@fb.com>
 <CACiB22jyN9=0ATWWE+x=BoWD6u+8KO+MvBfsFQmcNfkmANb2_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACiB22jyN9=0ATWWE+x=BoWD6u+8KO+MvBfsFQmcNfkmANb2_w@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong, 

Thanks for the pointer, I fixed this bug, but I found another one that's triggered
now the test program I included in  tools/testing/selftests/bpf/test_pidns.
It's seemed that fname was not correctly setup when passing it to filename_lookup.
This is fixed now and I'm doing some more testing.
I think I'll remove the tests on samples/bpf as they are mostly end on -EPERM as 
the fix intended.
Is ok to remove them and just focus to finish the self tests code?.

Bests

On Wed, Aug 14, 2019 at 01:25:06AM -0400, carlos antonio neira bustos wrote:
> Thank you very much!
> 
> Bests
> 
> El mié., 14 de ago. de 2019 00:50, Yonghong Song <yhs@fb.com> escribió:
> 
> >
> >
> > On 8/13/19 5:56 PM, Carlos Antonio Neira Bustos wrote:
> > > On Tue, Aug 13, 2019 at 11:11:14PM +0000, Yonghong Song wrote:
> > >>
> > >>
> > >> On 8/13/19 11:47 AM, Carlos Neira wrote:
> > >>> From: Carlos <cneirabustos@gmail.com>
> > >>>
> > >>> New bpf helper bpf_get_current_pidns_info.
> > >>> This helper obtains the active namespace from current and returns
> > >>> pid, tgid, device and namespace id as seen from that namespace,
> > >>> allowing to instrument a process inside a container.
> > >>>
> > >>> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > >>> ---
> > >>>    fs/internal.h            |  2 --
> > >>>    fs/namei.c               |  1 -
> > >>>    include/linux/bpf.h      |  1 +
> > >>>    include/linux/namei.h    |  4 +++
> > >>>    include/uapi/linux/bpf.h | 31 ++++++++++++++++++++++-
> > >>>    kernel/bpf/core.c        |  1 +
> > >>>    kernel/bpf/helpers.c     | 64
> > ++++++++++++++++++++++++++++++++++++++++++++++++
> > >>>    kernel/trace/bpf_trace.c |  2 ++
> > >>>    8 files changed, 102 insertions(+), 4 deletions(-)
> > >>>
> > [...]
> > >>>
> > >>> +BPF_CALL_2(bpf_get_current_pidns_info, struct bpf_pidns_info *,
> > pidns_info, u32,
> > >>> +    size)
> > >>> +{
> > >>> +   const char *pidns_path = "/proc/self/ns/pid";
> > >>> +   struct pid_namespace *pidns = NULL;
> > >>> +   struct filename *tmp = NULL;
> > >>> +   struct inode *inode;
> > >>> +   struct path kp;
> > >>> +   pid_t tgid = 0;
> > >>> +   pid_t pid = 0;
> > >>> +   int ret;
> > >>> +   int len;
> > >>
> > >
> > > Thank you very much for catching this!.
> > > Could you share how to replicate this bug?.
> >
> > The config is attached. just run trace_ns_info and you
> > can reproduce the issue.
> >
> > >
> > >> I am running your sample program and get the following kernel bug:
> > >>
> > >> ...
> > >> [   26.414825] BUG: sleeping function called from invalid context at
> > >> /data/users/yhs/work/net-next/fs
> > >> /dcache.c:843
> > >> [   26.416314] in_atomic(): 1, irqs_disabled(): 0, pid: 1911, name: ping
> > >> [   26.417189] CPU: 0 PID: 1911 Comm: ping Tainted: G        W
> > >> 5.3.0-rc1+ #280
> > >> [   26.418182] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> > >> BIOS 1.9.3-1.el7.centos 04/01/2
> > >> 014
> > >> [   26.419393] Call Trace:
> > >> [   26.419697]  <IRQ>
> > >> [   26.419960]  dump_stack+0x46/0x5b
> > >> [   26.420434]  ___might_sleep+0xe4/0x110
> > >> [   26.420894]  dput+0x2a/0x200
> > >> [   26.421265]  walk_component+0x10c/0x280
> > >> [   26.421773]  link_path_walk+0x327/0x560
> > >> [   26.422280]  ? proc_ns_dir_readdir+0x1a0/0x1a0
> > >> [   26.422848]  ? path_init+0x232/0x330
> > >> [   26.423364]  path_lookupat+0x88/0x200
> > >> [   26.423808]  ? selinux_parse_skb.constprop.69+0x124/0x430
> > >> [   26.424521]  filename_lookup+0xaf/0x190
> > >> [   26.425031]  ? simple_attr_release+0x20/0x20
> > >> [   26.425560]  bpf_get_current_pidns_info+0xfa/0x190
> > >> [   26.426168]  bpf_prog_83627154cefed596+0xe66/0x1000
> > >> [   26.426779]  trace_call_bpf+0xb5/0x160
> > >> [   26.427317]  ? __netif_receive_skb_core+0x1/0xbb0
> > >> [   26.427929]  ? __netif_receive_skb_core+0x1/0xbb0
> > >> [   26.428496]  kprobe_perf_func+0x4d/0x280
> > >> [   26.428986]  ? tracing_record_taskinfo_skip+0x1a/0x30
> > >> [   26.429584]  ? tracing_record_taskinfo+0xe/0x80
> > >> [   26.430152]  ? ttwu_do_wakeup.isra.114+0xcf/0xf0
> > >> [   26.430737]  ? __netif_receive_skb_core+0x1/0xbb0
> > >> [   26.431334]  ? __netif_receive_skb_core+0x5/0xbb0
> > >> [   26.431930]  kprobe_ftrace_handler+0x90/0xf0
> > >> [   26.432495]  ftrace_ops_assist_func+0x63/0x100
> > >> [   26.433060]  0xffffffffc03180bf
> > >> [   26.433471]  ? __netif_receive_skb_core+0x1/0xbb0
> > >> ...
> > >>
> > >> To prevent we are running in arbitrary task (e.g., idle task)
> > >> context which may introduce sleeping issues, the following
> > >> probably appropriate:
> > >>
> > >>          if (in_nmi() || in_softirq())
> > >>                  return -EPERM;
> > >>
> > >> Anyway, if in nmi or softirq, the namespace and pid/tgid
> > >> we get may be just accidentally associated with the bpf running
> > >> context, but it could be in a different context. So such info
> > >> is not reliable any way.
> > >>
> > >>> +
> > >>> +   if (unlikely(size != sizeof(struct bpf_pidns_info)))
> > >>> +           return -EINVAL;
> > >>> +   pidns = task_active_pid_ns(current);
> > [...]
> >
