Return-Path: <netdev+bounces-9279-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9697728597
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C92F1C21086
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD0E1DCD4;
	Thu,  8 Jun 2023 16:39:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB1A1DCB5
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:39:42 +0000 (UTC)
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8E235BF
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:39:20 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-30e4eec95c8so827149f8f.3
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 09:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686242347; x=1688834347;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lOuYSg8J4w1AyHg8USLMCe+g5bUzTKHHhFPUeoHmJUk=;
        b=6W8hni56+3CAISFHLE0+aKfDczVpe3GSsC36gdTSCbo77FUGrxOafMNwf/aZA0P+lp
         0FjNRd6v+dFm42X//HP0dujYr+WFpb5sSkoc1qr6z0z3h04DYSIF2RV5Wg83Luzawvii
         C9u2Oh1aQy81go4yVeJvKLbWBtiUz4qjvhkguIOhfrH6FQskup30X5/DUx/zthL4Lkcu
         QEzSO8vytbsAKig5hGaAG21gVW0MV+Kc578GebqoPcjGH+pHywu1/yPgmbPI2vqkG2kX
         IYeXjgKxLZ0UFqON5AipdWeCLbPeNc5YV/5Aih+YVfvc4OzqJNYpleQCEmp2hVb3FVqe
         t6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686242347; x=1688834347;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lOuYSg8J4w1AyHg8USLMCe+g5bUzTKHHhFPUeoHmJUk=;
        b=VgcVJpvU4hl/83/1cwpH+MDRGxwrWorqkylRRKe9DE5wYI5upb/zOW86MmnwOSmIh/
         AyGTEOMKcJmrydMas3a/fMlZTLER3SSgvNX1FwJHlm0Gx+4+Il6kTsZXdy8HsMLRvgzR
         1NnkRXYIhMlsrinI/RJCEZzRsVmAR4TzIGyZSQHL3naXUgBRjYnHwc2LA4MqZ3M10i8b
         36P6AH2s0mAtlzKaYZNN3CuespozO81gG5wmA1X1W99pLfv3DTK8IYWDW71Fut8ipurG
         rLU3zuHCMbhZ69u3oLRyUdWTGWAytmkmeuoJQ/pxbL3Gn0jSzUd0YRRaYKm9/Jds366l
         79eg==
X-Gm-Message-State: AC+VfDyjkEkEed++SiSADuYrVuvGHHf2PUBjz3hlveEjs88WwG1/w41A
	0IMUkbnyG4w+GONbzehPBikW2w==
X-Google-Smtp-Source: ACHHUZ4w5v555r5a47h8fcPCos9lMeBsunv8Hu1oUvXPAQm+qb6ALiRc0oXrG0SBcb2lupTKB4xVtw==
X-Received: by 2002:adf:e2d2:0:b0:30a:e479:66a2 with SMTP id d18-20020adfe2d2000000b0030ae47966a2mr11007108wrj.37.1686242347447;
        Thu, 08 Jun 2023 09:39:07 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id e13-20020adfef0d000000b0030aeb3731d0sm2038215wro.98.2023.06.08.09.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 09:39:07 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Thu, 08 Jun 2023 18:38:54 +0200
Subject: [PATCH net 12/14] selftests: mptcp: userspace pm: skip if 'ip'
 tool is unavailable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-12-20997a6fd841@tessares.net>
References: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-0-20997a6fd841@tessares.net>
In-Reply-To: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-0-20997a6fd841@tessares.net>
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Davide Caratti <dcaratti@redhat.com>, 
 Dmytro Shytyi <dmytro@shytyi.net>, Menglong Dong <imagedong@tencent.com>, 
 Geliang Tang <geliang.tang@suse.com>, 
 Kishen Maloor <kishen.maloor@intel.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Matthieu Baerts <matthieu.baerts@tessares.net>, stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=974;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=LgQePFMCSt72bRADkX0FG+ALuqpXJ1DkTpc7juUL6uE=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkggQaOPetE2lDIy1IfFY1CDe5VbXKJ63o3Gq1I
 uzizz8sM0iJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZIIEGgAKCRD2t4JPQmmg
 cx63EADsPoFYaIZvExp5hZTyExQrpDgNrCt284Hr4s/PMWfWJO5IhB6YBXDFrAH/2x6a+yeS9AM
 FeJ0RRhC3ATqR6M5D0zKgvWDDwn7zaxewmaIPzg8vEWBwL3It8pA62eIvUvPaMxa2Vw2edfDK7e
 zKakE5/9rrQI7Sw2T94n8ob2NPoqHX8GK2w7ZEJKjubDFCYjqMUf19S8d1TGSbwp9nQtxTmuFUR
 Evsolbryd5zzyvW9Lq710epCQr6ubnGsinRpRasAhDdypYxMqaGVRCIjiPcFqyxvoA+n0SsBwFv
 dlGqlJL0csZpGsM9mC4nMLyHE7qrH9aFthb6WT4WZAAD2EcxHpyxRGrgIrDwo5col8mt/cpP+Rv
 3Bl67nCJB7u3uZ1wxNTLAkn/Iy0wxzphM+OfprLFnuuwzgdOpGLw1DOoPTGBY2RUzG47qLgoeMK
 JXw0Euu6MY50IPJqrVDkcL+bWDPbH6nmnaFyLKRaqe+l3IqVeDa2lykiXbtPqM+rNE/D6JsoQg0
 BEglw9ycobAWVKiZylxQYyxR0wdqJQMxYTDOaoS9tcw6Fuoc6M7WzbqUG8z4rTHYNQwT2CscWQd
 96yohKQ65y0AG+oAZEu2Ay4BLu36bpJE9hlg2sE8SSu3EXW4AyNOD47tMF+dx70JS+sUQcwe+MK
 6gpbM2JvwkpJ78A==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When a required tool is missing, the return code 4 (SKIP) should be
returned instead of 1 (FAIL).

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 259a834fadda ("selftests: mptcp: functional tests for the userspace PM type")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 8092399d911f..192ab818f292 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -8,7 +8,7 @@ mptcp_lib_check_mptcp
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
 	echo "SKIP: Cannot not run test without ip tool"
-	exit 1
+	exit ${KSFT_SKIP}
 fi
 
 ANNOUNCED=6        # MPTCP_EVENT_ANNOUNCED

-- 
2.40.1


