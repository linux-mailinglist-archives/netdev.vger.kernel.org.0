Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213AC6D4417
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbjDCMFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjDCMFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:05:14 -0400
Received: from mail-lj1-x263.google.com (mail-lj1-x263.google.com [IPv6:2a00:1450:4864:20::263])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD95199F
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:04:59 -0700 (PDT)
Received: by mail-lj1-x263.google.com with SMTP id q14so30080362ljm.11
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 05:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680523498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dubmJZzj9ewK7VdPsSH0OrrerYhQltiRGNAZ5sYhsdE=;
        b=owWYS1VVibUABjXX7VSbtvRh0XtK1zmGJqqs+aa0pqCH5H4x0JQhsXiwVyNu+HHeyY
         37mKtGwGmRcsh6ob2/NSrbFsxSqlE2ZztPtJJ869q7Zq07tIFXnzdIv7YbJ2ZKoCHlmw
         e88iSnpzMFdgVnavEgGXPliO2xm0td647Oo5Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680523498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dubmJZzj9ewK7VdPsSH0OrrerYhQltiRGNAZ5sYhsdE=;
        b=RgxRwKsft7pmwbdk36ZzU6mn7R+YakZS/7DmBlX/SS6viAafQEze5NtV/NC5qpKGOV
         31sYmfvb+u7ZOHq36SXLyrQECRVAyDrAfLRDDxi/m/piynva7EaZ7PXs4sH6bQwVzGj9
         9MxQLG1KGAdJVGuekrIQZen/ZFLA62AtiNsIdk8mzEAe2cIsvlKfUW0QCH2sMrP0PMKl
         94h9s8Cl5EhFwcj76lY7DkPgml0IrbNAm6TtGikMUtOPvCvi+mTgxOgz+uOW7Wj3hJoN
         +HJ4DlTp5zdbtshKdRbBN7SRDA4PTI2pCFJhvGUJnfvLrxKNg2tEVW0tdAGU4A3gtsu5
         eiLg==
X-Gm-Message-State: AAQBX9eTFSK88I5NuleFxrPtHWCtOyEf/Ke1u6ZeTzfUqc12lPOE8kJy
        G9ImBgrwS4jtK0JRt52pgo9HHBid5sXhFRVp0TDbGCfji6Pw
X-Google-Smtp-Source: AKy350YerD1mBS1N0DhMKmHhnV36wHp/bArUw8WNCwFwDem7NnjRkJ70Xq8ME/XUvVF7/+TWaOidByobHMw/
X-Received: by 2002:a2e:8786:0:b0:2a6:389f:d0d0 with SMTP id n6-20020a2e8786000000b002a6389fd0d0mr653005lji.37.1680523498077;
        Mon, 03 Apr 2023 05:04:58 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id bg27-20020a05651c0b9b00b002905c01ea6dsm2299495ljb.31.2023.04.03.05.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 05:04:58 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Weqaar Janjua <weqaar.janjua@gmail.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf] selftests: xsk: Disable IPv6 on VETH1
Date:   Mon,  3 Apr 2023 14:04:51 +0200
Message-Id: <20230403120451.31041-1-kal.conley@dectris.com>
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

