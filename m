Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30811FFE49
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbgFRWqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728244AbgFRWqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:46:10 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE88C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:46:10 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id l12so8121735ejn.10
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dRvKUpFKB31cWMn4qRD0LszkLu5+Gzwbxa1y2xW3FY4=;
        b=KZx+OFnsz3MoHFPOwl0SgdGr7X+oKPS31dQUR86c222lIdk6mC1UDuH431vyfV8NOV
         UKoOXsJKzuFdVPD/wv26rZyW8luw6U3HtqTiC4JFrHEJJBNWv6E5VyuElPhjT6Ru+ess
         B+XRDTGpFVm2lwX7jtgzZ/UKH0eGsXsWMS1XwBPAic/TZW9QccHQ9KPUnV52GY5b6s+4
         fIuViK8ZDkg31T4GcS9WF665bQ546XjEJoSHX+FbtIAfGX7Yyu81exe0VJkolaluqMYm
         PayZaP9eHo6bTOYjQRi6dw0mKWgbXnN43nqVxnNTpztw64kD1UwNbqXxiul4nqUYZzFA
         Ts1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dRvKUpFKB31cWMn4qRD0LszkLu5+Gzwbxa1y2xW3FY4=;
        b=BGdbRjUU7ILYf+8na4+tZEjkf8YDJp+dI5YMK1y1mTdI6pNbkR94uomxCeIimKCVs0
         1UtfVFREwJkthXkjyqehYawq1F6IcX8uaJnnno7PgQ9OWMupm93lLtyBiUgMw2xtY+Z1
         yNrNGr7mzM2TCZZQOVgBI2S4Y+5JT95NBKVKin+QoijbldB4uGuzqLKw7akSJft8W6Ti
         nnEqggmID+/stj5CH5rDTEitOa7Qdt1JdjgWVCEas+2Y32QW2zLQateUH4+qp8xFoLsp
         5QQr7X9sKW4kH7x7w3d1sGFSDiQNAr0DhqCiYhjoCQWS0+aGkeeUbus20fTb1iHyO/5p
         Q9hg==
X-Gm-Message-State: AOAM5303FkB7YEOw2WY6AL81j2HpwLE7fSzOnM57ebWOGyOfHV4eQK50
        sc/79oekEh4iwYJ//RrFp1fMVx5h5GZDLbM1q7E=
X-Google-Smtp-Source: ABdhPJx2tETTHNvucDtJ3J/iA6g3LSekRKMvt3rT4cn2u8rqGFSp8nXInNArJ3IAXWkEgupV9zGSvmrxKhAvEVkVnZg=
X-Received: by 2002:a17:906:ce30:: with SMTP id sd16mr935719ejb.374.1592520368709;
 Thu, 18 Jun 2020 15:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com> <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com> <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <20200618212615.GG110603@carbon.dhcp.thefacebook.com>
In-Reply-To: <20200618212615.GG110603@carbon.dhcp.thefacebook.com>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Thu, 18 Jun 2020 18:45:56 -0400
Message-ID: <CAMdYzYr+fCpmr6LFPznN+DpLYcFKLFoG+_jeE=2UTi5O-Fs12Q@mail.gmail.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Roman Gushchin <guro@fb.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 5:26 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Thu, Jun 18, 2020 at 02:09:43PM -0700, Cong Wang wrote:
> > On Thu, Jun 18, 2020 at 12:36 PM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > On Thu, Jun 18, 2020 at 12:19:13PM -0700, Cong Wang wrote:
> > > > On Wed, Jun 17, 2020 at 6:44 PM Zefan Li <lizefan@huawei.com> wrote:
> > > > >
> > > > > Cc: Roman Gushchin <guro@fb.com>
> > > > >
> > > > > Thanks for fixing this.
> > > > >
> > > > > On 2020/6/17 2:03, Cong Wang wrote:
> > > > > > When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> > > > > > copied, so the cgroup refcnt must be taken too. And, unlike the
> > > > > > sk_alloc() path, sock_update_netprioidx() is not called here.
> > > > > > Therefore, it is safe and necessary to grab the cgroup refcnt
> > > > > > even when cgroup_sk_alloc is disabled.
> > > > > >
> > > > > > sk_clone_lock() is in BH context anyway, the in_interrupt()
> > > > > > would terminate this function if called there. And for sk_alloc()
> > > > > > skcd->val is always zero. So it's safe to factor out the code
> > > > > > to make it more readable.
> > > > > >
> > > > > > Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
> > > > >
> > > > > but I don't think the bug was introduced by this commit, because there
> > > > > are already calls to cgroup_sk_alloc_disable() in write_priomap() and
> > > > > write_classid(), which can be triggered by writing to ifpriomap or
> > > > > classid in cgroupfs. This commit just made it much easier to happen
> > > > > with systemd invovled.
> > > > >
> > > > > I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself"),
> > > > > which added cgroup_bpf_get() in cgroup_sk_alloc().
> > > >
> > > > Good point.
> > > >
> > > > I take a deeper look, it looks like commit d979a39d7242e06
> > > > is the one to blame, because it is the first commit that began to
> > > > hold cgroup refcnt in cgroup_sk_alloc().
> > >
> > > I agree, ut seems that the issue is not related to bpf and probably
> > > can be reproduced without CONFIG_CGROUP_BPF. d979a39d7242e06 indeed
> > > seems closer to the origin.
> >
> > Yeah, I will update the Fixes tag and send V2.
> >
> > >
> > > Btw, based on the number of reported-by tags it seems that there was
> > > a real issue which the patch is fixing. Maybe you'll a couple of words
> > > about how it reveals itself in the real life?
> >
> > I still have no idea how exactly this is triggered. According to the
> > people who reported this bug, they just need to wait for some hours
> > to trigger. So I am not sure what to add here, just the stack trace?
>
> Yeah, stack trace is definitely useful. So at least if someone will encounter the same
> error in the future, they can search for the stacktrace and find the fix.

