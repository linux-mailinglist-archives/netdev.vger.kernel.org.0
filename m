Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA7E77A8B6
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 14:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbfG3Mie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 08:38:34 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:46635 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729088AbfG3Mid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 08:38:33 -0400
Received: by mail-pf1-f170.google.com with SMTP id c3so6643432pfa.13;
        Tue, 30 Jul 2019 05:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5OIu5CEjdBAspysH0Ye7YYpeHBguHsHWqkMFFR0LEDc=;
        b=HI4mbCHlZhXO8MuWJ81uDkdeH94aZ1SvZPlzEwhUvoWKbKSN9KmRQt4JW/xpfJDyA4
         5tVv2vg1X3jAV7ubgR7/7qJDua8n0RAV8yNAq9aKnCjxDGMHiq9vKmxE0m1YZ7dmI1Ie
         CeCcNgwshEVmTI43v6duiKcwcWzUMOAGsqNwUwiVunJwQ8NYw51Tsl2l9nEvyENodQ0p
         JlBBH2v7dNdckNB07gTtZ2PyKI3jscUZQgIEqYSdyViX2oQIa3OKBuhIChWmju0QeSPw
         Vl72igUgyp06d6MtOFlmKJ4gw7UWpuTRc0EirIuhlZ5Aaz/BtF/CuKe1URUMQGJBeJy4
         Bazg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5OIu5CEjdBAspysH0Ye7YYpeHBguHsHWqkMFFR0LEDc=;
        b=DaJa+6dYnYsm3L8Zy86pILWokSqh20IUHvHoN0+vhNFK8YPA9JrrFNlcDne6iRYztr
         a+Rrxf+C712INVl9p7R+iyXjLXWJBiEmd4ORDAddnqrQ1fUw8TRgY1kOJxDZwbaNRxTV
         GXMOuxihqDff8N+tJf0AGwlnxTcy5m862Xyamba9at6l/CVmBHQIBEQPQqOm7V+tBRGn
         LsfMOYEMfFnuEOcQLtIW89zVSF2oyt4qdyr0e+Y/0UKlytt5dFegCy91oNx8CyZpzsMj
         UMJeBNZldL4Lm7S05iMxEVDaqhnAij+dFDYexWI0DUWNI2sDanZ5uUqtIfLFBlI9dRV8
         sJJA==
X-Gm-Message-State: APjAAAU03LJmxnb/pbbSDkH36pvhYvE6q6TDPEENHv+8U3OJ5vOpEKke
        AXzKtXSi3eM+n8DhP1gphpbTO4qz
X-Google-Smtp-Source: APXvYqxcFr1yYWUO3C1Cy3ha7pTWU71bHIV4kOdCIqbKwyevwk8JO606weXXn4SxenwGwPI89zNGBg==
X-Received: by 2002:a63:3148:: with SMTP id x69mr22310079pgx.300.1564490312699;
        Tue, 30 Jul 2019 05:38:32 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r2sm83153494pfl.67.2019.07.30.05.38.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 05:38:31 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCHv2 net-next 0/5] sctp: clean up __sctp_connect function
Date:   Tue, 30 Jul 2019 20:38:18 +0800
Message-Id: <cover.1564490276.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to factor out some common code for
sctp_sendmsg_new_asoc() and __sctp_connect() into 2
new functioins.

v1->v2:
  - add the patch 1/5 to avoid a slab-out-of-bounds warning.
  - add some code comment for the check change in patch 2/5.
  - remove unused 'addrcnt' as Marcelo noticed in patch 3/5.

Xin Long (5):
  sctp: only copy the available addr data in sctp_transport_init
  sctp: check addr_size with sa_family_t size in
    __sctp_setsockopt_connectx
  sctp: clean up __sctp_connect
  sctp: factor out sctp_connect_new_asoc
  sctp: factor out sctp_connect_add_peer

 net/sctp/socket.c    | 376 ++++++++++++++++++++-------------------------------
 net/sctp/transport.c |   2 +-
 2 files changed, 147 insertions(+), 231 deletions(-)

-- 
2.1.0

