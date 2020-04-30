Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D7E1C096E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgD3Vdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726752AbgD3Vdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:33:51 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6640EC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:33:51 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id z6so2815480plk.10
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=jbjAtLgSx++jA6t7xlCAULbJf9CM7m63JqKvbK35sBw=;
        b=FUF6YGoSJKvMYI3FF/vvrU/bI1nNftJNbZUEWxYNcnvqJJrqFJHM57CIcqiYAJSkWi
         zuk7/grl61aGaeuhXpHMTs98eGTsl2T/ZZRgBW/Pwhm4sXjyVBIisX/d8NPHo7qLod/5
         fGhoNyIONPy4ulR+I2AfWk0Uia3/pRF3qmhm87S1y9zHA1eYyD9/Z68uVJ5AiR2GpFcF
         Br/FSvFxJa+9fCupAmCYPggR/nkmYz9Emi5Q1ZWeYh2qzdlo1JIz4rMsr3A+CxF7Zahr
         9PMMxW+oop2+2mHZuarInOSejPmEFMOrn+YvWrmU/bpQsYAb+OBOO8G4c73YwFpbDsMs
         3GGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jbjAtLgSx++jA6t7xlCAULbJf9CM7m63JqKvbK35sBw=;
        b=Q+QFwtVa580F2mMvoy0m67hvM5noSXf0tBWr0gSd/JQ0lUZaGDej9jTusFtdEgMpyL
         hWwGvZ9mWZAhRIa+B+ZpTgwe2/i/75m+wITMEalLgEARthqGDEnuWQEAwlWcKSNgZCdD
         OVKSvi/wJlr815GzaDqAykPGBeaL5Fhr1ZJduD8r1UMh29/QCtVNE9gn6cd3wW0T4kq9
         VSPI2AB12d3QUilipGOeUt7brBfiDt6lrT1lhbuGJGV3IxI+5TJfKKbh8dmAbbIgcNDC
         RMn1zKP2EPReFnXPnAfwBgID5SOFlda+x+WTRhvUA48I8NIkBKg7PsUowKJIIUj6LMD0
         TB/Q==
X-Gm-Message-State: AGi0Pubz7jj6WiKjyaKpr8ZrtCj1fbRADHUDNVUpz6YiDjO4VpdvBWXp
        fjALdyrv6Y1RFRoWtFutnelAT9ZziZU=
X-Google-Smtp-Source: APiQypKZjzOlwJaZYcr6Htbdkd1x6J6kYWu8NWuIx8Mf2FmUemjD7MpwLQWHf2pZ6cUtap6WsFMvbg==
X-Received: by 2002:a17:902:8d95:: with SMTP id v21mr1099201plo.322.1588282430479;
        Thu, 30 Apr 2020 14:33:50 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f9sm579086pgj.2.2020.04.30.14.33.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Apr 2020 14:33:49 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net 0/3] ionic: fw upgrade bug fixes
Date:   Thu, 30 Apr 2020 14:33:40 -0700
Message-Id: <20200430213343.44124-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches address issues found in additional internal
fw-upgrade testing.

Shannon Nelson (3):
  ionic: no link check until after probe
  ionic: refresh devinfo after fw-upgrade
  ionic: add device reset to fw upgrade down

v2:
 - replaced extra state flag with postponing first link check
 - added device reset patch

 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.17.1

