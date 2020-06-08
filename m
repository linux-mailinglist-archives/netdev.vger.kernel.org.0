Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D061F18F1
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 14:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgFHMn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 08:43:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47465 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728802AbgFHMnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 08:43:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=utvLOGjABWchDzVBBNcvjGgT0Uw4uVA8BCJYHrkDTYE=;
        b=TyCgMLODxX0a9jzlp75v5jJdlB/ziQNUZGG1WFR4A1VSJIXaKZL0jHDPKPxvBk36zGfPGV
        Wm68hG1vlF+FKx1KiRVln78MzBLMBXw9e1DoWFHgU0c44YVcA0QoVqCJ97sc0Dxg4+L062
        DBCepTeUpfOWILkpU7co5aKxYyNROn8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-fadBivTJNfa_ScRuU80DaQ-1; Mon, 08 Jun 2020 08:42:59 -0400
X-MC-Unique: fadBivTJNfa_ScRuU80DaQ-1
Received: by mail-wm1-f69.google.com with SMTP id h25so5343327wmb.0
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 05:42:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=utvLOGjABWchDzVBBNcvjGgT0Uw4uVA8BCJYHrkDTYE=;
        b=NMModq/wBDkPQQI82jZFcuPGcdemWVfPcIsEUpq6F+aHrS39nnJ9j12q3qnQPwuaxH
         svBIeU+kfX2NWJ1rpW+UQXTBNNcJTDBUp0IHGm5Plk6ZXvNqDHdBSXaNAF4Fq9lTHyBh
         PkmQYmXptaMJYehoffE2F8Nbyl+jYmfAvIBCcYZjIz0Mfcyz276wGDoVaWr/+OGSIL0h
         tQw1Zcl69efFhD53ZvPJCxfikkpTxCPavqZ0oogSZw0MzK5ijz/iaBz78TNKTI9i1+vc
         K0u/x47YmlnhfkZ7ZwXPp+PQqqnIToodtUDyrh/K+PbmlVq6tzjZenug9mqwKxG2lRc9
         TK1w==
X-Gm-Message-State: AOAM533ptIQTUaM9y7QIn7GE1vOzlskm9QIm7fDd90H9d10B/QMGtHCi
        TBIkUgqhNIzLtnbfH7xVV3BOmL9gPul908qvC7hKseYsgg2Q3Cyo9kCu0C9Pgzuxws/InFVLhYS
        grRjRw1mQPb7y0dFI
X-Received: by 2002:a1c:5411:: with SMTP id i17mr17027062wmb.137.1591620178258;
        Mon, 08 Jun 2020 05:42:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxHCDKaiMql4q+MgfnmT9afh3wFAhLtf//8SgAbDqi4VLnsVn3wc/xBGn3Rmk2vnzUyPWpJw==
X-Received: by 2002:a1c:5411:: with SMTP id i17mr17027042wmb.137.1591620178029;
        Mon, 08 Jun 2020 05:42:58 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id g82sm22458959wmf.1.2020.06.08.05.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:42:57 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:42:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] vhost/test: fix up after API change
Message-ID: <20200608124254.727184-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass a flag to request kernel thread use.

Fixes: 01fcb1cbc88e ("vhost: allow device that does not depend on vhost worker")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index f55cb584b84a..12304eb8da15 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -122,7 +122,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
 	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
-		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, NULL);
+		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL);
 
 	f->private_data = n;
 
-- 
MST

