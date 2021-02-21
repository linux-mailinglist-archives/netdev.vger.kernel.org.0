Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACF3320DFA
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 22:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhBUVfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 16:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhBUVeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 16:34:50 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1FCC06178C
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:09 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id n20so130847ejb.5
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fxTIFR4EqLLuVSHPMzl4uGYJ6EYKN6vyQGKYjXcR7i4=;
        b=oGTyVL2FWBU0nBlBXL+OCfoflf7tb32Ue6y7C+d+FBxg+Yr1xqJeHzzzXdQcNVSURY
         F3ElPH4srlWT/Tm1lgwaauRJBzyPu1m3xppNml6jeJGgAonQVWYtAq2puItfchofh7i5
         H6mYOYOJrpmWnqZkWmI4JYi10bVJL8K/dvM1opo5cC68O9mkNDh8qwWNuZVpEa0YIWUn
         cAKq4bwn3dentY21DzHYC4+IL+zbx4Q456Sw74B5RBHaZnxRLn9Yxx1KpEritAmZq4Xf
         xiD47lv98UdQzCKzwkJkq1OUlwGgJugUtHIVuwOSVvy44VLjGSsqEVwvzouuIZyb2xIw
         zdmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fxTIFR4EqLLuVSHPMzl4uGYJ6EYKN6vyQGKYjXcR7i4=;
        b=liLzZFxzXMjI6MYzI4L9yNdhdLcpyBmTxjHUyOAsVUaQuLFpEihyM8P2wVH5z6TaUu
         pL6Oi6XTpy1sPDVQr7emboq/TsJcZygN0BDszhkwS2QVXIB3O9wyu/nteWaB+QVp/jpR
         RwlFQcuUGHb5uG4VrMXNf1NRFF3G1jGSQyx+LSYZA2Dhy+zvakqmtNn0pEe4nUm+eany
         RWACy7IfD5LNAP88Yw+BSAEqFEN5fkUa7iZWuiMuDbaTz8EVhUxleceDpatiLdVbEgio
         VR5P2re0DWSTWMQW1FseH5YXfidyDJyFrmdhrkBwlyvAt0rDwvk7o/PnnhAWSgB1qRq2
         4WIA==
X-Gm-Message-State: AOAM533rS/OBI2ihfbERcfB6Sijy1EdHXzpJqxcyxDsnRYoz2SHhVOtz
        7bf13CGwTAxp38U5Kley/MHyKj07Fmk=
X-Google-Smtp-Source: ABdhPJwfD6WilmmeugRSmsPAjdDxU1F0rYRrGwEc1rzHICC0rHaGtl9KxhGx9S7rcImTLE7Q4INZhA==
X-Received: by 2002:a17:906:f102:: with SMTP id gv2mr18014365ejb.47.1613943248469;
        Sun, 21 Feb 2021 13:34:08 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id rh22sm8948779ejb.105.2021.02.21.13.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 13:34:08 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 03/12] Documentation: networking: dsa: remove static port count from limitations
Date:   Sun, 21 Feb 2021 23:33:46 +0200
Message-Id: <20210221213355.1241450-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210221213355.1241450-1-olteanv@gmail.com>
References: <20210221213355.1241450-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

After Vivien's series from 2019 containing commits 27d4d19d7c82 ("net:
dsa: remove limitation of switch index value") and ab8ccae122a4 ("net:
dsa: add ports list in the switch fabric"), this is basically no longer
true.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index fc98b5774fb6..cb59df6e80f4 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -360,14 +360,6 @@ DSA data structures are defined in ``include/net/dsa.h`` as well as
 Design limitations
 ==================
 
-Limits on the number of devices and ports
------------------------------------------
-
-DSA currently limits the number of maximum switches within a tree to 4
-(``DSA_MAX_SWITCHES``), and the number of ports per switch to 12 (``DSA_MAX_PORTS``).
-These limits could be extended to support larger configurations would this need
-arise.
-
 Lack of CPU/DSA network devices
 -------------------------------
 
@@ -697,7 +689,6 @@ two subsystems and get the best of both worlds.
 Other hanging fruits
 --------------------
 
-- making the number of ports fully dynamic and not dependent on ``DSA_MAX_PORTS``
 - allowing more than one CPU/management interface:
   http://comments.gmane.org/gmane.linux.network/365657
 - porting more drivers from other vendors:
-- 
2.25.1

