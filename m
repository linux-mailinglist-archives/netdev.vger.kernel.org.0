Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E659C407B23
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 02:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhILAsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 20:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhILAsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 20:48:22 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AAFC061574
        for <netdev@vger.kernel.org>; Sat, 11 Sep 2021 17:47:09 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id q21so10023778ljj.6
        for <netdev@vger.kernel.org>; Sat, 11 Sep 2021 17:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fTtI1r5tPdIsG/NkIDSe/Aqz0eLPuMAYXLyyQSCQenY=;
        b=hfTvAxTgvh8dEvrrDxR1ts56KucOk9K49I6CwiyfT/tY2ZjzFKVA1lkSySAKreAWgo
         VhO/812N3vhm209MU9Q9V6tlHvzI9p8WifyBBoR0fSaGmuxPOrmttOegqVxG0p+D+3GY
         5ija9A2vsipX8mcMCJiZFFlb1VoRK5Mr5hWlg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fTtI1r5tPdIsG/NkIDSe/Aqz0eLPuMAYXLyyQSCQenY=;
        b=xowcvgNhtZUil+KoTepggL7TXV8FE/9vQHxpxcYXMp3veci2iaRs4X4HTG/PXaqgrI
         Qwe8UPb69tAzdCo6EstVN7avAYacKC9lu/PCUp9UEA23jJfRlKbhv8m/r8cVdgKecySd
         1cFtzCdAuNMU+xPVf9r3FdoERa2LY2j4+XP78IfUuPvNkbkzyyqG5QaKDCK6+F9Gp7uT
         jh1qDUc0W9mjPekD0FOuL3MxPfAgGU53O0VMkjRD6n8ztx32bTzlB/L0FlM2hfbMzfkD
         FGAekkXVKv6W1ZDSH2VxPefOqRwykL0EnfcWhD+1ssG92J4nkAIE8bU76Tsk3ZL/ay+Q
         zWHA==
X-Gm-Message-State: AOAM5329SVzOTY25tBTSo1pocMdGBZwV9iNhxbNcv/tuKJ2yDItEGOsT
        tIaxsf6cFZpeG8OUJ+g18qp0OIyhZ/4GpK8HLGE=
X-Google-Smtp-Source: ABdhPJw57druMdZx6Rol9rVbtOpqHTd3EWO1pQDzz2OKIs3KF26a2WmYNemIOOyaCW5YAINEjYiqXw==
X-Received: by 2002:a2e:4e09:: with SMTP id c9mr4098449ljb.62.1631407627274;
        Sat, 11 Sep 2021 17:47:07 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id z4sm356088lfr.201.2021.09.11.17.47.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 17:47:05 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id k13so12574756lfv.2
        for <netdev@vger.kernel.org>; Sat, 11 Sep 2021 17:47:04 -0700 (PDT)
X-Received: by 2002:a05:6512:3d04:: with SMTP id d4mr3696677lfv.474.1631407624560;
 Sat, 11 Sep 2021 17:47:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210911200504-mutt-send-email-mst@kernel.org> <163140733123.30830.10283487707815357982.pr-tracker-bot@kernel.org>
In-Reply-To: <163140733123.30830.10283487707815357982.pr-tracker-bot@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 11 Sep 2021 17:46:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj1Wd8yVyErBrG06jE+Q2rgjNB2N=MzEdjNVo9v0YRwAA@mail.gmail.com>
Message-ID: <CAHk-=wj1Wd8yVyErBrG06jE+Q2rgjNB2N=MzEdjNVo9v0YRwAA@mail.gmail.com>
Subject: Re: [GIT PULL V2] virtio,vdpa,vhost: features, fixes
To:     pr-tracker-bot@kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arseny.krasnov@kaspersky.com, caihuoqing@baidu.com,
        elic@nvidia.com, Jason Wang <jasowang@redhat.com>,
        lingshan.zhu@intel.com, mgurtovoy@nvidia.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Wolfram Sang <wsa@kernel.org>, xianting.tian@linux.alibaba.com,
        xieyongji@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 11, 2021 at 5:42 PM <pr-tracker-bot@kernel.org> wrote:
>
> The pull request you sent on Sat, 11 Sep 2021 20:05:04 -0400:
>
> > https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus_v2
>
> has been merged into torvalds/linux.git:
> https://git.kernel.org/torvalds/c/a93a962669cdbe56bb0bcd88156f0f1598f31c88

Note that pr-tracker-bot is confused, but not entirely wrong.

Because this was a subset of the pull request that was actually
merged, pr-tracker-bot reports that it was merged.

True.

But what was _really_ merged was the first version that contained this
and then some.

           Linus
