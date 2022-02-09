Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874514AEC35
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239110AbiBII0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbiBII0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:26:01 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E757C0613CA;
        Wed,  9 Feb 2022 00:26:05 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id x4so1595729plb.4;
        Wed, 09 Feb 2022 00:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qcjBJ/Ci2VT2f5f7cAYMgRpT1z1jkbGO0KryE5QWZ98=;
        b=A0TRrw7fLJ9eVfA7MjdT8PplW2pF0Hf6og6tUjvIQYCx3+JMf7+sm3aEfqfxoFabm9
         38aogAR6iprWXfy1WlExL0Sw23wuoV+nijCcodDj2eZG0odCpFxe7+aPMxIGJjLe03+J
         WeC0h4fEqFCqt4BjJXfa1fTjj3IWGMOd9Y3up7+qmPeFh3j2OcgsE4pZdiS4We9BpsK+
         2GVb77W/9kWHDzgFUPQWCmnJdojz79ZvPIih5mzbzkBOf9XBNRJ9BcFkSUpj3zCbz4UX
         0BuFGgrg30C1SjIDVRSgbJcJuAMloX4/CGglyw7otIpaegntMTZEfR17l1UQ7+0KtFLD
         4TAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qcjBJ/Ci2VT2f5f7cAYMgRpT1z1jkbGO0KryE5QWZ98=;
        b=lZ7XT/oZApYv4gGbjFJ3uA0ThlZb87xzzaWi2JNR6UzzI5yNHHhPBD0ghUsaGpA/WX
         p21vaAeGPU/jQ975IrifAijjlLMSWIRWU6r3ANZ58jIsA57UZ81OelhgwXhy9WyLS1/o
         5gcFg10+hLMesnBErXCA9lh76jA09MBNiKD/2n6ys7N4g3dCGt6jqkPfE3wYdGu0yuMl
         XtpTEdgze7NEQ62Cv+QqlN1mw/bJvTCT+RTqwSR1pQfsbpD5OfnQwZBcwibWZFJu2eqQ
         pKSVODA+xRIU52/A06mjlqYe8vuX399F2AzoUBDxVjuAHK1uaQFSTSvAcMzjdLSWIQRf
         T7pg==
X-Gm-Message-State: AOAM530LyqgTEdxRx1zlVZGZJax1kL7x272VNvobkXJS1q+R2TZhgned
        QC4GaAhiJs4CcCsU5tQsKHK0E8sXoe0=
X-Google-Smtp-Source: ABdhPJyIHornEkMjATpC9q19n0/2gCr2JmRrsBk/zCu2Jz4jkkk7cfi1Ff6mYh+j/AwhXYHHg+5w4Q==
X-Received: by 2002:a17:903:189:: with SMTP id z9mr1011269plg.71.1644395164335;
        Wed, 09 Feb 2022 00:26:04 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id nv13sm5641533pjb.17.2022.02.09.00.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 00:26:03 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH nf] selftests: netfilter: fix exit value for nft_concat_range
Date:   Wed,  9 Feb 2022 16:25:51 +0800
Message-Id: <20220209082551.894541-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the nft_concat_range test failed, it exit 1 in the code
specifically.

But when part of, or all of the test passed, it will failed the
[ ${passed} -eq 0 ] check and thus exit with 1, which is the same
exit value with failure result. Fix it by exit 0 when passed is not 0.

Fixes: 611973c1e06f ("selftests: netfilter: Introduce tests for sets with range concatenation")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/netfilter/nft_concat_range.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tools/testing/selftests/netfilter/nft_concat_range.sh
index df322e47a54f..b35010cc7f6a 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -1601,4 +1601,4 @@ for name in ${TESTS}; do
 	done
 done
 
-[ ${passed} -eq 0 ] && exit ${KSELFTEST_SKIP}
+[ ${passed} -eq 0 ] && exit ${KSELFTEST_SKIP} || exit 0
-- 
2.31.1

