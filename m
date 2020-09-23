Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5FA276262
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgIWUpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgIWUpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 16:45:35 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73356C0613CE;
        Wed, 23 Sep 2020 13:45:35 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id u3so331364pjr.3;
        Wed, 23 Sep 2020 13:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JI9pZZmOJp7Ii/fvKa6cvstV+ZUKEidaK35wSni60bI=;
        b=uaLZCbsug5SIpI+rHXgo8liudu0LGSw5nqMZZXB9vk33gJOwleti/+gIQS4mVnm6EU
         IlQeNGo/0jQ5h/cZ3z9zQmvUiFlrSudB7Gv0g07yCGicdGVxXMJ+tgGJBpB7zz/7/CQ3
         /zlvgKqpGh6qZgeXNlHz1UuZHEWkY03retXi1Fp2lTxFpM93xBLCODwTYjqw919f4DDN
         5w1BWZ+odUpAnrtZIESxSyo6xatFUg84PWcqdXMsLF6Nwo/XsAnxLMt+KVhZcEU9lyJg
         e06BsXxw64o86bOym18mvBVrf7PhJAMTjhvAcKczXTqWk9uHj5rArG0SKS/qpBhh1FeL
         VEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JI9pZZmOJp7Ii/fvKa6cvstV+ZUKEidaK35wSni60bI=;
        b=m08ownmrbZER51XrwEw4+RYtcPkybm5hKqbYc/dTPRUXzijZtctalmH2iy3uEOlE0l
         toLhSY3tnwm34x818+zQgyVj9WpQcyjdGSZj6jCy81FHyyu04EN/ZPXVyiRy+EKu8NKq
         RMUiT5Rgr4PUMQF+eePscxPf9eiS3jiN3kwU3RHB7U6XPkeELRE879jTbCZKsDPDrLkB
         LkPRO6avg2aWehxDP3xIy/f3I82wIbpn8aSt9F3BC86WxsJ4lF8DtiteEjQCFIIEojIg
         k+PpJlagy6yB7dT8RTFaJsPNsZIUQv60zSpDz4UsO5QUiUzn3fVwCCfNQsT9a3Cuv3BD
         8XYA==
X-Gm-Message-State: AOAM533ZaGYgxqyRi6BfRqYjiFikR0oABcDX//xlcSXnIsQVKka262GO
        uCv438/2bJKyaSkh1xyfYUj3oOHJGP6+Hg==
X-Google-Smtp-Source: ABdhPJzo/lUCgC0pfv03jHvNhD3OQo7ssr2yfu7rGvYDOuZFr+ekxvtD4U0QSyTRX0tF4irG44f61A==
X-Received: by 2002:a17:902:6b8b:b029:d2:173:33d0 with SMTP id p11-20020a1709026b8bb02900d2017333d0mr1428514plk.62.1600893934590;
        Wed, 23 Sep 2020 13:45:34 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u6sm330776pjy.37.2020.09.23.13.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 13:45:33 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        vladimir.oltean@nxp.com, olteanv@gmail.com, nikolay@nvidia.com
Subject: [PATCH net-next v2 0/2] net: dsa: b53: Configure VLANs while not filtering
Date:   Wed, 23 Sep 2020 13:45:12 -0700
Message-Id: <20200923204514.3663635-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

These two patches allow the b53 driver which always configures its CPU
port as egress tagged to behave correctly with VLANs being always
configured whenever a port is added to a bridge.

Vladimir provides a patch that aligns the bridge with vlan_filtering=0
receive path to behave the same as vlan_filtering=1. Per discussion with
Nikolay, this behavior is deemed to be too DSA specific to be done in
the bridge proper.

This is a preliminary series for Vladimir to make
configure_vlan_while_filtering the default behavior for all DSA drivers
in the future.

Thanks!

Changes in v2:

- moved the call to dsa_untag_bridge_pvid() into net/dsa/tag_brcm.c
  since we have a single user for now

Florian Fainelli (1):
  net: dsa: b53: Configure VLANs while not filtering

Vladimir Oltean (1):
  net: dsa: untag the bridge pvid from rx skbs

 drivers/net/dsa/b53/b53_common.c | 19 +--------
 drivers/net/dsa/b53/b53_priv.h   |  1 -
 net/dsa/dsa_priv.h               | 66 ++++++++++++++++++++++++++++++++
 net/dsa/tag_brcm.c               | 16 +++++++-
 4 files changed, 82 insertions(+), 20 deletions(-)

-- 
2.25.1

