Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953575962B4
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbiHPSwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236056AbiHPSwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:52:03 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8365382F8F;
        Tue, 16 Aug 2022 11:52:01 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id z16so13647490wrh.12;
        Tue, 16 Aug 2022 11:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=LelQJvF7zxFbcLTMVJBAC3ic54PTqj8BI7T6uO42R/g=;
        b=Jxur5a7liBp1PmhjSOcKVdU6u6dilPcqzQOqarV3aWjxxH51gEsLKvWlFjN3EWFBXO
         BBNILfQtiFUHfDtwQZKw2sGfxi3I8QYLd0qkkjwNgrge2VU/qRN5SQmzQGrA+onAgY1z
         d1ID1LAwkKtznqESpJSwQNFf1fSpcyzAtOG2q3UVhQyXVl2ow6feR3433o28fvAP5qT4
         tbav2ZS49sK4W7AtL+re2ihcdqZEKnFT6aIP5P3PSM+DEnwqpdk/HC/8aCTFxuQiYj09
         pJdZXemzm8GF7vbjBNMEqK+oslPblhQX2NzuvvUigB/n5taGdbVoO+GptZlGIhqiVY46
         w4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=LelQJvF7zxFbcLTMVJBAC3ic54PTqj8BI7T6uO42R/g=;
        b=mkyZ7d7JjX3mfAZJcDAsWWxugX9MMpxpyr3qCTONSV7FH3RhnKph6uycLGbboJeUzO
         7JHnFxShfUPDa/MZzcAmaA/Kb6VeCAs+6T+FZhTvdHhfj3BPHbgKAlY9Azxpg7XdB0Z9
         tr0dTPKyQvpMMfou39Yl11A7BSUo2yVnyleFCDmlXF+Ul2e4KzXcdmuyA5yrlEeTebu0
         QM78Zu5mAfjasT1gkWDP7hjUJnd0jbD1ZU68OCVYI6vu61Vac7RANONqKVH0Am+WEQlp
         1jkNlOqVR48szhycBtM5HaRcp3v5U+pM9yFM/PKbAZSO6g/ZcSwk4n/7uDfR49JSMeHh
         txeA==
X-Gm-Message-State: ACgBeo01zCLqf/LG/y6jgVhnl5u+TwSk+jcMunyIOfG2tryEiu8bwxDU
        TGLYKBhz9vlJU+5NIWA4tmE=
X-Google-Smtp-Source: AA6agR5Xu+JSG852gTLLjB/bAlqsZ5gPzyFWqiPlrvSCB+sbcSVVsbR3uvyMBpWuQzW3a6h44Luobg==
X-Received: by 2002:a05:6000:1704:b0:220:69a7:ec2b with SMTP id n4-20020a056000170400b0022069a7ec2bmr13047367wrc.436.1660675920042;
        Tue, 16 Aug 2022 11:52:00 -0700 (PDT)
Received: from bernard-f6bvp.. (lfbn-idf1-1-596-24.w86-242.abo.wanadoo.fr. [86.242.59.24])
        by smtp.gmail.com with ESMTPSA id c3-20020adffb03000000b002206236ab3dsm10897159wrr.3.2022.08.16.11.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 11:51:59 -0700 (PDT)
From:   bernard.f6bvp@gmail.com
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Osterried <thomas@osterried.de>,
        Francois Romieu <romieu@fr.zoreil.com>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        Bernard <bernard.f6bvp@gmail.com>, Bernard Pidoux <f6bvp@free.fr>
Subject: [PATCH] rose: check NULL rose_loopback_neigh->loopback
Date:   Tue, 16 Aug 2022 20:51:40 +0200
Message-Id: <20220816185140.9129-1-bernard.f6bvp@gmail.com>
X-Mailer: git-send-email 2.34.1
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

From: Bernard <bernard.f6bvp@gmail.com>

Since kernel 5.4.83 rose network connections were no more possible.
Last good rose module was with kernel 5.4.79.

Francois Romieu <romieu@fr.zoreil.com> pointed the scope of changes to
the attached commit (3b3fd068c56e3fbea30090859216a368398e39bf
in mainline, 7f0ddd41e2899349461b578bec18e8bd492e1765 in stable).

Above patch added NULL check for `rose_loopback_neigh->dev`
in rose_loopback_timer() but omitted to check rose_loopback_neigh->loopback.

It thus introduced a bug preventing ALL rose connect.
The reason is that a special rose_neigh loopback has a NULL device.

This is shown in /proc/net/rose_neigh via rose_neigh_show() function :
...
	seq_printf(seq, "%05d %-9s %-4s   %3d %3d  %3s     %3s %3lu %3lu",
	   rose_neigh->number,
	   (rose_neigh->loopback) ? "RSLOOP-0" : ax2asc(buf, &rose_neigh->callsign),
	   rose_neigh->dev ? rose_neigh->dev->name : "???",
	   rose_neigh->count,
...
/proc/net/rose_neigh displays special rose_loopback_neigh->loopback callsign RSLOOP-0:

addr  callsign  dev  count use mode restart  t0  tf digipeaters
00001 RSLOOP-0  ???      1   2  DCE     yes   0   0

By checking rose_loopback_neigh->loopback, rose_rx_call_request() is called even in case 
rose_loopback_neigh->dev is NULL. This repairs rose connections.

Verification with rose client application FPAC:

FPAC-Node v 4.1.3 (built Aug  5 2022) for LINUX (help = h)
F6BVP-4 (Commands = ?) : u
Users - AX.25 Level 2 sessions :
Port   Callsign     Callsign  AX.25 state  ROSE state  NetRom status
axudp  F6BVP-5   -> F6BVP-9   Connected    Connected   ---------

IMHO this patch should be propagated back to LTS 5.4 kernel.

Signed-off-by: Bernard Pidoux <f6bvp@free.fr>
---
 net/rose/rose_loopback.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
index 11c45c8c6c16..1c673db52636 100644
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -97,8 +97,10 @@ static void rose_loopback_timer(struct timer_list *unused)

		if (frametype == ROSE_CALL_REQUEST) {
			if (!rose_loopback_neigh->dev) {
-				kfree_skb(skb);
-				continue;
+				if (!rose_loopback_neigh->loopback) {
+					kfree_skb(skb);
+					continue;
+				}
			}

			dev = rose_dev_get(dest);
--
2.34.1

