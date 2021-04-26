Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF1B36BBED
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 01:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhDZXGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 19:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbhDZXGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 19:06:12 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B327DC061574;
        Mon, 26 Apr 2021 16:05:29 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 12so90506070lfq.13;
        Mon, 26 Apr 2021 16:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BPMH6qNaKQjMxsNZAGHPh/aPPkLS9VEfERR1tAOwa90=;
        b=HidwbhW0uz2cWvkJRBxcwFH5R6NwBjOZd5gxDgtJeuSZP3iGwinU2fzECW2NVZhONv
         lZh5tb62flYTAeV2zzNK8znTezdyo1Cw3Qyp5WMfj7cG0+zmTKAlO0A0YvyxuoLO+ZyJ
         85uI9+6JDluZXdQ7lUADm7Rj6RQ3gIWyzy1Z9/bg9IzAN6hOxuoXYGziqxPnYcLNDqRg
         eC069t++GMr20DAFADJvqi11s4tBZ3/9B59Hv5FlVYIgY5uFwsKdiNyZ66eRO/3ZMnDo
         Q4Kg6Ceb5ajR7rGTuaDVcxrJPSFXD/d+nbl/azeO8pgADSFZskc+bCBDkx6/mNtoG49R
         SaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BPMH6qNaKQjMxsNZAGHPh/aPPkLS9VEfERR1tAOwa90=;
        b=DR2Rnkq2KIZFbJ7Rtqcj1106lLr5oETub66N0ai6zBt5IVnrXk/HFbb1npqe362blI
         qoi7cyCZK4cAcLUhzHj+ceYM0/9gZV8q1DeQB7TnEgqXXPLfRE8nK2fBDYYxRRnlduFX
         OHe77aocmSucJGkAXUD9oO5Y4iyw8kVPps8mUp59QPA0cK1V+9qyamK4gj9/vHUsKAyG
         nRq6WKOu6CB6QqpBiIoDUqB5Zl6OsOI05msmrwqBHtWTZircNHAGf7/1X30HDLvOTOqn
         Zqhm72B1hSW9jGIvo+alIxPOKjwjiheRD2dcto8R1lLzbs9dOZC8nYoOv8+Z83tvp4We
         xeiQ==
X-Gm-Message-State: AOAM532sgn7SjhJxgZuJEhN99dZ/rn84Rafl/0JGrn0XM1XyvG+mkzck
        3bpspq6OLKr6WMhde2tzU4IreuazgteYg0ChSWyjBmmh
X-Google-Smtp-Source: ABdhPJzfuFjO9Q2MasxXjn/Wu2vRoWyG8OV04TwpXB4PVnm/cu+MIqWbsCkoNbOGy0/aUpXd0oDXCYNa/+RiHvTgnGQ=
X-Received: by 2002:ac2:510d:: with SMTP id q13mr14810246lfb.75.1619478328130;
 Mon, 26 Apr 2021 16:05:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <20210402192823.bqwgipmky3xsucs5@ast-mbp> <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp> <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com> <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
In-Reply-To: <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 26 Apr 2021 16:05:16 -0700
Message-ID: <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Cong Wang <xiyou.wangcong@gmail.com>
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

On Mon, Apr 26, 2021 at 4:00 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Hi, Alexei
>
> On Wed, Apr 14, 2021 at 9:25 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Apr 14, 2021 at 9:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > Then how do you prevent prog being unloaded when the timer callback
> > > is still active?
> >
> > As I said earlier:
> > "
> > If prog refers such hmap as above during prog free the kernel does
> > for_each_map_elem {if (elem->opaque) del_timer().}
> > "
>
> I have discussed this with my colleagues, sharing timers among different
> eBPF programs is a must-have feature for conntrack.
>
> For conntrack, we need to attach two eBPF programs, one on egress and
> one on ingress. They share a conntrack table (an eBPF map), and no matter
> we use a per-map or per-entry timer, updating the timer(s) could happen
> on both sides, hence timers must be shared for both.
>
> So, your proposal we discussed does not work well for this scenario.

why? The timer inside the map element will be shared just fine.
Just like different progs can see the same map value.

Also if your colleagues have something to share they should be
posting to the mailing list. Right now you're acting as a broken phone
passing info back and forth and the knowledge gets lost.
Please ask your colleagues to participate online.
