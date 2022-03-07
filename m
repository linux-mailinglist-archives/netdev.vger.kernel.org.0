Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18694CF0A5
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 05:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiCGE3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 23:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiCGE3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 23:29:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7AB15DFA1
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 20:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646627305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9tbExO3BDZat3L0Mr6cR1o35ZQT83FwaaZZrCN3AvXs=;
        b=YNSZ0XbYf4DUUgEb0nyG3fm7GUkr+MxP4ku5vEqwv35OQxdWYO6p0ibq1SrPwmye2wvSSc
        MXLcOtm0WH+yY/I2+6cRPNXFkV2DZM9LPRQkd6fdFsm2qLI96E1sGX422OAP61rw/1enGm
        B3QJV6OyRaCtIRIRA93QlOEwQ4/JBuk=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-hg-ThEFZNRy9p2m7Zvqt6w-1; Sun, 06 Mar 2022 23:28:24 -0500
X-MC-Unique: hg-ThEFZNRy9p2m7Zvqt6w-1
Received: by mail-lj1-f199.google.com with SMTP id bf20-20020a2eaa14000000b0024634b36cdaso5953547ljb.0
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 20:28:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9tbExO3BDZat3L0Mr6cR1o35ZQT83FwaaZZrCN3AvXs=;
        b=WFL5r1TTyr89il+BMgOJCewwcXVnbCzUM4pbb1yuwMuB4sV/UrdC2hKUCr4qHTkB9s
         fMt7XsBQEmF8yISGgSrbp02krvUI9T5s3ARaZcek0b+lHYI7xRclhpax0mt86r3VWFOj
         bL8sUnhcjIk6wG1l5MEh0sNEVSLLAVAAY660KmoTAZ2EjKYlkz+DuFvnLMwIYQ2p7Okn
         pMbABLHHEesvXQCajTp+B0KwYCVot5YP0zvnKildZ8g4jOW2tZWCE5yfOp5BS6w7bMtZ
         dMEfHpuqkwVa3I5ZAU1CyFvByOD8jOU9DafLyu0cN2YJ+VgLbWm2kiKarypGkB3GmnZ0
         oTNQ==
X-Gm-Message-State: AOAM532Pwro4zOfvkjN1xVn7QJWucQDUSNNGBa2MEFmufn0PChQWSHO3
        mOXLiY4ltsuHTyQOtX/wMhbRK95Y1vtwBEgXKfMGHwTQQ4hiZ7KQyzFQ62W9p8l5HXoU642Skuw
        sApY54lERx91Ehbm3TFOJnOgczLZTUji0
X-Received: by 2002:a2e:b004:0:b0:247:e29f:fbd4 with SMTP id y4-20020a2eb004000000b00247e29ffbd4mr3315719ljk.315.1646627302500;
        Sun, 06 Mar 2022 20:28:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7t/FmOlAHsaca3+vPWPLkhh6GrRRORwyNVIv0iuzGeDQK5UazN9tjcM5HcXUU0LViwU9VgxZDMfLowP80K9M=
X-Received: by 2002:a2e:b004:0:b0:247:e29f:fbd4 with SMTP id
 y4-20020a2eb004000000b00247e29ffbd4mr3315706ljk.315.1646627302185; Sun, 06
 Mar 2022 20:28:22 -0800 (PST)
MIME-Version: 1.0
References: <20220305095525.5145-1-mail@anirudhrb.com>
In-Reply-To: <20220305095525.5145-1-mail@anirudhrb.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 7 Mar 2022 12:28:10 +0800
Message-ID: <CACGkMEtb6qSq2=WXWeaDZknw77C7pQwSgxP0-KxCCVhTyM-HwQ@mail.gmail.com>
Subject: Re: [PATCH v3] vhost: fix hung thread due to erroneous iotlb entries
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 5, 2022 at 5:56 PM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
>
> In vhost_iotlb_add_range_ctx(), range size can overflow to 0 when
> start is 0 and last is ULONG_MAX. One instance where it can happen
> is when userspace sends an IOTLB message with iova=size=uaddr=0
> (vhost_process_iotlb_msg). So, an entry with size = 0, start = 0,
> last = ULONG_MAX ends up in the iotlb. Next time a packet is sent,
> iotlb_access_ok() loops indefinitely due to that erroneous entry.
>
>         Call Trace:
>          <TASK>
>          iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
>          vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
>          vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
>          vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
>          kthread+0x2e9/0x3a0 kernel/kthread.c:377
>          ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>          </TASK>
>
> Reported by syzbot at:
>         https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
>
> To fix this, do two things:
>
> 1. Return -EINVAL in vhost_chr_write_iter() when userspace asks to map
>    a range with size 0.
> 2. Fix vhost_iotlb_add_range_ctx() to handle the range [0, ULONG_MAX]
>    by splitting it into two entries.
>
> Fixes: 0bbe30668d89e ("vhost: factor out IOTLB")
> Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> ---
> Changes in v3:
> 1. Simplify expression since start is always 0
> 2. Fix checkpatch issue
> 3. Add Fixes tag
>
> v2: https://lore.kernel.org/kvm/20220224143320.3751-1-mail@anirudhrb.com/
> Changes in v2:
> 1. Don't reject range [0, ULONG_MAX], split it instead.
> 2. Validate msg.size in vhost_chr_write_iter().
>
> v1: https://lore.kernel.org/lkml/20220221195303.13560-1-mail@anirudhrb.com/
>
> ---
>  drivers/vhost/iotlb.c | 11 +++++++++++
>  drivers/vhost/vhost.c |  5 +++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> index 670d56c879e5..40b098320b2a 100644
> --- a/drivers/vhost/iotlb.c
> +++ b/drivers/vhost/iotlb.c
> @@ -57,6 +57,17 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
>         if (last < start)
>                 return -EFAULT;
>
> +       /* If the range being mapped is [0, ULONG_MAX], split it into two entries
> +        * otherwise its size would overflow u64.
> +        */
> +       if (start == 0 && last == ULONG_MAX) {
> +               u64 mid = last / 2;
> +
> +               vhost_iotlb_add_range_ctx(iotlb, start, mid, addr, perm, opaque);

Do we need to check the errors and fail?

Others look good.

Thanks

> +               addr += mid + 1;
> +               start = mid + 1;
> +       }
> +
>         if (iotlb->limit &&
>             iotlb->nmaps == iotlb->limit &&
>             iotlb->flags & VHOST_IOTLB_FLAG_RETIRE) {
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..55475fd59fb7 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1170,6 +1170,11 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>                 goto done;
>         }
>
> +       if (msg.size == 0) {
> +               ret = -EINVAL;
> +               goto done;
> +       }
> +
>         if (dev->msg_handler)
>                 ret = dev->msg_handler(dev, &msg);
>         else
> --
> 2.35.1
>

