Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D7E51DC2E
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 17:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442947AbiEFPff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 11:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442937AbiEFPfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 11:35:16 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E43B6EC71
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 08:31:09 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id a191so6403508pge.2
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 08:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kdkb9iJD2Cf92mUwdfbtRZPbJe3zJ/RvlmfMXNxr0ow=;
        b=BbQAApVltlUz38H+FD9UfNocvzYbc2lnKvRFDdAYntx5DQ6S28pl58E0a/FO3Dl3nv
         /2lTlAi6T4ztizG+gVEIZtc9pmi+/3Pq3oGW63sumsvrRbSK0Az+3/8tQ4bKA6g1dMu4
         4rUjHP8xiboqHAvJ3Mwa6rgxowZlSgk+F+ibvi4Zt/VIVH1g+b3IyEhMMPkL1r80akRi
         a9WSBdAwxHIHi4GSYywdxNdms0kQrNfBZsGdVVd9dPr+fXS52UgOlW3py+D0Pv4DqdWJ
         Aj8ehHQgVrbXLrK2KW8j8VcFSJJi/q5u6Jw9aPu7KbRf3Cds2VTbXv8kDymdxStVjqPP
         ToMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kdkb9iJD2Cf92mUwdfbtRZPbJe3zJ/RvlmfMXNxr0ow=;
        b=nQRl/LsQcthxuwYrhtor4LbYk9peKs50FzfnwQpd0rYV2uBmxxi2Xzf6Dw6/vnLmrH
         YsBg4XFeYVsZbMsvqKMU8FvAgxQCXGHr1zWER6E4ag2Uoh4qErQTO6eZj0uDymq800vX
         7GdQBvrxmQSLueay3Wi0QkaetKagR0LEDSHNzcoVHwD4en7rVRFrqQmy72tnvTcmpZje
         H1LVFB9/r9k+woD8rnLOZwhTtTRFa1TmmXYqG71TatA+UejcPssekkA2cTSDYvD4WMC1
         XV2K+2Wqq3OE7Z5F+kCBe25xaDlsLhTFlFZJX4o+XPD6RUH8kmcIeA23GBl8F4DHAqOJ
         GoJQ==
X-Gm-Message-State: AOAM532NBqMg9uRhgklZYehPf8E9hv/xogPLx0raUiAdNrVSpb3c/fVq
        tK14S5rNT6SwblPe2i8R0oo=
X-Google-Smtp-Source: ABdhPJxcVmgpZtZgbJfldL47UAkDVJ5vuoMK8UowsK0tDhjtuwODnjc461RgdJRJG5ekNwPk4K70ZA==
X-Received: by 2002:a63:2bc4:0:b0:3ab:1d76:64db with SMTP id r187-20020a632bc4000000b003ab1d7664dbmr3096089pgr.508.1651851068898;
        Fri, 06 May 2022 08:31:08 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:709e:d3d8:321b:df52])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902d70400b0015e8d4eb1bfsm1918612ply.9.2022.05.06.08.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:31:08 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 04/12] ipv6: add struct hop_jumbo_hdr definition
Date:   Fri,  6 May 2022 08:30:40 -0700
Message-Id: <20220506153048.3695721-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220506153048.3695721-1-eric.dumazet@gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Following patches will need to add and remove local IPv6 jumbogram
options to enable BIG TCP.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ipv6.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 213612f1680c7c39f4c07f0c05b4e6cf34a7878e..63d019953c47ea03d3b723a58c25e83c249489a9 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -151,6 +151,17 @@ struct frag_hdr {
 	__be32	identification;
 };
 
+/*
+ * Jumbo payload option, as described in RFC 2675 2.
+ */
+struct hop_jumbo_hdr {
+	u8	nexthdr;
+	u8	hdrlen;
+	u8	tlv_type;	/* IPV6_TLV_JUMBO, 0xC2 */
+	u8	tlv_len;	/* 4 */
+	__be32	jumbo_payload_len;
+};
+
 #define	IP6_MF		0x0001
 #define	IP6_OFFSET	0xFFF8
 
-- 
2.36.0.512.ge40c2bad7a-goog

