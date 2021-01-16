Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6641A2F8BD9
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 07:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbhAPGOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 01:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPGOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 01:14:32 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BEBC061757;
        Fri, 15 Jan 2021 22:13:51 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id h186so6907421pfe.0;
        Fri, 15 Jan 2021 22:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=r6ZBFq9DkJZ2tpvGqG5+pJx56O4V/iX/AfXLlHPFg4Q=;
        b=EsSGgNod3bsqzTiIFYRjLKg90zqiIvQOvQ6nKwWid+ssFOEvw/lL7DRixQWv36E9bP
         Yu2j9Isf2B4iVPPXXXSn+VI0oQQWaFACgNzMnVLJf37nCOqldzkdCHP/0jIbGCzX2DCG
         uLyljBIi/1yyRMJi/uQgyzdZIYGAuryOtEJEAXz5gTRWlT37K4FcIlRfB2c7vZCPwDxB
         vqYSQFpYQCV/1MEUX34PSfUJAbVhIsUVs3qnULMWOEdtQtlEs7yUAEx+ITBXGCHIAnAL
         jR+4rw9coP28DLhRjLo66IkLT4DJcVBROUQzN4tXUH3bxkuYHEc7HnYc0U0Z9gbVAjU3
         94kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=r6ZBFq9DkJZ2tpvGqG5+pJx56O4V/iX/AfXLlHPFg4Q=;
        b=K1IBAgeZaAQX1WvoFtWtgCQw2l6PQu1rGaceJmKQBQWF7c0qHW+Fkb/8+zEKjNlTP+
         5d8ZLUiNK+WZLRhTonJmPgAXL4D+Ct5eUdSIYE35AMhtJri+57nGV6fZHzgNDfs2eEUO
         YlF+zoACEBhjnmkdqXW68T8r7Lj0bjtU+NHO4vDWY8KLbWijSJRXUQ2JJmJnY/XH6c8y
         jCfp2oyXGtnxpHlm59Upwy6PsT+shEs1xEpDcQ5rcUf1N7Jt6jXwAU0HARv/2q7EzSF8
         +7wdNLEScvE7Ry0XRboz1cU3NXVOkGukPrCtKTWo6xNusi8HPHkJOT+EsGmEE3iBhp1y
         yhOg==
X-Gm-Message-State: AOAM530SyNmJAp3yXlEYcv67KLw1ZlDK7xOF8KyAw2fO1MfUNvILv1z9
        o9KOg1qJtvg2sbwXd8E1ykGYzf2WR7JpHw==
X-Google-Smtp-Source: ABdhPJwCn1gNfstQ9YdIORANyi+qvRInI90IuWxV/fUbjrbKN+XnUU2pkBVpbVDOup2dxPTOta2UYA==
X-Received: by 2002:a65:460d:: with SMTP id v13mr16099601pgq.414.1610777630983;
        Fri, 15 Jan 2021 22:13:50 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b13sm9933821pfi.162.2021.01.15.22.13.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 22:13:50 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next 0/6] net: support SCTP CRC csum offload for tunneling packets in some drivers
Date:   Sat, 16 Jan 2021 14:13:36 +0800
Message-Id: <cover.1610777159.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces inline function skb_csum_is_sctp(), and uses it
to validate it's a sctp CRC csum offload packet, to make SCTP CRC csum
offload for tunneling packets supported in some HW drivers.

Xin Long (6):
  net: add inline function skb_csum_is_sctp
  net: igb: use skb_csum_is_sctp instead of protocol check
  net: igbvf: use skb_csum_is_sctp instead of protocol check
  net: igc: use skb_csum_is_sctp instead of protocol check
  net: ixgbe: use skb_csum_is_sctp instead of protocol check
  net: ixgbevf: use skb_csum_is_sctp instead of protocol check

 drivers/net/ethernet/intel/igb/igb_main.c         | 14 +-------------
 drivers/net/ethernet/intel/igbvf/netdev.c         | 14 +-------------
 drivers/net/ethernet/intel/igc/igc_main.c         | 14 +-------------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 14 +-------------
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 14 +-------------
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c  |  2 +-
 include/linux/skbuff.h                            |  5 +++++
 net/core/dev.c                                    |  2 +-
 8 files changed, 12 insertions(+), 67 deletions(-)

-- 
2.1.0

