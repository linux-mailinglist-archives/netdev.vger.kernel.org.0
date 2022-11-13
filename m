Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A096270E5
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 17:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbiKMQos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 11:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbiKMQor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 11:44:47 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECB5DEE1;
        Sun, 13 Nov 2022 08:44:46 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id hh9so5589351qtb.13;
        Sun, 13 Nov 2022 08:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R5DIZa7Rm2J6kfbCsXyn/ityWCIwsC4f7tL9B7j8cKg=;
        b=KjCIdZrwWWMPj+i6JNp//zlmRdeo8ol9O/5mgWRnG8MmoCCkt6C6fRriEYcr0Hvpq2
         vrKcu4X/qjMbn/ExUo+YlOrx7Rk6W9ezMzs/ZIeT0/8/ITgHG5WCd4pVJUGlK2RjjFEz
         C4vROrM2WgzNJ22yL6sESLZO5mTd03aw7sE6naL5YALZeJIIX47K7+8StUXBgDFhBXCL
         gopMFrQbHFiZLakm0avY/Y2hoUtce44Rkh/33WtjXl8dicMGC9vEmwLlDC7rMzOzDkOK
         NmT9KyRGAE2u8ZibX7LZn0Zu/mdWTvXmBF/A3K/G1EWYz9Y0brw2pb/cFFM+x8vzJI6q
         VcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R5DIZa7Rm2J6kfbCsXyn/ityWCIwsC4f7tL9B7j8cKg=;
        b=ZiqEpHyUdK6Q6lxx+8a6l3omMsrWuJEfhzJZwuqo0KJsPREHFtMe4at87qdWTgD2Qe
         xCA/Ln4DLzYjCQ9EKssj+sl0hEDsHEEEO5qng1Jw37KnkRl0Zx5fac28zbLDzZ7bXrCV
         4EQMMYJ4+sY3hYRHK4huYtEwtReG7cYdwewRWc+71YMocJQ9rDDkTGmy/QD8FNmGJDrF
         xVgEmgBoXRkrS7yiXXSIO6rXwbDcvreDyARYkxO6fivsyMPwDrCYipmeWBgEx0DzZfra
         c2qB4Y45O6R0VW24W5RN6YI6sbsVtARqxQiEcJ1swLjTr4R03rfwHX3EYHt7lsX09Nuk
         ML5w==
X-Gm-Message-State: ANoB5pkfC1vC+xPyfHcNUYOQCW/v4BlxMxKkCJx66CNJzM46XihsqJi1
        TowupNqgGmGGjQYTsF/z/T0B8xAgUvsm/w==
X-Google-Smtp-Source: AA0mqf6RlK/K8tgGGhfA38XtwNxbIeVuXgHGEyBsqo7LKwSvcioUxYM29TvOUwiqZKHnLC+E6Oosvg==
X-Received: by 2002:a05:622a:151:b0:3a5:6a0e:db3c with SMTP id v17-20020a05622a015100b003a56a0edb3cmr9400000qtw.398.1668357885705;
        Sun, 13 Nov 2022 08:44:45 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id cf8-20020a05622a400800b0035d08c1da35sm4429191qtb.45.2022.11.13.08.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 08:44:45 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Subject: [PATCH net-next 0/7] sctp: support vrf processing
Date:   Sun, 13 Nov 2022 11:44:36 -0500
Message-Id: <cover.1668357542.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds the VRF processing in SCTP. Simliar to TCP/UDP,
it includes socket bind and socket/association lookup changes.

For socket bind change, it allows sockets to bind to a VRF device
and allows multiple sockets with the same IP and PORT to bind to
different interfaces in patch 1-3.

For socket/association lookup change, it adds dif and sdif check
in both asoc and ep lookup in patch 4 and 5, and when binding to
nodev, users can decide if accept the packets received from one
l3mdev by setup a sysctl option in patch 6.

Note with VRF support, in a netns, an association will be decided
by src ip + src port + dst ip + dst port + bound_dev_if, and it's
possible for ss to have:

# ss --sctp -n
  State       Local Address:Port      Peer Address:Port
   ESTAB     192.168.1.2%vrf-s1:1234
   `- ESTAB   192.168.1.2%veth1:1234   192.168.1.1:1234
   ESTAB     192.168.1.2%vrf-s2:1234
   `- ESTAB   192.168.1.2%veth2:1234   192.168.1.1:1234

See the selftest in patch 7 for more usage.

Also, thanks Carlo for testing this patch series on their use.

Xin Long (7):
  sctp: verify the bind address with the tb_id from l3mdev
  sctp: check ipv6 addr with sk_bound_dev if set
  sctp: check sk_bound_dev_if when matching ep in get_port
  sctp: add skb_sdif in struct sctp_af
  sctp: add dif and sdif check in asoc and ep lookup
  sctp: add sysctl net.sctp.l3mdev_accept
  selftests: add a selftest for sctp vrf

 Documentation/networking/ip-sysctl.rst   |   9 ++
 include/net/netns/sctp.h                 |   4 +
 include/net/sctp/sctp.h                  |  16 ++-
 include/net/sctp/structs.h               |   9 +-
 net/sctp/diag.c                          |   3 +-
 net/sctp/endpointola.c                   |  13 +-
 net/sctp/input.c                         |  98 +++++++-------
 net/sctp/ipv6.c                          |  22 +++-
 net/sctp/protocol.c                      |  19 ++-
 net/sctp/socket.c                        |   9 +-
 net/sctp/sysctl.c                        |  11 ++
 tools/testing/selftests/net/Makefile     |   2 +
 tools/testing/selftests/net/sctp_hello.c | 139 ++++++++++++++++++++
 tools/testing/selftests/net/sctp_vrf.sh  | 160 +++++++++++++++++++++++
 14 files changed, 445 insertions(+), 69 deletions(-)
 create mode 100644 tools/testing/selftests/net/sctp_hello.c
 create mode 100755 tools/testing/selftests/net/sctp_vrf.sh

-- 
2.31.1

