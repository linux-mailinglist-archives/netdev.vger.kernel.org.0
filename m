Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9F52F1287
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 13:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbhAKMqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 07:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbhAKMqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 07:46:03 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F016C061786;
        Mon, 11 Jan 2021 04:45:23 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id c13so8193794pfi.12;
        Mon, 11 Jan 2021 04:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fmUQlRam3mBAIiFTols5aHBn7GKobtKDU9G+UgNF4i0=;
        b=EiqHRhdYNRRJYGFEDZqXXtfQz/GvTtM007LdtlcJLXoYig5FkRtK9Nu6fFBoILOwSZ
         gBi5VaByhIdz6CsCPpj8wVWLPS74/cUOMQscyfsoUr+1HaaPaGPaXgHj8raNOv7rR69g
         jFF7t9vF7glzoiban72d8XZ13SfjmjIqTHHyTjQe1N8R95uDMVWtS+DAt0X1o7D6gBU4
         lf+sSqX9uSafYWtAVBoNeQIvbuwiS1WE92FG3ZphV1BmV5JwitfchD7aVVK20EHGbIrh
         mqxU8PB9f86qQuin0VRPlc2/+0MLWaJabDqkAmzF7yvqK086bUz3QBoyAh9A2menOK9/
         FRCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fmUQlRam3mBAIiFTols5aHBn7GKobtKDU9G+UgNF4i0=;
        b=gKmS4L0Gbk5qDbPOWcEV8V2wrECcy7SNVX88kpYYHI+hLV8A9Vvg9o65T5DDimfafe
         AC/XIlBZHrO0ZB0ijTVOL5YiNPyEX8ceYw083HaYJMcQv+5pqQohU1flCCPhjzgPydP1
         cp0Avi/WWTOCOWMRfgkA40BSUEkMNlijJ2O9fJOKGmph5vCen+YxcMkt+9aIKuWDA1rr
         hMU/h0MCVvdJj95seBkyIxOZaz+3OWd8vMfjbS3u3Psajg6xuWBjBylAk1Kr2TD/cyMb
         k9dGqn3MReogsh/IgRaqI4tA8jtc4yZZuULyerU7JrgA8BRXCnUoOngUVb+ciz1DND3i
         RFKw==
X-Gm-Message-State: AOAM5326rF4vQEZ+H1E24bbpSBn6sJGmyEB2bUxF1J0ywsuqSSlzFvI5
        ikBxZjYQHihg3aA4yHLfmyvsUj2+uumIeQ==
X-Google-Smtp-Source: ABdhPJx9SvVdhMvCEo7HEV3xRaOUOA/9nCk915IZOJ0LDMghBxMZqa2vysGI4tyhd1T9AduzWY9/XA==
X-Received: by 2002:a63:4559:: with SMTP id u25mr19305063pgk.306.1610369122528;
        Mon, 11 Jan 2021 04:45:22 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z125sm17937939pfz.121.2021.01.11.04.45.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 04:45:21 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 0/2] net: fix the features flag in sctp_gso_segment
Date:   Mon, 11 Jan 2021 20:45:12 +0800
Message-Id: <cover.1610368918.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1/2 is to improve the code in skb_segment(), and it is needed
by Patch 2/2.

Xin Long (2):
  net: move the hsize check to the else block in skb_segment
  sctp: remove the NETIF_F_SG flag before calling skb_segment

 net/core/skbuff.c  | 5 +++--
 net/sctp/offload.c | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.1.0

