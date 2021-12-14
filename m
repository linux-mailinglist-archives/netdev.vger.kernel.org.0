Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302CB473AB5
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 03:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhLNCUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 21:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhLNCUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 21:20:17 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E927C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 18:20:17 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id e3so59087284edu.4
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 18:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=chLmVj5F9v7o8xwppcyYkXk9RedN5pKR5WdpbUeegJU=;
        b=P/QppK3RdMoDu6QZYv0XFavlDJPpKNfl+llVo6CUgDl8kiizOpu2Cqfe/2YiaBZDQ8
         RMB+tRMhdDweu88XzTDFDvAl2Ypa9g75sU0OkRPxOUE3fVUlAl/y6F2JbkHWVumsXuFm
         tEjQA3oxKsRCiHkrNldKzs70AfztRaRNyNLN7PV9gDwn65OuJgB0a3c65Rq/XneEKkRF
         rPc4ER5YChYxu7sBgvvYuchLcrLjv2FcceI4AdW38gg5qRB+CrngHCcurmS4mPLl9w0/
         MunSHjn57/Uk+RXFw3qIWilx+LzDPCHBm/FgEjlcxFHvcqC00cnqRv45DnuduQAmzZWb
         5CDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=chLmVj5F9v7o8xwppcyYkXk9RedN5pKR5WdpbUeegJU=;
        b=fsFTbHpL4DiEuB5lOvrc8aiFdYfXeCcPdYKfnqo3zoT8GuCNGo3NXkaWU+sSJ7nbik
         3t0S29lCeEDRJSrtyqwDA1uRYepIjaxUragoIorn0K+k7kPGUp9FBtpYE1OkmmCKAX6a
         8tnreZ1gqPi3qDL8dsWNXWElCG21waN7VY6vfY6NnVMM4x3ehAE640HNeQzDBQmv4vE7
         ZygiflWQR8Z8f/5uShaz4c8DOYv8IcZD43wbz8nkvBsCEXtQbRIB0P7NSoC6CEsTPltZ
         A43Vv0wkdnDK5GDVtBG3KawIUm9h5tCh5tGOk7ylQUJprvSfVBp8o+TOtkMoDVABne3h
         eFMQ==
X-Gm-Message-State: AOAM533frCjq8V0b0OOTebacFIevle2dFcL8IZCg5AyMdVaxCGax65f6
        NdQAEDZUPgBZuGwxwDwqsdv4d3Ln7YXc2BcqybA=
X-Google-Smtp-Source: ABdhPJyA1LPDxoWLUy+g+W/V7lKtmkRHIam7Q4hXFkAfEqpttgb4uvfTw9xbNS/DMl7RfD0Ly7Y2otY0K8j4D01FPYY=
X-Received: by 2002:a05:6402:2152:: with SMTP id bq18mr3644503edb.105.1639448415602;
 Mon, 13 Dec 2021 18:20:15 -0800 (PST)
MIME-Version: 1.0
References: <20211210023626.20905-1-xiangxia.m.yue@gmail.com>
 <20211210023626.20905-3-xiangxia.m.yue@gmail.com> <CAM_iQpVOuQ4C3xAo1F0pasPB5M+zUfviyYO1VkanvfYkq2CqNg@mail.gmail.com>
 <CAMDZJNUos+sb+Q1QTpDTfVDj7-RcsajcT=P6PABuzGuHCXZqHw@mail.gmail.com> <CAM_iQpU+JMtrObsGUwUwC8eoZ1G39Lvp7ihV2iERF5dg0FySXA@mail.gmail.com>
In-Reply-To: <CAM_iQpU+JMtrObsGUwUwC8eoZ1G39Lvp7ihV2iERF5dg0FySXA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 14 Dec 2021 10:19:39 +0800
Message-ID: <CAMDZJNXwOZUyJndHsOjjR-n-m1V2BkVh7xsvEOuj=tJ2OaVHbQ@mail.gmail.com>
Subject: Re: [net-next v3 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Cong Wang <xiyou.wangcong@gmail.com>
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

On Tue, Dec 14, 2021 at 6:53 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sat, Dec 11, 2021 at 6:34 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Sun, Dec 12, 2021 at 10:19 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Thu, Dec 9, 2021 at 6:36 PM <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > This patch allows users to select queue_mapping, range
> > > > from A to B. And users can use skb-hash, cgroup classid
> > > > and cpuid to select Tx queues. Then we can load balance
> > > > packets from A to B queue. The range is an unsigned 16bit
> > > > value in decimal format.
> > > >
> > > > $ tc filter ... action skbedit queue_mapping hash-type normal A B
> > > >
> > > > "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit") is
> > > > enhanced with flags:
> > > > * SKBEDIT_F_QUEUE_MAPPING_HASH
> > > > * SKBEDIT_F_QUEUE_MAPPING_CLASSID
> > > > * SKBEDIT_F_QUEUE_MAPPING_CPUID
> > >
> > > With act_bpf you can do all of them... So why do you have to do it
> > > in skbedit?
> > Hi Cong
> > This idea is inspired by skbedit queue_mapping, and skbedit is
> > enhanced by this patch.
>
> This is exactly my question. ;)
>
> > We support this in skbedit firstly in production. act_bpf can do more
> > things than this. Anyway we
> > can support this in both act_skbedit/acc_bpf. 1/2 is changed from
> > skip_tx_queue in skb to per-cpu var suggested-by Eric. We need another
> > patch which can change the
> > per-cpu var in bpf. I will post this patch later.
>
> The point is if act_bpf can do it, you don't need to bother skbedit at
> all. More importantly, you are enforcing policies in kernel, which is
> not encouraged. So unless you provide more details, this patch is not
> needed at all.
Hi Cong,
1. As I understand it, act_bpf can work with 1/2 patch(but we should
another path to change the skip_txqueue in bpf).
It is easy for kernel developer. But for another user, it is not easy.
tc command is a choice, and easy to use.
2. BTW, act_bpf can't try to instead act_xxx action in future even
though it can do more thing. right ?
3. This patch is more important to work with 1/2, and only enhance the
skbedit queue_mapping function. not a big change.
4. "policies" ? if selecting tx from a range(this patch) is what you
mean "policies", so change the skb mark, priority, tc-peidt
and other tc-action are "policies" too. we still need the different tc actions.
>
> Thanks.



-- 
Best regards, Tonghao
