Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651912C91B5
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730880AbgK3Wzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730868AbgK3Wzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:55:53 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45276C0613D4;
        Mon, 30 Nov 2020 14:55:13 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id t6so25114915lfl.13;
        Mon, 30 Nov 2020 14:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oHrYJR0Y0dJtQjn9b1Uu8e8y7F/jAGCGISIlJKPpGCI=;
        b=rwTwlZYoFc/ODgkaIZUsLLp8J4WNtN9WP3FNgjIwrjtYm7RcUNhTbpuTGWX2x+I7nS
         IsZ8KiGslYbkL06g3B6cHifhB76z45mDbtudMWQVUuevpNhcRMQCGHbWIAIgI2XgxyZP
         +GWuFnd+mFkgv9T+SOgfcOFLbWUbQDZdAkIpVU2W0zU7BIfRQs5CfAcRaDnNlP+EpDQu
         eKg1fqiMHO28dUYDp7o4a7uCzndKrRbHo9m1UPmMQ1mW8vKngjx4fsg5BSM7TyD0kGaa
         i40ddQwtUiMBTDPrhd4c6AUPa57YaQvdBXp0TbVJx+epH5Zu6f+Rn0ypQZNgGHH5gRsA
         H2tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oHrYJR0Y0dJtQjn9b1Uu8e8y7F/jAGCGISIlJKPpGCI=;
        b=F1YAmh4QNmBaG+lylZKCkI7yIWCWet5GXMa3UCSLe7+/lT05bDpe1Cpke5ah8yd+Mh
         oZZZ03uC7rWzUI+mTJ7HPMTQoG5fxS6gSBlii00ONfO18n20lEOB4/PLaUy4wrJpATKO
         rY8gtzQsFvIvuk/m2s20wdqIVauL3oSFrK1+D6N4Owrn3s0h4jB5XXdOEu75vfI89PL3
         Nmkl7jNXAFArWakoX0Mhl4EJ3RIRRr+m/8A5YTBZwiKaqkkxq+7XW+0FmkLIlHHqYw8d
         WPuC7v28FYzdH8xgG7DBongWISyX7/06etn/bP0K08d2ujcSirzTrNwZaIa8GLhLYYnO
         ph3A==
X-Gm-Message-State: AOAM533WUH5Hs8oL3y6cGRn6PtqybYHdV/zE7k9yl048372joG7tqjN/
        L3Hoa4WJDMSkcY6sDPNxTWi2dv9L8G8CVed0m58=
X-Google-Smtp-Source: ABdhPJwfYbtq962kEoxl9l6H9Iify7j7vxOpaM/ss1j5RqJ7L9w6b4ZS2wiQswqEYb5ygwsJ4jcxS+ZDz5BK5H9blHw=
X-Received: by 2002:a19:2390:: with SMTP id j138mr10718584lfj.390.1606776911738;
 Mon, 30 Nov 2020 14:55:11 -0800 (PST)
MIME-Version: 1.0
References: <20201121024616.1588175-1-andrii@kernel.org> <20201121024616.1588175-6-andrii@kernel.org>
 <20201129015934.qlikfg7czp4cc7sf@ast-mbp> <CAEf4BzbsN5GD62+nh7jMbdrWftATdJ57_3L_rgmG2-2=HXEV2w@mail.gmail.com>
In-Reply-To: <CAEf4BzbsN5GD62+nh7jMbdrWftATdJ57_3L_rgmG2-2=HXEV2w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 30 Nov 2020 14:55:00 -0800
Message-ID: <CAADnVQKYda2YxU8O-41HWbRFek-9USOOUBAZr71GALe9kVTQ5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/7] selftests/bpf: add tp_btf CO-RE reloc test
 for modules
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 2:52 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Nov 28, 2020 at 5:59 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Nov 20, 2020 at 06:46:14PM -0800, Andrii Nakryiko wrote:
> > >
> > >  SEC("raw_tp/bpf_sidecar_test_read")
> > > -int BPF_PROG(test_core_module,
> > > +int BPF_PROG(test_core_module_probed,
> > >            struct task_struct *task,
> > >            struct bpf_sidecar_test_read_ctx *read_ctx)
> > >  {
> > > @@ -64,3 +64,33 @@ int BPF_PROG(test_core_module,
> > >
> > >       return 0;
> > >  }
> > > +
> > > +SEC("tp_btf/bpf_sidecar_test_read")
> > > +int BPF_PROG(test_core_module_direct,
> > > +          struct task_struct *task,
> > > +          struct bpf_sidecar_test_read_ctx *read_ctx)
> >
> > "sidecar" is such an overused name.
>
> How about "sidekick"? :) Its definition matches quite closely for what
> we are doing with it ("person's assistant or close associate,
> especially one who has less authority than that person.")?
>
> But if you still hate it, I can call it just "bpf_selftest" or
> "bpf_test" or "bpf_testmod", however boring that is... ;)

bpf_testmod sounds the best to me :)
