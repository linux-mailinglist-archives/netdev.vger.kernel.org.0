Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A01E4112C5
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 12:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbhITKUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 06:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhITKUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 06:20:51 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66B1C061574
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 03:19:24 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id 11so2346150qvd.11
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 03:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/3jkhx/6WzTCM+3srn8UkTOoOFfpwClkCb2IAqRgocI=;
        b=EVTUJcJesVPyGEOlz1oBB3+SEepmUIdXIA2oXAeCm2AMCi7RdgGJ7BlxjucFQjTof8
         cQxIlrjCCLyTPXmGqzC8HmPdH039eoZXEYiqsfznC12A3vECFlWhx+DhzaGeFgPPv3Yq
         JRXcfoPp64N3NiBr1IzbUGzHjPb7miaa8TE68WjdfXs/u5gjlKU6fdgmrH3hnY4treKI
         0N2uZvmR16Yu8WgyxuvOFtJAbV7OTSR7R58DvRTGBClmVI/pimry5n4vocmc6F/hMmCb
         BVARqQCmVTaW5xTEzX8vLhTSyL8yA2FcKDQvx+AKyiHI0Fk5YL+KY91QIwupniWoJyE8
         G7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/3jkhx/6WzTCM+3srn8UkTOoOFfpwClkCb2IAqRgocI=;
        b=vMSVXF/SYRAAf5l5hDHzRX7z7RkZq0VyYMfSyMuLZ9OWcLAFyHZKms6rrBVMzhHVBb
         jnh/Op4EyLNRp+ZMU0t0BFrcJVZVUMthnUE/BACuFFQ+afUtVZD+8S+Su3aPvNTsjexm
         0U+DB3GrycHxe6SmW1xeczfe6vkd2Z/aduScVJ+Fifu7VdDaclKI0ymOD6BQFd/Zw4m+
         s2GQdgcVnIjo5du5UdadcX1zYoHf0icRd5rHGvxfYVL9tvAti5XDystsI7dUadZ8/OqF
         kbTUK+c5Kft+oXw0tT7QrhHB24zAbdkh421xi1lSrCve5OLajxqrE/hk/g/yXA7AKI+Q
         0xtw==
X-Gm-Message-State: AOAM531MiVfrmxW2/55wLmsP79IK5LQGbcikEry/2ElofN96GP8RJ+Wj
        Li1YP0XuduDNCSWdRqgS/CPfA8FMiedGyA==
X-Google-Smtp-Source: ABdhPJwpaeAdzjV7+0ahZO1BKVDMHn6Ce+1dYsUhVR9fc/wZCzyBz37zYCH/WrDRbv0MNY0lLbIkWA==
X-Received: by 2002:a05:6214:2e4:: with SMTP id h4mr24669725qvu.3.1632133163658;
        Mon, 20 Sep 2021 03:19:23 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u9sm4637985qke.91.2021.09.20.03.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 03:19:23 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 0/2] net: sched: drop ct and dst for the packets toward ingress in act_mirred
Date:   Mon, 20 Sep 2021 06:19:20 -0400
Message-Id: <cover.1632133123.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the old ct and dst carried on these packets mirred or redirrected
to ingress, it may cause these packets to be dropped on rx path. This
issue could be easily triggered when using OVS HWOL on OVN-k8s. To fix
it this patchset is to drop ct and dst for these packets, just as it
does in internal_dev_recv() in OVS module.

Xin Long (2):
  net: sched: drop ct for the packets toward ingress only in act_mirred
  net: sched: also drop dst for the packets toward ingress in act_mirred

 net/sched/act_mirred.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

-- 
2.27.0

