Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A5E63A2B9
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 09:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiK1IVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 03:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiK1IUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 03:20:45 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E6A1704E;
        Mon, 28 Nov 2022 00:20:33 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id n3so15482136wrp.5;
        Mon, 28 Nov 2022 00:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qSIbdQeQLc1B6fZDwz85ioJ0LOXvlrrzDAmnKikBfF0=;
        b=NwL/5dEuggm86DTrBCWMUdvqPs2+LVBGByIglS7sm3G0+vlGhXnMVLgQrf8n8EFyJC
         HW5izUDuVo/Sq6ThdRlec5rYWst/HjY5vtsWolt3M3JVTB27AZJuNM6TtVqBnRgS6rTQ
         HmSIab1PZAKykrqYD4ljI3cxsiLZRsxeXFNnz1smkj6MY2iCRbAJNKfYZELFXBijBUoI
         L7m5Dg4lpXDHLgtRTpyzQCapdmbRQ1PZz2yxqZJnDAlwHUbCmHyw2bveWsWkOyr1OHPu
         MnJ4lut9Avqwa0WvfSUn0ZY8HYd8bStxGwFYrVIaA5OiqesPm4iWyj//W8r6jAqSajZJ
         SWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qSIbdQeQLc1B6fZDwz85ioJ0LOXvlrrzDAmnKikBfF0=;
        b=4rdMMjukxHieo+2C5t38ZPwosKmK3TrlLsqzLdhr+VreZQtibM+Vdo+HtrFZ9WJD5a
         XDaDMGnQ1lhJmyy8nfyn2C1j0aYeX8Ehcvo1AuqVQHupRoYmba4lmnjYANLK07ukOjlx
         CqWRkmvCCNfXOatDTxH7eKXWv3Iuf7JXS/IiCiiVfTryulOVZkTPjyl7jPrNWyTmCI1v
         Q1KuGwzzHDEOrxFHVPAa4cn3nzBEgrhiCInazOvAcucGgS0yYdE4LZXd49QGvyCAdTTG
         pwkK8gKPVkV0l5spzKzFgpgoJ46Qq9ozxN7ln3gMoPgJJGHP0RIsNMgY4l/gAx7xVg98
         DyGg==
X-Gm-Message-State: ANoB5pmYDAditaigdW/J4znrssLwA/BhlctpMnuyc27P3trb7Ksg7pxO
        0eXtrLAlUDe8O2b/TNXBbFI=
X-Google-Smtp-Source: AA0mqf6aji4/cGcIbRAqRw4P6sBoRN0HKEiHun0VEl6pEwIos6LTLsQdy30HlrAYjW1M8L4Nz7R9zQ==
X-Received: by 2002:adf:ea44:0:b0:242:19b2:f1fc with SMTP id j4-20020adfea44000000b0024219b2f1fcmr1221218wrn.593.1669623631507;
        Mon, 28 Nov 2022 00:20:31 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id r6-20020a05600c458600b003cfd4a50d5asm18664171wmo.34.2022.11.28.00.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 00:20:31 -0800 (PST)
Date:   Mon, 28 Nov 2022 11:20:27 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>
Cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] bonding: uninitialized variable in
 bond_miimon_inspect()
Message-ID: <Y4RvS7Bns4Q8MorG@kili>
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

The "ignore_updelay" variable needs to be initialized to false to
prevent an uninitialized variable bug.

Fixes: f8a65ab2f3ff ("bonding: fix link recovery in mode 2 when updelay is nonzero")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---

This was found by Smatch.  Another Smatch warning that might be worth
investigating is:

drivers/net/bonding/bond_main.c:5071 bond_update_slave_arr() warn: missing error code here? 'bond_3ad_get_active_agg_info()' failed. 'ret' = '0'

I don't know the code well enough to say if that's a real bug.

 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c87481033995..8a57a5681461 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2527,7 +2527,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 	int link_state, commit = 0;
 	struct list_head *iter;
 	struct slave *slave;
-	bool ignore_updelay;
+	bool ignore_updelay = false;
 
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP) {
 		ignore_updelay = !rcu_dereference(bond->curr_active_slave);
-- 
2.35.1

