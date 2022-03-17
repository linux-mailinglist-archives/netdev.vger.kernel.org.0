Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49324DC009
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 08:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiCQHTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 03:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCQHTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 03:19:33 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F185E7B101
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 00:18:16 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id bx5so4137487pjb.3
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 00:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lwYCvbdSvsKQVfbw5AAHi1y1GvZSShokPM29lP8j3XE=;
        b=Q/9L+NLavb/u1Epy0Y0scM0b5Ajwk9isTPN0uiuqJZggfrLIFqFw1YIExDeTBE3oEe
         oLyjF38/H7bnFsygDNc2+PgcGPc6BCpg7we3bBihzcw4qpuQu3ugk67g9TFntddeesZi
         WW6eRfHTgzbp9MYnmBiwAmHBGxOZq+BiPXg0QwQ751HGFLuf8d7nzfq9OQii5HRRGlLB
         ygcGxbDtxjmijQ/HnY6ILXDreeHNBn/NiYxUsT62MKj8vSaucjwy7N5xj+jvznDvorxR
         4eJ+PZtgNR6y7Lsd4E/g1XayOYe3RzNfy+iZsaRY1WS3oX1crrVvywJYLcU9PyhkGVGX
         NNgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lwYCvbdSvsKQVfbw5AAHi1y1GvZSShokPM29lP8j3XE=;
        b=NxG87F+xQvDWZxlB72b6Oa78uqlabT+LPDwXCsy2xsLZS6KhDjZb33atZye+QDMQIU
         N0ZKq7/8sNAL3AF0+tlXmypoAtFwNAtALhcYZr4A255smqtsF4INfAP0JmfqRnvdiPdo
         2AsFAc73Jhm52rdegQ2viUSes9tpNLy1DiwCTH/bf6dNfQZK9Yo+l5QseLl3QynM/LOH
         WMwGQpf7K01uBsYUQRzuCbDP9pwKrYMSIVNHsXKgv+Evh5LITTGV6bMtBbWsJnrGTu5P
         bJ7IGnQIYa5D8I6yD2B6F5lymZKDWamMlbpMkLKvz7tUi0dAdTIcMYPudDDHkcOR+PxS
         FTzg==
X-Gm-Message-State: AOAM53394ZeWGH1MT2bnxj+tSiKR+gqCe7s6A280UJETGbM8HPxVatS5
        b07eLDE1p5JZhV2ywFdWgVk3CIs7BUs=
X-Google-Smtp-Source: ABdhPJzLqO1VUecqEXX4rnzwm5inC527JiUKcepaOxyadcs+9GdFDuWzAwW6w/RWHE1eEncV5fiw9w==
X-Received: by 2002:a17:902:d643:b0:153:97c3:c8e5 with SMTP id y3-20020a170902d64300b0015397c3c8e5mr3672929plh.76.1647501496213;
        Thu, 17 Mar 2022 00:18:16 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e11-20020a63e00b000000b0037341d979b8sm4519366pgh.94.2022.03.17.00.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 00:18:15 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sean Young <sean@mess.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf] selftests/bpf: exit with error code if test failed
Date:   Thu, 17 Mar 2022 15:18:05 +0800
Message-Id: <20220317071805.43121-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
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

The test_lirc_mode2.sh test exit with 0 even test failed. Fix it by
exiting with an error code.

Fixes: 6bdd533cee9a ("bpf: add selftest for lirc_mode2 type program")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/test_lirc_mode2.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_lirc_mode2.sh b/tools/testing/selftests/bpf/test_lirc_mode2.sh
index ec4e15948e40..420dc86362f5 100755
--- a/tools/testing/selftests/bpf/test_lirc_mode2.sh
+++ b/tools/testing/selftests/bpf/test_lirc_mode2.sh
@@ -36,3 +36,5 @@ then
 		echo -e ${GREEN}"PASS: $TYPE"${NC}
 	fi
 fi
+
+exit $ret
-- 
2.35.1

