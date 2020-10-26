Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DF5298A67
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 11:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769853AbgJZK3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 06:29:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1769844AbgJZK3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 06:29:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603708191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=2eg5gLkK3IN2TrtgtWoIls6yWdwRGx6m5adarIfK+A8=;
        b=SaQrDPD7CEv6NBnaL5QHSLiL/Hco0jDOGi55Fwy1jCZzQX7A2sZUsdEp3vHhmDoZb18ZJ8
        MIAp163wGoJ1Wa5HePxH5209ET4u7I8xC5bMvNyfGWs8Trtq036zxuuxSSjtfcSDuzDXzW
        zQsYEX5iocYZ+qzU4XpY1Wf8NEhqwDw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-DSG_LSS8Maik2p_Re5df3w-1; Mon, 26 Oct 2020 06:29:49 -0400
X-MC-Unique: DSG_LSS8Maik2p_Re5df3w-1
Received: by mail-wr1-f72.google.com with SMTP id t17so8185426wrm.13
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 03:29:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=2eg5gLkK3IN2TrtgtWoIls6yWdwRGx6m5adarIfK+A8=;
        b=f8EkbXlwYh3/z+O0s9C/ic6Xr5KkQYeetok6vrss+EZ3YxcqgdqbxLVeUCyuSaBKkf
         ZyMloMUFo9kF5WXVuSAfd5oHm6PKCWoRXdAFP98M7j+5/b/mgx1wRrSN3tzkvpavRpfS
         jrVA9DXBC6Oy58B1YkgENrDY9O0q9oabF1tF43TwN8Ba3Seu2qZFLsuPupJTEkNNVAx4
         xwLobErkAW4nkVjA40p8j3t42HsDZ1DZgFVslCU2LKa/eEgHugSQolB4oek22sGRb1nK
         OP+fQuI04EckovloOnIdrMDrtmWjnPEJgDFXG42JPnBWjtyTxhp8QkbDCJ1ABZijQ3hB
         Xw7Q==
X-Gm-Message-State: AOAM530gbW5sKoaC3F/jxBh4ZtVKubaA4sd8igBhEtzixXAOjKy/wpZW
        YkHIOpUaBlzf/AUiFGR2s7INwh7TnHteSGeJRGkskynYembkL6xllJys4+eAmA48YeRzrsMGvVv
        K3N+YHABURZf0r00h
X-Received: by 2002:a7b:ce8f:: with SMTP id q15mr15359208wmj.88.1603708188311;
        Mon, 26 Oct 2020 03:29:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkqJ/3Vi/XEWJX71lJNK3dccODCkr4/dTsxKQbVu+9c3ISYMQ/83JWUkvcRZInJrfN7otOSg==
X-Received: by 2002:a7b:ce8f:: with SMTP id q15mr15359184wmj.88.1603708188025;
        Mon, 26 Oct 2020 03:29:48 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id f5sm19346708wmh.16.2020.10.26.03.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 03:29:47 -0700 (PDT)
Date:   Mon, 26 Oct 2020 11:29:45 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Alexander Ovechkin <ovov@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net] net/sched: act_mpls: Add softdep on mpls_gso.ko
Message-ID: <1f6cab15bbd15666795061c55563aaf6a386e90e.1603708007.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCA_MPLS_ACT_PUSH and TCA_MPLS_ACT_MAC_PUSH might be used on gso
packets. Such packets will thus require mpls_gso.ko for segmentation.

v2: Drop dependency on CONFIG_NET_MPLS_GSO in Kconfig (from Jakub and
    David).

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/sched/act_mpls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index f40bf9771cb9..5c7456e5b5cf 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -426,6 +426,7 @@ static void __exit mpls_cleanup_module(void)
 module_init(mpls_init_module);
 module_exit(mpls_cleanup_module);
 
+MODULE_SOFTDEP("post: mpls_gso");
 MODULE_AUTHOR("Netronome Systems <oss-drivers@netronome.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MPLS manipulation actions");
-- 
2.21.3

