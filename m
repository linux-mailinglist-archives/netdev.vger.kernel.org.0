Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42D4F62B37
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 23:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732549AbfGHVxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 17:53:17 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:40732 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730443AbfGHVxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 17:53:17 -0400
Received: by mail-pl1-f180.google.com with SMTP id a93so8953029pla.7
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 14:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=sfk5YphuNTK1Oqu49Hg+KnxGjmamT3wRgTV1hs7P+ms=;
        b=eC3Svy3R3Daw5lR5goSWkqOOMgBoZgXuk+8lsNrN3TeKzTxlSdZ9iTd0I9ztzGKtzR
         4yfNo535io7+SO5g75D0q+7QWAiuhsm+z3ox2q4vU3X1ICsGUqt7kZSSeYsTLj78bld0
         0yhsMz9xuyqUETcxaMjS3IY5eZVIPlU4dR/b8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sfk5YphuNTK1Oqu49Hg+KnxGjmamT3wRgTV1hs7P+ms=;
        b=e83IhU9vLzc7r8p/a6juy6wZzhrQ2mqXMcKty6V65NUFw0IWnJOszUjd54ty9xEqRY
         Lghi1wm5ukQKN2Okcl/7LWCTkFM7DdPVjDT8hFSw9c+O5G+tEEIq4wBgGMzhLYQUNNyH
         9mU4o6eGqj1L29SzwEb5CIQUXUxpxRKaxLR2yZNbSII7M8Dl0Ldp+KKNPpHgQ9KU4wxl
         MXjZewwZb+0U9zKxbLVaO6PvOP4fGTAuR2IDS47EaKcvFRjVBooFeLc6UPgBclR0c0aO
         0z10GoQ3TMVGpXylBa7/BDOkyY/WN6yxVDpmOh9hezeQRTzTIbDwnXKc1El6faLbgBcT
         ASUw==
X-Gm-Message-State: APjAAAVY8OX5fE7UQSNER4oL5MuIuf3qBG2jDmsn+DIIVA+NHojxdOTk
        f4+3Wv55ek7huqo9kdx85ah8bg==
X-Google-Smtp-Source: APXvYqyqd85+C7qnBPgB4+Nft1toU5zg8Nm+B2FUFO7b/Qos47ljde0UBK9TE9VNeTt7AjFQqjOeYQ==
X-Received: by 2002:a17:902:7483:: with SMTP id h3mr27571852pll.28.1562622796585;
        Mon, 08 Jul 2019 14:53:16 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x9sm11352157pfn.177.2019.07.08.14.53.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 14:53:16 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, gospo@broadcom.com
Cc:     netdev@vger.kernel.org, hawk@kernel.org, ast@kernel.org,
        ilias.apalodimas@linaro.org
Subject: [PATCH net-next v2 0/4] bnxt_en: Add XDP_REDIRECT support.
Date:   Mon,  8 Jul 2019 17:53:00 -0400
Message-Id: <1562622784-29918-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds XDP_REDIRECT support by Andy Gospodarek.

Andy Gospodarek (3):
  bnxt_en: rename some xdp functions
  bnxt_en: optimized XDP_REDIRECT support
  bnxt_en: add page_pool support

Michael Chan (1):
  bnxt_en: Refactor __bnxt_xmit_xdp().

 drivers/net/ethernet/broadcom/Kconfig             |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  72 ++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  17 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c     | 144 +++++++++++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h     |   7 +-
 6 files changed, 214 insertions(+), 29 deletions(-)

-- 
2.5.1

