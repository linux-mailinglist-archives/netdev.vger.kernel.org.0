Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A91C442D65
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 13:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhKBMF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 08:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhKBMF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 08:05:28 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBBAC061714;
        Tue,  2 Nov 2021 05:02:53 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id bp7so14098705qkb.10;
        Tue, 02 Nov 2021 05:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SlEl6xnsMOiGMYZIh5HE23SN+pYdaLNBTumELjwi0xk=;
        b=ZQQ6Ev7WhK08/wKOFAcd4BuHYGigSQxOciRVmrIQ4hzikTcavk6exTZjOjc9fHz1PM
         Vdkwk9waXe3P1IyfMVkITsHydqgyMO+Ie+JCJodKpM6woZG48Nzjw5Rex4KZtTByp8Oa
         kflxBFkKBzQqZUicTL8mhvR89AuolX1MGi0o9DJszPz2X+NHsPClkQWxE/0qLQqglQo8
         5Z3W83s4QR/Bbt3eH2Deo65ucMKo1QlDZMQrHFvhrF6FH0ITQY4EvJ9Lxa+Asf2CguD8
         TCRn0LT3QO9LhPWJ2J8qwWxpJtD0ayqF4uehzhFHKo0QiX/qKDJNFHbG8Efa37RL6E83
         e6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SlEl6xnsMOiGMYZIh5HE23SN+pYdaLNBTumELjwi0xk=;
        b=tV1eg+u57ilmQTwFaNhZuzWtkpu0TLrVRbzcEt7n+oyHIahRFZT/AIrpsvUSHNyv5f
         w61QzsRirEvcGDce9hcOimiZAynGGu6LCzJsLUfeDUAwVrwl94QybRdASnUtVv95E1NF
         Qt73QeU1CJ4v8Hbs8hlTCxk4/VefVHtCJVAlsIVHqcTvpaI71bDGeUg+a2Jdy2HYfSZK
         ai45cZPIhW5U5mccnUxN258mb0FryEFuQ/xgAMkCqz9IcDByeUbJqrgOQsAsMnphpxk6
         n5MG/6l9XkO4XTPHVRqaCcLTXtyf4K/rKRj6ZRXmbBqZQCbZyL4lXH/KWImklPfIHfDr
         gHgw==
X-Gm-Message-State: AOAM532y+0eHhjZb45czfkVMSnuEz95WgTmOI2Ufp7FN8r/iCpkS10W9
        IanAnLcofIel7pUgWHzEB9VSpWAubq1/oCIy
X-Google-Smtp-Source: ABdhPJzERCZrj81J6IXNzI9QpKmIkSDq/WK1uiLQttHtL45gLXHpE1BIG5Rob+1SyVBcm9NjBSv5XQ==
X-Received: by 2002:a37:bc1:: with SMTP id 184mr27785807qkl.96.1635854572836;
        Tue, 02 Nov 2021 05:02:52 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w9sm12498988qko.19.2021.11.02.05.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 05:02:52 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCHv2 net 0/4] security: fixups for the security hooks in sctp
Date:   Tue,  2 Nov 2021 08:02:46 -0400
Message-Id: <cover.1635854268.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a couple of problems in the currect security hooks in sctp:

1. The hooks incorrectly treat sctp_endpoint in SCTP as request_sock in
   TCP, while it's in fact no more than an extension of the sock, and
   represents the local host. It is created when sock is created, not
   when a conn request comes. sctp_association is actually the correct
   one to represent the connection, and created when a conn request
   arrives.

2. security_sctp_assoc_request() hook should also be called in processing
   COOKIE ECHO, as that's the place where the real assoc is created and
   used in the future.

The problems above may cause accept sk, peeloff sk or client sk having
the incorrect security labels.

So this patchset is to change some hooks and pass asoc into them and save
these secids into asoc, as well as add the missing sctp_assoc_request
hook into the COOKIE ECHO processing.

v1->v2:
  - See each patch, and thanks the help from Ondrej, Paul and Richard.

Xin Long (4):
  security: pass asoc to sctp_assoc_request and sctp_sk_clone
  security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce
  security: add sctp_assoc_established hook
  security: implement sctp_assoc_established hook in selinux

 Documentation/security/SCTP.rst     | 65 +++++++++++++++--------------
 include/linux/lsm_hook_defs.h       |  6 ++-
 include/linux/lsm_hooks.h           | 13 ++++--
 include/linux/security.h            | 17 +++++---
 include/net/sctp/structs.h          | 20 ++++-----
 net/sctp/sm_statefuns.c             | 31 ++++++++------
 net/sctp/socket.c                   |  5 +--
 security/security.c                 | 15 +++++--
 security/selinux/hooks.c            | 34 ++++++++++-----
 security/selinux/include/netlabel.h |  4 +-
 security/selinux/netlabel.c         | 18 ++++----
 11 files changed, 133 insertions(+), 95 deletions(-)

-- 
2.27.0

