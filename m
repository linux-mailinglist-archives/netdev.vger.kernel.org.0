Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C126532882
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 13:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbiEXLHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 07:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234063AbiEXLHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 07:07:00 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0186D849
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 04:06:59 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-edeb6c3642so21794135fac.3
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 04:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VKKe+6qBQIm12lCUpH0Sxp4+NXI90A0uXZAqIc10ncY=;
        b=HwVDCzwjATjlGAIJ3+JeU4cM+iRQQ0fGccnqZgJ7Dwvs7Q6IFYDh0GJqXRziKDGGJ+
         H9tvhZs5mxuIKSyQC8CFDXsKX9ogyBkEB/C1aD8YRjrHCStbKZ1iVsKD1nOiQ0QWAPWV
         JqX6sDB6TFi1tf4w85qQNxyJD6rUNFrzCCJoivsunDquhDIaodahgeZJjaW3QwR6inhe
         ISTLZAj0L19EcmGbVQEmwkVQGCiok/ehKp4L+eIeGMrwa6PmU+sPKAop8VeTZlsy26CB
         4Cjd11YnAUYOcDGo8S0E56AxsYEHrAr1H/kAB3H8yRT9WAX0cj6wDvMJ38vJpf/aqHA1
         K9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VKKe+6qBQIm12lCUpH0Sxp4+NXI90A0uXZAqIc10ncY=;
        b=VwwfaXm+XxSsubDWCJUU3a9JuH4LF2IYOSZhwiDK/Sw66XfB+ezDvSbHEyfkB7ar47
         RGCLOKJIl2gB3XUCzsyc0OUEl9eOjjduHC9mWkdfmloHyyNkNTEvksv9zAVTemcI659B
         fgIThE3j67HtXBpiCoZldr13yH/3UcAsKGsGBs4ELr3dJf221p3ILWUwdbERcnEH3ZEi
         /rubFAQItHvubZLFStPcNKUEt3qDFqiVkqCgfDSBHyv+PTPiy2Ox5fITRUAVs81T5c9k
         BtTysUR/oF+o/VtV54qX2FfFA/nsVwbZTwViPJ4ajik3RJRHidafQ80LPrZXnxVgZNtS
         G0dw==
X-Gm-Message-State: AOAM5311blnowCJUf13wZ9BU/7eJY+rQq0stsl5YtyQqsZsutzfoirMs
        LguDRHnp9fX9d/iUd6wKJqll8j22wfJJTyEsfecpaQ==
X-Google-Smtp-Source: ABdhPJzhl26EPYePCoZDxKKBpid3sxP95MD1D8lQQk/DlugmdrO4YT7uA/zZbc8AT4HaqELuAJenHw20CnIPSKMbeCQ=
X-Received: by 2002:a05:6870:4184:b0:f1:97d2:6696 with SMTP id
 y4-20020a056870418400b000f197d26696mr2104578oac.148.1653390417932; Tue, 24
 May 2022 04:06:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220512112347.18717-1-andrew@daynix.com> <CACGkMEvH1yE0CZYdstAK32DkEucejNO+V7PEAZD_641+rp2aKA@mail.gmail.com>
In-Reply-To: <CACGkMEvH1yE0CZYdstAK32DkEucejNO+V7PEAZD_641+rp2aKA@mail.gmail.com>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Tue, 24 May 2022 14:06:46 +0300
Message-ID: <CABcq3pFJcsoj+dDf6tirT_hfTB6rj9+f6KNFafwg+usqYwTdDA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] TUN/VirtioNet USO features support.
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, mst <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

The issue is that host segments packets between guests on the same host.
Tests show that it happens because SKB_GSO_DODGY skb offload in
virtio_net_hdr_from_skb().
To do segmentation you need to remove SKB_GSO_DODGY or add SKB_GSO_PARTIAL
The solution with DODGY/PARTIAL offload looks like a dirty hack, so
for now, I've lived it as it is for further investigation.


On Tue, May 17, 2022 at 9:32 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Thu, May 12, 2022 at 7:33 PM Andrew Melnychenko <andrew@daynix.com> wrote:
> >
> > Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
> > Technically they enable NETIF_F_GSO_UDP_L4
> > (and only if USO4 & USO6 are set simultaneously).
> > It allows to transmission of large UDP packets.
> >
> > Different features USO4 and USO6 are required for qemu where Windows guests can
> > enable disable USO receives for IPv4 and IPv6 separately.
> > On the other side, Linux can't really differentiate USO4 and USO6, for now.
> > For now, to enable USO for TUN it requires enabling USO4 and USO6 together.
> > In the future, there would be a mechanism to control UDP_L4 GSO separately.
> >
> > Test it WIP Qemu https://github.com/daynix/qemu/tree/Dev_USOv2
> >
> > New types for VirtioNet already on mailing:
> > https://lists.oasis-open.org/archives/virtio-comment/202110/msg00010.html
> >
> > Also, there is a known issue with transmitting packages between two guests.
>
> Could you explain this more? It looks like a bug. (Or any pointer to
> the discussion)
>
> Thanks
>
> > Without hacks with skb's GSO - packages are still segmented on the host's postrouting.
> >
> > Andrew (5):
> >   uapi/linux/if_tun.h: Added new offload types for USO4/6.
> >   driver/net/tun: Added features for USO.
> >   uapi/linux/virtio_net.h: Added USO types.
> >   linux/virtio_net.h: Support USO offload in vnet header.
> >   drivers/net/virtio_net.c: Added USO support.
> >
> >  drivers/net/tap.c               | 10 ++++++++--
> >  drivers/net/tun.c               |  8 +++++++-
> >  drivers/net/virtio_net.c        | 19 +++++++++++++++----
> >  include/linux/virtio_net.h      |  9 +++++++++
> >  include/uapi/linux/if_tun.h     |  2 ++
> >  include/uapi/linux/virtio_net.h |  4 ++++
> >  6 files changed, 45 insertions(+), 7 deletions(-)
> >
> > --
> > 2.35.1
> >
>
