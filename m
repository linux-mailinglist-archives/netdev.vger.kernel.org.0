Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB981FC232
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 01:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgFPXUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 19:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPXUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 19:20:14 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7CAC06174E
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 16:20:14 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id d12so189909qvn.0
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 16:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ydEIvhIlb7ovVI3Xf7h9v7BiGXq3AQvutaYsjp4Texs=;
        b=ZlJPiZtn4IBK8cMZY1UsbSNbCNAbfV+Jz/6SBXYZaE6/xOjWjBsO3S/ali4J3aBhgr
         PxuGjtiRC40R+LZE/NJ7CVdegcwKU2hjYHs+EFCc3x3lU5ZBiIlwJ1G/yyKpfQ2oIZbM
         GZHocRPFoCG9tJ5yVcqMZ8t6brtS1insmxk7lcltomIzJ15upUtwiOGy2MT6B0Em4RHN
         uiXbIHtHTRjW7MNsvN+EWgxsyMR7yWxZghnphLRGR2cbeRkIGmA+5OfV5da+OrrThV5z
         zv46ItWLnHGZ44h40UzEb8hBx5hMlzcXcqyAZf1cfHLTNPxmB62dAa8K4W+gEqrNlMh9
         PSvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ydEIvhIlb7ovVI3Xf7h9v7BiGXq3AQvutaYsjp4Texs=;
        b=LoSXxooirXs7blf0v5GmeVL9zpeeZK2Ol7eOf2tOeCpB6t8jEvLAVXA2/O7OIHDBsy
         qtmLv+cSrYj1O4lHHiEepIZQ6uGSZgox4vfP3cO9Rt7JKq8XcRT4kp+gztIaXV7txH4c
         T0qsGGoAF/zUZOesZRJuQkpQw3BC0sRDHkCJVfPNB62Bbcfm6ehC7BglP/NSY4g8i4l9
         hPJ8vhTaO2L4XRYzb3ARXp9dGRdDcZbRwl+36tVzGAZECqxZYhIF6Bhsb5m4raRS/HSu
         ZwD6EDafrS6WJ1vEUKwizHGvYSbUC6I6XQP5AYrBlPUsCKsgGOnmY22KDFuKjvYBu9dA
         Oi0g==
X-Gm-Message-State: AOAM5321VadDKuG/gvK83Ieoazo6TOPT9VZShydpqITpxzVMP7D55z2g
        5xZsRyjCmGJiELArqnv+8aTqzyG+XuYvVImu9rwN+g==
X-Google-Smtp-Source: ABdhPJxd5+ZpJ8GjVcVCEZ1v1WeHVdV9UTZFumqfLL/JQrqofc8zuLTAJrBCUN8dxMgEM3UaxU6R3qWb2KzOk5eSmsE=
X-Received: by 2002:ad4:4732:: with SMTP id l18mr4912831qvz.43.1592349612894;
 Tue, 16 Jun 2020 16:20:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200608182748.6998-1-sdf@google.com> <20200613003356.sqp6zn3lnh4qeqyl@ast-mbp.dhcp.thefacebook.com>
 <CAKH8qBuJpks_ny-8MDzzZ5axobn=35P3krVbyz2mtBBtR8Uv+A@mail.gmail.com>
 <20200613035038.qmoxtf5mn3g3aiqe@ast-mbp> <CAKH8qBvUv_OwjFA70JQfL-rET662okH87QYyeivbybCPwCEJEQ@mail.gmail.com>
 <20200616230355.hzipb7hly3fo5moc@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200616230355.hzipb7hly3fo5moc@ast-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 16 Jun 2020 16:20:01 -0700
