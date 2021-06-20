Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8893ADF2E
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 17:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhFTP0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 11:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhFTP0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 11:26:39 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D163C061574;
        Sun, 20 Jun 2021 08:24:26 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id k6so11704715pfk.12;
        Sun, 20 Jun 2021 08:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kEdRMmvFH+OJ/tXM4maq3qoIg5+rcFsm9j8kAcdNT04=;
        b=uiGL5sPW1xNVc0DKXMeTFkU1MvuVa3g+9Y0tLLoCE5QxLzn1VjoVNEBIY/WiQqsuZu
         ATjuVJdSbrgEkv/z8tD8sQ7G0z9CUF/O7/oikaFDnzbBVh99BMYloIZs01VkKfUvzim1
         bZnqnIIoYjESGz0ZcnhxtSPUJtPh5mow0NuCBW4mLg2z2UAdrP2J949Frnrs79RvV2CZ
         1pIuZBccHOM25U9j8gPBiSwP8TSK/BoD4uNoERhDnLTdjFD4op0mh1pFqPGA83Tkqr7D
         jG0co58cgP4/dH8APEaV61D08wY4uHF7ww1/7vBEUsGsVPFuQxXfQyklL7J0MWo+lWeF
         YFQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kEdRMmvFH+OJ/tXM4maq3qoIg5+rcFsm9j8kAcdNT04=;
        b=e7x08MK5f5mgd3l04Fhrgp9dixvU9qzjoJ4q8wtxZ559r0byPsrYDPJJJegQPBtijD
         5V7ZD/J3cNKYUbL5talVEDw/RpB9aKyPYxOu3P7Td0/Z5v4MP9Vb1auP1GxV3pXTZdqV
         MX0+tsjY0sqAwNYi+0NtybwWPLGeAx3me6VWsC5x7Q11gllYOA00wVz8hxKZI6Pq9ZW1
         Uq+nmpZRQ+xqLmxZN4qj9B7WItQAm3UVybMy25tIp0ol9ah92zdmWgJ/QjguniehcV/m
         PChYyQot58QX5rTJaHpE1P9KEo17vKQOBFC5UiDBOCJmzOlN2XUVspXDosk0rAc1atw8
         7sVA==
X-Gm-Message-State: AOAM53368XdvBY3J+jQXhnID9I13Jy2hy2mnMNjOHF+vWRErBQ39fINt
        l441TUjULsl8JvyQwwxBZQ==
X-Google-Smtp-Source: ABdhPJzi1pYMw/8I/QMvMyOajCq9OhdLw644fzUknVW19uYupI+RQidYX2sWlPRp0FAagAaX4J4SYw==
X-Received: by 2002:a63:491d:: with SMTP id w29mr19672704pga.86.1624202666115;
        Sun, 20 Jun 2021 08:24:26 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id a15sm13250356pfl.100.2021.06.20.08.24.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jun 2021 08:24:25 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH 0/2] atm: nicstar: fix two bugs about error handling
Date:   Sun, 20 Jun 2021 15:24:13 +0000
Message-Id: <1624202655-6766-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheyu Ma (2):
  atm: nicstar: use 'dma_free_coherent' instead of 'kfree'
  atm: nicstar: register the interrupt handler in the right place

 drivers/atm/nicstar.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

-- 
2.17.6

