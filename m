Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFC562C960
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbiKPUBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbiKPUB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:01:28 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2689663B94;
        Wed, 16 Nov 2022 12:01:27 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id c15so11434303qtw.8;
        Wed, 16 Nov 2022 12:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cgNyxqLmmLctmSF/4BskxSA/5tgM3jspyo0wtb8y+7A=;
        b=myyfg7qo2sNUd/k5rngiZ4MXQjBF1VcxpRwoD4uy7Pl9MT/bEs36FpCYbxpB4WaDj2
         3JN7Lp0s6phVIJUcINhip1/1yUc8WXqLp2lZEhpoFwB4DrNKWupc7c8k/w/VaGfIMD54
         YuGzEWJ2MYu9T7pTts9XDogw85hzHxfZvNB85k7OftIk3tk7kr5MuqN/5mhiRfHAZL0r
         +T4BRZ758xq5z72JAn6IP34htKSNtw+JmakUHB98jI0qj3pxQWT9dtt1+GDTESVsu9Ri
         +6Roy5hN3plMrbAIS1ceos0mjb+Eme94S0Q9lUXvnqC/0loSZgwc46ilPs0b8Vpk4x10
         N86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cgNyxqLmmLctmSF/4BskxSA/5tgM3jspyo0wtb8y+7A=;
        b=P9oxC7q8eHDJSCx1uyTM3V1jnaGIx9sk3BoWO3520ZIsEHWvB6yfIUUJbVXiLgQiDk
         DyFFT19V6uDe8wj6UOs9N7QN+SAGrzCZqsoOtlVb7hl29ROewFbmxehChcb+iCO2JSFU
         Wt03hinN6+cRfY7YMwldgStUA2x77H6eO1F5vmKeb82dTdF7+YKgMgEpnFEbIibamcYb
         ikmxNeDrK4nMnfYL6zyCxwk4dBi1EkozOV08Jq0jV+/wG4+2f4bMDB3iVNAmA6qlXySb
         mwe58NwmV5bEaXmE2WHiFQ9A7LU8GmralDF6S7FC9mTrcksDKBh6CKphPLpCOlDHeBvW
         MIfA==
X-Gm-Message-State: ANoB5pmBmj+QIO2d482P5EmlY0BzZSH2CdhvSE01DlebTUOQGamFgJNM
        SEQjBEu8sNGH2jdsroF626HTTUzxXOs17A==
X-Google-Smtp-Source: AA0mqf6/YsW4rh6Wc08KSkEGVMw70auoadCZfVkhVZkvtkOroBm0+Q8IPsMtv5odVnqTKq0PiqYsTA==
X-Received: by 2002:a05:622a:1349:b0:3a5:f932:f16d with SMTP id w9-20020a05622a134900b003a5f932f16dmr9111023qtk.44.1668628885806;
        Wed, 16 Nov 2022 12:01:25 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d7-20020a05620a240700b006fba44843a5sm2900411qkn.52.2022.11.16.12.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:01:25 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Subject: [PATCHv2 net-next 0/7] sctp: support vrf processing
Date:   Wed, 16 Nov 2022 15:01:15 -0500
Message-Id: <cover.1668628394.git.lucien.xin@gmail.com>
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

v1->v2:
  - In Patch 5, move sctp_sk_bound_dev_eq() definition to net/sctp/
    input.c to avoid a build error when IP_SCTP is disabled, as Paolo
    suggested.
  - In Patch 7, avoid one sleep by disabling the IPv6 dad, and remove
    another sleep by using ss to check if the server's ready, and also
    delete two unncessary sleeps in sctp_hello.c, as Paolo suggested.

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
 include/net/sctp/sctp.h                  |   6 +-
 include/net/sctp/structs.h               |   9 +-
 net/sctp/diag.c                          |   3 +-
 net/sctp/endpointola.c                   |  13 +-
 net/sctp/input.c                         | 108 +++++++-------
 net/sctp/ipv6.c                          |  22 ++-
 net/sctp/protocol.c                      |  19 ++-
 net/sctp/socket.c                        |   9 +-
 net/sctp/sysctl.c                        |  11 ++
 tools/testing/selftests/net/Makefile     |   2 +
 tools/testing/selftests/net/sctp_hello.c | 137 +++++++++++++++++
 tools/testing/selftests/net/sctp_vrf.sh  | 178 +++++++++++++++++++++++
 14 files changed, 461 insertions(+), 69 deletions(-)
 create mode 100644 tools/testing/selftests/net/sctp_hello.c
 create mode 100755 tools/testing/selftests/net/sctp_vrf.sh

-- 
2.31.1

