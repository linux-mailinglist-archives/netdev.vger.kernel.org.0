Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3265F60F50
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 09:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfGFHgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 03:36:46 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:44900 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfGFHgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 03:36:46 -0400
Received: by mail-pl1-f169.google.com with SMTP id t14so2536321plr.11
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 00:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=VABqYXgsPm89GK10K6Rz3VlhdcFIHafLzpuKLunCfNk=;
        b=Q2eRBYXwmc0iAoL6B1fpCqfNX24+6tv5GQALMoyuirzgLv+RZWOQ4/zKoOCf5PaaFJ
         xjAP+bcbk+BGGyz+w41CA9DqNzytyyFKiSIlDZPu9teMjb7qqlos1Y+RWs2o3XMd8Vhc
         9E4cFOfd6kARFhareP8tUdc1I3bTCRe4GobEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VABqYXgsPm89GK10K6Rz3VlhdcFIHafLzpuKLunCfNk=;
        b=juRnVOmP6+nKWfEu+DcJHtl4hxMJXILRqWis2AVF21+0pJJGzKpPOZUxSbUUDrbT+I
         T2JQm5do41qv6SwtkMz+ooS4NniE8RKto5h9AgvnQI6hgawoBXmQSkJ48KLmqFrFQj7e
         7DhxYjzeKzSD8Jty9MqpSHYCp49j0bJfA72Jdr6sX3bLTBy9kD+lZHC/MewYqr/xw3/G
         m7pR+4ZiqUgjHGxXiICG0V8FIR4TeH/kPHhetRf1lnepZUeoo3cFTT6tJNqrHJDT0Q8s
         hUFHiiNwoVs2dKoISmfRJkrTzSeX3nwhFFfR1TxHK6SMS10iXRdzx2W91UxkTtjA4IC1
         TWFQ==
X-Gm-Message-State: APjAAAUoYS/UllPuFfFoL8jO3Q3W9OSaXBZC3BbuH26rPxBng2tNRT3S
        zj6My7WEdflCdun5kSHF15hreg==
X-Google-Smtp-Source: APXvYqzW4c8HenTYMkoDeAeuV7ylKgFG767lP/WMV1XA2gXD44NEwlOD/E4j9ST6avrYy6pDsvwkKQ==
X-Received: by 2002:a17:902:29e6:: with SMTP id h93mr9643389plb.297.1562398605222;
        Sat, 06 Jul 2019 00:36:45 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a10sm1520144pfc.162.2019.07.06.00.36.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 00:36:44 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, gospo@broadcom.com
Cc:     netdev@vger.kernel.org, hawk@kernel.org, ast@kernel.org
Subject: [PATCH net-next 0/4] bnxt_en: Add XDP_REDIRECT support.
Date:   Sat,  6 Jul 2019 03:36:14 -0400
Message-Id: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds XDP_REDIRECT support by Andy Gospodarek.

Andy Gospodarek (3):
  bnxt_en: rename some xdp functions
  bnxt_en: optimized XDP_REDIRECT support
  bnxt_en: add page_pool support

Michael Chan (1):
  bnxt_en: Refactor __bnxt_xmit_xdp().

 drivers/net/ethernet/broadcom/Kconfig             |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  65 +++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  17 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c     | 144 +++++++++++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h     |   7 +-
 6 files changed, 208 insertions(+), 28 deletions(-)

-- 
2.5.1

