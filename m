Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C28A4197
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 04:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbfHaCAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 22:00:17 -0400
Received: from mx6.ucr.edu ([138.23.62.71]:56624 "EHLO mx6.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbfHaCAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 22:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1567216818; x=1598752818;
  h=from:to:cc:subject:date:message-id;
  bh=9g/JKp5foaxieSnROfbCL0H+QjD7in4dyY/WHzgkS8M=;
  b=HPZ3ZPuOaThj5A4OXBhlaGW7Yxw58hOJtzdGhBTz3rPzzmexptrEeztc
   dBq0CRIne4QHWm5qL4kFfB1+ROAX2Ypafh5Icj9fKAQN8CkVgMG/QZQqh
   Yid0Z2fT/XkKEAfaUq0vhSNuUoapqOiU22ZLZnSnyI8wUAfoMeEM0cqsF
   ud9muGW7FL8bZmIBtDZX44WaB8An8Aod9KhjruRET2CCvHxZK923jaBaa
   dvh1lPfJQnOXhB8VcjuRPG51EJyO9HU5Fo/Q3+NrSYhE5pPjdd9OF3zpH
   DRtjmc9B66vJpLqQhxbTJ5BN3PpelZerwm95n9+ku7o9PX3Tx2fDNMQfi
   Q==;
IronPort-SDR: ATXjk5zp4JIJ5FgGOyeN/wp5rc2QpRtEfCHvEch+f7n2ycvOfb2PUO1RvkD1w25bby4OM7x5Ct
 zX4HQjcFsDmS6NEParXK6NPAI7JU9Hr7AjHYGS0BLsU6D/FjUIp0DNhvJ3TDk5r2Mv920mxkbW
 99V2K4AhuodDTXvg8vL5CmsssUUe7ta4gJAEOBpsHiPGTtTN4khIhY5IOPCELaYYDhVVOUsPYs
 NUMNYiAsBr63RFdn75tRMZidW27IWnuyqvM0dh36lkru46E/42DEKYu7KDz8Ziv7BUYUFZ/puj
 CVY=
IronPort-PHdr: =?us-ascii?q?9a23=3AeT+5PxervNw2EfjLZ5qQerbplGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxcuyZh7h7PlgxGXEQZ/co6odzbaP6ea5BzFLvM3JmUtBWaQEbw?=
 =?us-ascii?q?UCh8QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFR?=
 =?us-ascii?q?rlKAV6OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MQu6oR/MusQXgYZuJaY8xx?=
 =?us-ascii?q?XUqXZUZupawn9lK0iOlBjm/Mew+5Bj8yVUu/0/8sNLTLv3caclQ7FGFToqK2?=
 =?us-ascii?q?866tHluhnFVguP+2ATUn4KnRpSAgjK9w/1U5HsuSbnrOV92S2aPcrrTbAoXD?=
 =?us-ascii?q?mp8qlmRAP0hCoBKjU063/chNBug61HoRKhvx1/zJDSYIGJL/p1Y6fRccoHSW?=
 =?us-ascii?q?ZdQspdUipMAoa9b4sUFOoBPOBYr4bgrFUQtBW1GAesBOLxxT9Mm3D9wKk23u?=
 =?us-ascii?q?o9HQ3D2gErAtAAv2nOrNjtNKkcT/27wqfLwzvEdP5axSvx5ZLUfh07vf2AQb?=
 =?us-ascii?q?R9etfRx0k1EAPFi02dpo7kPzKU1uQNrm+b5PdnWOOvim8nqxt+ojmzysswhI?=
 =?us-ascii?q?TEnZ8VxUze9Slj3ok6OMC4RVd9bNW5E5VQrzmXO5VqTs4mWW1luyY3xqcYtZ?=
 =?us-ascii?q?KmcyUG0okryhrbZvCfboSF4xbuWPyPLTp2hH9pYqyziheo/UWixeDxUNS/3k?=
 =?us-ascii?q?xQoSpfiNbMs2gA1xnU6seaVPRw5lyh2TOT1wDL7eFEPFw0mbLbK5E/xr4wkY?=
 =?us-ascii?q?IesUHZES/3nEX6lbeWdkE59uSx5eTrf7Hrq5uGO497jQH+NasumsihDugiLg?=
 =?us-ascii?q?cOWG2b9fy91L3l40L5XK1HguMqnqTdqpzXJsQWqrSnDwNI3Ysv8QuzAjOi3d?=
 =?us-ascii?q?gAmHkINlNFeBaJj4jzPFHOJej1DPe+glSsijhrxuzKMqHvD5jWM3jMjK3hca?=
 =?us-ascii?q?xj5EFB1Qo/1cpf6I5MCrEdPPLzXVf8tNrGAR8lLgO73fjnBc5j1oMRR22PGL?=
 =?us-ascii?q?WVMKDMvl+S4OIgPe2MaJUSuDbnJPh2r9D0inpsqF4PfbSulc8GenCxH6w+eG?=
 =?us-ascii?q?2EamCqj9scRzRZ9jEiRfDn3QXRGQVYYGy/Cudjvjw=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2GHAQDa02ldgMfWVdFmHgEGBwaBVAg?=
 =?us-ascii?q?LAYNXTBCNHYYPUQEBBosgGHGFeoMJhSSBewEIAQEBDAEBLQIBAYQ/gmMjNQg?=
 =?us-ascii?q?OAgMIAQEFAQEBAQEGBAEBAhABAQkNCQgnhUOCOimCYAsWFVJWPwEFATUiOYJ?=
 =?us-ascii?q?HAYF2FAWhLYEDPIwjM4hrAQgMgUkJAQiBIocfhFmBEIEHg25zhA2DVoJEBIE?=
 =?us-ascii?q?uAQEBjUCHFJYJAQYCgg0UgXOSWCeCMoF/iRo5il0BLaYJAgoHBg8hgTECgg1?=
 =?us-ascii?q?NJYFsCoFEgnqOLR8zgQiLXIJUAQ?=
X-IPAS-Result: =?us-ascii?q?A2GHAQDa02ldgMfWVdFmHgEGBwaBVAgLAYNXTBCNHYYPU?=
 =?us-ascii?q?QEBBosgGHGFeoMJhSSBewEIAQEBDAEBLQIBAYQ/gmMjNQgOAgMIAQEFAQEBA?=
 =?us-ascii?q?QEGBAEBAhABAQkNCQgnhUOCOimCYAsWFVJWPwEFATUiOYJHAYF2FAWhLYEDP?=
 =?us-ascii?q?IwjM4hrAQgMgUkJAQiBIocfhFmBEIEHg25zhA2DVoJEBIEuAQEBjUCHFJYJA?=
 =?us-ascii?q?QYCgg0UgXOSWCeCMoF/iRo5il0BLaYJAgoHBg8hgTECgg1NJYFsCoFEgnqOL?=
 =?us-ascii?q?R8zgQiLXIJUAQ?=
X-IronPort-AV: E=Sophos;i="5.64,449,1559545200"; 
   d="scan'208";a="73596727"
Received: from mail-pl1-f199.google.com ([209.85.214.199])
  by smtpmx6.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2019 19:00:17 -0700
Received: by mail-pl1-f199.google.com with SMTP id v22so3632894ply.19
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 19:00:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DDyvegdKp6MmZvQoeqYKTe4rMUcvHNSrG5Su6nBLcf4=;
        b=KicPoiz71pijnuerYLU4/cSblF556bCqD95Z1hwT4c9qFzKJbR5cz2SuTk/zniouKo
         /NwDlR1hPAmeyFCncqSc9rUWXkrjvhVYoggewii6elqfcZsUbto3jk/D+pNs+g8/6iOO
         IML2D7eYhM7sfO5G6v4Jfy45jUuXf805YLGoiivlmdkHXT0f94Ir6pFvQ913kgOF1nIl
         tj9cGtwBV1qEa1ty8OVgGAmii5aolRrGXN0bzcnTDPUHPUrejVPTDbW4YcU2m1hrlE2v
         GkpDfxI4rkp+NznhTKeSeVUjkuGUvNJ2uTe1mFse8d5KrkMny/G5wGv/Ps13QQqk7ODi
         uNWg==
X-Gm-Message-State: APjAAAUrxRmB8moKtOFNfH3YjUSDAW+lqYEUA6Bqh9I3GYYP9vf7FUZx
        1Y6bTsJN507dT0o3mU22UNwAM+9LYDo1m0MHfpCgsXbuPhSMFcWdI59CBDhdEv6BPCLcC8f6usz
        P6MTUhS0pk6huZ1WWDw==
X-Received: by 2002:aa7:9495:: with SMTP id z21mr21413550pfk.220.1567216815847;
        Fri, 30 Aug 2019 19:00:15 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy2BLuGlLGxCSNkEHMBr+Frsk42bOM599GwK6aw54HDOsHA5LvdnFEX6NldgYdsc89eYIHNdQ==
X-Received: by 2002:aa7:9495:: with SMTP id z21mr21413519pfk.220.1567216815530;
        Fri, 30 Aug 2019 19:00:15 -0700 (PDT)
Received: from Yizhuo.cs.ucr.edu (yizhuo.cs.ucr.edu. [169.235.26.74])
        by smtp.googlemail.com with ESMTPSA id 127sm7549594pfy.56.2019.08.30.19.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 19:00:14 -0700 (PDT)
From:   Yizhuo <yzhai003@ucr.edu>
Cc:     csong@cs.ucr.edu, zhiyunq@cs.ucr.edu, Yizhuo <yzhai003@ucr.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: stmmac: dwmac-sun8i:  Variable "val" in function sun8i_dwmac_set_syscon() could be uninitialized
Date:   Fri, 30 Aug 2019 19:00:48 -0700
Message-Id: <20190831020049.6516-1-yzhai003@ucr.edu>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function sun8i_dwmac_set_syscon(), local variable "val" could
be uninitialized if function regmap_field_read() returns -EINVAL.
However, it will be used directly in the if statement, which
is potentially unsafe.

Signed-off-by: Yizhuo <yzhai003@ucr.edu>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 4083019c547a..f97a4096f8fc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -873,7 +873,12 @@ static int sun8i_dwmac_set_syscon(struct stmmac_priv *priv)
 	int ret;
 	u32 reg, val;
 
-	regmap_field_read(gmac->regmap_field, &val);
+	ret = regmap_field_read(gmac->regmap_field, &val);
+	if (ret) {
+		dev_err(priv->device, "Fail to read from regmap field.\n");
+		return ret;
+	}
+
 	reg = gmac->variant->default_syscon_value;
 	if (reg != val)
 		dev_warn(priv->device,
-- 
2.17.1

