Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD774E4E92
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 09:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242931AbiCWIvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 04:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242910AbiCWIvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 04:51:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 526967307A
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 01:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648025406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VkoZGCDazaob935cf0K6/xqwp1grV8y7vA1EUagsdw8=;
        b=L1Q3EyaW4rN+iIkTSQe2yw4phBv647L98QRD/0NuZkNbIPIx/I0VMOzh/7xRcR3VjFoS1p
        bgRS2JKNji0fkyOAYinn3drq9BSYNxZmTYOj/HZlmBsMbYL28eHtosYptymNL0u3S5X3Cz
        wuFI1zDxHPXIwLAm3M9ky1T4bqD3o1E=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-S4GtyW2NO2SStLoSsWwq1Q-1; Wed, 23 Mar 2022 04:50:05 -0400
X-MC-Unique: S4GtyW2NO2SStLoSsWwq1Q-1
Received: by mail-qt1-f200.google.com with SMTP id e5-20020ac85985000000b002e217abd72fso681812qte.9
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 01:50:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VkoZGCDazaob935cf0K6/xqwp1grV8y7vA1EUagsdw8=;
        b=pIo54FG1ncw/Qg+QRPbPpx2kC3kQjLtOJ2D077Pmub/izPVMrDiVm24STWwf3On/v9
         riLcEjot3t3v+GvIM4oWOe+hCJKQKNw33Ygh05VHWffuiBTDZ7SLI4rNW06j+cBIMdMO
         TWFdXWuWv+LgX6N/XH96vHqmta1jQxt1/VaSrKcEQsAdRu3oG/lwXEjY14Pxk0wsx1HZ
         wYA279TQ2WAFYPd72G5b3hocixQFlXElD1mm1NC2nn3KJWix56E1kFeh/XqIiMzFIRlt
         JqVOIjC/S+DFEuSw9WwHbei4TdAvYdgN1sIQAVht2VLgQVWMq7PzTpu4LYemuEVfeM9A
         2jpw==
X-Gm-Message-State: AOAM5314bCePa5of7mTRpa8XbxIP4PpNtDmH7XJTdiKrdqOabBQLAt+Z
        lEkqNMBVRi9KZg1UlfoPKRG2zZDgSxA9uymJLl+sQe1G3dwvt84IjZHU/7Hd9NcDDi+wOn0nIKP
        WzyY1HZ/BAREvFPNwnsHiPDiLTFBFqZNRefSigTqS3U/HEU9xPVeuHmGPyHUM42FPUVI+
X-Received: by 2002:a05:620a:1a92:b0:67d:b2c2:8311 with SMTP id bl18-20020a05620a1a9200b0067db2c28311mr17908337qkb.594.1648025404245;
        Wed, 23 Mar 2022 01:50:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylURIbsHFC5CVM0PxCcg9Ie4RCz+seln0B3QhsU0NKbzEwgOSb1+E5im+z84ivzzgUFUDiHg==
X-Received: by 2002:a05:620a:1a92:b0:67d:b2c2:8311 with SMTP id bl18-20020a05620a1a9200b0067db2c28311mr17908319qkb.594.1648025404003;
        Wed, 23 Mar 2022 01:50:04 -0700 (PDT)
Received: from step1.redhat.com (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id j188-20020a3755c5000000b0067d1c76a09fsm10640609qkb.74.2022.03.23.01.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 01:50:03 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 1/3] vsock/virtio: enable VQs early on probe
Date:   Wed, 23 Mar 2022 09:49:52 +0100
Message-Id: <20220323084954.11769-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323084954.11769-1-sgarzare@redhat.com>
References: <20220323084954.11769-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio spec requires drivers to set DRIVER_OK before using VQs.
This is set automatically after probe returns, but virtio-vsock
driver uses VQs in the probe function to fill rx and event VQs
with new buffers.

Let's fix this, calling virtio_device_ready() before using VQs
in the probe function.

Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 5afc194a58bb..b1962f8cd502 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -622,6 +622,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
 	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
 
+	virtio_device_ready(vdev);
+
 	mutex_lock(&vsock->tx_lock);
 	vsock->tx_run = true;
 	mutex_unlock(&vsock->tx_lock);
-- 
2.35.1

