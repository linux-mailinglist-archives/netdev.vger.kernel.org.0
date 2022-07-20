Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B831157B180
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiGTHP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiGTHP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:15:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB2B613CF8
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658301324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yV3Z2US3lJGM8Odcv2oPe9zY/cE+J6SYHmjcc47m2lQ=;
        b=OcA6og3SZ0vUk/rC3Uj6GuglqcW+6nh0TE/Y3jg10oC9Kf8VvtYbnTI3BC8tDMqyYdBI10
        4awYLwxyJYfx2e6iXB0XzBkZJQz1DSlSbztDJl99DI8Y4uHt07XIHbPl5m8YyyHqtc7XSm
        TGpVbfgFeWhUFm4idDs4KnwRU9L11FY=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-VCkLmAJCOMivvoLzAs6hjg-1; Wed, 20 Jul 2022 03:15:21 -0400
X-MC-Unique: VCkLmAJCOMivvoLzAs6hjg-1
Received: by mail-lf1-f71.google.com with SMTP id z28-20020a0565120c1c00b0048a2049d2feso5541898lfu.22
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:15:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yV3Z2US3lJGM8Odcv2oPe9zY/cE+J6SYHmjcc47m2lQ=;
        b=UcLfru/5qLazVRtb95Rkzt9TBjlHlmFM+guDL1dsGk98NiKTijE7vnVoNhJNL5c7vm
         OFBDsbuy3H3nlKVZ0BiIz7ux7P3NfnRUUhxLZySgqdvJ2k0ECXWC+j+ZmHyY6k3SKvwp
         c1KPgl2m9uYY6bU3xFtVR3fPFZDRSwi0wCiskdictaR7NAbPMDj5YD6xQ8G5f4vfrqsw
         AQPnlpZchDJxCmADfXRfXkl+OP8LUwSrZQJkQ/TcATOLgnl+WklZdkKDFqgnZ7oOg1sm
         CUpw3lDWBHtyIZwHnDBu+G4KD4L/sQ7s3IIJb6O7AhBieLan+siEBgYYDp4dMGesI2kN
         O6Bg==
X-Gm-Message-State: AJIora+AjrFhVVedh1tvhRJwb4ILpfA/Aycr/6eEtZuj5sJP6c7Nd7N0
        H21lEpwP0WhQQC9wQIC3tDpy8fiyL2oHxx1g78PdCFOQheLaHgvkyRUdJQpLywgBl+u4z0YCy7i
        N/4XjVTrUPrjJwVPy/zTlSRmS/T821LaM
X-Received: by 2002:a05:6512:3c95:b0:48a:3d1:9df with SMTP id h21-20020a0565123c9500b0048a03d109dfmr20361199lfv.641.1658301320255;
        Wed, 20 Jul 2022 00:15:20 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vRijlKLwPBOi/360M74uIAuqhlJ71c7QISF2XxTXk+Cfl6sjVmbqE8qnZ9ij4MIW7iMxRbltcGTPXBzrrrx/A=
X-Received: by 2002:a05:6512:3c95:b0:48a:3d1:9df with SMTP id
 h21-20020a0565123c9500b0048a03d109dfmr20361186lfv.641.1658301320071; Wed, 20
 Jul 2022 00:15:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <20220719172652.0d072280@kernel.org> <20220720022901-mutt-send-email-mst@kernel.org>
 <CACGkMEvFdMRX-sb7hUpEq+6e04ubehefr8y5Gjnjz8R26f=qDA@mail.gmail.com> <20220720030343-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220720030343-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 20 Jul 2022 15:15:08 +0800
Message-ID: <CACGkMEuLSAFfh-vZ1XoerjNrbPWVmfF-L5DCGBPMnwzif7ENSA@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing support
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alvaro Karsz <alvaro.karsz@solid-run.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 3:05 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jul 20, 2022 at 03:02:04PM +0800, Jason Wang wrote:
> > On Wed, Jul 20, 2022 at 2:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Jul 19, 2022 at 05:26:52PM -0700, Jakub Kicinski wrote:
> > > > On Mon, 18 Jul 2022 12:11:02 +0300 Alvaro Karsz wrote:
> > > > > New VirtIO network feature: VIRTIO_NET_F_NOTF_COAL.
> > > > >
> > > > > Control a Virtio network device notifications coalescing parameters
> > > > > using the control virtqueue.
> > > > >
> > > > > A device that supports this fetature can receive
> > > > > VIRTIO_NET_CTRL_NOTF_COAL control commands.
> > > > >
> > > > > - VIRTIO_NET_CTRL_NOTF_COAL_TX_SET:
> > > > >   Ask the network device to change the following parameters:
> > > > >   - tx_usecs: Maximum number of usecs to delay a TX notification.
> > > > >   - tx_max_packets: Maximum number of packets to send before a
> > > > >     TX notification.
> > > > >
> > > > > - VIRTIO_NET_CTRL_NOTF_COAL_RX_SET:
> > > > >   Ask the network device to change the following parameters:
> > > > >   - rx_usecs: Maximum number of usecs to delay a RX notification.
> > > > >   - rx_max_packets: Maximum number of packets to receive before a
> > > > >     RX notification.
> > > > >
> > > > > VirtIO spec. patch:
> > > > > https://lists.oasis-open.org/archives/virtio-comment/202206/msg00100.html
> > > > >
> > > > > Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> > > >
> > > > Waiting a bit longer for Michael's ack, so in case other netdev
> > > > maintainer takes this:
> > > >
> > > > Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> > >
> > > Yea was going to ack this but looking at the UAPI again we have a
> > > problem because we abused tax max frames values 0 and 1 to control napi
> > > in the past. technically does not affect legacy cards but userspace
> > > can't easily tell the difference, can it?
> >
> > The "abuse" only works for iproute2.
>
> That's kernel/userspace API. That's what this patch affects, right?

I'm not sure I get this.

The 1-to-enable-napi is only used between iproute2 and kernel via
ETHTOOL_A_COALESCE_TX_MAX_FRAMES not the uAPI introduced here.

So I don't see how it can conflict with the virito uAPI extension here.

Thanks

>
> > For uAPI we know it should follow
> > the spec? (anyhow NAPI is something out of the spec)
> >
> > Thanks
>
> When you say uAPI here you mean the virtio header. I am not
> worried about that just yet (maybe I should be).
>
> > >
> > > --
> > > MST
> > >
>

