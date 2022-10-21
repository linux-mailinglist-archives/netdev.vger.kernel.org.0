Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64ED7607ED8
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 21:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJUTNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 15:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiJUTNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 15:13:48 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B2B15A8DF
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:48 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id i65so3176385ioa.0
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwurrB7qdNkMpnWeG+ha/LhhiXkd7fDsKvUQoo9Dexw=;
        b=GBbpot0zp4+XeMgKSqEiFGsGVvyxt8vtlPZJfrtB3MbianLPzdG3fvyx8gmq+A1eiK
         F4L/j1yYMM0+nGOKtHn7qj1X6GNE/ZvCE4wdz4VA0ZMaiVURkF1XxVzWHNlNW1FYAbDu
         iqcGFuF08cIhPA0Xm+QfUiQuLJZPb2SIYPwqoqoqHRUrI8zmt7mt41q8xOE2m25OfLBR
         rFPFHSnHzeSt7ap5bolW/T2ccHm85XACIHUehjyR1NntmJym1N/p6a1t2473aw9Z+H1W
         E1vfYvdxYpolHCIOCdZH6o9nhyDv13v4JL6306T+B2B+YITr3FZQvUp0bYzCR8vTOL5e
         Mp1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DwurrB7qdNkMpnWeG+ha/LhhiXkd7fDsKvUQoo9Dexw=;
        b=YGAQTMGf4Admw5ekgY2MFrwViZazfZYc40krMpaaxw0CqLWYV98gEImJVDn6t/wcw5
         w0cWgbI/fTdaIcPcd++otKPbSB2Zor1oppuQuFQkooYxHKYDABbjZvU23/Q9HwgI1gn8
         nImZmgsdeyXACo5evU4XQLe/+MnWkdjn314Pyaax0cbT6zMKrUhBDeKNQI9R5E1MtafB
         EbgMX/zZyyaQWwirw2AIeKe+a73W3QKkk3OA6Pfzw+fWrTChW39UDmGcusGN4bWdi9GV
         orKE+xtnuydnAKsbGX4jkrNwuI3lbRwk1LoH7rrzfr4G7HGPgAtWtxVXeUjOtGzBGavb
         5ziQ==
X-Gm-Message-State: ACrzQf0/NG9JqMFywZNizQLqztk60Vpw2+ugnykcjfXmIwcctBzjvT1C
        bA2ZaUaJaDio1nZ8gFqtmLWLES+JFGE1RA==
X-Google-Smtp-Source: AMsMyM4+O93I7fkx2l0It2gMZCh9Vf+URaLPoTlpiCTWwbO4CTVZsxTbgLTYxLt3mJkYlv6RhxUrAg==
X-Received: by 2002:a05:6638:4304:b0:343:5953:5fc8 with SMTP id bt4-20020a056638430400b0034359535fc8mr14970008jab.123.1666379627832;
        Fri, 21 Oct 2022 12:13:47 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id e3-20020a022103000000b00363c68aa348sm4439362jaa.72.2022.10.21.12.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 12:13:47 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/7] net: ipa: remove two memory region checks
Date:   Fri, 21 Oct 2022 14:13:35 -0500
Message-Id: <20221021191340.4187935-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021191340.4187935-1-elder@linaro.org>
References: <20221021191340.4187935-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need to ensure table memory regions fit within the
IPA-local memory range.  And there's no need to ensure the modem
header memory region is in range either.  These are verified for all
memory regions in ipa_mem_size_valid(), once we have settled on the
size of IPA memory.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 26c3db9f52b18..e46e8f80b1743 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -197,16 +197,6 @@ bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem, bool route)
 		return false;
 	}
 
-	/* Entire memory range must fit within IPA-local memory */
-	if (mem->offset > ipa->mem_size ||
-	    mem->size > ipa->mem_size - mem->offset) {
-		dev_err(dev, "%s table region out of range\n", table);
-		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
-			mem->offset, mem->size, ipa->mem_size);
-
-		return false;
-	}
-
 	return true;
 }
 
@@ -257,15 +247,6 @@ static bool ipa_cmd_header_valid(struct ipa *ipa)
 		return false;
 	}
 
-	/* Make sure the entire combined area fits in IPA memory */
-	if (size > ipa->mem_size || offset > ipa->mem_size - size) {
-		dev_err(dev, "header table region out of range\n");
-		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
-			offset, size, ipa->mem_size);
-
-		return false;
-	}
-
 	return true;
 }
 
-- 
2.34.1

