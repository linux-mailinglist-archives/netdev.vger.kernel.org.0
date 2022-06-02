Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64E453B46E
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 09:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbiFBHif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 03:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiFBHi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 03:38:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 484091AD
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 00:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654155506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8S6wLquatnItcWZvek3jQW4rbdDmqnYoTMJmalyKWOA=;
        b=Gict0QZ00EbVFl9ecjE5uliewt/il/QZYt+EzaUWopc8z75qqN7m0KVlPlgA/MP+lP1IBH
        CubtzIggpFBMQH8sj3VKI5AXJ8Jz3auNXRR3+RJ88qLZPj4RYAglr/vnhv/IpLqXRPBOyP
        263y8aBnz104qDVbtJEIZXauR4f36tc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-PvAm9-sNPyiBQHmqATzt0A-1; Thu, 02 Jun 2022 03:38:25 -0400
X-MC-Unique: PvAm9-sNPyiBQHmqATzt0A-1
Received: by mail-lf1-f72.google.com with SMTP id h35-20020a0565123ca300b00479113319f9so346341lfv.0
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 00:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8S6wLquatnItcWZvek3jQW4rbdDmqnYoTMJmalyKWOA=;
        b=ajrtuVDUtIayBW5V8CrjosxUPdYoJAkDjmnYh10lQAhzUgdOtMTp6KgrKekUxDEyeG
         DzGSRztjjSz2Xtrxpj/N5WfIUVSPE56qPLHyv2oddKOK0SAsmP0VzKpNnduUh4MbPu7V
         Sy8faBSYROZxFzHOKgSbaIoOZ6v21Hje/wP/w7+Ypk7wDrJFri5jn7U5ogVA/1UC8C53
         jPE688f6Qw1Ij1tBRua0eNa4j+s8nU4Y8jeCvp4/0Z00cAZPIbjr4OugazIgPs3xW6L0
         VqL38+Cmn9ZCPVawGOXOqckv0V4fCAqHKYQQVP1FlKaMeaOYl7EhMxrqrLMyx1080f8h
         QsCw==
X-Gm-Message-State: AOAM53297o71JvbVSuRYxbLYFF1zyacJpvli1C0OAilqRQdyuxLjSUzn
        VOz4Jt963GQhYjSkCnCdrGvZRC5/jlfvhOiJcP/oI6tfYKNgBtGSMvNM+6TqTXuk2bgGni+fWDC
        1sTaa4spaXMADJYAc87DyVTGsdAjogxeW
X-Received: by 2002:a05:6512:39d2:b0:478:5ad6:1989 with SMTP id k18-20020a05651239d200b004785ad61989mr2530128lfu.98.1654155503031;
        Thu, 02 Jun 2022 00:38:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3O4k++MCpHtSuiX0ROlBjtZNZwtRKVz3FtxIFV/35s1PaTj2JIOrFkGUSJoEUttxJ7HDNqg4mOwQC1G1H/kg=
X-Received: by 2002:a05:6512:39d2:b0:478:5ad6:1989 with SMTP id
 k18-20020a05651239d200b004785ad61989mr2530120lfu.98.1654155502840; Thu, 02
 Jun 2022 00:38:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220602023845.2596397-1-lingshan.zhu@intel.com> <20220602023845.2596397-6-lingshan.zhu@intel.com>
In-Reply-To: <20220602023845.2596397-6-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 2 Jun 2022 15:38:11 +0800
Message-ID: <CACGkMEtCKT5ib_+gUdryDXfxntTr_JF7fZpeePZ+=BFjY_TG+w@mail.gmail.com>
Subject: Re: [PATCH 5/6] vDPA: answer num of queue pairs = 1 to userspace when
 VIRTIO_NET_F_MQ == 0
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue pair,
> so when userspace querying queue pair numbers, it should return mq=1
> than zero

Spec said:

"max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ is set"

So we are probably fine.

Thanks

>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/vdpa.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 030d96bdeed2..50a11ece603e 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -818,9 +818,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>         u16 val_u16;
>
>         if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
> -               return 0;
> +               val_u16 = 1;
> +       else
> +               val_u16 = le16_to_cpu((__force __le16)config->max_virtqueue_pairs);
>
> -       val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
>         return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
>  }
>
> --
> 2.31.1
>

