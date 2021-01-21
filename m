Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4D42FDE4B
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 02:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbhAUA62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 19:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbhAUAmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 19:42:38 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BD8C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 16:41:56 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b8so244438plx.0
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 16:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UDKaEKVC4WoMYfHNX2TuibQYNft0Bj2Dkxf7RkZ+7EQ=;
        b=N81jt8+ZR4eIfK+aMu52TNlojBf5yTrbFIxVHq3EHA2ndvpcAyojlPYkpFQSBnqU1z
         v0PvPFVehJYUu95VBnPmIvGlW696fgwKUdJbsO4RXgvMwLzZnZLbOkQRmWd2GaP2BEjf
         c9Vs9oi2HlvviTVF7S95vgenRmn7io7ibtvzHeyVCa9JC88zReJn3RMoa9ZdrmZoLZ5R
         9dJv1npNmYhZyofE7r/axsBZZCCXOaB2t49bv5yhDPmB2L8icgEEWuXxkMhybcUkNd1D
         01XQzmV4EuWjJFqRcZiVHetfbnn1ppXF6Te1Bd3cEwCZmjRypUnHOgD/Txy/Jj1MoHps
         jDaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UDKaEKVC4WoMYfHNX2TuibQYNft0Bj2Dkxf7RkZ+7EQ=;
        b=dTbFee90yURvjwkU3MCcZ9UPdJq8h710TcRqeFZ4hHt+4fxFdj1KUSfMsLulJGvio8
         cHOB1GwcU0It0w9EzQEG9HHXjbxUu0d4nRP43093JRSCpcuM7ydZdOvnvjQ5glh5JDKx
         qOYMQopMvG+/GiMypv9gLJhhzn3gxeyejM+aXwkDq+x+YDQ5apTMhxeWkl1ooWm8eQNe
         PDXn+LzjS/D4KqvHR1jHoa9SlW62WlTiStdemWElSMdqbNuvpZc+/DEQJmGvt4M8INdv
         tZBZrAUckrFPWNQG9WukE1QwxCjLCqb/P8oBAOgnVByOyEs43Ji09kxdzh/uFoBKjIQZ
         OVUQ==
X-Gm-Message-State: AOAM533hoS3kbkdB+Y23F7Xizjj9FVmurqkIv9+mWjgAiu9C/F5tAujN
        f9YUejca/Fk8i7FLQhCTJ3Y=
X-Google-Smtp-Source: ABdhPJw/kks18SEPjctb2xadBsu511cToAGBegjqzkI6LlhU8nmmx+1TugxosLm0Fi18dfsI4HFmMA==
X-Received: by 2002:a17:902:c509:b029:de:c3c7:9433 with SMTP id o9-20020a170902c509b02900dec3c79433mr11961697plx.71.1611189715720;
        Wed, 20 Jan 2021 16:41:55 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id a37sm2874646pgm.79.2021.01.20.16.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 16:41:55 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        kuba@kernel.org
Subject: [net-next v2 0/2] tcp: add CMSG+rx timestamps to rx. zerocopy
Date:   Wed, 20 Jan 2021 16:41:46 -0800
Message-Id: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Provide CMSG and receive timestamp support to TCP
receive zerocopy. Patch 1 refactors CMSG pending state for
tcp_recvmsg() to avoid the use of magic numbers; patch 2 implements
receive timestamp via CMSG support for receive zerocopy, and uses the
constants added in patch 1.

v2: Fixes various stylistic comments and introduces a helper method
to reduce indentation.

Arjun Roy (2):
  tcp: Remove CMSG magic numbers for tcp_recvmsg().
  tcp: Add receive timestamp support for receive zerocopy.

 include/uapi/linux/tcp.h |   4 ++
 net/ipv4/tcp.c           | 130 ++++++++++++++++++++++++++++-----------
 2 files changed, 98 insertions(+), 36 deletions(-)

-- 
2.30.0.284.gd98b1dd5eaa7-goog

