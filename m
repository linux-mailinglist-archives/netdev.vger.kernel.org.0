Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF01AA72B2
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 20:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfICSpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 14:45:11 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39760 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfICSpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 14:45:11 -0400
Received: by mail-qt1-f194.google.com with SMTP id n7so21215968qtb.6;
        Tue, 03 Sep 2019 11:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=TP/nxnQHNvQgkQWnrMmtRVQkzf/U2EMaIcHydGqn6+w=;
        b=RdH9/LAsJ4GwpNa5D1BwJfADOoN8eBDkaq3dtP0uILDnQmGxZcbbzQnIND349KlZ9G
         omsRdv939nEZwsQGQgn6dmeis+sIg2fU0eGhyKEDQjth8PBRAlo+coXq5utKSd0aPO6B
         fmOLJfsrVX8jQ6lvAUuaiZfZB51Sm9eVT7NZ7rcDtQQWZ7WgpsmXmVPfAhdHnLdi3Pz9
         cexQ/RAna+PpV5//u60FCZpJgdXJLYgMJsoPzOlA5NFJ1M1svMG2w0x8uOZsKLqzKITn
         8s6KJoJNHXE+SPvQJcTf163pxNeqJG43MbunDT6S4aOVR/MKamSGhrCkekjytOXHiQ44
         D+mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=TP/nxnQHNvQgkQWnrMmtRVQkzf/U2EMaIcHydGqn6+w=;
        b=SQAO8msW251TJWzYrUAm3jB0W7F9e5CcumH3uLh8UBXzh7RbIrVNQMBznIMzfQY2ME
         hvMZ/pR+xTO87SMvEjLYJXLIrIRQRP9upH7B17xmBKagGdQdozKhIESd5gQkU84ITjyR
         MPhGqhhFX/sWzECW3uCPtk8lqNCY8itQkQFq36+lopwEH6YViLmC17SFoTSmnRYYLkgO
         j+XoUPZur8+zgUDlzzTFvk2l5Dqi/HwOfD3cMz5dcdKbUd0gOXX4ioT+71PgPTpopSS1
         VkmCHzH6OmrXa/Axk1fa/rSeRwCzFw9OJf8sLkbMzy+QhfPaT4ixpuWUm62armMtQS4+
         FD6g==
X-Gm-Message-State: APjAAAXEnNMtLuFtmCavPO6A//t0dnCFwpcuS4Pg80FhUueloealfvv7
        AuerhwEZp8EkzWyP0hvK0ug=
X-Google-Smtp-Source: APXvYqwqmYGQTkhKidGM1ltYrj8p0EFeo6gWVUBrAR4l+2wDIy9Zdj6l+1xB2akmXyJwDiun8VGaMA==
X-Received: by 2002:ac8:94f:: with SMTP id z15mr35941455qth.233.1567536309415;
        Tue, 03 Sep 2019 11:45:09 -0700 (PDT)
Received: from ebpf-metal ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id q3sm2852793qtp.14.2019.09.03.11.45.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 03 Sep 2019 11:45:08 -0700 (PDT)
Date:   Tue, 3 Sep 2019 14:45:04 -0400
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next V9 1/3] bpf: new helper to obtain namespace data
 from current task
Message-ID: <20190903184502.2vpaqnoubbr7nnf6@ebpf-metal>
References: <20190813184747.12225-1-cneirabustos@gmail.com>
 <20190813184747.12225-2-cneirabustos@gmail.com>
 <13b7f81f-83b6-07c9-4864-b49749cbf7d9@fb.com>
 <20190814005604.yeqb45uv2fc3anab@dev00>
 <9a2cacad-b79f-5d39-6d62-bb48cbaaac07@fb.com>
 <CACiB22jyN9=0ATWWE+x=BoWD6u+8KO+MvBfsFQmcNfkmANb2_w@mail.gmail.com>
 <20190828203951.qo4kaloahcnvp7nw@ebpf-metal>
 <4faeb577-387a-7186-e060-f0ca76395823@fb.com>
 <20190828210333.itwtyqa5w5egnrwm@ebpf-metal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190828210333.itwtyqa5w5egnrwm@ebpf-metal>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yonghong,

> > Yes, the samples/bpf test case can be removed.
> > Could you create a selftest with tracpoint net/netif_receive_skb, which 
> > also uses the proposed helper? net/netif_receive_skb will happen in
> > interrupt context and it should catch the issue as well if 
> > filename_lookup still get called in interrupt context.
>
For this one scenario I just created another selftest with the only difference 
that the tracepoint is /net/netif_receive_skb so this fails with -EPERM.
Is that enough?.

