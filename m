Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB004423D2D
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238429AbhJFLtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238341AbhJFLtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 07:49:47 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CEEC06174E;
        Wed,  6 Oct 2021 04:47:55 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id p11so8734749edy.10;
        Wed, 06 Oct 2021 04:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kw3Ir5Gyq+D9F9tT/lLiOTdXEuPzQBCuLATIbYBfmVI=;
        b=dwY2KVF1HvyTa8h+U8S2GFBGu4Udoz3uDcf3mlLaxfmuiIz412ewVYPH/h8PjuKFnC
         Fow2I78Te2AXa+y86sgA1gFqxM+lFGG1jnD8KWWhsywG+i0zecNIzZeAkwGLVTwV+pDg
         o06tLE6SEIQQM8wGDjNEWs2dMQg8GQcOaqBcE2IAQ09QUBPC4Hoe/1+Zy0HLZy/d5Wjg
         9q8wvjrwkvy8XncfWHZ+Ym/weRjzE7UYfDysPCP9Ew98fuUeK6QRDs034X0FEu/h92m2
         EtUOo9YECudEgkUWUHPEL58IY3FbkKOOxi505MgyGd9iTuPnMEcQkWrH2CA10PSOAxAe
         L/0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kw3Ir5Gyq+D9F9tT/lLiOTdXEuPzQBCuLATIbYBfmVI=;
        b=zSbWs1ESsaTK3xPxwnNnhiQ6tYhvA0dDU6vzDWvWMMmuxpxxshmMMMk/PBiva2dWeF
         1+KvTWQlp4ATv2qwYO6HsykMrhBxUjUhU3g0svehimfyKgbiJ9qNaQEm00np6jCXqC+r
         c0Ye/vi7NT0MuGxKq6KbHdJsVDCAtiRW0uSwwE1PcKSwxOXvRPhG1aUlKobJwLbZIuRj
         Wiu6H/9CdYeieXgwjfVlIqwQZFMq2HEHhtsjwKSzHIa8kssKVT6dHA+q4qXrjHt3+3Ke
         zWam64LtZpWFRIpsGk2GKJlvEuX89bKNvaXv9ZwUdVtiWr0lKQiTL3ulmkX2tDPVwMDJ
         dyrQ==
X-Gm-Message-State: AOAM5300gIlfbMhFxciYAHKm66DmD3i2arS54CfJPq9k0pINHqSRykPR
        HEFdEMmWJ4OcYyFqpB7zhCo=
X-Google-Smtp-Source: ABdhPJxuA+vaE0UvBVgP8LaKn+wRg1iSIfy9Mpq4awfAyYp+9LJM1uJSyNm5MzA+IHt1kIyxtzl+6A==
X-Received: by 2002:a17:906:2ccf:: with SMTP id r15mr23980620ejr.182.1633520873513;
        Wed, 06 Oct 2021 04:47:53 -0700 (PDT)
Received: from localhost.localdomain ([95.76.3.69])
        by smtp.gmail.com with ESMTPSA id y40sm1402187ede.31.2021.10.06.04.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:47:53 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] selftests: net/fcnal: Mark unknown -t or TESTS value as error
Date:   Wed,  6 Oct 2021 14:47:18 +0300
Message-Id: <ba13bcf10f6deecadaf8a243993a273dd2761422.1633520807.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633520807.git.cdleonard@gmail.com>
References: <cover.1633520807.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now unknown values are completely ignored which is very confusing
and lead to a subset of tests being skipped because of a mispelling.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 2839bed91afa..43ea5c878a85 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -4005,10 +4005,13 @@ do
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
 	vrf_setup)	 setup "yes"; exit 0;;
 
 	help)            echo "Test names: $TESTS"; exit 0;;
+	*)
+		echo "Unknown test '$t'"
+		exit 1
 	esac
 done
 
 cleanup 2>/dev/null
 
-- 
2.25.1

