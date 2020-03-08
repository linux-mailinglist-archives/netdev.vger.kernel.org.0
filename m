Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C867017D0C6
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 02:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCHBPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 20:15:49 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43589 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgCHBPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 20:15:49 -0500
Received: by mail-pl1-f195.google.com with SMTP id f8so2504726plt.10
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 17:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=O3vxefhTmXOP9j1Qu3cFiTCJtsUPwf3j5ArMZf7EzZ0=;
        b=PxMAh0KKik/VEutoJ6/sv67ZUMgDZYvC+SgDTWbh+q+0Aohc9nthngcuCak972ci9W
         pq01SHKIqMXXQoaP+MN+uKgedyPosZl50/obcgNI+4EmuDl1tMdLy8fYq/kwGeZopdOc
         1Gd1JUp2UIizyJBytT9R5KYbMveiXs5Iz9thXaWpuWfK0v6+Vq6Cn0NP8U+N19ooT5lh
         WYqJ0W1Wp7kw0n5UV8Zqitnx86ldQunCE2LFrCyqhOMvNO0I0pSjcFQDM0cLmq64mg+o
         8fey2l6ZZ53Yk9y1fqFiPjCLK+dHIRz/0xzaQ8qFVbMiZ0WGHG+3CSv43kYUMLKB4P9N
         e83w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O3vxefhTmXOP9j1Qu3cFiTCJtsUPwf3j5ArMZf7EzZ0=;
        b=rxUnxrQmehpEoeIwfS8SZ6nh0K0SFCEPVSf7JmcNbTWZc0iGMdct1rhAoB7PvCrssr
         09d/2TDDQjFx2USLzaAq9B7KiNqTHHZNab2a6LgkYGVGFK3ZVK7rDpk7K8VZvUoqDdQ9
         ew5kKVQy9cW/c8KTRYC/S9CCxkDpI5Rj9nCknA80eZMNSRs6ZRRIXc9uKqPMy0t/+F52
         cP5NrGv1J4K/f+Rb6yB4mdiyvzduxtUqq//6AKD2miq9fEAzz8OhnWse3klfCOL7sDGA
         +TJzIuv4SzA9R/pj6Bnn2HVB1vGE/MjsB2+HcYSKvKzrNUIlXAVC/4YA6+I6X6yEZCpD
         hSiQ==
X-Gm-Message-State: ANhLgQ2bDn5YMWL986SVpIR0Hf7B8gwkOktsFm+LpSkVV72KoifcgoXH
        higCfM5gjvTuWcbe+V3IBt0=
X-Google-Smtp-Source: ADFU+vvXt9o0Ehi1R9o3pXLkDjQ7QMj7OtX8mWIoXc/xApQF8gu0KEieouvd730AVgVA+JqqVbbvfA==
X-Received: by 2002:a17:90a:30c3:: with SMTP id h61mr10931832pjb.50.1583630148313;
        Sat, 07 Mar 2020 17:15:48 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id n9sm36793760pfq.160.2020.03.07.17.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 17:15:47 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        martinvarghesenokia@gmail.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 0/3] bareudp: several code cleanup for rmnet module
Date:   Sun,  8 Mar 2020 01:15:10 +0000
Message-Id: <20200308011510.6129-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to cleanup bareudp module code.

1. The first patch is to add module alias
In the current bareudp code, there is no module alias.
So, RTNL couldn't load bareudp module automatically.

2. The second patch is to add extack message.
The extack error message is useful for noticing specific errors
when command is failed.

3. The third patch is to remove unnecessary udp_encap_enable().
In the bareudp_socket_create(), udp_encap_enable() is called.
But, the it's already called in the setup_udp_tunnel_sock().
So, it could be removed.

Taehee Yoo (3):
  bareudp: add module alias
  bareudp: print error message when command fails
  bareudp: remove unnecessary udp_encap_enable() in
    bareudp_socket_create()

 drivers/net/bareudp.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

-- 
2.17.1

