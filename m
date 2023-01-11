Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A986657AC
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238257AbjAKJiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235915AbjAKJhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:37:20 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E115FCA;
        Wed, 11 Jan 2023 01:36:02 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id bs20so14416648wrb.3;
        Wed, 11 Jan 2023 01:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UxYyG1qoCtU6q6CHSuAlYxv5sFnMz8aGPPPyKfwBER4=;
        b=nBONqyay9jM4gr2b5iDxKwJDUAisqj0iA3GvGwyQpdkSX2P7vr0RpWTGyQP3Om6HPX
         LL11jfRSGto61N3QkpJzi5ZwqAyAKCT6DyUSc4s4jbBZoeuB7xW6Ar78f9b2eZeHxwP7
         kUavckTvpBlCsx5StfF5EOAsXrMh+O3UNhANBJ29BUcAmv30bHDaLioVosKsqET5R1DZ
         jYKBoRUPOMO4pwd2Qh9ZHQGRY2+fJpBzXLrhrcdSor/vLXbYdP6fFe9oi5rQiVmN/z9S
         L/ycMpqL5pUyQIOILhc0vifdiKg+z7no0UaPY8uq3m+OH7zihayovdz7ERPXNSDGcfqO
         VDaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UxYyG1qoCtU6q6CHSuAlYxv5sFnMz8aGPPPyKfwBER4=;
        b=v5fU019HEqSp//d0Qi6Y+hVlf3fqKA4oQY2XIFvdkeHO+QQ2EJYXTgciKADlQ6Fj5h
         iZ76EWT4vfN++tRCFHNgeoiXFIMlSpYERsIZa/u2/ATjCaJD/+XwWX+hf+Ibga57dvN/
         yv2pCRBUkmztL4urfMA4rsnvnuoC5fd8UgCdXrdEfyYgZFu7GWLU8x/LeobhXxkaUSAR
         Ohsi+j4RvyvrB5udQ/Q0M0B3hd5+06cYp+sXXj1u04QN10vYkITE05poUz1p4vHsb4EM
         cXt7cgrWDA5mkY6cDnFSrri6Oy43++VY6AhRbjglmnfDOMuZisQ8qn9ibrHVkIcYKAUI
         ILPw==
X-Gm-Message-State: AFqh2kqNwqx26gLv6dz7zKibk3T/wuhmYPA2mYyCFMjMOQjBztrEEsG6
        84oAli40syPnW9MxwEHOFQo=
X-Google-Smtp-Source: AMrXdXvpf6lwRDvB/vFvpk6F/GWN5g5V1xRX4cXxhGA89PG+1lsx98G/yhvmtf3qYcanloTW8CzoTg==
X-Received: by 2002:adf:a1cc:0:b0:2b4:e5e:c0a3 with SMTP id v12-20020adfa1cc000000b002b40e5ec0a3mr6131619wrv.21.1673429760716;
        Wed, 11 Jan 2023 01:36:00 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb52000000b0025e86026866sm15553069wrs.0.2023.01.11.01.35.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:36:00 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 01/15] selftests/xsk: print correct payload for packet dump
Date:   Wed, 11 Jan 2023 10:35:12 +0100
Message-Id: <20230111093526.11682-2-magnus.karlsson@gmail.com>
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

Print the correct payload when the packet dump option is selected. The
network to host conversion was forgotten and the payload was
erronously declared to be an int instead of an unsigned int.

Fixes: facb7cb2e909 ("selftests/bpf: Xsk selftests - SKB POLL, NOPOLL")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
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

