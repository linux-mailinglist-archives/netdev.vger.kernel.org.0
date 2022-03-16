Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2604DBA26
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 22:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347608AbiCPVdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 17:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358221AbiCPVcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 17:32:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34F3B875
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 14:31:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l19-20020a252513000000b00629235aacb2so2955578ybl.13
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 14:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to;
        bh=3dsz5dbH5kEyW4axTTb+7KMz2gUw7wSKEz7pXvCGPrI=;
        b=ruNLN0QUwD2+P/9mZCFcDHrzi0ACCz+1MTWu1lIN6BlCsR0ly2aiNUo/Kp40a3AMeJ
         /AUHpc+OYELZsczBMIrwsmu34ZCChO0UYpeq4IJYA/tJeGdgBUzKrX/3TDX3tTTeQLGD
         p7HkXsxTU9QgSSDw6W8qSpv4+qNduinc9sF9GGrB97i2uexR2aMNoaYmlVdp0X2OprvF
         2X/oCyWd7u/ZWhPWF5T5kbF4qACt9+aPjNxcSQ+aKQzT3+XSQIbLV1SSB34suAM+Jsdp
         pxXqFP+lRP/VCkmPc4bLIY0vjKemGmUX8owFShWx3qArUJuQ325C0GcvzKGs+8aAnHOy
         daWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to;
        bh=3dsz5dbH5kEyW4axTTb+7KMz2gUw7wSKEz7pXvCGPrI=;
        b=ByAfDS4jq58UDFuxHHbHOqgq0Cy2ZKLjGG6hOMSoOq/vfrb3YqhT0GUMjsAEQUrCQY
         nEuEc7BmtH1JiImR4Zkio/35Y+fEIg811pEhgdyMSFfDsTNRzpNoQfukpzmHYGgSYuSw
         JDW9mL9kzIEr3dJb5BjZAQ+yanem/2ODkjIpXAqS9BM3R/z8WiNC8uE9oxeTsmafhsMG
         NvTmspYC96wePw/1DiG90+0U//sVWUwWJb1RxFoDpeTVPY4CSOyIjT4MsGGgTFk1MxCR
         qH3UCvrdselnHEdmod8xcIpaQLFeYJ+LDlzkiMG2jFqFtyH0kdOXdEUjq14w/1YwN9vD
         YYwg==
X-Gm-Message-State: AOAM530wwwZWKtii4n3BX0feHoXoyHPtSqMOU2ddccq7Z1vEcK6TXu6W
        ehoMgyIuP2EMWmM6LWEvhFyQSuPw
X-Google-Smtp-Source: ABdhPJy1RUm7WtIB242YqrV+NlR2c3Uq5jQuRSedyLxsPeiksy1rrgcfsuz3Cam2NAcioXpHWSZZ7tzVFw==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:7dae:6503:2272:5cd1])
 (user=morbo job=sendgmr) by 2002:a25:e78e:0:b0:633:9df1:9fff with SMTP id
 e136-20020a25e78e000000b006339df19fffmr1426122ybh.233.1647466289213; Wed, 16
 Mar 2022 14:31:29 -0700 (PDT)
Date:   Wed, 16 Mar 2022 14:31:25 -0700
Message-Id: <20220316213125.2353370-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH] vlan: use correct format characters
From:   Bill Wendling <morbo@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Bill Wendling <morbo@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compiling with -Wformat, clang emits the following warning:

net/8021q/vlanproc.c:284:22: warning: format specifies type 'unsigned
short' but the argument has type 'int' [-Wformat]
                                   mp->priority, ((mp->vlan_qos >> 13) & 0x7));
                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

The types of these arguments are unconditionally defined, so this patch
updates the format character to the correct ones for ints and unsigned
ints.

Link: ClangBuiltLinux/linux#378
Signed-off-by: Bill Wendling <morbo@google.com>
---
 net/8021q/vlanproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/8021q/vlanproc.c b/net/8021q/vlanproc.c
index 08bf6c839e25..7825c129742a 100644
--- a/net/8021q/vlanproc.c
+++ b/net/8021q/vlanproc.c
@@ -280,7 +280,7 @@ static int vlandev_seq_show(struct seq_file *seq, void *offset)
 		const struct vlan_priority_tci_mapping *mp
 			= vlan->egress_priority_map[i];
 		while (mp) {
-			seq_printf(seq, "%u:%hu ",
+			seq_printf(seq, "%u:%d ",
 				   mp->priority, ((mp->vlan_qos >> 13) & 0x7));
 			mp = mp->next;
 		}
-- 
2.35.1.723.g4982287a31-goog

