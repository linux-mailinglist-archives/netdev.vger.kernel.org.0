Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16BFE557F9
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbfFYTnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:43:20 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35606 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729270AbfFYTmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:42:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id c6so73426wml.0
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 12:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=85UmCqjB/2q4FemAi0uqOHeKcTywLVBMQcPg1IVAqAM=;
        b=ItHyKFJ4XKYckCqhHyWodBeiPoSVP0SJx+jL3mIeXqtPEFRqoYIQTpI9yaJjhvDtfN
         BQl3rcGcAlTg36sUZLiD3au1iPVGbO7p9kY/FIwWRVv9Dfq9i2rWLxoGu1Do0wyYHoYK
         iUQFdMcGCoqYvRLgIqdjeSvfS4xwLoaBpenmM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=85UmCqjB/2q4FemAi0uqOHeKcTywLVBMQcPg1IVAqAM=;
        b=dPRSKQMfgO5BTrVG+j0aY2YeaTpil+oiSa6on+fck6enG7CcXf3gEbnseYmF2UzE4S
         uoEfpYG2szU1Ccn0qqaKm6nvCExEKnpU/Kd6JDF2pWPHaY7iGvzWmTqMWA4igB959qj4
         rs3JlNhLyYZlv+L3Q5iL140XrH9C+t9i0mB2OxR5BQ5ijXWQK7btMcBQIIBhv5QkbkG4
         xUutouuMn04IyV/mdeHS4ynu9dAqLQ+ryJcuVLFktvuWsD/y5klXX0pOe3f+mv9sekNy
         GrdNaUm4BnpJisRri+vnrFnrZXfVJDw9oLUmRJZnp4fRiNfTJEyORpa8ctrfu2mJSls0
         wLQw==
X-Gm-Message-State: APjAAAXNpumRvmZ9Ir0aYDpEMpiRpNnZkaHAdl+uYCzjnLl4yrUWw4+X
        n6LtXE/xvzshcUWmEzRuN/RRX5e6jLGpYw==
X-Google-Smtp-Source: APXvYqzIMxgXlOTdo4m8VF3Ksi0pmsLJDIqlKPFVSelHYIH0PbCG3pg3PScZRGP+zhtfti6ZKyzEKQ==
X-Received: by 2002:a05:600c:2388:: with SMTP id m8mr85591wma.23.1561491771995;
        Tue, 25 Jun 2019 12:42:51 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedb6.dynamic.kabel-deutschland.de. [95.90.237.182])
        by smtp.gmail.com with ESMTPSA id q193sm84991wme.8.2019.06.25.12.42.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 12:42:51 -0700 (PDT)
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
To:     netdev@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v2 07/10] tools headers: sync struct bpf_perf_event_data
Date:   Tue, 25 Jun 2019 21:42:12 +0200
Message-Id: <20190625194215.14927-8-krzesimir@kinvolk.io>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625194215.14927-1-krzesimir@kinvolk.io>
References: <20190625194215.14927-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct bpf_perf_event_data in kernel headers has the addr field, which
is missing in the tools version of the struct. This will be important
for the bpf prog test run implementation for perf events as it will
expect data to be an instance of struct bpf_perf_event_data, so the
size of the data needs to match sizeof(bpf_perf_event_data).

Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
---
 tools/include/uapi/linux/bpf_perf_event.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/uapi/linux/bpf_perf_event.h b/tools/include/uapi/linux/bpf_perf_event.h
index 8f95303f9d80..eb1b9d21250c 100644
--- a/tools/include/uapi/linux/bpf_perf_event.h
+++ b/tools/include/uapi/linux/bpf_perf_event.h
@@ -13,6 +13,7 @@
 struct bpf_perf_event_data {
 	bpf_user_pt_regs_t regs;
 	__u64 sample_period;
+	__u64 addr;
 };
 
 #endif /* _UAPI__LINUX_BPF_PERF_EVENT_H__ */
-- 
2.20.1

