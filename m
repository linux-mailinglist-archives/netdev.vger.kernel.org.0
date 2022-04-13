Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44E6500031
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237621AbiDMUuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236542AbiDMUuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:50:22 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D111050470;
        Wed, 13 Apr 2022 13:47:59 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id i27so6337859ejd.9;
        Wed, 13 Apr 2022 13:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oxLePFx8Fq+seNMfUwSyI5u63bTK2hgBeAnss7OXaN0=;
        b=P6SkBP367S2Wp+x5uEk/qbytSNXaoctYO0Fs/wz777P5X/JWy1eSevGHT/qeATov3u
         mKxhtC+RJDsdTgpXDVjgh+wUCPfPVw+YrN4QM5rnvYUCNmHsY2HMq8ZmoVuliY/qcKl1
         tK4zq2HmlV4iHpftiMzSo0PPXn3M7lr1XiivqQC81tkhskpZsr6MCcYUkTJHBuwErMom
         Z/yf+7opoG/GVSw34U0wgUGc0DShk6J2LtMTqieywmJZ1ghu1vv5yxE7cbNArPgQohqC
         9UZ+oPW2yQh8lPAua5tj3zJKHK1PzB5bf9rzaufmJh+wD4ffS85kZIsxz7AYlzp5PzXn
         iZ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oxLePFx8Fq+seNMfUwSyI5u63bTK2hgBeAnss7OXaN0=;
        b=RSFuv/fyKOgGDZMiVUEDVVUOEO9mrGO7vgOv6fyh6Wjyx6n2mBCnsf0GJl0bOAhKbT
         MNXLuA3CTzAbQMZkHdk3RaAvbY9aIhzg8llIP7XqaB009F8NnnWaMF0aaJQO6VUJQRcl
         w5e8UcuO58nyl/awKXyYO7jvyKwH6HV4GMcJA+vB/cnWl0Yvb7hUzoIhEKFsECqujTA+
         JY1JJVi6i6KUiSbMjZA48zR2iIBJ/WkamgaT0TAkTDOmMo/VCoCpWT/PJGywuLBZQYDi
         CYE4sbJfo/b6K6Oy1rPA0zDiCPq1GFzKDhQzApegJ4WFW0KHGDc7/ic/lK5ZC2R6HP55
         mfRA==
X-Gm-Message-State: AOAM532h7of2DJeeMHjS9KWlvEYq5Q7IvkauONrH8dFDt5GkRnH9b5yA
        xp4cZyAmCRWhFmp6Pns0c4w=
X-Google-Smtp-Source: ABdhPJy9KVgC2+Z9Gy9D7Asn3JZZ4Lzh6ZOIFUPmZraohLsVbU/W03klYluTNkoIIzEOiozU5K53dw==
X-Received: by 2002:a17:906:c091:b0:6db:62b6:f4cc with SMTP id f17-20020a170906c09100b006db62b6f4ccmr40828985ejz.607.1649882878370;
        Wed, 13 Apr 2022 13:47:58 -0700 (PDT)
Received: from anparri.mshome.net (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906408600b006e87d654270sm5021ejj.44.2022.04.13.13.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 13:47:57 -0700 (PDT)
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
Subject: [RFC PATCH 1/6] hv_sock: Check hv_pkt_iter_first_raw()'s return value
Date:   Wed, 13 Apr 2022 22:47:37 +0200
Message-Id: <20220413204742.5539-2-parri.andrea@gmail.com>
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

The function returns NULL if the ring buffer has no enough space
available for a packet descriptor.  The ring buffer's write_index
is in memory which is shared with the Hyper-V host, its value is
thus subject to being changed at any time.

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

