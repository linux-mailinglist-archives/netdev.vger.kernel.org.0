Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909B1380231
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 04:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhENCyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 22:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhENCyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 22:54:50 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C5BC061574;
        Thu, 13 May 2021 19:53:39 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id i5so18404784pgm.0;
        Thu, 13 May 2021 19:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J5IurG2LaPoI6GLjY84j9lFhYUx5eDvCmRkvT3NLakQ=;
        b=IJPo7Fit6um8lRdzq7QCII9iH7pHFiu7X/3Bf47lTQhxumxQzb5+SM/1wHayf4t+OX
         qp4XX7HvEG3R1jCseK0f8eXLy7uGzsRjvnUQIgm88dBg+hHQc7pFXwAH8kdpsiOaDWk1
         ZERt6fD13BXiPLgGVM829CoxkV32clTSAjBZvmjC8od2GetoM9h3vyXReXb/U0ircXqc
         NGxCfhuEkoL2TDagRK9b3irE3UyPhrgMYs3YO2uqblBkQqCK++Z12+kFmWs0Jb5sqhnC
         tUdgGUR5BltyoMT6imvD4vYyuB3m4Yj+0wOB9P13kHfeDTdTkl0GMGaMDPFQIs2RxuP2
         uV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J5IurG2LaPoI6GLjY84j9lFhYUx5eDvCmRkvT3NLakQ=;
        b=tCs82l97utyCSiuYB6912ZJjqoulpDbldWXY/k+BBucMsYLIT1b/Z878+x2yRiDczG
         QViwSKc//C43+MmJ27GjPfALqD4BcoZr2ze1t1SHqRWCRW2XyVJRGdffwkdG1RAmAgT7
         xhRwKBLdG4w7knWpTORTCyoBIYRppoGsWbE81JrFv2FhXQD4lqJ2dhMiWf1jnjgIuIpA
         8qGyAaGyxQoAIWwZQxZnksB2XY2lv2/Vr88uIJEtHFX1wcbB58UqxjbQgaQXiw2ggRV0
         TMdXTLHn4V9uq25rnnMFOoKToVDM30BpQZFy9byS5DnsZ4wdU5/ATtbX2+TjcyQhML8b
         +cGw==
X-Gm-Message-State: AOAM533kQEzjalrUwuUamSgB/Xd1HrfJsOkGQbWYFw+Z3ViFut3Wxt8m
        19v9u6YZgqwvkJTfSFIK+3pZKGBTnEt3wtyGyxo=
X-Google-Smtp-Source: ABdhPJxo8AxTvMJcCnN/DXqEdcGwYlofZ4pY714CNaHCz3dtzLNg63DrCjykVhx9VN4Tb3fD+HcI1CBR6ASpi+hJOJo=
X-Received: by 2002:a65:45c3:: with SMTP id m3mr43861900pgr.179.1620960818551;
 Thu, 13 May 2021 19:53:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210402192823.bqwgipmky3xsucs5@ast-mbp> <20210402234500.by3wigegeluy5w7j@ast-mbp>
 <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
 <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
 <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
 <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com>
 <20210427020159.hhgyfkjhzjk3lxgs@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpVE4XG7SPAVBmV2UtqUANg3X-1ngY7COYC03NrT6JkZ+g@mail.gmail.com>
 <CAADnVQK9BgguVorziWgpMktLHuPCgEaKa4fz-KCfhcZtT46teQ@mail.gmail.com>
 <CAM_iQpWBrxuT=Y3CbhxYpE5a+QSk-O=Vj4euegggXAAKTHRBqw@mail.gmail.com>
 <CAOftzPh0cj_XRES8mrNWnyKFZDLpRez09NAofmu1F1JAZf43Cw@mail.gmail.com>
 <ac30da98-97cd-c105-def8-972a8ec573d6@mojatatu.com> <e51f235e-f5b7-be64-2340-8e7575d69145@mojatatu.com>
In-Reply-To: <e51f235e-f5b7-be64-2340-8e7575d69145@mojatatu.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 13 May 2021 19:53:27 -0700
Message-ID: <CAM_iQpX=Qk6GjxB=saTpbo4Oc1KBxK2tU5N==HO_LimiOEtoDA@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Joe Stringer <joe@cilium.io>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
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
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 11:46 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2021-05-12 6:43 p.m., Jamal Hadi Salim wrote:
>
> >
> > Will run some tests tomorrow to see the effect of batching vs nobatch
> > and capture cost of syscalls and cpu.
> >
>
> So here are some numbers:
> Processor: Intel(R) Xeon(R) Gold 6230R CPU @ 2.10GHz
> This machine is very similar to where a real deployment
> would happen.
>
> Hyperthreading turned off so we can dedicate the core to the
> dumping process and Performance mode on, so no frequency scaling
> meddling.
> Tests were ran about 3 times each. Results eye-balled to make
> sure deviation was reasonable.
> 100% of the one core was used just for dumping during each run.

I checked with Cilium users here at Bytedance, they actually observed
100% CPU usage too.

>
> bpftool does linear retrieval whereas our tool does batch dumping.
> bpftool does print the dumped results, for our tool we just count
> the number of entries retrieved (cost would have been higher if
> we actually printed). In any case in the real setup there is
> a processing cost which is much higher.
>
> Summary is: the dumping is problematic costwise as the number of
> entries increase. While batching does improve things it doesnt
> solve our problem (Like i said we have upto 16M entries and most
> of the time we are dumping useless things)

Thank you for sharing these numbers! Hopefully they could convince
people here to accept the bpf timer. I will include your use case and
performance number in my next update.
