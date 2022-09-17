Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798015BB78A
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 11:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiIQJ3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 05:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiIQJ3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 05:29:08 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BD045980;
        Sat, 17 Sep 2022 02:29:07 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s206so22525633pgs.3;
        Sat, 17 Sep 2022 02:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Et7gBu6ryTbMxL9W4K1dknNDV6Bh5mogJwEgrQ9HyMI=;
        b=LipLgafZvrL2VEaSmQL7+o+PSML3/68XhPiDignY/W6GKY4u/Q01k/GuiGVL2i1LKZ
         OOoQqCLRdK0ZIRgDDHY5wvvoZdsE7ZRy6ODO3EqvPMihs0+yYQqUwm7jhs0SnSe2V/Oj
         stDHl6HlsExGQ+8yXdYs6Q8qUAoGD/dTEq68t82hWsGYDkEQTE113NLF8U6xTwJp4SBp
         vPgoE9aFTd4/wJpB07se43siAkBiQwtGkC6EzsqwA+hJ+buq6pol+B/hfl4axIOzmpAG
         jqKZiTHl3sFDSfonMNzoaXaBQEzEOcIvc4ps9ZeSPoIZZbCzBRXwnANGSJROOWubiw22
         YTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Et7gBu6ryTbMxL9W4K1dknNDV6Bh5mogJwEgrQ9HyMI=;
        b=ZTepRCMQK1W4zvspKCsZAtfHnyIVPez/ySHq53r0Ul+uP3Sm/eiZ7tvZj3MmRaAS5P
         /uo9dW9kNsJzgxbOcewC2SlMFn6pQANdWcZitQXVF20hDoe+1ShmBiWgcuEwDOHI75c1
         C0Uzw8fdHE8vlw8Q3uWLqEiXai6RdKB5/4IrXdW1Gx2XruMo99WJEw7IurmiwKmFZ6k6
         HYSJeaMJs/Qcw1reF9ucPiGtGsMFUe5U3b2KECi0i858bu/cW4XndPralTvgp1QyusNX
         q9WN3+Kk3srrIVdRKG1Qarun3jtldkbAsSQaQSUFIN5kI//aibZXPsJ5+6sljGyBzRoH
         bTUQ==
X-Gm-Message-State: ACrzQf3QVt5mqV1MnhJOUf00Q7c6VGxTJQzXb5FvNiriSxJroQpm/xeW
        qZ4JIFazofitaolJkKG4ls0=
X-Google-Smtp-Source: AMsMyM6di36+LY/c8LYOma+I6cMbaWh8B9mWpmcC7+a/6d1pqEBMBjdYrWhelYNHMUvnZJvx4GIdgA==
X-Received: by 2002:a05:6a00:1312:b0:536:fefd:e64a with SMTP id j18-20020a056a00131200b00536fefde64amr8776021pfu.26.1663406947070;
        Sat, 17 Sep 2022 02:29:07 -0700 (PDT)
Received: from localhost.members.linode.com ([2600:3c01::f03c:92ff:fed5:2c62])
        by smtp.gmail.com with ESMTPSA id a2-20020aa79702000000b00537aa0fbb57sm15959450pfg.51.2022.09.17.02.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 02:29:06 -0700 (PDT)
From:   junbo4242@gmail.com
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc:     Junbo <junbo4242@gmail.com>
Subject: [PATCH] Do not name control queue for virtio-net
Date:   Sat, 17 Sep 2022 09:28:57 +0000
Message-Id: <20220917092857.3752357-1-junbo4242@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Junbo <junbo4242@gmail.com>

In virtio drivers, the control queue always named <virtioX>-config.

Signed-off-by: Junbo <junbo4242@gmail.com>
---
 drivers/net/virtio_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9cce7dec7366..0b3e74cfe201 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3469,7 +3469,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 	/* Parameters for control virtqueue, if any */
 	if (vi->has_cvq) {
 		callbacks[total_vqs - 1] = NULL;
-		names[total_vqs - 1] = "control";
+		/* control virtqueue always named <virtioX>-config */
+		names[total_vqs - 1] = "";
 	}
 
 	/* Allocate/initialize parameters for send/receive virtqueues */
-- 
2.31.1

