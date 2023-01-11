Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B206657C4
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbjAKJjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjAKJh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:37:27 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E90D1003;
        Wed, 11 Jan 2023 01:36:09 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d17so14421213wrs.2;
        Wed, 11 Jan 2023 01:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VRtmeQGjJgd2ktEcOQh5+7MOjNdEVw8NBWLMwVF55VI=;
        b=WJMDuXwt7355Ic0iRFzPhIDqTFXBeFeGjcx23GUaj707JR6/cEbLhP++THBUnkUjn5
         a8ICywirdVyx9On3PHgLdMA2OsT69tR+3vehiH4DdLrJlkBc1SvvrGKN6wqEhXCP+5K+
         TXMb8af+kkAM6yHxPejP7qG8qe8q3j72yi40cU66qRhpnyQf455wOzujO1VNOjebw7e3
         h0ta+Ge+pXP3q222wY6ScQirdOsZhK3okormxqCCl9kn8Yh+riambaa2Tfubx9az5POv
         QJqr3nnuQ/ReqKd6QTJTR2ro7lHqu8dyKbEmJt/VKOyAlBXU3dgzp3OcEQxPiyagKgXy
         +3xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VRtmeQGjJgd2ktEcOQh5+7MOjNdEVw8NBWLMwVF55VI=;
        b=Z7nFk97Jg1XuCv5EEaZAsvT3p749YKbDQoIgHLwz/U77XSv6FNpuRCILj2/K50h2iX
         qmBfuvywEIXh3t9pSiN845c9CmVLdD7dQpD7r6GjvD9TReCI2zHP93lJk8d0uIzhFFYZ
         yWs+ZriOYxMKk3TX+0+af9YR/wbuvLsd0xKhQWYGq36z/zbgO6JUkQ+VmQv4k1EQfA5T
         jmSsoYr1Dhixun1DZeVuzuC+2B5g9RT1xh9jb328o9sgkiO1a84ukeM3M6+C9IKz8wiH
         wnYlIla3RBqJTU9ad9j2YtNOfnR83+FiepN4DNKR9mZj4jtbi2vI6RbTA5NcTRcEV0cy
         F/ug==
X-Gm-Message-State: AFqh2krte6QijSuQcUJf5avK6/k/xISHF7QZNick1m9mOV9sfOmkkyQZ
        cXVeVoUjqiLO/FbxCvCd/wu9IXhwyDUSI52x
X-Google-Smtp-Source: AMrXdXvgSDACGPmFLp9mXmrruLEUptYMRpX8KSn8Z+8/ee8vTHnZI6lIWYM8U/AoFm0kvOIQYARbQw==
X-Received: by 2002:a05:6000:1c03:b0:2bb:ed0c:a0d8 with SMTP id ba3-20020a0560001c0300b002bbed0ca0d8mr7994728wrb.53.1673429767909;
        Wed, 11 Jan 2023 01:36:07 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb52000000b0025e86026866sm15553069wrs.0.2023.01.11.01.36.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:36:07 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 05/15] selftests/xsk: remove unused variable outstanding_tx
Date:   Wed, 11 Jan 2023 10:35:16 +0100
Message-Id: <20230111093526.11682-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111093526.11682-1-magnus.karlsson@gmail.com>
References: <20230111093526.11682-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Remove the unused variable outstanding_tx.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xsk.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
index 5e4a6552ed37..b166edfff86d 100644
--- a/tools/testing/selftests/bpf/xsk.c
+++ b/tools/testing/selftests/bpf/xsk.c
@@ -86,7 +86,6 @@ struct xsk_ctx {
 struct xsk_socket {
 	struct xsk_ring_cons *rx;
 	struct xsk_ring_prod *tx;
-	__u64 outstanding_tx;
 	struct xsk_ctx *ctx;
 	struct xsk_socket_config config;
 	int fd;
@@ -1021,7 +1020,6 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	if (err)
 		goto out_xsk_alloc;
 
-	xsk->outstanding_tx = 0;
 	ifindex = if_nametoindex(ifname);
 	if (!ifindex) {
 		err = -errno;
-- 
2.34.1

