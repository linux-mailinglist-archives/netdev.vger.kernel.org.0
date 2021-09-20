Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2DD411B79
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 18:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344422AbhITQ64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 12:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244744AbhITQ4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 12:56:46 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E05C0611C1;
        Mon, 20 Sep 2021 09:47:57 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c22so63562838edn.12;
        Mon, 20 Sep 2021 09:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OmC4mkSbBxwC8kLlx6/wM2R6XpjuEwyOodXYfjGgidE=;
        b=mF2Lp/wVAzjMME5ltM9Lkmv9+xWZFC1kVr+719bJYLuDlQEN8nOGBkRMEawLQhiuG0
         skGs47cHh+4zDwTXMCT7SFpbBTbd6f0wgJPvIwn08BN7qm7RtqTrdQpGFGauAUwAIxcM
         UzAmqLxi9kmpXUJnj/BEtYAkvy8+ok5PBwCZ+Rbl1jBMKgVyAfeWcGxD2ot5XkYXYrU9
         PbAXoB4/IzQZYQAzgSK+4oSF2ANernNCnbJeCX7Gqv9vVTed9DieL20pP+9jZC3w93yQ
         M/dC8C/Qo6pun2c1BAlvHlQcPwr5vg3Gju/QgsSIQRFD8CEtZRf/uUfANmbWzaCVqmMM
         sB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OmC4mkSbBxwC8kLlx6/wM2R6XpjuEwyOodXYfjGgidE=;
        b=inTXyHhaToR3SvE87vTuCpva1GGLhGmCJlow5/IM/gs8vMfdg6MzBwx9tlalnDJUBV
         eDc2DzATlrwLny23HPJ0Fe/bzdDu7jlNyQVFlIriytFsdRH847Vn9CJ4NqCIjuDbd3Wf
         oA5/4mdNUT+Fb6CNg97BdP4O+U7Mk3bkbSKCc1rja+ZZ4p+U0e1aZUIRV23Amo0FU5Ix
         3dJpt5Vl9zeRfqRbmV+PH53hhB7s3WIbCM93mW+m31c/3ya0EOdtJzoDagCnHzhoN+YO
         JRBnMP2uyXTitQpqgNh1VKjdALlYua0DFqcg6Riv0WJ1xg8mCtXpZRrO/oRSHPJUMXbP
         jZNQ==
X-Gm-Message-State: AOAM532jhs8Xd8jlOfdd8Jq3JTNfhfB+czBPzl5oPkROdadJDMQwj92n
        DJn7UzJ+FtUlQn7j0D3sf/8=
X-Google-Smtp-Source: ABdhPJw5/Agktydvv4Utlp8p45PSSck6BL+WgUQ5syHxOcwNNIn/9LMS9wmFpelueiLTYFB/m6WCWA==
X-Received: by 2002:a17:907:1b06:: with SMTP id mp6mr28517224ejc.188.1632156475572;
        Mon, 20 Sep 2021 09:47:55 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.googlemail.com with ESMTPSA id 6sm6385232ejx.82.2021.09.20.09.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 09:47:55 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH 0/1] Sgmii fix for qca8k qca8327 switch
Date:   Mon, 20 Sep 2021 18:47:44 +0200
Message-Id: <20210920164745.30162-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some background for this. As stated in other patch, we are testing
qca8327 switch in various device. We tought this was a specific
configuration of the switch and needed special binding to disable pll on
sgmii port. With a better analysis of the original qca driver it was
discovered that pll was only enabled on switch revision 1.

By testing the same configuration with a qca8337 switch that have a
revision 2, using the secondary cpu port (set as sgmii) as primary
(removed the first cpu port from dts and updated the driver to use the
secondary cpu port port6 for everything) confirmed that pll enabled is
not actually needed and all works correctly.
Different case for another router with a qca8327 switch that with the
extra option enabled doesn't work at all and no traffic can be detected.

Also in the original driver the signal detection (SD bit 4) is never
enabled. Having that enabled doesn't seems to give any problem so i
won't disable that, but i'm just pointing this out to think about it.

Don't know if that should be disabled or not but the pll changes is
absolutely needed as in some case it cause the malfunction of the entire
connection.

Ansuel Smith (1):
  drivers: net: dsa: qca8k: fix sgmii with some specific switch revision

 drivers/net/dsa/qca8k.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

-- 
2.32.0

