Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283CA30E73D
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbhBCXYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbhBCXYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 18:24:52 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C82C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 15:24:12 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id j12so837585pfj.12
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 15:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QkBwo1QvheJuFukE9NhuutxcWZPl5puvQJsXHXcWqgM=;
        b=bWjlwy5x4Zvvd9b9rAspUCWmrLAOuNWscChiH2kRUxMXs2w22KzxnZYpVl8/yb4KZL
         F4SDUuH81fguypbapuj/pa7sxoDo0Hn/+cqyqsZsu/H1LLSrxfv3ieHJxr1EQdWUxCSM
         K6xVE+k7NfAiyt/SWB6w5+m8xFSGYCJsFZQMphHodHHpsvqsVY8FkZmNzR4dvKN1V6hp
         qDBdSPmb9gWep9AYWKSoNDLP8NYCbLd2XGK3oz+5JC5OdexgTNhxX8lngHWtTbmPQBTK
         zl/y3ru0t2biUEfwcHa1SeI7tSblJ32iGTkiQZXs306yhJBXr69xMgikYe6CxmVMLjWJ
         eMKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QkBwo1QvheJuFukE9NhuutxcWZPl5puvQJsXHXcWqgM=;
        b=a0sV6ax9FnkIGPb98TnLNG873jjNY4FmdtV7BGbWDKUd5l1PZ4qFlr6xfSDNGqFfHQ
         uVeL8wKM6RNvHaSafaZ1eEZOQU6EvFgKN+lrju1bGcG52MSXZi4mG89FX0tYIF6V/Lvy
         5AMhuwx1g0gM98CZmMoVNICF4WWLAzx7sx1uZ9eAn35bCZRBVUugoFF+lHTyMO829jQd
         zsXYj0qvUGZF9hKzDAPsGkw82KTdyFbDzuQSyYdHwUYmoa9P9Zz+WOC9LSeBEtKGwiTr
         y4rtwSUa0N8L5nOBAgV/w75Gw+KLeZiuS8SL7crPmFVoHiQiCk6o13wXBShfa3hYyicp
         hM0A==
X-Gm-Message-State: AOAM531zHslkskbB3Z1CWN2WQymmQpXOww8GisOTktt1n8q5UlgX2TOj
        kGpcMgAofxyE/UKYr3WNuIE=
X-Google-Smtp-Source: ABdhPJzaK2YrkFIVKThFYuI9TEiP+uJP5/yEhd0uz0V+/C9FHB9Te7PAAyQD4Hgb8DrI2LEBmQBN4A==
X-Received: by 2002:a62:1e43:0:b029:1cc:9a5e:c852 with SMTP id e64-20020a621e430000b02901cc9a5ec852mr5164964pfe.40.1612394652196;
        Wed, 03 Feb 2021 15:24:12 -0800 (PST)
Received: from localhost.localdomain (h134-215-163-197.lapior.broadband.dynamic.tds.net. [134.215.163.197])
        by smtp.gmail.com with ESMTPSA id j1sm3462561pfr.78.2021.02.03.15.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 15:24:11 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH V2 net-next 0/5] add support for RFC 8335 PROBE
Date:   Wed,  3 Feb 2021 15:24:10 -0800
Message-Id: <cover.1612393368.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The popular utility ping has several severe limitations such as the
inability to query specific interfaces on a node and requiring
bidirectional connectivity between the probing and probed interfaces.
RFC 8335 attempts to solve these limitations by creating the new utility
PROBE which is a specialized ICMP message that makes use of the ICMP
Extention Structure outlined in RFC 4884.

This patchset adds definitions for the ICMP Extended Echo Request and
Reply (PROBE) types for both IPV4 and IPV6, adds a sysctl to enable 
response to PROBE messages, expands the list of supported ICMP messages
to accommodate PROBE types, and adds functionality to respond to PROBE
requests.

Changes since v1:
 - Add AFI definitions
 - Switch to functions such as dev_get_by_name and ip_dev_find to lookup
   net devices 

Andreas Roeseler (5):
  icmp: add support for RFC 8335 PROBE
  ICMPV6: add support for RFC 8335 PROBE
  net: add sysctl for enabling RFC 8335 PROBE messages
  net: add support for sending RFC 8335 PROBE messages
  icmp: add response to RFC 8335 PROBE messages

 include/net/netns/ipv4.h    |  1 +
 include/uapi/linux/icmp.h   | 24 +++++++++
 include/uapi/linux/icmpv6.h |  6 +++
 net/ipv4/icmp.c             | 98 +++++++++++++++++++++++++++++++++----
 net/ipv4/ping.c             |  4 +-
 net/ipv4/sysctl_net_ipv4.c  |  7 +++
 6 files changed, 129 insertions(+), 11 deletions(-)

-- 
2.25.1

