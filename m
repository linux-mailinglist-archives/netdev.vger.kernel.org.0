Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30A838C79D
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhEUNRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbhEUNRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 09:17:43 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5B1C0613CE
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 06:16:19 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id s22so30201644ejv.12
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 06:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pYHD+GGIC69DHLvN9ug04/OX1/8J6eayffNrxZYP2ME=;
        b=jHrJXeGZCXYwwSyKhgKXFDKoNlrubJxc+Duq0YnBDsvHGCpDrsTEUC718PwEHO9aJs
         mQPjy18GV1xqZNvMuP3/BU2lh6iMpve5jWQEEQK8UlfVDAmp6TySzPwmCVZaLWzyEz1l
         Nev3azUFPjggUfpOS56ZJqfMjG8w/knbEzr3CJbtwewg0Fu8yDOmQDTQJg3vajnKZ6jW
         eaBGpj0ONddur/qtiFqHJnanB8/sgOcPVNakvzOkPyQymnUz/QOI4E9aB92rtRHQ/M6D
         Zfhd+reeOiGPO/k1eTFnUXYjSlDzbiNAt+gjtlnQUd/OGux+FngA61H+KZb3MVyGRNGR
         nMBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pYHD+GGIC69DHLvN9ug04/OX1/8J6eayffNrxZYP2ME=;
        b=MBTacrT+pVPAMMgCAbfgXSnF97DYpV9Fu02zLacL0ICGvorOaOq2AhWLAFnyS1zhbb
         ShYH/zVIRa0Dt1EYxvOeVrz73N/da6mCUhcxytbGJrORu8mNqTckdWcghBO47qO2o3vO
         bYBghLdqmf+sTXc1DJQePrEGzS8Uzm5f2J8X+yD5D4JuwaYR4Tq7KVXZm/xd5EZGKuJD
         VdoM/9VS24+RTybvp9mciJINvkHwyazyXZkvOaSWLii4H7mSh6S5P3GomH0QRiCp10R1
         q9sMxptiDDvIFHbfTlLaU4W2BuWsHQO6+FFxjgsx2sYQaguN03JW4ECBCM8XUDEjO2MF
         HiLA==
X-Gm-Message-State: AOAM532zkCEFd+Dgr4PQ8Qy2HIU2B7Q9L2RAIk/POPrBTbMEyuhaR27u
        JxfMuuo7IufLRVPTGjKIKfo=
X-Google-Smtp-Source: ABdhPJxNa4oBVBUoJ48o/k+uLEThozlnmxg+RG2BnLh7nH3gsu/eX8w2/z6ofSiLHBgmBIdf3ZJoqg==
X-Received: by 2002:a17:906:fa0d:: with SMTP id lo13mr10526539ejb.477.1621602977660;
        Fri, 21 May 2021 06:16:17 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id bm24sm3959310edb.45.2021.05.21.06.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 06:16:16 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 0/2] Ethtool statistics counters cleanup for SJA1105 DSA driver
Date:   Fri, 21 May 2021 16:16:06 +0300
Message-Id: <20210521131608.4018058-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series removes some reported data from ethtool -S which were not
counters at all, and reorganizes the code such that counters can be read
individually and not just all at once.

Vladimir Oltean (2):
  net: dsa: sja1105: stop reporting the queue levels in ethtool port
    counters
  net: dsa: sja1105: don't use burst SPI reads for port statistics

 drivers/net/dsa/sja1105/sja1105.h         |   14 +-
 drivers/net/dsa/sja1105/sja1105_ethtool.c | 1089 +++++++++++----------
 drivers/net/dsa/sja1105/sja1105_spi.c     |   15 +-
 3 files changed, 598 insertions(+), 520 deletions(-)

-- 
2.25.1

