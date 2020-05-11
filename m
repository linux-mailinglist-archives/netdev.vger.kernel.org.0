Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4A51CD670
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 12:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgEKKWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 06:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727093AbgEKKWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 06:22:36 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC80C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 03:22:35 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id s9so7045619lfp.1
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 03:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=QpwdVZP/mrhAPxpNDxnDTfFrLaxC+zgR7bK6GtNL1rE=;
        b=xxgJokT4bG7TXPgRdooxx6dzFXNb/hLwsvnGFBv+bd3rDdYdzSczxAAfGXoyZJZDZI
         OsFAny8HEV7cmSx/IPPvNke10B4EnJWuVZkh7WIwm87jH4lpMg0gZMGJ9c2PTCddvbzk
         Ka7Fz29ntCejL5+1Hmf1KiZ4ZeNYv7dGh9msKxzHFPcfT2h52l5xTJnBucJ5qz4vzFUl
         4TJWzm9CTOY0v9B+sV1eBVZ4Si0FTCGHD5RxbmIQs9ddA5xKwbS+yHRSAIzdVb8O3VMB
         jJa9i8IALVI6i/HIN7P49IVnOEKi6/y6NGmL9JE03cKJet8Cl9EUaGRXlHERhzvWN3H3
         8ltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QpwdVZP/mrhAPxpNDxnDTfFrLaxC+zgR7bK6GtNL1rE=;
        b=til2a/lDkkNE4j5ls9kbcXwKVVuXi4xW8RdFBsQqKnkGrP21fVLlZmuZYNCMNuhwXN
         fQEYiAswYRiw+KF2LhSxDXtyn5JiKkcx4GknVEzWmUaG0hTfVj5L7ZUyTtUm/CAN5ao9
         +sRQgPzxh20fZzEop0G/UVG5QgjHyo1bAy7LKuHus3tVVtBf8qdmd+W6u+GoI/ZFbvTR
         8TfE5mR2Ze1QRGfPelhp9HAbauD9blexbFRP8x4XX1wCHhducjw168jNEV/8dA4Okulv
         lkOrRBrxyGn2LNR5gkP7RGBCKzYpXYZS0B4HiDSWvuXflcPzJD7yQZJJYRiY1QZbtAoN
         AffA==
X-Gm-Message-State: AOAM533uErtFRbX0YzCJjg0Eow1JxpYEvK4QtZMyNDtXigay8uIi0jB1
        QBcmN/txPxVP1XalpgZD0/agGp3QYgWf9Q==
X-Google-Smtp-Source: ABdhPJxIpQSKJWTDQVgkNMbZJFUrWq8XpRcag7a3CInvI3wD90ZcJjEu7pH4Rx7bODK4qGoCYzFr+A==
X-Received: by 2002:a19:d55:: with SMTP id 82mr10698548lfn.89.1589192554122;
        Mon, 11 May 2020 03:22:34 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.46.227])
        by smtp.gmail.com with ESMTPSA id j15sm10199453lji.18.2020.05.11.03.22.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 03:22:33 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v9 0/2] xen networking: add XDP support to xen-netfront
Date:   Mon, 11 May 2020 13:22:19 +0300
Message-Id: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds XDP support to xen-nefront driver.
The second patch enables extra space for XDP processing.

v9:
- assign an xdp program before switching to Reconfiguring
- minor cleanups
- address checkpatch issues

v8:
- add PAGE_POOL config dependency
- keep the state of XDP processing in netfront_xdp_enabled
- fixed allocator type in xdp_rxq_info_reg_mem_model()
- minor cleanups in xen-netback

v7:
- use page_pool_dev_alloc_pages() on page allocation
- remove the leftover break statement from netback_changed

v6:
- added the missing SOB line
- fixed subject

v5:
- split netfront/netback changes
- added a sync point between backend/frontend on switching to XDP
- added pagepool API

v4:
- added verbose patch descriprion
- don't expose the XDP headroom offset to the domU guest
- add a modparam to netback to toggle XDP offset
- don't process jumbo frames for now

v3:
- added XDP_TX support (tested with xdping echoserver)
- added XDP_REDIRECT support (tested with modified xdp_redirect_kern)
- moved xdp negotiation to xen-netback

v2:
- avoid data copying while passing to XDP
- tell xen-netback that we need the headroom space

Denis Kirjanov (2):
  xen networking: add basic XDP support for xen-netfront
  xen networking: add XDP offset adjustment to xen-netback

 drivers/net/Kconfig               |   1 +
 drivers/net/xen-netback/common.h  |   2 +
 drivers/net/xen-netback/netback.c |   7 +
 drivers/net/xen-netback/rx.c      |   7 +-
 drivers/net/xen-netback/xenbus.c  |  28 ++++
 drivers/net/xen-netfront.c        | 317 +++++++++++++++++++++++++++++++++++++-
 6 files changed, 355 insertions(+), 7 deletions(-)

-- 
1.8.3.1

