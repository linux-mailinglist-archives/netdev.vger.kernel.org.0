Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F3E643F5B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiLFJJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbiLFJJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:09:01 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA371DF0D;
        Tue,  6 Dec 2022 01:08:58 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id u12so21550157wrr.11;
        Tue, 06 Dec 2022 01:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oBDrhciyUnzlxX/TZMPkmc1oT4VfvbpsEGpcqBYnyMo=;
        b=U4Vztr69xzp2xiM/Yo0D8itk9XqBPsIIFKOM94nCSKiLTF2B1due5kJQQ4KCWn6gat
         AV8l3sXR2xVwu9zdf/+AYE9AaedwUH3K8rWKXc4g7Hyca1YQXnLjyJdSYsqvb5J9gQCr
         ZVvuXwZTA9nzkg+jNaZ91t773zh6nxta98l9JuuYBGS1oNFTzoh6K33iKXXdFsSlANgR
         9rs3f8dKOIbMKBKUvf2yz2zAHmeLm9PQvDBZt6WhlJgG2n5MFfv8X07Osx+LiqZmr+lw
         aRoQ0Fd5OjuAY7OCbyTcPUcdpLKX4xOodVIh9BN6Pekxi4vlnGFiL1dkLyc+gnYoTh57
         veQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oBDrhciyUnzlxX/TZMPkmc1oT4VfvbpsEGpcqBYnyMo=;
        b=60tiWY+XuUNugQCo7kD6Dzv6xSPYX+NFkyudMUmbyXDi+2SeKbDgrOvAuDs5r+aSYQ
         6NElxkLD/lbbF1QCpv6J0YZ/KLUnXUXbyM/7foZqAT2f6YwhKUwmQzZVOQ7w9cFxP3ex
         CxbGWdmIG7pnGqfyrQvfuoK8obmK6gBvP+oKqn7d7Jb4Rer43iU7I6r6xAMvcYHRcTu4
         SAt4McLfkM6jzPFCw1K1VH+mm/TLyW9nSr5dfqVwNld8WVjW7Y34cJxk5Qi5gqLBFri9
         Z/5JwVLXYckpAJIJSxIyX+mHC6hOECprsZP3OArfN8KHGmNttQBl+GPy666fv6muhu6W
         WCEw==
X-Gm-Message-State: ANoB5plxM1UFY8cFg9lYohuA4I5bVNyNnEeayPjcTtjPvWg2qeKvp5rK
        0RCbviCckdsbUf1agWEdG4E=
X-Google-Smtp-Source: AA0mqf6zhGYPvhS9BRRouTnRdjCn8GnY5Ph8ESr07Ex5afGzVFkS4NqIXHxBOIy3rqhqbxXadeAcKA==
X-Received: by 2002:a05:6000:239:b0:242:423c:4ce9 with SMTP id l25-20020a056000023900b00242423c4ce9mr11460447wrz.399.1670317737026;
        Tue, 06 Dec 2022 01:08:57 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.08.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:08:56 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 01/15] selftests/xsk: print correct payload for packet dump
Date:   Tue,  6 Dec 2022 10:08:12 +0100
Message-Id: <20221206090826.2957-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206090826.2957-1-magnus.karlsson@gmail.com>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Print the correct payload when the packet dump option is selected. The
network to host conversion was forgotten and the payload was
erronously declared to be an int instead of an unsigned int.

Fixes: facb7cb2e909 ("selftests/bpf: Xsk selftests - SKB POLL, NOPOLL")
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 162d3a516f2c..2ff43b22180f 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -767,7 +767,7 @@ static void pkt_dump(void *pkt, u32 len)
 	struct ethhdr *ethhdr;
 	struct udphdr *udphdr;
 	struct iphdr *iphdr;
-	int payload, i;
+	u32 payload, i;
 
 	ethhdr = pkt;
 	iphdr = pkt + sizeof(*ethhdr);
@@ -792,7 +792,7 @@ static void pkt_dump(void *pkt, u32 len)
 	fprintf(stdout, "DEBUG>> L4: udp_hdr->src: %d\n", ntohs(udphdr->source));
 	fprintf(stdout, "DEBUG>> L4: udp_hdr->dst: %d\n", ntohs(udphdr->dest));
 	/*extract L5 frame */
-	payload = *((uint32_t *)(pkt + PKT_HDR_SIZE));
+	payload = ntohl(*((u32 *)(pkt + PKT_HDR_SIZE)));
 
 	fprintf(stdout, "DEBUG>> L5: payload: %d\n", payload);
 	fprintf(stdout, "---------------------------------------\n");
-- 
2.34.1

