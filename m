Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19F04D199F
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347100AbiCHNwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240491AbiCHNwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:52:41 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B3539829
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 05:51:45 -0800 (PST)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E746E3F5F1
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 13:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646747502;
        bh=gfyiehsHSCfxlKgNkCwVdg7pcAcR1+WSTjtuQee0hjc=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=CBEJzHxUgr+Qw0BD/FZ/GCN6XoBt1JE/0ywZc4gf2wXJpNXOq6yi2NhHFFBU1/+HB
         6RgJVne8zfY2wO1YsixXcVPFkQp4jZPZ3YQtFHlYFgcqFAcv/jn57EArlh/ZXYYc0E
         oJJVvygotOsXkwPCxpIhiCYwN+BO8leEmRy53H2uPg1siwL/hSZZkXgZGe52sK6TvK
         7EvN5yJoanW9mFXdtp/MBr3IPgggnhZXZ3jo8BMk/LHGuflt8OD2cdzRPrNXxJyFmF
         SzQOjO3Gg735VT2AMMpv6XoVGuHFsZQErp1XLtp0RbsBRpVqc9p1sBO3E57ndITUH4
         veqjWod+WdF8w==
Received: by mail-ed1-f70.google.com with SMTP id o20-20020aa7dd54000000b00413bc19ad08so10652287edw.7
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 05:51:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gfyiehsHSCfxlKgNkCwVdg7pcAcR1+WSTjtuQee0hjc=;
        b=LnCIiiv5326kFDL95iXHjBDP4l257YQNONcTWDmExfm86iRth9DPbUwQyZtCZkkcfU
         NtFvxthxzgs8VkOEK2eugKO6fgT0i7zEJCcTwD6d3HRjBmmjROhcV7nJKBKklMJhmtMO
         2pAPU0LOOrASXKZ5URAuECkcm+37OlrILrKm972tn9TQHqUWLDrhoUzJaKg2E0IXqcvg
         EmPuSTRImPkiMia91R9lAKytIiph1+wH5XY5/mWGoIbe3tUy9kRQ9QSeXw9NuqCGRu1K
         ASnqIfugXnvPOdQTfxjLUr7x1W2/kGA+zh2ZGEzghMShvntH3e7ot8C2QW5A2JsxXW//
         I4ig==
X-Gm-Message-State: AOAM532EwcD4QHU1rTecmuYJO31dHCD+wVLGPQ8dyqGh19HoyLXSp8tF
        nfmscp6m8tfI+NrI1KP3FqXEV6KXcNRdxJKeaP7qso8W4l1YikBdsStGgGcFuY027K7ZUqLuUt6
        Efp726vxXPaFgEIGdGBEaISeHwbDqo9uRcg==
X-Received: by 2002:a17:906:2b93:b0:6cf:bb48:5a80 with SMTP id m19-20020a1709062b9300b006cfbb485a80mr12934381ejg.681.1646747502549;
        Tue, 08 Mar 2022 05:51:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysAvtt7THWDP/7AQq9m26HPhDMKhrOPlwL6m0Q4Ozl6W8r2lgyPin1uXHPmX+Ti1qYgfKN0w==
X-Received: by 2002:a17:906:2b93:b0:6cf:bb48:5a80 with SMTP id m19-20020a1709062b9300b006cfbb485a80mr12934365ejg.681.1646747502267;
        Tue, 08 Mar 2022 05:51:42 -0800 (PST)
Received: from localhost.localdomain (p5087f509.dip0.t-ipconnect.de. [80.135.245.9])
        by smtp.gmail.com with ESMTPSA id b15-20020a50cccf000000b0040f74c6abedsm7606163edj.77.2022.03.08.05.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:51:41 -0800 (PST)
From:   Kleber Sacilotto de Souza <kleber.souza@canonical.com>
To:     kuba@kernel.org, davem@davemloft.net, shuah@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH] net: netdevsim: fix byte order on ipsec debugfs file
Date:   Tue,  8 Mar 2022 14:51:06 +0100
Message-Id: <20220308135106.890270-1-kleber.souza@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding a new xfrm state, the data provided via struct xfrm_state
is stored in network byte order. This needs to be taken into
consideration when exporting the SAs data to userspace via debugfs,
otherwise the content will depend on the system endianness. Fix this by
converting all multi-byte fields from network to host order.

Also fix the selftest script which was expecting the data as exported by
a little-endian system, which was inverted.

Fixes: 7699353da875 ("netdevsim: add ipsec offload testing")
Fixes: 2766a11161cc ("selftests: rtnetlink: add ipsec offload API test")
Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>
---
 drivers/net/netdevsim/ipsec.c            | 13 +++++++------
 tools/testing/selftests/net/rtnetlink.sh | 10 +++++-----
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index b80ed2ffd45e..03fb8b56edc4 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -41,16 +41,17 @@ static ssize_t nsim_dbg_netdev_ops_read(struct file *filp,
 
 		p += scnprintf(p, bufsize - (p - buf),
 			       "sa[%i] %cx ipaddr=0x%08x %08x %08x %08x\n",
-			       i, (sap->rx ? 'r' : 't'), sap->ipaddr[0],
-			       sap->ipaddr[1], sap->ipaddr[2], sap->ipaddr[3]);
+			       i, (sap->rx ? 'r' : 't'), ntohl(sap->ipaddr[0]),
+			       ntohl(sap->ipaddr[1]), ntohl(sap->ipaddr[2]),
+			       ntohl(sap->ipaddr[3]));
 		p += scnprintf(p, bufsize - (p - buf),
 			       "sa[%i]    spi=0x%08x proto=0x%x salt=0x%08x crypt=%d\n",
-			       i, be32_to_cpu(sap->xs->id.spi),
-			       sap->xs->id.proto, sap->salt, sap->crypt);
+			       i, ntohl(sap->xs->id.spi),
+			       sap->xs->id.proto, ntohl(sap->salt), sap->crypt);
 		p += scnprintf(p, bufsize - (p - buf),
 			       "sa[%i]    key=0x%08x %08x %08x %08x\n",
-			       i, sap->key[0], sap->key[1],
-			       sap->key[2], sap->key[3]);
+			       i, ntohl(sap->key[0]), ntohl(sap->key[1]),
+			       ntohl(sap->key[2]), ntohl(sap->key[3]));
 	}
 
 	len = simple_read_from_buffer(buffer, count, ppos, buf, p - buf);
diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index c9ce3dfa42ee..8b1f20947673 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -814,11 +814,11 @@ kci_test_ipsec_offload()
 	diff $sysfsf - << EOF
 SA count=2 tx=3
 sa[0] tx ipaddr=0x00000000 00000000 00000000 00000000
-sa[0]    spi=0x00000009 proto=0x32 salt=0x61626364 crypt=1
-sa[0]    key=0x34333231 38373635 32313039 36353433
-sa[1] rx ipaddr=0x00000000 00000000 00000000 037ba8c0
-sa[1]    spi=0x00000009 proto=0x32 salt=0x61626364 crypt=1
-sa[1]    key=0x34333231 38373635 32313039 36353433
+sa[0]    spi=0x00000009 proto=0x32 salt=0x64636261 crypt=1
+sa[0]    key=0x31323334 35363738 39303132 33343536
+sa[1] rx ipaddr=0x00000000 00000000 00000000 c0a87b03
+sa[1]    spi=0x00000009 proto=0x32 salt=0x64636261 crypt=1
+sa[1]    key=0x31323334 35363738 39303132 33343536
 EOF
 	if [ $? -ne 0 ] ; then
 		echo "FAIL: ipsec_offload incorrect driver data"
-- 
2.32.0

