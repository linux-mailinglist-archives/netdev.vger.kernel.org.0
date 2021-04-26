Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB02636BC1E
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 01:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbhDZXiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 19:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237340AbhDZXiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 19:38:12 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA52C061574;
        Mon, 26 Apr 2021 16:37:30 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id p17so3914570plf.12;
        Mon, 26 Apr 2021 16:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X0op96Qd3v8XRVqIRIAuS/vAfP3V+wXGZaLSB8+cQF0=;
        b=RZSnR8eKOogb+NWaRG5k9Mzhbe99u16baMxD55e0g5nYMqkfuQgOGQeJMYSX+9ztNX
         uA17P54a7dbtOAX2LTWsX3raOCSYlr82GHXbw363667kaMXl6hMBtr7D8eks9Hl3iEtT
         0GcSAxkkNhNAn+6QMD4Bm6fgwNeNPFLnxWs+7DxnHCc/ukQEGYy5yy4aELJ/7p2brFUM
         qpkDgQhqqS+curxRVoEz/ZqpX8ZGpHfEBHVMHF/6XqYjuqL/Od/auZzdnDZlAz3omDY3
         /itnfFaEL2O1Z17YJuJHAkCgCH78Zy5yEBI8jGTHDR+CCf+TXXHxyBVw1FyGWqcJmhId
         iGCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X0op96Qd3v8XRVqIRIAuS/vAfP3V+wXGZaLSB8+cQF0=;
        b=T5whUw71m5sESFoqFUBuIby2Y3NCardqFZL4jFOPrPIzxv9vESMHdxSt6FpqXGiYd1
         kcNt3QmI7KUQzS5Ugz88bV0gCA/r/F06vsU3WQD4QYI7ANFfEHWdPNotL6lXtgdnL+oF
         uFyOAmKs5XK6IgTM20san0m75R3U/sD6ChFnw4HWUh26b2irr8ZeaKOUyx3nQ5QXCSsL
         OgxJCgsgCc53kNH2gSQ7XP7v1Ry+1Vkjs3U7vepUWsIkJadCHDJ6NDJTP2CaEXg4HYty
         quaX1qWd9LEZS6U/rfcvA+BmNrbgj81VnlCmV5+X00eyuyAgqpEbrAz/Oxx424zLN3Op
         5b4Q==
X-Gm-Message-State: AOAM533iLgm8Up6gz7RjTgHQt2pFGTNgzsXAKv3F0Zd7KLv3mpvc8FOX
        jfOb6EzS2dKUnPDz07tkrAHSuPrAXoiR18Z7jIU=
X-Google-Smtp-Source: ABdhPJwqDx8SWyd3BneHjbrGz+a22dhLwPfUWgCly3/ewyvx9UH8zJbIy6dCPDofWL30d3tM0+yMSaF/6PrlUk66qg0=
X-Received: by 2002:a17:90a:d347:: with SMTP id i7mr16864621pjx.231.1619480250105;
 Mon, 26 Apr 2021 16:37:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <20210402192823.bqwgipmky3xsucs5@ast-mbp> <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp> <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
 <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com> <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
In-Reply-To: <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 26 Apr 2021 16:37:19 -0700
Message-ID: <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 4:05 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Apr 26, 2021 at 4:00 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > Hi, Alexei
> >
> > On Wed, Apr 14, 2021 at 9:25 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Apr 14, 2021 at 9:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > Then how do you prevent prog being unloaded when the timer callback
> > > > is still active?
> > >
> > > As I said earlier:
> > > "
> > > If prog refers such hmap as above during prog free the kernel does
> > > for_each_map_elem {if (elem->opaque) del_timer().}
> > > "
> >
> > I have discussed this with my colleagues, sharing timers among different
> > eBPF programs is a must-have feature for conntrack.
> >
> > For conntrack, we need to attach two eBPF programs, one on egress and
> > one on ingress. They share a conntrack table (an eBPF map), and no matter
> > we use a per-map or per-entry timer, updating the timer(s) could happen
> > on both sides, hence timers must be shared for both.
> >
> > So, your proposal we discussed does not work well for this scenario.
>
> why? The timer inside the map element will be shared just fine.
> Just like different progs can see the same map value.

Hmm? In the above quotes from you, you suggested removing all the
timers installed by one eBPF program when it is freed, but they could be
still running independent of which program installs them.

In other words, timers are independent of other eBPF programs, so
they should not have an owner. With your proposal, the owner of a timer
is the program which contains the subprog (or callback) of the timer.
With my proposal, the timer callback is a standalone program hence has
no owner.

>
> Also if your colleagues have something to share they should be
> posting to the mailing list. Right now you're acting as a broken phone
> passing info back and forth and the knowledge gets lost.
> Please ask your colleagues to participate online.

They are already in CC from the very beginning. And our use case is
public, it is Cilium conntrack:
https://github.com/cilium/cilium/blob/master/bpf/lib/conntrack.h

The entries of the code are:
https://github.com/cilium/cilium/blob/master/bpf/bpf_lxc.c

The maps for conntrack are:
https://github.com/cilium/cilium/blob/master/bpf/lib/conntrack_map.h

Thanks.
