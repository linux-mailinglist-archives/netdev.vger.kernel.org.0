Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF084799A0
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 09:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhLRIP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 03:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbhLRIPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 03:15:24 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2958C061574
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:24 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id h5so2850316qvh.8
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nwFi71EYaCJQa6ilhf8tVOd8kB/6/KSAsgM4Xiu4kfs=;
        b=JmIhe8esW3r4j3MbrZp9HSnPWHjg1IuzANbfd9HpimKI4IZccZIpHXaUC4lLjNOyKj
         AhkJ54QlfEWBtpXIo2Pnf6ZBg4UUTbu3/eJo3A55rHe02WOdlhl7I9wDLLgOYku19ueR
         ngJIYHNdpgli3g62gJYjKTs8Qd4x2qqQbmg1nHEeiQd94LYTW6xO61NOeGE2p0T/mxeR
         GO5Y33epna7vyRJcR0EGwKMiNLL8No8sR0bpcvWVm0TMRIFdW96Fwp01UfUegBMi8Nzg
         0DgsHt1DzxDlpcLpSZODIdKHQ0SOh9uSVDnb3hLyU/DtZitnHESGUeIv3GPk2wO4SEdm
         PfFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nwFi71EYaCJQa6ilhf8tVOd8kB/6/KSAsgM4Xiu4kfs=;
        b=LtT5drJ/dEaK1M60kcz24ftCuse2AyxdZeaR99kBoZ61XWJVtQfFFtCt2L8OUQ2sSO
         kI380kbygpv4IjwD54GVNWcX9+XR9g97XOdoXLyi9e7FhvI3lE/CBRnZmclsRADygFJW
         VP/pp68BVnVaeWnlO7adJmtvGd4F7MsNM6zgxM7RWNITQREhesqkxznbYZ9vJRJ/KSUI
         iHyCzDBLtpAafWJwGW1F8eGzu2dGXPEYkj8yAv+HUtcrVfeN3kJqzIeYEtgKrGd5bvq+
         LujZtt6K9OSKsO+79DYDOi3OcJMz1g8YDuU8D+rE0/fng0CgkIa9XUZY54AhpEZ1/DAo
         9eCQ==
X-Gm-Message-State: AOAM532UhRDZk5HKGoKR+czDTVE1M6+E2IxFbPJzBc1KBCmBBVl7T4gq
        bj2vN18IE4jHcfEKY2MZ/N37sMyHkbb6fg==
X-Google-Smtp-Source: ABdhPJwz+s0B20yQ2vT6VgeXysiBST0YQPbnY9c+QHtHjjrch94kW/Vzy6Q2cLsSOHKbNX/vQS/Jcw==
X-Received: by 2002:a05:6214:5198:: with SMTP id kl24mr5239604qvb.6.1639815323716;
        Sat, 18 Dec 2021 00:15:23 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id f11sm6423357qko.84.2021.12.18.00.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 00:15:23 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2 10/13] net: dsa: realtek: rtl8365mb: use GENMASK(n-1,0) instead of BIT(n)-1
Date:   Sat, 18 Dec 2021 05:14:22 -0300
Message-Id: <20211218081425.18722-11-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211218081425.18722-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index e87c60d9c8cb..a8f44538a87a 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1966,7 +1966,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->priv = priv;
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
-		mb->port_mask = BIT(priv->num_ports) - 1;
+		mb->port_mask = GENMASK(priv->num_ports - 1, 0);
 		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
-- 
2.34.0

