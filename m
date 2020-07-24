Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F7322C5B4
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgGXNDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgGXNDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 09:03:14 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D70C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 06:03:14 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l64so1688433qkb.8
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 06:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hM8FycPGzgkWyIDIu5oVA1lpgkuXZzR2Dyqnm82Le9g=;
        b=leNpCoTp6qHB8noP/2c0e/1eQBStDb7ZTCA4IVzbHTP5LS+AdhFdHX3opT9jMEF9ZO
         25EvQ/NoSNm+J4i6wrnIJ9GtbdOhgK/SdypBCCkzf0A/ut/1ls2vJE2uFGhijICqRM+y
         vvkd0eHYNgXWXwiO+DZ91oKo8oZLmew1TKxz2OR+WlVvB0h1y1I02axnhk6qGxf8rcEJ
         sErFEub58ngD64tCj6I+BX9s06KzgntDxCMejuVPxWTFmNeJng5hymXXJmthB50uJuJ7
         /PAOKkKmKXKDF9d+IBw6c2X914LO+PZjs3BXVM3H0QQ/vMCPmIVcCLz2Jq5xn7FtsS4w
         vgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hM8FycPGzgkWyIDIu5oVA1lpgkuXZzR2Dyqnm82Le9g=;
        b=pbtUfnW69OZYCKHCLslhp9Ynu+mV3oRJx9dTcp3Ng5wusb7PKNcmkH/SmQuLAoow+p
         yKzWCDJUq3dpn1d9JzS0+B03OrCvN2Y+9eTtMI0Zwpl89+q22Qdfqd51XBCdr4PAFt2h
         0/LTFzYiO23BlmgrrNPXX3TpljPa+GpURnVJmD3NdaRDnoL1Amt99ZSxyH2oaUeJcZ37
         hHQxct6ftwwo5l0EuBcl/WTg1GnAU3vjegoILjTFBXTbNGuTkjCarYfVieFi3flBEeky
         iJlFbCWkNQAL1/DmYhYO04rQ3zItnvD7br4T6i/mKkY6BTQIWuWUUkSBMPSmamT/237/
         /qvA==
X-Gm-Message-State: AOAM530lG3AxxveZXJkCvosAE0OCLuiilX1uTLKB6M21x0zOWAFM5EgG
        8cLJoeGp2T3tETmJRSMaXQ0JwgqA
X-Google-Smtp-Source: ABdhPJw7o5i6ELQsQpcq6CNFbwGt/su9YDuYuTDaVy2QiEfEOqbYWO+ncd4J5QmqK6gdzpJzsoPy4A==
X-Received: by 2002:a37:a848:: with SMTP id r69mr9807742qke.58.1595595793155;
        Fri, 24 Jul 2020 06:03:13 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id b8sm1203491qtg.45.2020.07.24.06.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 06:03:12 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next v2 0/3] icmp6: support rfc 4884
Date:   Fri, 24 Jul 2020 09:03:07 -0400
Message-Id: <20200724130310.788305-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Extend the feature merged earlier this week for IPv4 to IPv6.

I expected this to be a single patch, but patch 1 seemed better to be
stand-alone

patch 1: small fix in length calculation
patch 2: factor out ipv4-specific
patch 3: add ipv6

changes v1->v2: add missing static keyword in patch 3

Willem de Bruijn (3):
  icmp: revise rfc4884 tests
  icmp: prepare rfc 4884 for ipv6
  icmp6: support rfc 4884

 include/linux/icmp.h        |  3 ++-
 include/linux/ipv6.h        |  1 +
 include/uapi/linux/icmpv6.h |  1 +
 include/uapi/linux/in6.h    |  1 +
 net/ipv4/icmp.c             | 26 +++++++-------------------
 net/ipv4/ip_sockglue.c      | 14 +++++++++++++-
 net/ipv6/datagram.c         | 16 ++++++++++++++++
 net/ipv6/ipv6_sockglue.c    | 12 ++++++++++++
 8 files changed, 53 insertions(+), 21 deletions(-)

-- 
2.28.0.rc0.142.g3c755180ce-goog

