Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B455FCFBF
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 02:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJMAVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 20:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiJMAUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 20:20:37 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0955BF2517
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 17:17:51 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 63so318351ybq.4
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 17:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nqgh1ED8YLB3Lt0ws7IuNLmuxoK0yD2LR5GJPgsLVvA=;
        b=W1fbXQ4scCa8Aep6N0cQa85yRo+RHzhCjqU9C17a2GycoxpJKqsfwyTzqPU2P9Dgpa
         +l6W0OriU9nSD1VENAfnSKXeF274+lr4SyUHODPMPW2x3a8jcaKK9+eZV2uJWHoMir0T
         Vcx+kXS6Eqbpe7DbkwjZ49mEerz1hwPFIz8Ld0q/CoGVyfL/1HWyro0i9LugpgS4AXKN
         ign/P4AP/BpuWW/cHBjxOLuuTfXFsSMCMu8SHFtP5vt3KgodzfzfTUgJNCrxYR9bI9xY
         oUh275VlEVNfw+4YPxMuIedrLbqw9kCSZ7O2Z9Kd9snkSpDjZi3iJw9nDl14QfXbGHXd
         Q7Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nqgh1ED8YLB3Lt0ws7IuNLmuxoK0yD2LR5GJPgsLVvA=;
        b=4vscG0QQcA/dK2LK8EoDKnLe3TtXaPTsAOQ5kTQ6KuO3xYB+eL3OgU5vkh8tfFa/tC
         pGOv8mfhKYk59TQPQsSlJYvYTcBzesbaOR2WADyALNPHx3Noeacr6nUBos9dh4/oJNAH
         e+Hp78m63AywtX8aK1/IFYmhBKc0zs7B4IPz3ZmMtKDCZb/fOQOKEt5KooHkGMNnv+0W
         1HnzSYbRSrLxsJeD0jiHNgYBPjLmwRQzNRPlve+BhQM9HRZGa6wY+zQhQS0eiF5KChUH
         9D042WmBfkhVeU2eEbn5CXPUC+O67DVeHGaGfHDUzDjwxzBWdcj7LoNOBgf59k4aEepo
         fkGA==
X-Gm-Message-State: ACrzQf3BqpMAIJv3+NEETT232JDRinRjo5VzH1Wf/EoGf2YxQPdZVPp6
        taSny/VFTuuxa5BJMMvuvROezZl6JVVCWmvcRa50Hw==
X-Google-Smtp-Source: AMsMyM5Xnza8VEtFbrhcq72guYOiwZzbACy5/YLx5pQbN6BpBeTecfpkREpBFpJHdWAl173DTnZHrkaj5NX6U0SFseo=
X-Received: by 2002:a25:9885:0:b0:6b3:e9a7:4952 with SMTP id
 l5-20020a259885000000b006b3e9a74952mr32358446ybo.294.1665620270607; Wed, 12
 Oct 2022 17:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210817194003.2102381-1-weiwan@google.com> <20221012163300.795e7b86@kernel.org>
In-Reply-To: <20221012163300.795e7b86@kernel.org>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 12 Oct 2022 17:17:38 -0700
Message-ID: <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Wei Wang <weiwan@google.com>, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 4:33 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 17 Aug 2021 12:40:03 -0700 Wei Wang wrote:
> > Add gfp_t mask as an input parameter to mem_cgroup_charge_skmem(),
> > to give more control to the networking stack and enable it to change
> > memcg charging behavior. In the future, the networking stack may decide
> > to avoid oom-kills when fallbacks are more appropriate.
> >
> > One behavior change in mem_cgroup_charge_skmem() by this patch is to
> > avoid force charging by default and let the caller decide when and if
> > force charging is needed through the presence or absence of
> > __GFP_NOFAIL.
>
> This patch is causing a little bit of pain to us, to workloads running
> with just memory.max set. After this change the TCP rx path no longer
> forces the charging.
>
> Any recommendation for the fix? Setting memory.high a few MB under
> memory.max seems to remove the failures.

Did the revert of this patch fix the issue you are seeing? The reason
I am asking is because this patch should not change the behavior.
Actually someone else reported the similar issue for UDP RX at [1] and
they tested the revert as well. The revert did not fix the issue for
them.

Wei has a better explanation at [2] why this patch is not the cause
for these issues.

[1] https://lore.kernel.org/all/CALvZod5_LVkOkF+gmefnctmx+bRjykSARm2JA9eqKJx85NYBGQ@mail.gmail.com/
[2] https://lore.kernel.org/all/CAEA6p_BhAh6f_kAHEoEJ38nunY=c=4WqxhJQUjT+dCSAr_rm8g@mail.gmail.com/
