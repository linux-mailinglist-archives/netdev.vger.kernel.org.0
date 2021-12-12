Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3584717D0
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 03:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbhLLCTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 21:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbhLLCTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 21:19:14 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB20C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 18:19:14 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id y68so30302959ybe.1
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 18:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+gV0IDMlbCT/bGgGL1TwKuv+1OIOf5UhqPYKCBF1dSg=;
        b=dsHddEOXp8F6F9o7L805ifAIeRmWXP+Nz/Bm33jkc8VTAALCJudfdYp+1nzOQdOhBI
         XRIiYLzWj6JItWqrbN7O0/KeTw+EbWjOVD9j0b3UVF2o4AZKw8BuEt1F5ot20hZrvSRb
         hfV5qrmtKm5VySHaIn+pWBahukRC3aFZ4nWEln+jyfcPnr/9cTBOBoERKOeZedLNXiNT
         hTfJJS4AnPFKJvRKiUSPqAWbqjfpAzeqrBTMrJALQw5NCOvcvVthPIcV5U8Ke2WbP/tb
         aVJeWTITn3uEX6+uhWDHe3SUh5z6bjGTsGgz3rfYzXUR9wA85MgiDxShwH3XfECAWQ27
         0XQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+gV0IDMlbCT/bGgGL1TwKuv+1OIOf5UhqPYKCBF1dSg=;
        b=wYIiaViH4xxtAhYsVapJf/BpKXN1oCho4hK40sZ88SnfiD9CiYXTfDgsRYg07KzdqF
         NVLVQMHV1QslHn1qJtGbokbdU52rZOGaITMIWJj2plowNNjh07vaJgTONug0v1skLv8x
         c6MK7msBZurT60PFZ8q1Ddw+L1cmiOAOzuX+OPoo7FjkV94vAhjmCNM9egSDAkUS0+vW
         gQ3Q/56C2k81axaO/yKxlOoTt85moDG7wngGIaoIX4qyEZNhXGYjQim+J1fkefu6Ir0F
         /tn7xn+ENst6J+8Xyu9ljGjvxNgLig6TM3pfOSTTkfxqYc7cyvtzVIF/mOlgRNbf19F8
         PARQ==
X-Gm-Message-State: AOAM530t9vTnKoydpvj8cvIHbVjitQaxA6FLvMfM5Z8I4kqTzDy0+t15
        m4IbLiPLHAJlqSh00jmpXlGhCMJ4xX1gsn1RV/g=
X-Google-Smtp-Source: ABdhPJzp9CsmuOvQi+1PSYYQ7q8tqiuH1uL979obrnLWudXhneZ+ehSEfobYNqrMdw4/7CAVHnxqhgc5nluNS9h6epg=
X-Received: by 2002:a25:73cc:: with SMTP id o195mr25994541ybc.740.1639275553892;
 Sat, 11 Dec 2021 18:19:13 -0800 (PST)
MIME-Version: 1.0
References: <20211210023626.20905-1-xiangxia.m.yue@gmail.com> <20211210023626.20905-3-xiangxia.m.yue@gmail.com>
In-Reply-To: <20211210023626.20905-3-xiangxia.m.yue@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 11 Dec 2021 18:19:03 -0800
Message-ID: <CAM_iQpVOuQ4C3xAo1F0pasPB5M+zUfviyYO1VkanvfYkq2CqNg@mail.gmail.com>
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

On Thu, Dec 9, 2021 at 6:36 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This patch allows users to select queue_mapping, range
> from A to B. And users can use skb-hash, cgroup classid
> and cpuid to select Tx queues. Then we can load balance
> packets from A to B queue. The range is an unsigned 16bit
> value in decimal format.
>
> $ tc filter ... action skbedit queue_mapping hash-type normal A B
>
> "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit") is
> enhanced with flags:
> * SKBEDIT_F_QUEUE_MAPPING_HASH
> * SKBEDIT_F_QUEUE_MAPPING_CLASSID
> * SKBEDIT_F_QUEUE_MAPPING_CPUID

With act_bpf you can do all of them... So why do you have to do it
in skbedit?
