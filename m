Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06F8C62E5D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfGICx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:53:57 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39809 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbfGICx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:53:56 -0400
Received: by mail-qt1-f193.google.com with SMTP id l9so11935509qtu.6
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 19:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wl/o04w38MLbu44BN8LVP/WadQ5Viq57NR4FwS4YREA=;
        b=Sjl8GgjFrcsdSEi+Y1YFmKdgItiSnABdRMvlsDdvKf29hr/LHNbXZranXaSzyBuP5b
         BqtdmRYFUCmkV+kM1UqyEmt6DBRjNVSmipXdXpCJyrrILZqfBgeKdb2gMF21yJPjaBjY
         IIDJ2LDDKSe7nu/yBdNvd3AFMYCWtW+PZUK97Z59cTehhO4QFI82AtofnXsSyoc/rSkD
         Ns3mnjQmK2h12rcbZJTIwTX3XfKq3BAAnzVzWr81KS3IAEp0fxKgHC+H4ydS2z2l9RH2
         OV2oEQJuJ14nOhO+CScSgphPk6ND8xfoxibmtVk4MMPE1BSu90j+ZkRf18kiZaAw28Wi
         kPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wl/o04w38MLbu44BN8LVP/WadQ5Viq57NR4FwS4YREA=;
        b=ZmJbPIybD218AJQ0TUiCrJBjl6U6cIYQt82cXnPx+18CAZcuTsHyjwMQz3Wo5L0/Kn
         AlUr2wJlYmRFfLaOCZmNqkjvf8mTbXDVowl2QG982yjOD/OUfcEql1ljENnwZUxNBUFy
         3SsIN/lce0at4MjxdiD1ddmRmzl9EvNsXiKjxHN+4jeCOxsl3ZjiEMiJT1Dfxt/Jannt
         sTmPnpl9SCW9rHq7coLt/R4eOMhXB67X3R40rmnybH4KST7J6yStgf+CBrtfk/Jsy+Fx
         n5ZrIq6mcR1FKeFcBgk+bA+bwWefTTVbVSCkBUF7bEOkICp8eYZWPJdvSo8uArq44wei
         zXAQ==
X-Gm-Message-State: APjAAAV3ybCHF+2n84F+AoYi7qhz2EJfCiDPVBEawn31d2iJKhT3L1rD
        oOaGVDk7tDT5zqu1jFeHBq045A==
X-Google-Smtp-Source: APXvYqwZ4cGJoCVkJyuFD6VwJFbNIGe3xAnx43GBhL6MGA6QobcQ+FioF/uLqIveVAJ5jYXSOLMI5g==
X-Received: by 2002:ac8:26e3:: with SMTP id 32mr13668057qtp.79.1562640835388;
        Mon, 08 Jul 2019 19:53:55 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm8148837qkm.17.2019.07.08.19.53.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 19:53:54 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 08/11] net/tls: add missing prot info init
Date:   Mon,  8 Jul 2019 19:53:15 -0700
Message-Id: <20190709025318.5534-9-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709025318.5534-1-jakub.kicinski@netronome.com>
References: <20190709025318.5534-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Turns out TLS_TX in HW offload mode does not initialize tls_prot_info.
Since commit 9cd81988cce1 ("net/tls: use version from prot") we actually
use this field on the datapath.  Luckily we always compare it to TLS 1.3,
and assume 1.2 otherwise. So since zero is not equal to 1.3, everything
worked fine.

Fixes: 9cd81988cce1 ("net/tls: use version from prot")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 56135f3ff4ff..06c30f677f7a 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -878,6 +878,8 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 		goto free_offload_ctx;
 	}
 
+	prot->version = crypto_info->version;
+	prot->cipher_type = crypto_info->cipher_type;
 	prot->prepend_size = TLS_HEADER_SIZE + nonce_size;
 	prot->tag_size = tag_size;
 	prot->overhead_size = prot->prepend_size + prot->tag_size;
-- 
2.21.0

