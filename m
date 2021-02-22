Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C42432112D
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 08:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhBVHJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 02:09:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230057AbhBVHJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 02:09:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613977671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SfjcSkeuCzE9/+CoYCFIFTm1Ke7Qr71yxOHQpPA/W1c=;
        b=MmLC1XCeQFJyCYx5S/0CMYJYnn4w4Jr2EWn7ig1tSiIb5fHd3oPpLVd10SNyjzdmDMQpDG
        N4tIGitGpQB7axz75TnckNYqxhLhJlMblcJcq8ptll8gh6Pb6AYSnqWiT8Bg/obCiQJIJF
        6IkdzC+Qq0h8PEN23LFWCvMb9CKBP34=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-UO7QqnbFPxqlaoLTKZXXdQ-1; Mon, 22 Feb 2021 02:07:49 -0500
X-MC-Unique: UO7QqnbFPxqlaoLTKZXXdQ-1
Received: by mail-pf1-f198.google.com with SMTP id o2so6646888pfd.1
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 23:07:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SfjcSkeuCzE9/+CoYCFIFTm1Ke7Qr71yxOHQpPA/W1c=;
        b=LhV+Xr9Akz8QK6iyF+1tZy6eP6bG3l9O4XFoEtmDXKOWzxmrMNjzbXIhUVavYZTLpy
         9d5cP75c/0g2LnCU4d7D6s4GRNFEQih7F35fpaZJBCWax4JoXGcAQxcSAdnxVoW+lEaw
         aiyNDa8QyUAkYoSHJMncUk/Fe0/9FcTmk8PpSpZQqG/w6l2bI1iE0LFKO7KMDlK7HwnX
         5AArNUQn5+cgWjYnS4qPlST8i5EaRoIv8ka3ITYk0nd4uSJFeHtyIc2jfKuX/C8wZfeQ
         UyVnyBsUIcmLVYEyuts4a+utoHjIBXPvLFrgy9BX7ppv80fpPI0zAqeK2VWILQZf5oel
         e88w==
X-Gm-Message-State: AOAM531twuJ0cXiFS86R5zqQ6utvZSKpUTwIYjhFe9OXcAFyPWsj4wpp
        5oWb4xEIiCHD9sYUllKpU23Osyf9a94bw/RADuJbAJqDwzYQOgDP/nvsm9xU45WBEsx7ZZiuxaJ
        dWnyBFV2lj4eVLco07qD6LXUyjQ5xAGxn3LM7s6wRNHe3SPlgrtnulUuNgIoqbJU=
X-Received: by 2002:a63:90c9:: with SMTP id a192mr19124722pge.8.1613977668304;
        Sun, 21 Feb 2021 23:07:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwP+/I77AvpPaCYZWkNUEmz3EntQVTfgkKGYRyDaFQPkLb+Affv8SxoduV3LDfkj7rLRdqY7Q==
X-Received: by 2002:a63:90c9:: with SMTP id a192mr19124701pge.8.1613977668054;
        Sun, 21 Feb 2021 23:07:48 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a24sm18029132pff.18.2021.02.21.23.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 23:07:47 -0800 (PST)
From:   Coiby Xu <coxu@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kexec@lists.infradead.org, intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH 3/4] i40e: use minimal admin queue for kdump
Date:   Mon, 22 Feb 2021 15:07:00 +0800
Message-Id: <20210222070701.16416-4-coxu@redhat.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222070701.16416-1-coxu@redhat.com>
References: <20210222070701.16416-1-coxu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The minimum size of admin send/receive queue is 1 and 2 respectively.
The admin send queue can't be set to 1 because in that case, the
firmware would fail to init.

Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      | 2 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c | 9 +++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 118473dfdcbd..e106c33ff958 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -66,6 +66,8 @@
 #define I40E_FDIR_RING_COUNT		32
 #define I40E_MAX_AQ_BUF_SIZE		4096
 #define I40E_AQ_LEN			256
+#define I40E_MIN_ARQ_LEN		1
+#define I40E_MIN_ASQ_LEN		2
 #define I40E_AQ_WORK_LIMIT		66 /* max number of VFs + a little */
 #define I40E_MAX_USER_PRIORITY		8
 #define I40E_DEFAULT_TRAFFIC_CLASS	BIT(0)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5307f1744766..2fd8db80b585 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14847,8 +14847,13 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	i40e_check_recovery_mode(pf);
 
-	hw->aq.num_arq_entries = I40E_AQ_LEN;
-	hw->aq.num_asq_entries = I40E_AQ_LEN;
+	if (is_kdump_kernel()) {
+		hw->aq.num_arq_entries = I40E_MIN_ARQ_LEN;
+		hw->aq.num_asq_entries = I40E_MIN_ASQ_LEN;
+	} else {
+		hw->aq.num_arq_entries = I40E_AQ_LEN;
+		hw->aq.num_asq_entries = I40E_AQ_LEN;
+	}
 	hw->aq.arq_buf_size = I40E_MAX_AQ_BUF_SIZE;
 	hw->aq.asq_buf_size = I40E_MAX_AQ_BUF_SIZE;
 	pf->adminq_work_limit = I40E_AQ_WORK_LIMIT;
-- 
2.30.0

