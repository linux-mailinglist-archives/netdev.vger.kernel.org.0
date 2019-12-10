Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24DEE11893B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfLJNJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:09:26 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37200 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727306AbfLJNJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 08:09:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575983364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NNvyL4Y9eRzqtb2H2E84LxRf2YADQJydGhMMLpn/rvY=;
        b=YCyQxxBCwG9YnKU8c4d3uWtS/1dc5JI9f0XVSok+6Yu1dNVHJfYbgvWIsZ6eJ/t7utYxX7
        bvxM5Tozv4+KIs/cXrwyQCgvvEi5asck2B/yQWtUTQHMP5C1wicuTqowJ+NKZDnlFpR2lJ
        xCK8dCCHIBvy4zGnWEkSURe3qHBKBjo=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-564kIVYIONOx6vP92p5nGw-1; Tue, 10 Dec 2019 08:09:23 -0500
Received: by mail-qv1-f72.google.com with SMTP id q17so6731267qvo.23
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 05:09:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wQxMVxgAtK5y0CyKs1BCEj6d5vwE3qN67Xvd5FZmfgk=;
        b=anFVQkNYYvmuOW8haWjF2lbGHMuw4xXKtAJXS+7CPT9sO5CuUQX6zuAduFeKt/9xfd
         +HfpiQecYpfC1kqmpOE/Nd4HnBzowLAD4hEO0AohA4ICdgGSA42Bf0HfWbyMufveVcF1
         w6/tvHIjb2+qm/44ikEgxZfRob6X7+kZj0LvAoRO9xS1okinqNl7H85hCHolyw1k8NmS
         4/W5LDd4r6aMXDO/tgjSW4AJpvA3ToQanqcKk2VVn7Rjv3NL6k0T58Imwt2Q6aYVNS7z
         dSQpbzaJWfBNxclu7YbjI8OHzc6lF5e1XpoE7fM4dwMfN7J3EXYCRbqKVFvrhPtGqY1B
         UCjw==
X-Gm-Message-State: APjAAAUz8oteNuT7rz+zOqJezAIW1hzYQGrdXk755jTT6lmMfG8sUK3e
        yFyoVLjUOleHHb8lrOLPXc5URNwEze1e2PkUtGq13LFk9HRsEwYG3pOrygt1SkMfOnCiuwlnvvd
        LZbv9M6xCdFnven2f
X-Received: by 2002:a05:620a:911:: with SMTP id v17mr12704479qkv.251.1575983363391;
        Tue, 10 Dec 2019 05:09:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqz7ER+Suti7b7WGSHiGKo0njA6UpaXbA4+jGOZ4LZZhkiLlbT0G0TM3FUm0G1znF25VZZnGAw==
X-Received: by 2002:a05:620a:911:: with SMTP id v17mr12704462qkv.251.1575983363208;
        Tue, 10 Dec 2019 05:09:23 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id x32sm1074057qtx.84.2019.12.10.05.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 05:09:22 -0800 (PST)
Date:   Tue, 10 Dec 2019 08:09:17 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org, Julio Faracco <jcfaracco@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        dnmendes76@gmail.com, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next v11 3/3] netronome: use the new txqueue timeout
 argument
Message-ID: <20191210130837.47913-4-mst@redhat.com>
References: <20191210130837.47913-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191210130837.47913-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
X-MC-Unique: 564kIVYIONOx6vP92p5nGw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/=
net/ethernet/netronome/nfp/nfp_net_common.c
index bd305fc6ed5a..d4eeb3b3cf35 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1324,14 +1324,8 @@ nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct =
nfp_net_tx_ring *tx_ring)
 static void nfp_net_tx_timeout(struct net_device *netdev, unsigned int txq=
ueue)
 {
 =09struct nfp_net *nn =3D netdev_priv(netdev);
-=09int i;
=20
-=09for (i =3D 0; i < nn->dp.netdev->real_num_tx_queues; i++) {
-=09=09if (!netif_tx_queue_stopped(netdev_get_tx_queue(netdev, i)))
-=09=09=09continue;
-=09=09nn_warn(nn, "TX timeout on ring: %d\n", i);
-=09}
-=09nn_warn(nn, "TX watchdog timeout\n");
+=09nn_warn(nn, "TX watchdog timeout on ring: %u\n", txqueue);
 }
=20
 /* Receive processing
--=20
MST

