Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B15E5EB947
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 06:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiI0EiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 00:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiI0EiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 00:38:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D77EACA20
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 21:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664253497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YvoMQQlEryHzODM1sEcbq2UTTJwK38dUW+JesBnUtoI=;
        b=T2kq8cnGJCfK7RyuE4xfAG50U9HtpGtT9pN2o/22kNSWQPO7ByPDkQ6KDaZjJG79UVr0Rc
        CARn5V60f3y+DV5T/zx1cxYZDycaXbzeIdT8CpEts0K/3EsMak7QY0NvCxPk1BjgzJeEY6
        Iz8IXOL8i2HWH9no/xMBiJF9Sq0mPtI=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-167-65fGLUghPAW0aITKvkOWxw-1; Tue, 27 Sep 2022 00:38:15 -0400
X-MC-Unique: 65fGLUghPAW0aITKvkOWxw-1
Received: by mail-ot1-f72.google.com with SMTP id l18-20020a0568301d7200b00655f6197d9dso4197332oti.5
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 21:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=YvoMQQlEryHzODM1sEcbq2UTTJwK38dUW+JesBnUtoI=;
        b=Ik+lSRzurfc3Ehwj7Wq+j+DBzEOaKQAl2jCJU+dvhulr/plcvH47BQQEF2PB+cfnfK
         ppWEZcklS94iSgmiK5+dbGE2wl70yaE9SZ7dke9OxEs+v1UlJ8+7nMO+/sTETYBXp7R1
         UdP5Q35OL4b5QxkXYhV2rMcSNMCABQVUMKVIP5eBEroyT8oIXuwvCWYdiuHT5LGRGbKB
         QsWoQ4tn4UcMQPPzOe8+PU2MxnoZnVMUjYJWJ/dquG35aiYTU1AaSn2+/CIln17B8Ric
         lF+5F9e+BNzA7efjh/3fNDnEQfeL0JCSrxx/DAce0ObxcEj6j4s2XSxUOK6Snbdv5Xhy
         uNtw==
X-Gm-Message-State: ACrzQf30XA4me+Ua1Sj4vaLJ4ZSrVEt98dZGDvwscEIBLwAQM/6WvfP+
        uZwE82hVM8mQGoCmazr8y19B13/WNavNKtffTsQ2WXr1xBPZ2EvVRDrN1rSEHcH9N0SYgM5EFUn
        St0k/ydyS8H3t11DfbgT84UM/tyJlqRSI
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id bx34-20020a0568081b2200b00350c0f670ffmr947694oib.35.1664253494787;
        Mon, 26 Sep 2022 21:38:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Y2cfb+vwgFJjFYaenS5cjGkB+F68aaugASVk8P/h+ix7i0pb9U9SgX0ojSutoniNgQV3lWGR/xhFLwDhdg2E=
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id
 bx34-20020a0568081b2200b00350c0f670ffmr947690oib.35.1664253494632; Mon, 26
 Sep 2022 21:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220927030117.5635-1-lingshan.zhu@intel.com> <20220927030117.5635-4-lingshan.zhu@intel.com>
In-Reply-To: <20220927030117.5635-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 27 Sep 2022 12:38:03 +0800
Message-ID: <CACGkMEs3C==_sJBC94enpj=4a9KxDbFKcwMsCsECbPn2QYBv4w@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND 3/6] vDPA: check VIRTIO_NET_F_RSS for
 max_virtqueue_paris's presence
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 11:09 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> virtio 1.2 spec says:
> max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ or
> VIRTIO_NET_F_RSS is set.
>
> So when reporint MQ to userspace, it should check both
> VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS.
>
> unused parameter struct vdpa_device *vdev is removed
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vdpa/vdpa.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index e7765953307f..829fd4cfc038 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -800,13 +800,13 @@ static int vdpa_nl_cmd_dev_get_dumpit(struct sk_buff *msg, struct netlink_callba
>         return msg->len;
>  }
>
> -static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
> -                                      struct sk_buff *msg, u64 features,
> +static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
>                                        const struct virtio_net_config *config)
>  {
>         u16 val_u16;
>
> -       if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
> +       if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0 &&
> +           (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
>                 return 0;
>
>         val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
> --
> 2.31.1
>

