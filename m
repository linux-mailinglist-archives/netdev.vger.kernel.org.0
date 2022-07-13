Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE893573FA6
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbiGMWhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiGMWhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:37:16 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353C312D37;
        Wed, 13 Jul 2022 15:37:16 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so6087659pjo.3;
        Wed, 13 Jul 2022 15:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U6nqR87MpLCb7RwS78t5wN2kwEi9VqwmnIoFrwat7b0=;
        b=bvY7AIzlKMI7yhyri9SaPd6THvA6WXB44RA2ikIG/1eFNxeL+xccWsNf7ch6mxpkKw
         MGCSmPZuBiQbxm/WxFKELpdTr6OsIUw+xtcuiQpha+GR85X7atZwnNgOUPnrfeyZNzWJ
         SsUT6I0YUxadKt1dc0aOQI33O62arhQ5TjNfhSLzSjyseohRqZKgC8XHYqdBl+T8RNy8
         klWUcgdkCZlcJL9PqSfjsLVjBxnkd/uhZtRTSkTnNXC6ft8XCbriNybC92BrLTvKOyY+
         5Q/yS0WdXj/ZDyci4rFuby9+FdbmylucdPUnh/GEAeOCVm+SFSnOQW6AaMeVXfr2jAnF
         aaug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U6nqR87MpLCb7RwS78t5wN2kwEi9VqwmnIoFrwat7b0=;
        b=EMpQ2zEVn3yECRpU6Wr/2KWv7TRytCFEJbIPY60EllgpNt2LuHXuyONFhUx6D5NRSP
         JeeyP89tPiF2bilPKXNBu0zOJynp1DQ4B2GSIZATuQsiUWkiqwLLoef7JWegAdT38df9
         tUPjVQFNeyFlEoYF9o3vlmnOcz118aVroOcMgptWBTZbQsjWANNyJm/pxchqlGmRkUdc
         LL6q/2ugN0xSX70a+KuXqFnhbx/DDZi4ndzLIgyLBMqMVIRi1uBqiF4SnwZiCfcIdXVI
         U/iyR8DsJxJDvqp75Vq7yg4uqJyoQLd/UAA2xpjwnZsLmOL9HmYa1qe8yGr/5hp4VQmq
         +JUg==
X-Gm-Message-State: AJIora9VLQWGxwIc1a/1OxR5FKB77xb+tl6GSxEaEZq891kRbkailMzc
        JGQojcC32UQ0JdbwNgLpbeyg2eGcSXvzOJhSUv4=
X-Google-Smtp-Source: AGRyM1si9Jr/THg4CviajcVTwNIJVtgmyHQpq2A9v1rCjn8Lj8LGjikzZAilgOkE7Zj/9jI6YFh+vw==
X-Received: by 2002:a17:902:c14a:b0:16b:d07c:ad60 with SMTP id 10-20020a170902c14a00b0016bd07cad60mr5166011plj.141.1657751835064;
        Wed, 13 Jul 2022 15:37:15 -0700 (PDT)
Received: from localhost.localdomain ([64.141.80.140])
        by smtp.gmail.com with ESMTPSA id b18-20020aa78ed2000000b00525302fe9c4sm38639pfr.190.2022.07.13.15.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 15:37:14 -0700 (PDT)
From:   Jaehee Park <jhpark1013@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        dsahern@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, linux-kernel@vger.kernel.org,
        aajith@arista.com, roopa@nvidia.com, roopa.prabhu@gmail.com,
        aroulin@nvidia.com, sbrivio@redhat.com, jhpark1013@gmail.com
Subject: [PATCH v2 net-next 0/3] net: ipv4/ipv6: new option to accept garp/untracked na only if in-network
Date:   Wed, 13 Jul 2022 15:37:16 -0700
Message-Id: <cover.1657750543.git.jhpark1013@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch adds an option to learn a neighbor from garp only if
the source ip is in the same subnet as an address configured on the
interface that received the garp message. The option has been added
to arp_accept in ipv4.

The same feature has been added to ndisc (patch 2). For ipv6, the
subnet filtering knob is an extension of the accept_untracked_na
option introduced in these patches:
https://lore.kernel.org/all/642672cb-8b11-c78f-8975-f287ece9e89e@gmail.com/t/
https://lore.kernel.org/netdev/20220530101414.65439-1-aajith@arista.com/T/

The third patch contains selftests for testing the different options
for accepting arp and neighbor advertisements. 

Jaehee Park (3):
  net: ipv4: new arp_accept option to accept garp only if in-network
  net: ipv6: new accept_untracked_na option to accept na only if
    in-network
  selftests: net: arp_ndisc_untracked_subnets: test for arp_accept and
    accept_untracked_na

 Documentation/networking/ip-sysctl.rst        |  52 +--
 include/linux/inetdevice.h                    |   2 +-
 net/ipv4/arp.c                                |  24 +-
 net/ipv6/addrconf.c                           |   2 +-
 net/ipv6/ndisc.c                              |  29 +-
 tools/testing/selftests/net/Makefile          |   1 +
 .../net/arp_ndisc_untracked_subnets.sh        | 308 ++++++++++++++++++
 7 files changed, 389 insertions(+), 29 deletions(-)
 create mode 100755 tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh

-- 
2.30.2

