Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4954E3B6C23
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 03:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhF2Bsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 21:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhF2Bsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 21:48:37 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E8BC061574;
        Mon, 28 Jun 2021 18:46:11 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id q192so15822096pfc.7;
        Mon, 28 Jun 2021 18:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u7yocOhqM9FCAx5h9Kqg6t5YMTy/n1r7NOo6Y7e5i34=;
        b=XpVlwMGYo4nYuzByCDyy2dtpNuP/UApXeGKqjGMTt7q480TQr2zJRcYiifln5qDWP8
         c21fUjiFOCfC0UQgDO1l+1xswSBxVwiNK0cmFVj8jqUXmO3NSDxdwf76A4Xk2SQtyhIP
         1yY331vP6sQWmpDUj/mVwieyajWa0cEOFQht/3Lydqj4wWdauWu4yejfoutMLN8n5n6i
         kHAASzb5B2mlPsR2vWlh/Fv+Al6uyoAQsMGRe2JCou/U6Bg21bkJh3vtyAbSOlQ30Mcb
         FjlkE4stxVb08+Nu0H7UXqqRxFty6eTlHLEHM2FVEo8o//PkiKTiHoeVtqzFJdzhrnGv
         7ckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=u7yocOhqM9FCAx5h9Kqg6t5YMTy/n1r7NOo6Y7e5i34=;
        b=BoTMpy+bty395uF8Aeb49N6QtDbj8+sID8SOqCOE7bq1UjuUyyMvcfoW+dxF/7oeod
         dCWwYbvFU+k0l14ittPbmQd5eRskIMaRQVBkAy5nn7BJSvIY2w1e4Vs9NrkIRonnbc2i
         57hu5UP9C95LZgbpDzdgZ0NoVkELxWtxkOU/kqbXPM0F/OnsFBEAXmfDqNugJn0mKMAB
         28G/JomaYCEsj205+qeUoA/ZO1IrG64XJryb4am3YSz0Fr9rgZ7hshcTvtPcj/lPXPFT
         PCuzFy81f/VDPJUWB9ol17HFx7cVOuD8XsXitcM7SEK7t1Ma+GafhhubMhMYYm1qAGxz
         YdDg==
X-Gm-Message-State: AOAM531YdjA/PKrwWpXY1/IF4rpnp8oZ4+yrFMZ2Sr3s9H414dec80Tv
        u7iK/fg+mOaQ9ti1VasZgPU=
X-Google-Smtp-Source: ABdhPJw0ggp0dA6jrK821gHT9aJ1czmpmHjyISWpUTK2klNLrrOHr6uLkJFP78BUmg5ish+ojrYMBA==
X-Received: by 2002:a62:794c:0:b029:30b:6792:3a45 with SMTP id u73-20020a62794c0000b029030b67923a45mr11362754pfc.46.1624931170869;
        Mon, 28 Jun 2021 18:46:10 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:45ad])
        by smtp.gmail.com with ESMTPSA id d2sm15542609pgh.59.2021.06.28.18.46.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jun 2021 18:46:10 -0700 (PDT)
Date:   Mon, 28 Jun 2021 18:46:08 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
Message-ID: <20210629014607.fz5tkewb6n3u6pvr@ast-mbp.dhcp.thefacebook.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-2-alexei.starovoitov@gmail.com>
 <fd30895e-475f-c78a-d367-2abdf835c9ef@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd30895e-475f-c78a-d367-2abdf835c9ef@fb.com>
