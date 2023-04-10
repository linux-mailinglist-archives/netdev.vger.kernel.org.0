Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432F36DC691
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjDJMIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjDJMIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:08:02 -0400
Received: from mail-ej1-x662.google.com (mail-ej1-x662.google.com [IPv6:2a00:1450:4864:20::662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB76819A0
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:07:58 -0700 (PDT)
Received: by mail-ej1-x662.google.com with SMTP id sh8so11956128ejc.10
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1681128477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xNbic2k37/uJb//jGocyCjKfzDNnw7vJzB+19fgD/vU=;
        b=lFDITA5hSIO3u8hVF0yCmco2vpi7O1SZ04BShKnCIMBu9qWkXJHcVolsDdPBa0XnUt
         QBPL+VSVMCKgFgUGuUEsm69+xFRAvRV+4iNWrKhre0ZGaNgVteqGAqqWpvE8mevhZ/sK
         cob8b+aOSEtLhNj+/1HmHwf0IvR/ENfA/0UlM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681128477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xNbic2k37/uJb//jGocyCjKfzDNnw7vJzB+19fgD/vU=;
        b=TGzo5y3pEqU0z6V1y5+nu2+sbVQY1h4gj/8zr9RMDSEBmjBs8gDgkxz0l+SIfbbJJI
         pmSVvPj4k54EgkawpjKQdINeLonFRMW6kLvjd/JJYKizOZ20Q1NVpoho5JokN3E5O/X0
         Dnpogt0U97Vu1LQB+Ryxog4ywRuJ+i1trYZ24A94WftebIFUZB2xEZsBjluEcLkgdz/F
         oymhgHeIPCxOV6OQtfOtKGhysAeb+MOfGPJBRhO/GcDXL75tfmbDdt2+InhTkG8oOoNz
         HJCvMRr3Cw78G01eALMXfQXiHX0f3uX2xcYpotxNzbykFSxl+0ydS3Qm7pgblOTVG8j3
         4uzg==
X-Gm-Message-State: AAQBX9cSp1SHOKPgZw1xHocxhRoC/EK47Arb7IWS94VLuGB4BJqVRY8y
        bYVnmFNGrXkPC9/aLOiAa8VTOwvQqulhrNoD649GbVzOAD2M
X-Google-Smtp-Source: AKy350bX+Gw5pkRVI9K7HZRdso4z0tqD2c56eUTXhw9H9zhtDwHal9R9E6C8al4EM8JEj1WzI54XGl0VGR4K
X-Received: by 2002:a17:907:2d2a:b0:8b1:7eba:de5 with SMTP id gs42-20020a1709072d2a00b008b17eba0de5mr7635152ejc.10.1681128477114;
        Mon, 10 Apr 2023 05:07:57 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id nb39-20020a1709071ca700b008b1fc5abd08sm2089769ejc.56.2023.04.10.05.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 05:07:57 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v5 3/4] selftests: xsk: Use hugepages when umem->frame_size > PAGE_SIZE
Date:   Mon, 10 Apr 2023 14:06:28 +0200
Message-Id: <20230410120629.642955-4-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230410120629.642955-1-kal.conley@dectris.com>
References: <20230410120629.642955-1-kal.conley@dectris.com>
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
index 5a9691e942de..7eccf57a0ccc 100644
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

