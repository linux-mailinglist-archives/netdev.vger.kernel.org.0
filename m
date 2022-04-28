Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66C3513758
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbiD1Oyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiD1Oyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:54:44 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0E75C853;
        Thu, 28 Apr 2022 07:51:29 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l18so10048174ejc.7;
        Thu, 28 Apr 2022 07:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vuIsff87ALefijT05zxCKdqr80dXhi87dosPw80x4gc=;
        b=PstODrS9isMX6NHMixerP3v6KE5/4KrHAUXQKcTvx5lkKrEVb/g2ukG4fHldglpVun
         rTVT9xe6GxBlc8KDvz5SLHuiKFZ5bSevL7Zh6fdIY6j3GXCI0t8ivIZvE9tyttg055jh
         KHDGYaypWpdMQeFXAwLFi0jmHUsfBcEfE4perTsJq8OmRO6XBsS+nDAapDQkfCoUtSIK
         QoiEF0ErqgmotE7DKu02YgEH6BUouVqQQCSHZCuXnhhj6T4RORamSymNyqBzB4PtmdbB
         ECVPm9y+KBogeetoaQWScoJQfPDuZrBTlE7awUW4wMbkRsYa2NhvSHp95eUOfFkaufnf
         ykkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vuIsff87ALefijT05zxCKdqr80dXhi87dosPw80x4gc=;
        b=xS92vSnMt3ioYAju0bCHCdMfdXf8mb4rgzXw0EFTuuazspBAbgi1AeTd6VRv3ZD6YL
         0wWe4XA6UduViyOQIWgvmI5HscSaQ4W6CqpZH5aTQbkyJqaj6TV6bJ6a3ncWhqKE4Ho3
         /jGYXx07jbvBT/Ujgz1CmxSOO4Ewe96yDzPHNZYwjqePmXtyWkuRjZXO++d9VFigSSJX
         MHO+nNCqb15XtxYIDL958B71C3yL1+kRWbdfGEKB3DTs3J6CxAQNcRgZaFOfpFTXCVYI
         f3DCqG64EwB1yoXhKQvTwrsWjomXX7PMogAWSM09VdTqLwAhA1Hj7PcFE6uBcJI6tO47
         ZRpg==
X-Gm-Message-State: AOAM532U6Jl+ue0tHayeQdRy4hPEQdYSdsWP4SRdGamI8wuqnvb1xVnt
        /uI7oFamcJdNNZ6q1C8l8o0=
X-Google-Smtp-Source: ABdhPJyWKoDRWtnsnCacA/1k6ig5YP6Iu6E9yfNfRPhRAc2DeNw/Ayi7I+PHkRNxj32Zb91VlUymtw==
X-Received: by 2002:a17:906:1ec3:b0:6cf:d118:59e2 with SMTP id m3-20020a1709061ec300b006cfd11859e2mr32140363ejj.767.1651157487582;
        Thu, 28 Apr 2022 07:51:27 -0700 (PDT)
Received: from anparri.mshome.net (host-79-49-65-106.retail.telecomitalia.it. [79.49.65.106])
        by smtp.gmail.com with ESMTPSA id x18-20020a170906b09200b006e8baac3a09sm61616ejy.157.2022.04.28.07.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:51:27 -0700 (PDT)
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
Subject: [PATCH hyperv-next v2 1/5] hv_sock: Check hv_pkt_iter_first_raw()'s return value
Date:   Thu, 28 Apr 2022 16:51:03 +0200
Message-Id: <20220428145107.7878-2-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220428145107.7878-1-parri.andrea@gmail.com>
References: <20220428145107.7878-1-parri.andrea@gmail.com>
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

