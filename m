Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA04B225650
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 05:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgGTDuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 23:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgGTDuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 23:50:01 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E0BC0619D2;
        Sun, 19 Jul 2020 20:50:01 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u185so8391550pfu.1;
        Sun, 19 Jul 2020 20:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zpNQ7DCGwSOUMSEK/HU3GfgSbODJuk/1Ak8yOIxI+Lo=;
        b=PL5iTwbBGXyIVqSqB9VAq4WTd8xfZWF8q75j3na4O4bCRxjSjklJNYvZVGX5coNz4E
         KHDBEMUFejqwBRaahP+8+HrtEudl0YuIWYcWroqKFc7s6Da5ZWWdOKcvfDxwGntinkTF
         WHw7YGSJnICohHpFqBxp96oNnEw3+JFMSFWmuyXoJwZm5CIILgKor33Hv/BWiQy7oBNm
         3A69TWqMWFjCvKLFIPXcwbkHz0CRVPVG6le3bXIHOSxMP99D74XFSJviTYqixvihWQtg
         npG7q6taxiuGUPVPdX5u8rRmaLHIVZkAL0bg3a+g2uSsz350kIVvLzykt0ec0sBLQ0sP
         FxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zpNQ7DCGwSOUMSEK/HU3GfgSbODJuk/1Ak8yOIxI+Lo=;
        b=PkjL9PsHiN/4vRNwMZDkvnOE6il+pWSg+AVPZhGPt2DOWea4eZA/dbbyrMYs9mbBOd
         plGJ5GYRelyFVfZwEBKwD4tH9UBD/ycpyyIFlQ5dhTyjWXZDbDDLH7+0e4vx5ugFyihZ
         DomhfUnwZM+eTJOO2ULQNN4VyrdXdCRtcsqg1HpF0nbiZ5PjdxFTtfTcjxIQ8KGXPy7y
         UcvESUEm6HtaU8f/OWep2xweTHIDniXiYZ88uci7nfedQ5jP6GaZ3cD5McMcL5/QdzbK
         m1VPeg97BD/x8voHw7wS+WAnN0wXO19kHtN8y0so+Ysx1nz9eAia9SXMk0YFcta02EOi
         s//Q==
X-Gm-Message-State: AOAM531VqKuzGmiuUiFtUFkB2eCOP26dsT1oAaeJqAAz34BRwI+Tqorx
        LeP76xpq4uBAaZoRFhmBdEGXmRvd
X-Google-Smtp-Source: ABdhPJyqoti0uhXOTBdcSbHSU2nkj0p0nV2nSMZQ7vPSfhtXeSYwVu7FJEke/oup3/tyyKRNwiclrA==
X-Received: by 2002:a05:6a00:14ce:: with SMTP id w14mr18393710pfu.121.1595217000500;
        Sun, 19 Jul 2020 20:50:00 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id z11sm15183445pfj.104.2020.07.19.20.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2020 20:49:59 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list), olteanv@gmail.com
Subject: [PATCH net-next v2 0/4] net: dsa: Setup dsa_netdev_ops
Date:   Sun, 19 Jul 2020 20:49:50 -0700
Message-Id: <20200720034954.66895-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

This patch series addresses the overloading of a DSA CPU/management
interface's netdev_ops for the purpose of providing useful information
from the switch side.

Up until now we had duplicated the existing netdev_ops structure and
added specific function pointers to return information of interest. Here
we have a more controlled way of doing this by involving the specific
netdev_ops function pointers that we want to be patched, which is easier
for auditing code in the future. As a byproduct we can now maintain
netdev_ops pointer comparisons which would be failing before (no known
in tree problems because of that though).

Let me know if this approach looks reasonable to you and we might do the
same with our ethtool_ops overloading as well.

Thanks!

Changes in v2:

- use static inline int vs. static int inline (Kbuild robot)
- fixed typos in patch 4 (Andrew)
- avoid using macros (Andrew)

Florian Fainelli (4):
  net: Wrap ndo_do_ioctl() to prepare for DSA stacked ops
  net: dsa: Add wrappers for overloaded ndo_ops
  net: Call into DSA netdevice_ops wrappers
  net: dsa: Setup dsa_netdev_ops

 include/net/dsa.h    | 71 +++++++++++++++++++++++++++++++++++++++++++-
 net/core/dev.c       |  5 ++++
 net/core/dev_ioctl.c | 29 +++++++++++++-----
 net/dsa/master.c     | 52 ++++++++------------------------
 4 files changed, 110 insertions(+), 47 deletions(-)

-- 
2.25.1

