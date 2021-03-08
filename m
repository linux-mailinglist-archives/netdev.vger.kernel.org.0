Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74183311A0
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 16:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhCHPFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 10:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhCHPFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 10:05:15 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DD1C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 07:05:15 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id q25so21459554lfc.8
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 07:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=o3g/v+Gz+gUjzlI3Q9NR45Mxou8BEM9BgV5qcyMRt7g=;
        b=0ISk/T+3dgJDMUPj70BAkQCB+VbASZFu8jhOftwQw81SNmQfLnyRTQdSP2J2HzN2pV
         kisz/DpuLdRcjKCluMNPJux5Qj60x/oCMorPUDvamIzFsIi5BCfdq0TAJZxUZvr8lRlL
         BX6h6MNsdb63RwXAbNP9p8AGdMOZFUTzK3FEFNjoWKNlDT6zZuDbjPPA+1Pmlp4tE1Lo
         gW67gjNuAgqosmr1XxSgCxGI4LLV6z7UQf7diWOly5efO8wn7efp+M+j2xnee4P3PR1e
         iMkmafYCXY2tJoy+nJbzD1PIugz15flW3nuYqFyWhSr1JjT29buhpk9UOzsliQjMaUxo
         ijSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=o3g/v+Gz+gUjzlI3Q9NR45Mxou8BEM9BgV5qcyMRt7g=;
        b=CnlV+83/UzakTEul4KVTMu346OfcL3evidmHoG8hTuC1X2AhfLd8wWl4TD9US4u1FN
         hsuWJzEWcnp/7hZz8kMBWtEppQpI828Joe4q4/INmAVqTpCOnnk5sXOFeuSsbKJHPwef
         hIkOTkS/eGXXObWZkkYAPuqdaHzeMlOVHjm8vCDdD+zB0FBw+Pci4buaXQMaFSsATaeF
         176egGjSba8ieNQW6njsNwXWJKz2qbE7GPpoM3ycrM+sjqbWecqfrMV3Ev46Mt7yu/nk
         0uBJhpl7p/mI8EOaXk15mTEHiWkucHM8MLFyYfyqNXZG3b9NOb4nNZW6hW37zoK7/3rB
         OIdg==
X-Gm-Message-State: AOAM5316VWHLBlxt7Z8dDPDGWrWbZtGtRp7RrKlncm6p8v2tnvBau2bn
        +tO6VSjRHtulpmjBp+puO/A9lA==
X-Google-Smtp-Source: ABdhPJzvRoVaQYpS5UYwbD2RLe04SuXFoehXQb7v5gJrTim7jxuU0neheuS7jhM32q3OPMPBhajPzw==
X-Received: by 2002:a05:6512:ad4:: with SMTP id n20mr11271895lfu.507.1615215913535;
        Mon, 08 Mar 2021 07:05:13 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id i184sm1385696lfd.205.2021.03.08.07.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:05:12 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net 0/2] net: dsa: Accept software VLANs for stacked interfaces
Date:   Mon,  8 Mar 2021 16:04:03 +0100
Message-Id: <20210308150405.3694678-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First, re-introduce the ability for drivers to signal that VLANs for
standalone ports are not offloaded.

Then, make sure that mv88e6xxx never offloads VLANs for standalone
ports.

Tobias Waldekranz (2):
  net: dsa: Accept software VLANs for stacked interfaces
  net: dsa: mv88e6xxx: Never apply VLANs on standalone ports to VTU

 drivers/net/dsa/mv88e6xxx/chip.c | 40 ++++++++++++++++++++++++++++----
 net/dsa/slave.c                  |  9 ++++++-
 2 files changed, 44 insertions(+), 5 deletions(-)

-- 
2.25.1

