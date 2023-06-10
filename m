Return-Path: <netdev+bounces-9824-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE1E72AD17
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:16:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC416281691
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 16:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57EBA22D42;
	Sat, 10 Jun 2023 16:12:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A871D2C3
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 16:12:03 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A24A3C01
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:57 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-307d20548adso1919551f8f.0
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686413516; x=1689005516;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pEy5+4Z5L1HB0pmwUKUXQPC9ewbB/0SPfNFYVuvGdPw=;
        b=0W8hhF+6XrYbuQNpSDcEArGfHrOkM/8mIwfX2MkDdFnxrXWJaqGJ4mZKQcbV+T1O7M
         GV8MX0niqXImR6GOHoP+niODKugNR+EEk/BfhlJ63fKrFiju5/A5s0kztTyZS0vsxmMo
         91wbNd4HkbthW4CZEIEXzY+sCD0tHOH0aXCSMayIoorvgz/LHrlasPcO5srFLugrVHVc
         REEGtiGQXJtKP2VGtKs0z9NGQ0ZMY8wKpUZEVgX3JZzsdtcwi7CSL6SKIGt1ZTEMCVFX
         XHlumiUgSMcRUmkOnKzHAQPJU2EPN+nkE+nzpu2RMSR6wfTSA8yIWsD1WqqXvLWue/cO
         dpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686413516; x=1689005516;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pEy5+4Z5L1HB0pmwUKUXQPC9ewbB/0SPfNFYVuvGdPw=;
        b=IRH947oJVkwm8q67afuB+ET1WteuIq6UG7hw8IFWf17mEISkpvrr+KMzrnqkQWaVUh
         gKyc3lg4uA3HjETkhzNdJmoe8MG1xujti2qUkt+U9KBCCLxRrBUjIKbOdrEYy8uPbxjD
         PJcYhxBWXx8FEoKzPTkX1CrIkkiHQ/Xx46MP6p8fr9+U8FyD9bLfv/Gm/a3A2MMHqO3D
         Cakw3eZ5qt3FmyO1JxiglSyd/1G+418Jg4JzoJL1IhxqRzvEhsDx/eiNfgR4II17mJlq
         PLehC+cC9HwbeVHdpVmkDS5/7lEOTemg7OfDbrPRY1RSvtIVs2YFXKtdWyggxi5TTxf+
         C12g==
X-Gm-Message-State: AC+VfDwqwXW6a7XK0HwKxTOaGRwK3D5QYUoH0wKJrTihpD+WZUtbCDfQ
	HUR6kKgdSyYITcbFtJ1YXCo1kQ==
X-Google-Smtp-Source: ACHHUZ5WYhkTgJhNvHTUJovpI++RcbHnCniAGEv3L2U8c6RIDOBzfTzgBZnmZH8CCuR9FeMxZs01ng==
X-Received: by 2002:adf:fd46:0:b0:30d:981d:a049 with SMTP id h6-20020adffd46000000b0030d981da049mr1675990wrs.4.1686413516176;
        Sat, 10 Jun 2023 09:11:56 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id u9-20020a5d4349000000b003079c402762sm7431145wrr.19.2023.06.10.09.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 09:11:55 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sat, 10 Jun 2023 18:11:43 +0200
Subject: [PATCH net 08/17] selftests: mptcp: join: support RM_ADDR for used
 endpoints or not
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-8-2896fe2ee8a3@tessares.net>
References: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-0-2896fe2ee8a3@tessares.net>
In-Reply-To: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-0-2896fe2ee8a3@tessares.net>
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>, 
 Davide Caratti <dcaratti@redhat.com>, Christoph Paasch <cpaasch@apple.com>, 
 Geliang Tang <geliangtang@gmail.com>, Geliang Tang <geliang.tang@suse.com>
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 Matthieu Baerts <matthieu.baerts@tessares.net>, stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1704;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=ENX6g4OzQPKQMfCdmU6IeEgbosGhUnGqQUwM04UZ8GA=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkhKC+AgqZJ5qaGkZLJAqoIy91nD7xkXapvrYrx
 tlPCIeMUVWJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZISgvgAKCRD2t4JPQmmg
 c/ElD/9TTVtf3G7Q9uaewb/SFGltJ+aQpRjfi/BfEi6IBnntRoYoyU0bu/t/Zcs/CHpXDzS2jQr
 l2Emt6xkgVX/j4diOEN1/GvbhpbJSUlEII6wbpAjo29YUDaRxiZHI+LEV2mVp3tueho3A8k5E4+
 6wo0kc0XYORc3jQmxjwVoBzqEa+rGpFUJQFor0Hf73mFqS3hJmEptSLrwxjzt1tvairTqFNc5yq
 lW24S7Vv3nvvuiHmqglCfRKe0f69GmAszzdmWdwwGftL/AAAXppePGUJ9/il2oubHbM3pTIZtuS
 efgCkxnMAP4AR9SSivkpQKLLwBFVJZ5Bi1SBG4ZPJEznZhtp9rcYqgjonLIeU4oPGQKgpQceWNl
 D4lBRJPEhVpZbJ2ztMOKPLCTrwIykIwz7UxeJ7dVZEFzVzW4Wy2bEN5Pcu6kndxKciIXjxIysIq
 +KX6lILW5wi2GW74wR5rtldDnZVajgnwe8a48Fq+A1wxCTtfMNQdqraGtLg+qtutq+jf6R72+6W
 frBasSJEz6ulBrcaBQLbtVcRU7Xd8JV7CnHsOaPKe4np8V7+LDXWPNIs+mcqJou/L3kpcfXzz87
 xxSmZed8v6q/duNknVtlhFxBlSPcybZ0Db4+mfRDLdLLQkvEg6QCFV/dmavsPOWo0rIYFIs+Qzg
 Rof2VIAas5uJUpg==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

At some points, a new feature caused internal behaviour changes we are
verifying in the selftests, see the Fixes tag below. It was not a UAPI
change but because in these selftests, we check some internal
behaviours, it is normal we have to adapt them from time to time after
having added some features.

It looks like there is no external sign we can use to predict the
expected behaviour. Instead of accepting different behaviours and thus
not really checking for the expected behaviour, we are looking here for
a specific kernel version. That's not ideal but it looks better than
removing the test because it cannot support older kernel versions.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 6fa0174a7c86 ("mptcp: more careful RM_ADDR generation")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index cfd43037c6d5..3d4f22fe8f8c 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2394,7 +2394,12 @@ remove_tests()
 		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
 		chk_join_nr 3 3 3
-		chk_rm_nr 0 3 simult
+
+		if mptcp_lib_kversion_ge 5.18; then
+			chk_rm_nr 0 3 simult
+		else
+			chk_rm_nr 3 3
+		fi
 	fi
 
 	# addresses flush

-- 
2.40.1


