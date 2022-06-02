Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6792053BC24
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbiFBQLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbiFBQLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:11:33 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753D52AD99B;
        Thu,  2 Jun 2022 09:11:32 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 1so5748780ljp.8;
        Thu, 02 Jun 2022 09:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6zbUw3x/NJA/vn4ED7GxT1M9yN1v9lCpihV5ohVRAXY=;
        b=dF2ahP17ijXf9r1UiMCcRAjwHzRpLrHTTxzlPSUGkfQ1ayMnRQSmgVRS/dEzTYvOZd
         ijKJm6hGHA0LdZdmwT3y1lB4qdZRYj3oGxWePfGjfNpDig2ffj1erVFmRDtCa9bBzvz4
         KfBgGxjxERwPa/7fPqA4ANpFPmmOipSkZ10KDa2a/l9Qso/cDr2a0S6KuiOtcfqlOEUt
         56R8dzey5U481BDenJpIx8G3jv5TSegd0pG9rLuckypf+pvwdy15fljiIUzbQIwIX8U4
         TJXmoFJbTaCxxtd6KOYNHNdrgZIBKx9bBF8FGA2JEqShFxY4Aw0OJBp+aVgQbaCARSD0
         Sh2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6zbUw3x/NJA/vn4ED7GxT1M9yN1v9lCpihV5ohVRAXY=;
        b=5UPL4s5hx54vlb1aKjjhu49SHu3jXd9yL0RKl6gqwXgkNEICehMyjJTFzQEEgct/hl
         HTUtLhB403E13MQ1ks85YzBbtOYrr+nJjyuwsRVgbDP2/UETsSrhYhiBZj/ddlpRVf4O
         zydu+tCbaFIK7wRYsN3mtCG/S8yhmxPEANL7+iuHi9lE87le6JrmDG7yMaBJSEpTztjW
         kyAmoRw3spbBiqBlKd9pIrk/RX2iHmhUyQuyo1nBabzfF7PUmEsWf4oPybfa+vZQ6+Wk
         YEguFk2XxQfB01MvOpS0ZW3DI8CKgT9FRZIqgx4iuA7vz4SmogAByF5eDSdqmUoMOKUC
         0JGQ==
X-Gm-Message-State: AOAM531GBnunvSKB+NAHqq5rqr+VUcNqyT0XL3yU+Ay7CwvPUJeKbN0y
        wlXmg6hvb/aupFJsOYjP9aR1NgTORZh8dXgksYGuldj89dA=
X-Google-Smtp-Source: ABdhPJw3LWhdDhu+DtLY1WzTECevsulMjHfuaI6WZkhgmB8/CKo9ZNKTLVpsOWfvhER5Qx6qHZJ9G67yvb0nRyymAuk=
X-Received: by 2002:a2e:87c8:0:b0:255:6d59:ebce with SMTP id
 v8-20020a2e87c8000000b002556d59ebcemr4645495ljj.455.1654186290647; Thu, 02
 Jun 2022 09:11:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzY-p13huoqo6N7LJRVVj8rcjPeP3Cp=KDX4N2x9BkC9Zw@mail.gmail.com>
 <20220517180420.87954-1-tadeusz.struk@linaro.org> <7949d722-86e8-8122-e607-4b09944b76ae@linaro.org>
 <CAEf4BzaD1Z6uOZwbquPYWB0_Z0+CkEKiXQ6zS2imiSHpTgX3pg@mail.gmail.com> <41265f4d-45b4-a3a6-e0c0-5460d2a06377@linaro.org>
In-Reply-To: <41265f4d-45b4-a3a6-e0c0-5460d2a06377@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 2 Jun 2022 09:11:19 -0700
Message-ID: <CAEf4Bza-fp-9j+dzwdJQagxVNseNofxY2aJV0E6eHw+eQyyeaQ@mail.gmail.com>
Subject: Re: [PATCH v4] bpf: Fix KASAN use-after-free Read in compute_effective_progs
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 7:37 AM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>
> Hi Andrii,
> On 5/23/22 15:47, Andrii Nakryiko wrote:
> >> Hi Andrii,
> >> Do you have any more feedback? Does it look better to you now?
> > Hi, this is on my TODO list, but I need a bit more focused time to
> > think all this through and I haven't managed to get it in last week.
> > I'm worried about the percpu_ref_is_zero(&desc->bpf.refcnt) portion
> > and whether it can cause some skew in the calculated array index, I
> > need to look at this a bit more in depth. Sorry for the delay.
>
> Did you get a chance to look at this yet?
>

Hm.. I've applied it two days ago, but for some reason there was no
notification from the bot. It's now c89c79fda9b6 ("bpf: Fix KASAN
use-after-free Read in compute_effective_progs").

> --
> Thanks,
> Tadeusz
