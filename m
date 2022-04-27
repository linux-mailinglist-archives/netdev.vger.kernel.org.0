Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E0B511988
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235733AbiD0NQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 09:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbiD0NQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 09:16:52 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6081B8295;
        Wed, 27 Apr 2022 06:12:59 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g20so1890388edw.6;
        Wed, 27 Apr 2022 06:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vuIsff87ALefijT05zxCKdqr80dXhi87dosPw80x4gc=;
        b=O9p24mrXUv60CAJt3qAcRAqRkDMq78u0XMBuSTRxdiP4HxXCv8JyATpS24r1jjvmMS
         mhkJbSrPGodE5A89kc9flBzdmXDOt6FuKJrhfZAF+cNBp6eZkg63RftSyPGyhevalBMU
         /fS2fcrfnbglOmvPbhyazCyJ/Pzn7p8WCUBQTFLEEYkOyOHMhHNDrQ/cCdMzqSZQFd5S
         SkpuK+GmoqwdOyrdEN4TEc3vgfFvPU/zeIPSiROVQFymvLVdSIq1CNZK1Bf8eecWgrmx
         hlHaYMUL/D73p8QXMb2qb+kTC1hy5JULCGaGrIb9Ar0R0SjcgWK/HpWLn+I92X5PBFHb
         MK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vuIsff87ALefijT05zxCKdqr80dXhi87dosPw80x4gc=;
        b=ZgAitxG78FFPlns1EFU7Aj30FqWaGwWiqdq2DGYjQHENbtbuhPkzMENAeA0ej28sOo
         /hb3Z0DBHCK6MsUo3IBJVQWI6AT3ZVy6E2t0CYZFPyjGUiNMS/bsZRzSkt6nxuHoIV0/
         KNGaRvU+Q/oHuz8Pq+sk74oXyOOHbS4tVPXR5997KWxhav7nqRgugdRdFqwkk9s/MmlU
         i7TG1DRDbFNkzHPFUZgyGFJVJ95lq7+48IkXaFeCf416N/9IFrBnsnrI513fyttli0Vw
         Je2qIDihf1JBVlkB4yAFuaiU8jCOOGsnD+7UFpcqVH6aHB9sffDHS0tmgAbbnz9vxEes
         s8hg==
X-Gm-Message-State: AOAM5324SKFpYn9FCEmAwbBBKuzVSfMTyfWksB93Ime1LBsTXWBIz03B
        3j+/LUhsBNq6MaLl8bgaHXc=
X-Google-Smtp-Source: ABdhPJxGMGBd3LAuuUpGQRWYmS6mqgQG4kw1WUUet+hwK1HwTy2HVr8ldPt0SgnQ2k1KIjHfHNPSqg==
X-Received: by 2002:a05:6402:3042:b0:426:1906:6daf with SMTP id bs2-20020a056402304200b0042619066dafmr2257326edb.406.1651065177897;
        Wed, 27 Apr 2022 06:12:57 -0700 (PDT)
Received: from anparri.mshome.net (host-79-49-65-106.retail.telecomitalia.it. [79.49.65.106])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906124600b006e843964f9asm6668987eja.55.2022.04.27.06.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 06:12:57 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Subject: [PATCH v2 1/5] hv_sock: Check hv_pkt_iter_first_raw()'s return value
Date:   Wed, 27 Apr 2022 15:12:21 +0200
Message-Id: <20220427131225.3785-2-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220427131225.3785-1-parri.andrea@gmail.com>
References: <20220427131225.3785-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function returns NULL if the ring buffer doesn't contain enough
readable bytes to constitute a packet descriptor.  The ring buffer's
write_index is in memory which is shared with the Hyper-V host, an
erroneous or malicious host could thus change its value and overturn
the result of hvs_stream_has_data().

Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/hyperv_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index e111e13b66604..943352530936e 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -603,6 +603,8 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
 
 	if (need_refill) {
 		hvs->recv_desc = hv_pkt_iter_first_raw(hvs->chan);
+		if (!hvs->recv_desc)
+			return -ENOBUFS;
 		ret = hvs_update_recv_data(hvs);
 		if (ret)
 			return ret;
-- 
2.25.1

