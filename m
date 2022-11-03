Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885BD618A7E
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiKCVZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKCVZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:25:34 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49FD17AAA
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 14:25:32 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id r186-20020a1c44c3000000b003cf4d389c41so4214449wma.3
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 14:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dCqZNSHIaxnmzerwBb4XIzFYMc5x8wpQp8vL9SOeM7o=;
        b=I1KjqUirjGHXmo2eSE5H2LXCLOtZVk5v18PrxYKsfDtiV6Zxtkv54CjpdZ9FjmQbVv
         FLzazGxfdCvKYXgp7UUioFTUOxJ4GYre5vqKGLV9bAQHMminVeeH3louO6ugrTx3U7jp
         q/SuMBzDQ4FLoKCisko+Yp6Tf9Ujoir5sercRpbV0goa3PbcYxJIKS206I8vHL5glcH2
         U9R/Npj4ZgbD6+2zIWBIeKVJMuB70ZklH7ugTNRJfDG52Up9jLixE5OR4PMdRnYtlQJX
         ezJutKj2JrTkTuU+fd+9tYnBlEZvdB+pXMe8xzhAt10J45tZOxU3WPR1nnj1GtcMf5zI
         Sfjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dCqZNSHIaxnmzerwBb4XIzFYMc5x8wpQp8vL9SOeM7o=;
        b=wFpCnZ+hhGLsW9GOYJpj7x50oPw4eMDceurfpv/MKqEl+L8YxMS5NP9sDKOtnW94uL
         zmBUwL46i1bbJX/k1CwPH4O5SHXTFJfZlO1st4XV/U6lupUuku0Tb/G4QxVx0VVSLymO
         fBcqIudz+FOUcbnkE2sNoX0UvZaDssK/NI2d8GMYRc7vWXcQnzimRzoc7TyEJ3zJuyJp
         fzAfaOn7sPpBdEN2vh2sBD3Suk6ZMWNW8kHvdg4GKK2zmxfVtP8g6Sj6Xe8oe+rhMsDP
         FsfWMbuB2LXZH8Edp3lAGwwX9Sazd/uY3EGnonXJnWqBGnBQcu0NMhpyysP9OdJXHxb9
         Jpmw==
X-Gm-Message-State: ACrzQf2fIAtw6igU5WQ69TR5Gycj3oCbLLgezmkPfz1d7r5NiRwi+Rpa
        LUbG9Y7A4IsIavL4DbxAQNdCIw==
X-Google-Smtp-Source: AMsMyM6pdKCb3XDLsvHaC2qLEWuJ5HZzMGMMMeKkNHEV2+giCh3a6z1oeOVxF4qVmdnQCbrQ3psM8g==
X-Received: by 2002:a05:600c:1553:b0:3c6:e12d:6f32 with SMTP id f19-20020a05600c155300b003c6e12d6f32mr30355982wmg.109.1667510731469;
        Thu, 03 Nov 2022 14:25:31 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id t18-20020a05600c199200b003a601a1c2f7sm1038652wmq.19.2022.11.03.14.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 14:25:31 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 0/3] net/tcp: Dynamically disable TCP-MD5 static key
Date:   Thu,  3 Nov 2022 21:25:21 +0000
Message-Id: <20221103212524.865762-1-dima@arista.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes to v2:
- Add static_key_fast_inc() helper rather than open-coded atomic_inc()
  (as suggested by Eric Dumazet)

Version 1: 
https://lore.kernel.org/all/20221102211350.625011-1-dima@arista.com/T/#u

The static key introduced by commit 6015c71e656b ("tcp: md5: add
tcp_md5_needed jump label") is a fast-path optimization aimed at
avoiding a cache line miss.
Once an MD5 key is introduced in the system the static key is enabled
and never disabled. Address this by disabling the static key when
the last tcp_md5sig_info in system is destroyed.

Previously it was submitted as a part of TCP-AO patches set [1].
Now in attempt to split 36 patches submission, I send this independently.

Cc: Bob Gilligan <gilligan@arista.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Francesco Ruggeri <fruggeri@arista.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Salam Noureddine <noureddine@arista.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

[1]: https://lore.kernel.org/all/20221027204347.529913-1-dima@arista.com/T/#u

Thanks,
            Dmitry

Dmitry Safonov (3):
  jump_label: Add static_key_fast_inc()
  net/tcp: Separate tcp_md5sig_info allocation into
    tcp_md5sig_info_add()
  net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction

 include/linux/jump_label.h | 21 +++++++++--
 include/net/tcp.h          | 10 ++++--
 net/ipv4/tcp.c             |  5 +--
 net/ipv4/tcp_ipv4.c        | 74 +++++++++++++++++++++++++++++---------
 net/ipv4/tcp_minisocks.c   |  9 +++--
 net/ipv4/tcp_output.c      |  4 +--
 net/ipv6/tcp_ipv6.c        | 10 +++---
 7 files changed, 96 insertions(+), 37 deletions(-)


base-commit: f2f32f8af2b0ca9d619e5183eae3eed431793baf
-- 
2.38.1

