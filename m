Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0C4500034
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238742AbiDMUuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237733AbiDMUui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:50:38 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAA471EE9;
        Wed, 13 Apr 2022 13:48:07 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b15so3897619edn.4;
        Wed, 13 Apr 2022 13:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f1sb4UJO60vFzMQ7jSbq55RolpNBURxLc/zOFDSJzng=;
        b=RZHBRZwdWQj4k166dR00upgLdsBBe5YQG0YMmIxueE8ZdGl7slEHuajU9J58ek4IU4
         aUo8x9QIOO//Ygo7SvIOrbz2eHEOg1wWzUVnYA1kVNmrPhIw5mV8oIPkoSVF5/fiqR3c
         4UrFripKq7coAIlwM6QqMxcV7r1q/QTGGmoOK2S1DP+VGtnAS+YYADLhV1O9wzrEypVm
         GKnATg8rr+EucS48uRGjkyVm3NWZ9XlAZhMm5SeA+baTyxmNzXSIq6WV3Xy02e6M3UBN
         H3Jfm6/1somOLOl3mrdGFjrriz//+hoPyf4Jy5ueG3yZvSdQaDzKpsUA7t+bvJcKhzKO
         KHng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f1sb4UJO60vFzMQ7jSbq55RolpNBURxLc/zOFDSJzng=;
        b=ND9ZZvN0I764QE7ofq3vj3B+oLKAfpQXzF/kPl6BE9T0lPa4Lfs5d2U+dXm8W3QcqT
         v+/aYeZP4UESDbFuf2XJEnZKN8ed3wKdhxcjnR+luKFc7TM+ZJDzpPWuClRqNpLZ17kh
         TVZk36nRLFop3UVkjuGf+UWE5MFm6oODmATvvUMmswwRNGPjxrn3oQd9XAzXLDOA5+p9
         l9pXThV7pI+Sbwf5YzAdNhp6jMjCmhDokU5wlMIrcEpOoSinki2/GhAJrA78zA23TvOW
         m4DCC93gH5rXWo3Hqs3Yq8MxDc5lojy+yeBiEqDOlL56E4BCuXklcwN2888a1xF00eU8
         wu+Q==
X-Gm-Message-State: AOAM530GZX+MN0/3/De+FQ8F5/oAwcc1SPozEYc43mmlMFjACtuP2xmu
        gwDUzTS+lgpdWl/4gERo4jM=
X-Google-Smtp-Source: ABdhPJxZ9PWnW1BIcct9QDxfoPrYL/4Isc8Lg5OgyZOPAZr2NRGisB65l3qSSHAgI4rVCfM1ObtBAg==
X-Received: by 2002:a05:6402:1112:b0:413:3d99:f2d7 with SMTP id u18-20020a056402111200b004133d99f2d7mr45665365edv.23.1649882886236;
        Wed, 13 Apr 2022 13:48:06 -0700 (PDT)
Received: from anparri.mshome.net (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906408600b006e87d654270sm5021ejj.44.2022.04.13.13.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 13:48:05 -0700 (PDT)
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
Subject: [RFC PATCH 4/6] hv_sock: Initialize send_buf in hvs_stream_enqueue()
Date:   Wed, 13 Apr 2022 22:47:40 +0200
Message-Id: <20220413204742.5539-5-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413204742.5539-1-parri.andrea@gmail.com>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So that padding or uninitialized bytes can't leak guest memory contents.

Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
---
 net/vmw_vsock/hyperv_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 092cadc2c866d..72ce00928c8e7 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -655,7 +655,7 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vsk, struct msghdr *msg,
 
 	BUILD_BUG_ON(sizeof(*send_buf) != HV_HYP_PAGE_SIZE);
 
-	send_buf = kmalloc(sizeof(*send_buf), GFP_KERNEL);
+	send_buf = kzalloc(sizeof(*send_buf), GFP_KERNEL);
 	if (!send_buf)
 		return -ENOMEM;
 
-- 
2.25.1

