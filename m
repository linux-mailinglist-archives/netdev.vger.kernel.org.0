Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF73E491371
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 02:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238826AbiARBdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 20:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238732AbiARBdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 20:33:50 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E9AC061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 17:33:49 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id 15so39644456edx.9
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 17:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OZe0YYww3ayjsiup/9HXJDpddM+ZpnxmgAGFx4WXQoE=;
        b=ARW7DR9hy+P/cDNNp0PFJg/18d6Hpj7AiZwEex7vHULLosxOD4nzs9ap/Tx80x+pGk
         2Dk2wWYWMXD8kyvi2XWYpsm8mP8qjnlZv9TiQ0pzwNQvllD1ZpSPwsuQJl/qta3q0NG6
         UgNiWRs7Rf0BGC5CUiPhzAJoFPWw7ez8POigC4U2Z8hm9InV44SAPGuvkPAMBR9+M+Ar
         aBb9ZNvUyWX1V8mdtf0A7IxSGCygTCW7vKeWirVtcjxN4m7AIgxuKZ/UEWT7WIzWvA05
         4vwzSHoC1x9OYPA3v0qosdw33N7jUSFp2JpmPRjWv6xuUG5L8uLZTeNSQNRSEhi3kdZV
         PfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OZe0YYww3ayjsiup/9HXJDpddM+ZpnxmgAGFx4WXQoE=;
        b=KL+cGjlUHCHwXw1/k6E5+GKJXsnGVTjAVHrcNaKVAMhg5dnqCnqy5V7fwqkS/MPbgX
         tyDdo+RZ/sDMDOu6NX4iYKYNmbCy+RAQqy8hKIyiZpmg0YHAPxjOznosxv10GneCTyQ3
         hwZyK4bvHdCh7sR9nCw20PsTSU5xtsIqd5fX8p5QLn9neiDar3JRieMfZavfKm4RIve8
         B2pc9MO3TJfj5FQ6EvrWfhNMQhzcffpljoVnrgnJ67nG89OnMpzcUwrH0PsC4juqjZpj
         qhCrRD1DktZ/9WyjITLghmNbcC9p89HZ/Y9ApiQZrKrFp2ImTuAD6lyrEFojpRUya3Nj
         9wjQ==
X-Gm-Message-State: AOAM531Xm0ZUXJDfDhSOjnz6jNf2BjPOYAxwNk5wayn770+BtdjnSnns
        UygoqWfozopIAGYuK1je/apKgz+0SbHQ0dlAfINesPTSfWF+yw==
X-Google-Smtp-Source: ABdhPJyKbE6Koy8DsnQ0cqWVQ4XH/QwVUoTASi8RLu/YxmYw0fuCJWc4dcl/zPRJPfOkntiCxIwL+Hi/9qn5pFhPOzI=
X-Received: by 2002:a50:fe89:: with SMTP id d9mr23526973edt.252.1642469628001;
 Mon, 17 Jan 2022 17:33:48 -0800 (PST)
MIME-Version: 1.0
References: <20220107115130.51073-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20220107115130.51073-1-xiangxia.m.yue@gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 18 Jan 2022 09:33:02 +0800
Message-ID: <CAMDZJNX5oO_Xu2ngCX8T41XH_uM62VZ1kTDEEMc9r3taEBiewQ@mail.gmail.com>
Subject: Re: [net-next RESEND v7 0/2] net: sched: allow user to select txqueue
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
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

On Fri, Jan 7, 2022 at 7:51 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Patch 1 allow user to select txqueue in clsact hook.
> Patch 2 support skbhash, classid, cpuid to select txqueue.
>
> Tonghao Zhang (2):
>   net: sched: use queue_mapping to pick tx queue
>   net: sched: support hash/classid/cpuid selecting tx queue
ping, any progress?
>  include/linux/netdevice.h              |  3 +
>  include/linux/rtnetlink.h              |  1 +
>  include/net/tc_act/tc_skbedit.h        |  1 +
>  include/uapi/linux/tc_act/tc_skbedit.h |  8 +++
>  net/core/dev.c                         | 31 +++++++++-
>  net/sched/act_skbedit.c                | 84 ++++++++++++++++++++++++--
>  6 files changed, 122 insertions(+), 6 deletions(-)
>
> --
> v7:
> * 1/2 fix build warn, move pick tx queue into egress_needed_key for
>   simplifing codes.
> v6:
> * 1/2 use static key and compiled when CONFIG_NET_EGRESS configured.
> v5:
> * 1/2 merge netdev_xmit_reset_txqueue(void),
>   netdev_xmit_skip_txqueue(void), to netdev_xmit_skip_txqueue(bool skip).
> v4:
> * 1/2 introduce netdev_xmit_reset_txqueue() and invoked in
>   __dev_queue_xmit(), so ximt.skip_txqueue will not affect
>   selecting tx queue in next netdev, or next packets.
>   more details, see commit log.
> * 2/2 fix the coding style, rename:
>   SKBEDIT_F_QUEUE_MAPPING_HASH -> SKBEDIT_F_TXQ_SKBHASH
>   SKBEDIT_F_QUEUE_MAPPING_CLASSID -> SKBEDIT_F_TXQ_CLASSID
>   SKBEDIT_F_QUEUE_MAPPING_CPUID -> SKBEDIT_F_TXQ_CPUID
> * 2/2 refactor tcf_skbedit_hash, if type of hash is not specified, use
>   the queue_mapping, because hash % mapping_mod == 0 in "case 0:"
> * 2/2 merge the check and add extack
> v3:
> * 2/2 fix the warning, add cpuid hash type.
> v2:
> * 1/2 change skb->tc_skip_txqueue to per-cpu var, add more commit message.
> * 2/2 optmize the codes.
>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Alexander Lobakin <alobakin@pm.me>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Talal Ahmad <talalahmad@google.com>
> Cc: Kevin Hao <haokexin@gmail.com>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Cc: Antoine Tenart <atenart@kernel.org>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> --
> 2.27.0
>


-- 
Best regards, Tonghao
