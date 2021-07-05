Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BC53BC111
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 17:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhGEPlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 11:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbhGEPlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 11:41:18 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E561FC0613A0
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 08:38:25 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id b5so10450819plg.2
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 08:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6EsKOTvWOjUQo1NWlcS80O57gWZwdcGLpYfT4315Shs=;
        b=uS/eo1JGtoUHrEoOmxaioV2Dkl3y80LdVCVjTEXsHwDWywF6WmXuenY1Qh0YTtfRNk
         cOEpBfitkBB7bYpnkvW4Kr3KZ4R3gYCGsXjYsG3GFPysmB+BsSiIU6R5zrW+ADIJNX78
         aboiERm4zo5PwQYCuHoNwuNdtx9K21UM8JrqvV14Jo+S7/VuZdwCuKv01MGRSekECAsi
         uhB3CuO7CvVp+RRpJCuMoHgDrzXNg9F2gBcJIPZZSbeqoiBkaQqRlyXE8mfQDYEWii11
         Xctj3zanXQp7jBONGWm76UBVd/o7siWxjyMmowZfZmPHFwkWnVsla/DAwxUkde286Cpv
         +epQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6EsKOTvWOjUQo1NWlcS80O57gWZwdcGLpYfT4315Shs=;
        b=gnFQTQUppdnmNX5vn1hi49wFmmN+dXiui4f3aND7OFPyXVkCzotIAecY1xWE4XnZAh
         Wo0FtZJ1dNkNhHAW7yLTrkRqTPpZ0dTbabdoOvrM6qrpn8ZvqaAbFig0nBhaOCAKNWQ7
         adOGfvcyNeYfVBNguSB0bFaMiPKoOKHQKsFGeQEZN+Ug+rp7rpYrX2dgtNwxnLDGj68I
         kXun11OfHQkhVxZ3132He1QPNMvobGlacAN+aM7j6hL1+jqmJm1NAVMNvbbARGk4dpGX
         IsJxitg7lDh0O7MCUyxB6ENN4ivf58lO6GLHMWiKeVyGqdO+f9PJZ+RkNJ5rojFA8GwV
         24/w==
X-Gm-Message-State: AOAM530Kt0keFwyCaxzqaVGjB8pfUgBVwqbvWgMWk7ssGrzt97nH/uA9
        gmeBMVCPZJq3RfTE7UPsCxI=
X-Google-Smtp-Source: ABdhPJzspn9E8JZ2oPLoi76w30PyAlKf/Z9s/OTru37hzWbSD+LmYJRhgCZepXJXS5CWMNESF9b8Gg==
X-Received: by 2002:a17:902:7c91:b029:129:8c0f:853 with SMTP id y17-20020a1709027c91b02901298c0f0853mr5315027pll.62.1625499505378;
        Mon, 05 Jul 2021 08:38:25 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id k10sm9310353pfp.63.2021.07.05.08.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 08:38:24 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        intel-wired-lan@lists.osuosl.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 0/9] net: fix bonding ipsec offload problems
Date:   Mon,  5 Jul 2021 15:38:05 +0000
Message-Id: <20210705153814.11453-1-ap420073@gmail.com>
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
The 9th patch is to fix incorrect return value of bond_ipsec_offload_ok().

v1 -> v2:
 - Add 9th patch.
 - Do not print warning when there is no SA in bond_ipsec_add_sa_all().
 - Add comment for ipsec_lock.

Taehee Yoo (9):
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
  bonding: fix incorrect return value of bond_ipsec_offload_ok()

 drivers/net/bonding/bond_main.c            | 181 +++++++++++++++++----
 drivers/net/ethernet/intel/ixgbevf/ipsec.c |  20 ++-
 drivers/net/netdevsim/ipsec.c              |   8 +-
 include/net/bonding.h                      |   9 +-
 4 files changed, 178 insertions(+), 40 deletions(-)

-- 
2.17.1

