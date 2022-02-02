Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA0C4A6BBC
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 07:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244754AbiBBGwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 01:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiBBGwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 01:52:37 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDB3C061744;
        Tue,  1 Feb 2022 22:02:04 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so4977943pjb.5;
        Tue, 01 Feb 2022 22:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=86IjzIpCbQx4czdgL/69qWfwpQP21WFfHd9YXZh8XRw=;
        b=LeIrzLJObxSs72D/KdtETdQKjYBNu/IrnjPlyp9LwGAzy4f9mZtURT72piZm85Y+Z8
         ZMBz6CFZgtZOWKLkeMDp8ZPeYgZsV8NJP5GLlOj26mAk6TrKGu/PIe1K7zB5WM2/H7P5
         di+XRjU7brf0F8IzfceTD3yiSac9H3zbAFOgACf2dgRNsOiPWuzWZZRD/mQXxoNAbx9E
         w01UDu58+X4p626MoOKGjC/hy0zXk6lSFMGR9itkRcHqdWkonqrofkKdrWCgJZUHlp7j
         zWHRqvosewZi1i0Kzwvg6MipUCdgR/GqdDA8Lu0ClseSixlNtSF1IGrezzYVve7W4kwp
         GEJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=86IjzIpCbQx4czdgL/69qWfwpQP21WFfHd9YXZh8XRw=;
        b=HI8lEv1yRp7Btg8GQPm/C/+jycswByrNM0MkJ3L157mlUJpTdZ52HkIKrbOJIh3e7e
         5OEZQenZ1c1iBMLsdedbsElwbDBq1ALg6RfHlO5m2VbuBQ6Pi8qeJQyRHrW/zl42FRbj
         GwyDSfpWFtbD/5M3h+whpz5hiUTLRPLr0bUU/8UXMU9SASlU5+l6GpvwImo7epLUOtyT
         nEU+zujg/FxS3VR5p6IDxTvKDuzTmbH6md0TZzUWGZoxTFw0A5qqCHry0+HlImU7nzwb
         XMJLbGs+NJ0n1K2yh+wuy0TPbgd/cuKV8oEyXbpvBgIPq3kwlbd7V6dljJhqHEBHKDfp
         Gvew==
X-Gm-Message-State: AOAM532BGJiW3BLVo+WFymFoNdVhDZnLXw0/7cRbCUVumrSm62ss5wAI
        PpRInenx0N6YDfNd07ezArw=
X-Google-Smtp-Source: ABdhPJyzzLECPZy3zC9f9DjxNP3VLhjVdkTULNfdJDRxtTDoaoSVAWOWqFONU5DJpmkYfuKNa/h1jA==
X-Received: by 2002:a17:90b:f92:: with SMTP id ft18mr6527137pjb.113.1643781724046;
        Tue, 01 Feb 2022 22:02:04 -0800 (PST)
Received: from localhost (61-223-193-169.dynamic-ip.hinet.net. [61.223.193.169])
        by smtp.gmail.com with ESMTPSA id l21sm23843863pfu.120.2022.02.01.22.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 22:02:03 -0800 (PST)
From:   Hou Tao <hotforest@gmail.com>
X-Google-Original-From: Hou Tao <houtao1@huawei.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, houtao1@huawei.com,
        syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com
Subject: [PATCH bpf-next v2] bpf: use VM_MAP instead of VM_ALLOC for ringbuf
Date:   Wed,  2 Feb 2022 14:01:58 +0800
Message-Id: <20220202060158.6260-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 2fd3fb0be1d1 ("kasan, vmalloc: unpoison VM_ALLOC pages
after mapping"), non-VM_ALLOC mappings will be marked as accessible
in __get_vm_area_node() when KASAN is enabled. But now the flag for
ringbuf area is VM_ALLOC, so KASAN will complain out-of-bound access
after vmap() returns. Because the ringbuf area is created by mapping
allocated pages, so use VM_MAP instead.

After the change, info in /proc/vmallocinfo also changes from
  [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmalloc user
to
  [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmap user

Reported-by: syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
v2:
  * explain why VM_ALLOC will lead to vmalloc-oob access
  * add Reported-by tag
v1: https://lore.kernel.org/bpf/CANUnq3a+sT_qtO1wNQ3GnLGN7FLvSSgvit2UVgqQKRpUvs85VQ@mail.gmail.com/T/#t
---
 kernel/bpf/ringbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 638d7fd7b375..710ba9de12ce 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -104,7 +104,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
 	}
 
 	rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
-		  VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
+		  VM_MAP | VM_USERMAP, PAGE_KERNEL);
 	if (rb) {
 		kmemleak_not_leak(pages);
 		rb->pages = pages;
-- 
2.35.1

