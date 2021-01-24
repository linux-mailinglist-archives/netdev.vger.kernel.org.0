Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA24301AB3
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 09:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbhAXIqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 03:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbhAXIpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 03:45:49 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CFBC061574
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 00:45:00 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 31so5736330plb.10
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 00:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ptc7rBtJom9jcqbHqQcgwhy2ALSos7YsSj93cZBUov8=;
        b=XILA6JbmFm4RiOIbZkxI4BldE4fiQg/SBotcCNTBHRYsx7FnlHe8MBeCmchUYy5s6G
         OgWzXR1csnovLSGnau6MEASW/3ItnrFwzG8dfJDvCq0Bs4ScJ6oZaJJ0IqyVyUdOSEYv
         n6QkiPuXGZRVqbSthnabCC0aFdQKUNxS/l9yblr+JGLG1mRfE3GrwKfhWr6M7LRxoRjv
         0T9xZUoq7ScGVTnVCJL4JdQNcDg9uh5FQLIjh+UDb++/hdvosnAemKaseVRuOaxn5DeZ
         AjKWzDLlJK3/TQRtjACE84TvawCkasCv429TR0s7GsSbIEkR+zHcD7iIr54aaZy/AVRu
         I47A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ptc7rBtJom9jcqbHqQcgwhy2ALSos7YsSj93cZBUov8=;
        b=ra9Dk9iwnJMaSPOP+BwnLIP7pQ8ro7vGFw0MJ3Kwg4tawqVT5x+0GerSv08WhthZjZ
         DGfqcR+0V87bgGmE4L+fLyXbhP38+X2gjDCB5zKIsJgptoMSLTc8e7t5gypC7DSOg4ML
         X57sNpaPWQ5mgyUlqbRd/rz9ski+oCSJ/TyYlFp6te4qitk/jAlp+fJHUdqKfKIUBiN/
         GQjbbq7xrSV2QXRXrkmUjy+rv+MqoAtN4a0PTY2bh1tp+G8g94k0zaKuX3deXewI0H2n
         Rbb0RMNrIv9M+ZfkFpgBzMOPqhxiumE80lRt4E/h3mIHbJ/d4HG4EevFQbwCMIwFdaPj
         unUQ==
X-Gm-Message-State: AOAM533kmNFxfNusdx1QUnzy4DcDetJCRCLBsmYPYSms9N47duTQjBe1
        GbxCDE2f24YdBzyM3IQPpLZGCIUbhaXlZQ==
X-Google-Smtp-Source: ABdhPJyfhan0TPSq6QPsYZVcRjoFsPUdHXIMSJ00fqkV0YW85cRLtI5+3KWnh7ZMCkaoGoyKnGQMdw==
X-Received: by 2002:a17:90a:3f82:: with SMTP id m2mr15377683pjc.235.1611477900301;
        Sun, 24 Jan 2021 00:45:00 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 14sm13179705pfy.55.2021.01.24.00.44.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Jan 2021 00:44:59 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 0/2] net: add support for ip generic checksum offload for gre
Date:   Sun, 24 Jan 2021 16:44:50 +0800
Message-Id: <cover.1611477858.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset it to add ip generic csum processing first in
skb_csum_hwoffload_help() in Patch 1/2 and then add csum
offload support for GRE header in Patch 2/2.

v1->v2:
  - See each patch's changelog.

Xin Long (2):
  net: support ip generic csum processing in skb_csum_hwoffload_help
  ip_gre: add csum offload support for gre header

 include/net/gre.h      | 19 +++++++------------
 net/core/dev.c         | 13 ++++++++++++-
 net/ipv4/gre_offload.c | 15 +++++++++++++--
 3 files changed, 32 insertions(+), 15 deletions(-)

-- 
2.1.0

