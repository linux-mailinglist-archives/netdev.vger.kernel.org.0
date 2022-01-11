Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930ED48B4AA
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344900AbiAKRy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344769AbiAKRyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:54:49 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A2DC061748
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:49 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id h1so18368563pls.11
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/oE5+nHZ47hf0eq1B8VOPvwAM1+8jomIksNPwOnPNNA=;
        b=NJOry5YTyGOUnXe/1/j2hK0F60ua7ZI98hiaH+DoxszNCVWEtfVwzTQIfTSVCENMf8
         GVm5Bki15lVtaEE9/6U/rRObFvNGboDUYzLmebOZr9ybxJY8d30JQfGZiFI/4JOyXeYc
         thGFtLbgCGilsUStjBPNjqF/64mtfjfOv/oIidcEmVcIDTF7Q7mIxX0o33oxeWI114NI
         vvr82QthAGGKkOlQjNdJqDAlmp/F/fLgyGA3EsQ1JUE501wW6I4rucOsoXHmUot8QY7/
         etISnWoDXAU04CpO3VQnyUlIOsv94Bp6SieF1mPVJX4Vi3BjVf4wPgNWroXg3Bn2oSDJ
         KLJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/oE5+nHZ47hf0eq1B8VOPvwAM1+8jomIksNPwOnPNNA=;
        b=GMmaQ50kjR5u8qqJmKGWkAvhUuNFEij9QzqHN7ts3wEmD89UuWQd2MYB+Lg6mEpIjj
         P8rRq0XRD8vV4nF7K3pArBtLTygcxj8r7ct4tmE5gUdoCQGds7T2Tx2OMHmDSfEpDrrO
         qR+B1GA1YHE3zEEvuh/k7GgbTOvPqEYtaoVHQw1EzyY+3lN59RUiEJlkT15ZFb+Ki7wm
         JBBBUOgIwnYVuRsM/m0+DrBqtqRSnHKmFbCdTY5EPNBCsFYq4m0DU1v+dSWa59FOkTWY
         Ae4g9IGSpEUWMrhWqGRw6EUOEZVkIE4+fGfrLY8Pbl4f1QgD6+RnHsUSUhf7RP4BCUt4
         o+aQ==
X-Gm-Message-State: AOAM531ra9QkaCfmkKAmMDHqJNIcgNtMeUW7yLm+TNaifBQa81+iSc7q
        Gb0xL/Ronz3wolHCgkbgOhd9p6EuZWRJdA==
X-Google-Smtp-Source: ABdhPJyJPp21hIiScw+VsAH/v+SDTGq85u6XOpwJEyc4bh35QFfpQ+sp08O4aNyEDLYw9JLf3WoZuw==
X-Received: by 2002:a63:3f04:: with SMTP id m4mr2772831pga.326.1641923688647;
        Tue, 11 Jan 2022 09:54:48 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f8sm23925pga.69.2022.01.11.09.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:54:48 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 07/11] can: fix clang warning
Date:   Tue, 11 Jan 2022 09:54:34 -0800
Message-Id: <20220111175438.21901-8-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220111175438.21901-1-sthemmin@microsoft.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix warning about passing non-format string.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iplink_can.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index f4b375280cd7..67c913808083 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -330,8 +330,9 @@ static void can_print_nl_indent(void)
 	print_string(PRINT_FP, NULL, "%s", "\t ");
 }
 
-static void can_print_timing_min_max(const char *json_attr, const char *fp_attr,
-				     int min, int max)
+static void __attribute__((format(printf, 2, 0)))
+can_print_timing_min_max(const char *json_attr, const char *fp_attr,
+			 int min, int max)
 {
 	print_null(PRINT_FP, NULL, fp_attr, NULL);
 	open_json_object(json_attr);
-- 
2.30.2

