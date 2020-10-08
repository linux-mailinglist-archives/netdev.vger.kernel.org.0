Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B08E28756F
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 15:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgJHNu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 09:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgJHNuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 09:50:52 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AF1C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 06:50:51 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id u21so8237328eja.2
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 06:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3QgNMvIcxcJ+OZ/UVUVDVU8AjuIQyIXiYSQz3ZXOfyc=;
        b=gddnoLDi8gJB/XfGuRlkOPu0QkFuNCDvptr0DNnnN9zR6L/TQOIZry/T8nnfgDy1Np
         CPPJiRDXBi9ZAdrlRArFaKub0S5VN0RWlxn/RdX0QAxSxdFzqw7vhY+hmoZqlIIE2Zh0
         OL203A6slEAuhDRAPSruHZEdglCDzhnUOpi6hARpsEHcEbrdoRhJetT+wdMImMx4Osfj
         X+xamHmVKec9YfRUf5v6tfDJ7RJnH1SCajX5T1AQ3Lks24cH9fy50M8vwNnW+cgUpZJB
         fuFVCHojLANJVwCUhNU7ETHpvCI0eVlkEfS58jdiVUmS3oN9QEFWIeomoiJaz+JUgOH5
         NQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3QgNMvIcxcJ+OZ/UVUVDVU8AjuIQyIXiYSQz3ZXOfyc=;
        b=mAjKmODBhw/hpdhcwUbQo+rrgQ7bbtL8XHRylqWadrzjHcEZ3i2Kkt3A1y8MIcRmDV
         TXwVPW2JVS6Y/tC1eFhN/BFfOpHW05vP1LblXxqCAAZYIU7FVF4g0i0wAuT8X4aLzjp6
         WHVMnIec7XblvqfkUuVxwpVAvL+ilfo6Q3etoUU7fFmrzWuMYO/oPibJThxLlowqYn39
         mrHF4xtb/U634/dKqEIXX1+ufXWbwF9VA7EdHimFFPqhxGGz2UXNNSsh0R3itk1/Wcs5
         TuEdFTRxrDtFPbI/WulQlesLx341VwYDiqMmz2lzi2xnWvKcXeqE+2oXNMnREomSYI9X
         HaSg==
X-Gm-Message-State: AOAM5312kKZMlwdRGLFybWw7BOA7RV+VqWoBbZNYaDC/ij+QUdi5PMfQ
        DkS3Uz6Dq6gc7vWq/es3Szr9yNcmBSohLY3k
X-Google-Smtp-Source: ABdhPJyMjE2huWp77x8uInTy9yelVKnDVMIqvkFVZX4R7Yn0iBOVk78xW3OY3emUAxwocg6cSEqntw==
X-Received: by 2002:a17:906:1f08:: with SMTP id w8mr8662607ejj.181.1602165050062;
        Thu, 08 Oct 2020 06:50:50 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id w21sm4169617ejo.70.2020.10.08.06.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 06:50:49 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 4/6] bridge: mdb: print filter mode when available
Date:   Thu,  8 Oct 2020 16:50:22 +0300
Message-Id: <20201008135024.1515468-5-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201008135024.1515468-1-razor@blackwall.org>
References: <20201008135024.1515468-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Print the mdb entry's filter mode when it's available if the user
requested to show details (-d). It can be either include or exclude.
Currently it's kernel controlled and can't be changed by user-space.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/mdb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index d33bd5d5c7df..c0cb4fd1421e 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -150,6 +150,13 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 	print_string(PRINT_ANY, "state", " %s",
 			   (e->state & MDB_PERMANENT) ? "permanent" : "temp");
 
+	if (show_details && tb && tb[MDBA_MDB_EATTR_GROUP_MODE]) {
+		__u8 mode = rta_getattr_u8(tb[MDBA_MDB_EATTR_GROUP_MODE]);
+
+		print_string(PRINT_ANY, "filter_mode", " filter_mode %s",
+			     mode == MCAST_INCLUDE ? "include" : "exclude");
+	}
+
 	open_json_array(PRINT_JSON, "flags");
 	if (e->flags & MDB_FLAGS_OFFLOAD)
 		print_string(PRINT_ANY, NULL, " %s", "offload");
-- 
2.25.4

