Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31C5307279
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 10:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhA1JUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 04:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbhA1JTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 04:19:21 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BD1C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 01:18:40 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id 31so2978537plb.10
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 01:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pQ9auhZL+31qnampaqF9x3FYPHxkuR4zlbWSrWlOPps=;
        b=FnCjg0RgDMJqKLPGKPIewVs+sP9HqGYZ7mkfC2BAMwjtSsILzno4zsnOWbw0wyFIO+
         yb4C4BlxXoMmEclAwNHhV/hXUgk4X1ZQtFCD0+bvPJtZFuwEewHJZChuRmV7GZsAS/fH
         oK2/L8hS1v6GLm8sFMdH5Dxa7TfVjpVKhEO/+hJGXsRNUnWlZM0CyyE8o77VDb9kIEpX
         ZKsjRkmGtj0A6j2PHdmuAZXAPTpngFpsZHGPQe9/m8jZTAStpPmL94T2CzE7ahR6BCL2
         qGUFdMuY5HBxrUrnzKarIcgakhvayrqUv+RMf+HNEoFfMt6h0Qi3O3hjqFBt64koBGMP
         hP8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pQ9auhZL+31qnampaqF9x3FYPHxkuR4zlbWSrWlOPps=;
        b=HLsCLJCRrODfRMNjVXPfJTob+dkt+5K/vXQJ5DayvY/iCl+xQIfNWUS66kODqFfbqy
         FiEfwIzp9mtXP6+wa2zntHnK43M9dWy+AZG40tR/t6ZG+2+s2Fq9djv0XeBb47LMt7oP
         tZe1oZPSUwxgK3BQELfDUEoR2ECk70lD9OHOb347k7o7DXUHlncXoiAh/UvjvKfnGAyk
         yxl+asjLlYkrYp8JlNV4hMo5ckjPvCqD/zntZGB9gTRjf8YgV8k4AB3AmpMt+yYaPAMF
         71YDjT7tw+U7FLhsq1IYfEAHmVBE0JqUp9cSf6URge1VYpI9+2cJ+/8+ZlS0raq2kfz5
         /oDA==
X-Gm-Message-State: AOAM5331a9jADjUfYmLw2jTc7cHzP6BzdyZgWa+ZCq54o6TwDQ0V2+A8
        XkABGS0RqoUW3wAivgEEg+8KAsFq6D2yHw==
X-Google-Smtp-Source: ABdhPJwBZHgIgXP+qvmn0lAcayKbC3zsUz/eiGS9AQoIVdOV98dTLgOxtFX1SscsAzGxKrUADqkb8w==
X-Received: by 2002:a17:90a:757:: with SMTP id s23mr10220458pje.39.1611825520242;
        Thu, 28 Jan 2021 01:18:40 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r1sm4995709pfh.2.2021.01.28.01.18.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Jan 2021 01:18:39 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCHv3 net-next 0/2] net: add support for ip generic checksum offload for gre
Date:   Thu, 28 Jan 2021 17:18:30 +0800
Message-Id: <cover.1611825446.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset it to add ip generic csum processing first in
skb_csum_hwoffload_help() in Patch 1/2 and then add csum
offload support for GRE header in Patch 2/2.

v1->v2:
  - See each patch's changelog.
v2->v3:
  - See the 1st patch.

Xin Long (2):
  net: support ip generic csum processing in skb_csum_hwoffload_help
  ip_gre: add csum offload support for gre header

 include/net/gre.h      | 19 +++++++------------
 net/core/dev.c         | 13 ++++++++++++-
 net/ipv4/gre_offload.c | 15 +++++++++++++--
 3 files changed, 32 insertions(+), 15 deletions(-)

-- 
2.1.0

