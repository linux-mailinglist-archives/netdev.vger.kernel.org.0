Return-Path: <netdev+bounces-6640-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B3907172A5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:37:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 256C8281446
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B25AB110C;
	Wed, 31 May 2023 00:35:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FF31390
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:35:58 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7376F135
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:35:33 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64d3e5e5980so5958682b3a.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685493314; x=1688085314;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=23xeKFVPUFVZGWBGcJOCGL5XHLy6P13RAX8/V5+vCsQ=;
        b=Zzi32WniBs2qsNeUcZpuHj0aOjghw34hMXI5mJNDxSCxlmScNB1KaOhHw7iIfDXPo1
         V+jdLZdCOzmJooq6ReyEDuonbANQua+JQIP1YJFlqoP/IHorvyr0YYOmGECTz+XEU8W8
         EydPfFdpfxo3g/a7Wxf7xDZ9RWRkyg/K5RKZo4V7QaQby6Waw3flS1exibwyhrX+ksir
         hWZ9uAXvX2LXvo69boWk2o4ueD1iGQMhmiX78hfG1iqKuix9f1sdkWs1vDPLIUCKwnGh
         bTs0aZMZ+YDXt2swYoP3zYIG2IbZ+YtekjrreHr36dU+IgCCSMbYSVQQKKEUMwy5FaLA
         lgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685493314; x=1688085314;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=23xeKFVPUFVZGWBGcJOCGL5XHLy6P13RAX8/V5+vCsQ=;
        b=DkQqAj+0dXDq18CTTeFL9VXHFKyIdviL7ykLGxrWn5vZkjyAkOEncA9jZLY7gHWM7Z
         nxyikA0NBLwD9EhEUGlxSisCbYgJNfBUI4tArCNrdItV4GLYL7//yipiGPgT+eQoQp+a
         dnB2yYPptkBdKi1rDso3b3yPTloAVcShDd5u0AseXmLFJjkcnWLbCsxe0tsKaPz/19V/
         3x5dM9i5bJoirR3H9+/tHr+9MMrsy/84Gz4dWMUqe8laG3WHaAGbCpRIq8MJd7AX+1WY
         cJTj8/rJS1i+c7AI0dLCisByJsHrt9wqKH2sAZhgG/y4w/+kRYvh/eAz2zkD0yErXKG1
         RnrA==
X-Gm-Message-State: AC+VfDxn1FnPt33Aqd5VSauC/dguihqi5MLwYvAkSkEu53EyooPPaTW/
	sQhr61dl/7BznXMzUZ21nuibJQ==
X-Google-Smtp-Source: ACHHUZ6FcM3ztXr+/sYU8OWmAw8FbDZaKJuUZBXSFWUbBlS4izbiuRG7Pr592dIDgc8xqRBmJvB8qw==
X-Received: by 2002:a05:6a20:1583:b0:10d:b160:3d5f with SMTP id h3-20020a056a20158300b0010db1603d5fmr5045134pzj.38.1685493314237;
        Tue, 30 May 2023 17:35:14 -0700 (PDT)
Received: from [172.17.0.2] (c-67-170-131-147.hsd1.wa.comcast.net. [67.170.131.147])
        by smtp.gmail.com with ESMTPSA id j12-20020a62b60c000000b0064cb0845c77sm2151340pff.122.2023.05.30.17.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 17:35:13 -0700 (PDT)
From: Bobby Eshleman <bobby.eshleman@bytedance.com>
Date: Wed, 31 May 2023 00:35:09 +0000
Subject: [PATCH RFC net-next v3 5/8] virtio/vsock: add VIRTIO_VSOCK_F_DGRAM
 feature bit
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v3-5-c2414413ef6a@bytedance.com>
References: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryantan@vmware.com>, 
 Vishnu Dasa <vdasa@vmware.com>, 
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, Bobby Eshleman <bobby.eshleman@bytedance.com>, 
 Jiang Wang <jiang.wang@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This commit adds a feature bit for virtio vsock to support datagrams.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 include/uapi/linux/virtio_vsock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 64738838bee5..772487c66f9d 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -40,6 +40,7 @@
 
 /* The feature bitmap for virtio vsock */
 #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
+#define VIRTIO_VSOCK_F_DGRAM		3	/* Host support dgram vsock */
 
 struct virtio_vsock_config {
 	__le64 guest_cid;

-- 
2.30.2


