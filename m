Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7818E60F726
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbiJ0M0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235535AbiJ0M0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:26:40 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9789FF23B
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:26:39 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id 11so1305269iou.0
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZhPH98EZI2dEoFXGWQtmjLxJRjCACN6xFS+27Ga9q8=;
        b=CGOB+dy4GUYVpZbN/DWiHffXQGLBKtcmB1o3l8pIV6Su1Tk7/cZYKQBTlO6wnaarmQ
         7VxFaYWL5uwsE9aAL2ZwDSgT0VNkNynJspstC4HVS2vS4YWvbNdYKdx3gIuoHuMhusDL
         GSh6+4QsnoL1WXG8yGkpQ5nU05969EC4nc/mQP+BH5cxcDqHiNJYDLqYY8vgDs9uz5wN
         uNGMVLymJbJfomK+gHqG4Q0Rr+NB8gWE7k3ZXOg7Pdj6k42BfgnCpf8kbAA4gapcXSUd
         E1q6/w1VhnDAepMXHViahUPSJdEs/+tVmTv8jnyFpPIYcPMgHjzFKTKFkZeziQ0YwKat
         DX6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZhPH98EZI2dEoFXGWQtmjLxJRjCACN6xFS+27Ga9q8=;
        b=vAo/FbsPofb8nYFtDWutzhLpwOQdTOVFHfd/mcKouO+HNY0z2OkGUS44APaf59xG1f
         SRyos/clOmH8DG20sUoMSUwq/cB6EuV6oigJHoGI0RzkhT+QmHgx2OhC16rBpR0fq14I
         5o9HOwW7MGH/bUC6nAcDPktePfHTGNuulSTSDztuzx2PNQ+kC6s6inNwseV6xJwKA3nh
         3ak+4V2coeKR6JJ4oxiEwNxJeLqQdL4liRn1dXJoZ4uo+ps7AIFXJvP2A11SX2ESlY0J
         jr6vXCu8eZy5t/edr5prIhRnUcHTdo3/ImND1ZWK2+T1rqOIiqKsu8YGKYSIfSzgSTDG
         eOkA==
X-Gm-Message-State: ACrzQf04lO/7542/HpdcJICltuLLIELO6v3YGzcvACFHBGn8IC/zuZR5
        qDZnv1j/dtFeqDhtb4Am7GmWQWlkPY8MnA==
X-Google-Smtp-Source: AMsMyM4g+r8w9GFfz7c0hkxjUrZJwSTc6gyWD9hZwwkTwdOZ6LpuMCgR3yYayx37JARnCXXFoBgCOQ==
X-Received: by 2002:a6b:5f1d:0:b0:6c5:247c:6763 with SMTP id t29-20020a6b5f1d000000b006c5247c6763mr1803360iob.65.1666873599556;
        Thu, 27 Oct 2022 05:26:39 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id w24-20020a05663800d800b003566ff0eb13sm526528jao.34.2022.10.27.05.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 05:26:39 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/7] net: ipa: change an IPA v5.0 memory requirement
Date:   Thu, 27 Oct 2022 07:26:27 -0500
Message-Id: <20221027122632.488694-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221027122632.488694-1-elder@linaro.org>
References: <20221027122632.488694-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't require IPA v5.0 to have a STATS_TETHERING memory region.
Downstream defines its size to 0, so it apparently is unused.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index cb95402018394..9ec5af323f731 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -198,9 +198,12 @@ static bool ipa_mem_id_required(struct ipa *ipa, enum ipa_mem_id mem_id)
 
 	case IPA_MEM_PDN_CONFIG:
 	case IPA_MEM_STATS_QUOTA_MODEM:
-	case IPA_MEM_STATS_TETHERING:
 		return ipa->version >= IPA_VERSION_4_0;
 
+	case IPA_MEM_STATS_TETHERING:
+		return ipa->version >= IPA_VERSION_4_0 &&
+			ipa->version != IPA_VERSION_5_0;
+
 	default:
 		return false;		/* Anything else is optional */
 	}
-- 
2.34.1

