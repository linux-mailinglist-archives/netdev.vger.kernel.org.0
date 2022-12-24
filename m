Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7C3655896
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 07:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiLXGKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 01:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiLXGKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 01:10:52 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F72210EF
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 22:10:50 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id bp44so2572099qtb.0
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 22:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3E3YAkwQ1FMGK0G4c+k3cWhSC99qn+AW2e60BpLd48M=;
        b=h0YtYQKEi5AnsXB7utpqFRidFunGHv4v+XFF72sE8OGP438jrHeRtPo/jQdOSZ1pLE
         oegIRWAaL4+RlmtvXf3fWwBdtxMDrz9wbhjYKbUArB5tP0fzi7/cIsac8j32oj4Hz6Xj
         3+DSLdyaQWX2k4WvvXwK/zYvkz1jN+G7ah7Zc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3E3YAkwQ1FMGK0G4c+k3cWhSC99qn+AW2e60BpLd48M=;
        b=lDjWj24YBh6mj+7jm3NnDrsVQ/U8wuusSfwowOsbfngA7BzDv6XnNV6yJip5OGs2Yc
         hTJF82HqDz7BO5Ww9jV4BLXQCshx7UtJtNJyVxB9QWZmXstot8gIHdCXWJ8Lo02r9A6R
         Yr7Q2QUlnkqY83rK7qJ+dNq/weUGZE+6YZ/loISMJmWrPqNGpu9kA8gk5Ja1XthKmZRg
         Dq+vKsMMAqEHRe63AaSY19v1Kv7dquFxT2DpBUMZMVrpSd65/l2/0Lm3GI70va3xEoLD
         IakYd8iJG3zOtRVmqsxzhVuxWamneOqKmZjYkS+BvFATLV/Aur9459gXat1tKbQjH3O8
         8Thw==
X-Gm-Message-State: AFqh2kpie8szbo1tWSqB1SklPuWsfyp5IBp3FZArLp3BmPvjHnaYb36J
        NI7YdAs82l2oObBuHOHWfx1qLRwMZhmVDLL/
X-Google-Smtp-Source: AMrXdXuIFPIxCezeOWIqrjkuQ3TJO8FXkzYC5H7qC249SZFGxxSaZmvb4VZWEj1Zeu6YK6cShCOheg==
X-Received: by 2002:ac8:785:0:b0:3a7:eab2:e461 with SMTP id l5-20020ac80785000000b003a7eab2e461mr11813012qth.25.1671862248712;
        Fri, 23 Dec 2022 22:10:48 -0800 (PST)
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com. [209.85.222.170])
        by smtp.gmail.com with ESMTPSA id s13-20020a05620a0bcd00b006e16dcf99c8sm3713828qki.71.2022.12.23.22.10.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 22:10:47 -0800 (PST)
Received: by mail-qk1-f170.google.com with SMTP id f28so3226073qkh.10
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 22:10:46 -0800 (PST)
X-Received: by 2002:ae9:ef49:0:b0:6fe:d4a6:dcef with SMTP id
 d70-20020ae9ef49000000b006fed4a6dcefmr506882qkg.594.1671862246626; Fri, 23
 Dec 2022 22:10:46 -0800 (PST)
MIME-Version: 1.0
References: <20221222144343-mutt-send-email-mst@kernel.org>
 <CAHk-=wi6Gkr7hJz20+xD=pBuTrseccVgNR9ajU7=Bqbrdk1t4g@mail.gmail.com>
 <20221223172549-mutt-send-email-mst@kernel.org> <CAHk-=whpdP7X+L8RtGsonthr7Ffug=FhR+TrFe3JUyb5-zaYCA@mail.gmail.com>
 <20221224003445-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221224003445-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 23 Dec 2022 22:10:30 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh_cyzZgYp1pL8MDA6sioB1RndQ_fref=9V+vm9faE7fg@mail.gmail.com>
Message-ID: <CAHk-=wh_cyzZgYp1pL8MDA6sioB1RndQ_fref=9V+vm9faE7fg@mail.gmail.com>
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes, cleanups
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        almasrymina@google.com, alvaro.karsz@solid-run.com,
        anders.roxell@linaro.org, angus.chen@jaguarmicro.com,
        bobby.eshleman@bytedance.com, colin.i.king@gmail.com,
        dave@stgolabs.net, dengshaomin@cdjrlc.com, dmitry.fomichev@wdc.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        harshit.m.mogalapalli@oracle.com, jasowang@redhat.com,
        leiyang@redhat.com, lingshan.zhu@intel.com, lkft@linaro.org,
        lulu@redhat.com, m.szyprowski@samsung.com, nathan@kernel.org,
        pabeni@redhat.com, pizhenwei@bytedance.com, rafaelmendsr@gmail.com,
        ricardo.canuelo@collabora.com, ruanjinjie@huawei.com,
        sammler@google.com, set_pte_at@outlook.com, sfr@canb.auug.org.au,
        sgarzare@redhat.com, shaoqin.huang@intel.com,
        si-wei.liu@oracle.com, stable@vger.kernel.org, stefanha@gmail.com,
        sunnanyong@huawei.com, wangjianli@cdjrlc.com,
        wangrong68@huawei.com, weiyongjun1@huawei.com,
        xuanzhuo@linux.alibaba.com, yuancan@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 9:35 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> They were in  next-20221220 though.

So, perfect for the *next* merge window.

Do you understand what the word "next" means? We don't call it
"linux-this", do we?

This is not a new rule. Things are supposed to be ready *before* the
merge window (that's what makes it "next", get it?).

I will also point you to to

  https://lore.kernel.org/lkml/CAHk-=wj_HcgFZNyZHTLJ7qC2613zphKDtLh6ndciwopZRfH0aQ@mail.gmail.com/

where I'm being pretty damn clear about things.

And before you start bleating about "I needed more heads up", never
mind that this isn't even a new rule, and never mind what that "next"
word means, let me just point to the 6.1-rc6 notice too:

  https://lore.kernel.org/lkml/CAHk-=wgUZwX8Sbb8Zvm7FxWVfX6CGuE7x+E16VKoqL7Ok9vv7g@mail.gmail.com/

and if the meaning of "next" has eluded you all these years, maybe it
was high time you learnt. Hmm?

              Linus
