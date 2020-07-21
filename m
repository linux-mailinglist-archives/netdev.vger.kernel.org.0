Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893142275B9
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGUCkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUCkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:40:16 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5362DC061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 19:40:16 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x8so9585771plm.10
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 19:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9QazzlKwtoXyJArgNhvH1RvSiHmi85K86y75+aquz48=;
        b=kinZNmUfTmn1r9LjoAfwG/bXhszUT3ZDdGmoJUR+8va6X6gF14FuT+XxI4+F7JLgzr
         c9kU7vFTR3ZHhkfHEZhgFw9Y3LNFsLg0y1ABZyfjus9QSpyjNg6kynhgdZ9/Q62l1hoR
         yRp5C3fFvppgdiRzwrsL7ciuf51UkvYIA8uETVoUYivW6HcYp1LRpRnWWVbHs5sSI6D1
         /imqruLRUclx+Vf2MzU0EUIUhOD2I/QhvpsMeSsWTjpLhNadHjPf/NmGa8TIRkkg9byv
         ronGBxNA510M5DPvVt6UweOF2nuf15STnVneW62H4hQuqNiL7t5oCBro1Co2rOiJ7WN7
         r/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9QazzlKwtoXyJArgNhvH1RvSiHmi85K86y75+aquz48=;
        b=ioO4B9X9aTZwElF5o0yWJrjQSIbRvNSVhNtMWUszHQRXezHs4BekDanULPcu6VEecc
         feRpMAxC726QzftrZ3yW0osSGLoDWEA2g9UJohawg2ZBK4A3h9CCia3FvBL+o5uz8C8Y
         C1qPF3QOZhCrbFTZ0R9909xpvhNhsT18yBHc/EQ7OGI761fGdH+mE7Gq084+T7q159OE
         loDNxmNFIHkld8g0kzET4DIxDeO1+83AXwIOiwWfGGGrG8xUo8T2F+huPFhJQUCM0Vfk
         wZMfHt7OFOXfxRotFHrwtjHwhqpIUiW8K5VUFBH0ndRVooZp5+JAEC0mAUPspw4ni0Uv
         lNuA==
X-Gm-Message-State: AOAM532KXKbv5lgMEtVGpbp2ei3xcGs4v8p9SfgupcEroAfVfJZETFY8
        jmSQu6XeEwt/M9u6BDAWHew=
X-Google-Smtp-Source: ABdhPJwMo4zSOQ1VsO5uLSMFdfoUaadT0SMHohPawKkJCeaZDyJJNAiT1FYVHyIlh2wCTqvSr/sm9w==
X-Received: by 2002:a17:90a:5607:: with SMTP id r7mr2331069pjf.56.1595299215896;
        Mon, 20 Jul 2020 19:40:15 -0700 (PDT)
Received: from hyd1soter3.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id i21sm18499114pfa.18.2020.07.20.19.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:40:15 -0700 (PDT)
From:   rakeshs.lkm@gmail.com
To:     sbhatta@marvell.com, sgoutham@marvell.com, jerinj@marvell.com,
        rsaladi2@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     Rakesh Babu <rakeshs.lkm@gmail.com>
Subject: [PATCH v2 0/2] Interrupt handler support for NPA and NIX in Octeontx2.
Date:   Tue, 21 Jul 2020 08:08:45 +0530
Message-Id: <20200721023847.2567-1-rakeshs.lkm@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu <rakeshs.lkm@gmail.com>

Changes from v1.
1. Assigned void pointers to another type of pointers without type casting.
2. Removed Switch and If cases in interrupt handlers and printed the hexa
value of the interrupt

Jerin Jacob (2):
  octeontx2-af: add npa error af interrupt handlers
  octeontx2-af: add nix error af interrupt handlers

 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  12 ++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   4 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 148 +++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_npa.c   | 176 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_struct.h         |  20 ++
 5 files changed, 360 insertions(+)

--
2.17.1
