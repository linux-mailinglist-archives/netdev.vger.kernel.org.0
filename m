Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0546C655555
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 23:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiLWWpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 17:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiLWWpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 17:45:22 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27ACE1B782
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 14:45:22 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id g7so4762261qts.1
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 14:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vSvLPbLq/C9FCOrpReOfkegMxmEq2CG+zmnUg15rfnE=;
        b=O0nO2npcsEuGz+0NX8LmllWKqOioCXhGuOHySQlyMTXGG2F9CCkQXekZJapL/wB5cN
         luHDk0NeFDIYSI6+va2fCWh86HzpC4ARJaWu10Enp9BH5cG/n36UP46NrRtnmKYV2mdp
         6PrsrjtqGbBhZOiPYxKOD7XSXcAkSBUcrfYFs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vSvLPbLq/C9FCOrpReOfkegMxmEq2CG+zmnUg15rfnE=;
        b=DyOA4ewEQ+29ER2LJicaltrMOCIyX9BbXhrfiw1WsY4gc0TVixd/tbwNJe9zcvI6pq
         2srWHv8t5g9oemzPNkzgXOR9/mWF/6bu1MaW807NgV/MYY87QNVApP/auxinFeR9j9xK
         l8FAm/ZrHkznkWNJiVUKiYwd9WTxEI92xBfTRgiptlBBhZz34WHELro16RNlVV3s1886
         blXKS6RtpHYiiNZhODJANl4doSeoJQtPFZGw+miQS1rmMoogPLhoUWSYLA9RU5Yy/gPC
         FL9DjN5i0/6M1TtAXWDW+iIY+TcEX79g7YJe4B89IKll5Q+hoEWG67hz9vSR4Lpa2H/W
         go2Q==
X-Gm-Message-State: AFqh2kp/0bfHkpKDWqSNpEGbupK82JiaEs4WFzTtQNl4cAtiHkmD05yk
        w3DhAyQzHX/vz+ZtqtX/yD6mBmQKfXAzNGbm
X-Google-Smtp-Source: AMrXdXuRBSzcRFUuO5gw+6KnCzYBZ5wvcev2UFn5RGCo+I0DsOSEVCWcB21erL6CTbWJUUs69OuCKw==
X-Received: by 2002:ac8:7ee5:0:b0:3a5:c1d:c26 with SMTP id r5-20020ac87ee5000000b003a50c1d0c26mr13279121qtc.50.1671835521049;
        Fri, 23 Dec 2022 14:45:21 -0800 (PST)
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com. [209.85.222.177])
        by smtp.gmail.com with ESMTPSA id p16-20020a05620a057000b00704c1f4e756sm2940659qkp.14.2022.12.23.14.45.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 14:45:20 -0800 (PST)
Received: by mail-qk1-f177.google.com with SMTP id a25so2941976qkl.12
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 14:45:20 -0800 (PST)
X-Received: by 2002:a05:620a:1379:b0:6fc:c48b:8eab with SMTP id
 d25-20020a05620a137900b006fcc48b8eabmr367434qkl.216.1671835022820; Fri, 23
 Dec 2022 14:37:02 -0800 (PST)
MIME-Version: 1.0
References: <20221222144343-mutt-send-email-mst@kernel.org>
 <CAHk-=wi6Gkr7hJz20+xD=pBuTrseccVgNR9ajU7=Bqbrdk1t4g@mail.gmail.com> <20221223172549-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221223172549-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 23 Dec 2022 14:36:46 -0800
X-Gmail-Original-Message-ID: <CAHk-=whpdP7X+L8RtGsonthr7Ffug=FhR+TrFe3JUyb5-zaYCA@mail.gmail.com>
Message-ID: <CAHk-=whpdP7X+L8RtGsonthr7Ffug=FhR+TrFe3JUyb5-zaYCA@mail.gmail.com>
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

On Fri, Dec 23, 2022 at 2:27 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> They were all there, just not as these commits, as I squashed fixups to
> avoid bisect breakages with some configs. Did I do wrong?

I am literally looking at the next-20221214 state right now, doing

    git log linus/master.. -- drivers/vhost/vsock.c
    git log linus/master.. -- drivers/vdpa/mlx5/
    git log --grep="temporary variable type tweak"

and seeing nothing.

So none of these commits - in *any* form - were in linux-next last
week as far as I can tell.

             Linus
