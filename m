Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE13B3639DC
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 06:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbhDSEEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 00:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhDSEEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 00:04:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1A6C06174A;
        Sun, 18 Apr 2021 21:04:06 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id nk8so3976379pjb.3;
        Sun, 18 Apr 2021 21:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hOsZ6ZAWuon3dm2MZrd8FkaSau84thpl7XFQwU5olAc=;
        b=FRj2Oc2qKXjJ0+HRBeXKiZNcvm09E0wR+zi4pf4hYThpFVjDmoirdE9srkAX23K690
         h5SgoI2Q9EtS72FDV4ipvZvWtfv/GUgNBfVJXenX/jt4ILBLY3h5UpBG2zmX3G0XhGhY
         2B80K8gWjkqK11sry1/PAjH9ZckonsgQBCNdSlOg+NyIQr85926xkyRHJZICg8RQyJFE
         j+MtbJkaxdq71+82qyKN7DSmv5wta7bkLxA8qQ57BzI8dBS7lefmasAnQwZLSRqFN7T+
         udc9CAZJ2i+038e463+wn85ZvR1F4jbZN8eNPOn5R9QjC1kd7m58N8N85MgNgoRoCaIL
         u7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hOsZ6ZAWuon3dm2MZrd8FkaSau84thpl7XFQwU5olAc=;
        b=m69wF1TPmy9Sflo/W9HSZTeyUf6nPBWaf3jw8AThLIaJv8Jpuk9xPD40FJP8sqWIJC
         3N4CxDJDGtySxvgPHAVCb+NoDA3rrtGHS5pSFeq2unvmNZbFNh3JUI3Z/1AIYJ2erL1w
         mN7vPoOxogI1G6YcOpfNaFi4fcho06jdUrJ/OZy2aRbuNvaI2tcZDyFMuETqeffrTVNT
         RbPBvgX90/JiOToBfADsTk6TM0tGdwePxtlpH6lWGhnrbVe8ua45CG1dYomhKvrOmMsQ
         HAixxa0ZDITIrM5EHSjQbCyaIekdMDSQ7zIQBNrMm+UhTKtIZ4Fnd6bJfrSUL2MeeZeu
         dfzQ==
X-Gm-Message-State: AOAM530c+EmiZozAva5bdD77NduXhjXoc5wTUxBJqBaSrsEJe7LG4fis
        PiHBVwb+20pyMI7+2vVWtZY=
X-Google-Smtp-Source: ABdhPJxcKeTMm7Gcj5hsB5BDdKOpKVQoZ5Z1KI2psRngBPctBvPcf7fWZupUj0ZXMHy0StJVBT+jyg==
X-Received: by 2002:a17:90b:3646:: with SMTP id nh6mr22581469pjb.119.1618805045663;
        Sun, 18 Apr 2021 21:04:05 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id 25sm12169423pgx.72.2021.04.18.21.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 21:04:05 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 0/2] net: ethernet: mediatek: support custom GMAC label
Date:   Sun, 18 Apr 2021 21:03:50 -0700
Message-Id: <20210419040352.2452-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for specifying GMAC label via DTS. Useful when it is desired
to use a master DSA interface name that is different from the "eth%d"
pattern.

Ilya Lipnitskiy (2):
  dt-bindings: net: mediatek: add optional GMAC labels
  net: ethernet: mediatek: support custom GMAC label

 Documentation/devicetree/bindings/net/mediatek-net.txt | 6 ++++++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c            | 4 ++++
 2 files changed, 10 insertions(+)

-- 
2.31.1

