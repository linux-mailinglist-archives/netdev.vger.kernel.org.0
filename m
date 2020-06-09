Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69AB1F3A66
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 14:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgFIMIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 08:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgFIMIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 08:08:35 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82668C05BD1E;
        Tue,  9 Jun 2020 05:08:34 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id v79so20425377qkb.10;
        Tue, 09 Jun 2020 05:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=vRHbPOXtPbJdANLvmSwZ4cS7X1/NwFEoLTvptBebMJM=;
        b=aADFy46qw/Vq/MMCuSbBmbsKc0B9TH20nslbYSnWZNTVPRWLM4Eiu3okUJjB+jyDKP
         2vQzs7enHj/b8o2w3J+JzTGAJPdJ8WeEZYsfgNlzUL4h//jWglPvInFIKrfyf/9pjggP
         92SNWvRKlOQdNK2XiWmxqvUEuoR6VF0xR/YvgadYyuGbB6OEsPE9ZH5CaGJRYTE+S71n
         ZO0to0h5nvo7nHqgv0Xb5EDS5xACoa2V4zsRXNc0N/eJNjRtFAhXHuKMtpRpqwhy64re
         FoCCCSREHz0D7053m/SJ6t7asElKY97FrMaxLt85/87yvS/ZQjgp8FwATgT/CNbg2mvO
         hiAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=vRHbPOXtPbJdANLvmSwZ4cS7X1/NwFEoLTvptBebMJM=;
        b=aWV/18v53aZLyloCYaGfM8MuljcgxqsbkXAR+s/X9rjiy8CKTrXVAMTxsa6/qvUf4L
         rZh0FvzzZ4Rq4OOzISzylvQHSdUgbx/ZC1jR3YCDlvKNKWdTACUhJclbz57nFvwyihgr
         K0KZai5QMXRVKpy8WgoffYZs5FsxhSVwbWTtcxaW6uoBlAb2X8KpcinfatIXtYvi5S50
         TFFgbFS+V669Tb1HxXHAyh/JyFXtnHzuohOSfbqOmFofawv245yFzsXBTwpbZxeb0Ke6
         5QWdvqsf++zWAcEOtxLT7K9FtLbBpo07kfqTRYPEME5Dnr6Woq0IRf9Ofn/yiaOsSGQY
         1r3A==
X-Gm-Message-State: AOAM5301/TVXSeTr8X2GOkjuhfbzGT6Pdh9bDx084VJWqQL+YiS3FhwQ
        bQQQCm7yfFZrbaVlOl1b4tI=
X-Google-Smtp-Source: ABdhPJxSzISY4ib4u1DtG9gJaxQkMpZ71pq7o6ENgO3YLF6GKZ8qbVpkR7mK0rYln/VJQxzA8xkGTw==
X-Received: by 2002:a37:9c91:: with SMTP id f139mr27953469qke.371.1591704513335;
        Tue, 09 Jun 2020 05:08:33 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:29ac:7979:1e2e:c67b])
        by smtp.googlemail.com with ESMTPSA id d56sm10732690qtb.54.2020.06.09.05.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 05:08:32 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev@vger.kernel.org (open list:XDP (eXpress Data Path)),
        bpf@vger.kernel.org (open list:XDP (eXpress Data Path)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] bpf: alloc_record_per_cpu Add null check after malloc
Date:   Tue,  9 Jun 2020 08:08:03 -0400
Message-Id: <20200609120804.10569-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The memset call is made right after malloc call. To fix this, add the null check right after malloc and then do memset.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 samples/bpf/xdp_rxq_info_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index 4fe47502ebed..490b07b7df78 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -202,11 +202,11 @@ static struct datarec *alloc_record_per_cpu(void)
 
 	size = sizeof(struct datarec) * nr_cpus;
 	array = malloc(size);
-	memset(array, 0, size);
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
 		exit(EXIT_FAIL_MEM);
 	}
+	memset(array, 0, size);
 	return array;
 }
 
-- 
2.17.1

