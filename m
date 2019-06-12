Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B55844796
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbfFMRAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:00:41 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41154 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbfFLX7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 19:59:19 -0400
Received: by mail-qt1-f195.google.com with SMTP id 33so12374430qtr.8
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 16:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FBa5WZfKsjgDHVhLTbWPeIkU99UvgwFDdzHkaq8AbHM=;
        b=FQ7zluZGhAlCc4HQMKhrUv83qaUFSuJkZn/jeqr2ZmwgDLA0nAbFoIWLOKynpKYKAG
         dy0kxQVLvMc4hcF7c8ewiYanW5/2R+TxC/b7BEtOHClVxfixtk39lIbU3T3YWmbTdAYf
         QN6ot34Nf/Qy3tJ84wfz0bJkcBGawDUn+mVajDarJeh5767lIXwsNsPZFfurGlv/TWlO
         enynF1RVyRVpcPF7NVQajA2B/+eg8QCeXnIZmejGX+5EfnUee8rt1AjWg9pq9P1z49h+
         OFpSVMQTGIz/pigTj+aza5r1Z0HyBkpiIsVudjmsH7tm1kdHj4IcH9HRH0dus1ZfcxG/
         60aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FBa5WZfKsjgDHVhLTbWPeIkU99UvgwFDdzHkaq8AbHM=;
        b=oBDzmNip5xGY1R5E2u4lyObwQiAwNrwOqG3hQxHEpJGYF2T2TiKNMa9+kClaxBgDwX
         8JGewrN/C5SK3+CcsrgBN/i444H/8XeK4Da89Wxq7YEIfuOsg4M1NVEY3zoYNRT9Pz4x
         6vEzurikFjH9+GP/pvcaOjFtNvgB2T0eLXhaGmtyLBVXqjPeeNMPRgg/XOTgy15rSDfs
         Hdk6OPKkYzYwmiIrCq7VxxWDS4xTd13pOp64yGBjjFiD46vKsDreB9GDo5j1QwD7aET2
         HdxoQHTJC0MPV7AhBB3m2vJZxnC6ms5UkFzIBrY74z/73kS/qu/ffGMJska2O3Q60/8+
         B9Ow==
X-Gm-Message-State: APjAAAVLMI00OmTzQ10Bz4Rk/mdIEfnVauP8itptCX4lSUExwM3Ds/jV
        a4tymKmW5yhdg/6o7S2fKZaLmg==
X-Google-Smtp-Source: APXvYqweu0Kv25JKwWnXr1n/w5eWxYyANeCcbgyEDh488j8m++awLtYMwWrKgOQqoh4dxM1fyv+FBQ==
X-Received: by 2002:a0c:a8d1:: with SMTP id h17mr992254qvc.117.1560383958022;
        Wed, 12 Jun 2019 16:59:18 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p4sm490891qkb.84.2019.06.12.16.59.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 16:59:17 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 1/2] nfp: update the old flash error message
Date:   Wed, 12 Jun 2019 16:59:02 -0700
Message-Id: <20190612235903.8954-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612235903.8954-1-jakub.kicinski@netronome.com>
References: <20190612235903.8954-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apparently there are still cards in the wild with a very old
management FW.  Let's make the error message in that case
indicate more clearly that management firmware has to be
updated.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
index 42cf4fd875ea..9a08623c325d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
@@ -241,11 +241,16 @@ static int nfp_nsp_check(struct nfp_nsp *state)
 	state->ver.major = FIELD_GET(NSP_STATUS_MAJOR, reg);
 	state->ver.minor = FIELD_GET(NSP_STATUS_MINOR, reg);
 
-	if (state->ver.major != NSP_MAJOR || state->ver.minor < NSP_MINOR) {
+	if (state->ver.major != NSP_MAJOR) {
 		nfp_err(cpp, "Unsupported ABI %hu.%hu\n",
 			state->ver.major, state->ver.minor);
 		return -EINVAL;
 	}
+	if (state->ver.minor < NSP_MINOR) {
+		nfp_err(cpp, "ABI too old to support NIC operation (%u.%hu < %u.%u), please update the management FW on the flash\n",
+			NSP_MAJOR, state->ver.minor, NSP_MAJOR, NSP_MINOR);
+		return -EINVAL;
+	}
 
 	if (reg & NSP_STATUS_BUSY) {
 		nfp_err(cpp, "Service processor busy!\n");
-- 
2.21.0

