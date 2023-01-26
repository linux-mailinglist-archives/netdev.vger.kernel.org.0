Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B36A67D23B
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjAZQ5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjAZQ5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:57:09 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB564689
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:57:08 -0800 (PST)
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 935543F20B
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1674752226;
        bh=AqdG7g/ZZSZ4pNA8kNsOLtm4cZ2nj059acclO2QHloQ=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=QkAh6RWEMzfOrZfJWby3xNyO6F3aY1oLyODxwYvrhHAoAZxnFrSK8GnB7GLH7HvTI
         N3pVlW+1NqdaL4Dt9LEIjXPdA1sccy4Mfk8O5hzYiNtfgIg4T1QEgcwbuh92P2a9qI
         TbFLBHlHxl25Mjr3Vfl0JDt5JMxeV454vZ5wWIK/2qWwNBXGmRJWTVOd5ZfkT7TGjD
         Cw4SbUr42biWr8R7D6sk4hFXMlJ6u8zsVB8bwmR96WR2UK45tE0HTBfav9rpV6BokG
         mpQyvqR79wrZ/Rz/+YyMFnl7aJChoxm8VYcGDszGSqQYUI2VfcaHAmWoEwl2MkumDD
         eONKtBp+uJHSw==
Received: by mail-wr1-f71.google.com with SMTP id l8-20020adfc788000000b002bdfe72089cso453599wrg.21
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:57:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AqdG7g/ZZSZ4pNA8kNsOLtm4cZ2nj059acclO2QHloQ=;
        b=3HFGRdeHC3tNEmejkPXWLqJoOSBrTbcf5WVg44m509pDCjpuVu8ALq+pa1npLp691/
         mFYMPoUrqaCKrwMu8Y7cYabQ1mnJznr/hQWVhpBmjAKCEmOKKvk+EnkWLKWlxtZiIY1M
         iXaU+FYJoxT+WlQ1DfxD6IHnVrjF8YMsfpttvLq3AvmvUXcFLz7gCgnvGqzrETNGHSMs
         vqIE4kPLDOL/a9C2IwE+G5RiQl7Li+kr35QT7JDmOQs4Ln1lmS7TH2TariY3EJeWO2XI
         VVoX7sq4ITLqQJtT5jEqSWEbwndL3xedL+2KrjyhJdqZjAYa97owBGvFxWdsdM7YUVsX
         /QDg==
X-Gm-Message-State: AO0yUKXCJ43iDFmDBUtQfsi1oMZcLs8y62JbsiUjWN2eJOgL/m9rqU8h
        8GFxd35L6umnCyYAxqn8+OniDSvDKDCwa21+z+fZPdCEx/aAwhhzk+yIEwGpRPDuP0NeemESEzn
        XMypG4tiNIk+/ORH/5Xtj73A39X0Zf3NkxA==
X-Received: by 2002:a5d:4578:0:b0:2bf:c725:85 with SMTP id a24-20020a5d4578000000b002bfc7250085mr2088192wrc.12.1674752226310;
        Thu, 26 Jan 2023 08:57:06 -0800 (PST)
X-Google-Smtp-Source: AK7set+6H2kfXMT7ftWtKu40YIJWufbyLiNwAPLxiuN+FJ6q9L1RwkmEUjFPqgtZSaO3tmoiBUHB5w==
X-Received: by 2002:a5d:4578:0:b0:2bf:c725:85 with SMTP id a24-20020a5d4578000000b002bfc7250085mr2088187wrc.12.1674752226168;
        Thu, 26 Jan 2023 08:57:06 -0800 (PST)
Received: from qwirkle.internal ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id n1-20020a5d6b81000000b002bdc39849d1sm1701946wrx.44.2023.01.26.08.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 08:57:05 -0800 (PST)
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Andrei Gherzan <andrei.gherzan@canonical.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftest: net: Improve IPV6_TCLASS/IPV6_HOPLIMIT tests apparmor compatibility
Date:   Thu, 26 Jan 2023 16:55:48 +0000
Message-Id: <20230126165548.230453-1-andrei.gherzan@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"tcpdump" is used to capture traffic in these tests while using a random,
temporary and not suffixed file for it. This can interfere with apparmor
configuration where the tool is only allowed to read from files with
'known' extensions.

The MINE type application/vnd.tcpdump.pcap was registered with IANA for
pcap files and .pcap is the extension that is both most common but also
aligned with standard apparmor configurations. See TCPDUMP(8) for more
details.

This improves compatibility with standard apparmor configurations by
using ".pcap" as the file extension for the tests' temporary files.

Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
---
 tools/testing/selftests/net/cmsg_ipv6.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/cmsg_ipv6.sh b/tools/testing/selftests/net/cmsg_ipv6.sh
index 2d89cb0ad288..330d0b1ceced 100755
--- a/tools/testing/selftests/net/cmsg_ipv6.sh
+++ b/tools/testing/selftests/net/cmsg_ipv6.sh
@@ -6,7 +6,7 @@ ksft_skip=4
 NS=ns
 IP6=2001:db8:1::1/64
 TGT6=2001:db8:1::2
-TMPF=`mktemp`
+TMPF=$(mktemp --suffix ".pcap")
 
 cleanup()
 {
-- 
2.34.1

