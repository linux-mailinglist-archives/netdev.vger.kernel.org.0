Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C313217BE6D
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgCFN3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:29:07 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40894 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgCFN3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:29:07 -0500
Received: by mail-wr1-f65.google.com with SMTP id p2so1555573wrw.7
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 05:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1qadHUzF6uBqddy9Kzt+/fH81WIcmaGNA6CeSTeDuQw=;
        b=Sud+4nwL6Mg1LaQYdYdf1Rf3sv1E5EMvKHV2HAHMrOsfUpXCXA0lEIvqO36assOFVo
         5omNuLoKtl2hqGiAXuA6Ce6Gqq2MCiR/7jKbCB9VWYFve3/ItxUCavqAaPanabfJCJ/J
         dKQfxy6bWKzHHghIajiV58eQrX+uQOWhNCBQtGlTokzY2h9sOcVbMw0N4FcRNbdzJugQ
         VDn6LBxyvNC9BtujwVnuCVevSSG87K4l02NGvxPnChFYWqW6JobTPkGBfjfFn67XFWEV
         9OZERRJISLitNGhveLuVAJBr2lluC/HuTyg5IK7uJ9ZtiPyBBAfahuWjLX5IZEBP10sr
         2htQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1qadHUzF6uBqddy9Kzt+/fH81WIcmaGNA6CeSTeDuQw=;
        b=aHZ7qL6HRoqIkACrsoa6kXpM0lZbllkZgdgxpLD4ELGPeOc2xVVG1dO7mwH922kwVN
         M4L4yfYBTDnWXlMTZBiJukF+9P7oe+A1lZMpxe/Qfn4MIdKkCp/ehKIW0NgG77He39Wh
         dDjkE/fOy0YC1wiL5GQIpcuEvgQ73TIK75L238oPFc4ADFru7+BbguVu+ALEwHYHq9si
         gLrQ8SDzA4O3Bp16/dHvmPJMdbyVLlIl0pcSNQNGQrtjpJ/19V67AddRAAZk5OOH0GKp
         xondDxF3YS5rMMBoTbgGG3McAJtobpz2ar6NvQmTYCdXthciEiQ3tLFN4zFL+TKqAtWY
         QWBA==
X-Gm-Message-State: ANhLgQ1hTrixz1Hl2YViL7AfmhLq2W+aDfvo3VuRAh7s+td8NClyCVe0
        hFFEHfZa3dudRzuTncdk16aVgw79XBE=
X-Google-Smtp-Source: ADFU+vvBrmKNw4CGPZBH2OC6EYsLKRQ9vW/0XE1mBcfTFBaNiXsPBh84k/k6vUxEOLD+IQH7a3hwAQ==
X-Received: by 2002:a5d:5512:: with SMTP id b18mr4017862wrv.215.1583501344939;
        Fri, 06 Mar 2020 05:29:04 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g129sm15719110wmg.12.2020.03.06.05.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:29:04 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v3 05/10] mlxsw: restrict supported HW stats type to "any"
Date:   Fri,  6 Mar 2020 14:28:51 +0100
Message-Id: <20200306132856.6041-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200306132856.6041-1-jiri@resnulli.us>
References: <20200306132856.6041-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently don't allow actions with any other type to be inserted.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- moved to bitfield
v1->v2:
- move the code to the first action processing
---
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 7435629c9e65..588d374531cc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -29,10 +29,16 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 	if (!flow_action_mixed_hw_stats_types_check(flow_action, extack))
 		return -EOPNOTSUPP;
 
-	/* Count action is inserted first */
-	err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
-	if (err)
-		return err;
+	act = flow_action_first_entry_get(flow_action);
+	if (act->hw_stats_type == FLOW_ACTION_HW_STATS_TYPE_ANY) {
+		/* Count action is inserted first */
+		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
+		if (err)
+			return err;
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
+		return -EOPNOTSUPP;
+	}
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
-- 
2.21.1

