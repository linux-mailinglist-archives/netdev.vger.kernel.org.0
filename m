Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6712A521463
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241324AbiEJMAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241323AbiEJMAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:00:47 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B66D5046D;
        Tue, 10 May 2022 04:56:50 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id b19so23453640wrh.11;
        Tue, 10 May 2022 04:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=37vZ7zO8zNdxOSa6KCVBXjvvcDFhp9HB1h2jCDa15Po=;
        b=VFoz9RJE2gv9AKldVbsAPVZs1nnDxSD9LIWHiNWudqDgWbyh7TqXVcB/FZaG+qjrUp
         MM8NVmCO26MbIjc7vKQ2Fga3ODzW6IoRt++iTQq7p1UN1LkZAx3tn6gXfOnw+l1GepAw
         qttLkAEPQFRIgjXMvhb5gVGc5b2TAxNx5Vd/CxCu+9aC1FR4x0XqMowlsgtt/UD1mY2u
         YWIZ+cP9K+1dCdZQJJNWbS05aISXCEq4V3pLmfpzukxh8fHqXzKVvL9SJgqF0WV9amhb
         OOOfyBEq4uXsywAvTlHgbTNhBezOCUODB8aDi09shpQMLi5PUSNin+8h8AYEEoiaPNXr
         5wsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=37vZ7zO8zNdxOSa6KCVBXjvvcDFhp9HB1h2jCDa15Po=;
        b=5FtRx5JDM5QBmlrAPEaH8IQQPgLOOwQZ6RHdKVVRpvr/qLgmi0w+FUel0qnA2YViYv
         o5igTTvdMtk7BYuQTqrS78wSFpjMIDYnq7FGHrK8DotIiiXyKY/00qbOzTo8qN41ZCCI
         DboV3nBK+ZT4eGsoF8JcYMyXzlqiIFrxrtrosuDmrAB75P9FXDk5fX/vknTzmMI0TOFj
         HbmoOxNoAEz0UEl5hVi8DW9yHqSt/zOIc0pyG1MC+IWCoEND/QjUeqonfQbs9Sv0ZBy4
         XSTfJV3CnjztwCW2oILIH928E+Pk6jZZG82YkQKCcH2p8MsIM+xZ29kbvTVp9AbjQqtO
         aPvA==
X-Gm-Message-State: AOAM531c6Rab0vrZ3S9iyB+h+5eyJ4+Dtshcg/EH2S3vJwS+o+aGLCxJ
        vPDPrZTsehOy52T7iMZYKm0=
X-Google-Smtp-Source: ABdhPJxyn4eXpyxv+HpzqfwbDHeAK9TIkRH81edFjZ0udrkAmxBfZWOl+bMysyPYTI+q+hgSLBxo4Q==
X-Received: by 2002:adf:f406:0:b0:20a:ded8:6803 with SMTP id g6-20020adff406000000b0020aded86803mr18312601wro.232.1652183809075;
        Tue, 10 May 2022 04:56:49 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id e25-20020a05600c4b9900b003942a244f51sm2267797wmp.42.2022.05.10.04.56.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 04:56:48 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/9] selftests: xsk: cleanup bash scripts
Date:   Tue, 10 May 2022 13:55:56 +0200
Message-Id: <20220510115604.8717-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220510115604.8717-1-magnus.karlsson@gmail.com>
References: <20220510115604.8717-1-magnus.karlsson@gmail.com>
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

Remove the spec-file that is not used any longer from the shell
scripts. Also remove an unused option.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh    |  8 +-------
 tools/testing/selftests/bpf/xsk_prereqs.sh | 11 -----------
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index cd7bf32e6a17..2bd12c16fbb7 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -43,7 +43,6 @@
 #   ** veth<xxxx> in root namespace
 #   ** veth<yyyy> in af_xdp<xxxx> namespace
 #   ** namespace af_xdp<xxxx>
-#   * create a spec file veth.spec that includes this run-time configuration
 #   *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
 #       conflict with any existing interface
 #   * tests the veth and xsk layers of the topology
@@ -77,7 +76,7 @@
 
 . xsk_prereqs.sh
 
-while getopts "cvD" flag
+while getopts "vD" flag
 do
 	case "${flag}" in
 		v) verbose=1;;
@@ -130,12 +129,7 @@ if [ $retval -ne 0 ]; then
 	exit $retval
 fi
 
-echo "${VETH0}:${VETH1},${NS1}" > ${SPECFILE}
-
-validate_veth_spec_file
-
 if [[ $verbose -eq 1 ]]; then
-        echo "Spec file created: ${SPECFILE}"
 	VERBOSE_ARG="-v"
 fi
 
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index bf29d2549bee..7606d59b06bd 100755
--- a/tools/testing/selftests/bpf/xsk_prereqs.sh
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -8,7 +8,6 @@ ksft_xfail=2
 ksft_xpass=3
 ksft_skip=4
 
-SPECFILE=veth.spec
 XSKOBJ=xdpxceiver
 
 validate_root_exec()
@@ -34,13 +33,6 @@ validate_veth_support()
 	fi
 }
 
-validate_veth_spec_file()
-{
-	if [ ! -f ${SPECFILE} ]; then
-		test_exit $ksft_skip 1
-	fi
-}
-
 test_status()
 {
 	statusval=$1
@@ -74,9 +66,6 @@ clear_configs()
 	#veth node inside NS won't get removed so we explicitly remove it
 	[ $(ip link show $1 &>/dev/null; echo $?;) == 0 ] &&
 		{ ip link del $1; }
-	if [ -f ${SPECFILE} ]; then
-		rm -f ${SPECFILE}
-	fi
 }
 
 cleanup_exit()
-- 
2.34.1

