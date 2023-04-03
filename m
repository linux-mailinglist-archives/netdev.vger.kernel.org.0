Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44EBF6D440F
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjDCMET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjDCMEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:04:15 -0400
Received: from mail-ed1-x561.google.com (mail-ed1-x561.google.com [IPv6:2a00:1450:4864:20::561])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5BC1FDA
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:04:09 -0700 (PDT)
Received: by mail-ed1-x561.google.com with SMTP id cn12so116388426edb.4
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 05:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680523448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mv9eSPw2NYDm+zLdn/0KIdtGuLd5MVBc/kA1IEA/9U8=;
        b=qeLcnaJvpGzxzC9i2/5UzqXUn0aCH0vyWkKClH/xO2mw5d0sxsfOU84hGlNAlIyj3T
         HM5N0+wtUwVioRD56uqOqHHmo+V2eV35THsxuTTiMOn0pLREW5D21VnQ7UXTW/RlSEm0
         achUFDrhpgjMzG1xbdweAPoGwdzCbh75n2gi0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680523448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mv9eSPw2NYDm+zLdn/0KIdtGuLd5MVBc/kA1IEA/9U8=;
        b=eHgJVfPtOymDnyjDwOJN2QspY/7WIEIqczRlbVk3eUulG3jmdfBeG46IRlVIzp9J66
         QMnirUBfMYyWyo/NzF21RpT9nBiTIEF6WAHlEDg6i/G55E7Zm8KhyOuOEVqf+VJ4ANq8
         JKkfzJ6cP8v3pRONDvAtuCvxkPW7+BqXTcmVN7PldEB5bUliAxsk/iuh4S9D84O7hoJn
         CrnLYgARNnDpVHAEpcpBnFJPLrachYLTolrfHfH45i6Z+YxePbiK0g4fz9apfDLe4zGP
         cmwCddFsWDsIL5oLadWnTXIuke5oGBzcNdL+U0qc7a8hRPr7gIriP/EWDMdU/tFy4tZK
         RYmQ==
X-Gm-Message-State: AAQBX9cUdA8RzKa0c0wRRQ2ncNJGrf9aoM3vGOV4YuFVYb2mraAGV0eC
        xWWYHfO97+vW6nKlTFclf75NtkbzxI7WBCVZTCQJdCVi7B7x
X-Google-Smtp-Source: AKy350bUU6hMTd1TMujkpxpKhnxiqLj2cfko1OJLyNg9wh5tN+dyqD8vkd+4SwQbNePb4gRX6VT7DZ+TD912
X-Received: by 2002:a17:907:a0b:b0:93e:739f:b0b3 with SMTP id bb11-20020a1709070a0b00b0093e739fb0b3mr46736265ejc.50.1680523448055;
        Mon, 03 Apr 2023 05:04:08 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id g26-20020a17090613da00b0093d0d964affsm3174279ejc.73.2023.04.03.05.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 05:04:08 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf] selftests: xsk: Deflakify STATS_RX_DROPPED test
Date:   Mon,  3 Apr 2023 14:03:59 +0200
Message-Id: <20230403120400.31018-1-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix flaky STATS_RX_DROPPED test. The receiver calls getsockopt after
receiving the last (valid) packet which is not the final packet sent in
the test (valid and invalid packets are sent in alternating fashion with
the final packet being invalid). Since the last packet may or may not
have been dropped already, both outcomes must be allowed.

This issue could also be fixed by making sure the last packet sent is
valid. This alternative is left as an exercise to the reader (or the
benevolent maintainers of this file).

This problem was quite visible on certain setups. On one machine this
failure was observed 50% of the time.

Also, remove a redundant assignment of pkt_stream->nb_pkts. This field
is already initialized by __pkt_stream_alloc.

Fixes: 27e934bec35b ("selftests: xsk: make stat tests not spin on getsockopt")
Signed-off-by: Kal Conley <kal.conley@dectris.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index a17655107a94..30a364283542 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -631,7 +631,6 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 	if (!pkt_stream)
 		exit_with_error(ENOMEM);
 
-	pkt_stream->nb_pkts = nb_pkts;
 	for (i = 0; i < nb_pkts; i++) {
 		pkt_set(umem, &pkt_stream->pkts[i], (i % umem->num_frames) * umem->frame_size,
 			pkt_len);
@@ -1124,7 +1123,14 @@ static int validate_rx_dropped(struct ifobject *ifobject)
 	if (err)
 		return TEST_FAILURE;
 
-	if (stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2)
+	/* The receiver calls getsockopt after receiving the last (valid)
+	 * packet which is not the final packet sent in this test (valid and
+	 * invalid packets are sent in alternating fashion with the final
+	 * packet being invalid). Since the last packet may or may not have
+	 * been dropped already, both outcomes must be allowed.
+	 */
+	if (stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2 ||
+	    stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2 - 1)
 		return TEST_PASS;
 
 	return TEST_FAILURE;
-- 
2.39.2

