Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39754A87B4
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351798AbiBCPbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236346AbiBCPba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:31:30 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33281C061714;
        Thu,  3 Feb 2022 07:31:30 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id w11so5777542wra.4;
        Thu, 03 Feb 2022 07:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qRQ95PT/Vrnz3TmgchsWQMEElvKn8TkczXxrd4JiXxg=;
        b=AkoM/A5rnKXsxCvCu64RpwCAa1kHe1CnXoXLu7P+imwHaVaI9eP28fg51hSaEFMOF4
         +XPtzorhUV3yBmmCMxYy7eRn7+382DNo2rGvb+Fbkmd+zeq+pvWQ2ekbk1jBexZIVbcZ
         5H9wxYmQj4P9dT3TqF+66PF81ZCqNeycsCVEAeNSxsSqoWFzJ5PslzH/ody6xNEO9DVa
         xKe1uvavMWzkVxrmnfvY9BlpN58Eo6m2hRwpsIju37UTIUipmjWEAKg5q1M0L7YthmOT
         uwxncGk607ESanGw5jKMLgLgMXVQehyqYk5yA7czIimEWTA734NnlDAbLubDDYW58LCU
         wMPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qRQ95PT/Vrnz3TmgchsWQMEElvKn8TkczXxrd4JiXxg=;
        b=qXeLInK9aVSXvJPHs2nkJsI7f9x87BOdw2sGlyd2TZPHxUagbWpXUUb3dS2Io5aUG+
         23e8FLhELkTCNjLGNAwQWvLqiKBih22u2cdnVE/T/T4nxf7cTWXk1NW7IFlNym3ISucQ
         KVRQUpz+8DrQICcFL9VDhkf79k3+PQA+ZnuAIkZjRwvuAEUF9/HmHCFBqIlr/lgvN1mg
         DAeE9T+9KkPRYQhNSxDJaByh8bTY+CTY4Aji+rmyB/J1Kz1OdEKWiKAfrz7vmjvgFFZx
         8vh+xvpcFaFdSoeAFKetSBUoHyaIZnrn+vb6NDk0mcBzlbGA/1kd+W6ul0fFwo5PoRUc
         JbPw==
X-Gm-Message-State: AOAM533XTSnyHz9ll0SD+0k9H6MdJs3mrk7dEuqA+8acXVyFoz0bBQ+G
        auyyEuxdjZCPQ7H5yxNACdyQVPCKeg1QkQ==
X-Google-Smtp-Source: ABdhPJxGJDjfwZpXdBMoGDpmAenPPoddfCUlQWcfP8GotPPMuvY6LU011UtpkpATUFXf9XHLI7i27g==
X-Received: by 2002:adf:fd8b:: with SMTP id d11mr29096831wrr.606.1643902288679;
        Thu, 03 Feb 2022 07:31:28 -0800 (PST)
Received: from baligh-ThinkCentre-M720q.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.googlemail.com with ESMTPSA id n5sm8627250wmq.43.2022.02.03.07.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 07:31:27 -0800 (PST)
From:   Baligh Gasmi <gasmibal@gmail.com>
Cc:     gasmibal@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org (open list:MAC80211),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] mac80211: remove useless ieee80211_vif_is_mesh() check
Date:   Thu,  3 Feb 2022 16:30:34 +0100
Message-Id: <20220203153035.198697-1-gasmibal@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We check ieee80211_vif_is_mesh() at the top if() block,
there's no need to check for it again.

Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
---
 net/mac80211/sta_info.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 537535a88990..91fbb1ee5c38 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -364,8 +364,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 			goto free;
 		sta->mesh->plink_sta = sta;
 		spin_lock_init(&sta->mesh->plink_lock);
-		if (ieee80211_vif_is_mesh(&sdata->vif) &&
-		    !sdata->u.mesh.user_mpm)
+		if (!sdata->u.mesh.user_mpm)
 			timer_setup(&sta->mesh->plink_timer, mesh_plink_timer,
 				    0);
 		sta->mesh->nonpeer_pm = NL80211_MESH_POWER_ACTIVE;
-- 
2.35.1

