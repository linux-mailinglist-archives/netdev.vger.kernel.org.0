Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7233DEDFA
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbhHCMkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235782AbhHCMkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 08:40:43 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBB9C061757;
        Tue,  3 Aug 2021 05:40:32 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l19so29559121pjz.0;
        Tue, 03 Aug 2021 05:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dQ9TyR/ElfRpbm66B73yjjkp4wHEV5Mt6Yp5m7wMnpM=;
        b=Pj6L45Z5d1eZKMGaDjGEn+k38rvy794EmzxLdJb/SBe9YcVz+Am/OQ2Jc9YAn3dH56
         NkN+NKB8dBgiUuBspVurnd1M2ZGcauGNp0w98ejIF6BPhziigns9l/nvFpsjEp+QxTeP
         1qg+5au+gYhCsgMNP1q3myQQaOnlQrLgxsZbKt1IsCncbJLzZlzP5qialHQ6k8kBN4Wc
         lufhtmrVT2A6OdlrcdtwYhDCOekmQbh1DbxY66wIDO54BMgIDx0ynuGEaXAQ3/ebHLZz
         HzEosZ1FUd9VCBYFLs10i8GCICS6vzUHmNSfPAShvkfnBqm+FmN2ViyS78b7OXjKF/wj
         Qduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dQ9TyR/ElfRpbm66B73yjjkp4wHEV5Mt6Yp5m7wMnpM=;
        b=MfEK+kZt5x5DSHS9pajOBgetNAHqyQZP02jV6AcOgurju9x6o4atzZd6tjSH3A5JM3
         vt+ti0WIpNrdWWkJmZitCLSqczYnEY6R6cy2Cxvmy7LMp4rz/3zz13fTBziD014sjoYj
         YmhElNGCeWPJ+GZnIkdOgKitnQxP3bplYPKx2dpVGByDvG86Pmnp0D/EJuVh92js2Pgl
         OnyNhCixermxKfo/klzKYH+7SUa+3bZ5pXIoQzvP/0wK9GDRDJOqi6m2PWdICBuls2Pp
         EVT2G+DfJ+VOhar3zJWqKpOa//FA9ZhpQT+1EV3T5twcuJm2SUyUayFbqBTSCoRB+qB0
         F8Hw==
X-Gm-Message-State: AOAM530URR917AWg5P1/8sPS1DJqrxW/opA8lUE69Gu1UeQqkRZGh71o
        D8I3RI/N81C+WPdV2K1f8Pw=
X-Google-Smtp-Source: ABdhPJwZx7+VO53Jv6LZiPKW412Lt5aGVRYJ7kbue0DP70WdatNFYtNsAGuAlhq7/AwKuQp8i2TUUA==
X-Received: by 2002:a65:6813:: with SMTP id l19mr51800pgt.118.1627994431593;
        Tue, 03 Aug 2021 05:40:31 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g25sm15747499pfk.138.2021.08.03.05.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 05:40:30 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Eric Woudstra <ericwouds@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 0/4] mt7530 software fallback bridging fix
Date:   Tue,  3 Aug 2021 20:40:18 +0800
Message-Id: <20210803124022.2912298-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA core has gained software fallback support since commit 2f5dc00f7a3e,
but it does not work properly on mt7530. This patch series fixes the
issues.

DENG Qingfang (4):
  net: dsa: mt7530: enable assisted learning on CPU port
  net: dsa: mt7530: use independent VLAN learning on VLAN-unaware
    bridges
  net: dsa: mt7530: set STP state on filter ID 1
  net: dsa: mt7530: always install FDB entries with IVL and FID 1

 drivers/net/dsa/mt7530.c | 87 +++++++++++++++++++++++++++-------------
 drivers/net/dsa/mt7530.h |  9 +++--
 2 files changed, 66 insertions(+), 30 deletions(-)

-- 
2.25.1

