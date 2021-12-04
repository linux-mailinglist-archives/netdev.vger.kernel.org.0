Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCD84681D7
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344269AbhLDBqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhLDBqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 20:46:53 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2BEC061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 17:43:28 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id y13so18359566edd.13
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 17:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=knyhyXznFRpQyyPt6moupCBzK0yPBHeHOOSrfrRH+/c=;
        b=jpww7174Vpr1hqMgcYpXJ/PCumcDxWDk65JV3KulQemfdXc6k1fGewGpJ1i4Kvctl8
         w9KeA97JACfVn+meTrFDYKhNvzC996RShvTBrxU1DgXUGLem3Ns9NCIfFhZfbGjcWQFs
         fBCzMn+ZBhubylC0wGduCCsTbfvE2H+/PONlEerLz27oPUkB6QPPwspGfyENrT4/xfcT
         d56ichql2DSW87liE5ALBGPsi632wuta4LwyH0vwzqkma7dOEwv5WQipX89TmpYpxv6C
         VXDJajreVpgyIEvn1isoK0ZQG9k8ViEf71VuEM3y7XHkdKtt+XUvbqyd2hsysE65pdNL
         2GwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=knyhyXznFRpQyyPt6moupCBzK0yPBHeHOOSrfrRH+/c=;
        b=Ee9L0Fmkoe/NIQXfec9tNc5iiBQjZ4Abkhd7iLsX0QqiYtOtbMVtotxRKADXYVqOKh
         4POO3a/H5KFuHC0eao9+2xQeg4hLjYQC34yqNHSf/u/x4cWqGEE6oEmFIqcZhF3Lk6x7
         fXwkv2OfkrHJhbn3sSVx2sucOVgOtyA85YZA66iIU6ry/J0rz6y7H1bene5qrV9kSZ5w
         myc8zUO3rWiT2GAtMNvPri88JsTlb+7De07g7MGGCR88gQE9V+BCy9I90cKs01clx8M8
         YUrP8WZLnR+MJtQal5049GcxXLMrhT6T4GF026SXsI4d/tIZjIaAvSjBWXcrJDGvuxaZ
         rxEw==
X-Gm-Message-State: AOAM533zVi6eA5AscrDovMMQLGnj+onzs3UN+Jez7t4TBfmHhHkrZUPn
        SDVDQsFtYA1Dd7SGYGGRqs21K4eF8Ig3PYS4Rt8=
X-Google-Smtp-Source: ABdhPJzcyYe7aG0YvbjJVg31iHlKP1khGdpXtsjE2XQx4yOmnvyHgjv1nmYqoJ5nos80t/p9qfHeJr5sHg4P+WfR6sU=
X-Received: by 2002:a17:906:9144:: with SMTP id y4mr26459595ejw.98.1638582204807;
 Fri, 03 Dec 2021 17:43:24 -0800 (PST)
MIME-Version: 1.0
References: <20211202024723.76257-1-xiangxia.m.yue@gmail.com>
 <20211202024723.76257-3-xiangxia.m.yue@gmail.com> <518bd06a-490c-47f0-652a-756805496063@iogearbox.net>
In-Reply-To: <518bd06a-490c-47f0-652a-756805496063@iogearbox.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sat, 4 Dec 2021 09:42:48 +0800
Message-ID: <CAMDZJNUGyipTQgDv+M8_kiOEZwXJnivZo6KCwgYy_BoMOiEZew@mail.gmail.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 4, 2021 at 5:35 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 12/2/21 3:47 AM, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Try to resolve the issues as below:
> > * We look up and then check tc_skip_classify flag in net
> >    sched layer, even though skb don't want to be classified.
> >    That case may consume a lot of cpu cycles.
> >
> >    Install the rules as below:
> >    $ for id in $(seq 1 10000); do
> >    $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
> >    $ done
> >
> >    netperf:
> >    $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
> >    $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32
> >
> >    Before: 152.04 tps, 0.58 Mbit/s
> >    After:  303.07 tps, 1.51 Mbit/s
> >    For TCP_RR, there are 99.3% improvement, TCP_STREAM 160.3%.
>
> As it was pointed out earlier by Eric in v3, these numbers are moot since noone
> is realistically running such a setup in practice with 10k linear rules.
Yes. As I said in v1, in production, we use the 5+ prio. With this
patch, little improvements, 1.x%

This patch also fixes the packets loopback, if we use the bpf_redirect
to ifb in egress path.

-- 
Best regards, Tonghao
