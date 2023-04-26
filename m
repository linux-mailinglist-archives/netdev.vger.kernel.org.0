Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3C76EF012
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240111AbjDZIQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240108AbjDZIQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:16:44 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7D93AA2;
        Wed, 26 Apr 2023 01:16:39 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b7b54642cso4948141b3a.0;
        Wed, 26 Apr 2023 01:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682496999; x=1685088999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uovfg71uf8r2RO7wNvMppfAd1Z3lZTe8QqzmEQHrYGA=;
        b=Hpv9JJ3VLh3ng4QBtXXmSMHqr5AuecTf9YOUOmFFRhA2P+QsjhpfRhc4FssgKySlYY
         HFdww9aYhGJPZcE8vYhlTQZe3lrBucaTilkn4GBGMrjnFTsdccnzrldyyxeyflWexRqU
         HvHK1ZhrgHQ0hEaT0pXumwA1cqNr82H2hMLz30glFiF6drVUDuJOXh+4OrAOp4OLDgg+
         jKYDV4w0AkOVgXRx42pxd9+gegagQzeTrMQXYFoRAIZOBLSWeQJN5wpteespZl0rFpMf
         71yAYyJ/mzSEZgTIyfvEhMD5xd9TTrEroHPbC5zlND33j4N2sKkrzNpvtvtJ8lt+WMiR
         o5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682496999; x=1685088999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uovfg71uf8r2RO7wNvMppfAd1Z3lZTe8QqzmEQHrYGA=;
        b=S7e/E1Hlc6geNI2gIdpAeUP48ow6rRJYN4a7l45NVyjBnirMg+EYWLXw35G4iK71G9
         L198O5G5Uh6F1NRxjntW6bzlkFoe/DRL6/WyhI5CAMfysPqF+NBw42A+ZZ6DR6N6OYPS
         n218P6oaIxX2Z8fSepM2vMbqwqKJAWW7vi/Ntve5wiNS6CBk4q23yLLab+G8cjPRcBxu
         I3ro+sv7t0QGLRGQ0ITasYk87JpGW3iZF5d7Q+eo7NUIinHb4gIWPZyt6yJRCa8ink47
         SLYIY2/JU9Cl3KNV/yyT/NKOii9acO+IqpkMmdzh895bW7KZRXu3ww2pzm9hYnlRjm4t
         gbLg==
X-Gm-Message-State: AAQBX9cS3fhgonPvhHGq7UKIUb200v1KpbiEZsQltqj4tNezXsJhptaa
        dkOFJIgGqZIXuoT2uwP0DPom7R81dv0=
X-Google-Smtp-Source: AKy350b0eKm/EkkPtSxU4AK1IDZbhezeix7msW2ZwD5QKNhQHalXGrA/LZyyCd2BQH+qRgf99bCK6g==
X-Received: by 2002:a05:6a00:1990:b0:63d:3d2b:a7ee with SMTP id d16-20020a056a00199000b0063d3d2ba7eemr28478320pfl.18.1682496998889;
        Wed, 26 Apr 2023 01:16:38 -0700 (PDT)
Received: from cosmo-ubuntu-2204.dhcpserver.bu9bmc.local (1-34-79-176.hinet-ip.hinet.net. [1.34.79.176])
        by smtp.gmail.com with ESMTPSA id b4-20020a62a104000000b0063f0ef3b421sm10107504pff.14.2023.04.26.01.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 01:16:38 -0700 (PDT)
From:   Cosmo Chou <chou.cosmo@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sam@mendozajonas.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        chou.cosmo@gmail.com, cosmo.chou@quantatw.com
Subject: [PATCH v2] net/ncsi: clear Tx enable mode when handling a Config required AEN
Date:   Wed, 26 Apr 2023 16:13:50 +0800
Message-Id: <20230426081350.1214512-1-chou.cosmo@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230425083842.65873403@kernel.org>
References: <20230425083842.65873403@kernel.org>
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

ncsi_channel_is_tx() determines whether a given channel should be
used for Tx or not. However, when reconfiguring the channel by
handling a Configuration Required AEN, there is a misjudgment that
the channel Tx has already been enabled, which results in the Enable
Channel Network Tx command not being sent.

Clear the channel Tx enable flag before reconfiguring the channel to
avoid the misjudgment.

Fixes: 8d951a75d022 ("net/ncsi: Configure multi-package, multi-channel modes with failover")
Signed-off-by: Cosmo Chou <chou.cosmo@gmail.com>
---
 net/ncsi/ncsi-aen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ncsi/ncsi-aen.c b/net/ncsi/ncsi-aen.c
index b635c194f0a8..62fb1031763d 100644
--- a/net/ncsi/ncsi-aen.c
+++ b/net/ncsi/ncsi-aen.c
@@ -165,6 +165,7 @@ static int ncsi_aen_handler_cr(struct ncsi_dev_priv *ndp,
 	nc->state = NCSI_CHANNEL_INACTIVE;
 	list_add_tail_rcu(&nc->link, &ndp->channel_queue);
 	spin_unlock_irqrestore(&ndp->lock, flags);
+	nc->modes[NCSI_MODE_TX_ENABLE].enable = 0;
 
 	return ncsi_process_next_channel(ndp);
 }
-- 
2.34.1

