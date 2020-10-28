Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDD929DC20
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388965AbgJ1Wim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388951AbgJ1Wib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:38:31 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F609C0613CF;
        Wed, 28 Oct 2020 15:38:31 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id x203so1236078oia.10;
        Wed, 28 Oct 2020 15:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oRd9D9KAGEvSUVDHFx51Z3pe4W3JS4rlMi+zj5tnu1o=;
        b=E8ql5xGfRHpoTKr5i0U4XM9uzxC6u2e9Cg3/yWktFZDdSuRO6Udnjb7bA3rCe9EnUG
         8cIQMmKu7BUC4a0CJ8oFGmBVSKHR0QRNlTOVJQG4a4IhAJW2NHV1grRhMQUmzccVLcC9
         onsJs2Ihyxv3p5mJNwmpmmsx9jMdvIbYUgH1mvLb2cogBg8iLX58dBUz+r82kCKHVvnb
         XumzNtq+C05tnupu1y3h8jPs/EIisyHYrMzfPJ+h0052DweivHzgByZDQi8JNFRKysny
         FHHfLpjyjztIKOBRKGcDOuk6qtN2e+9lTmDCOG764V61f0M6J7B3i0hqr0ttd07PAhbv
         8LMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oRd9D9KAGEvSUVDHFx51Z3pe4W3JS4rlMi+zj5tnu1o=;
        b=qVh3tAo0s2weUv26rBSWrKJXKFS0KIK9QXJgu1sEQfRg1Bza+gJ84GIh/kbsx9oJfS
         KUCxWJ3YanUEC9HYtMVe8AV6pYcnOQAz3FrmJJB6Hf8hCp/K/QWbHOVGdr867XFuap7y
         kZFGBvgkcOztNEinfs8yNY0eS6yHuHcGKt4nLGfh61z8cqb2y1K+KNKe/Zq5k8xHzuGR
         D8bRk/5yu7xLBwveJoYl4wQ8WRqtQU4XMng7bdSon/H0mGu0DJmZax3OgU8WQhFUptI/
         fH/UJNS263LLUWdJI5Ao59mRAaxsWkh56YFtyd6gM7DXu3NV4g6zghFzfzzm4RqwU/qz
         i2Iw==
X-Gm-Message-State: AOAM532XU2g56jSzPmCWHxYCKFfObNFTVl2No6024+DUU8jfLpj1GPjb
        Z2g+nDf2afvUXgo/5QNUAjIRvVhyeNlFYbj8
X-Google-Smtp-Source: ABdhPJw08anLcn91mXmmfsPzN+W5dpD39hXzuhPgRbUE4/T21wkwPxdeaE55dA/3l8zuJN2Sj8xr2A==
X-Received: by 2002:a17:90b:23c2:: with SMTP id md2mr2718827pjb.205.1603892156901;
        Wed, 28 Oct 2020 06:35:56 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q14sm5935393pjp.43.2020.10.28.06.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:35:56 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next 9/9] samples/bpf: add option to set the busy-poll budget
Date:   Wed, 28 Oct 2020 14:34:37 +0100
Message-Id: <20201028133437.212503-10-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201028133437.212503-1-bjorn.topel@gmail.com>
References: <20201028133437.212503-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Support for the SO_BUSY_POLL_BUDGET setsockopt, via the batching
option ('b').

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/xdpsock_user.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 7ef2c01a1094..948faada96d5 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1482,6 +1482,11 @@ static void apply_setsockopt(struct xsk_socket_info *xsk)
 	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL,
 		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
 		exit_with_error(errno);
+
+	sock_opt = opt_batch_size;
+	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL_BUDGET,
+		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
+		exit_with_error(errno);
 }
 
 int main(int argc, char **argv)
-- 
2.27.0

