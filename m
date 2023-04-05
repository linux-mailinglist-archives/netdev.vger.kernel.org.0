Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5147F6D76E3
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbjDEI30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237146AbjDEI3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:29:24 -0400
Received: from mail-ed1-x561.google.com (mail-ed1-x561.google.com [IPv6:2a00:1450:4864:20::561])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695183596
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 01:29:22 -0700 (PDT)
Received: by mail-ed1-x561.google.com with SMTP id eg48so139017246edb.13
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 01:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680683361;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dubmJZzj9ewK7VdPsSH0OrrerYhQltiRGNAZ5sYhsdE=;
        b=fap3neKkM4RZlmbaswN8wfO5OfaFYwyq7u3U9SC/yss7GFyBfcLf3QWly2JYJYQYya
         EwGZTWN5O/gi1o2EIiEB/gn9gXStcw1wG1aHC4S3bYSORuxU85r79O0lSkfUePklYSr0
         N/VTtD8Mtu4te5BqaDTL9zHEsvM1O2mLPwnSo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680683361;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dubmJZzj9ewK7VdPsSH0OrrerYhQltiRGNAZ5sYhsdE=;
        b=2pmh5BZ4H02sqQaZ0ZZCRU8Y9mLmnah5hVIC103MvPBvDffgKeb4cw/bVsjJh1ObcA
         bE5aBowcjMEWEdFrk8N538GfzB1niutbuAVnYutwdKdl5M4abutBAdsxwcSKN34kR3O5
         4F+yt2aRZIKQ7r/R66FAbFzxEl+pD6Ut18ZmYGSNp+KwWZuAnTiumIICLb7CxqblM7X8
         vz99rpXU+lZ7bwsCxhI+eoTbxn2jlxqy7Lv6phuZUWJidwvqrD89pnKiPzW/gVH8zEf4
         cjpTQ7+LglzUsX157F/+xaWRMVGRZY8/3DldfVqg8WZaPuvbHxD6jo/uqZcYotRorgrE
         EHVQ==
X-Gm-Message-State: AAQBX9fQFQH8xrDSGoAW8tkaSXbBegyYi/ngGJ4Nns+R1JDdX4MG9M8Q
        6cvSMLp10PynZojAzNGKxMZHfEdSdSW6o5TbpRD/l6S2bTd0
X-Google-Smtp-Source: AKy350Z4cm+MiMZg4tJ4XDYwi4+Uu9E47u1H18ZU8iKT15a3z615sLf7uPFlUQi/STJR3hpPLB6Dq/IGJ4+T
X-Received: by 2002:a17:906:e204:b0:947:5acb:920c with SMTP id gf4-20020a170906e20400b009475acb920cmr1932253ejb.34.1680683360731;
        Wed, 05 Apr 2023 01:29:20 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id i25-20020a17090685d900b00944010e0472sm3723264ejy.236.2023.04.05.01.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 01:29:20 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Weqaar Janjua <weqaar.janjua@gmail.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] selftests: xsk: Disable IPv6 on VETH1
Date:   Wed,  5 Apr 2023 10:29:04 +0200
Message-Id: <20230405082905.6303-1-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change fixes flakiness in the BIDIRECTIONAL test:

    # [is_pkt_valid] expected length [60], got length [90]
    not ok 1 FAIL: SKB BUSY-POLL BIDIRECTIONAL

When IPv6 is enabled, the interface will periodically send MLDv1 and
MLDv2 packets. These packets can cause the BIDIRECTIONAL test to fail
since it uses VETH0 for RX.

For other tests, this was not a problem since they only receive on VETH1
and IPv6 was already disabled on VETH0.

Fixes: a89052572ebb ("selftests/bpf: Xsk selftests framework")
Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 tools/testing/selftests/bpf/test_xsk.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index b077cf58f825..377fb157a57c 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -116,6 +116,7 @@ setup_vethPairs() {
 	ip link add ${VETH0} numtxqueues 4 numrxqueues 4 type veth peer name ${VETH1} numtxqueues 4 numrxqueues 4
 	if [ -f /proc/net/if_inet6 ]; then
 		echo 1 > /proc/sys/net/ipv6/conf/${VETH0}/disable_ipv6
+		echo 1 > /proc/sys/net/ipv6/conf/${VETH1}/disable_ipv6
 	fi
 	if [[ $verbose -eq 1 ]]; then
 	        echo "setting up ${VETH1}"
-- 
2.39.2

