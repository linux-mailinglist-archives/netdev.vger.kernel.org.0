Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6ACD1F5393
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 13:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgFJLho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 07:37:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35253 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728664AbgFJLgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 07:36:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nqpRKPPRu97i04+lEwiVZnVP4RAISD6OyeyY71/1iaw=;
        b=PD3DXviUIXZSvLoLAGuF692PzUijlWhppV55ZYxp5ZvJhdv/oOyKxnqycdlsIKlAl05Ro9
        vJXmZKpt9/tjiRcITzJF7kZ+lqnPFaDR6sRdKl9FT8WvPsPF/3XlmhxsbBVFUDAcD1u2C4
        Q8BCO1YTt5uaGYZRw8wu8KRy9OYKJWc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-yl4bQqP9Ne6_j_kQwJF1gg-1; Wed, 10 Jun 2020 07:36:20 -0400
X-MC-Unique: yl4bQqP9Ne6_j_kQwJF1gg-1
Received: by mail-wm1-f69.google.com with SMTP id b63so1811910wme.1
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 04:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nqpRKPPRu97i04+lEwiVZnVP4RAISD6OyeyY71/1iaw=;
        b=fV+jHG/iPmsVVhVAmmPYl3SrfVWbLUr+GL0f9HSYeLTuJliLmFWl9nJcrtulvlTf6V
         4+SiHGLzCz1hOGYlA5h2FGv+idlgDchr9sjyU8Ym4522xsGn3XvzA++F7dmuCYX9kBwr
         chA0emGQMa6WM9XmJTEhkNxbT+AJI1vKGGBhWEB2madOcY87tHzktImdY0p/KoYQLYWE
         LCpJZXzPtHooU1Uxl2dLA/v8/1sdfakYQYC7H+3HNwKGJ+17iSQ5oMPNNij4PlP7bj9M
         S/lXfBAyc4j3K3BXqbxdwFjXcaxAF8cUqCbig3vN4/Y+vBchtivCeB+b+EnOz7M9/gd+
         8FRw==
X-Gm-Message-State: AOAM5337IlJz2VdR9FJOP1ufZkywinnX5zxGIZaxAPf23+LpCarqQK3o
        IdYmrN4XPAdPc1aY+UM4W9428BZCka60Hn+gvq+NGTBnkJBdl4LGVS3Gj/wiAR6tJMPuJmSkoTx
        SS0WSqKI2sJOF4V+E
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr2749314wma.148.1591788979279;
        Wed, 10 Jun 2020 04:36:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk/lBSoKqQEzUm0ygb+JThKfl+fyQkS7QcmVzzuz7sF0aMX0Q8Jh3FrRflgePDOX+1hNCqVA==
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr2749304wma.148.1591788979097;
        Wed, 10 Jun 2020 04:36:19 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id d63sm6775894wmc.22.2020.06.10.04.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:36:18 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:36:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v7 08/14] fixup! vhost: use batched get_vq_desc version
Message-ID: <20200610113515.1497099-9-mst@redhat.com>
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
 drivers/vhost/vhost.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 7a587b13095c..03e6bca02288 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2205,10 +2205,6 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 	last_avail_idx = vq->last_avail_idx;
 
 	if (unlikely(vq->avail_idx == vq->last_avail_idx)) {
-		/* If we already have work to do, don't bother re-checking. */
-		if (likely(vq->ndescs))
-			return 1;
-
 		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
 			vq_err(vq, "Failed to access avail idx at %p\n",
 				&vq->avail->idx);
-- 
MST

