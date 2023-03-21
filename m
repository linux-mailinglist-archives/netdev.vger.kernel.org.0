Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FECA6C3965
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjCUSpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjCUSpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:45:38 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECFB303C7
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:45:36 -0700 (PDT)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 0EB333F533
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 18:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1679424333;
        bh=yvq6UMt9yN5iUlZuMyY0OG5lD/RxD6knn9gceCIGOkg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=HIPJQxMlM/Wv+lrL18I9c68nP4KtaXtCro/RU+uaaECc8R3DBz1wC8kLaGJqF/jXr
         tmVsFi4/6c4R7175sYqfYkla0ehDYwVFlj+V/I1tFYYzJIBfDVP+fHqkKNW9YPHYTA
         nfq1DpixlNc2rwdZgFQSbpddMkV6FSaBck7fsVQ1rqEdy+q5PCRNzzt2yns2ORMnQs
         RVQ14NiZk/L/iazpZu9HAVV+EVXIUJtsKue5MKkRBhtqn7j8IIdaWZo2D1ek4kTcrQ
         kFgszDVCK03s9zZVnkOIyJTjKtUFNg9AQH/MggKWDgiKFltebjk7VLJrfnXNQQ82UJ
         oFyWIQoIa1e/g==
Received: by mail-ed1-f69.google.com with SMTP id i42-20020a0564020f2a00b004fd23c238beso23246246eda.0
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:45:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679424332;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yvq6UMt9yN5iUlZuMyY0OG5lD/RxD6knn9gceCIGOkg=;
        b=ZMFoW/sN4GARCYhtQqORY5k8hv7MfPM+5cDli7DCeextgL+je6Lh0BjSEBAbWj0uhc
         p+5f16JmJGyYWSx51xqdn4YeeQa+cv145BiA36kWRqJX28T43QFjMRQRxmSVIRZs4VUx
         xMsi3lR6ujsGxBiRRUTdzHDSicRjzr1OYV1/mwsn7G+fIDC0QOgnM9rbvFgZKoswzFt7
         fRzOAD0gdGVDI/xh53UfJBtZfxi4Rz2l77fFRLRymxhBu0FE2RomO8R7EwAq8CEHURjr
         bcw+ial+a+3j8EBZq7T6O58Ac1GW0FB5q882S3akzYOk5T8OShlVEUrJoVJWds+ciQoP
         Mebg==
X-Gm-Message-State: AO0yUKXIBRNJrM0F1aYG+BGkjx6iZDJGRKDu/e/s6UFsfYuVTcl/VKgE
        NavLfMP+kYbcW0oqYilzeVPUQlCLwqKEpqi1ZfPWXS/T+MnPUzfR/CrWNPDhUdttApNnIJjPNFB
        jcYg58T/6avL4C/b4NWOxd+9kawR75S3+sA==
X-Received: by 2002:a17:906:8476:b0:931:96c5:7646 with SMTP id hx22-20020a170906847600b0093196c57646mr3965073ejc.57.1679424332652;
        Tue, 21 Mar 2023 11:45:32 -0700 (PDT)
X-Google-Smtp-Source: AK7set+h4AxTZC2eEvXbNStSrd7vEgU483k1w+wvWlNjFWtlvw+Tar3b0aYg/x+Y147Rd5JSOKP06g==
X-Received: by 2002:a17:906:8476:b0:931:96c5:7646 with SMTP id hx22-20020a170906847600b0093196c57646mr3965041ejc.57.1679424332403;
        Tue, 21 Mar 2023 11:45:32 -0700 (PDT)
Received: from amikhalitsyn.. (ip5f5bd076.dynamic.kabel-deutschland.de. [95.91.208.118])
        by smtp.gmail.com with ESMTPSA id p9-20020a1709060e8900b0093313f4fc3csm4928194ejf.70.2023.03.21.11.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 11:45:31 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>
Subject: [PATCH net-next v2 0/3] Add SCM_PIDFD and SO_PEERPIDFD
Date:   Tue, 21 Mar 2023 19:33:39 +0100
Message-Id: <20230321183342.617114-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTIALS,
but it contains pidfd instead of plain pid, which allows programmers not
to care about PID reuse problem.

2. Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
This thing is direct analog of SO_PEERCRED which allows to get plain PID.

3. Add SCM_PIDFD / SO_PEERPIDFD kselftest

Idea comes from UAPI kernel group:
https://uapi-group.org/kernel-features/

Big thanks to Christian Brauner and Lennart Poettering for productive
discussions about this.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>

Alexander Mikhalitsyn (3):
  scm: add SO_PASSPIDFD and SCM_PIDFD
  net: core: add getsockopt SO_PEERPIDFD
  selftests: net: add SCM_PIDFD / SO_PEERPIDFD test

 arch/alpha/include/uapi/asm/socket.h          |   3 +
 arch/mips/include/uapi/asm/socket.h           |   3 +
 arch/parisc/include/uapi/asm/socket.h         |   3 +
 arch/sparc/include/uapi/asm/socket.h          |   3 +
 include/linux/net.h                           |   1 +
 include/linux/socket.h                        |   1 +
 include/net/scm.h                             |  14 +-
 include/uapi/asm-generic/socket.h             |   3 +
 net/core/sock.c                               |  32 ++
 net/mptcp/sockopt.c                           |   1 +
 net/unix/af_unix.c                            |  18 +-
 tools/include/uapi/asm-generic/socket.h       |   3 +
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   3 +-
 .../testing/selftests/net/af_unix/scm_pidfd.c | 336 ++++++++++++++++++
 15 files changed, 417 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/net/af_unix/scm_pidfd.c

-- 
2.34.1

