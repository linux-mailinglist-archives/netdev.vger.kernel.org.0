Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6B56A47F9
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjB0Ra1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjB0RaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:30:19 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E6F23665
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:30:02 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id l25so7070829wrb.3
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FXsFeSYXhhebwYsbMFUFO6H/liA5A1XnJx5Vo1iUzXc=;
        b=jiVVUh6ZHHuKpGgbeAqEhbPiahxX+jfZWSAjgEXV8ubCHO2eeD3cm9dO+ZMPTOo+0v
         c4Zm5N40uRAJ4i98u0ChAFvGiXUCcdFBvVCqxsB6131UdLT8Cq8ob/S0/UCBi3Z1FCWv
         GWFT7FXNdspyMXNozScqtQ379CI964ap5nyUewPyzOajMluOjP6wrX+JjZ0R4j89RToF
         IplencS/rDEOm3RBcw2swu5QGQAyPM5Jtoq569WrQTGUD2dpxFMPc6wdkBcP9Fjytr/I
         BzMyL0AJjTap2JgXMqrDICHxy4+wD16ZCyUBB61BIc6JmfsF0dvc8mHF8jhdUNzXSZ3k
         bhsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FXsFeSYXhhebwYsbMFUFO6H/liA5A1XnJx5Vo1iUzXc=;
        b=CMSDRx5Xj+F/UGSAeSMyfutI13qMrIdqNNe0RAi1YL6NI/+D6CkRy45CPpzWXqZolD
         jHSuF5D5a0ZiKeHQw1wSsn4/hY/xnRLI70S7XvBiMG0lxp7ejlWqSiRZlKN0J8aPfuWO
         /yHH9LUNZunuiFr2aDNrZgymqBtyYdHf3a9gDtSF9BJfNuCHX5I4s6eiBJxkiRmDBt1Z
         gEbE6xddzzVBWWPjqh5P9D0S+SZpP8Ef4kRM+z97C9mwr5Zhs1y26HLKPQbJ8fsKizon
         SdOFGtqI60Pe3L8lQAkvJ3MciobqbPFk0FGrbEXmukHFkHm4znjWnIPDZvy5cGPSwzYA
         lMhQ==
X-Gm-Message-State: AO0yUKXAzVweMjoJhdRQ+0+lE02IovLzsP+dh18hGt02o9FC8o+3/Eyy
        /yYwl2U4gXdQOwwTWKidM1y5UQ==
X-Google-Smtp-Source: AK7set+GD+WdRwGtNhuSqMvqcdGrq1Sd6/n+McpoTWgTeywGeLxJqtJDYSevMGIS0lbn1/7OP4Bheg==
X-Received: by 2002:a5d:4905:0:b0:242:1809:7e17 with SMTP id x5-20020a5d4905000000b0024218097e17mr18569252wrq.6.1677519000848;
        Mon, 27 Feb 2023 09:30:00 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id t1-20020a5d6a41000000b002c70a68111asm7763689wrw.83.2023.02.27.09.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 09:30:00 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Mon, 27 Feb 2023 18:29:28 +0100
Subject: [PATCH net 5/7] selftests: mptcp: userspace pm: fix printed values
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v1-5-070e30ae4a8e@tessares.net>
References: <20230227-upstream-net-20230227-mptcp-fixes-v1-0-070e30ae4a8e@tessares.net>
In-Reply-To: <20230227-upstream-net-20230227-mptcp-fixes-v1-0-070e30ae4a8e@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>,
        Jiang Biao <benbjiang@tencent.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org, Geliang Tang <geliang.tang@suse.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1019;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=u14VopBS7eG+GMQE/e+myn6drxPOU35I+54NgBvgJVc=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj/OiRvO1nGXreLTk1oRKPUSKUwo3sjBg8CHxXj
 F8Jh9Ior+6JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY/zokQAKCRD2t4JPQmmg
 czLTEAC66fH926z1SBI5/RVMdkXuHWcrSbzqIIAesibSfPKAd89A72IhbHffWOhgnzvfpsbG6YS
 7bWsdjYKS4DN8bvwYeoRDGPnul0H+PdaIr2P0DNW9Yewqkahkcq5fPlZvbHnz8daq5yVK63CFwg
 T7/R8aNz7484dT+yiLKjVPJSpAA9lt+kXrqBIDag+nxh3jy85+Y856hMRif3Jqq75c37+QxE3Nb
 9Swwp4GKoDBV/kmufiXgIBi2p6XC6aC6FBucSeQr3PcZox01SxcTjnOBgOqJJ0ONGaPVYlNrCUP
 O7gHIZN4jpMBkRdd3K/hNcUtncIwOSJK4WOTyKL2kKBupA3VTy3SBtQqwK3dVHDcpnOBYhrsbX3
 w7t9rGU/pOucT7fRnAoZZCrWIDCuNVmDN4KmoEShDzItBhnHdA/gyoc/77qYpWc2eh05naGu7yr
 qNY9Hg5Yu6bghEG83vUNOaFwHg9gSDSAMJ192GbViaEEsEmRuDJh8heC5bdytdU44ln+3OFZUjj
 /smLEYPqGpUnHYbFiXTYAikWsg1lE5XYATp1Zu4GUB5fSOi53eFSj3G4gqmpOKTc7iwcn7cRmpx
 ny2YtCYVVWLmB7Wt13LEMgWkyEYhcCkJawiNEvokIb+GGTXO4bppiBHvfRxyfAP852JH9kLcR6i
 S9gTyG1YrdUdv9A==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of errors, the printed message had the expected and the seen
value inverted.

This patch simply correct the order: first the expected value, then the
one that has been seen.

Fixes: 10d4273411be ("selftests: mptcp: userspace: print error details if any")
Cc: stable@vger.kernel.org
Acked-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 66c5be25c13d..48e52f995a98 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -240,7 +240,7 @@ check_expected_one()
 	fi
 
 	stdbuf -o0 -e0 printf "\tExpected value for '%s': '%s', got '%s'.\n" \
-		"${var}" "${!var}" "${!exp}"
+		"${var}" "${!exp}" "${!var}"
 	return 1
 }
 

-- 
2.38.1

