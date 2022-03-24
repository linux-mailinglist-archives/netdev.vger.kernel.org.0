Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D3C4E5F19
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 08:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347468AbiCXHKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 03:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239320AbiCXHKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 03:10:13 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFE298582;
        Thu, 24 Mar 2022 00:08:41 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b15so4528149edn.4;
        Thu, 24 Mar 2022 00:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2DIzib4o08iye1kgkTSG9/ojDh+JAr+HPIElFaP/bcc=;
        b=lCt1RxMJ8zVYgbMpVAzhxiZ+KgXTt3FIQ+H89ZtLkKjrJv8w9eNH6KMwtYvtj0uExe
         UZn3pEZaC3AIqEE4+pWQkIAZ7ZrvcNbzH5dSG3fiib5d79iTSZhT69z7PrzcERJzJDNc
         3AOqoHYV4FPfo/VS+S1F2UdiTU9olX8B1f/CMNdFJf8UwSeOWNhUW9NMekVC3GmjGUtw
         /wcr5dFrrFGLa3xkuxoAyNxrVP1zc0Kj7okXMZYS748aapUQltGkHAij6675zRIquCLx
         79xFJ0XwnTgY8P1OMsZWMAPXjRr3C/RDx6gZpZ0Eyr/tSwVKf6lB/fhxxTZxZaCHTE3K
         CUTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2DIzib4o08iye1kgkTSG9/ojDh+JAr+HPIElFaP/bcc=;
        b=meGu1iKHuj2FlCWYCWfJt/4xyN0rMaqxQ85Cad+lYEwLu503GmrWg9DZ7e0IwS/4R2
         GiSFcbMGb9OzEV/60ILSUzdRy0Ekrz5XELxafvyl8T5ykZ0sJ4OgK4DiSRy/vAM2JejB
         FHtILsdMCc3WB5lgUH8XufjweGdKWOG94OW5CLwus7q8jC40fYiTih8kiZ7+1YAzjS1g
         9ljUUuRz+zh+0JOLK+o1jondCa3mkuH4feiUMzxsQIcbBMcc83JLZqKZIc/TxF151G/7
         b3x+Er3NJSJtqbKM5kzAp52dNc5g/7EkesbYcuV+SBsLXaAF5j4K2TMnLiv7rLGb7Ds9
         VWRg==
X-Gm-Message-State: AOAM533PN06hiRkO9UYe22nPuJNYHtV4HDslmN10TIMV20aOZ2f4i/Ew
        geAj+/YG1bjXl2FuQEeTXxg=
X-Google-Smtp-Source: ABdhPJyGuOyR40tiN+XJl/Z+fRAxZlJTj44MIkp0nzo3GoVPoeQNYup2mTfdo8v+ARKWzr7xiqqi6g==
X-Received: by 2002:a05:6402:506:b0:419:46b2:2433 with SMTP id m6-20020a056402050600b0041946b22433mr4938255edv.21.1648105719877;
        Thu, 24 Mar 2022 00:08:39 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id o2-20020a50d802000000b00410d7f0c52csm1011976edj.8.2022.03.24.00.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 00:08:39 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jakobkoschel@gmail.com>
Subject: [PATCH] bnx2x: replace usage of found with dedicated list iterator variable
Date:   Thu, 24 Mar 2022 08:08:16 +0100
Message-Id: <20220324070816.58599-1-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
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

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index c19b072f3a23..fe985ddb35db 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12971,20 +12971,19 @@ static int bnx2x_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid)
 
 static int bnx2x_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 {
+	struct bnx2x_vlan_entry *vlan = NULL, *iter;
 	struct bnx2x *bp = netdev_priv(dev);
-	struct bnx2x_vlan_entry *vlan;
-	bool found = false;
 	int rc = 0;
 
 	DP(NETIF_MSG_IFUP, "Removing VLAN %d\n", vid);
 
-	list_for_each_entry(vlan, &bp->vlan_reg, link)
-		if (vlan->vid == vid) {
-			found = true;
+	list_for_each_entry(iter, &bp->vlan_reg, link)
+		if (iter->vid == vid) {
+			vlan = iter;
 			break;
 		}
 
-	if (!found) {
+	if (!vlan) {
 		BNX2X_ERR("Unable to kill VLAN %d - not found\n", vid);
 		return -EINVAL;
 	}

base-commit: f443e374ae131c168a065ea1748feac6b2e76613
-- 
2.25.1

