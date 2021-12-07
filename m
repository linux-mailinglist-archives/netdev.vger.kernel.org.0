Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F145446B085
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240154AbhLGCUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238230AbhLGCUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 21:20:53 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3032C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 18:17:23 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id x15so51081715edv.1
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 18:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VffKsRiIsMsg462/uxEVFJk9Zzwb5ztfVAwjZJXN+g4=;
        b=cLzOFm+/r55T8LatvKnVm6ViAsMzBJoH2ErVHWTODk5XQ+Krobf8lh5uze7LHmWYLG
         zaBkis2vD+oomfj1wpcKX5WL2WBDVm5r2RfCdjgMRTVCcoWyPVKJlOWoYT0f1s6pZy8i
         FgFsvKg/BvMN1VLw+pyIC35bO8gGdE6fxg2wsOpDxhMHITQ872otTc/fTcYjur4X989I
         ohoZ6LeRhi0homA2k9xFDSMIAv/bVoXeZyztln7pCmREP4ZCWjESQmwBYlzXBOf8DaA8
         5HyMyHVWaA/MyLHM4BYOyfkz+FUDsOWYOQFj80MyMaPDR+bF7KJo2SRacyocmPtaMtcx
         uM2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VffKsRiIsMsg462/uxEVFJk9Zzwb5ztfVAwjZJXN+g4=;
        b=fA4v3O6WNA13WdiTRyQ/6gJkB9j8rrU69WNtCFwIfNCYLjukdMnwR0VP42JSByhRMj
         cTA4qRSqxisETqiwWZI75ZoPiVYSLZ/woe7693w5mqpPR42Csd43c/fAXKMwh3Os3sXV
         krRhVTexVPwUIvrBB4JCATsduBmZyOJJSzB/7ogp7U96n4XTGIsRP+7IPOhSIO8jJ+Ke
         jD/QZdpmjclZpfXKqPfH1rsWp34+FdeSvhHFCCLbEeihBxcL21BcxFqz7r63fMMSr/R3
         mSYfkU9QNzn3zyNsuMozTv+ULh2fpuv+8Vme57wDdKayHpSSWq0DlA9ft5I9yZvequTB
         XpCw==
X-Gm-Message-State: AOAM533uNlfKoGgVSFkL78pqTmBRCl6bW/tp+BJvmH1VxQtEEVC6wvZv
        L/t+W8qeX7925CDBych7MUNlQHZEHNc6y7/3e48=
X-Google-Smtp-Source: ABdhPJyCSOVBbL8B8D0YH6Z6XLxTisB6X1VC4/vLPX80r6qccPWVkk5ny4FeKAirJaIVV6qrCQhExTu1uXk2vuRmhZ4=
X-Received: by 2002:a05:6402:4407:: with SMTP id y7mr4505038eda.140.1638843442294;
 Mon, 06 Dec 2021 18:17:22 -0800 (PST)
MIME-Version: 1.0
References: <20211202024723.76257-1-xiangxia.m.yue@gmail.com>
 <20211202024723.76257-3-xiangxia.m.yue@gmail.com> <518bd06a-490c-47f0-652a-756805496063@iogearbox.net>
 <CAMDZJNUGyipTQgDv+M8_kiOEZwXJnivZo6KCwgYy_BoMOiEZew@mail.gmail.com>
In-Reply-To: <CAMDZJNUGyipTQgDv+M8_kiOEZwXJnivZo6KCwgYy_BoMOiEZew@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 7 Dec 2021 10:16:44 +0800
Message-ID: <CAMDZJNWx=MzSxB19JG_gmffmJrdLQ_cBzJhVYtor1EMb-DujXw@mail.gmail.com>
Subject: Re: [net v4 2/3] net: sched: add check tc_skip_classify in sch egress
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 4, 2021 at 9:42 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wro=
te:
>
> On Sat, Dec 4, 2021 at 5:35 AM Daniel Borkmann <daniel@iogearbox.net> wro=
te:
> >
> > On 12/2/21 3:47 AM, xiangxia.m.yue@gmail.com wrote:
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > Try to resolve the issues as below:
> > > * We look up and then check tc_skip_classify flag in net
> > >    sched layer, even though skb don't want to be classified.
> > >    That case may consume a lot of cpu cycles.
> > >
> > >    Install the rules as below:
> > >    $ for id in $(seq 1 10000); do
> > >    $       tc filter add ... egress prio $id ... action mirred egress=
 redirect dev ifb0
> > >    $ done
> > >
> > >    netperf:
> > >    $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
> > >    $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32
> > >
> > >    Before: 152.04 tps, 0.58 Mbit/s
> > >    After:  303.07 tps, 1.51 Mbit/s
> > >    For TCP_RR, there are 99.3% improvement, TCP_STREAM 160.3%.
> >
> > As it was pointed out earlier by Eric in v3, these numbers are moot sin=
ce noone
> > is realistically running such a setup in practice with 10k linear rules=
.
> Yes. As I said in v1, in production, we use the 5+ prio. With this
> patch, little improvements, 1.x%
>
> This patch also fixes the packets loopback, if we use the bpf_redirect
> to ifb in egress path.
Hi Daniel, Eric
What should I do next=EF=BC=9FThis patch try to fix the bug, and improve th=
e
performance(~1% in production).
Should I update the commit message and send v5?
> --
> Best regards, Tonghao



--=20
Best regards, Tonghao
