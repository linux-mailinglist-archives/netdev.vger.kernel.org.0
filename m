Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60E6276514
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgIXAcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:32:19 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A559C0613CE;
        Wed, 23 Sep 2020 17:32:19 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k13so769540pfg.1;
        Wed, 23 Sep 2020 17:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9ug8usfNa3PZfFmZ6RI3mDJxlzqOuryqqA4P0VKGvHk=;
        b=WUQQ34Q9Dhou2GG6rUi7tMwz0VGa7TigMXck6Lu7H8qiD0/44OKCZbAUi3n7cgIhpn
         VTnH31LraN098C0jojeN93uiNcjyIeMAOeEwSNpT1BQpU9JtEvTve12ec5tR97TIVN0P
         ZXRYrgwVDr9mZfvDSSXb0vXrWtc/2p/YHv1wVvjUfIB4Eniedg4v0Q2wPnpcvl+4focd
         glAxMqjfLYEo56rgMxxkqDmOQn/vezLMj6WCJpUzkYTIKYPCa3xMutY3iU8CyGzcm4fN
         bJrd0QX6wfXPs45DS1pwSEAvU0rUwJmvtFjxrhlp1Yn9VSitXg5EC51rGRpGLHvpATkH
         htlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9ug8usfNa3PZfFmZ6RI3mDJxlzqOuryqqA4P0VKGvHk=;
        b=m8fGVEOIXmeLipt6/zGFXveNuKn76lyVshxni5WEupONojfQkoA8MydO6areF4xGmG
         SkQdr6yWEW7D1RV8Nk7cVBs2m3/iaiGGN2jXtXcKnlfKBiB90cp8YqKPuSc0Nja1sezg
         UqfU68XlUxuj6QDfNa19WW0wVbaTLpYkhLPfomx/LeLhBLlixHnetNcQQzhpDSWantNl
         Tgdws1t5+YTFbKeVHnnI8IYZApohJrgUzhiEC9AVupDa11eajDgJXKNcYGBIgICuVLuX
         g+icCA2wZyHzZ0XutWj1HBaYEdnPv/dAElzyS+3G+422tCWIgmaySbaZL/AB0d2ddP4F
         sOiQ==
X-Gm-Message-State: AOAM530krDe+gaH/erVKP2XcPfHBIyyFyDNM54jmEAwpyT5xMN4djUkT
        jipalOqcs3ZUTgpLKKeTR0U=
X-Google-Smtp-Source: ABdhPJwAVP9o34+72rUsOd+wOddOPKkW8SxV/W6C169LuF/es914/a6cpu3NtSlrb0F4g4bEhw9Wtw==
X-Received: by 2002:a63:5119:: with SMTP id f25mr1793883pgb.351.1600907538503;
        Wed, 23 Sep 2020 17:32:18 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id z8sm828757pgr.70.2020.09.23.17.32.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:32:17 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 00/16] mptcp: RM_ADDR/ADD_ADDR enhancements
Date:   Thu, 24 Sep 2020 08:29:46 +0800
Message-Id: <cover.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series include two enhancements for the MPTCP path management,
namely RM_ADDR support and ADD_ADDR echo support, as specified by RFC
sections 3.4.1 and 3.4.2.

1 RM_ADDR support include 9 patches (1-3 and 8-13):

Patch 1 is the helper for patch 2, these two patches add the RM_ADDR
outgoing functions, which are derived from ADD_ADDR's corresponding
functions.

Patch 3 adds the RM_ADDR incoming logic, when RM_ADDR suboption is
received, close the subflow matching the rm_id, and update PM counter.

Patch 8 is the main remove routine. When the PM netlink removes an address,
we traverse all the existing msk sockets to find the relevant sockets. Then
trigger the RM_ADDR signal and remove the subflow which using this local
address, this subflow removing functions has been implemented in patch 9.

Finally, patches 10-13 are the self-tests for RM_ADDR.

2 ADD_ADDR echo support include 7 patches (4-7 and 14-16).

Patch 4 adds the ADD_ADDR echo logic, when the ADD_ADDR suboption has been
received, send out the same ADD_ADDR suboption with echo-flag, and no HMAC
included.

Patches 5 and 6 are the self-tests for ADD_ADDR echo. Patch 7 is a little
cleaning up.

Patch 14 and 15 are the helpers for patch 16. These three patches add
the ADD_ADDR retransmition when no ADD_ADDR echo is received.

Geliang Tang (16):
  mptcp: rename addr_signal and the related functions
  mptcp: add the outgoing RM_ADDR support
  mptcp: add the incoming RM_ADDR support
  mptcp: send out ADD_ADDR with echo flag
  mptcp: add ADD_ADDR related mibs
  selftests: mptcp: add ADD_ADDR mibs check function
  mptcp: add accept_subflow re-check
  mptcp: remove addr and subflow in PM netlink
  mptcp: implement mptcp_pm_remove_subflow
  mptcp: add RM_ADDR related mibs
  mptcp: add mptcp_destroy_common helper
  selftests: mptcp: add remove cfg in mptcp_connect
  selftests: mptcp: add remove addr and subflow test cases
  mptcp: add struct mptcp_pm_add_entry
  mptcp: add sk_stop_timer_sync helper
  mptcp: retransmit ADD_ADDR when timeout

 include/net/sock.h                            |   2 +
 net/core/sock.c                               |   7 +
 net/mptcp/mib.c                               |   4 +
 net/mptcp/mib.h                               |   4 +
 net/mptcp/options.c                           |  81 +++--
 net/mptcp/pm.c                                |  91 ++++--
 net/mptcp/pm_netlink.c                        | 276 +++++++++++++++++-
 net/mptcp/protocol.c                          |  30 +-
 net/mptcp/protocol.h                          |  39 ++-
 net/mptcp/subflow.c                           |   3 +-
 .../selftests/net/mptcp/mptcp_connect.c       |  18 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 189 +++++++++++-
 12 files changed, 674 insertions(+), 70 deletions(-)

-- 
2.17.1

