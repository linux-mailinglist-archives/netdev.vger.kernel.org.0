Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA0565D24D
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239219AbjADMS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239179AbjADMSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:18:45 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3250314D17;
        Wed,  4 Jan 2023 04:18:41 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m8-20020a05600c3b0800b003d96f801c48so23863607wms.0;
        Wed, 04 Jan 2023 04:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oBDrhciyUnzlxX/TZMPkmc1oT4VfvbpsEGpcqBYnyMo=;
        b=MmHdGhCyeFJtrUxZJ9v0BQ5bScIgl0w0CMHU8c8GG31iY8cNt10nMdKdXM234nibz5
         Tht0mviR9obD4i3lcq7IFVTcqe+/I/PnBz64vTdCr/j8kvSDgK10pntpVqnMlPS4tY75
         +CAdTHzkimwSNZHQ0bfFaR9jpMj63SFcRmexD7nI36dCSAceZxwLc4PoOfCU+MLLRMYu
         OXpslUKoZZKu7+Mm/UwHNjDvC910J1MciaT79a6Oo4uZ0r1Js45UScA1eMAVO+q/lsmi
         tfrwk7z3zeqerkey9Ma8aNlJDUCDDCPkJCKcwQ4CLb25OBpGTPOou/UtbmABOGgM3PJm
         SJeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oBDrhciyUnzlxX/TZMPkmc1oT4VfvbpsEGpcqBYnyMo=;
        b=FTj+iO5G3gCsnFCRsk4qJXnNfbtxyYiYV3ybkBGDHRidz+w+Q+qKLEJvPLmzMNVp+W
         NiojE7tVQ+X3GpnLbWqCZ+tH7Hx+8jJ2wd47azfC4V9j7zGsO0U6oe8vYkQvlV5gh4Qh
         iCj1qDR03NBSgHnBRea6Vd9t6PCueWXAs1e+hgEKgrdR1GegoSJI/PSoVKG449QeN7rL
         Eu0jbBUkKvPw8AwloxyGNvs1/RH86rKi4aL7rfFF/O29Az659SeTpSxXh9N3PRfTcI5/
         eZW620S0sNXWLb6is6pMueiPtWyGSc7OcTUrokLbkd8+vIjgqqdKC2n8m1+d0G1TK7tz
         99ow==
X-Gm-Message-State: AFqh2krZtc3tZpROtnJqgxqU9URN9T/QvJ77h4TZIFiBr6dy7G9213cl
        Bw4SZ02fK+Qs69XjlrrNLxA=
X-Google-Smtp-Source: AMrXdXsO2FZuJymBTj5jL9YtMI6L+vB2DfrjbehfOAiNDB8zmbZfITTaWQaEtppB+SJShk9zJHnEEw==
X-Received: by 2002:a05:600c:54ef:b0:3d0:5254:8a43 with SMTP id jb15-20020a05600c54ef00b003d052548a43mr41924166wmb.38.1672834719647;
        Wed, 04 Jan 2023 04:18:39 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003d04e4ed873sm35013749wmo.22.2023.01.04.04.18.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:18:39 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 01/15] selftests/xsk: print correct payload for packet dump
Date:   Wed,  4 Jan 2023 13:17:30 +0100
Message-Id: <20230104121744.2820-2-magnus.karlsson@gmail.com>
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

