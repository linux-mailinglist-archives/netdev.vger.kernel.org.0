Return-Path: <netdev+bounces-9273-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF7C1728583
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:41:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2154F1C2104F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F25156C5;
	Thu,  8 Jun 2023 16:39:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49CF19922
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:39:31 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355E42D48
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:39:10 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-30aef0499b6so619259f8f.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 09:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686242341; x=1688834341;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DG0t6hTRy1TiyueGnVsxEMjDQDrpL785hzWCnX9OzbM=;
        b=v9od5LLaYjGyBE9sXoa5jMv4GgSBHzi8qzhPbOPMblfJyEoT1Ntk4FeEnl/yQ7csMd
         tY74qfEBV8O9CBpbNnbHP0adFvE67AxXvEG3wZ8KM3A88BigiySiZSnZ/i9Wbroyx96M
         90kDbSTXVgYDcE2ZhZiq2/wUEYbjK44rRfAG1BlhKCAZL9dsuKAUlsF3wj0rTCh2W31R
         o7xcIJ6EQFbZT2XdJ6CwNaGnKstBh33/mWJ7bDOchCXqNZADtxC9C7T3POyMt7UKOJh3
         R1Nl6ctWeHQsieBAib879az3l9JmYTqx3dpcZ9gVXk7tYGYY2G5v89BW683wQJk0DM/0
         aLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686242341; x=1688834341;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DG0t6hTRy1TiyueGnVsxEMjDQDrpL785hzWCnX9OzbM=;
        b=RAbYSIzoWut01RItfjQZY0hi+yrvzXOzxFOJCfJFSjLyCEKjU86JN6i5ZsXu2yL+fo
         7NJbKIjJWAsc24Zzwq5CFvm1xtTy3r+0rrRvTj31FvkKyeNnLinV1RJNKObQt6S5liUd
         Q6UZc30d3kKwWRkzJ66bSxe7uyxQHmpU8xMG4Zsc/29VW+MMvyPpFjKgV4jA22Ca6tLo
         sigWGGZpgFlL5coJuAKofAFNBmG/cYbc10HGv11sVMdNa8gA5ybbiLA/zFwxtgwVzJX0
         175Sz17mtVmq5vt61MvY9jQUi82N1PHH9npyYKKux4GJktoLzqferWGEe8TJenyw18nA
         rHCw==
X-Gm-Message-State: AC+VfDyZgWOWJJtmLIV3wWajeAHt9c2KMmzGileNnlpfay37Cr5dqz9i
	NVwmX0gZBiaLtCBkpQlEmbaA8g==
X-Google-Smtp-Source: ACHHUZ7mNCDI+jt9sTgoc5QjI1No/0dP3dNBFY0c0TDn+0iU4pVklcn3ibo2AcRHK8NMbAhDrfXtiw==
X-Received: by 2002:a5d:5966:0:b0:304:6762:2490 with SMTP id e38-20020a5d5966000000b0030467622490mr7431282wri.3.1686242341257;
        Thu, 08 Jun 2023 09:39:01 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id e13-20020adfef0d000000b0030aeb3731d0sm2038215wro.98.2023.06.08.09.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 09:39:00 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Thu, 08 Jun 2023 18:38:49 +0200
Subject: [PATCH net 07/14] selftests: mptcp: pm nl: remove hardcoded
 default limits
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-7-20997a6fd841@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2377;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=zenPus60hgnkS6/g6C+PcTE8gwjvfHkXz30wSKvDTLw=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkggQaPUSkIYhlVuF6CCKRXpqcJjLtMtkvcUJ5V
 4mYflZuiw2JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZIIEGgAKCRD2t4JPQmmg
 c2BiD/0ZLPN/vt8nPU76WXsimATCWKM8DDK6lRKm1Br0xFin9kdDaH2gTz3MQYM/W8cGsbr6lv4
 9c6yOdwV/bVfJnJXR7SuSP3iTv6kvpTRePXHlNPfaglf777DQsow4GGEDM/fCojZiP00hcpHdZE
 62oDe/SuQcDQU20YjlF9PyR6h2CcJvoMKFVF2t6wYfK/z4o/+egdBBJ8MhezPR+RqAjzMyK2wIG
 uAwImEUPeY+fWAhWkzPmMRvXzXsTo12TzMU45wLgiNcafjeBaM40Wi4nZd1oWBrxt9FX6voUfea
 Ulpt9InGY1QIqLwl8XOnO8jLKrBum7eZxG3++D8z3BTh15eN7wQxTjJlu7xpuH5WcMui0/laK/v
 iFJV3cM4pNenTH+6NmYdgoTCikt+mz3v3pRldpgg/v/082VzpBH8GQHS5mW7DpZrvjbq6r61ggm
 b5h9yy7G6Afa/jgx0PHYXP0PF3nre6tp6UGyCitGBX+zhIT5PqAYHa/PAdKlsWk92Cijv7WVhVs
 vuDirSjYk96S4FzESnlMD1GZQt+MNiKSQg+w0GqFY39dQHVl1Vx/iMbdTmIiIssSALxjfN1gnhs
 IDOUdlSwQ2JSBehWux/iEH7bEvC/OI2cQyTMxj6zY+rVaTO6atrzPMm4VZciSvLQrV/eW+mONv3
 VY1lRgQTHDKGfLw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the checks of the default limits returned by the MPTCP
in-kernel path-manager. The default values have been modified by commit
72bcbc46a5c3 ("mptcp: increase default max additional subflows to 2").
Instead of comparing with hardcoded values, we can get the default one
and compare with them.

Note that if we expect to have the latest version, we continue to check
the hardcoded values to avoid unexpected behaviour changes.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: eedbc685321b ("selftests: add PM netlink functional tests")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_netlink.sh b/tools/testing/selftests/net/mptcp/pm_netlink.sh
index 32f7533e0919..664cafc60705 100755
--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -73,8 +73,12 @@ check()
 }
 
 check "ip netns exec $ns1 ./pm_nl_ctl dump" "" "defaults addr list"
-check "ip netns exec $ns1 ./pm_nl_ctl limits" "accept 0
+
+default_limits="$(ip netns exec $ns1 ./pm_nl_ctl limits)"
+if mptcp_lib_expect_all_features; then
+	check "ip netns exec $ns1 ./pm_nl_ctl limits" "accept 0
 subflows 2" "defaults limits"
+fi
 
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.1
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.2 flags subflow dev lo
@@ -121,12 +125,10 @@ ip netns exec $ns1 ./pm_nl_ctl flush
 check "ip netns exec $ns1 ./pm_nl_ctl dump" "" "flush addrs"
 
 ip netns exec $ns1 ./pm_nl_ctl limits 9 1
-check "ip netns exec $ns1 ./pm_nl_ctl limits" "accept 0
-subflows 2" "rcv addrs above hard limit"
+check "ip netns exec $ns1 ./pm_nl_ctl limits" "$default_limits" "rcv addrs above hard limit"
 
 ip netns exec $ns1 ./pm_nl_ctl limits 1 9
-check "ip netns exec $ns1 ./pm_nl_ctl limits" "accept 0
-subflows 2" "subflows above hard limit"
+check "ip netns exec $ns1 ./pm_nl_ctl limits" "$default_limits" "subflows above hard limit"
 
 ip netns exec $ns1 ./pm_nl_ctl limits 8 8
 check "ip netns exec $ns1 ./pm_nl_ctl limits" "accept 8

-- 
2.40.1


