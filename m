Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8946D4525
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjDCNCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjDCNCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:02:11 -0400
Received: from mail-lf1-x163.google.com (mail-lf1-x163.google.com [IPv6:2a00:1450:4864:20::163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0306F1D86F
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 06:02:08 -0700 (PDT)
Received: by mail-lf1-x163.google.com with SMTP id g17so37983410lfv.4
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 06:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680526927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vEhFH3i/UwokEBWEnFizsJMKXzUUnazCcIuMHjSUIWg=;
        b=hCS9Wy2klHb60FM9HLsFhdDnFuvaJ0L559f3t8KLSH+WOQVwm7Gfy1vcir0LaqB20z
         G609n6eZu90oMP0/D43sf+JUA+EFKw8Npk+8GU1+wF1ntisjYLjJlpY4bSItWrbYssLB
         0RrR//bU44J5eXUBpyIxgGKqO3GSZJ3jzYVO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680526927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vEhFH3i/UwokEBWEnFizsJMKXzUUnazCcIuMHjSUIWg=;
        b=zQ9tZldOI0i4uafW0N8KghrhfA9zran1vBn0VcrcPO3tUOwCWeMKNr0abb96ugpyF4
         739Q3kdtfIGZHQQndBdhbJSZrwbOJD0ZcJaavkw1LaGjLjMBp9vnzIfsujYZGS1J3gsh
         fCB12eP1VPyRvtXv9JCp0NHFiTpYw+/hokfKN+jTb8/z95bnr2saO0IKDQpmcDX3ho4d
         MrMuktIrqhlpgSre+buO6YXzURz8MQE6o2AvN8l57jubm6Hkkpef0/sIqCvoCDTBxSGg
         P5eswOG+Hgy8w+6hSS41/SdPA5XLBRN+IgaAA7/PPDiTr21W1WZNZvzcgjXuIvmwjGNF
         kMvg==
X-Gm-Message-State: AAQBX9dsFV4q2Tppen/vhXiDAcvVFRgUEIPAlUjVnxHRflD760YQe/th
        2gRYj+mw0WDEVUa1CpaAKdfQZ/9o62aubhGRnfAar0P0sLGN
X-Google-Smtp-Source: AKy350aHfgDDioVgKMy3hSPfGcQzCSSIU939JUAmQ90NcFGWD+Ct6os165xxQS0qaStfntHDP4gOAcD4gwA6
X-Received: by 2002:ac2:508d:0:b0:4ea:f69a:de37 with SMTP id f13-20020ac2508d000000b004eaf69ade37mr10184339lfm.42.1680526926900;
        Mon, 03 Apr 2023 06:02:06 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id w7-20020ac25987000000b004e81ff9f545sm2099845lfn.79.2023.04.03.06.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:02:06 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Kal Conley <kal.conley@dectris.com>, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next] selftests: xsk: Add xskxceiver.h dependency to Makefile
Date:   Mon,  3 Apr 2023 15:01:51 +0200
Message-Id: <20230403130151.31195-1-kal.conley@dectris.com>
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

xskxceiver depends on xskxceiver.h so tell make about it.

Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index b677dcd0b77a..b55d828911d5 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -607,7 +607,7 @@ $(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(OUTPUT)
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
 
-$(OUTPUT)/xskxceiver: xskxceiver.c $(OUTPUT)/xsk.o $(OUTPUT)/xsk_xdp_progs.skel.h $(BPFOBJ) | $(OUTPUT)
+$(OUTPUT)/xskxceiver: xskxceiver.c xskxceiver.h $(OUTPUT)/xsk.o $(OUTPUT)/xsk_xdp_progs.skel.h $(BPFOBJ) | $(OUTPUT)
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
 
-- 
2.39.2

