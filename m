Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A33E3E1055
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 10:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237216AbhHEIcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 04:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbhHEIcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 04:32:11 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B6EC061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 01:31:56 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id yk17so8180814ejb.11
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 01:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9EkdsdYrApQ7+f5B8Pf+SPksTX/P+n0hxS3e4gT9YU8=;
        b=xqiRpsxL69vB0rwu/tqx/+M8yMfnqdwIb7raj+3psGPAF3iRPd6FMf46Tn4VpwyItb
         LHQcr8Ax3liG9F1syUcoSfiF5j2K2cTZ+uVYAhkmZ53Sih1ZFMTUj/Gu5d98VE1eQhz7
         X4z3w6gR0WR4VvFpZ8vvtEI8fyRyW4zoYDXY4zto0r2hni1xTyxeoy90wsy8N94LR8KJ
         8EBf8/GeQwHJMySq3h0zLRqfsq3qd5Upf4TcUUDzHr6CVr6Me78rYi4k3F2S8FQdpFRS
         okJ1JqXxx7Wu6JYjlmSVM4+0i0pfJYD9BfLnS/ZdbuMifq4WG6dTkFbd/X2jpfwsw/Ti
         /v3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9EkdsdYrApQ7+f5B8Pf+SPksTX/P+n0hxS3e4gT9YU8=;
        b=V/qdfkvRohnYR8yohYdDdN+INEN4gTs+VaId8SOKN/i5Ctf2BdlNiAqR1+i7vsCnZT
         V9QQXdfly9Fnxet6MaEPr52CO77M2IJlGWc2Y7gTXrW1svDB2pt4eSjDDJBCkJJyH661
         xnvsx/z3beMYzxqu6UYaZNA0uZZZj7VZiOJFZpPznaYDz44jg8jxXZ0I+4SLpI0IqtXm
         oGFfqwRLdFpW00lLyaUvwvXwsOdSZJpKjMrU8R6aZn7w9QE4aaWaN7+/fB0oa2eRvwqQ
         MohmIgFnuTttpyseQSEkn5MIi7d60GrBpP3NgvNc2KnWjZLtfMmt/gM6y7NY3uvXgBmd
         L/aQ==
X-Gm-Message-State: AOAM530onMPf7kB5yh6FdoadQhvngWaqa9reoyzvjjUavIc1j9WpOT1S
        LOdYkVcArsUvMjuxb5AJR2iFNyFlu6Ff+bUM
X-Google-Smtp-Source: ABdhPJxMIcJYTBW+Ta73fHztDJiyFCHXDkhT478vefVH/d1uYr5MDxyp/ys5RslAyEcnURKaWL0IyQ==
X-Received: by 2002:a17:906:2990:: with SMTP id x16mr3597423eje.554.1628152315124;
        Thu, 05 Aug 2021 01:31:55 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bm1sm1471611ejb.38.2021.08.05.01.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 01:31:54 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, arnd@arndb.de, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 0/3] net: bridge: fix recent ioctl changes
Date:   Thu,  5 Aug 2021 11:29:00 +0300
Message-Id: <20210805082903.711396-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
These are three fixes for the recent bridge removal of ndo_do_ioctl
done by commit ad2f99aedf8f ("net: bridge: move bridge ioctls out of
.ndo_do_ioctl"). Patch 01 fixes a deadlock of the new bridge ioctl
hook lock and rtnl by taking a netdev reference and always taking the
bridge ioctl lock first then rtnl from within the bridge hook.
Patch 02 fixes old_deviceless() bridge calls device name argument, and
patch 03 checks in dev_ifsioc()'s SIOCBRADD/DELIF cases if the netdevice is
actually a bridge before interpreting its private ptr as net_bridge.

Patch 01 was tested by running old bridge-utils commands with lockdep
enabled. Patch 02 was tested again by using bridge-utils and using the
respective ioctl calls on a "up" bridge device. Patch 03 was tested by
using the addif ioctl on a non-bridge device (e.g. loopback).

Thanks,
 Nik

Nikolay Aleksandrov (3):
  net: bridge: fix ioctl locking
  net: bridge: fix ioctl old_deviceless bridge argument
  net: core: don't call SIOCBRADD/DELIF for non-bridge devices

 net/bridge/br_if.c    |  4 +---
 net/bridge/br_ioctl.c | 39 +++++++++++++++++++++++++--------------
 net/core/dev_ioctl.c  |  9 ++++++++-
 3 files changed, 34 insertions(+), 18 deletions(-)

-- 
2.31.1

