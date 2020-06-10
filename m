Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701961F5392
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 13:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgFJLgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 07:36:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28029 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728540AbgFJLgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 07:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QQIo3L2MWWvjb6mzSKSfjdSEv1rN96HPXR5N45kiTKk=;
        b=FSODTOuDqaBnAiLb2DGtXbD1Nk0FkulVbexlNKTdqC0GKCHROtdOAOvVv2rR7SVJ93DmFO
        Tg6StNKmcIG8Qj4KJYaQ/7xOivuDn5rSpoSEh/bwTp1UvzZppc5cBN3GyKCJFPwZAiDMj4
        4qEH150p5U6QsygLYYrOqLP9H99Akho=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-vm5XyyJfOCqy4iYZWJ7ZAw-1; Wed, 10 Jun 2020 07:36:03 -0400
X-MC-Unique: vm5XyyJfOCqy4iYZWJ7ZAw-1
Received: by mail-wm1-f71.google.com with SMTP id c4so402140wmd.0
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 04:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QQIo3L2MWWvjb6mzSKSfjdSEv1rN96HPXR5N45kiTKk=;
        b=uEH26H+2N/lwVa4rDbXeh59gvVKoPK5wSzQUYzQQDlTqzI58ufJM6yPUFsALuICNzh
         TYZ4iv5lZ9x8NsERSqvfBRWpHSjsM/SbPVXR9MJh1qDuA1qTcwNEUpIE09mNBqaaU7Jr
         KcpW5xha4Vn8NnMPQosAFhqIxrayRF0NtAqHyXI9DHnpyn7oDW5S/kXeMD1FS8mSfZoW
         KJKLoYKePISgEj+8stmPZKUvAtnijEfoyWEzcuixr9b3wWacOLATsiIn79IbluRCOtdD
         mgHt6vYNqg65TwOF7ppUPgknz9Ff5gM3UVkfl7qr3sjeBiKwdhHjV1phKEsM1NWMNfd0
         eMRA==
X-Gm-Message-State: AOAM533psHzjO5oswNE97C6vIO6n+gVVuXr8P0tdjnH4ZnIjJMVkQQxG
        ioAov1ZN3KM267KuU4OeLmKwqE4+QYwW5zD2OkINlpkX7ogAYxg7DS8HXbEBn3peOHXuzKPbsbt
        nl6gXF62a8Sp/P5Sj
X-Received: by 2002:adf:a157:: with SMTP id r23mr3378908wrr.92.1591788962282;
        Wed, 10 Jun 2020 04:36:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAHBbn1Hm38GkVQUdC9QO7S3prwhr5Px+sKP6OuFbtKtCWmiw5G13O+k9LGPpnGaeJbpRtfQ==
X-Received: by 2002:adf:a157:: with SMTP id r23mr3378893wrr.92.1591788962077;
        Wed, 10 Jun 2020 04:36:02 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id c206sm7360362wmf.36.2020.06.10.04.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:36:01 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:35:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v7 02/14] fixup! vhost: option to fetch descriptors
 through an independent struct
Message-ID: <20200610113515.1497099-3-mst@redhat.com>
References: <20200610113515.1497099-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610113515.1497099-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 180b7b58c76b..11433d709651 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2614,7 +2614,7 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
 err_fetch:
 	vq->ndescs = 0;
 
-	return ret;
+	return ret ? ret : vq->num;
 }
 EXPORT_SYMBOL_GPL(vhost_get_vq_desc_batch);
 
-- 
MST