User-Agent: NeoMutt/20180223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 09:54:11AM -0700, Yonghong Song wrote:
> 
> 
> On 6/23/21 7:25 PM, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> > 
> > Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
> > in hash/array/lru maps as a regular field and helpers to operate on it:
> > 
> > // Initialize the timer.
> > // First 4 bits of 'flags' specify clockid.
> > // Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
> > long bpf_timer_init(struct bpf_timer *timer, int flags);
> > 
> > // Arm the timer to call callback_fn static function and set its
> > // expiration 'nsec' nanoseconds from the current time.
> > long bpf_timer_start(struct bpf_timer *timer, void *callback_fn, u64 nsec);
> > 
> > // Cancel the timer and wait for callback_fn to finish if it was running.
> > long bpf_timer_cancel(struct bpf_timer *timer);
> > 
> > Here is how BPF program might look like:
> > struct map_elem {
> >      int counter;
> >      struct bpf_timer timer;
> > };
> > 
> > struct {
> >      __uint(type, BPF_MAP_TYPE_HASH);
> >      __uint(max_entries, 1000);
> >      __type(key, int);
> >      __type(value, struct map_elem);
> > } hmap SEC(".maps");
> > 
> > static int timer_cb(void *map, int *key, struct map_elem *val);
> > /* val points to particular map element that contains bpf_timer. */
> > 
> > SEC("fentry/bpf_fentry_test1")
> > int BPF_PROG(test1, int a)
> > {
> >      struct map_elem *val;
> >      int key = 0;
> > 
> >      val = bpf_map_lookup_elem(&hmap, &key);
> >      if (val) {
> >          bpf_timer_init(&val->timer, CLOCK_REALTIME);
> >          bpf_timer_start(&val->timer, timer_cb, 1000 /* call timer_cb2 in 1 usec */);
> >      }
> > }
> > 
> > This patch adds helper implementations that rely on hrtimers
> > to call bpf functions as timers expire.
> > The following patches add necessary safety checks.
> > 
> > Only programs with CAP_BPF are allowed to use bpf_timer.
> > 
> > The amount of timers used by the program is constrained by
> > the memcg recorded at map creation time.
> > 
> > The bpf_timer_init() helper is receiving hidden 'map' argument and
> > bpf_timer_start() is receiving hidden 'prog' argument supplied by the verifier.
> > The prog pointer is needed to do refcnting of bpf program to make sure that
> > program doesn't get freed while the timer is armed. This apporach relies on
> > "user refcnt" scheme used in prog_array that stores bpf programs for
> > bpf_tail_call. The bpf_timer_start() will increment the prog refcnt which is
> > paired with bpf_timer_cancel() that will drop the prog refcnt. The
> > ops->map_release_uref is responsible for cancelling the timers and dropping
> > prog refcnt when user space reference to a map reaches zero.
> > This uref approach is done to make sure that Ctrl-C of user space process will
> > not leave timers running forever unless the user space explicitly pinned a map
> > that contained timers in bpffs.
> > 
> > The bpf_map_delete_elem() and bpf_map_update_elem() operations cancel
> > and free the timer if given map element had it allocated.
> > "bpftool map update" command can be used to cancel timers.
> > 
> > The 'struct bpf_timer' is explicitly __attribute__((aligned(8))) because
> > '__u64 :64' has 1 byte alignment of 8 byte padding.
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >   include/linux/bpf.h            |   3 +
> >   include/uapi/linux/bpf.h       |  55 +++++++
> >   kernel/bpf/helpers.c           | 281 +++++++++++++++++++++++++++++++++
> >   kernel/bpf/verifier.c          | 138 ++++++++++++++++
> >   kernel/trace/bpf_trace.c       |   2 +-
> >   scripts/bpf_doc.py             |   2 +
> >   tools/include/uapi/linux/bpf.h |  55 +++++++
> >   7 files changed, 535 insertions(+), 1 deletion(-)
> > 
> [...]
> > @@ -12533,6 +12607,70 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> >   			continue;
> >   		}
> > +		if (insn->imm == BPF_FUNC_timer_init) {
> > +			aux = &env->insn_aux_data[i + delta];
> > +			if (bpf_map_ptr_poisoned(aux)) {
> > +				verbose(env, "bpf_timer_init abusing map_ptr\n");
> > +				return -EINVAL;
> > +			}
> > +			map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
> > +			{
> > +				struct bpf_insn ld_addrs[2] = {
> > +					BPF_LD_IMM64(BPF_REG_3, (long)map_ptr),
> > +				};
> > +
> > +				insn_buf[0] = ld_addrs[0];
> > +				insn_buf[1] = ld_addrs[1];
> > +			}
> > +			insn_buf[2] = *insn;
> > +			cnt = 3;
> > +
> > +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
> > +			if (!new_prog)
> > +				return -ENOMEM;
> > +
> > +			delta    += cnt - 1;
> > +			env->prog = prog = new_prog;
> > +			insn      = new_prog->insnsi + i + delta;
> > +			goto patch_call_imm;
> > +		}
> > +
> > +		if (insn->imm == BPF_FUNC_timer_start) {
> > +			/* There is no need to do:
> > +			 *     aux = &env->insn_aux_data[i + delta];
> > +			 *     if (bpf_map_ptr_poisoned(aux)) return -EINVAL;
> > +			 * for bpf_timer_start(). If the same callback_fn is shared
> > +			 * by different timers in different maps the poisoned check
> > +			 * will return false positive.
> > +			 *
> > +			 * The verifier will process callback_fn as many times as necessary
> > +			 * with different maps and the register states prepared by
> > +			 * set_timer_start_callback_state will be accurate.
> > +			 *
> > +			 * There is no need for bpf_timer_start() to check in the
> > +			 * run-time that bpf_hrtimer->map stored during bpf_timer_init()
> > +			 * is the same map as in bpf_timer_start()
> > +			 * because it's the same map element value.
> 
> I am puzzled by above comments. Maybe you could explain more?
> bpf_timer_start() checked whether timer is initialized with timer->timer
> NULL check. It will proceed only if a valid timer has been
> initialized. I think the following scenarios are also supported:
>   1. map1 is shared by prog1 and prog2
>   2. prog1 call bpf_timer_init for all map1 elements
>   3. prog2 call bpf_timer_start for some or all map1 elements.
> So for prog2 verification, bpf_timer_init() is not even called.

Right. Such timer sharing between two progs is supported.
From prog2 pov the bpf_timer_init() was not called, but it certainly
had to be called by this or ther other prog.
I'll rephrase the last paragraph.

While talking to Martin about the api he pointed out that
callback_fn in timer_start() doesn't achieve the full use case
of replacing a prog. So in the next spin I'll split it into
bpf_timer_set_callback(timer, callback_fn);
bpf_timer_start(timer, nsec);
This way callback and prog can be replaced without resetting
timer expiry which could be useful.

Also Daniel and Andrii reminded that cpu pinning would be next
feature request. The api extensibility allows to add it in the future.
I'm going to delay implementing it until bpf_smp_call_single()
implications are understood.
