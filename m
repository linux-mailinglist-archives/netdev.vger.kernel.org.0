Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EB1655882
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 06:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiLXFts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 00:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiLXFtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 00:49:46 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24B3E0EB
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 21:49:44 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id a14so4472666pfa.1
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 21:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Be9qZ3HVvy/Sm+xJabwUjsOwonZrbpMs2ouPpFo3Qww=;
        b=jYLtKGR6pjYlo/9SgNfH/rHB6TwlRImRgehoQupICfDVWz00aaFn/gJSvaBAhbuRvL
         Jn09iFoYEVss3akSYPsRJZQj7l/0Za91bfLe/8imbQ4zmiCg62UusJounftbzB7nRYWP
         iotK3ok+WB3ckMxq7d+7f0eskAo+okxMWYU8UzOEkM4T/p9UVxKpvLNFg/SrBaVC6bzf
         julhp15V05lHSfwBUDfzg6z4F2r7y5Kgd4F4me7wdOgaDa/RTKdqw4FnVynpnICWHqGz
         W1MiRwmuosS01C+GGkWUEzPnY+U39xglvy3XB/3sAdMTemQoQT3SFRqmSo8LlJO9TuYZ
         uRvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Be9qZ3HVvy/Sm+xJabwUjsOwonZrbpMs2ouPpFo3Qww=;
        b=K7aHY/taExHdrQjw9lfjB3KtJqkcOwCCaZwh2EMpYIQ9OAojB77TRq8XLzjoOoZeSF
         iFDxc2el3DQpxHmODJm8HK9IikqnYncFBU3P2Uoo9gqebGk57wZs7bSWU2C1vkfw01u4
         t6O20mWIB08fywf97sFIsF8xzojzElohYyO/O3V5P4XaO7pnhrG8HkGMrzLCrnmZ3Gwv
         XSW/RLNPWQSyZSG+KGH01GqnC2QSgCcRsgBRSV7VnnhYjp1sz6sTUqb81rL52xJLVd5n
         bdxOjROv7t+629PXC+HFetWajYQPYpxTlfO50wkJEoiCAQaLAyYF3wfb/OVUphoYjRtF
         kIgA==
X-Gm-Message-State: AFqh2kr9RTjFSVcQHqgrLS1B2WTspqikJtbTmNWttBazU0A7mAcevcj+
        xvSxrEsKh6pvh4nh4VbpAFfTP3dYqUIgzHVvTxk+cg==
X-Google-Smtp-Source: AMrXdXtYGrvP5/vnyJe/l0eVcSeMHu3kFu34JbU583rmSM5zS8TwLEz9dKY+xHKywot2IrdknSHm3E+8k61DAXT+bJE=
X-Received: by 2002:a63:161d:0:b0:46f:6225:c2f9 with SMTP id
 w29-20020a63161d000000b0046f6225c2f9mr493439pgl.225.1671860984183; Fri, 23
 Dec 2022 21:49:44 -0800 (PST)
MIME-Version: 1.0
References: <20221222144343-mutt-send-email-mst@kernel.org>
 <CAHk-=wi6Gkr7hJz20+xD=pBuTrseccVgNR9ajU7=Bqbrdk1t4g@mail.gmail.com>
 <20221223172549-mutt-send-email-mst@kernel.org> <CAHk-=whpdP7X+L8RtGsonthr7Ffug=FhR+TrFe3JUyb5-zaYCA@mail.gmail.com>
 <20221224003445-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221224003445-mutt-send-email-mst@kernel.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Sat, 24 Dec 2022 00:49:32 -0500
Message-ID: <CA+pv=HM-Ur7g4Kd3-0nO3TPRgyojgdk8XVTgTnNfebTA6ARg5Q@mail.gmail.com>
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes, cleanups
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
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

On Sat, Dec 24, 2022 at 12:36 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Dec 23, 2022 at 02:36:46PM -0800, Linus Torvalds wrote:
> > On Fri, Dec 23, 2022 at 2:27 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > They were all there, just not as these commits, as I squashed fixups to
> > > avoid bisect breakages with some configs. Did I do wrong?
> >
> > I am literally looking at the next-20221214 state right now, doing
> >
> >     git log linus/master.. -- drivers/vhost/vsock.c
> >     git log linus/master.. -- drivers/vdpa/mlx5/
> >     git log --grep="temporary variable type tweak"
> >
> > and seeing nothing.
> >
> > So none of these commits - in *any* form - were in linux-next last
> > week as far as I can tell.
> >
> >              Linus
>
>
> They were in  next-20221220 though.
>

+1, just checked and these appear to be in next-20221220.

-- Slade
