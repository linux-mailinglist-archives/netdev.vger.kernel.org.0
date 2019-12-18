Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA74D124128
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfLRIMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:12:32 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46412 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfLRIMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:12:32 -0500
Received: by mail-pg1-f193.google.com with SMTP id z124so830377pgb.13
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DF7jBgX2467hTXDcH/0UhMHJAOIjVESG6Cy9niUYFmA=;
        b=WArwdnopsB9lDwZYb7InrFQWetYpDG7hwYm33RJmLAWesPAapMkPKZL3HS5G/seC42
         kwNAAXgqdt+tzr2M4laTaxVGfOdKL2dP9zXt1fs75qMM+MRU/nsjAsWvrvGipAkB0cWX
         W/SLhB8/N2NtinqtGA6ucykfDxrAWFht6EKO4E6y9X5b0kofwsWBpwMRRK+7hs2D5YN/
         phoOxRhbnF/snPLhfz7JsjBTqimJeMdGM5skURDLMgrCXX5nrT/sSgd7zHsQaXwulRi/
         VjbQe47HjBSifdS6jgvdhN61QC2SlMyc+fVngjD49UWvdnMkdG4wN976mhFZGAVlG9s7
         7L2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DF7jBgX2467hTXDcH/0UhMHJAOIjVESG6Cy9niUYFmA=;
        b=Bnu4c0BB/ObBR0JNGpYrsB6CfZi3O4HyDGFM+lZ/PlRtIPWG25hNmJ1BNyrw06eNwR
         wSc1pxkstwJUwJm15A4BZXW32TB56FHvqxiwTroxs5D73bwR5BjlLwQA+J2zMqf4JkdB
         iGKg+Vu1RagEVxm58K5iKZLhaoReylYLEcLGbmv2RV9N8r9/U8TAw/u6O9nsH7/8JURu
         wep9Aqpnk0dNuYPo95LncgVHq1MzDPxFugzeCKzQ7IXBAfERdodNIDXOHAdzmXCD+44u
         43vBAQrVFsJns2lGzqUssnjAakBOLOuLKKMa1SxGEpocn5sKIjSl/qM6XriktDXNAMFS
         X1/Q==
X-Gm-Message-State: APjAAAURNRtRG8FU9YExTEk1v0bclYCZ2zN8c1p0XXWahwrTfp23AtI8
        PlqlfKgcXPAm2oUyv8/4l54=
X-Google-Smtp-Source: APXvYqzNpKuTzJkxPQ/MFX1sLHiIfy9TfwOLRBFCheK1SyvtfPJHMQVPtVYifk19Ihzj3aWnxmezFA==
X-Received: by 2002:a63:465b:: with SMTP id v27mr1608634pgk.257.1576656751672;
        Wed, 18 Dec 2019 00:12:31 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:12:31 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Subject: [RFC net-next 05/14] net: core: rename netif_receive_generic_xdp() to do_generic_xdp_core()
Date:   Wed, 18 Dec 2019 17:10:41 +0900
Message-Id: <20191218081050.10170-6-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

In skb generic path, we need a way to run XDP program on skb but
to have customized handling of XDP actions. netif_receive_generic_xdp
will be more helpful in such cases than do_xdp_generic.

This patch prepares netif_receive_generic_xdp() to be used as general
purpose function by renaming it.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a46db72759cf..6bfe6fadea17 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4461,9 +4461,9 @@ static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
 	return rxqueue;
 }
 
-static u32 netif_receive_generic_xdp(struct sk_buff *skb,
-				     struct xdp_buff *xdp,
-				     struct bpf_prog *xdp_prog)
+static u32 do_xdp_generic_core(struct sk_buff *skb,
+			       struct xdp_buff *xdp,
+			       struct bpf_prog *xdp_prog)
 {
 	struct netdev_rx_queue *rxqueue;
 	void *orig_data, *orig_data_end;
@@ -4610,7 +4610,7 @@ int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 		u32 act;
 		int err;
 
-		act = netif_receive_generic_xdp(skb, &xdp, xdp_prog);
+		act = do_xdp_generic_core(skb, &xdp, xdp_prog);
 		if (act != XDP_PASS) {
 			switch (act) {
 			case XDP_REDIRECT:
-- 
2.21.0

