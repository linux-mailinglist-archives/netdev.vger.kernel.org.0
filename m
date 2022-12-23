Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E7C65540F
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 20:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiLWTzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 14:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiLWTzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 14:55:02 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFC813F2A
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 11:55:01 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id x11so4446915qtv.13
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 11:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ytlGRN+Zvf1GCedPeHeIV0/Bc2Bxmm4MYRgni7UZ0VA=;
        b=T/HZO1Z86a/yucKbo8fCYB94xGQsaTO4ihOAnJOljMUc9OICiF/xMdXrc4ryg28DpR
         eFl/E3g3ID+1rnnglCWSW0jyixUPXe1uLYogNis+p2d9rOzDyOEgoIH4uPfAhY1MCiEh
         FRVU9oEHU2CS0vZvFc4uxoQNQVaMpW4BUYnLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ytlGRN+Zvf1GCedPeHeIV0/Bc2Bxmm4MYRgni7UZ0VA=;
        b=pAM1uZWBUX/J5cV+mSbKRT9BAFrBklA351cS8+jR+xi4Wc2bf+aCuPzoselSybGB8D
         5uud74jSZmdiNO5W8Ao7mp3nzEEx71a5Yv6ZekhlelVvec28NOkbbVrEkIVWGLBMaXRe
         LSO+vhbuEBmCqMeQncRC/ABRkespCzbc559UWMEjt2FlwgRfFQQj0XHC2WqCzUL78BD6
         tk5NYKrEu656gzJ0AGrak9BRFi8NPTfBZXzDZUKmbaEhG+c1MsQ1j5E+hZW4cQPFKRsN
         QJplXLMiOsAGnvORmoyIZnuRq1OhRy/mqglQFZgk/RvvvJhNnJX1JZr7woNs7nb/JR6a
         jcrQ==
X-Gm-Message-State: AFqh2krNFPZeWJlEya15ogrliYC0MUmv5F3XMScbBlXQWlQ2JRNHtPYG
        Pw9YC0KQfdOiVCKDvq+7TMiL4dx1ufQjNI1/
X-Google-Smtp-Source: AMrXdXvcRW6yiTBTRBoP9bRyjIQXwvoeAroR0Ou8UweZJsMMbEblqzSFUCe36mv3XfWxSkIo0aYHtQ==
X-Received: by 2002:a05:622a:4d0f:b0:3a8:661:251 with SMTP id fd15-20020a05622a4d0f00b003a806610251mr14586560qtb.64.1671825300382;
        Fri, 23 Dec 2022 11:55:00 -0800 (PST)
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com. [209.85.219.45])
        by smtp.gmail.com with ESMTPSA id ga27-20020a05622a591b00b0039cd4d87aacsm2424641qtb.15.2022.12.23.11.54.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 11:54:58 -0800 (PST)
Received: by mail-qv1-f45.google.com with SMTP id df17so177411qvb.3
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 11:54:58 -0800 (PST)
X-Received: by 2002:a05:6214:2b9a:b0:4c7:20e7:a580 with SMTP id
 kr26-20020a0562142b9a00b004c720e7a580mr551504qvb.43.1671825298226; Fri, 23
 Dec 2022 11:54:58 -0800 (PST)
MIME-Version: 1.0
References: <20221222144343-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221222144343-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 23 Dec 2022 11:54:41 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi6Gkr7hJz20+xD=pBuTrseccVgNR9ajU7=Bqbrdk1t4g@mail.gmail.com>
Message-ID: <CAHk-=wi6Gkr7hJz20+xD=pBuTrseccVgNR9ajU7=Bqbrdk1t4g@mail.gmail.com>
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

On Thu, Dec 22, 2022 at 11:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

I see none of this in linux-next.

               Linus
