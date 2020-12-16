Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E66B2DC202
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 15:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgLPOS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 09:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgLPOS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 09:18:29 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D40C06179C
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 06:17:48 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id e20so6288874vsr.12
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 06:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zGuef7QNpJoBs103ZROpg9hVYX5SQUrY21cb6QdJWDw=;
        b=aDPdyVQ+7eXwLiwV6X5UQ12qtcecCJrIwoN7K7aVIE15V7T3h2CVGORyogQB/f7z0T
         M6A/budE2CuCKQrp2c04fkfAQ4I25KvTW8HkSfezHy7ln4jtn7p/xV87QOS7i4jKcX7r
         wc6gn9q5C1ptXd0MQauwox1Roy9VVT0EFAtJNfa4lESi3sYsajzTYcK/lzrAdzkDL1Rr
         a9mfMX1IRWQVBTNsE5kHMwVgYzgS9ZKRR6Z1HhgI/r/ynepb4sVZSlOtVhxYut5hoYWG
         no2aZugFFo8HwNEffF3CZSLohYTvXfUGopPLMLHN7yOxoCjcoHdfsjSyihtvLHH/TpuG
         WmRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zGuef7QNpJoBs103ZROpg9hVYX5SQUrY21cb6QdJWDw=;
        b=iLrj1Ky39Ai5E//VX3QywbHZk7gx92omQ+En+69yrjW/NSgx/2ARVsS/aVUXBtAISK
         2UKxqPir7txt3QBKrhXkcWhEiFvP6268PhKV+/kzATFAoYjZluGrWc+nVYjVHqEf1ZOj
         KbAFzLc/Vk4vy5T4YKF4YQCD5j4dlAvZfVmeqdd8zHRLzfSWka2ds2Uh1yj985E7r4aZ
         bxf1e9IB2R/6bgfgQOiBhReMwsLzqVNOxVmhXboHPvZx3uASNf9Kgb75VAtEbpPbewHe
         NUtPojQE6p9E70826gjCb2kXocQz+3EFd8oGBzRmYJFijMMt1sSXchccfccAvir/FNlC
         OmIg==
X-Gm-Message-State: AOAM5334h0DmoRPx+8IU7RX1Yrhj2ASNULTTZBLLD0EZSmDM283oqDJB
        dUDbGTWxyVcuYy6pTqYLx2JZ20JY9Yw=
X-Google-Smtp-Source: ABdhPJw4U3pxMCztPTgMlp1xgLft08Ulswr6SJ6r39NEGpOg0dpeBNR0O5P+2gLN0lfZwxldj0buxg==
X-Received: by 2002:a67:5c03:: with SMTP id q3mr31334245vsb.47.1608128267682;
        Wed, 16 Dec 2020 06:17:47 -0800 (PST)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id k19sm237625vsm.19.2020.12.16.06.17.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 06:17:46 -0800 (PST)
Received: by mail-vs1-f54.google.com with SMTP id r24so12979457vsg.10
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 06:17:45 -0800 (PST)
X-Received: by 2002:a67:30c1:: with SMTP id w184mr32661876vsw.13.1608128264592;
 Wed, 16 Dec 2020 06:17:44 -0800 (PST)
MIME-Version: 1.0
References: <cover.1608065644.git.wangyunjian@huawei.com> <62db7d3d2af50f379ec28452921b3261af33db0b.1608065644.git.wangyunjian@huawei.com>
In-Reply-To: <62db7d3d2af50f379ec28452921b3261af33db0b.1608065644.git.wangyunjian@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 16 Dec 2020 09:17:08 -0500
X-Gmail-Original-Message-ID: <CA+FuTSctg7y-s-bkfGf5kEj_LR1ht+LGAA5u36sKvutOVXSHaA@mail.gmail.com>
Message-ID: <CA+FuTSctg7y-s-bkfGf5kEj_LR1ht+LGAA5u36sKvutOVXSHaA@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] vhost_net: fix ubuf refcount incorrectly when
 sendmsg fails
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 3:26 AM wangyunjian <wangyunjian@huawei.com> wrote:
>
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> Currently the vhost_zerocopy_callback() maybe be called to decrease
> the refcount when sendmsg fails in tun. The error handling in vhost
> handle_tx_zerocopy() will try to decrease the same refcount again.
> This is wrong. To fix this issue, we only call vhost_net_ubuf_put()
> when vq->heads[nvq->desc].len == VHOST_DMA_IN_PROGRESS.
>
> Fixes: 0690899b4d45 ("tun: experimental zero copy tx support")
>
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Acked-by: Willem de Bruijn <willemb@google.com>

for next time: it's not customary to have an empty line between Fixes
and Signed-off-by
