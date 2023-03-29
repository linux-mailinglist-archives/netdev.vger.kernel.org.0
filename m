Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13B06CF1D8
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbjC2SIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjC2SIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:08:20 -0400
Received: from mail-ed1-x563.google.com (mail-ed1-x563.google.com [IPv6:2a00:1450:4864:20::563])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68186592
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:08:10 -0700 (PDT)
Received: by mail-ed1-x563.google.com with SMTP id ek18so66807589edb.6
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680113290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i2i+01++VA+1j2ZEVCh5fg4pO/m6vcFxbZIQZAXxjI8=;
        b=AW67JIn5aLtRKvQ4ISp3hFmglAQJgsJ0dmDFCEGpxvRu7O0kdMEFfhYAo1KrL0jtEE
         BMvJkF2fGQfHPg7tSVQGmpFV3BH/rXOEUC5oyGEL1xqlqJGQoEDUaIF3h3pT34MUXg3H
         7A5BZv9Sk96kT2f1EEJWJjhsetjVL65RdAEAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680113290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i2i+01++VA+1j2ZEVCh5fg4pO/m6vcFxbZIQZAXxjI8=;
        b=1uklKupxgpDfbrkX8L0kacr9y0JJc2vY9YUHtC0O+zeWZWk2hDLtfdChtbiWGqISqz
         TvSEw/O6hD4VWjpNFrmrdDcMvbi0xdN3kOnyOahBaENIwfCeQLMPUL1SFessLD/8Dd49
         c2/KUuZCtz/0t3Ql19GTLtj6jDJkt4t3rdel80t/8tcLTxcc9AWeRGYJPZEhCca61fg8
         Qc/MA+jHOZgC7klmaCo85H+oQh3RQc2bLnH1QFjOZXNoKqKSokM/PplF+HIMXVMYFSuL
         GWTRdfieK7S1kmyxLjtwv4Oj/tfY9U9/Cq6hcgf1NW9/bh6Co6oeQbpUunn26cSa+Qhc
         7Ftw==
X-Gm-Message-State: AAQBX9c5+OX88U5NgKrs2vSj9Q++uqXvItNMa9FCNBpWh1uzMiy+gDuj
        wF3ygweUZ8o/28t6ftdpAxluG9B9K5RmEms93qxzz6G2oGU9
X-Google-Smtp-Source: AKy350YnNMkIoPr9AkaT9hzMt5Gkz3gTzo6P2v70cEI9WgKrIZvymtYZd9xVGxZIn2gvv5ZKiNoQ/LZ4Or00
X-Received: by 2002:a17:907:d40c:b0:933:3a65:67ed with SMTP id vi12-20020a170907d40c00b009333a6567edmr23733105ejc.75.1680113290328;
        Wed, 29 Mar 2023 11:08:10 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id m10-20020a1709066d0a00b00920438f59b3sm12072998ejr.154.2023.03.29.11.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 11:08:10 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 09/10] selftests: xsk: Use hugepages when umem->frame_size > PAGE_SIZE
Date:   Wed, 29 Mar 2023 20:05:01 +0200
Message-Id: <20230329180502.1884307-10-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230329180502.1884307-1-kal.conley@dectris.com>
References: <20230329180502.1884307-1-kal.conley@dectris.com>
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

HugeTLB UMEMs now support chunk_size > PAGE_SIZE. Set MAP_HUGETLB when
frame_size > PAGE_SIZE for future tests.

Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 9b9efd0e0a4c..f73bc6ff5c3d 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1289,7 +1289,7 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	void *bufs;
 	int ret;
 
-	if (ifobject->umem->unaligned_mode)
+	if (ifobject->umem->frame_size > sysconf(_SC_PAGESIZE) || ifobject->umem->unaligned_mode)
 		mmap_flags |= MAP_HUGETLB;
 
 	if (ifobject->shared_umem)
-- 
2.39.2

