Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A08A407B2E
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 02:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbhILAw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 20:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhILAw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 20:52:27 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F74C061574
        for <netdev@vger.kernel.org>; Sat, 11 Sep 2021 17:51:14 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id f2so10047667ljn.1
        for <netdev@vger.kernel.org>; Sat, 11 Sep 2021 17:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=djPK8cia5m0qX5Zxp7M6GNMnA/J0EGKvTFEvrA/orKo=;
        b=BeZ4wj46QWUIa1PRMxDJJzSxU067c8arLPq359/YAIYM2Pa0vDxJ8SxI9wU5chvg6x
         BdROVYGYeqJj5fLU+2WKja4e3teRqDF//UpkYy1+DfaBSxLpp8qry0a9vpB11tJA8BrZ
         wqMor7qv9Hf7pXq+K01/g7ViYfTGbH32VnwLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=djPK8cia5m0qX5Zxp7M6GNMnA/J0EGKvTFEvrA/orKo=;
        b=nU5HgzKf0bA0E3fKJOvdfH8yuk6KibSHmS3ugrpsiUmVTYEOW1lsm577fYw+7H6wOB
         ckYO5sKu+g58Y8ejoVXkmt7r9J4saMg8RR4Q64wxZwj/QZiBFAA5elFxPfig+8dJSFpg
         e609x8vsgSJNNt4L4UB3jJ4dbw6ThRmlSPFDvf70v9YBxOhWfBbBg6G2riCltFScj90L
         hmHbcyAJBHXCLha6QQRG5Et62GXud3NgD3bsyUCq3x4mlm9YgB+J/1vdPoxOSOpxbZbH
         zpon+ckqPh2AovmkUF5buoV2gk0QYvcrWBC0CY24vNJtbCewI89N1UBohGhaMM7Wew8h
         umuA==
X-Gm-Message-State: AOAM530vmJ+xz3wr6+dk5SxVayAm06LmA3NmP9DMefxFg3yOSY6dK+x7
        ApuuT61IgjUmgelhyVSB70m4LbRNWs9bWoFNIeE=
X-Google-Smtp-Source: ABdhPJy9+0ZMZfz7OQbYdVB3G20+/geGSphhJyy99ybscRGgGfIz4zVtAafRSkOKK6p5RAZpX8GnKQ==
X-Received: by 2002:a2e:7505:: with SMTP id q5mr1531791ljc.506.1631407872619;
        Sat, 11 Sep 2021 17:51:12 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id j28sm354648lfp.307.2021.09.11.17.51.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 17:51:12 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id t19so12527283lfe.13
        for <netdev@vger.kernel.org>; Sat, 11 Sep 2021 17:51:12 -0700 (PDT)
X-Received: by 2002:a05:6512:34c3:: with SMTP id w3mr3705182lfr.173.1631407431833;
 Sat, 11 Sep 2021 17:43:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210909095608-mutt-send-email-mst@kernel.org>
 <CAHk-=wgcXzshPVvVgGDqa9Y9Sde6RsUvj9jvx0htBqPuaTGX4Q@mail.gmail.com> <20210911200508-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210911200508-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 11 Sep 2021 17:43:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wguv1zB0h99LKH1UpjNvcg7tsckE_udYr3AP=2aEUdtwA@mail.gmail.com>
Message-ID: <CAHk-=wguv1zB0h99LKH1UpjNvcg7tsckE_udYr3AP=2aEUdtwA@mail.gmail.com>
Subject: Re: [GIT PULL] virtio,vdpa,vhost: features, fixes
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arseny.krasnov@kaspersky.com, caihuoqing@baidu.com,
        elic@nvidia.com, Jason Wang <jasowang@redhat.com>,
        lingshan.zhu@intel.com, mgurtovoy@nvidia.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>, Wolfram Sang <wsa@kernel.org>,
        xianting.tian@linux.alibaba.com, xieyongji@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 11, 2021 at 5:11 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> It's in the tag for_linus_v2 - the point of keeping for_linus
> intact was so anyone can compare these two.

Well, since I had already spent the effort in trying to figure things
out, I had merged the original branch.

I just didn't _like_ having to spend that effort, particularly not the
weekend before I do rc1.

This has not been one of those smooth merge windows that we occasionally have.

             Linus
