Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615BD5A5FA0
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiH3Jjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiH3JjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:39:18 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939264BA68
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:37:37 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 145so10431933pfw.4
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=klXqMBTglR/zDSbdWU27CzNQYcUu/px+eqBjURCfBMM=;
        b=EWfRMTtwV9YV/hiSiCrUst32WxCdGm6WnBcNb9TK8Xgb5MjvfpvLdJetdrPNHCbTGV
         AJXvuQALYrvqxk8ErlcoU89JOLSWQtxKIDadQNQhsCWcWBSWt7ypepiEAQ1+Bsvru3E9
         ucit09cT20W6sjI/YN1XNMhgE7ARkorClqLF6RXYfYoQTasqIYOi9a0xwgKAO1EQFKnT
         eZcTp+recCdkjk3KDpWEb2nQNP3ggzmfNbJtTH0x91au3uBpEi2gh8o+i9VON+SrZ9SS
         IRXrcIBuw566qyPp2A68Rm5dx5+ABUfYIGiTbT6so86jtHpkduJi6YM3mQLrxYF9fzun
         Aiqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=klXqMBTglR/zDSbdWU27CzNQYcUu/px+eqBjURCfBMM=;
        b=FOuwNM6Ad79Pk0+5Eaku2maE0/o8Y8gP9UkAFoVuGVgSYXX9YpmKT/mZ5Al3UZpoci
         hL7hKacUM3GMWzjMoWoLSarBIFVnkKqsoT05KQFenol/3YQrYj7OK7vnbdUFJheHfnim
         SaTBGgvW3qpgtebgUhuVBBo9zMEkvubnSzITKX3VSehHxGB+ItIUPttS+DBzAXeQFrO0
         fxklMb1FSXBz/TwFfRYv1GUPfZwTuP53It9Mx4pB+xFgBEuRKY56bQwVhZJiMa9h43MQ
         iJBEFSp+Px8yxEFvPvqkNyfVSolCfTKcwCvOljVCFc936D4e4l3L0L8GZJLUdUf+v0Bx
         iQQg==
X-Gm-Message-State: ACgBeo2saUqcAYCLW2cX0sVhhkFlRiQzFpBMpkvyQhGD8W0hZSFQcSZZ
        Xv0mmFJLAd9mnqecqBNcGhqdkd7rqE+4hA==
X-Google-Smtp-Source: AA6agR5qZjXj6iYejq++nNV9MWwdcHM19+MXcJRqU1RoIeSoL8/GlHFNLHVhKYnOaLNOSlVsiDH53w==
X-Received: by 2002:a05:6a02:205:b0:41b:96dc:bb2a with SMTP id bh5-20020a056a02020500b0041b96dcbb2amr17509528pgb.116.1661852256932;
        Tue, 30 Aug 2022 02:37:36 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h187-20020a62dec4000000b0053639773ad8sm8899393pfg.119.2022.08.30.02.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 02:37:36 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, LiLiang <liali@redhat.com>
Subject: [PATCHv2 net 1/3] bonding: use unspecified address if no available link local address
Date:   Tue, 30 Aug 2022 17:37:20 +0800
Message-Id: <20220830093722.153161-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220830093722.153161-1-liuhangbin@gmail.com>
References: <20220830093722.153161-1-liuhangbin@gmail.com>
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

When ns_ip6_target was set, the ipv6_dev_get_saddr() will be called to get
available source address and send IPv6 neighbor solicit message.

If the target is global address, ipv6_dev_get_saddr() will get any
available src address. But if the target is link local address,
ipv6_dev_get_saddr() will only get available address from our interface,
i.e. the corresponding bond interface.

But before bond interface up, all the address is tentative, while
ipv6_dev_get_saddr() will ignore tentative address. This makes we can't
find available link local src address, then bond_ns_send() will not be
called and no NS message was sent. Finally bond interface will keep in
down state.

Fix this by sending NS with unspecified address if there is no available
source address.

Reported-by: LiLiang <liali@redhat.com>
Fixes: 5e1eeef69c0f ("bonding: NS target should accept link local address")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2f4da2c13c0a..531c7465bc51 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3167,6 +3167,9 @@ static void bond_ns_send_all(struct bonding *bond, struct slave *slave)
 found:
 		if (!ipv6_dev_get_saddr(dev_net(dst->dev), dst->dev, &targets[i], 0, &saddr))
 			bond_ns_send(slave, &targets[i], &saddr, tags);
+		else
+			bond_ns_send(slave, &targets[i], &in6addr_any, tags);
+
 		dst_release(dst);
 		kfree(tags);
 	}
-- 
2.37.1

