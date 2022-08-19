Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2FD5991F8
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 02:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239415AbiHSAzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 20:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiHSAzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 20:55:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F14BC04C2
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660870544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nAd/+cM4nZ9kiL+UQq/k1a1/NhUGZtyDcD6og5LvfI0=;
        b=YkXuRSRiDsknmVR7rbbnNyhzTaWJrjCyVKjTR2dk1lZGlXSUUhZRkpMwHCp0wKpI+j4D2r
        1ZmPHCWbObdWLY1AvcjcsY9lRS8pHiuSR5Vlr+ZUMF3Q6SJaFvLT/fz+ScpzKRPmksGurY
        AMAlHIUg5DKmzjM3g3l/o4RzKM73iuE=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-373-kUMrvmGPPxiVXExGDdGsKw-1; Thu, 18 Aug 2022 20:55:43 -0400
X-MC-Unique: kUMrvmGPPxiVXExGDdGsKw-1
Received: by mail-lf1-f69.google.com with SMTP id x29-20020ac259dd000000b0048af0e04887so962633lfn.12
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:55:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=nAd/+cM4nZ9kiL+UQq/k1a1/NhUGZtyDcD6og5LvfI0=;
        b=bQyfu3DsQfctFCfd6Cn+TKu6Rf/r3bBJBycltbadK5eTR9KfilvJGTpOQQSQnMW6no
         qIlL7K89Ms9YIc9JlvGWCpBIfsSqJHDpnSFAlRClVEBQkK6r1Q77wI/bJMBlHJhzKRdv
         zIBtglG0xadHE7X/mfLOj3cK4Bw5GXFUUu3xhNpXnxsxRVp6ertzOMYdEkX5xZa3yg/g
         kRalsb8Ur9bKr5NGm5P/r7HZt5u+K9ZCk4zCUTydoYZ5R9izJfkbfNJLgaT/njyuezVv
         BgZtMPxg2zkcxPRbRa3I/Efdg8UJu9SM2b6WZPnAv3hFeq0dWfKiSMd+jP8ZDnAypYN2
         EpjQ==
X-Gm-Message-State: ACgBeo3meI0OUCTE4vRrR32sQPaj3wPtZYfM4MOfJEXhtRTrCho9G1sB
        YpyBf0Opw3CXNDudL86fa9qEysnsn9TJl7caVNDXrZcb1Xhszf/tJE7ZQI+V35iCuWNfHenDoHI
        256gZiU1CMGC4WQnKr27tVHVJ5IGXdy5m
X-Received: by 2002:a2e:a5c3:0:b0:261:ac2d:2820 with SMTP id n3-20020a2ea5c3000000b00261ac2d2820mr1575613ljp.243.1660870541936;
        Thu, 18 Aug 2022 17:55:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5yNZcX0ZYYl5wi2Ajj1Zn3BopMcLzRyHDmesw1YcQgFxMbsXTpyZrKS/KZ/n0mefgLfPKqM+qY83EfJJoPgEg=
X-Received: by 2002:a2e:a5c3:0:b0:261:ac2d:2820 with SMTP id
 n3-20020a2ea5c3000000b00261ac2d2820mr1575598ljp.243.1660870541756; Thu, 18
 Aug 2022 17:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220811135353.2549658-1-eperezma@redhat.com> <20220811135353.2549658-2-eperezma@redhat.com>
In-Reply-To: <20220811135353.2549658-2-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 19 Aug 2022 08:55:30 +0800
Message-ID: <CACGkMEvz3kKKhpnn6=P1BiSYgvDaSx_t_QuTAKo6yYC8UH_aAA@mail.gmail.com>
Subject: Re: [PATCH v8 1/3] vdpa: delete unreachable branch on vdpasim_suspend
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, ecree.xilinx@gmail.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Laurent Vivier <lvivier@redhat.com>,
        Martin Porter <martinpo@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Eli Cohen <elic@nvidia.com>, Cindy Lu <lulu@redhat.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 9:54 PM Eugenio P=C3=A9rez <eperezma@redhat.com> wr=
ote:
>
> It was a leftover from previous versions.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdp=
a_sim.c
> index 213883487f9b..79a50edf8998 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -509,16 +509,9 @@ static int vdpasim_reset(struct vdpa_device *vdpa)
>  static int vdpasim_suspend(struct vdpa_device *vdpa)
>  {
>         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> -       int i;
>
>         spin_lock(&vdpasim->lock);
>         vdpasim->running =3D false;
> -       if (vdpasim->running) {
> -               /* Check for missed buffers */
> -               for (i =3D 0; i < vdpasim->dev_attr.nvqs; ++i)
> -                       vdpasim_kick_vq(vdpa, i);
> -
> -       }
>         spin_unlock(&vdpasim->lock);
>
>         return 0;
> --
> 2.31.1
>

