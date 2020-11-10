Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2632ACBB7
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbgKJDbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730249AbgKJDbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:31:21 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE43C0613CF;
        Mon,  9 Nov 2020 19:31:21 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id q10so10145593pfn.0;
        Mon, 09 Nov 2020 19:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Otq5Ki3MUwA1fHHIPIs9PXe0ltw4hYmVmiE8MSdi1wM=;
        b=DQ8n+ccJqzyXKB4ZwCvhvv43UTiaV82+HkVz0M/eOLgAbKPlc75FbM/z5uoA3tZe7y
         iE1RsE/8KANlCjqZegv5Y/3/55IwyGiUWYuhsAJfcK6+CRsf8rCn4V5aIG6MO3JgqRxv
         MmlFPGP9FjEx/H1VikA+sepo5JyQoE8qYiYROtmAHB9jj9LXkY/IZY7WW66yxtJ3OWye
         e6VmkwGZgURnrCUs5Z0eCBZRqRdjdIH5GKGGexoRJyOOnmGNcaDNQZORqgmIf2AHCHxi
         Xiu8ajupf3UjxjuI0g69krrEgldyzohqrQLoL4EA/6poOiYawxRLUc8mGc03O7X7wzwA
         yroQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Otq5Ki3MUwA1fHHIPIs9PXe0ltw4hYmVmiE8MSdi1wM=;
        b=eNvUeKzdCufgLP7g9yz72kzd8PMhXjy4QPUSk70xkSfQVeCbDenbp8bF5fcsFMOj4X
         WXva/kldTUI8/Kkyl6m0YAzPQRUyEM8U1sQjCS7yxOhq4JIpkDsQMyFUO+uIgLTH9Bof
         rJwmE7ep1+W2AhZgXr0eV0CD8Wlaf4AH3htfCY2xsBQUEAGWdmsnHJyN4VRsYECe1Zi7
         U1Oihx9JKK+e63UshSJuXQWHA+MOcTxMODx4GyN1memfVp+rmTYPs/hOodHuerpIcB2w
         3iGoneGe34ckQSShTpQl0kZEkxrOpK+kIVz1Ncu6CPpkMifO0hsvjmpfkWyLkp87SrH7
         RkyQ==
X-Gm-Message-State: AOAM531SL+iQHM/inlZCowguI1+04XusKWX2AREXSa36JkhncVQBwWYE
        h2KQ6kZ8lskp4C7UJiz011Z8O7PyXZc=
X-Google-Smtp-Source: ABdhPJz+JL9a4NANf4bTcYXpmCpM4HFv+kQZ9J+HaHlyW3OXCz9w5abNaXZEBb6GfgwmbmPFYPj93A==
X-Received: by 2002:a63:1f53:: with SMTP id q19mr15607555pgm.286.1604979081084;
        Mon, 09 Nov 2020 19:31:21 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k12sm965677pjf.22.2020.11.09.19.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 19:31:20 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE), Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE), Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH 00/10] Broadcom b53 YAML bindings
Date:   Mon,  9 Nov 2020 19:31:03 -0800
Message-Id: <20201110033113.31090-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series fixes the various Broadcom SoCs DTS files and the
existing YAML binding for missing properties before adding a proper b53
switch YAML binding from Kurt.

If this all looks good, given that there are quite a few changes to the
DTS files, it might be best if I take them through the upcoming Broadcom
ARM SoC pull requests. Let me know if you would like those patches to be
applied differently.

Thanks!

Florian Fainelli (9):
  dt-bindings: net: dsa: Extend switch nodes pattern
  dt-bindings: net: dsa: Document sfp and managed properties
  ARM: dts: BCM5301X: Update Ethernet switch node name
  ARM: dts: BCM5301X: Add a default compatible for switch node
  ARM: dts: BCM5301X: Provide defaults ports container node
  ARM: dts: NSP: Update ethernet switch node name
  ARM: dts: NSP: Fix Ethernet switch SGMII register name
  ARM: dts: NSP: Add a default compatible for switch node
  ARM: dts: NSP: Provide defaults ports container node

Kurt Kanzenbach (1):
  dt-bindings: net: dsa: b53: Add YAML bindings

 .../devicetree/bindings/net/dsa/b53.txt       | 149 -----------
 .../devicetree/bindings/net/dsa/b53.yaml      | 249 ++++++++++++++++++
 .../devicetree/bindings/net/dsa/dsa.yaml      |   6 +-
 MAINTAINERS                                   |   2 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                |  10 +-
 arch/arm/boot/dts/bcm5301x.dtsi               |   8 +-
 6 files changed, 268 insertions(+), 156 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/b53.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/b53.yaml

-- 
2.25.1

