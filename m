Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A440D3BE42E
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 10:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhGGITB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 04:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGGITB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 04:19:01 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E29C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 01:16:20 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g24so1074114pji.4
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 01:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v7HcyF9w9I5AYnUxNpnBtVLS3vGIbX+eJKxfWCMSUIY=;
        b=FNA666qKc5cjULDCKnfePWxNH+Go+r38KsirzIN9cXWH23vK4Ca7KGEzUkfpHMJEmK
         IoF+2HIhqfhUmRcrf3AzF1VKx1UoIY2m9oKamNXRxWUm6ot2VyYpgpNLXfpnUN2g9Lds
         PmtCh3kTlIC+XfRyoGbKhDIdddEbC790UkohdwliGecNlF7H3dvHoZbiEMnzFhgtL0py
         EEw7XJHvdIVh19s6X8lGlNBK0Ui4FRSYdQyib4nGNir8Pa9mYs/KWTWtx/hjPoX/2nHL
         QzYWLq8atWtzVJgNfkQMTiac5UXfCAp71T1Boghdc+ACsf/DartZY843Cp8Px7h5+lgp
         gCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v7HcyF9w9I5AYnUxNpnBtVLS3vGIbX+eJKxfWCMSUIY=;
        b=mUem6RMgYNrSuF0LZdB+bNJk18yxPBlG765VI7gWQXGBFdCLkpqqN30pPp0VxOZGuV
         9m4gWJeRfRSj0fTm4PSRRp6kNMdyK1TVRe9oPlhD/FrKngrqC6cLQ4F8dVo0LDcaDdc/
         QveCBWOBoIAXpiYwGIWJXXLE3s7x6EEgdWRrniwXFT1lYVh8RTG1pXv9jnW34CU5JwU1
         G/cIUVYAwHabwHchN4o9+S2YiM62zs9y66u3HJm1FLzzqDMjxrRWfmXfgRb+3hih28jv
         VsQHzAD5aKb9988+lzKE+f1VjDZnOU6IJUXON8oekhS0EY5y7/06p0NgOiNl/Wpm59C0
         b9MA==
X-Gm-Message-State: AOAM533w9RfxbwGDHsU3uWyYjRLsKLVjXORWXrVEjx79rfYqHcNggmuC
        WKVK5S7MvXastop0vDMeGJagcJhHtl5fz1kR
X-Google-Smtp-Source: ABdhPJzFExJJe6+HKZ2DWvc3A2L6PMpbUtWzssRqe/PawpRTzu4vBdnJ9uBdPrzZzBZ1dJw3jgAn1Q==
X-Received: by 2002:a17:90a:cc7:: with SMTP id 7mr5057045pjt.20.1625645779945;
        Wed, 07 Jul 2021 01:16:19 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u40sm15476365pfg.19.2021.07.07.01.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 01:16:19 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 1/2] selftests: icmp_redirect: remove from checking for IPv6 route get
Date:   Wed,  7 Jul 2021 16:15:29 +0800
Message-Id: <20210707081530.1107289-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707081530.1107289-1-liuhangbin@gmail.com>
References: <20210707081530.1107289-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the kernel doesn't enable option CONFIG_IPV6_SUBTREES, the RTA_SRC
info will not be exported to userspace in rt6_fill_node(). And ip cmd will
not print "from ::" to the route output. So remove this check.

Fixes: ec8105352869 ("selftests: Add redirect tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/icmp_redirect.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/icmp_redirect.sh b/tools/testing/selftests/net/icmp_redirect.sh
index c19ecc6a8614..3a111ac1edc3 100755
--- a/tools/testing/selftests/net/icmp_redirect.sh
+++ b/tools/testing/selftests/net/icmp_redirect.sh
@@ -315,7 +315,7 @@ check_exception()
 
 	if [ "$with_redirect" = "yes" ]; then
 		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
-		grep -q "${H2_N2_IP6} from :: via ${R2_LLADDR} dev br0.*${mtu}"
+		grep -q "${H2_N2_IP6} .*via ${R2_LLADDR} dev br0.*${mtu}"
 	elif [ -n "${mtu}" ]; then
 		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
 		grep -q "${mtu}"
-- 
2.31.1

