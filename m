Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD05465D258
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239231AbjADMTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239109AbjADMSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:18:49 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C70811836;
        Wed,  4 Jan 2023 04:18:48 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id ay40so25439829wmb.2;
        Wed, 04 Jan 2023 04:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8sTJzD04XRe7x3AbvBKK3ZmowNuoy4S5LkUB6nexLbI=;
        b=gX5A9FeQkWSLPXKqDx/sWsRzjCDSTOhhrvNWWBTJ718nbwHdskkHrL7ZIJugQzEkdY
         Pv8lKlwb525wiG9H/25JU8GJgRh0UAP1nRJuLyM5Y1uGjDqf74Rcp47Lza67FL2OP+5/
         fCxsUx9q0tLY0W28vkoTJactwlYpquIi4H3BbPcTzfT19G8LowuqaggcShZZiQD13kZE
         gVORSvQnWwTur46/hOigOgXSQ18bQ0ndwPqOqyRh+52KXg2q1jUcq6x8F8OkIHT8dtJF
         p6l5MYPJXgsnkjoKHnvlLXOdF7Ahu4iNSHvehqAvWT1kzKaEYHuTN3rRwbyp5ESqu6hc
         yvWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8sTJzD04XRe7x3AbvBKK3ZmowNuoy4S5LkUB6nexLbI=;
        b=YmvcofyRl8wgst9Neit7O00hlXimfkXztHVUBHNrTsX7xnDXOaZFgz9Yg5uyWlJMBi
         +y1HK3z1tCXqLPXjZ4VJ99UyTpAFWYPrwgZGh2La17+S16OSxi1rLfNtd0UPwpbsREG5
         lDlKKKRN8MtNpcZ0lyzuJMqfgsv0ZD3fREYu7MMwv1ERYNyuUWZ/V/a1ckJ9LftMeWYH
         QwPd5eL1viz3ZV6HewNjCWVETvpBJsKVzgRzs11Nz+ZUwt2U5PEXj8tBUJTNPKn70+WA
         S0GCKtoqwmZAOalUq39yQxu9GjPf8w+BAaut/FziJ0ZZ0DI6ple+B7L+aZmzTSgrfyxR
         lEsg==
X-Gm-Message-State: AFqh2kqm3SPibLafN/oTb1NvBCgKPYUvhqDENYhxNr7V9LOOeFXaiuwy
        VgCqrIVn1uT0CgwTW/zV1Do=
X-Google-Smtp-Source: AMrXdXu4ZDkkhFbRoZsQDjElr4Kyu7dk+jOAE5DQofZkSRXg6QABNvQ8AFWRAWW3UeKyI3lNyWtimQ==
X-Received: by 2002:a05:600c:a10:b0:3d5:64bf:ccb8 with SMTP id z16-20020a05600c0a1000b003d564bfccb8mr33592178wmp.12.1672834726914;
        Wed, 04 Jan 2023 04:18:46 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003d04e4ed873sm35013749wmo.22.2023.01.04.04.18.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:18:46 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 05/15] selftests/xsk: remove unused variable outstanding_tx
Date:   Wed,  4 Jan 2023 13:17:34 +0100
Message-Id: <20230104121744.2820-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104121744.2820-1-magnus.karlsson@gmail.com>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
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

