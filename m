Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921FB32688E
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 21:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhBZUWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 15:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhBZUUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 15:20:05 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3EFC061786;
        Fri, 26 Feb 2021 12:19:25 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id e9so3982391pjs.2;
        Fri, 26 Feb 2021 12:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3pfHQZSWarGNOcNZ4+gyIjmqWRf8HzKA3bN85K8F5AU=;
        b=NxO8gxg8kFgFbEF6PTLQCF/D8wepnZ2Lh2KrxDCtxVt8okzFE5Q8xQSqAaqvm/mkKb
         6DeS4++YhVF9EnvRuqD95TNp0MtglbYopXmh57vTi00XIESKaSvg5bAuER3/rI5pKrvn
         czkSQai++5RSwowKwGQZDpryl6Fs/mm+rCzvGuYXxQ/6tPxeXwF9gqyMrO1kYnKcXIEn
         hJdEd8vSW+BsNV7ZBayXorGCtrM6yuoCz2+XOLbZ6tQ6ckuHk7OlR5E1o/bJ6gCxsegf
         VZMEqKcc79dl2ovH5qd7JOHRLihXPUSCQ50MINnv/9k8o8LDAaesLP68OxYG+wSpPNso
         aPdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3pfHQZSWarGNOcNZ4+gyIjmqWRf8HzKA3bN85K8F5AU=;
        b=PelxYEUpcrW7+a1ktzQwaZk2nX+G/zg5fIYSgQqMLwJGLlQy7W2rttTJwa+ZmVdlYS
         +fPTehmW8rZKKKcc4ieJb927MIycA3sW2Fd7J7KRgEye0P5SrzACQIhsRwhVAcPvcUdj
         dmDOXrOxvGj/S4VSaNmixXUeGabsy8D2ZUVIJU6stazYLF/BX2aHNAoLheM/Q8xiMJKB
         byZUCkspprRYM15IVWF/cTVA5Zm4q2FTrArbcDiZ39PJA20vzLOfUfXeAscuV8dAZAaD
         o20+bQ0bUYM4SVAPhmriQnPKhC7sVMG/kbjYPugumeDy4wdIKcm+5deY6/arUetVePH8
         M/ZQ==
X-Gm-Message-State: AOAM531qXEl12SU7usxw6taJIdv4FtgEG9vnXKyvFmrWa3YRUNPYoYW2
        +rO569Vek0zfE2ig6xO85RwQexPmKCs1KJnIQ/vPSH4vSD1tvw==
X-Google-Smtp-Source: ABdhPJzCSya5DPtRXo0mH3e8wzYt/dhW1sUmKCXK2It30b7hmBPIoJHSXM6t+5KxosBTXAAvbvwz13KW8TWGtcZB7UU=
X-Received: by 2002:a17:902:b410:b029:e3:284e:4e0b with SMTP id
 x16-20020a170902b410b02900e3284e4e0bmr4894932plr.33.1614370765098; Fri, 26
 Feb 2021 12:19:25 -0800 (PST)
MIME-Version: 1.0
References: <20210224153803.91194-1-wangkefeng.wang@huawei.com>
 <CAM_iQpV0NCoJF-qS1KPB+VE3FSMfGBH_SL-OxhMO-k0pGUEhwA@mail.gmail.com> <1cf51ae7-3bce-3b9f-f6aa-c20499eedf7a@huawei.com>
In-Reply-To: <1cf51ae7-3bce-3b9f-f6aa-c20499eedf7a@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 26 Feb 2021 12:19:14 -0800
Message-ID: <CAM_iQpWArF_At1XAcviDnyXdth4cMeUSQh7RBW-JNCDUPYfA2A@mail.gmail.com>
Subject: Re: [PATCH] net: bridge: Fix jump_label config
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 5:39 PM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>
>
> On 2021/2/26 5:22, Cong Wang wrote:
> > On Wed, Feb 24, 2021 at 8:03 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> >> HAVE_JUMP_LABLE is removed by commit e9666d10a567 ("jump_label: move
> >> 'asm goto' support test to Kconfig"), use CONFIG_JUMP_LABLE instead
> >> of HAVE_JUMP_LABLE.
> >>
> >> Fixes: 971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge input path")
> >> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> > Hmm, why do we have to use a macro here? static_key_false() is defined
> > in both cases, CONFIG_JUMP_LABEL=y or CONFIG_JUMP_LABEL=n.
>
> It seems that all nf_hooks_needed related are using the macro,
>
> see net/netfilter/core.c and include/linux/netfilter.h,
>
>    #ifdef CONFIG_JUMP_LABEL
>    struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
> EXPORT_SYMBOL(nf_hooks_needed);
> #endif
>
>    nf_static_key_inc()/nf_static_key_dec()

Same question: why? Clearly struct static_key is defined in both cases:

#else
struct static_key {
        atomic_t enabled;
};
#endif  /* CONFIG_JUMP_LABEL */

Thanks.
