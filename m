Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120DF362A30
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344287AbhDPVX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344280AbhDPVXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 17:23:24 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CB7C061756
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:22:57 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c17so19175211pfn.6
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CODT/l9wKNWBpQaDvOl66Tu0sYopza7reL9vKUiw/uY=;
        b=Q223E8YiG2Uing5+vQRc/SIQG9F41JyBDQfS3DsJo8NG/TIoHP8YuSaS4cVI1nfrdh
         3GmJDA8kD5yQ1aDYbQvpkbXAen8t2yM9S732rgRFwR3p8VWNkz+AEz4FZVc4WqY+y88x
         upOprON0paEsrUT/Z5Qz+uFFuPSbS/P98+fFBQfsorkHLNh4hDFQv33UfUTf6x4MONqv
         4yhsTUHXADkUimLny5lS2GBuCO9Rj6/63dBwdSbz/l7srIUXqHRSziwJJ64UvSKJFfWP
         4WMmShRJqN4gAUY1K79HithDio9yIPtv33kdkinfNidanBB2r22zgddhJgBJgSqNkeo/
         6Xrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CODT/l9wKNWBpQaDvOl66Tu0sYopza7reL9vKUiw/uY=;
        b=BVzJmfiNOcMYM6zBPUIftJdE0eCQJz0zAM4uYKJ88mE3p3yLjLZYxS/gYCyQGvEqD2
         fYkSJyTRrDkzUNskxoPngr/62qSiuzxAJJDwAfY1DrCAZBjur6fRg/YvbWcfNPeEHL7t
         7QEmzLSejN8Fny61kbQgle8hfRPgBLbCzMv551vvmQygltPUNGnoPyXVFGhXCpS97e4q
         6J2ZZBAjXlrioLvmrBN08C+w6nXTn8CLBMXqgihbYNxOVvwpmo0tn7QQqbrEfT/xqSa8
         yWLwszRca0SrrpXsr25XTUMnRvs38lEXFAOLDjZ3raA3y8Z5OIf3/j5N/uOX2N4BMVl0
         mSeg==
X-Gm-Message-State: AOAM53083aLzYxV1HOSpKw+n1rqGiCsA0xR3AtpfnZWFewXYRlOckYuW
        uJs9exUM3TMJzgWpCjM9TBFziCG5Se6vLw==
X-Google-Smtp-Source: ABdhPJxAbz7Gj4UNBK7IYRg0P1x4yx3Qix8hI/lcyaaCsLlcJF//j4QkV+w2HG2Rm6wq8BHMaERbLQ==
X-Received: by 2002:a62:68c4:0:b029:226:5dc5:4082 with SMTP id d187-20020a6268c40000b02902265dc54082mr9205516pfc.48.1618608177399;
        Fri, 16 Apr 2021 14:22:57 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t23sm6069132pju.15.2021.04.16.14.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 14:22:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 00/10] Fixups for XDP on NXP ENETC
Date:   Sat, 17 Apr 2021 00:22:15 +0300
Message-Id: <20210416212225.3576792-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

After some more XDP testing on the NXP LS1028A, this is a set of 10 bug
fixes, simplifications and tweaks, ranging from addressing Toke's feedback
(the network stack can run concurrently with XDP on the same TX rings)
to fixing some OOM conditions seen under TX congestion.

Vladimir Oltean (10):
  net: enetc: remove redundant clearing of skb/xdp_frame pointer in TX
    conf path
  net: enetc: rename the buffer reuse helpers
  net: enetc: recycle buffers for frames with RX errors
  net: enetc: stop XDP NAPI processing when build_skb() fails
  net: enetc: remove unneeded xdp_do_flush_map()
  net: enetc: increase TX ring size
  net: enetc: use dedicated TX rings for XDP
  net: enetc: handle the invalid XDP action the same way as XDP_DROP
  net: enetc: fix buffer leaks with XDP_TX enqueue rejections
  net: enetc: apply the MDIO workaround for XDP_REDIRECT too

 drivers/net/ethernet/freescale/enetc/enetc.c | 140 ++++++++++++-------
 drivers/net/ethernet/freescale/enetc/enetc.h |   3 +-
 2 files changed, 88 insertions(+), 55 deletions(-)

-- 
2.25.1

