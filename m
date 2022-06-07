Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0E553F5F5
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 08:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbiFGGPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 02:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiFGGPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 02:15:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26F2BD6820
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 23:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654582512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IwobWdiv7zoiQQTttGF2XO0A4bzubaGTbiuN7Fw0a3s=;
        b=M5U15PZDsr8jUWgNqWeUASbhrjHWS8DmDpnjQm1OedSjPcGIFhdT8oZJFYIFjqRfB7KPTu
        /I574UZXO3oxlB53aJvS1gUSdk2/vAynMmisnxv2RGrkUoqEVIrYPn9pEAT9b5dDBQmGDk
        GOV+hWHY+ToG2E8CYAmq+rBD87WgRtQ=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-Gm4_lvs5PDyvWC69klu8_w-1; Tue, 07 Jun 2022 02:15:10 -0400
X-MC-Unique: Gm4_lvs5PDyvWC69klu8_w-1
Received: by mail-lj1-f198.google.com with SMTP id g13-20020a2eb5cd000000b00255ac505e62so143297ljn.1
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 23:15:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IwobWdiv7zoiQQTttGF2XO0A4bzubaGTbiuN7Fw0a3s=;
        b=x1PIYCXGLYISqqst9Svi2u35JjT2yGQUDlsjovGavzYfGm1p3khz0e6acNv1gp+7eN
         W81Ywr/hj7zjwzGssVmkH8rA1YWBRhqCURN58UTORlTIA6Q9D75qn63x5m1YlbgtGo5h
         u1I0nIChk9Zzs/lNRELJ9KI9kTUTfd/NDVIGczfIuvqyHI7HuZ8BOQLxC6qmF47yJkBB
         fHJ9vdIggfrxXrkn9Jvtnjz5E4AhoUR8z9aN62Wb2tC11rtoT3/+lmhwdzN0435dgx/H
         f7k2dlmIwsQllVE0QDYYWp/YHBW8oP0gCwOGRvKf2c4fBoXu4X14OZGBocy2mv643Jt6
         phtw==
X-Gm-Message-State: AOAM531t1BTh4/IzuGwLOT8f21C69eQBYtmkajHzhBbF1+w1Pm6XiERk
        QZZUmv+gjqU1Svy8vc0L/zxE94hoNWm7s1rThNwZ2NruBPoxVXTd+tbfT1IQenONzipMkLdhN0H
        17spKmVEe3+ZVVXEqnktDYaZfaNYqgmYN
X-Received: by 2002:ac2:4e0f:0:b0:479:54a6:f9bb with SMTP id e15-20020ac24e0f000000b0047954a6f9bbmr3745343lfr.257.1654582508791;
        Mon, 06 Jun 2022 23:15:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwbCHzOStBHS1kLdIsx0TiIAu+B9gjJ7P5zEhkh8poeSMqphGgkX5Eleo+aghrpoYD9Dn3nIpc/a1Ofv3vqOc=
X-Received: by 2002:ac2:4e0f:0:b0:479:54a6:f9bb with SMTP id
 e15-20020ac24e0f000000b0047954a6f9bbmr3745336lfr.257.1654582508590; Mon, 06
 Jun 2022 23:15:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220602023845.2596397-1-lingshan.zhu@intel.com>
 <20220602023845.2596397-6-lingshan.zhu@intel.com> <CACGkMEtCKT5ib_+gUdryDXfxntTr_JF7fZpeePZ+=BFjY_TG+w@mail.gmail.com>
 <f86049b5-1eb1-97e7-654c-d3cde0e62aa7@intel.com>
In-Reply-To: <f86049b5-1eb1-97e7-654c-d3cde0e62aa7@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 7 Jun 2022 14:14:57 +0800
Message-ID: <CACGkMEuXjUMUTNAQUHr=_n1BiQkz0FD5+t52636uTuM36h-0Kw@mail.gmail.com>
Subject: Re: [PATCH 5/6] vDPA: answer num of queue pairs = 1 to userspace when
 VIRTIO_NET_F_MQ == 0
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 4:22 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>
>
>
> On 6/2/2022 3:38 PM, Jason Wang wrote:
> > On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> >> If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue pair,
> >> so when userspace querying queue pair numbers, it should return mq=1
> >> than zero
> > Spec said:
> >
> > "max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ is set"
> >
> > So we are probably fine.
> I thinks it is asking how many queue
> pairs(VDPA_ATTR_DEV_NET_CFG_MAX_VQP), so answering 0 may not be correct.
>
> Thanks,
> Zhu Lingshan

Please add the result of the userspace vdpa tool before and after this
patch in the changlog in next version.

Thanks

> >
> > Thanks
> >
> >> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> >> ---
> >>   drivers/vdpa/vdpa.c | 5 +++--
> >>   1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> >> index 030d96bdeed2..50a11ece603e 100644
> >> --- a/drivers/vdpa/vdpa.c
> >> +++ b/drivers/vdpa/vdpa.c
> >> @@ -818,9 +818,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
> >>          u16 val_u16;
> >>
> >>          if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
> >> -               return 0;
> >> +               val_u16 = 1;
> >> +       else
> >> +               val_u16 = le16_to_cpu((__force __le16)config->max_virtqueue_pairs);
> >>
> >> -       val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
> >>          return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
> >>   }
> >>
> >> --
> >> 2.31.1
> >>
>

