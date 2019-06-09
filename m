Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A61F3AA8C
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731902AbfFIRTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 13:19:18 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43337 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729277AbfFIRTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 13:19:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id i189so3896545pfg.10
        for <netdev@vger.kernel.org>; Sun, 09 Jun 2019 10:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VOA+z+jGkv5MT303wn1Ym/wuSaJNCg2BrjPXz+dA91I=;
        b=Rr58f2ncR/UkjyZV03o0J9oVL2pZq8mTbtLy/gBSpmBgcm8gG2bQYUM+IxvKNMc8hu
         EYYusOZG7yPnllFU7L0waRaVDrsoMUR/cgPmbzyHwVWeYsAyDLnCv+CQwguu90u/hKT3
         UucbdWFGU11Libqqhjvqh/QABoxLqzIn/9oXs2MvT+PhMWgQ1Hf85RoOvrN83VmkRq3r
         sVlNZAC9BIiJwp0ki6DzPMK7xIasXDFst6sBy4kZeqbrcfqh2q6cVhvDNiiY6MkXX6j0
         B4Q0O+BFDZUQ/gT7niB542REXN4dexALv3054BLQsWZ0Y8FZu4MzWZt54piA1U/WUjNt
         Ih1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VOA+z+jGkv5MT303wn1Ym/wuSaJNCg2BrjPXz+dA91I=;
        b=nKlPKnj17u8F8g5bNtIfTp98bAWM82KuAsw+M/E9yl1WQikrea71j6EIN3s/bBr/Fa
         E8quPMintPlK8Ajsoa8ufH2DW0uddgvSZzbQHgPYJRuhjnDvgni42nnyHkyGFtMEmpra
         CPD+fYlTdUERuOd+K9Iwu/I6K5jyIR8xEZTmdbE/yDw/pYL5qeTk0Rm7GLODDfzb+3hf
         fpgMYB72wtfHSTWiinlPKEQms9k4+usMNC+FrQ9khfWJ0PQffOo/xZIi+jimc8aJNqbh
         I1534m1gqnhUaH2HewzPE7NQEhZogMVu+DQ7+yroZaUoQHm5Jj/O2dbtkzGHGgZ3Kpab
         q64w==
X-Gm-Message-State: APjAAAXJguwOgTQIX/FcDOKTDHCVlrCiWiEPN8fAzavC4QYrIoEOZtv3
        rCoLJys6VpJJbjrLQMunXI8=
X-Google-Smtp-Source: APXvYqwp6tPkHpG7+5VnTaVLU3AJSHl9Oy7sFmtbG0h1qahwYs1tTxpK1v7vG6KPJvax1AgmudZcGw==
X-Received: by 2002:a63:a056:: with SMTP id u22mr12106459pgn.318.1560100757034;
        Sun, 09 Jun 2019 10:19:17 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id b66sm9421039pfa.77.2019.06.09.10.19.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 10:19:16 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, pshelar@ovn.org, netdev@vger.kernel.org,
        dev@openvswitch.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] net: openvswitch: remove unnecessary ASSERT_OVSL in ovs_vport_del()
Date:   Mon, 10 Jun 2019 02:19:06 +0900
Message-Id: <20190609171906.30314-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ASSERT_OVSL() in ovs_vport_del() is unnecessary because
ovs_vport_del() is only called by ovs_dp_detach_port() and
ovs_dp_detach_port() calls ASSERT_OVSL() too.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/openvswitch/vport.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 258ce3b7b452..9e71f1a601a9 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -261,8 +261,6 @@ int ovs_vport_set_options(struct vport *vport, struct nlattr *options)
  */
 void ovs_vport_del(struct vport *vport)
 {
-	ASSERT_OVSL();
-
 	hlist_del_rcu(&vport->hash_node);
 	module_put(vport->ops->owner);
 	vport->ops->destroy(vport);
-- 
2.17.1

