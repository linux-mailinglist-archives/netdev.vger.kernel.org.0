Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAD33BA21B
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 16:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhGBO3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 10:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbhGBO3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 10:29:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400E4C061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 07:27:02 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b8-20020a17090a4888b02901725eedd346so3245678pjh.4
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 07:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LVdwwqVF/XZk39P/8nVH8GZpFL5LYEAsDqyuMwIEhh0=;
        b=KNwieUJbjyrDJya825rX/JxeJpZaH1FqOC2VBqqewLgfWC1uXzogpz3jh0X1HV4HUw
         5PGr3jO4W30awUg9jRxlP0ILhPoSXOgzD3QmGLTlwQSI2JXEvSyE8bZuErmViv02Wlnk
         TOSWHCjBOZvUZ2qap5yqdrdRTqY3II0U2yNlg0dVt0paH7LFh6GKZJOIsbEnlvcV3R9R
         pPmdobiZh0Cl4FhhoPzSyR2RUa3TYLK7Xq1LqcHkRXBVCVCARZgBEQw1PD9WyhM7inkI
         T4KRu92X5DxUWku5djVMJ+bwDkAl5VgwQlGZGYDUBjniUeXFHdCUrImdebpUukIQRO9P
         8ioQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LVdwwqVF/XZk39P/8nVH8GZpFL5LYEAsDqyuMwIEhh0=;
        b=p2nHphLKiUEimWhz8B0izEhMrvdP3Ch7fp2cJjg98d27ICJYvQcClBzxsxAe2y4Dkr
         pnYQ2G9+lVcurzUnLe/RyrC+F6rdZMgJUayeMIxipZ4dVkE1UfjQIHx78rpgmqC2LqTp
         AnB1P13OLV774BxKTZgF7SG68OkOdlppfVgiR82rLYrNdEWUXff5eRqdlzhI/KvCX1Ou
         2laykV6SPHAcH+AQzBrAYe41QfzINxNWlfL+A5vyLgxMGN6BdAHMCXZxla3sj7Vt4SB+
         61orXBrIgX2b6P7dKMXo7mgqprF8o+YaRFjuf/Hb23Db5TAjfDv2S1MpueNx5QwMY5sW
         8qTg==
X-Gm-Message-State: AOAM531GmVITmAl6qQOYUwbt8zCYcp0JO1+6PhKajPJatKAemK2oH5Rv
        E/nv8XxCTzaOrE0FwNjRC1k=
X-Google-Smtp-Source: ABdhPJzOS3tskzLp+3Ip5cIPeh0p6NlZFSrWmoHbf0Y7aQjp86DUgPFh5UxOnaRLQCynIpbSSbWUBA==
X-Received: by 2002:a17:90a:1d0a:: with SMTP id c10mr72160pjd.39.1625236021689;
        Fri, 02 Jul 2021 07:27:01 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id nr12sm12683747pjb.1.2021.07.02.07.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 07:27:01 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 0/8] net: fix bonding ipsec offload problems
Date:   Fri,  2 Jul 2021 14:26:40 +0000
Message-Id: <20210702142648.7677-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some problems related to bonding ipsec offload.

The 1, 5, and 8th patches are to add a missing rcu_read_lock().
The 2nd patch is to add null check code to bond_ipsec_add_sa.
When bonding interface doesn't have an active real interface, the
bond->curr_active_slave pointer is null.
But bond_ipsec_add_sa() uses that pointer without null check.
So that it results in null-ptr-deref.
The 3 and 4th patches are to replace xs->xso.dev with xs->xso.real_dev.
The 6th patch is to disallow to set ipsec offload if a real interface
type is bonding.
The 7th patch is to add struct bond_ipsec to manage SA.
If bond mode is changed, or active real interface is changed, SA should
be removed from old current active real interface then it should be added
to new active real interface.
But it can't, because it doesn't manage SA.

Taehee Yoo (8):
  bonding: fix suspicious RCU usage in bond_ipsec_add_sa()
  bonding: fix null dereference in bond_ipsec_add_sa()
  net: netdevsim: use xso.real_dev instead of xso.dev in callback
    functions of struct xfrmdev_ops
  ixgbevf: use xso.real_dev instead of xso.dev in callback functions of
    struct xfrmdev_ops
  bonding: fix suspicious RCU usage in bond_ipsec_del_sa()
  bonding: disallow setting nested bonding + ipsec offload
  bonding: Add struct bond_ipesc to manage SA
  bonding: fix suspicious RCU usage in bond_ipsec_offload_ok()

 drivers/net/bonding/bond_main.c            | 176 +++++++++++++++++----
 drivers/net/ethernet/intel/ixgbevf/ipsec.c |  20 ++-
 drivers/net/netdevsim/ipsec.c              |   8 +-
 include/net/bonding.h                      |   8 +-
 4 files changed, 172 insertions(+), 40 deletions(-)

-- 
2.17.1

