Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDD318C403
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 01:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgCTABK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 20:01:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55772 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCTABK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 20:01:10 -0400
Received: by mail-wm1-f68.google.com with SMTP id 6so4760763wmi.5
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 17:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PcpWpIcx5bRLZawLvv9mrOBvy2SAaOL/6BYWBsgnD9g=;
        b=VYze/OsQLPMA5MMSN8uuok/R/NCX2UB+NIg+TX5pUPgGLSMbtcTUnMuAma402Qkfk/
         5STUgYsOE2APltBaeZFZBcj9kTpxaxoDRSp4Ze1RKmFuSEwqPVbY4jrT+wjTUZy4Slkr
         gUbgqdJRWnHI65d4zct/SUomz1ruIUeKUpcAYKwy0qdHoajZH5IgYeOFkpOpmtxLhTTG
         tfrhRLqdJbRcxdjDnnHGWThHE9RWy6HVbW4f7bYI9h7ko335nlAa6ZWNDivV75dKc3px
         K0jlVOSvc0nfsc2ohv37F5tIwEfkOa4/VCiRRgJuJVvf59tXizEt9Kv08nzEGyD9qX+g
         W1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PcpWpIcx5bRLZawLvv9mrOBvy2SAaOL/6BYWBsgnD9g=;
        b=bjsFqiiK+Urqn5TWIyjHLtDx1F0UUBT+b1YhPyI+fk+B04vgzxjHVYR9Yi//UazP5S
         iU8GDv+tbIRN2no9GeN5brsC4/LJO2DXIycltNhr3mTy3G3ehPyAwes3oVGyHzxV2Cdf
         v5YhiM0xSoVBmC9zgY4Pxk4NKpgy3Opb4wBodEmfC1bq8hfJN0zIeKamcPzyTbUxPnFP
         W15d3Djb3JpsHlxZrDHzilm+zdCXjOW/Veo1ymY6qiiThyyXU/eKh7ED5+UfSBs35yjF
         fLIG2clU9bfC3KJchp8pmMXZDj0efCYBRrTMb8gI51Yr4D/nRvwoMYhA2FajnhwKZiLl
         YD0w==
X-Gm-Message-State: ANhLgQ0CGWR6vTW4U6JubU5U91XXxTTZ4+d1Vx0hcqngNBJXICT2EkeT
        sCR/xGNsUWa9ya4BRndxMgk=
X-Google-Smtp-Source: ADFU+vukC2YADQKzZj4lBJDqVQRE8zJ0v0gO6VK1KDZcYIFDdaKlpXY4J9kEq1ALPMIBXxLugGVcmA==
X-Received: by 2002:a1c:4054:: with SMTP id n81mr6282737wma.114.1584662467862;
        Thu, 19 Mar 2020 17:01:07 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id t126sm5670418wmb.27.2020.03.19.17.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 17:01:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: [PATCH net 0/3] Bugfix, simplification and cleanup in DSA tag_8021q
Date:   Fri, 20 Mar 2020 02:00:48 +0200
Message-Id: <20200320000051.28548-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series removes the dsa_8021q_remove_header and dsa_8021q_xmit
functions and replaces them with saner implementations, thereby
redefining what the tag_8021q module has to offer (at the moment, just
the VLAN definitions and install/uninstall rules remain).

Vladimir Oltean (3):
  net: dsa: tag_8021q: replace dsa_8021q_remove_header with
    __skb_vlan_pop
  net: dsa: tag_8021q: remove obsolete comment
  net: dsa: tag_8021q: get rid of dsa_8021q_xmit

 include/linux/dsa/8021q.h | 16 -----------
 net/dsa/tag_8021q.c       | 57 +--------------------------------------
 net/dsa/tag_sja1105.c     | 27 ++++++++++---------
 3 files changed, 16 insertions(+), 84 deletions(-)

-- 
2.17.1

