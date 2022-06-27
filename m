Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550D955B538
	for <lists+netdev@lfdr.de>; Mon, 27 Jun 2022 04:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbiF0Ca7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 22:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiF0Ca6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 22:30:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 220FC2AF7
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 19:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656297056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kJbcwB7EfNKpZ99plzFtpzkiIgmO0GfWqgxD6ydKGBA=;
        b=O+AVCCYAVcZ+unyq4WDBIyDHCnIFtjwZo6ua7+oY0je044DHpfBv0eDeF6Hz3+NTx89/1S
        2yOBQnJsh5l/n1+5eSWxKWMcIuxw2OsDc75iVnp4Om5NxZxK6A893PBKr0Et8zHNpxxIiJ
        Wxeq0YhxOcC/pmsRN5NePbhyJaEOap4=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-nsYNcorGPLSF5cjCuTCLYQ-1; Sun, 26 Jun 2022 22:30:54 -0400
X-MC-Unique: nsYNcorGPLSF5cjCuTCLYQ-1
Received: by mail-lf1-f71.google.com with SMTP id i3-20020a056512318300b0047f86b47910so3983567lfe.14
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 19:30:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kJbcwB7EfNKpZ99plzFtpzkiIgmO0GfWqgxD6ydKGBA=;
        b=rplsHV7mmenhWI9bb3p/tgRIYOrnHdE9L/7PGVmXHs2NnNx8sEjSwfMGy454N4f8Ng
         +omSZouXK21Oe7Acxx0xavJQzCR8XzxvvredIhgdBUukZi23zZSwUTKaESjuJJUjr85R
         azk23ysM38utf/j1stkoDpw44xkxILy711CLnBrm2vtrLjYN2tBOCWyfQ9OrWyuZvKa5
         TmblzB9EptbVBweNztd4SLInp13FEnQNnNzEH38EcYfmUufen7lihNH3XVmG9OiwE8i2
         ots7qyLyjBGfy0iPvW1PlR/9CrGZrPyGF+dlmAFYPTtjKkviXGZkkyCVTvYDn1bJ+J1H
         lstw==
X-Gm-Message-State: AJIora+8kKB/gKcJfNfjg1lIiLUafeLKHhmlEuYFJdBCKf++BiC5w0g2
        Fu6ZyotbCx5ObRcgS7aYZPolkEwXrPjM1rx3g5Egg/c7fMQ5rMhtvfxqjnDksGmV1lB0sKF/hML
        4TsaQPf0XIfLvp16anuT5d4mcGmq5DOEm
X-Received: by 2002:a05:6512:13a5:b0:47d:c1d9:dea8 with SMTP id p37-20020a05651213a500b0047dc1d9dea8mr6773789lfa.442.1656297053244;
        Sun, 26 Jun 2022 19:30:53 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ur82ARcDJaALzWVAunDCgq4vaJSklh1IynesHEAuaeWnmZYcX/Br+tGQmrs/x93fW3c+90sT9mKBAdQ35aQEI=
X-Received: by 2002:a05:6512:13a5:b0:47d:c1d9:dea8 with SMTP id
 p37-20020a05651213a500b0047dc1d9dea8mr6773770lfa.442.1656297053073; Sun, 26
 Jun 2022 19:30:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220624025621.128843-1-xuanzhuo@linux.alibaba.com>
 <20220624025621.128843-26-xuanzhuo@linux.alibaba.com> <20220624025817-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220624025817-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 27 Jun 2022 10:30:42 +0800
Message-ID: <CACGkMEseptD=45j3kQr0yciRxR679Jcig=292H07-RYC2vXmFQ@mail.gmail.com>
Subject: Re: [PATCH v10 25/41] virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        kangjie.xu@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 2:59 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Jun 24, 2022 at 10:56:05AM +0800, Xuan Zhuo wrote:
> > Add queue_notify_data in struct virtio_pci_common_cfg, which comes from
> > here https://github.com/oasis-tcs/virtio-spec/issues/89
> >
> > For not breaks uABI, add a new struct virtio_pci_common_cfg_notify.
>
> What exactly is meant by not breaking uABI?
> Users are supposed to be prepared for struct size to change ... no?

Not sure, any doc for this?

Thanks


>
>
> > Since I want to add queue_reset after queue_notify_data, I submitted
> > this patch first.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  include/uapi/linux/virtio_pci.h | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> > index 3a86f36d7e3d..22bec9bd0dfc 100644
> > --- a/include/uapi/linux/virtio_pci.h
> > +++ b/include/uapi/linux/virtio_pci.h
> > @@ -166,6 +166,13 @@ struct virtio_pci_common_cfg {
> >       __le32 queue_used_hi;           /* read-write */
> >  };
> >
> > +struct virtio_pci_common_cfg_notify {
> > +     struct virtio_pci_common_cfg cfg;
> > +
> > +     __le16 queue_notify_data;       /* read-write */
> > +     __le16 padding;
> > +};
> > +
> >  /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
> >  struct virtio_pci_cfg_cap {
> >       struct virtio_pci_cap cap;
> > --
> > 2.31.0
>

