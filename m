Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07ED30DF65
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbhBCQN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbhBCQJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 11:09:24 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA983C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 08:08:42 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id a9so18268788ejr.2
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 08:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fUXyf1oadQBPG9dQOZpK2kETmKrmf0MdC3Y5RBE0BWY=;
        b=SFFRC9w74eqN2PP+5Cg6Lptb53GsipB3iOC8L1frDD6hxvmghZMeLn8Z/Gwb/jU5YS
         IqutBLdpGXOsmk9gsvk3+JxLKL7CtRUzI0p/rU0CS9CiSClBfSY4ARkab5H+vlN4POC2
         rU07ZKdReo9yuShyJVnkjUoqIYesoAD1FyoB7H6MS8mpAR7IRhxdEnt9wdSUCEMjrFYQ
         1+h0ADwhy6EsrselEXxWmaZIIS0/GVC3kjd6CnsMacuHUKWTTqQ+7PsbkU6g8FJrsYVo
         omFGIruUjWhCTXK2JhrQhnlQEYq6H7SLOzTlAQ5/B3RJbhKmJALgiN/MY1EGHpNHh2xg
         6zcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fUXyf1oadQBPG9dQOZpK2kETmKrmf0MdC3Y5RBE0BWY=;
        b=KtllQEBKf7/E42/qirkS49VswC2rp6ky2v05etvkuYslpP/XkfKpm501yjzB5nZPJS
         R7jwAqhGt4eWKTyl8cqw0bUwTtyIXHRsWkhUzr6ZMVswA9CztvnEX+3GYXY5HPQMuMLn
         jULhAH+LqGLjZgHNTDkWyMs/rdM4mVNeqhagxOIBjCdCtfFFJn4HFNOu6pdrMiXI8EBz
         8W+aN7g50JGfsiN67KzA1GcOTqjI8DaPIPlu9xDWbVL++D5atJ0qlrRBzkwzqWr2ezxE
         g3eW46l3RVhdZR1SaD9s2u7HE3C+a26SszGgxy/EeGP2Jjun8kVX8mueCZnjqN6PYEyt
         vOTg==
X-Gm-Message-State: AOAM532idUOImY+wbMZ92BPx/QcZpTmnmE8xPOFooDm5+bEd69sV5W+b
        0nB8SmS2V6y7prd9hn3B+O0=
X-Google-Smtp-Source: ABdhPJxpBktpd1JzxQy+qawR9vNhSYuEhcLh5adifJ8HX7reVRs5JmJF9uZBK+zRB8qtUg/UPW9q+Q==
X-Received: by 2002:a17:907:1181:: with SMTP id uz1mr3993211ejb.60.1612368519760;
        Wed, 03 Feb 2021 08:08:39 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u16sm1085589eds.71.2021.02.03.08.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 08:08:39 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v2 net-next 0/4] Automatically manage DSA master interface state
Date:   Wed,  3 Feb 2021 18:08:19 +0200
Message-Id: <20210203160823.2163194-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch series adds code that makes DSA open the master interface
automatically whenever one user interface gets opened, either by the
user, or by various networking subsystems: netconsole, nfsroot.
With that in place, we can remove some of the places in the network
stack where DSA-specific code was sprinkled.

Vladimir Oltean (4):
  net: dsa: automatically bring up DSA master when opening user port
  net: dsa: automatically bring user ports down when master goes down
  Revert "net: Have netpoll bring-up DSA management interface"
  Revert "net: ipv4: handle DSA enabled master network devices"

 Documentation/networking/dsa/dsa.rst |  4 ---
 net/core/netpoll.c                   | 22 +++------------
 net/dsa/slave.c                      | 40 ++++++++++++++++++++++++++--
 net/ipv4/ipconfig.c                  | 21 ++++++++++++---
 4 files changed, 59 insertions(+), 28 deletions(-)

-- 
2.25.1

