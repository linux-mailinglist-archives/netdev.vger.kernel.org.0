Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4759465A4E
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 01:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353989AbhLBAHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 19:07:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344175AbhLBAHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 19:07:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638403436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U/VVqJ2rvS3+utXonMTYrBEeM8oEcGBPKY47J7o2598=;
        b=XX+GAkY+VwEhfrfduVBKBk6jW1cawTvExATVkTuUe3/ayEosE8PS+NzCoc2Q4QvSf1Ri37
        9wJfjfQVgKyhtTXm3sPcuCL9NyIaFnSpDpkToG1wbCOPiF6gEkDV9JHLAQj8ADJM/gNN5Y
        xbKz/7vghGKeOAq7hoG3FFaXLIIgBeU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-585-4S4UNNNvMy-ZdJ1ueW7-mA-1; Wed, 01 Dec 2021 19:03:55 -0500
X-MC-Unique: 4S4UNNNvMy-ZdJ1ueW7-mA-1
Received: by mail-ed1-f69.google.com with SMTP id y9-20020aa7c249000000b003e7bf7a1579so21804283edo.5
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 16:03:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U/VVqJ2rvS3+utXonMTYrBEeM8oEcGBPKY47J7o2598=;
        b=G8S9lKij/Y0qqfJQlU41y5TgW4sCK2lwB6slu/OjLLC3VlBG5kBMpTv2w+Vhh+iRrS
         FNeZJbT3VIQmw7Xm32x8CV9fCOiMh4/B1L1iaeVDXGlB4GPArjSkMaxrVSWFRx1C6452
         ZRqs79RUdiFrLBlnIeH9dpWBPV7CCzr3aT3+FnxEFUZabPAkOBi12/Cw7Q2xJS1hntgg
         NVrs+a/YJJNc4/v221fo+2cxh8gHoVoX1nKqwqAy0Kg0IsKvjVK2JP4uIZQ3o1gYb63v
         /1myUQvuMHmSXMZoK4FN3qajulqmvFIsgsUPPnjOIDN3cQhhKBiH2hRPC2GSjZSegwel
         ySyg==
X-Gm-Message-State: AOAM530jut1WhDOCYM2gDSRLUI9UIv4zsqhic10MDjriVnG2e0/qxHg1
        los6wdjFzDXDT8y9kupCo6B4LV0F8nzVFZiQ+931UEx0ik49TSGG3N2kAU2Xom4nTehrP/fyUdO
        SjL5aEEN9Fm0DPz7Y
X-Received: by 2002:a50:e102:: with SMTP id h2mr12566893edl.298.1638403433879;
        Wed, 01 Dec 2021 16:03:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyZmHop5Ge6qSzyuP7uAvHY/UWbBwr7FnWuIOUcaT9S7FEQFAGTzcI+yRyeuOzgpn3YScDHQA==
X-Received: by 2002:a50:e102:: with SMTP id h2mr12566858edl.298.1638403433621;
        Wed, 01 Dec 2021 16:03:53 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g1sm621476eje.105.2021.12.01.16.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 16:03:53 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ABD431802A0; Thu,  2 Dec 2021 01:03:52 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/8] page_pool: Add callback to init pages when they are allocated
Date:   Thu,  2 Dec 2021 01:02:22 +0100
Message-Id: <20211202000232.380824-2-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211202000232.380824-1-toke@redhat.com>
References: <20211202000232.380824-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new callback function to page_pool that, if set, will be called every
time a new page is allocated. This will be used from bpf_test_run() to
initialise the page data with the data provided by userspace when running
XDP programs with redirect turned on.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/page_pool.h | 2 ++
 net/core/page_pool.c    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 3855f069627f..a71201854c41 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -80,6 +80,8 @@ struct page_pool_params {
 	enum dma_data_direction dma_dir; /* DMA mapping direction */
 	unsigned int	max_len; /* max DMA sync memory size */
 	unsigned int	offset;  /* DMA addr offset */
+	void (*init_callback)(struct page *page, void *arg);
+	void *init_arg;
 };
 
 struct page_pool {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b60e4301a44..fb5a90b9d574 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -219,6 +219,8 @@ static void page_pool_set_pp_info(struct page_pool *pool,
 {
 	page->pp = pool;
 	page->pp_magic |= PP_SIGNATURE;
+	if (unlikely(pool->p.init_callback))
+		pool->p.init_callback(page, pool->p.init_arg);
 }
 
 static void page_pool_clear_pp_info(struct page *page)
-- 
2.34.0

