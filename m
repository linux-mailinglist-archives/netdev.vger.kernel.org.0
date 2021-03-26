Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0A734AAF2
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhCZPGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhCZPFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:05:32 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9202CC0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:05:30 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so4374233pjc.2
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cooperlees-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=lIoZ2GJa10LwJKhuQsIq7NQsmtB4RchE8GWPTnD7cXY=;
        b=f20VNMf55TFctOvfx6mPa1o8MMXYFZzmCXe/0rlGGQdvrOoTxu1oWu+S4itT6NUahm
         ACVyaOKPlQGkS6UWdquW2r8QYrceJrHzO+rxNR9yi5Oe0QmwOMmqZcG2MhIJbu5mP6Hy
         OAQ2Ug+iEG82pIJaDLCq8MlFeo3C+o1rBRxGZ0BlZvm5IGr+TzE7I5CQ0yw8Io0NHzeB
         D3drzPpg9UNzBmCbVTRfsh/QYMfo8jhvRm0KrQxp9LqGQ9Mbvm14DDEkv7EhX1b8Q80a
         u4SJdoPCqDgDegiM9eSvhg0tryVCkxxpfpkw8v7OezevIQV6wVHG+zHxWgvO18308Za3
         8HWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lIoZ2GJa10LwJKhuQsIq7NQsmtB4RchE8GWPTnD7cXY=;
        b=VTx1t/cdEbMTana1jUfrVPQz77kkHJnQYhWv0mXBAy8ocXpX1c7rU4s+24CiitWe+i
         4oyWVxc4XtqpbFwn2PZ164byxLFzBD2Eaiinwm1Is5dEt73AMT+Sl0zvV56RCcqDGbuV
         LX3l4l8T7Gs2pHv+cH1r0nusvzowElFYADkFB9lQMjytMNoLTo42vthvC60ozBonxmGn
         DPoU7gLoQUGHpfTd5Uslmk7zI0yWF9QoMH9bDCq6ZG9dpk8q+HMI3Rl9D8CKKwKrGJFi
         72Z7oZLUQDjR4uL1T6BQ/ZUOON4y5OCw4PdTyJOP+ikKXOqAeu13CsSH3/enh142uUKu
         lszA==
X-Gm-Message-State: AOAM531GHW+LmRMaWLVjPXLV73mGAC+JnDDhaPcFOZBoP8Vu7fEk2Aj4
        CECtXS25zCWsWXqCoXtoBU/v7HS8Dp1XuQ==
X-Google-Smtp-Source: ABdhPJzkghl8RYunxSumWR/tzJ5psGzychTinTQ7BYsHurbtRCFuFQ0YwYEUfyBSMnpR1wPR6JYR0A==
X-Received: by 2002:a17:902:442:b029:e7:1dfd:421a with SMTP id 60-20020a1709020442b02900e71dfd421amr4264511ple.7.1616771129963;
        Fri, 26 Mar 2021 08:05:29 -0700 (PDT)
Received: from cooper-mbp1.thefacebook.com ([2620:10d:c090:400::5:d759])
        by smtp.gmail.com with ESMTPSA id x1sm8853768pje.40.2021.03.26.08.05.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Mar 2021 08:05:29 -0700 (PDT)
From:   Cooper Ry Lees <me@cooperlees.com>
To:     dsahern@kernel.org
Cc:     me@cooperlees.com, netdev@vger.kernel.org
Subject: [PATCH] Add Open/R to rt_protos
Date:   Fri, 26 Mar 2021 08:05:13 -0700
Message-Id: <20210326150513.6233-1-me@cooperlees.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cooper Lees <me@cooperlees.com>

- Open Routing is using ID 99 for it's installed routes
- https://github.com/facebook/openr
- Kernel has accepted 99 in `rtnetlink.h`

Signed-of-by: Cooper Lees <me@cooperlees.com>
---
 etc/iproute2/rt_protos | 1 +
 1 file changed, 1 insertion(+)

diff --git a/etc/iproute2/rt_protos b/etc/iproute2/rt_protos
index 7cafddc1..0f98609f 100644
--- a/etc/iproute2/rt_protos
+++ b/etc/iproute2/rt_protos
@@ -17,6 +17,7 @@
 16	dhcp
 18	keepalived
 42	babel
+99	openr
 186	bgp
 187	isis
 188	ospf
-- 
2.13.5

