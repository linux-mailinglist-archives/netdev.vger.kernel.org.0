Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72ABF6C398A
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjCUSt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjCUStx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:49:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706C45653B
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679424498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=m16LG5qfJ+bTUG6Spw+RzSoYpGmgfuoZ6sJRsgb/iNs=;
        b=XsSSwi/nqbkFz16wOrUMWiSrWxdTWKaBEdSm91p0PnhLR+5FTbunRDg4uYNTOuH0oEXFE5
        72wWF2DLlOrZQFCjDLU3TSz4xg1yBcGEi/y4rtttToqeToNRWfcQwrn4eJgTQXA0GQ3986
        5Fjd7BUFZVoSsYqdH/VEYFOKsAY/2VQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-3IlF6XWnMPWgOhTPa6jR9A-1; Tue, 21 Mar 2023 14:48:17 -0400
X-MC-Unique: 3IlF6XWnMPWgOhTPa6jR9A-1
Received: by mail-qk1-f198.google.com with SMTP id 198-20020a370bcf000000b007468cffa4e2so2896078qkl.10
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679424497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m16LG5qfJ+bTUG6Spw+RzSoYpGmgfuoZ6sJRsgb/iNs=;
        b=kQRydRCHt1cns2aa5rwrvWbhGRb88BK/ZRf0kGzAvBDkswvHMj1XmFq+DCcOK5eePa
         vW+IYpmf1Cq9CuYbHuch5BGiipSMPg6IHEOjpMJEidajnTE6/+f4MDaK2K3TEFuVb7Qj
         zFupej2jOXWJI00h8ZIxXjF2fN0OLutPNtGFyrcrmACX6vOR2i1ZcQCn1y3M+BakHPRA
         YWvlPj7Mvks+GhPrjUXf4oxmQ2TZMDbZRNAh8LHHaRVmJr18VMb6b/IAWy4szT2LQjaH
         fiTUnIGcmrVkd8cUekWO2N5/oqt0hmunqWH514cMVk8wElZMtYrynoJ65RZWQjpO9j7t
         EPkg==
X-Gm-Message-State: AO0yUKWhS39SYIThl5ay29TO5Da9gHDRkNdcwIpkVwbQn6No9t2MIlg0
        sqMDEe4FiCrUeQb9IzmDIzcnIlD5/f8WuPIQHB0vmuLRp3JpBe4gQ9PDIE/owK3YIvjAYITLxsq
        6/DBV8zvejqZwwsF7
X-Received: by 2002:a05:6214:e4c:b0:5a3:44a1:788d with SMTP id o12-20020a0562140e4c00b005a344a1788dmr1318801qvc.29.1679424496990;
        Tue, 21 Mar 2023 11:48:16 -0700 (PDT)
X-Google-Smtp-Source: AK7set/uiKZ9Rf3XmfwDfIlgK1+2Ku5dlt08hCszlwq6yiw64bq4vrpan11278XtwOhJWytpr/YkPw==
X-Received: by 2002:a05:6214:e4c:b0:5a3:44a1:788d with SMTP id o12-20020a0562140e4c00b005a344a1788dmr1318782qvc.29.1679424496733;
        Tue, 21 Mar 2023 11:48:16 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 66-20020a370b45000000b0071eddd3bebbsm1525699qkl.81.2023.03.21.11.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 11:48:16 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] liquidio: remove unused IQ_INSTR_MODE_64B function
Date:   Tue, 21 Mar 2023 14:48:11 -0400
Message-Id: <20230321184811.1827306-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang with W=1 reports
drivers/net/ethernet/cavium/liquidio/request_manager.c:43:19: error:
  unused function 'IQ_INSTR_MODE_64B' [-Werror,-Wunused-function]
static inline int IQ_INSTR_MODE_64B(struct octeon_device *oct, int iq_no)
                  ^
This function and its macro wrapper are not used, so remove them.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/cavium/liquidio/request_manager.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/request_manager.c b/drivers/net/ethernet/cavium/liquidio/request_manager.c
index 8e59c2825533..32f854c0cd79 100644
--- a/drivers/net/ethernet/cavium/liquidio/request_manager.c
+++ b/drivers/net/ethernet/cavium/liquidio/request_manager.c
@@ -40,15 +40,6 @@ static void  __check_db_timeout(struct octeon_device *oct, u64 iq_no);
 
 static void (*reqtype_free_fn[MAX_OCTEON_DEVICES][REQTYPE_LAST + 1]) (void *);
 
-static inline int IQ_INSTR_MODE_64B(struct octeon_device *oct, int iq_no)
-{
-	struct octeon_instr_queue *iq =
-	    (struct octeon_instr_queue *)oct->instr_queue[iq_no];
-	return iq->iqcmd_64B;
-}
-
-#define IQ_INSTR_MODE_32B(oct, iq_no)  (!IQ_INSTR_MODE_64B(oct, iq_no))
-
 /* Define this to return the request status comaptible to old code */
 /*#define OCTEON_USE_OLD_REQ_STATUS*/
 
-- 
2.27.0

