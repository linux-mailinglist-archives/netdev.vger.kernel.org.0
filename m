Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5414371DB
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 08:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhJVGig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 02:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhJVGie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 02:38:34 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F10C061764;
        Thu, 21 Oct 2021 23:36:17 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id i12so608736wrb.7;
        Thu, 21 Oct 2021 23:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wqajo9l0GXf1mGw9gRUF75nIkkhhT1HFpYyLLwFZC+I=;
        b=FFefIGyD1Phu9cZOJx0kNT09EOz5cTuU28dlgk8X4zpMHk1+wmOJvhA8WBNyxvPlPQ
         ZOw8EZYVcx4Lrx28Kyo7z2WFZcYS/wcndNhlaEl5biTL/MnDKSLP9+KzDeDwidJPOXCx
         sTHYhZe856NBAaohgcn6OSlJp+BkkMxx0e8N2i1A+vvXhqgi3/pbDHTa/kf6sZgzlMIF
         ODXCfGC13d/AW5iVxyqgIaFhS0zS2JFwv88pW89FzTSYPCfhHNvl6B/oE70QYD73FyHW
         LPAgAMc/+LRg01qZvmJVLHfx83n4zxb9DreZ6Lbh8uAySmP4GnOilRZGCzGrCNUZu06x
         vcEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wqajo9l0GXf1mGw9gRUF75nIkkhhT1HFpYyLLwFZC+I=;
        b=S72pCfyVIAxN1+cdfx0dmqLR4pRHQZrEQ7weKgoakJzfdhqg46Qc6d0xH62r555Qw2
         cbKDZCfl29y3p+/s3hnBbxR/AiLy4V6Hu5hFzQEJmt9y0B1QbMYsES3wqGs2Kr8vf7Ul
         Smzc3EzQ3GSswhagZevFLJi4D0FK6qODZVGfwkKr7xzf1FpfscAeNlVeITWeENT8tWgO
         06O996ljUz2Pby2iH/Ml1pUnqcAhlsEXEL0SJM67OiYeDhg8h3T0G184zAHBNZ7BWqWU
         iX+QhBVxfvOXYBHv2hmPY0Ll8f+nZI8e4hdPUtUpF0Q90Nepwv8r0SX535QFPnq0avBp
         2Bcw==
X-Gm-Message-State: AOAM5321mi70PUHigAUh30rzLmwvupUlTxki4c4AvQgn//SBbfOgUdh6
        7V7IfPBWp/zHVYMleYKkgTwbgn4i7aRRkQ==
X-Google-Smtp-Source: ABdhPJwZjz0iy6J0sYLUc1VI2UtyIbn4e4HgWJ/rzsEIIVhf/TynYySmhxIuBqEI5NvEyItCon7mrw==
X-Received: by 2002:adf:a2d4:: with SMTP id t20mr12874782wra.229.1634884576155;
        Thu, 21 Oct 2021 23:36:16 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c7sm4099733wrp.51.2021.10.21.23.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 23:36:15 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH net 0/4] security: fixups for the security hooks in sctp
Date:   Fri, 22 Oct 2021 02:36:08 -0400
Message-Id: <cover.1634884487.git.lucien.xin@gmail.com>
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

Xin Long (4):
  security: pass asoc to sctp_assoc_request and sctp_sk_clone
  security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce
  security: add sctp_assoc_established hook
  security: implement sctp_assoc_established hook in selinux

 Documentation/security/SCTP.rst     | 65 +++++++++++++++--------------
 include/linux/lsm_hook_defs.h       |  6 ++-
 include/linux/lsm_hooks.h           | 13 ++++--
 include/linux/security.h            | 18 +++++---
 include/net/sctp/structs.h          | 20 ++++-----
 net/sctp/sm_statefuns.c             | 31 ++++++++------
 net/sctp/socket.c                   |  5 +--
 security/security.c                 | 15 +++++--
 security/selinux/hooks.c            | 36 +++++++++++-----
 security/selinux/include/netlabel.h |  4 +-
 security/selinux/netlabel.c         | 14 +++----
 11 files changed, 135 insertions(+), 92 deletions(-)

-- 
2.27.0

