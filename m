Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95A658FDCD
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 15:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235201AbiHKNyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 09:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbiHKNye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 09:54:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC4BD7E314
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 06:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660226068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6inRrhICS2L+j8kFy9iUcAEGaJYSzOH4irG6UMt8jBk=;
        b=FL4kHDvV+InEfWeZYMe7W1SbYHbtJoolJPT0TmLcQppBxNVi1K0OWtBR+z+qZdyX1BEL92
        ltnINXfHf/jwKE7IvWKnfcuuOF0eTM1MKM95ENs/5vcYJe+VNU1gDB8e2JECVG95xuzvb5
        jUW7NlXMta2IoEdjBw2DNX+eOF2ys/Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-jpiI7v9WOoKMCts-OUNHog-1; Thu, 11 Aug 2022 09:54:22 -0400
X-MC-Unique: jpiI7v9WOoKMCts-OUNHog-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C99898032F6;
        Thu, 11 Aug 2022 13:54:19 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA43240D282E;
        Thu, 11 Aug 2022 13:54:13 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     ecree.xilinx@gmail.com, gautam.dawar@amd.com,
        Zhang Min <zhang.min9@zte.com.cn>, pabloc@xilinx.com,
        Piotr.Uminski@intel.com, Dan Carpenter <dan.carpenter@oracle.com>,
        tanuj.kamde@amd.com, Zhu Lingshan <lingshan.zhu@intel.com>,
        martinh@xilinx.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        lvivier@redhat.com, martinpo@xilinx.com, hanand@xilinx.com,
        Eli Cohen <elic@nvidia.com>, lulu@redhat.com,
        habetsm.xilinx@gmail.com, Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>, dinang@xilinx.com,
        Xie Yongji <xieyongji@bytedance.com>
Subject: [PATCH v8 3/3] vhost: Remove invalid parameter of VHOST_VDPA_SUSPEND ioctl
Date:   Thu, 11 Aug 2022 15:53:53 +0200
Message-Id: <20220811135353.2549658-4-eperezma@redhat.com>
In-Reply-To: <20220811135353.2549658-1-eperezma@redhat.com>
References: <20220811135353.2549658-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was a leftover from previous versions.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
Note that I'm not sure this removal is valid. The ioctl is not in master
branch by the send date of this patch, but there are commits on vhost
branch that do have it.
---
 include/uapi/linux/vhost.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 89fcb2afe472..768ec46a88bf 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -178,6 +178,6 @@
  * the possible device specific states) that is required for restoring in the
  * future. The device must not change its configuration after that point.
  */
-#define VHOST_VDPA_SUSPEND		_IOW(VHOST_VIRTIO, 0x7D, int)
+#define VHOST_VDPA_SUSPEND		_IO(VHOST_VIRTIO, 0x7D)
 
 #endif
-- 
2.31.1

