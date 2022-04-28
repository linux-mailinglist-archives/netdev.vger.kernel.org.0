Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB361513765
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348585AbiD1Oyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiD1Oys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:54:48 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7485C746;
        Thu, 28 Apr 2022 07:51:33 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id i27so10056501ejd.9;
        Thu, 28 Apr 2022 07:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RIN8gOawCXDxnuKuymLvtjAI0BjsxNFPgbemmO0+RTI=;
        b=k9qd4rs+kos4p9fuFrcrhEaTVurYbQu5JAB5TlvpM1zhEvKT+R76kG9wVl/juFq0Wp
         vPSw7lsWKQ82Gv71hZte+YG+/2NSk9LIqPmLLSUlVrcfWH/8tFSC5k4s/yFeIDCVknbC
         vnvZFmxHdNKCL9GoyPA3RLovjT5SQAXbXbJpfOgcPRkQZR1KYa0aWlV/2inf89s2PDuX
         7ZQDQxZuKSQ/KktfUMAfrrLbpai6I1p9t02jwzIElprS1pYAPW2thVQPdZWuUYtoNq4X
         R+c967GpLQXEEXrNZzuxgoeVwIW4cCm+cpYZWcAfD1bmfoNcesP8CJH2zATQlL86n6Rz
         8mbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RIN8gOawCXDxnuKuymLvtjAI0BjsxNFPgbemmO0+RTI=;
        b=7ngw+/wo1dMatLPSN+GNlPVepD6PVGEXNoa8XhNQO2G1yFZbVbJQgMTiZURWpEgAu1
         fW5PIXuFOA/2kpW2hg5mf2EgDlew+uD0OdhICAIXP710KolySjO9Y38W+4nQf5qFix2S
         yE+3xZUhf1JWllqYzH5ReyRzY3p2DtSysqiH+DkxcbZub64xuhlWGtPQT37eVs7+Zakm
         beveIKVNdCnVSumGQVXZDlXzegVae6vOm27J5/WVjBBItqKXbV7NtHuSX3vXQ+FIHSey
         8goimv8Ob3n4CWiW6FCCu7o21tge6fhH4RsgSvXo8gzydlSOpY2V9Nlv9eAYyyF0MghN
         enbg==
X-Gm-Message-State: AOAM532DHpbbo/zu+sV6XbWw5LC/sDxd8SiUQFfRFIfgiFweCl7iaFA0
        ehZWPZWPDSccHIlJ9wjYHSE=
X-Google-Smtp-Source: ABdhPJy5lViZ6CLcBoESqVW5JlYJbBvqY0hkae/NMV5Se8ItjCNa8wWSnHEG8wkXUKWqx1nZcI9atg==
X-Received: by 2002:a17:907:3e1e:b0:6ef:ebf8:4059 with SMTP id hp30-20020a1709073e1e00b006efebf84059mr32126466ejc.657.1651157492013;
        Thu, 28 Apr 2022 07:51:32 -0700 (PDT)
Received: from anparri.mshome.net (host-79-49-65-106.retail.telecomitalia.it. [79.49.65.106])
        by smtp.gmail.com with ESMTPSA id x18-20020a170906b09200b006e8baac3a09sm61616ejy.157.2022.04.28.07.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:51:31 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Subject: [PATCH hyperv-next v2 3/5] hv_sock: Add validation for untrusted Hyper-V values
Date:   Thu, 28 Apr 2022 16:51:05 +0200
Message-Id: <20220428145107.7878-4-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220428145107.7878-1-parri.andrea@gmail.com>
References: <20220428145107.7878-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For additional robustness in the face of Hyper-V errors or malicious
behavior, validate all values that originate from packets that Hyper-V
has sent to the guest in the host-to-guest ring buffer.  Ensure that
invalid values cannot cause data being copied out of the bounds of the
source buffer in hvs_stream_dequeue().

Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/hyperv.h           |  5 +++++
 net/vmw_vsock/hyperv_transport.c | 10 ++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 460a716f47486..a01c9fd0a3348 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1696,6 +1696,11 @@ static inline u32 hv_pkt_datalen(const struct vmpacket_descriptor *desc)
 	return (desc->len8 << 3) - (desc->offset8 << 3);
 }
 
+/* Get packet length associated with descriptor */
+static inline u32 hv_pkt_len(const struct vmpacket_descriptor *desc)
+{
+	return desc->len8 << 3;
+}
 
 struct vmpacket_descriptor *
 hv_pkt_iter_first_raw(struct vmbus_channel *channel);
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 8c37d07017fc4..fd98229e3db30 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -577,12 +577,18 @@ static bool hvs_dgram_allow(u32 cid, u32 port)
 static int hvs_update_recv_data(struct hvsock *hvs)
 {
 	struct hvs_recv_buf *recv_buf;
-	u32 payload_len;
+	u32 pkt_len, payload_len;
+
+	pkt_len = hv_pkt_len(hvs->recv_desc);
+
+	if (pkt_len < HVS_HEADER_LEN)
+		return -EIO;
 
 	recv_buf = (struct hvs_recv_buf *)(hvs->recv_desc + 1);
 	payload_len = recv_buf->hdr.data_size;
 
-	if (payload_len > HVS_MTU_SIZE)
+	if (payload_len > pkt_len - HVS_HEADER_LEN ||
+	    payload_len > HVS_MTU_SIZE)
 		return -EIO;
 
 	if (payload_len == 0)
-- 
2.25.1

