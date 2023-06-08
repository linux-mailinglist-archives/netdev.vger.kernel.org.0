Return-Path: <netdev+bounces-9270-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2394E728574
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D052D2817D4
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC74317AC1;
	Thu,  8 Jun 2023 16:39:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7207318003
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:39:21 +0000 (UTC)
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB7F35A1
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:39:00 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-30b023b0068so675795f8f.0
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 09:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686242337; x=1688834337;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W8fna5vAfprlhMtgok8TsdPxk4+XnGn2xwviFFs33yA=;
        b=WjO95Uf8AXRZTgpmN0MrSemNy88XXAN9Yk9p2wn1WqhQZBDRPbXKGIoeCTflOlpzD7
         oTfas4tuqIXOJ/S7agipjh1KA1+nozfvMysP9Kc+MOCo34ut2xf5Maw7usiwaX204l+X
         BpxdZUX24N5i//2vIGpLjt381/3jf+ShzYWLto7pU00AldqM8QfXM8qQzpaO2zonnwL7
         J/93qagNO9dpeFFCaS9mSukB0oDjDbZZVsMPlWUAUY6ueyHM8VLrIKacf5E9fHkl1WJS
         cbzfRa45Tv21NEGemJEF0qAaJvVBf9M5W5Yl9Xnlw8vY63enauWem++arnmG+kOppux6
         Ey9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686242337; x=1688834337;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8fna5vAfprlhMtgok8TsdPxk4+XnGn2xwviFFs33yA=;
        b=k01F0OtgZBLK8apBRj2eOwO7FxwKqrCBZsFxmP2l6SXCC+TEtFhBhswOXpyY64/CH3
         e9p7u90boiNVhfXX7VfCIJwHUXhEZ/RAUYvrhRwCNsadAoaAkZ+CtrE20K85ohjhPXDf
         Qh9HGjRV6TMPOvUW5XqYwVomDmi1Mnrxwrbhxu25R495s5VvGZZ14D3EpVpIfHBGk6wu
         LQmA0JyTsMsMqrEj7EWrkjLutsS0tlkrVi6vlVgiEVHHeL6ys84TMdRUbAMLUoRmn5Nn
         dNOpSoNv7k3r5B9hiFecGMaxN2VTUjNgY4Kdtd/xsS5+I1/TnMQD5gw+sxRppuQzSrMC
         aEFw==
X-Gm-Message-State: AC+VfDwwj81iYKi7s3lJQi3yKldOeT3LUzrGfAVF06OtK8h+9jbcZSrW
	ytftP4GEv1zHYLZIxUATEfau6Q==
X-Google-Smtp-Source: ACHHUZ7qQMZsxyPNdRoFPT+JK7h8RzgnXGJX5TEj1DySMBO8nQYkOmQk40GIHbQG+y80B48uf6v17g==
X-Received: by 2002:adf:ee12:0:b0:2fe:e455:666c with SMTP id y18-20020adfee12000000b002fee455666cmr1957326wrn.33.1686242337238;
        Thu, 08 Jun 2023 09:38:57 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id e13-20020adfef0d000000b0030aeb3731d0sm2038215wro.98.2023.06.08.09.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 09:38:56 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Thu, 08 Jun 2023 18:38:46 +0200
Subject: [PATCH net 04/14] selftests: mptcp: connect: skip TFO tests if not
 supported
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-4-20997a6fd841@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1341;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=ungmKl+jPgBUIELXD/hdgwcdNa+5IIbuKeJXRHeksWg=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkggQZgRvNNN5VdNCvqhNddhCcd54OxjWj6abwK
 eeFhezbl4CJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZIIEGQAKCRD2t4JPQmmg
 c3p5D/45/+1kAY+ShxGYgWdaJUzHapthY6xFvYQGSwqDpGdNrIaww+42fkLBQtNgpHmdh709Nas
 5GM4KPTO3a3QBwl+UWoQd9+3ordpb6kksvUtX50aP4F7k2nl8JllIRTS0rDO7m+egbU4JN1M7n0
 6gWPUcw4K2kBvhDpVcEgrmioFGI6O+oj0dBMoOIh92jo5kBXvS7REhtQisFF11B5i3y00QXz1WB
 d3ZBxpiw5NOHfRasVVsTFUorqgswFOWRm5zQEMMtj3a23aTlBLtPHfajDjwh2ITNco++Lt8cy2f
 ZIQ1OWtMz/HFVEdabI8Fhvgfq+iSH0roXEnclRnnyQSiL+MtDeflxenuGJyiWBgcn2S8FqACUEu
 ai8I+3jCE7k+9w352KzzGaAYNlx1li9kRqqll25Mdm9iRW8cxlmhAMMQLdpq7gsskcU9s0Fc8Qu
 wiYB9AuotY7aR+uJkUnLTMiGA6T8Zu+7e2D+ZXY4xODyRy6WM8cGD+sP5Z8OGtq+oxnwaRGxxDD
 cY/41eKJTrkPb7mpfWk+z606pENgZ7WhfzC35mVA3LfO3VPlG8awrhRBMLlXWcuSNWwnTodm0+a
 dcnB9l1eEUCGskXpmxNSqJdd9nqIuz0fQGFsBadsWLMgHpkgvH3cw778jHcBwFFXm1wmuk6FxWe
 AE/eqCuJHBlXlsw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the support of TCP_FASTOPEN socket option with MPTCP
connections introduced by commit 4ffb0a02346c ("mptcp: add TCP_FASTOPEN
sock option").

It is possible to look for "mptcp_fastopen_" in kallsyms to know if the
feature is supported or not.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: ca7ae8916043 ("selftests: mptcp: mptfo Initiator/Listener")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 895114fb6832..773dd770a567 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -777,6 +777,11 @@ run_tests_peekmode()
 
 run_tests_mptfo()
 {
+	if ! mptcp_lib_kallsyms_has "mptcp_fastopen_"; then
+		echo "INFO: TFO not supported by the kernel: SKIP"
+		return
+	fi
+
 	echo "INFO: with MPTFO start"
 	ip netns exec "$ns1" sysctl -q net.ipv4.tcp_fastopen=2
 	ip netns exec "$ns2" sysctl -q net.ipv4.tcp_fastopen=1

-- 
2.40.1


