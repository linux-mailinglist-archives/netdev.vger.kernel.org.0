Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A89317193
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhBJUol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbhBJUoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 15:44:25 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B872C0613D6
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 12:43:44 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id c6so4647431ede.0
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 12:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UBGFboaGHXzMjkmTeOZoi+EnS25QwhIVqLhCuY1te2g=;
        b=XZ6b88BT1WaRhgfyTTshpc/i8DKpishN99oqdXCi/Qlky4yD1Gud4u9O/y5NfFbgHp
         Uv7IfiVXbJCIg16qdpW+xbL0tU5b121i5qlCRQvG2a8xw24uzJWPX/WCsD527d9YN7Bz
         9W9sbBINlFeH2tfxMjA29zNf4wTtM8TMddQpYZLns5XbhE6MgL05ZoRJ8ukZKfVjcpCs
         iAnGhor7R6OWk16DDGIaMhvqAQof5S9U2eJZD9HuPE+meAetBrMx71mPhphTGsa1fSkr
         AfCQzpEFU/rhk10p+39J5zRajIKZaCkhsRTmXQSWq4vpE7xCBL8/6VxB8r0veaMCfYL3
         Fv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UBGFboaGHXzMjkmTeOZoi+EnS25QwhIVqLhCuY1te2g=;
        b=d/NNfoXbN9pGWcRSNyeLUXWshmBrYptJ5sM8hHTul8jAlSN+7M8OcpHPkL4xC6hwG3
         SfUPBePEYVdNCHMvwK5xDuey2AJ5yDZCXHrgEvEU6TwNYTXI+cZO/yBK0qwWRX8e+fcc
         nkFCk2kauetbd5OdCtSSc7em1lin19r1znjwfBkFNNdu1QE8kBotYg6qjkeVxOpu8f6N
         +92Nu5O6J43MlkSEpTt34P3feTW23ydLrEM+RvcRDDoev5qN4K0Bnk2NvUwVA1HL4odM
         tjAKmhJJfxZtPKec2A6yZf0B4MQUWhw0qgbtzZ7t3BpYbTOjp8bzgzv9cLkrysUN3K6f
         B3JQ==
X-Gm-Message-State: AOAM531/0/+yPYV5iDE9d5bJwCPKIqkIQa82uqeoeHzaaIjoKPJfFb4k
        6Ydt993ZIchCFPLLkMR1UJn8LQjfTmwSYgplYI7Zxw==
X-Google-Smtp-Source: ABdhPJzk1n0isPMIKl4cVzebmFf4uKWxgAdvnNggxFZNURn8ntlkDgd6BtxXF5wnN15cx3kajBPsnQ==
X-Received: by 2002:aa7:da19:: with SMTP id r25mr4956882eds.1.1612989823072;
        Wed, 10 Feb 2021 12:43:43 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id l1sm2062655eje.12.2021.02.10.12.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 12:43:42 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, andy@greyhouse.net, j.vosburgh@gmail.com,
        vfalico@gmail.com, kuba@kernel.org, davem@davemloft.net,
        alexander.duyck@gmail.com, idosch@nvidia.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 0/3] bonding: 3ad: support for 200G/400G ports and more verbose warning
Date:   Wed, 10 Feb 2021 22:43:30 +0200
Message-Id: <20210210204333.729603-1-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
We'd like to have proper 200G and 400G support with 3ad bond mode, so we
need to add new definitions for them in order to have separate oper keys,
aggregated bandwidth and proper operation (patches 01 and 02). In
patch 03 Ido changes the code to use pr_err_once instead of
pr_warn_once which would help future detection of unsupported speeds.

v2: patch 03: use pr_err_once instead of WARN_ONCE

Thanks,
 Nik

Ido Schimmel (1):
  bonding: 3ad: Print an error for unknown speeds

Nikolay Aleksandrov (2):
  bonding: 3ad: add support for 200G speed
  bonding: 3ad: add support for 400G speed

 drivers/net/bonding/bond_3ad.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

-- 
2.29.2

