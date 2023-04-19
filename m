Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7B96E7648
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 11:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjDSJbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 05:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjDSJbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 05:31:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00CCB74D
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 02:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681896630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=To/Z2aKUn05uCqDmpdizDe13Xy/Ne8IR1ELES9feEn8=;
        b=UCihjCCxjzl0G1LpgEkFU8VhDHQ0sfVv6Kb2lDeVRzubZ4REDN8IOIo+y1m2QjDKLMtd89
        H+CHJSnve/zmi5840aX4qhXfews7lhJq1D7dxPdHGyIQQSvtyBiGldce2v6LSKAl9QqQfG
        xNSXEV105Yz25OJaPkVeKiSMw8LAKgc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-Kr3vxpWGPYyLPXUMFgXNyQ-1; Wed, 19 Apr 2023 05:30:28 -0400
X-MC-Unique: Kr3vxpWGPYyLPXUMFgXNyQ-1
Received: by mail-qt1-f197.google.com with SMTP id 19-20020ac84e93000000b003e3c23d562aso22373419qtp.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 02:30:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681896628; x=1684488628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=To/Z2aKUn05uCqDmpdizDe13Xy/Ne8IR1ELES9feEn8=;
        b=j7gc4bg7cPxAc39CC2LmnhPa2aVUh7CrUFnjQrFx/qhdqQNID9a9N9b4LC3D3qTj/q
         fnaPi8jqf7IQpFuEYyWKKy2QDb6rOzhoFywMqvIkSVcRAljxj+yCjbcnWNPb8j6fPfFE
         3PGDlzuLcWk/OIse7imvFPMn0fzhHZUz4SX7TL8R9/4J4muG5MFswNcdn10gg1TQww16
         lB8ekKDnrwYxPNHcuSKtudCDNxF25+msd7UZh4DKH3FzV0nY1apyQv8nUleh+GJV09Df
         BuVIyls3r/3NSAlLsEqjqkpTnUU5afc+ZkLHmfuiT5P8uHUkyr9tFHOtJKeUBuvTzqdV
         FoBw==
X-Gm-Message-State: AAQBX9dWkY1nNIHbBvl9V/9XrRLOf+Rnjsb0lzraL//W9Ilzht1WEJ2s
        4GAPxptYr7Ca5i+opuSaIqAK4A+aD+jPtly7pfSFjB/bXjG22OSk1x8k3J2IKECP2MkBKtN1eT2
        nfTmz1a7WlJ839cJp
X-Received: by 2002:ac8:5856:0:b0:3e3:8ebe:ce2d with SMTP id h22-20020ac85856000000b003e38ebece2dmr4663791qth.68.1681896628013;
        Wed, 19 Apr 2023 02:30:28 -0700 (PDT)
X-Google-Smtp-Source: AKy350arWkVKYAcdMdvj77voljoNXo58Xfzci6Fuv0r9IbfMnWkq1bBapWpJIOmEljT7ApJVePXaIw==
X-Received: by 2002:ac8:5856:0:b0:3e3:8ebe:ce2d with SMTP id h22-20020ac85856000000b003e38ebece2dmr4663749qth.68.1681896627694;
        Wed, 19 Apr 2023 02:30:27 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-157.retail.telecomitalia.it. [82.53.134.157])
        by smtp.gmail.com with ESMTPSA id z17-20020ac87cb1000000b003e64ea3faf7sm2631599qtv.59.2023.04.19.02.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:30:27 -0700 (PDT)
Date:   Wed, 19 Apr 2023 11:30:21 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, Jiang Wang <jiang.wang@bytedance.com>
Subject: Re: [PATCH RFC net-next v2 2/4] virtio/vsock: add
 VIRTIO_VSOCK_F_DGRAM feature bit
Message-ID: <nbuuohh72i4n27rzlg7sj7bwsrsrnnxxcxj6w5yotw5bhpcznt@ormwl5d6jiuw>
References: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
 <20230413-b4-vsock-dgram-v2-2-079cc7cee62e@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v2-2-079cc7cee62e@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 12:25:58AM +0000, Bobby Eshleman wrote:
>This commit adds a feature bit for virtio vsock to support datagrams.
>This commit should not be applied without first applying the commit
>that implements datagrams for virtio.
>
>Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> drivers/vhost/vsock.c             | 3 ++-
> include/uapi/linux/virtio_vsock.h | 1 +
> net/vmw_vsock/virtio_transport.c  | 8 ++++++--
> 3 files changed, 9 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index dff6ee1c479b..028cf079225e 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -32,7 +32,8 @@
> enum {
> 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
> 			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>-			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
>+			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
>+			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
> };
>
> enum {
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 331be28b1d30..0975b9c88292 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -40,6 +40,7 @@
>
> /* The feature bitmap for virtio vsock */
> #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
>+#define VIRTIO_VSOCK_F_DGRAM		2	/* Host support dgram vsock */
>
> struct virtio_vsock_config {
> 	__le64 guest_cid;
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 582c6c0f788f..bb43eea9a6f9 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -29,6 +29,7 @@ static struct virtio_transport virtio_transport; /* forward declaration */
> struct virtio_vsock {
> 	struct virtio_device *vdev;
> 	struct virtqueue *vqs[VSOCK_VQ_MAX];
>+	bool has_dgram;
>
> 	/* Virtqueue processing is deferred to a workqueue */
> 	struct work_struct tx_work;
>@@ -640,7 +641,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	}
>
> 	vsock->vdev = vdev;
>-
> 	vsock->rx_buf_nr = 0;
> 	vsock->rx_buf_max_nr = 0;
> 	atomic_set(&vsock->queued_replies, 0);
>@@ -657,6 +657,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
> 		vsock->seqpacket_allow = true;
>
>+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
>+		vsock->has_dgram = true;

This is unused for now, but I think the idea is to use in
virtio_transport_dgram_allow(), right?

I would follow `seqpacket_allow` in this case.

Thanks,
Stefano

>+
> 	vdev->priv = vsock;
>
> 	ret = virtio_vsock_vqs_init(vsock);
>@@ -749,7 +752,8 @@ static struct virtio_device_id id_table[] = {
> };
>
> static unsigned int features[] = {
>-	VIRTIO_VSOCK_F_SEQPACKET
>+	VIRTIO_VSOCK_F_SEQPACKET,
>+	VIRTIO_VSOCK_F_DGRAM
> };
>
> static struct virtio_driver virtio_vsock_driver = {
>
>-- 
>2.30.2
>

