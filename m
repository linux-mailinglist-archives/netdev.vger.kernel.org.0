Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058C4E3C44
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408214AbfJXTpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:45:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40164 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407614AbfJXTpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 15:45:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id o28so27367859wro.7
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 12:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zZ4Rx50dPFBaM4VONr5Y7kfXCz/ijvsc8SYeuhdJ+5s=;
        b=shnXLeWG45R1SBKv46qFJ2nxjKQskk6QkA2eTKOs+V3ILP5mGSotr1/MnO15q0wAHj
         NCYqMhW1lmJFDDJELNu/Xq3W9NPqc0wz9MqU0mY2weIIgYTGUM2sEJ7npkCEcVa4YbDZ
         3aZia6ZGo/qaWlt1HncVK8w0Dzy5ZcBFgrUpLhS0KS3yOjQuLfu+ntkj7NqzFNuGIb0w
         wfcIRtSWSCUWwW8ePaGA+OzqL7aN5ht/d4CWjN57mEwYMSukmP4PCPji8pUZsD6X2Lh+
         yfo+iao7iDuf4msHd+XtR9EhcSRigh+mUBCCR2NSrDsXEkwNkcdItlsGfgmNCdUhmKK+
         k3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zZ4Rx50dPFBaM4VONr5Y7kfXCz/ijvsc8SYeuhdJ+5s=;
        b=nsSReZN49lpl9eEhJ1jGdPr2CuEPrFvXG9N03/MyRi+g7HNlhwRoMejYN/0ijyE1dt
         gE/QC4QTLWU4SaM8oUducsG1QMDGVW7cHsjE39+8Uq3v78Q07HpHC88uFEZW2v5JXEch
         /lQNfZx++cdN/ydzuAkwgbDw1/bbUQ8zQRIXYD5/iNuFBEZF9xnyqvvoo2WNYulbDWoR
         erJQFO6EDLIcgRoCq656ZUimsR6dqal04DmIsLUUab2KvMgZZUvu7LwIFYP9ranS4foI
         4Wdm3WQ7TFjVj+4Pm4L1HTNegVR0QIlNwiiLpPG8IYNrXHWs+rasJkXvKu1NuhwwWtJk
         tB5w==
X-Gm-Message-State: APjAAAW3AipukxybQAmcY1jxxZObdBfJ1MEzTGDZOCqA32jZSnJOmEvS
        8WpsIhqhFWj1giX3a4tQDe0x0K0E
X-Google-Smtp-Source: APXvYqzRaZek09vgTtcO51NlP+dXWwvSrsTjZmxRZz55clqLt6wCJ+3XlHKpUXZa5kMjbS3ww67aog==
X-Received: by 2002:adf:9b9d:: with SMTP id d29mr5422968wrc.293.1571946315239;
        Thu, 24 Oct 2019 12:45:15 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 37sm39273250wrc.96.2019.10.24.12.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 12:45:14 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/2] net: dsa: b53: Add support for MDB
Date:   Thu, 24 Oct 2019 12:45:06 -0700
Message-Id: <20191024194508.32603-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series adds support for programming multicast database
entries on b53 and bcm_sf2. This is extracted from a previously
submitted series that added managed mode support, but these patches are
usable in isolation. The larger series still needs to be reworked.

Florian Fainelli (2):
  net: dsa: b53: Add support for MDB
  net: dsa: bcm_sf2: Wire up MDB operations

 drivers/net/dsa/b53/b53_common.c | 62 ++++++++++++++++++++++++++++++--
 drivers/net/dsa/b53/b53_priv.h   |  8 ++++-
 drivers/net/dsa/bcm_sf2.c        |  3 ++
 3 files changed, 70 insertions(+), 3 deletions(-)

-- 
2.17.1

