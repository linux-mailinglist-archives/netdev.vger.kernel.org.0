Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B3B26239C
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 01:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgIHXdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 19:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgIHXdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 19:33:53 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A79C061573;
        Tue,  8 Sep 2020 16:33:53 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d9so500301pfd.3;
        Tue, 08 Sep 2020 16:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DY5gbi/kg3mlXEWhK+AT4noIdeJ5tpruTcO86qQV2fw=;
        b=gD/1uUIjxxvndXA66bjpe84ydOX7OCQ6pi8H39SCb1WcPm9hzkQBnoZFpEvLIgTf6B
         oAOvXXy3rXuK0i4ORtK7eJJFZNYcD9cD/HIOKI+ioF69hJKgSwlOZ9hlW0hsOlbCtXKu
         WoMBhlib6KwG6qMtjiXjXPPka8kCdQNheTBjyeSlzLe0i+GfJJvCObe8WRNFsDW/G0eb
         7gEu970QLGJlhG9fc6NdH/sL7yN94Lr784NdQN+UKXs7sG2FC3dpzjpAuxl1E55ZBPdB
         qguXxEEs1ocql+7X/dMt4av1HnCsEPFTjLADZLIIof6W5BbyfDBNZvbjE9b3oMEE1802
         bRdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DY5gbi/kg3mlXEWhK+AT4noIdeJ5tpruTcO86qQV2fw=;
        b=diDXYBLo/yZHmj2Tl4yu8j8aKcMo1lhnn/S1BSHiRuJTHB1s5GoXqN6hEOdA7c3AW1
         M7df9XXZNwWhFG9TPEzO0ISw08shS+DiPmds9Q5nws63S50Yh0Fk1PdeIgqZQz5bQ7xP
         PoecTQ0Yj0Mt4VHElJaZwSgPWW8HEkF9tv4Delm4QQPCzK9HDWxER9TuXfqLNaT+mDeE
         hTmDcyFswmVfhPwPvdhJqJIlNWKmCViUdzCivQxFizYm5TuDw+oYif61za9QyA/TVy/l
         3wAT6gkzmRG4Mc+k2hwap8QN4yHofna7K9hU/GDFSyXnLDtkhOQ8/8bjE5SGsmA1Hbth
         pcSQ==
X-Gm-Message-State: AOAM531fAyeliN0iW5KlOLLsDf5btQ0DkcmlTVSVauWkA3sFKv0yZJ3C
        FTWV2oP1hGBFaJ8MZmyJ51I=
X-Google-Smtp-Source: ABdhPJyb8T9C7v1d33kdgNugE+3TPB7VCXh6XyWU6MplW7h01SgEPXkLa6ESccu35w5loo09tNI3iA==
X-Received: by 2002:a17:902:b088:b029:d1:8388:e6f8 with SMTP id p8-20020a170902b088b02900d18388e6f8mr71790plr.40.1599608032937;
        Tue, 08 Sep 2020 16:33:52 -0700 (PDT)
Received: from localhost.localdomain ([49.207.193.206])
        by smtp.gmail.com with ESMTPSA id c7sm473216pfj.100.2020.09.08.16.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 16:33:52 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+c613e88b3093ebf3686e@syzkaller.appspotmail.com,
        syzbot+d0f27d9af17914bf253b@syzkaller.appspotmail.com,
        syzbot+3025b9294f8cb0ede850@syzkaller.appspotmail.com,
        syzbot+0f84f6eed90503da72fc@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: qrtr: Reintroduce ARCH_QCOM as a dependency for QRTR
Date:   Wed,  9 Sep 2020 05:03:28 +0530
Message-Id: <20200908233329.200473-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removing ARCH_QCOM, as a dependency for QRTR begins to give rise to
issues with respect to maintaining reference count integrity and
suspicious rcu usage.

The bugs resolved by making QRTR dependent on ARCH_QCOM include:

* WARNING: refcount bug in qrtr_node_lookup
Reported-by: syzbot+c613e88b3093ebf3686e@syzkaller.appspotmail.com
* WARNING: refcount bug in qrtr_recvmsg
Reported-by: syzbot+d0f27d9af17914bf253b@syzkaller.appspotmail.com
* WARNING: suspicious RCU usage in ctrl_cmd_new_lookup
Reported-by: syzbot+3025b9294f8cb0ede850@syzkaller.appspotmail.com
* WARNING: suspicious RCU usage in qrtr_ns_worker
Reported-by: syzbot+0f84f6eed90503da72fc@syzkaller.appspotmail.com

Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
As I understand it, QRTR was initially dependent upon ARCH_QCOM, but was 
removed since not all modems using IPC Router protocol required the 
support provided for Qualcomm platforms. 
However, wouldn't ARCH_QCOM be required by the modems that require the 
support provided for Qualcomm platforms?
The configuration ARCH_QCOM isn't exactly the easiest to find, especially, 
for those who don't know what they're looking for (syzbot included, I 
guess).
I don't feel like the tradeoff of not depending on ARCH_QCOM over giving 
rise to potential bugs is worth it. 
Is NOT having QRTR depend on ARCH_QCOM so critical that it supersedes the 
priority of not giving rise to potential bugs?

 net/qrtr/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/qrtr/Kconfig b/net/qrtr/Kconfig
index b4020b84760f..8156d0f3656b 100644
--- a/net/qrtr/Kconfig
+++ b/net/qrtr/Kconfig
@@ -4,6 +4,7 @@
 
 config QRTR
 	tristate "Qualcomm IPC Router support"
+	depends on ARCH_QCOM
 	help
 	  Say Y if you intend to use Qualcomm IPC router protocol.  The
 	  protocol is used to communicate with services provided by other
-- 
2.25.1

