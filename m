Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377D0547660
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 18:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbiFKQUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 12:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbiFKQUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 12:20:50 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7943EBB;
        Sat, 11 Jun 2022 09:20:49 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id q18so1658960pln.12;
        Sat, 11 Jun 2022 09:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ig7GHUec0B14LkIn8gR94Hl1yo4+P+uoDJpl1B2ma+A=;
        b=OXkmP0wc3uOg7pBxnOdbppFJolfovMtAE4ogms9k2TchBab+kIXehe3LVfFweIzINq
         Fw3e/4Deh3ZjvRp9AK72xOA9w/VBnGrjFwGq5HdG52SLvoo+YyJprdpkhxjT7r21HrYL
         bB9+iinrflmgr065ugNDwO9lwJKIu0vjj57IgycJg6/Qrm68rtEkpP26KA3y3r9OpOTe
         FZCR+R57bgvcDVDIij/IgPnGEQaDb0LoZB1xAwbsJQ8R8o18PgRXgWExgLLbFTw96S1i
         zLQrZcqxHIZtEdwxCEFVgkuId4cAccjRUrfgvhpDZ48JTl8C5GjMB8fOuuVuo17Sda2S
         EUQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Ig7GHUec0B14LkIn8gR94Hl1yo4+P+uoDJpl1B2ma+A=;
        b=jtg5xdEVIN5ckCNjA3S9sAIq8a886/SulFYTuf9um16SLp2tZNgji/abRAWHzEJh7l
         YWJ+66MkD5FWRKJ4rggRBDbifzbnsH+1vGXudyJiavv8qrXRKNmIPd74ZFXM1INh0SQe
         Tmdd5aqCMVxIyo2kzCX675E5ogQCNZXiJqviHKZn8PAefOcp/F/BUjBwU3b9TSQ3DLxm
         wbuWPP8xHUBq7GyeTd7gKQdHh4h0mbCUGGsyZ7ifiuFreLAIbvehJ+cePONhljqKyrKF
         TxL5t0mG+Tnz1wZUk2Y92c6Q6Og/CqOmn7QvfHiS1T3KqcHQ/QToDULIlu0MUHrdqzZ8
         /f2A==
X-Gm-Message-State: AOAM533sG2gseAyb5SpKpsmZGvjhbqRlsCVAY3GpFV1/eWi9xD0iwu46
        8FFKJ/dOZ4Ax+JrA75MkRxVnpE98jGcT+A==
X-Google-Smtp-Source: ABdhPJx25Q1K2yss82Bk9pHn/IZ4OZWXnRmnv+CmysSLFaitaXuPTeX5+aAqpwvFpRAcrDl6Vbezyw==
X-Received: by 2002:a17:902:d2d1:b0:167:4c33:d5d3 with SMTP id n17-20020a170902d2d100b001674c33d5d3mr43247956plc.81.1654964448914;
        Sat, 11 Jun 2022 09:20:48 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id je9-20020a170903264900b0015e8d4eb2e3sm1692469plb.301.2022.06.11.09.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jun 2022 09:20:48 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH 0/2] can: etas_es58x: cleanups on struct es58x_device
Date:   Sun, 12 Jun 2022 01:20:35 +0900
Message-Id: <20220611162037.1507-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains two clean up patches toward struct es58x_device
of the CAN etas_es58x driver. The first one removes the field
rx_max_packet_size which value can actually be retrieved from the
helper function usb_maxpacket(). The second one fixes the signedness
of the TX and RX pipes.

No functional changes.

Vincent Mailhol (2):
  can: etas_es58x: replace es58x_device::rx_max_packet_size by
    usb_maxpacket()
  can: etas_es58x: fix signedness of USB RX and TX pipes

 drivers/net/can/usb/etas_es58x/es58x_core.c | 5 ++---
 drivers/net/can/usb/etas_es58x/es58x_core.h | 6 ++----
 2 files changed, 4 insertions(+), 7 deletions(-)

-- 
2.35.1

