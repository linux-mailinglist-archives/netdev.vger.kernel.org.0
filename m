Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4D0445D87
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 02:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhKEBwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 21:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhKEBwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 21:52:35 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8C8C061714
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 18:49:56 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so5502583wme.4
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 18:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wLIKb1B3sD7gpDetpYDcnVtopk8WtKF14UnMTVr7z5c=;
        b=GzH0LxLa/7Klq68tpwtV5tT03apuSeJSGuk9msZKS9/0cybWe3JxEm+BTMkS7NpDig
         h3pZ/kuFMAvhBTuyf9j+GLWoXtQY7vXsSkwndEOge4tDjLoBFbYUnt3t8EdVvgFFVfAv
         ww6P+4SQ5REZeslnLQHKaZxVPtJAaFCr5sCU2uU9QM1xuWbl8x4nyUOLbBGjo9S9FZOz
         7aTjhrgLbxAm67XEkv+ZtgDZ9Ie0fvcXbAzYwDLCjDkhinerxBPrMKGD57mw8i/KGkfB
         mnuOdWeJ0CyCP0BAEkAgRvkgnoda0Cf/6yTuxo8UpwnyrEKwyg5nfBpx8jGP/HqZp3hL
         i3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wLIKb1B3sD7gpDetpYDcnVtopk8WtKF14UnMTVr7z5c=;
        b=J4lcSMO5HD2lvCXCA8ZyXLztBrv4p2UrdyYcAP+oWr0J9auBtHKbfHvjvw0WllhG6s
         AhifBn+SKpLWBEpajqSSyvjoSwBTWO9v4AXPDIDyv2l9mOPn0kWrfUxrzn5CsgqhP25o
         Xz75L3ZjevPYMhAxQMXZ70YP5fft+0D/ZqnE17w1IlR9hduLa4q+CPUIZRcaQme8/nEK
         TGAvqgY+zW6UodPO68vDnlcwafcm0Q+1SRddVoQcYE62I5qL86CzmFM8NHnrd3N6Puav
         GMLRqCOaCVkUKP/VQmQt42Yx3FJTwzqRPD/tkm9+2EhmRJPuaEQ7nY01yZEZHWl4L3Ik
         FwSg==
X-Gm-Message-State: AOAM533RWO+mQpgZ/WkpvZFlryqXNVaPSpRBKDxQIxMPKQOwT0l88JFb
        dlEffQvLrMi+BqHo9GxujQZfNg==
X-Google-Smtp-Source: ABdhPJxYLDVSgfBtEoosBj4eSv7fLDEh4DCsNpycb2Y+v8EnzxBkVhZpAFRzhxKuUSHhTgkziFaevw==
X-Received: by 2002:a1c:f31a:: with SMTP id q26mr27039636wmq.148.1636076995407;
        Thu, 04 Nov 2021 18:49:55 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c6sm7202421wmq.46.2021.11.04.18.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:49:55 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/5] tcp/md5: Generic tcp_sig_pool
Date:   Fri,  5 Nov 2021 01:49:48 +0000
Message-Id: <20211105014953.972946-1-dima@arista.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

3 small fixes for unlikely issues.

The last patch adds tcp_sig_pool, which can be used to manage ahashes
besides md5 algorythm. It reuses tcp_md5sig_pool code and in my view is
a better alternative to [1] proposal, which uses shash for hasing
segments and frags. This also doesn't need introduction of an enum with
supported algorythms, which makes it possible to supply any
crypto-supported hashing algorythm from socket option syscall (like
struct xfrm_algo does in ipsec), reducing needless kernel code.

[1]: https://lore.kernel.org/all/5245f35901015acc6a41d1da92deb96f3e593b7c.1635784253.git.cdleonard@gmail.com/T/#u

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Francesco Ruggeri <fruggeri@arista.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Leonard Crestez <cdleonard@gmail.com>
Cc: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org

Dmitry Safonov (5):
  tcp/md5: Don't BUG_ON() failed kmemdup()
  tcp/md5: Don't leak ahash in OOM
  tcp/md5: Alloc tcp_md5sig_pool only in setsockopt()
  tcp/md5: Use tcp_md5sig_pool_* naming scheme
  tcp/md5: Make more generic tcp_sig_pool

 include/net/tcp.h        |  23 +++--
 net/ipv4/tcp.c           | 193 ++++++++++++++++++++++++++++-----------
 net/ipv4/tcp_ipv4.c      |  45 ++++-----
 net/ipv4/tcp_minisocks.c |   5 +-
 net/ipv6/tcp_ipv6.c      |  43 +++++----
 5 files changed, 207 insertions(+), 102 deletions(-)


base-commit: 8a796a1dfca2780321755033a74bca2bbe651680
-- 
2.33.1

