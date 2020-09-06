Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642EC25EC35
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 04:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgIFCz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 22:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgIFCzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 22:55:51 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F901C061574
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 19:55:51 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gf14so4800177pjb.5
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 19:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=zoYGT8aRD6gpzBpu8ArLrX0oOsYBryT38/R4M68WAlk=;
        b=L4Ruubk5ElbjsnZEsCBs4nhuc6q7vCa6/Vzpdvyu+/j+yW/77GNXcPjJDOuCOXQJrV
         jZxF5LjORz7g2XHUg9SgrFwKowicOouYrEzdWIZsMi9hSt1s69PFm8P4+d+1uf2DYrXs
         xOW+Zt/X+1eBtzJ4F030Ur//tjXoTUng1L/7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zoYGT8aRD6gpzBpu8ArLrX0oOsYBryT38/R4M68WAlk=;
        b=AzcDskGcrE0XSh6t61WoXoMGjgXqEjS+ow6mYGgpZJUPY8rfv0w5sTUqboPEBe3tBa
         cJ/yP7hPUd+J0P1NXyuld6ULi6fnlXnm26fECbOU67FWpeQkzkP9bui5YgNEuaJIPjMy
         RS0wEYXdU7R/us9BaIbAhFcoUyV0looL/5moFLRs8M4nSC5HOv57nqKMZmnruRv1pS0D
         /j9etiI4CO654/vbiLREAGSPP3+KYmVxMI9BobxT0NqWqlg4E6p9THZ1bOwfeIj8N0gt
         qvCNSgOOn8RZTPff+eCPwa1cUOlFP5ZyL9BzVLR+GngBNE7f5NnJRr7EMwIDxJo70LGI
         N8jw==
X-Gm-Message-State: AOAM531SvEXb99mfMrh7nc6UTjTizSmn8uGyqaVCrXJG4uRR96kUCWmc
        +ESjD/fixgbEvDb4P96gd9lBEOkMH5/vRg==
X-Google-Smtp-Source: ABdhPJzhT9gy5x2H85s4Hydko01i7VEG7RLSxtzXjetWt3uubWTKVBrBWuGgMS6in+dy0Ymv5sJH2g==
X-Received: by 2002:a17:902:bcc2:: with SMTP id o2mr14509876pls.87.1599360948647;
        Sat, 05 Sep 2020 19:55:48 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm1346959pgn.75.2020.09.05.19.55.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Sep 2020 19:55:47 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/2] bnxt_en: Two bug fixes.
Date:   Sat,  5 Sep 2020 22:55:35 -0400
Message-Id: <1599360937-26197-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch fixes AER recovery by reducing the time from several
minutes to a more reasonable 20 - 30 seconds.  The second patch fixes
a possible NULL pointer crash during firmware reset.

Please queue for -stable also.  Thanks.

Vasundhara Volam (2):
  bnxt_en: Avoid sending firmware messages when AER error is detected.
  bnxt_en: Fix NULL ptr dereference crash in bnxt_fw_reset_task()

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 13 +++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  4 ++++
 2 files changed, 11 insertions(+), 6 deletions(-)

-- 
1.8.3.1

