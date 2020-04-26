Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B851B93E7
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 22:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgDZUZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 16:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbgDZUZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 16:25:02 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA19C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 13:25:02 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 18so6586017pfv.8
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 13:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=h9fo6cgEf6KD6TzTlGM0zhA0R/U+VGuuTUW4AGO4fRI=;
        b=CCbwHzgi7n+NWbL9LuGyO4f7GeI6+dzAJaT6H0Zv2JY26/wxOOv0SqdBrEx9n58Ycb
         ROkP/TV/CTJVJxRzX9+jubL1JLUKXAaHvaxPayWMvyCZIdfrjDfB5EpwhFCp1gits4ki
         K0QbpSThV1vjcGQrGFVv69QudGrPbvxoUP9YI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=h9fo6cgEf6KD6TzTlGM0zhA0R/U+VGuuTUW4AGO4fRI=;
        b=iDtCcQ2LgTxPE5/auzxGzMMVycVRUOvXZQ/g4hfYQwLSEJDRNO6K7gfkfR/7vqDBLB
         8BigubTR9OOM66k8MlBgqT8zYNRTMQxCZcOzJBJut8Heavg12YSBSyaczfa/RrzjnIMH
         GDAF9DzVNh3bfG9WKWkveV7NHoXRyxBxmAdxgaYTtMt2x1ySxrEnHONr14h9LVe43pe3
         cc8BhNh0Qfp7yp/D8oPLcUqllE+/gGqt9pMa3LHM4fLcW96paAz4D/Og9l/SKRggvbaa
         wQpI5MLIuCcgS73HXEAOE0uRajKbxg3sfNZmhjDO+lgtEjn4/umSIGb7KnjNc2OwhsUk
         eOvg==
X-Gm-Message-State: AGi0PuYolbna+LtbNDXhTp/Juh61yyEchxcx8U6nVqFsM4fQLB4c2S7s
        4eP++z6toqJoiVK97LXgn+IMOKd4r+o=
X-Google-Smtp-Source: APiQypI4Tw93k+mCY0ZGe9AQk6BaKXjbaRCYH5uCdJBi7hRyrUaEVOes883A6S0YYktdniYk5oNjlA==
X-Received: by 2002:a63:3dc5:: with SMTP id k188mr9212768pga.425.1587932701859;
        Sun, 26 Apr 2020 13:25:01 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a136sm10862103pfa.99.2020.04.26.13.24.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Apr 2020 13:25:00 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/5] bnxt_en: Bug fixes.
Date:   Sun, 26 Apr 2020 16:24:37 -0400
Message-Id: <1587932682-1212-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A collection of 5 miscellaneous bug fixes covering VF anti-spoof setup
issues, devlink MSIX max value, AER, context memory allocation error
path, and VLAN acceleration logic.

Please queue for -stable.  Thanks.

Michael Chan (4):
  bnxt_en: Fix VF anti-spoof filter setup.
  bnxt_en: Improve AER slot reset.
  bnxt_en: Return error when allocating zero size context memory.
  bnxt_en: Fix VLAN acceleration handling in bnxt_fix_features().

Vasundhara Volam (1):
  bnxt_en: Reduce BNXT_MSIX_VEC_MAX value to supported CQs per PF.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 20 +++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c   | 10 ++--------
 4 files changed, 16 insertions(+), 17 deletions(-)

-- 
2.5.1