I have made this comment on include/uapi/linux/bpf.h, maybe is too terse?

struct bpf_pidns_info {
	__u32 dev;	/* dev_t from /proc/self/ns/pid inode */
	__u32 nsid;
	__u32 tgid;
	__u32 pid;
};

I'm only missing clearing out those questions to be ready to submit v11 of this patch.

Bests

On Wed, Aug 28, 2019 at 05:03:35PM -0400, Carlos Antonio Neira Bustos wrote:
> Thanks, I'll work on the net/netif_receive_skb selftest using this helper.
> I hope I could complete this work this week.
> 
> Bests.
> 
> On Wed, Aug 28, 2019 at 08:53:25PM +0000, Yonghong Song wrote:
> > 
> > 
> > On 8/28/19 1:39 PM, Carlos Antonio Neira Bustos wrote:
> > > Yonghong,
> > > 
> > > Thanks for the pointer, I fixed this bug, but I found another one that's triggered
> > > now the test program I included in  tools/testing/selftests/bpf/test_pidns.
> > > It's seemed that fname was not correctly setup when passing it to filename_lookup.
> > > This is fixed now and I'm doing some more testing.
> > > I think I'll remove the tests on samples/bpf as they are mostly end on -EPERM as
> > > the fix intended.
> > > Is ok to remove them and just focus to finish the self tests code?.
> > 
> > Yes, the samples/bpf test case can be removed.
> > Could you create a selftest with tracpoint net/netif_receive_skb, which 
> > also uses the proposed helper? net/netif_receive_skb will happen in
> > interrupt context and it should catch the issue as well if 
> > filename_lookup still get called in interrupt context.
> > 
> > > 
> > > Bests
> > > 
> > > On Wed, Aug 14, 2019 at 01:25:06AM -0400, carlos antonio neira bustos wrote:
> > >> Thank you very much!
> > >>
> > >> Bests
> > >>
> > >> El mié., 14 de ago. de 2019 00:50, Yonghong Song <yhs@fb.com> escribió:
> > >>
> > >>>
> > >>>
> > >>> On 8/13/19 5:56 PM, Carlos Antonio Neira Bustos wrote:
> > >>>> On Tue, Aug 13, 2019 at 11:11:14PM +0000, Yonghong Song wrote:
> > >>>>>
> > >>>>>
> > >>>>> On 8/13/19 11:47 AM, Carlos Neira wrote:
> > >>>>>> From: Carlos <cneirabustos@gmail.com>
> > >>>>>>
> > >>>>>> New bpf helper bpf_get_current_pidns_info.
> > >>>>>> This helper obtains the active namespace from current and returns
> > >>>>>> pid, tgid, device and namespace id as seen from that namespace,
> > >>>>>> allowing to instrument a process inside a container.
> > >>>>>>
> > >>>>>> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > >>>>>> ---
> > >>>>>>     fs/internal.h            |  2 --
> > >>>>>>     fs/namei.c               |  1 -
> > >>>>>>     include/linux/bpf.h      |  1 +
> > >>>>>>     include/linux/namei.h    |  4 +++
> > >>>>>>     include/uapi/linux/bpf.h | 31 ++++++++++++++++++++++-
> > >>>>>>     kernel/bpf/core.c        |  1 +
> > >>>>>>     kernel/bpf/helpers.c     | 64
> > >>> ++++++++++++++++++++++++++++++++++++++++++++++++
> > >>>>>>     kernel/trace/bpf_trace.c |  2 ++
> > >>>>>>     8 files changed, 102 insertions(+), 4 deletions(-)
> > >>>>>>
> > >>> [...]
> > >>>>>>
> > >>>>>> +BPF_CALL_2(bpf_get_current_pidns_info, struct bpf_pidns_info *,
> > >>> pidns_info, u32,
> > >>>>>> +    size)
> > >>>>>> +{
> > >>>>>> +   const char *pidns_path = "/proc/self/ns/pid";
> > >>>>>> +   struct pid_namespace *pidns = NULL;
> > >>>>>> +   struct filename *tmp = NULL;
> > >>>>>> +   struct inode *inode;
> > >>>>>> +   struct path kp;
> > >>>>>> +   pid_t tgid = 0;
> > >>>>>> +   pid_t pid = 0;
> > >>>>>> +   int ret;
> > >>>>>> +   int len;
> > >>>>>
> > >>>>
> > >>>> Thank you very much for catching this!.
> > >>>> Could you share how to replicate this bug?.
> > >>>
> > >>> The config is attached. just run trace_ns_info and you
> > >>> can reproduce the issue.
> > >>>
> > >>>>
> > >>>>> I am running your sample program and get the following kernel bug:
> > >>>>>
> > >>>>> ...
> > >>>>> [   26.414825] BUG: sleeping function called from invalid context at
> > >>>>> /data/users/yhs/work/net-next/fs
> > >>>>> /dcache.c:843
> > >>>>> [   26.416314] in_atomic(): 1, irqs_disabled(): 0, pid: 1911, name: ping
> > >>>>> [   26.417189] CPU: 0 PID: 1911 Comm: ping Tainted: G        W
> > >>>>> 5.3.0-rc1+ #280
> > >>>>> [   26.418182] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> > >>>>> BIOS 1.9.3-1.el7.centos 04/01/2
> > >>>>> 014
> > >>>>> [   26.419393] Call Trace:
> > >>>>> [   26.419697]  <IRQ>
> > >>>>> [   26.419960]  dump_stack+0x46/0x5b
> > >>>>> [   26.420434]  ___might_sleep+0xe4/0x110
> > >>>>> [   26.420894]  dput+0x2a/0x200
> > >>>>> [   26.421265]  walk_component+0x10c/0x280
> > >>>>> [   26.421773]  link_path_walk+0x327/0x560
> > >>>>> [   26.422280]  ? proc_ns_dir_readdir+0x1a0/0x1a0
> > >>>>> [   26.422848]  ? path_init+0x232/0x330
> > >>>>> [   26.423364]  path_lookupat+0x88/0x200
> > >>>>> [   26.423808]  ? selinux_parse_skb.constprop.69+0x124/0x430
> > >>>>> [   26.424521]  filename_lookup+0xaf/0x190
> > >>>>> [   26.425031]  ? simple_attr_release+0x20/0x20
> > >>>>> [   26.425560]  bpf_get_current_pidns_info+0xfa/0x190
> > >>>>> [   26.426168]  bpf_prog_83627154cefed596+0xe66/0x1000
> > >>>>> [   26.426779]  trace_call_bpf+0xb5/0x160
> > >>>>> [   26.427317]  ? __netif_receive_skb_core+0x1/0xbb0
> > >>>>> [   26.427929]  ? __netif_receive_skb_core+0x1/0xbb0
> > >>>>> [   26.428496]  kprobe_perf_func+0x4d/0x280
> > >>>>> [   26.428986]  ? tracing_record_taskinfo_skip+0x1a/0x30
> > >>>>> [   26.429584]  ? tracing_record_taskinfo+0xe/0x80
> > >>>>> [   26.430152]  ? ttwu_do_wakeup.isra.114+0xcf/0xf0
> > >>>>> [   26.430737]  ? __netif_receive_skb_core+0x1/0xbb0
> > >>>>> [   26.431334]  ? __netif_receive_skb_core+0x5/0xbb0
> > >>>>> [   26.431930]  kprobe_ftrace_handler+0x90/0xf0
> > >>>>> [   26.432495]  ftrace_ops_assist_func+0x63/0x100
> > >>>>> [   26.433060]  0xffffffffc03180bf
> > >>>>> [   26.433471]  ? __netif_receive_skb_core+0x1/0xbb0
> > >>>>> ...
> > >>>>>
> > >>>>> To prevent we are running in arbitrary task (e.g., idle task)
> > >>>>> context which may introduce sleeping issues, the following
> > >>>>> probably appropriate:
> > >>>>>
> > >>>>>           if (in_nmi() || in_softirq())
> > >>>>>                   return -EPERM;
> > >>>>>
> > >>>>> Anyway, if in nmi or softirq, the namespace and pid/tgid
> > >>>>> we get may be just accidentally associated with the bpf running
> > >>>>> context, but it could be in a different context. So such info
> > >>>>> is not reliable any way.
> > >>>>>
> > >>>>>> +
> > >>>>>> +   if (unlikely(size != sizeof(struct bpf_pidns_info)))
> > >>>>>> +           return -EINVAL;
> > >>>>>> +   pidns = task_active_pid_ns(current);
> > >>> [...]
> > >>>
