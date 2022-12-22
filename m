Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0749A653D68
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 10:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbiLVJUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 04:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbiLVJU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 04:20:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0127820F45
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 01:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671700780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mZAWSv5M153WIjy8BKTsqFkdNutmq5ALdbbPWu1odZ4=;
        b=ixt/L82wUxv+nEu3ux1qvROfTCR5mr1nqku847fFTiR7FPCSEs9hvLuThbn/GCTJu6kes3
        K2zxCIIK/v2QYjDJQyhTjxDPcCdm4iz9U11kLZxWBN1eUzFEuSC5nCcsyjQnn5GX/6Ul01
        neiqblhuPNLKIZCz8tBj9LRxZpe9sbg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-437-QF9-YeDROEuITy7N_zFItw-1; Thu, 22 Dec 2022 04:19:38 -0500
X-MC-Unique: QF9-YeDROEuITy7N_zFItw-1
Received: by mail-ed1-f69.google.com with SMTP id g14-20020a056402090e00b0046790cd9082so1111005edz.21
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 01:19:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mZAWSv5M153WIjy8BKTsqFkdNutmq5ALdbbPWu1odZ4=;
        b=RF2PfWDvNL2imDYguatA7rEQ3sIq5VkTtkpieMgNv8GpEckYT5mttjOwEASLwcO/C0
         ohVlLsEXKfRZwnCm+h6g6UVcEVmsOOGPJl8f0P4UPLhp+N3UFupr4yk/flbTlsw0Iwud
         PvyYLS1AruKaGAtIYeYNqTFoFR53RXX0XC3WMwz3GtB2orVJIp92H5TnUKFO+VL2y571
         DBs3dyO6jJj+sKfJb0wKrLFSPTsO/eAasN3pijjRz6T9otv0p70J8+pjTefQyr4FFEH7
         +G7HpNvSGiva0OmIpTKwAFSjriK9grmCYFjmDyTUsPEAIUfsmb739MIMYU3sGL+E0qQH
         eZZA==
X-Gm-Message-State: AFqh2krEQKXGVd/7TN2lHFesplstqtyYPAiWTtG7HFimdmNoZr0AKbhF
        OuNusKPhG97WFsF+rEnT/LdYZyBVmLmMiM47RwdN5OwVDo9/oIE3PqE3WlBBNdceiDAUvuxE7Ub
        JJHol3IdavkS9z0Slv+maxCI3p9gjkl5a
X-Received: by 2002:aa7:dd41:0:b0:46f:a73d:6bd7 with SMTP id o1-20020aa7dd41000000b0046fa73d6bd7mr418026edw.93.1671700777538;
        Thu, 22 Dec 2022 01:19:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvkyiuhyBopip+XvfvYqHHMpinouZZJTlfKlm1DIvH+vHsGNjxuontzwrB3mM8x3c2b5FEYMldk6bz7E7v/Ec4=
X-Received: by 2002:aa7:dd41:0:b0:46f:a73d:6bd7 with SMTP id
 o1-20020aa7dd41000000b0046fa73d6bd7mr418019edw.93.1671700777332; Thu, 22 Dec
 2022 01:19:37 -0800 (PST)
MIME-Version: 1.0
References: <20221222060427.21626-1-jasowang@redhat.com> <20221222060427.21626-5-jasowang@redhat.com>
In-Reply-To: <20221222060427.21626-5-jasowang@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 22 Dec 2022 10:19:00 +0100
Message-ID: <CAJaqyWetutMj=GrR+ieS265_aRr7OhoP+7O5rWgPnP+ZAyxbPg@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq command
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
        alvaro.karsz@solid-run.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 22, 2022 at 7:05 AM Jason Wang <jasowang@redhat.com> wrote:
>
> We used to busy waiting on the cvq command this tends to be
> problematic since:
>
> 1) CPU could wait for ever on a buggy/malicous device
> 2) There's no wait to terminate the process that triggers the cvq
>    command
>
> So this patch switch to use sleep with a timeout (1s) instead of busy
> polling for the cvq command forever. This gives the scheduler a breath
> and can let the process can respond to a signal.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/virtio_net.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8225496ccb1e..69173049371f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -405,6 +405,7 @@ static void disable_rx_mode_work(struct virtnet_info *vi)
>         vi->rx_mode_work_enabled = false;
>         spin_unlock_bh(&vi->rx_mode_lock);
>
> +       virtqueue_wake_up(vi->cvq);
>         flush_work(&vi->rx_mode_work);
>  }
>
> @@ -1497,6 +1498,11 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
>         return !oom;
>  }
>
> +static void virtnet_cvq_done(struct virtqueue *cvq)
> +{
> +       virtqueue_wake_up(cvq);
> +}
> +
>  static void skb_recv_done(struct virtqueue *rvq)
>  {
>         struct virtnet_info *vi = rvq->vdev->priv;
> @@ -2024,12 +2030,7 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
>         if (unlikely(!virtqueue_kick(vi->cvq)))
>                 return vi->ctrl->status == VIRTIO_NET_OK;
>
> -       /* Spin for a response, the kick causes an ioport write, trapping
> -        * into the hypervisor, so the request should be handled immediately.
> -        */
> -       while (!virtqueue_get_buf(vi->cvq, &tmp) &&
> -              !virtqueue_is_broken(vi->cvq))
> -               cpu_relax();
> +       virtqueue_wait_for_used(vi->cvq, &tmp);
>
>         return vi->ctrl->status == VIRTIO_NET_OK;
>  }
> @@ -3524,7 +3525,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>
>         /* Parameters for control virtqueue, if any */
>         if (vi->has_cvq) {
> -               callbacks[total_vqs - 1] = NULL;
> +               callbacks[total_vqs - 1] = virtnet_cvq_done;

If we're using CVQ callback, what is the actual use of the timeout?

I'd say there is no right choice neither in the right timeout value
nor in the action to take. Why not simply trigger the cmd and do all
the changes at command return?

I suspect the reason is that it complicates the code. For example,
having the possibility of many in flight commands, races between their
completion, etc. The virtio standard does not even cover unordered
used commands if I'm not wrong.

Is there any other fundamental reason?

Thanks!

>                 names[total_vqs - 1] = "control";
>         }
>
> --
> 2.25.1
>

