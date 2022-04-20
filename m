Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2972F509119
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 22:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382022AbiDTUKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 16:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382013AbiDTUKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 16:10:30 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F7345AD7;
        Wed, 20 Apr 2022 13:07:43 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id c64so3726359edf.11;
        Wed, 20 Apr 2022 13:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ya9mQeUeUB7WEvwDQ80duVGGhzEqxRrCrwLr6kr2uRY=;
        b=ZKS2ydxS6tFvgbDiBJy7q6iN9T3Q+XE4WVaeTcv7ov/eSt1NMkiVNfgJML6tC8RQHn
         urwVbyW3xxUn3ATkvgMWcRubNcX9QeyW/lyav3Mt29EzY/jDP9boNSDx2B4lF2QZgoAJ
         QqaSRg/5F+dkNaoUeadx52EPZqrWwJtbXu/Fyt4h2P50of1eVJxhwWEK4wBDn0c2Fw3Y
         lMtfK8LwM2gbVlNmzKPH1xPASPv5k+Z6Cbb8ZV7NyMxBKkfLS1d/Zovy23Invx8X8iWu
         tiTfqtIs5uSXdM4s2JL0C0S30OnNjwKirCxEGWvtkgSHUGvuFaPddRkk3dX/vwcYiMe3
         ahew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ya9mQeUeUB7WEvwDQ80duVGGhzEqxRrCrwLr6kr2uRY=;
        b=W2hy4lckk/F13Y5gY0vAWxVTCG/DaeOxWQk92JoNlxcavkPIqHdCJzeVoZa128L28D
         zFCP/9VjtztOYf1VGy3RFpMUMe4sIJEf/6rIUStoo0AS9Hpm39HXzsap42A6gLtgVUkg
         KgkEc8vdleknpCDYQlEIh4/Y2cypG3zEDD5ynWvsKnhFBq5q5bwqwKOOXkF9qHqBJsSG
         umX8iMF8Xz9cGrO7KYoZY1+qtlMVNt4+Oz0JlD7LsDCA05HVjP1Pv7tGpOuQLFEmHApI
         Zr/v5lzESxSHKOUV/DI3OQ6Qg0vyzjSazQHfNod0gYlTXVboAv+j316A2UQYfCd/DfCz
         Vbnw==
X-Gm-Message-State: AOAM533L2B9m5zkSmkG2aeuYcZpHD1JyDaGlvkEGE91jSBuIPt6JqOvl
        Z8ksmcyPW8cTT+EJQYm0yU8=
X-Google-Smtp-Source: ABdhPJytSsdi2FdWcWY6CE3Rnp2Uru41znI43WCdX8sm1eWT0BlveISbbim0Sap/Sp4S/LYDvTL3CQ==
X-Received: by 2002:a50:cc9e:0:b0:41d:7123:d3ba with SMTP id q30-20020a50cc9e000000b0041d7123d3bamr25412837edi.296.1650485262173;
        Wed, 20 Apr 2022 13:07:42 -0700 (PDT)
Received: from anparri.mshome.net (host-82-53-3-95.retail.telecomitalia.it. [82.53.3.95])
        by smtp.gmail.com with ESMTPSA id gy10-20020a170906f24a00b006e894144707sm7126853ejb.53.2022.04.20.13.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 13:07:41 -0700 (PDT)
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
Subject: [PATCH 1/5] hv_sock: Check hv_pkt_iter_first_raw()'s return value
Date:   Wed, 20 Apr 2022 22:07:16 +0200
Message-Id: <20220420200720.434717-2-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220420200720.434717-1-parri.andrea@gmail.com>
References: <20220420200720.434717-1-parri.andrea@gmail.com>
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

