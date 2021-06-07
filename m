Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC2D39DD4B
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 15:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFGNKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 09:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhFGNKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 09:10:32 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FDAC061766;
        Mon,  7 Jun 2021 06:08:40 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id k5-20020a05600c1c85b02901affeec3ef8so2304222wms.0;
        Mon, 07 Jun 2021 06:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Blqm8HDtxq2DCywo/otFV5fX8E6HMxdWztbHqtnhcQ4=;
        b=cYn0h2r3Og5Kv2IB6Ch8Nef2WtD0NS5tR8Qkw7JnR14mhvVUZDuDHssVmMhj9L7cYM
         ux8F7ZiQjdEfpB7ImquMEGAMOO65OGLlqggEBz9eRIDUfv5FNxNMNFtq7SMVxcdrn+eB
         UPaGR6Izbcnzx9JvyoY7OKihWxzQBIlrk04+lXeF+HdpjaWOStxVMBmr5lDj5NjTfwbA
         R1YoRphDY+m5urDxK7QGmBpLHuLinklwEgs5sLY/xvZgexrKqWIW14C0db3nI6Mkdmme
         Oesv6G8v+nLJ4gK5h2fSBchW3xDqbEt5dwAdi80/koq05EzZR2Q8Nfxvj2LG69YHoWwZ
         rCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Blqm8HDtxq2DCywo/otFV5fX8E6HMxdWztbHqtnhcQ4=;
        b=eNJZbj5GgLVxTGDxJIb3XvbVRGaWbnyOgFcZyn/aj/VkGm3irJFe8eX/l9kamANwev
         3RKbcZBKWWA9sEazQYMuZDATI6H0jDHrdy8j4ZzXe9QLMLgPyzM83pDsw6hFwYvVDCVa
         CK2buQixwtZOqgozbSQ3QE4vAdwG+munxeQfLxV+Dt8SKSh2CrBFgd32kA2SXvoLRHpT
         LAO9ZguOJh2nm9w82cyW5IDgQnW27MmXfEzz1srBN0aCWVjZ3YzaeYdzY9bG+U8YINBF
         IRH7EtxiLgKPlUdxsW62vFPREXLIrfY9ppwuMfSQXR8B2CbhBvYr0nJ8HWl++zLLU0Kf
         C40Q==
X-Gm-Message-State: AOAM5314P+jntL59w+UWd3XpPdniiECRAMQOwa9bFUJ0MO+VncLNvcyV
        V8d8VD3aBmm069O9x8RKwPo=
X-Google-Smtp-Source: ABdhPJxeGzMQVek2rzeTsU89oXk+OB6CMX7fRQTS8ECgarjAh0DmuwMBrb4/CptbA5tB8XsMg8do3Q==
X-Received: by 2002:a05:600c:204:: with SMTP id 4mr13651408wmi.95.1623071317518;
        Mon, 07 Jun 2021 06:08:37 -0700 (PDT)
Received: from linux-dev (host81-153-178-248.range81-153.btcentralplus.com. [81.153.178.248])
        by smtp.gmail.com with ESMTPSA id p187sm14802839wmp.28.2021.06.07.06.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 06:08:37 -0700 (PDT)
Date:   Mon, 7 Jun 2021 14:08:35 +0100
From:   Kev Jackson <foamdino@gmail.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] libbpf: Fixes incorrect rx_ring_setup_done
Message-ID: <YL4aU4f3Aaik7CN0@linux-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling xsk_socket__create_shared(), the logic at line 1097 marks a
boolean flag true within the xsk_umem structure to track setup progress
in order to support multiple calls to the function.  However, instead of
marking umem->tx_ring_setup_done, the code incorrectly sets
umem->rx_ring_setup_done.  This leads to improper behaviour when
creating and destroying xsk and umem structures.

Multiple calls to this function is documented as supported.

Signed-off-by: Kev Jackson <foamdino@gmail.com>
---
 tools/lib/bpf/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 6061431ee04c..e9b619aa0cdf 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -1094,7 +1094,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 			goto out_put_ctx;
 		}
 		if (xsk->fd == umem->fd)
-			umem->rx_ring_setup_done = true;
+			umem->tx_ring_setup_done = true;
 	}
 
 	err = xsk_get_mmap_offsets(xsk->fd, &off);
-- 
2.30.2

