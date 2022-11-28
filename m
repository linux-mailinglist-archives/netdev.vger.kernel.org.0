Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE72B63A6C1
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiK1LHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiK1LGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:06:38 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331811BE89;
        Mon, 28 Nov 2022 03:06:21 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id b12so16208105wrn.2;
        Mon, 28 Nov 2022 03:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6iLk8852vtQEeRyzsaRteWTAegVVqHjjadFAfVEwt3Y=;
        b=Orw6aFNaIz7/TraaFmAgXgtB76WVcJhDFUvvxun+WHHodMNW2JtT2phavw7PiK72Wo
         sqC+b/x6UHoMjnF4xE5rYrB66Mhb4eCxyHcGmwO/Jh2O7eQ2/CreTjRfT57ok5RMZSmj
         viYzsSuH7vh1p5ASXoTVDpNDR1oPyAgU/xBauD16Jzk0H8nKMIOF2/jkmGK5drlT19aq
         FBGCklq7iA4yEAI+v/wVUHfjiSzaTMHhEM+JvONb4BS8+e0f1XjN0M4oQnlvL84szzOh
         vObFc/MLy3t14CPOzM8IhHVI+ldhGG3u9jmtF1uavBbcIHunBx0qRdFTHzlVTaK+jIUZ
         DZbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6iLk8852vtQEeRyzsaRteWTAegVVqHjjadFAfVEwt3Y=;
        b=TIX5QSM1UxaEbYjzw2eQdOKeNqyCIyIZYDPeIAb2kKuo0rIxvUvNvf7Md0fRuaDTak
         ZxC1IFStXrnsA2+f3jObtzlX/fk3hJOiV1wnjjrYLXA0KC1cESlPBuh/fywjhIByDp4Y
         1PwuGvpH6AF+BUzp4cdLGWs9gnCNaQ3tMhlKUpk5ZJagmTUzlaxIDkARr0R7OXq+ooIr
         YdacZEsljIMnae/E7WgT/T8LzgRKmMPYW/kC26VoJcsJAgIeBIo2bbTiZMPAm/k+kf6m
         Y8ViS4VPO/j+1fEfntsWzireaImC8FKyHI3RR/r55RLsbTaLJba1eU7RqrjL4N8OnK8q
         Csuw==
X-Gm-Message-State: ANoB5plRKh6Z9FFyebsqJTwYeQs6LCvMJktOoyc0jvEIgdAC0Trdq/LR
        o6plO8uLWFNwiZYasjiG+FC88P62cUYK3gpf
X-Google-Smtp-Source: AA0mqf7Kga97e3nbxNII2NffGTNFS+oOycuWq26k9TBDyf8xJYo5p3Ts0UdRDuPE9XYOWcpzdqFKnw==
X-Received: by 2002:adf:b610:0:b0:231:9b9f:652b with SMTP id f16-20020adfb610000000b002319b9f652bmr23716989wre.421.1669633578651;
        Mon, 28 Nov 2022 03:06:18 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id c4-20020adfef44000000b00241ebd3c221sm12285567wrp.27.2022.11.28.03.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 03:06:18 -0800 (PST)
Date:   Mon, 28 Nov 2022 14:06:14 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next v2] bonding: uninitialized variable in
 bond_miimon_inspect()
Message-ID: <Y4SWJlh3ohJ6EPTL@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "ignore_updelay" variable needs to be initialized to false.

Fixes: f8a65ab2f3ff ("bonding: fix link recovery in mode 2 when updelay is nonzero")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
v2: Re-order so the declarations are in reverse Christmas tree order

Don't forget about:
drivers/net/bonding/bond_main.c:5071 bond_update_slave_arr() warn: missing error code here? 'bond_3ad_get_active_agg_info()' failed. 'ret' = '0'

 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c87481033995..e01bb0412f1c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2524,10 +2524,10 @@ static int bond_slave_info_query(struct net_device *bond_dev, struct ifslave *in
 /* called with rcu_read_lock() */
 static int bond_miimon_inspect(struct bonding *bond)
 {
+	bool ignore_updelay = false;
 	int link_state, commit = 0;
 	struct list_head *iter;
 	struct slave *slave;
-	bool ignore_updelay;
 
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP) {
 		ignore_updelay = !rcu_dereference(bond->curr_active_slave);
-- 
2.35.1

