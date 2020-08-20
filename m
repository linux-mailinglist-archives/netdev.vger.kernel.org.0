Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C197824C0C1
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgHTOkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgHTOjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:39:55 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143C0C061386
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 07:39:54 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id di22so1787321edb.12
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 07:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AdT5uevWPDIP+8YrWwAdAJf5izra/8s/R7L9WYRLEhs=;
        b=x0OI0AtZ64S3N76Uyli4cT6ax4kIs4o/Y60kGSkCyww/eDAvjAEqFKdrTnQCCnY8KQ
         /CO+5v3gne3lqJjEgKqcfY2ULLAZO0sp3rtV0BzvjzRYy5rRc5UH1z5R/1YoSt31mNEP
         fcqU/qJQFoP8jpwfl3Agee5qZXPj5HS2hqDeUwSrddf53SUxG3O+cnMhE0sN0fWHpCjx
         QwAvrQWmOhadd0BcxKsQFu+C1+tyooIASmCKBs3Z6SnBj6RWLrHB2DTYv/NMoyeWRQnW
         8RvubKtGIcKyIQrIxeJ+EdKyUVpVNKo7VtjUnAcqYp8ZPmVyyh0EWBe17D0VnNRRA334
         0Vkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AdT5uevWPDIP+8YrWwAdAJf5izra/8s/R7L9WYRLEhs=;
        b=REZmNTZoh4doop5+AK/vZRoTJubLNF6ZVFEFnrvpIjMHXZYsOuohW1DjvOq/YnSfnB
         y099kQv/36o6Je+nMbhfWc1EkQH1hz1SB6195sXFMaZ9nt+7+tFLUf3ccGMzDBL0Lp9p
         YJ11TSfQ6InJbxsJZNgpgLt6+XZ7aJANgJm2Y7PoSn9tYKlDv6WIrDyTdRJWGZnBZewi
         e71IYxb9f8QeDwE4ygm0BGQTFRC4bO9+rfhzkM7V4fvsRpkAfJgdQ1WIbVMC2w60OHLQ
         F+fa2e3IiO8g0NvZKcjHYysKVTwCvI9vIqodbDU0m5xpeAlYaE8lqg0Tjc0dr0QxGqf8
         pwWw==
X-Gm-Message-State: AOAM532YiWue9eg2RwxH5GpHwCf8P/dGNXkDQ4FMDtqfhThXx52DWakA
        ITi8OOutDsx9/vf248tgX/MXaQ==
X-Google-Smtp-Source: ABdhPJyhsYgCszhaR1ILkEOd9QCsSgcUYiomSFHzWsJUb/eeAlrtrpC2yX43eHqvG1zMZXCtaIS8tA==
X-Received: by 2002:a05:6402:180d:: with SMTP id g13mr3118806edy.277.1597934392128;
        Thu, 20 Aug 2020 07:39:52 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id m24sm1542511eje.80.2020.08.20.07.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 07:39:51 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Louis Peens <louis.peens@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 0/2] nfp: flower: add support for QinQ matching
Date:   Thu, 20 Aug 2020 16:39:36 +0200
Message-Id: <20200820143938.21199-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Louis says:

Add new feature to the Netronome flower driver to enable QinQ offload.
This needed a bit of gymnastics in order to not break compatibility with
older firmware as the flow key sent to the firmware had to be updated
in order to make space for the extra field.

Louis Peens (2):
  nfp: flower: check that we don't exceed the FW key size
  nfp: flower: add support to offload QinQ match

 .../net/ethernet/netronome/nfp/flower/cmsg.h  | 17 ++++
 .../net/ethernet/netronome/nfp/flower/main.h  |  6 +-
 .../net/ethernet/netronome/nfp/flower/match.c | 73 +++++++++++++++-
 .../ethernet/netronome/nfp/flower/offload.c   | 85 ++++++++++++++++---
 4 files changed, 165 insertions(+), 16 deletions(-)

-- 
2.20.1