I can provide at least a little insight into my configuration that
allowed the bug to trigger.
I'm running the following configuration:
Ubuntu 20.04 - aarch64
Mainline 5.6.17 kernel using Ubuntu's config.
LXD with several containers active.
Docker with several containers active.

Every crash was the same, with nfsd triggering the sequence.
My only nfs client at the time was a Windows 10 device.
Disabling nfsd prevented the bug from occurring.

Here was the last stack trace:
[23352.431106] rockpro64 kernel: Unable to handle kernel read from
unreadable memory at virtual address 0000000000000010
[23352.431938] rockpro64 kernel: Mem abort info:
[23352.432199] rockpro64 kernel:   ESR = 0x96000004
[23352.432485] rockpro64 kernel:   EC = 0x25: DABT (current EL), IL = 32 bits
[23352.432965] rockpro64 kernel:   SET = 0, FnV = 0
[23352.433248] rockpro64 kernel:   EA = 0, S1PTW = 0
[23352.433536] rockpro64 kernel: Data abort info:
[23352.433803] rockpro64 kernel:   ISV = 0, ISS = 0x00000004
[23352.434153] rockpro64 kernel:   CM = 0, WnR = 0
[23352.434475] rockpro64 kernel: user pgtable: 4k pages, 48-bit VAs,
pgdp=0000000094d4c000
[23352.435174] rockpro64 kernel: [0000000000000010]
pgd=0000000094f3d003, pud=00000000bdb7f003, pmd=0000000000000000
[23352.435963] rockpro64 kernel: Internal error: Oops: 96000004 [#1] SMP
[23352.436396] rockpro64 kernel: Modules linked in: xt_TCPMSS
nf_conntrack_netlink xfrm_user xt_addrtype br_netfilter ip_set_hash_ip
ip_set_hash_net xt_set ip_set cfg80211 nft_counter xt_length
xt_connmark xt_multiport xt_mark nf_log_ip>
[23352.436519] rockpro64 kernel:  ghash_ce enclosure snd_soc_es8316
scsi_transport_sas snd_seq_midi sha2_ce snd_seq_midi_event
snd_soc_simple_card snd_rawmidi snd_soc_audio_graph_card sha256_arm64
panfrost snd_soc_simple_card_utils sha1>
[23352.444216] rockpro64 kernel:  async_pq async_xor xor xor_neon
async_tx uas raid6_pq raid1 raid0 multipath linear usb_storage
xhci_plat_hcd dwc3 rtc_rk808 clk_rk808 rk808_regulator ulpi udc_core
fusb302 tcpm typec fan53555 rk808 pwm_>
[23352.455532] rockpro64 kernel: CPU: 3 PID: 1237 Comm: nfsd Not
tainted 5.6.17+ #74
[23352.456054] rockpro64 kernel: Hardware name: pine64
rockpro64_rk3399/rockpro64_rk3399, BIOS
2020.07-rc2-00124-g515f613253-dirty 05/19/2020
[23352.457010] rockpro64 kernel: pstate: 60400005 (nZCv daif +PAN -UAO)
[23352.457445] rockpro64 kernel: pc : __cgroup_bpf_run_filter_skb+0x2a8/0x400
[23352.457918] rockpro64 kernel: lr : ip_finish_output+0x98/0xd0
[23352.458287] rockpro64 kernel: sp : ffff80001325b900
[23352.458581] rockpro64 kernel: x29: ffff80001325b900 x28: ffff000012f0fae0
[23352.459051] rockpro64 kernel: x27: 0000000000000001 x26: ffff00005f0ddc00
[23352.459521] rockpro64 kernel: x25: 0000000000000118 x24: ffff0000dcd3c270
[23352.459990] rockpro64 kernel: x23: 0000000000000010 x22: ffff800011b1aec0
[23352.460458] rockpro64 kernel: x21: ffff0000efcacc40 x20: 0000000000000010
[23352.460928] rockpro64 kernel: x19: ffff0000dcd3bf00 x18: 0000000000000000
[23352.461396] rockpro64 kernel: x17: 0000000000000000 x16: 0000000000000000
[23352.461863] rockpro64 kernel: x15: 0000000000000000 x14: 0000000000000004
[23352.462332] rockpro64 kernel: x13: 0000000000000001 x12: 0000000000201400
[23352.462802] rockpro64 kernel: x11: 0000000000000000 x10: 0000000000000000
[23352.463271] rockpro64 kernel: x9 : ffff800010b6f6d0 x8 : 0000000000000260
[23352.463738] rockpro64 kernel: x7 : 0000000000000000 x6 : ffff0000dc12a000
[23352.464208] rockpro64 kernel: x5 : ffff0000dcd3bf00 x4 : 0000000000000028
[23352.464677] rockpro64 kernel: x3 : 0000000000000000 x2 : ffff000012f0fb08
[23352.465145] rockpro64 kernel: x1 : ffff00005f0ddd40 x0 : 0000000000000000
[23352.465616] rockpro64 kernel: Call trace:
[23352.465843] rockpro64 kernel:  __cgroup_bpf_run_filter_skb+0x2a8/0x400
[23352.466283] rockpro64 kernel:  ip_finish_output+0x98/0xd0
[23352.466625] rockpro64 kernel:  ip_output+0xb0/0x130
[23352.466920] rockpro64 kernel:  ip_local_out+0x4c/0x60
[23352.467233] rockpro64 kernel:  __ip_queue_xmit+0x128/0x380
[23352.467584] rockpro64 kernel:  ip_queue_xmit+0x10/0x18
[23352.467903] rockpro64 kernel:  __tcp_transmit_skb+0x470/0xaf0
[23352.468274] rockpro64 kernel:  tcp_write_xmit+0x39c/0x1110
[23352.468623] rockpro64 kernel:  __tcp_push_pending_frames+0x40/0x100
[23352.469040] rockpro64 kernel:  tcp_send_fin+0x6c/0x240
[23352.469358] rockpro64 kernel:  tcp_shutdown+0x60/0x68
[23352.469669] rockpro64 kernel:  inet_shutdown+0xb0/0x120
[23352.469997] rockpro64 kernel:  kernel_sock_shutdown+0x1c/0x28
[23352.470464] rockpro64 kernel:  svc_tcp_sock_detach+0xd0/0x110 [sunrpc]
[23352.470980] rockpro64 kernel:  svc_delete_xprt+0x74/0x240 [sunrpc]
[23352.471445] rockpro64 kernel:  svc_recv+0x45c/0xb10 [sunrpc]
[23352.471864] rockpro64 kernel:  nfsd+0xdc/0x150 [nfsd]
[23352.472179] rockpro64 kernel:  kthread+0xfc/0x128
[23352.472461] rockpro64 kernel:  ret_from_fork+0x10/0x18
[23352.472785] rockpro64 kernel: Code: 9100c0c6 17ffff7b f9431cc0
91004017 (f9400814)
[23352.473324] rockpro64 kernel: ---[ end trace 978df9e144fd1235 ]---
[29973.397069] rockpro64 kernel: Unable to handle kernel read from
unreadable memory at virtual address 0000000000000010
[29973.397966] rockpro64 kernel: Mem abort info:
[29973.398224] rockpro64 kernel:   ESR = 0x96000004
[29973.398503] rockpro64 kernel:   EC = 0x25: DABT (current EL), IL = 32 bits
[29973.398976] rockpro64 kernel:   SET = 0, FnV = 0
[29973.399254] rockpro64 kernel:   EA = 0, S1PTW = 0
[29973.399537] rockpro64 kernel: Data abort info:
[29973.399799] rockpro64 kernel:   ISV = 0, ISS = 0x00000004
[29973.400143] rockpro64 kernel:   CM = 0, WnR = 0
[29973.400416] rockpro64 kernel: user pgtable: 4k pages, 48-bit VAs,
pgdp=00000000dcdd1000
[29973.400989] rockpro64 kernel: [0000000000000010] pgd=0000000000000000
[29973.401490] rockpro64 kernel: Internal error: Oops: 96000004 [#2] SMP

I hope this helps.

>
> Thanks!
