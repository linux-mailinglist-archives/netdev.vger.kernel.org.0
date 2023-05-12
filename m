Return-Path: <netdev+bounces-2083-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A92700384
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33D4F1C21158
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FDC2BE53;
	Fri, 12 May 2023 09:21:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AF5BE52;
	Fri, 12 May 2023 09:21:28 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A38D2DC;
	Fri, 12 May 2023 02:21:27 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-3079b59230eso773812f8f.1;
        Fri, 12 May 2023 02:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683883286; x=1686475286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ASka55VrLqiFr/6jVKdTK/R93eQuRd6b7korf0ZyN2U=;
        b=VeRU9+Qf+Awr71A6qwyeq/4vXMzjc3SSK010yQ61wQz2J/C+AaKJScxAwIQ3gLs6ix
         IJTWEdjmNkR813ns7qTy8sYOf7iH0ThK2SM3ElqGjapWOHBTn7SN+ADY6KV+S1Z4KZ4j
         +M/kKjA+t5YSeRW0d5QTIhkptOmH2sQ3HDOeEMxSyrSMfW1jJ8Y8Y0bp9twk1DQdPzX3
         CjHcUZgCQG7GAh5ck7qQS8TwknlZ+T3EuxNQ0SUb9qb4EBr0q/VztDvkEYOlVN4IYMFr
         fQ0rskV58qoYc1gwRSPsYMECa1J8c8BO7A+8evQYMM6MWklu11B4bGFWoBH8CuImomxk
         HdnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683883286; x=1686475286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ASka55VrLqiFr/6jVKdTK/R93eQuRd6b7korf0ZyN2U=;
        b=kbluQ/rf2/Mrqb7EoJ9VMsIALlicGcLKmh6sJ+3yF6ppV40vd+uPGOi/9Ej3iYgzRB
         FCtf9Aiqow5rE9QaC0vp8d3CWFJl9yH8eIJtbTstksTHWxxl+TXANCSS8K+V6MU+7ogW
         +PEbrx5PI6knrdPU9UnMZXsQES/8U3O+Mmbk2Fj/TpnSltjg3Keoa7NADZe+o8VYyBI1
         KDmAj9+HbT3ZzlPA7nN2dAYsvahFO3qUtGuuSep7btZTvECxrpl1LOMDnjcOeUZybnYe
         9zw4jpR7e+glYfZh2rE7Mmn0NUszPTGd4f33aYbDAkx9fG/n4ytOrkU8BRCpt8hr4HJB
         e21g==
X-Gm-Message-State: AC+VfDz4ijHXpz10H+wV8FZhYRxB+DDwEX2FSIr7WvpNqTW+9spKF2mt
	Aouq4X8QtdWhbFFJAuKY4k8=
X-Google-Smtp-Source: ACHHUZ6UqLHMX8/ZRMl/RwwEhP6pFbJMHrT3wMr4VjRaPla9l+4uijUyCvybwYtGPcaIeJkK9QcuKw==
X-Received: by 2002:a5d:5266:0:b0:306:2720:b00d with SMTP id l6-20020a5d5266000000b003062720b00dmr14690313wrc.7.1683883285481;
        Fri, 12 May 2023 02:21:25 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id i14-20020a5d558e000000b003079f2c2de7sm11467789wrv.112.2023.05.12.02.21.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 May 2023 02:21:25 -0700 (PDT)
From: Magnus Karlsson <magnus.karlsson@gmail.com>
To: magnus.karlsson@intel.com,
	bjorn@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	netdev@vger.kernel.org,
	maciej.fijalkowski@intel.com,
	bpf@vger.kernel.org,
	yhs@fb.com,
	andrii@kernel.org,
	martin.lau@linux.dev,
	song@kernel.org,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	tirthendu.sarkar@intel.com
Subject: [PATCH bpf-next 01/10] selftests/xsk: do not change XDP program when not necessary
Date: Fri, 12 May 2023 11:20:34 +0200
Message-Id: <20230512092043.3028-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230512092043.3028-1-magnus.karlsson@gmail.com>
References: <20230512092043.3028-1-magnus.karlsson@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Magnus Karlsson <magnus.karlsson@intel.com>

Do not change the XDP program for the Tx thread when not needed. It
was erroneously compared to the XDP program for the Rx thread, which
is always going to be different, which meant that the code made
unnecessary switches to the same program it had before. This did not
affect functionality, just performance.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index f144d0604ddf..f7950af576e1 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1402,11 +1402,20 @@ static void handler(int signum)
 	pthread_exit(NULL);
 }
 
-static bool xdp_prog_changed(struct test_spec *test, struct ifobject *ifobj)
+static bool xdp_prog_changed_rx(struct test_spec *test)
 {
+	struct ifobject *ifobj = test->ifobj_rx;
+
 	return ifobj->xdp_prog != test->xdp_prog_rx || ifobj->mode != test->mode;
 }
 
+static bool xdp_prog_changed_tx(struct test_spec *test)
+{
+	struct ifobject *ifobj = test->ifobj_tx;
+
+	return ifobj->xdp_prog != test->xdp_prog_tx || ifobj->mode != test->mode;
+}
+
 static void xsk_reattach_xdp(struct ifobject *ifobj, struct bpf_program *xdp_prog,
 			     struct bpf_map *xskmap, enum test_mode mode)
 {
@@ -1433,13 +1442,13 @@ static void xsk_reattach_xdp(struct ifobject *ifobj, struct bpf_program *xdp_pro
 static void xsk_attach_xdp_progs(struct test_spec *test, struct ifobject *ifobj_rx,
 				 struct ifobject *ifobj_tx)
 {
-	if (xdp_prog_changed(test, ifobj_rx))
+	if (xdp_prog_changed_rx(test))
 		xsk_reattach_xdp(ifobj_rx, test->xdp_prog_rx, test->xskmap_rx, test->mode);
 
 	if (!ifobj_tx || ifobj_tx->shared_umem)
 		return;
 
-	if (xdp_prog_changed(test, ifobj_tx))
+	if (xdp_prog_changed_tx(test))
 		xsk_reattach_xdp(ifobj_tx, test->xdp_prog_tx, test->xskmap_tx, test->mode);
 }
 
-- 
2.34.1


