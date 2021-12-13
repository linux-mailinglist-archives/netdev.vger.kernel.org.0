Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C157473806
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 23:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238972AbhLMWxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 17:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234858AbhLMWxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 17:53:36 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B356C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:53:36 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id d10so42082894ybe.3
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/SYcpd9bI2hyZwaAPP1X30HscFWwOZw4QHqN4po8k1k=;
        b=iilmJ/+aOdti6QzihhP+InswG6KBQLB8bDmy1NWXnrWh25z0alNFhRBs/PWaN2oEDJ
         D2vIQgDIPodGiW/81RSZ6gObdACnbDWMn1dXeTY0I40AhwvSPqLq9rV8jbbxxrpRD7Gu
         aJuZ690Yk+BBcXB5znk68fAkf3ay7ZIDvvnmACDY10J+VRuARz9jJHW2o/Onl5eReXz6
         m9+a41PPU3udyrRI/ZCAMIkkZPKIVR+sj0Led+vrqjVP3kOAk3S7wL45DnhLeK+afUyd
         k4CndcCLNl6NnqiCWh3I2vdEgpn973D49V1A5Dh5bZ9q9WOdhTi4Wz/nh5Mb1I0kqU7M
         PlKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/SYcpd9bI2hyZwaAPP1X30HscFWwOZw4QHqN4po8k1k=;
        b=uc/IaB3zPJ4BzbEc5aSD5Wz1I9+z8TKMv1xfHs5L6OK+E+3LyEU0KSMD6eUiABihgX
         xOG8F6Zp+DkQpCUjGyFK1I5+Btffed7sFEESAQ9RBELX06FQLoH1J33LkrEnJ/MIXwnt
         VJC7by/3kk7/AZXtq5PSrsY3TP5+ORvr7TsltyH5JcHfaCHImYEF/xB7KmkVzWTNey9A
         ZPtFiaZj5oe5PHDfMyS2noBIWl9LWfejMXEIIfoS33FRql0NjoKeuhkc7aSsV+flEnWc
         BZ7UR7cYQoYa9WZxw8HgRZ1rL9a+fAHCa8upkVL3Gguf31do0G7JRqyK+Qn9vWp42Q8l
         nGbg==
X-Gm-Message-State: AOAM531VFib+9Gnr5WqAEoPbmtn6LeIH9RpP6yJB8sIlAMESYPnoha6v
        9VQwbzYKIPsq34GQEqJSgMXW+Rw324AqbXa4O6E=
X-Google-Smtp-Source: ABdhPJxJwZHwuwRJVq+RUguc3KDdGi1PrixNsl+n5bSKH9gYAA+yVTNPnAagHi1GoiJl9bZXiGqsQAGETgFTrMgUU04=
X-Received: by 2002:a25:73cc:: with SMTP id o195mr1766211ybc.740.1639436015778;
 Mon, 13 Dec 2021 14:53:35 -0800 (PST)
MIME-Version: 1.0
References: <20211210023626.20905-1-xiangxia.m.yue@gmail.com>
 <20211210023626.20905-3-xiangxia.m.yue@gmail.com> <CAM_iQpVOuQ4C3xAo1F0pasPB5M+zUfviyYO1VkanvfYkq2CqNg@mail.gmail.com>
 <CAMDZJNUos+sb+Q1QTpDTfVDj7-RcsajcT=P6PABuzGuHCXZqHw@mail.gmail.com>
In-Reply-To: <CAMDZJNUos+sb+Q1QTpDTfVDj7-RcsajcT=P6PABuzGuHCXZqHw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 13 Dec 2021 14:53:25 -0800
Message-ID: <CAM_iQpU+JMtrObsGUwUwC8eoZ1G39Lvp7ihV2iERF5dg0FySXA@mail.gmail.com>
Subject: Re: [net-next v3 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 6:34 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Sun, Dec 12, 2021 at 10:19 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Thu, Dec 9, 2021 at 6:36 PM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > This patch allows users to select queue_mapping, range
> > > from A to B. And users can use skb-hash, cgroup classid
> > > and cpuid to select Tx queues. Then we can load balance
> > > packets from A to B queue. The range is an unsigned 16bit
> > > value in decimal format.
> > >
> > > $ tc filter ... action skbedit queue_mapping hash-type normal A B
> > >
> > > "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit") is
> > > enhanced with flags:
> > > * SKBEDIT_F_QUEUE_MAPPING_HASH
> > > * SKBEDIT_F_QUEUE_MAPPING_CLASSID
> > > * SKBEDIT_F_QUEUE_MAPPING_CPUID
> >
> > With act_bpf you can do all of them... So why do you have to do it
> > in skbedit?
> Hi Cong
> This idea is inspired by skbedit queue_mapping, and skbedit is
> enhanced by this patch.

This is exactly my question. ;)

> We support this in skbedit firstly in production. act_bpf can do more
> things than this. Anyway we
> can support this in both act_skbedit/acc_bpf. 1/2 is changed from
> skip_tx_queue in skb to per-cpu var suggested-by Eric. We need another
> patch which can change the
> per-cpu var in bpf. I will post this patch later.

The point is if act_bpf can do it, you don't need to bother skbedit at
all. More importantly, you are enforcing policies in kernel, which is
not encouraged. So unless you provide more details, this patch is not
needed at all.

Thanks.