Message-ID: <CAKH8qBsak9E45d-znh9-4NQ4aSS_qta1_v0wEv-to=8Rc1-R0Q@mail.gmail.com>
Subject: Re: [PATCH bpf v3 1/2] bpf: don't return EINVAL from {get,set}sockopt
 when optlen > PAGE_SIZE
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 4:04 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jun 15, 2020 at 09:41:38AM -0700, Stanislav Fomichev wrote:
> > On Fri, Jun 12, 2020 at 8:50 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > [ .. ]
> > > > > It's probably ok, but makes me uneasy about verifier consequences.
> > > > > ctx->optval is PTR_TO_PACKET and it's a valid pointer from verifier pov.
> > > > > Do we have cases already where PTR_TO_PACKET == PTR_TO_PACKET_END ?
> > > > > I don't think we have such tests. I guess bpf prog won't be able to read
> > > > > anything and nothing will crash, but having PTR_TO_PACKET that is
> > > > > actually NULL would be an odd special case to keep in mind for everyone
> > > > > who will work on the verifier from now on.
> > > > >
> > > > > Also consider bpf prog that simply reads something small like 4 bytes.
> > > > > IP_FREEBIND sockopt (like your selftest in the patch 2) will have
> > > > > those 4 bytes, so it's natural for the prog to assume that it can read it.
> > > > > It will have
> > > > > p = ctx->optval;
> > > > > if (p + 4 > ctx->optval_end)
> > > > >  /* goto out and don't bother logging, since that never happens */
> > > > > *(u32*)p;
> > > > >
> > > > > but 'clever' user space would pass long optlen and prog suddenly
> > > > > 'not seeing' the sockopt. It didn't crash, but debugging would be
> > > > > surprising.
> > > > >
> > > > > I feel it's better to copy the first 4k and let the program see it.
> > > > Agreed with the IP_FREEBIND example wrt observability, however it's
> > > > not clear what to do with the cropped buffer if the bpf program
> > > > modifies it.
> > > >
> > > > Consider that huge iptables setsockopts where the usespace passes
> > > > PAGE_SIZE*10 optlen with real data and bpf prog sees only part of it.
> > > > Now, if the bpf program modifies the buffer (say, flips some byte), we
> > > > are back to square one. We either have to silently discard that buffer
> > > > or reallocate/merge. My reasoning with data == NULL, is that at least
> > > > there is a clear signal that the program can't access the data (and
> > > > can look at optlen to see if the original buffer is indeed non-zero
> > > > and maybe deny such requests?).
> > > > At this point I'm really starting to think that maybe we should just
> > > > vmalloc everything that is >PAGE_SIZE and add a sysclt to limit an
> > > > upper bound :-/
> > > > I'll try to think about this a bit more over the weekend.
> > >
> > > Yeah. Tough choices.
> > > We can also detect in the verifier whether program accessed ctx->optval
> > > and skip alloc/copy if program didn't touch it, but I suspect in most
> > > case the program would want to read it.
> > > I think vmallocing what optlen said is DoS-able. It's better to
> > > stick with single page.
> > > Let's keep brainstorming.
> > Btw, can we use sleepable bpf for that? As in, do whatever I suggested
> > in these patches (don't expose optval>PAGE_SIZE via context), but add
> > a new helper where you can say 'copy x bytes from y offset of the
> > original optval' (the helper will do sleepable copy_form_user).
> > That way we have a clean signal to the BPF that the value is too big
> > (optval==optval_end==NULL) and the user can fallback to the helper to
> > inspect the value. We can also provide another helper to export new
> > value for this case.
>
> sleepable will be read-only and with toctou.
> I guess this patch is the least evil then ?
> But I'm confused with the test in patch 2.
> Why does it do 'if (optval > optval_end)' ?
> How is that possible when patch 1 makes them equal.
Right, it should really be 'optval < optval_end', good point!
I want to make sure in the BPF program that we can't access the buffer
(essentially return EPERM to the userpace so the test fails).
Will fix in a follow up.

> may be another idea:
> allocate 4k, copy first 4k into it, but keep ctx.optlen as original.
> if bpf prog reads optval and finds it ok in setsockopt,
> it can set ctx.optlen = 0
> which would mean run the rest of setsockopt handling with original
> '__user *optval' and ignore the buffer that was passed to bpf prog.
> In case of ctx.optlen < 4k the behavior won't change from bpf prog
> and from kernel pov.
> When ctx.optlen > 4k and prog didn't adjust it
> __cgroup_bpf_run_filter_setsockopt will do ret = -EFAULT;
> and reject sockopt.
> So bpf prog would be force to do something with large optvals.
> yet it will be able to examine first 4k bytes of it.
> It's a bit of change in behavior, but I don't think bpf prog is
> doing ctx.optlen = 0, since that's more or less the same as
> doing ctx.optlen = -2.
> or may be use some other indicator ?
> And do something similar with getsockopt.
Good suggestion! That sounds doable in theory, let me try and see if I
hit something unexpected.
I suppose trimming provided optval to zero (optlen=0) is not something
that sensible programs would do?

In this case please ignore the v4 I posted recently!
