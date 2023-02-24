Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F5B6A213B
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjBXSLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjBXSLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:11:46 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402926C188
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:11:45 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id f19-20020a9d5f13000000b00693ce5a2f3eso93026oti.8
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kcVj+e3MEbv+Xd09KUM3tB8THbz9IQcXtyiz+MIZb9M=;
        b=Szo1Yg8HdB7u+kAz8CLVjcHAauqjqsw0qrW8+r3fODRVXpwybxwDeIsVWrnenPS7TG
         iwPK1HuQLzM4mHbZ4meW0G7mYRQ8evxG9GijuqIUSYrJzhUHOIFGhiHqsHfAwqSPv8PG
         BypceFpy1dkJX+UUiwGBSEyXrHwRknIAhU89X9CXdeuWiRLdH2J9EwcYQ8J449evRfE/
         V0sglPAVJPpRwh2KYGA4/8X0za0EmiE+UHfQZBEnGY038IvVUN61TuJenAqn7g/dNaE+
         LPnKyfSmnd4ZoV3H5PfSvR3iS7mwLjQ//1fr6Rg3HaxXyTxBJ7330f3urpOJDKE4hvir
         PO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kcVj+e3MEbv+Xd09KUM3tB8THbz9IQcXtyiz+MIZb9M=;
        b=CQCLlZIah80v1tVm9LzGdVLYrfafdPdYl5HZZOIlTswHipBURTTUtyr3Niz7CBzUBa
         9fbMthWvgq0vbZf53vlLN9oBca5ng5hy1xBDHjR4b/PROydUpyw4f/lvYz+C+EBxBeBY
         JrM7l4cRsK4LHpK+2egC/3aIJ9mkhjvSIWqXuTuXmljksovZOoP4wkpR62ss/ujVEW6X
         sR6yxZsfZLLnU0FMYc0d0ZuVD9/iU+OuEoKrmbOZRxj6vvm6ajrNYoUDuwTuxClNZpby
         sgFZbamzb0+ADec+wfiDvE+jYRYCXdy+nKfIQPk8nGURtsW3mPOmrVGDXjsylRFrBjlw
         qIIw==
X-Gm-Message-State: AO0yUKUgIt7AmWWUAaqhyFebUVPK48OjF0X2yXnJsWXxRXU3HRgQz4dC
        EQI1Gh7KJDFvzP1PpFEK+MXHjb0xbENDrEjX
X-Google-Smtp-Source: AK7set9Gu+yl2p3ZY/mlcK/YvGqXYsKY465pcS/SXjCLpo4NGOpP5YbqkJOcYsS1k2EAgRn+BB/crQ==
X-Received: by 2002:a05:6830:698d:b0:690:eb17:89f4 with SMTP id cy13-20020a056830698d00b00690eb1789f4mr268657otb.3.1677262304492;
        Fri, 24 Feb 2023 10:11:44 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:aecd:86a3:8e0c:a9df])
        by smtp.gmail.com with ESMTPSA id y7-20020a9d5187000000b0068bb7bd2668sm4040827otg.73.2023.02.24.10.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 10:11:44 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     Pedro Tammela <pctammela@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH iproute2 1/3] tc: m_csum: parse index argument correctly
Date:   Fri, 24 Feb 2023 15:11:28 -0300
Message-Id: <20230224181130.187328-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224181130.187328-1-pctammela@mojatatu.com>
References: <20230224181130.187328-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'action csum index 1' is a valid cli according to TC's
architecture. Fix the grammar parsing to accept it.

tdc tests:
1..24
ok 1 6d84 - Add csum iph action
ok 2 1862 - Add csum ip4h action
ok 3 15c6 - Add csum ipv4h action
ok 4 bf47 - Add csum icmp action
ok 5 cc1d - Add csum igmp action
ok 6 bccc - Add csum foobar action
ok 7 3bb4 - Add csum tcp action
ok 8 759c - Add csum udp action
ok 9 bdb6 - Add csum udp xor iph action
ok 10 c220 - Add csum udplite action
ok 11 8993 - Add csum sctp action
ok 12 b138 - Add csum ip & icmp action
ok 13 eeda - Add csum ip & sctp action
ok 14 0017 - Add csum udp or tcp action
ok 15 b10b - Add all 7 csum actions
ok 16 ce92 - Add csum udp action with cookie
ok 17 912f - Add csum icmp action with large cookie
ok 18 879b - Add batch of 32 csum tcp actions
ok 19 b4e9 - Delete batch of 32 csum actions
ok 20 0015 - Add batch of 32 csum tcp actions with large cookies
ok 21 989e - Delete batch of 32 csum actions with large cookies
ok 22 d128 - Replace csum action with invalid goto chain control
ok 23 eaf0 - Add csum iph action with no_percpu flag
ok 24 c619 - Reference csum action object in filter

Fixes: 3822cc98 ("tc: add ACT_CSUM action support (csum)")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 tc/m_csum.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tc/m_csum.c b/tc/m_csum.c
index ba1e3e33..ca74427a 100644
--- a/tc/m_csum.c
+++ b/tc/m_csum.c
@@ -94,7 +94,9 @@ parse_csum(struct action_util *a, int *argc_p,
 	while (argc > 0) {
 		if (matches(*argv, "csum") == 0) {
 			NEXT_ARG();
-			if (parse_csum_args(&argc, &argv, &sel)) {
+			if (matches(*argv, "index") == 0) {
+				goto skip_args;
+			} else if (parse_csum_args(&argc, &argv, &sel)) {
 				fprintf(stderr, "Illegal csum construct (%s)\n",
 					*argv);
 				explain();
@@ -123,6 +125,7 @@ parse_csum(struct action_util *a, int *argc_p,
 
 	if (argc) {
 		if (matches(*argv, "index") == 0) {
+skip_args:
 			NEXT_ARG();
 			if (get_u32(&sel.index, *argv, 10)) {
 				fprintf(stderr, "Illegal \"index\" (%s) <csum>\n",
-- 
2.34.1

