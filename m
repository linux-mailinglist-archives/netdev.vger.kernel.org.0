Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F51BAC75
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 03:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391392AbfIWB5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 21:57:35 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44398 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390768AbfIWB5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 21:57:34 -0400
Received: by mail-qt1-f193.google.com with SMTP id u40so15322808qth.11
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 18:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2CN1OMlv3/7cpKw80LjZF0euVZRhjEEAvzzA6QEdbVM=;
        b=dNr9ymPQO/Qj42HSWShGpnunPyoJrvcS26Ai0a3TzRaHAK9O/KqTkR3fJv7NP2QwTy
         hganrrtjhyWYr1vcCFlsAFJOLZSBm51CNAfmkD0VIoMr/f8MB0Jl2lqtr2QDuXdhPRM9
         Zu+zAJnRuTT5yjEe86zKiRzF9diJ78oaIo09yF+KBt1QlGxWJOH2HMm6TlVbMUYKFDME
         LI5PwD8Aml8rKj86Us9ue1SQPmwV0AotkUgxrsPdBLj9FEeLhX/mQuLLUqYB49uwPFkM
         j8/idS/qYeoEiPkbKmRCPHrf0xLs76/+x1OuDhhzvd5LTqbY+5qCpUyHu7bqhV8/PdFy
         s5Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2CN1OMlv3/7cpKw80LjZF0euVZRhjEEAvzzA6QEdbVM=;
        b=Fsw0SfHJGsaScCSMsHlc2KfJxvoWhKoeBpB7S6Wiu9aFwXa0Itu+Ra0CjNbw20MrOA
         asSviwL0ciGjzGteExgIAxpGwJ5yMj5olFOqydIbfcLl0cVT08BBth/979sIHDyZzcz8
         ORT39mvZD9Nv4Q98Hk7s0rIdhkVYyDlI/14pzyYm9zrDyFQWSj+EW2zuWQE0V3nYHqFz
         S7n9DoPxr3pc5bEA58jg6BkNzJ5mlBbgh/CwSSjdhG+onqCZu4IxPcG6eA/jLfngw/zv
         OFe0nPt4ote8nkMz2scHHNYtdBn5MSHfTg4u2icC4v9AcBE26RsHpVUKHuNTHkGKJz8+
         51fA==
X-Gm-Message-State: APjAAAUTDOV0MFBdalYxCXL0R9ve7lzIuJDYIOtDp1qUTKn4Ss98Z8lH
        kfW+/11eWjhJ/mJ1mn831WE1ZRYlSpA=
X-Google-Smtp-Source: APXvYqyRmg/OjGNoa2ugcfGZBG3hggsLAwoSER4sQmHPcOGi/Yfs0+yR7+zjGRC5T8eAghnXMgg8GA==
X-Received: by 2002:a05:6214:1231:: with SMTP id p17mr22984751qvv.170.1569203853575;
        Sun, 22 Sep 2019 18:57:33 -0700 (PDT)
Received: from localhost.localdomain ([2804:431:c7ca:1ddc:74b0:dcaf:993f:ef5c])
        by smtp.gmail.com with ESMTPSA id b22sm4574905qkc.58.2019.09.22.18.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2019 18:57:32 -0700 (PDT)
From:   jcfaracco@gmail.com
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net: core: dev: replace state xoff flag comparison by netif_xmit_stopped method
Date:   Sun, 22 Sep 2019 22:57:29 -0300
Message-Id: <20190923015729.10273-1-jcfaracco@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julio Faracco <jcfaracco@gmail.com>

Function netif_schedule_queue() has a hardcoded comparison between queue
state and any xoff flag. This comparison does the same thing as method
netif_xmit_stopped(). In terms of code clarity, it is better. See other
methods like: generic_xdp_tx() and dev_direct_xmit().

Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 71b18e8..a8ecf88 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2771,7 +2771,7 @@ static struct dev_kfree_skb_cb *get_kfree_skb_cb(const struct sk_buff *skb)
 void netif_schedule_queue(struct netdev_queue *txq)
 {
 	rcu_read_lock();
-	if (!(txq->state & QUEUE_STATE_ANY_XOFF)) {
+	if (!netif_xmit_stopped(txq)) {
 		struct Qdisc *q = rcu_dereference(txq->qdisc);
 
 		__netif_schedule(q);
-- 
1.8.3.1

