Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3DE31C36C
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhBOVKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhBOVK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 16:10:27 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FBFC061756
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 13:09:46 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id g3so7322146edb.11
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 13:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pYUs74n/bFM+2q8/YP8zFl2xiBhj16uaeXbAJo3RWmQ=;
        b=uRb+uxjW6ItqxA914icQ0XuUr2E7ZXdtnz1Fl+zQ07P0H+VtZMQF9cCSXWMuNZAW2g
         ZURk/rMH2+83nlVLe8cLHP3ZLsJVVwDH7kooav1LsodGiMaTwVfcJeP7eaTRB4CTNS79
         819jH8l+42nRoWs4WnI7ACsV4CEKXiQkBK2Ew6cPQMxh2/yIPFa5psO13sPqSjMEtaw0
         O5ucA2cdfqc7KukjqKEGOhPsKpRYqxKkJxD6pMMGU2bWB9hdC6s1stvVt3uO4vXYMkLx
         ZYFOW+1foZjLVmK6LLUJPH+ePjwhxsc9o4MLftmAnaEw9p4LEGeCJUxeN+8GPIs9REmH
         mzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pYUs74n/bFM+2q8/YP8zFl2xiBhj16uaeXbAJo3RWmQ=;
        b=ENeHM/suuR5QVAo3m2lgIs8ozLe+NpXVCM3ex6uxYyNrq2l6P06aD9K2B4QyNFxVqc
         ycOXAnsfHbl9Dythw/CjGR9IgYpgEpR+GlYwakOb5QaVHPpebU9Yx6vGVAAFWABAJd9O
         4M9ui508H4LvTnv37w7w2NPyZ3ubVDBsxMLKhpNCaC44fjmJ5PeBRySg8awL7h5yNHKW
         ntmE/dsZIIFPZB7YVtnLZl2GY4N4zXL96SNpFo5VCyOOyGFI3cdXWZVTohw1OnVYT7ej
         3aXtf5Nj/FToebGjRnayJhji3ddkCwz7ob6mfmgiECMIy8aIGBqSF5YpANuOHUZQ8f0k
         1+wg==
X-Gm-Message-State: AOAM530auZYQjTWrXdYKfkhy+1MHYVf9rzpZppChabJ3YEwx9n6sz+SY
        hzxJcZoKvWAN9QzT0voPk/A=
X-Google-Smtp-Source: ABdhPJwra3tyIg/HofsIg5eeR6W2bIRjJb8OOsRpEhtVUHOgduKELIDHzGawcexSdIcZKl1hAH+6wA==
X-Received: by 2002:a50:8b66:: with SMTP id l93mr17237296edl.384.1613423385556;
        Mon, 15 Feb 2021 13:09:45 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id n2sm4200418edr.8.2021.02.15.13.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 13:09:44 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 0/2] Fixing build breakage after "Merge branch 'Propagate-extack-for-switchdev-LANs-from-DSA'"
Date:   Mon, 15 Feb 2021 23:09:10 +0200
Message-Id: <20210215210912.2633895-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There were two build issues in the 'Propagate extack for switchdev VLANs
from DSA', both related to function prototypes not updated for some stub
definitions when CONFIG_SWITCHDEV=n and CONFIG_BRIDGE_VLAN_FILTERING=n.

Vladimir Oltean (2):
  net: bridge: fix switchdev_port_attr_set stub when CONFIG_SWITCHDEV=n
  net: bridge: fix br_vlan_filter_toggle stub when
    CONFIG_BRIDGE_VLAN_FILTERING=n

 include/net/switchdev.h | 3 ++-
 net/bridge/br_private.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.25.1

