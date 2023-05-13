Return-Path: <netdev+bounces-2356-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEF5E701683
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 13:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 701A11C21073
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 11:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB0D3FE1;
	Sat, 13 May 2023 11:52:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5221846
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 11:52:09 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582AB26A4
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 04:52:08 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50db7f0a1b4so8755029a12.3
        for <netdev@vger.kernel.org>; Sat, 13 May 2023 04:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683978727; x=1686570727;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=tPaRCdR9znhCSBNCV7Zh/uxMhVYAfQIv0T/cvc7dHOA=;
        b=LJqiQfQMoppCQZsnl7OLFprYP0Kd1l+UkZSnATNGUlYSEx232Hls0lKeCqmD/UEvhf
         mcXpGlLVAaNqi2/+XMQlOVQibPEt7nEAcpCWFccnXg8O37i3aFMro80yk/fV0nkCcqQy
         yVMsD+sU3LHl4lSauac8rd9YCggFgoodhsCGbM5Eh2HoLDIosa8gy3u+Thn/EqFjpg/j
         FDuHuIgel9KC/esPGWsUpObX7QxW5Y1JKUR7PZvb2PQ28zPXzjQngEz42S3ckpPpWuE8
         qbKaf2uNxxrUEz0tKdtjhDuxMc8lpHJ3cyX1A5wZxiJiCHY9Gq7nE2LJa7wSG3bVxTg5
         JjSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683978727; x=1686570727;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tPaRCdR9znhCSBNCV7Zh/uxMhVYAfQIv0T/cvc7dHOA=;
        b=RSRkQdJgHg5oagc1jRIB7LQf/tyYzY4LTlUJGzYNvyJadWCj4fwy1PczcV8/G/qVfN
         5QQiZDtm074O4qF2XsOzhoX/KnCD07oGrP9AF7uzplvrea20sV79lf4fGeNv14QmXwm+
         gS79putuXBr+/y1DVMhuIWcKMlVhACNgqNeKUXhmEN+A8Jb5mKO90IshysToPPztIcov
         z5BHQROXOECqx8ss7dHar8cOwNbmQGECO9XzVJFf2qe2PsM7US7A2uibqwBYafpYdW5Q
         qv6OdwbjI4inSwhbPfpgB1mjt2YF+41rFbKHDRGL80dRyktO5DZySNlhcCCdqWaqVcmS
         tTNQ==
X-Gm-Message-State: AC+VfDxfUgjmViGnLtYbN0vwkCKLUd6CecXeWliOXX6/7S4qfmIAB7S3
	x0xwePRg1ZyACRqEDn/ky2e+dA==
X-Google-Smtp-Source: ACHHUZ5dS7Vklfd3PE0jN2aWltMimSAo2leBDSacKryWJyI4F7P4qcPTn9UvNGhqoXUrqvB+DKW/pQ==
X-Received: by 2002:a17:907:c1f:b0:961:ba6c:e949 with SMTP id ga31-20020a1709070c1f00b00961ba6ce949mr27914478ejc.68.1683978726791;
        Sat, 13 May 2023 04:52:06 -0700 (PDT)
Received: from krzk-bin.. ([2a02:810d:15c0:828:a3aa:fd4:f432:676b])
        by smtp.gmail.com with ESMTPSA id hy25-20020a1709068a7900b0096607baaf19sm6723119ejc.101.2023.05.13.04.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 04:52:06 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Thierry Escande <thierry.escande@collabora.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] nfc: llcp: fix possible use of uninitialized variable in nfc_llcp_send_connect()
Date: Sat, 13 May 2023 13:52:04 +0200
Message-Id: <20230513115204.179437-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If sock->service_name is NULL, the local variable
service_name_tlv_length will not be assigned by nfc_llcp_build_tlv(),
later leading to using value frmo the stack.  Smatch warning:

  net/nfc/llcp_commands.c:442 nfc_llcp_send_connect() error: uninitialized symbol 'service_name_tlv_length'.

Fixes: de9e5aeb4f40 ("NFC: llcp: Fix usage of llcp_add_tlv()")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes in v2:
1. Fix typo in subject prefix.
---
 net/nfc/llcp_commands.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 41e3a20c8935..cdb001de0692 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -390,7 +390,8 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
 	const u8 *service_name_tlv = NULL;
 	const u8 *miux_tlv = NULL;
 	const u8 *rw_tlv = NULL;
-	u8 service_name_tlv_length, miux_tlv_length,  rw_tlv_length, rw;
+	u8 service_name_tlv_length = 0;
+	u8 miux_tlv_length,  rw_tlv_length, rw;
 	int err;
 	u16 size = 0;
 	__be16 miux;
-- 
2.34.1


