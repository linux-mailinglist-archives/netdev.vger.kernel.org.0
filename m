Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430ED2286E9
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgGUROY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729967AbgGUROW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:14:22 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10B0C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:14:22 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gc15so1665851pjb.0
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HlfYuXUKv5t2xefCLDUch5BfJc/25iRj8e8xuyzamqI=;
        b=C2w4ri5aELGwIVs6ZVGF+CZ4M0r+uhN1nJjFWDxu2ZKBuYiR6YjV9VO+EdABLIdW6P
         h1R3ND4kpURgea90Ite/6vyQBF+dY+vdHGLocPh7SvHx/qyrq2Qs7M4+Aelu0p8yPwDl
         k0j4Git4oiErpLuEkM3/RJJSmCFumh1xwsKA6XD7LXytuiRaMsBSFjhINdHv0xjUWVix
         Mmh+pY2VpVXebxGGRBBJkBsnz478EPlmcm1QrJocjqY63ZiqTCcUJyGQK1lGgHZLwlVs
         Elkh8o7eM+6IakW6z4ccXzBT84mq9SrAvV8j7RSFODyEBrbOoxuNGNgorcaIhWtXt+G9
         4FVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HlfYuXUKv5t2xefCLDUch5BfJc/25iRj8e8xuyzamqI=;
        b=sVfJJ2UIk3GhdyUZBDAYGSVq+278jNzj/nIia8vDiHc4XwcTFjVEVEczxp9854F2PR
         mJAcFOfhctp3IXupo4ARG70MUyI+S+Pm+cNZASnzWRuaHvNVkKqeR1GF5iKopARr3YyF
         p5MziuaF7yGzDzRsjxKszRTkjgHYrrrqleugHSpoqIfgdjp20qw/mDQlxEEGCXbFueOD
         DDq5dwgUooJKcFja+4dPBx0dOYNcG/lPcNeKMqZ2xOG4yqS/XsjWnAr8Q3YNHz6HmbH0
         7m4gDEEmfd0R/WlJC3gjndwS8vOWL2n+WNdGdHCk8pWbjIFHb2jbD5vwGI3iT/RBKZ2B
         s9iw==
X-Gm-Message-State: AOAM5308+is9gvIQ84oO9CjMP44tli1buOmtFky9oIFkjXkD5/qgIgtN
        buXFBslG/l9JD7NxjKtXeGjd4v+14sk=
X-Google-Smtp-Source: ABdhPJzTZQ/J/K4P2wkOfMh1z2smuzsDp5DU4ZYlAUuXEJSLZhPh46pJd8bvs1twVjzLg/nMkv2pEA==
X-Received: by 2002:a17:90b:1b06:: with SMTP id nu6mr5817676pjb.106.1595351662369;
        Tue, 21 Jul 2020 10:14:22 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id z20sm2982305pjr.43.2020.07.21.10.14.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 10:14:21 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     sgoutham@marvell.com, sbhatta@marvell.com
Subject: [PATCH net 0/3] Fix bugs in Octeontx2 netdev driver
Date:   Tue, 21 Jul 2020 22:44:05 +0530
Message-Id: <1595351648-10794-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Hi,

There are problems in the existing Octeontx2
netdev drivers like missing cancel_work for the
reset task, missing lock in reset task and
missing unergister_netdev in driver remove.
This patch set fixes the above problems.

Thanks,
Sundeep

Subbaraya Sundeep (3):
  octeontx2-pf: Fix reset_task bugs
  octeontx2-pf: cancel reset_task work
  octeontx2-pf: Unregister netdev at driver remove

 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 3 +++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 2 ++
 2 files changed, 5 insertions(+)

-- 
2.7.4

