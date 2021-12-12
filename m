Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E7B4717D8
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 03:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhLLCe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 21:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbhLLCe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 21:34:56 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9248C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 18:34:55 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z5so42235266edd.3
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 18:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HmlO8ji0lmrYYCji0X6NDJzAXQaqW9qrUQF709lcHUM=;
        b=hNoL8h4y/frCga+laoRjjQmm2gidF0Lw2QDozN3pEg0B8+BpCCiByFgSHqHKSjOj54
         C9zeubIK1ZORE1cduZwKS6Q5ZPtQflHBeJ5Mcy1M0mrvW9N3RSi8d+gSU22hBxYB+9Yn
         IN6W+jhbullTG8wpXp2nxj2+ZBi2PCeiplP8bNyZVPUAZZYC0p7ZgfVU7KUegOlr0xa6
         iOu8HOByVZsOHBPPtdeYsrST+z7TiMrTvtlCw3e/Z5dW/0SdV7T58wnDlFgTRhn/Q/fy
         seBicdI0HP30g1noinFiB7Tb6bMd5q6dMlpPFANaqb5cp8oqaNCt6y3eEoBRSXCZ2hJZ
         wkYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HmlO8ji0lmrYYCji0X6NDJzAXQaqW9qrUQF709lcHUM=;
        b=5TU+VJ5PtIi04IT5Aqyde1Bz73MDI4a5aCrCiCH6Fci6bYT7decHN0AboeCAWD9JGU
         4ArC1qU3Ra4um677AoOgShaQFOovcmjAO8qa7hlNZxk5skbHKEBK/CegWLBtFpPAZQjn
         e6wDW2yz+S6ib1KyUDWwsCdtMo25o4X6ld5yo2yrBMtSnRYHFiNUGoUNHYLu1pwDcaHO
         EL2b6dYgzRvNb1PCxqmczNFWVEPvQB5Gg7UdXejzkbr1UAfq4NbVyERpPJov5j/5Nxac
         6HVw0SB9m44cM//YjUb57JA2GSJO/sa0B7Nm93Qb62TVuFn+OTQldwqSVq/+32piK9eg
         3siQ==
X-Gm-Message-State: AOAM5328i1pWv8BBkYTz+8x/Y7VsXif/laxUvEsttMu+2ZH8ISpMfF87
        fGYC+c0eerGn69Pil7iUvEDKNsgL8ILAO6uLSm4=
X-Google-Smtp-Source: ABdhPJxUXDsV4orpPtW+E6iXHQH8GOR6x/vCgsE0tgMtwbx4R6+Rqy+x7KXMGZYq/gSYsltCuqcSy1NA/j091La/qKg=
X-Received: by 2002:a17:907:3f19:: with SMTP id hq25mr33087105ejc.225.1639276494338;
 Sat, 11 Dec 2021 18:34:54 -0800 (PST)
MIME-Version: 1.0
References: <20211210023626.20905-1-xiangxia.m.yue@gmail.com>
 <20211210023626.20905-3-xiangxia.m.yue@gmail.com> <CAM_iQpVOuQ4C3xAo1F0pasPB5M+zUfviyYO1VkanvfYkq2CqNg@mail.gmail.com>
In-Reply-To: <CAM_iQpVOuQ4C3xAo1F0pasPB5M+zUfviyYO1VkanvfYkq2CqNg@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sun, 12 Dec 2021 10:34:18 +0800
Message-ID: <CAMDZJNUos+sb+Q1QTpDTfVDj7-RcsajcT=P6PABuzGuHCXZqHw@mail.gmail.com>
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

On Sun, Dec 12, 2021 at 10:19 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Dec 9, 2021 at 6:36 PM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This patch allows users to select queue_mapping, range
> > from A to B. And users can use skb-hash, cgroup classid
> > and cpuid to select Tx queues. Then we can load balance
> > packets from A to B queue. The range is an unsigned 16bit
> > value in decimal format.
> >
> > $ tc filter ... action skbedit queue_mapping hash-type normal A B
> >
> > "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit") is
> > enhanced with flags:
> > * SKBEDIT_F_QUEUE_MAPPING_HASH
> > * SKBEDIT_F_QUEUE_MAPPING_CLASSID
> > * SKBEDIT_F_QUEUE_MAPPING_CPUID
>
> With act_bpf you can do all of them... So why do you have to do it
> in skbedit?
Hi Cong
This idea is inspired by skbedit queue_mapping, and skbedit is
enhanced by this patch.
We support this in skbedit firstly in production. act_bpf can do more
things than this. Anyway we
can support this in both act_skbedit/acc_bpf. 1/2 is changed from
skip_tx_queue in skb to per-cpu var suggested-by Eric. We need another
patch which can change the
per-cpu var in bpf. I will post this patch later.


-- 
Best regards, Tonghao
