Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C841A7254
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 06:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405140AbgDNEQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 00:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405132AbgDNEQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 00:16:39 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B67C0A3BDC;
        Mon, 13 Apr 2020 21:16:39 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e26so11515154wmk.5;
        Mon, 13 Apr 2020 21:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hyKFoSOT3+JqQspFpmS0qfxT2Hk1NGaZGJAmafeRRtk=;
        b=OGK2Uw7P7H8pQ49HPYbtL3YliUCHUWx4NkZDNImgjmfM2asoA9P20xDbNR43tqEwPs
         8iEqjUan/XnkuRsaI5VZQNG3yX0MrTy7tajEKI1jR3tZaEkXw/phtTfTy6+aaGwJ/Ft+
         Uq+GmI0TUxN9O3+vexT2qqaDMWLncJoPMYxIMcUIrM3Wlq6frsTkTii7Cbt2tdoL8WQ8
         jkJsWg+Q4WSI+C1pDUCG1hVnLFWdHDWq3tWet68694RxeIEYHDSoe4cvz4Q+5WBVlmXl
         2ZYqd40DEjaLk+KpJ4XnGX+S9AMvdHwqcEi3grVOdEyJlpv2o5dYToCyf34ok209dLIo
         Ke9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hyKFoSOT3+JqQspFpmS0qfxT2Hk1NGaZGJAmafeRRtk=;
        b=Uwoy1EqOC4LY3ykrJ6rs4QAJm1nvMNcKAg5Tx7e7pLSQWs/dKx+VgDrAVTYl4DwXo6
         1gZgvll7LbOl03FSYCsar5e8F9S05zr4zxvjROqjTfBZx1Ka/Z+A2EeNH/NXRjB9A8+v
         3CT/ttaxd7GTpKculR0eFr5N8z7lD+8fzmb5Cfo8JhI+q4GQsaO3opwtclgyXMbk4mnw
         zKhmy253swwAMjPwQSElSuy5Kj+cAaz3F++jRbAcXroC5pT2yKAsKZJi8jJRFw28Xstc
         Vh5swSc7gyvahq61LhK/wqVSXj5OKkEMkWq9ZPG2fzOlQTLGqBDxzU4qXEhhA9MpssB3
         vf3A==
X-Gm-Message-State: AGi0PubEnIyYBpyBl22+W/QfW281CX0UOLKOj4KRWFLUmQZlNNzx9rzm
        Dhyoc5QGNMuZ9q6ifNK0n1Ae+u4k
X-Google-Smtp-Source: APiQypLAagBuih4l8BRE4fBYBjWwpOjC3wpu2kO/zAF5kYtC31E5EXaOZj/HyEGbjGDwgkxtAoWyGg==
X-Received: by 2002:a1c:6642:: with SMTP id a63mr20267586wmc.47.1586837797834;
        Mon, 13 Apr 2020 21:16:37 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n4sm16704471wmi.20.2020.04.13.21.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 21:16:36 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-kernel@vger.kernel.org (open list), davem@davemloft.net,
        kuba@kernel.org
Subject: [PATCH net 0/4] net: dsa: b53: Various ARL fixes
Date:   Mon, 13 Apr 2020 21:16:26 -0700
Message-Id: <20200414041630.5740-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Andrew, Vivien, Jakub,

This patch series fixes a number of short comings in the existing b53
driver ARL management logic in particular:

- we were not looking up the {MAC,VID} tuples against their VID, despite
  having VLANs enabled

- the MDB entries (multicast) would lose their validity as soon as a
  single port in the vector would leave the entry

- the ARL was currently under utilized because we would always place new
  entries in bin index #1, instead of using all possible bins available,
  thus reducing the ARL effective size by 50% or 75% depending on the
  switch generation

- it was possible to overwrite the ARL entries because no proper space
  verification was done

This patch series addresses all of these issues.

Florian Fainelli (4):
  net: dsa: b53: Lookup VID in ARL searches when VLAN is enabled
  net: dsa: b53: Fix valid setting for MDB entries
  net: dsa: b53: Fix ARL register definitions
  net: dsa: b53: Rework ARL bin logic

 drivers/net/dsa/b53/b53_common.c | 31 ++++++++++++++++++++++++++-----
 drivers/net/dsa/b53/b53_regs.h   |  4 ++--
 2 files changed, 28 insertions(+), 7 deletions(-)

-- 
2.17.1

