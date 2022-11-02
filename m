Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB30616F75
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiKBVOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiKBVOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:14:03 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BA9D9
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:13:59 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id z14so63016wrn.7
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 14:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ns47bvu92RN1o/ST22gXYBYxxkJNfGwoF1/G0Fam6ZU=;
        b=P/jap1+f1RnlBrKQ5nOOYo+gEz7RfjfVWA1cqgzorpmFJzBkbPumvPweSEymhIETKV
         Wr3DgX9ti2aUAs4JLvBwgXbbVhjsXBMTpnrvOt9B9DRLpvOwjp0uQ4HS8IWTzzviU6ka
         j+gVSFVhzAWBfXi9HaH6Ph/QnU9VU6wvJrpEXH0871rASpyoMbtjBP/YNr+g5hyFaUtV
         lpCO9x1jo70oyWcOirhNbtJEEBqKUmdP3dt3/jmk+LgWRzLoh/eyj2Sz1vuVqBaLeJk9
         EQ9LLt2eR/amdapxof8dOj4AzsKE1oyBn7vLS9iVGYAsd5KK6Fa/YRU6G9zwto8SjStt
         SGUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ns47bvu92RN1o/ST22gXYBYxxkJNfGwoF1/G0Fam6ZU=;
        b=NsJk3qxofACwT2nsn7amgxxR0o3r+OgXsi5Zwb8nD6Xegq0Nvp0xeoUnIo1NAkXRJk
         rlmloq3JI2wcoEsRuAhy6wxUEIj7tnqshf55xNsBMwhZXHjvxGUdbGo0LvlFINLZxzGm
         xnalNJNkdtKvvomyr7rub3eqYlYvtUlALsCiwMhOTohp1InQ/GJI8y5RveRsIH9Y4HtO
         0+2TWtF60fPXe9cN83Utff/VVgPZ2HL13gkJo7LweWS6YJmx8g6CAJD5jysLjkh/0rDu
         BcH76bDYtHE9GVXVFnBI2VeWZnmwDeWDlj0O1T0A9Hjn65uu+iBsu3STtiN1casK20X4
         3wUw==
X-Gm-Message-State: ACrzQf0TQCStcTYB0xMbCuG58HkqPuIxmeOFyhum9zaFjUnPQT1/+01V
        4Gi6vrMKIn+kn7Hm7TISn6LlTA==
X-Google-Smtp-Source: AMsMyM7ztfbtC4swakuetRFq6TocNcEe3huQmympPzaW2QCSFJcHJAaDgWSWPc1z2/XBuVIU79BjoA==
X-Received: by 2002:adf:cc92:0:b0:236:77f0:ef5f with SMTP id p18-20020adfcc92000000b0023677f0ef5fmr16813625wrj.198.1667423637443;
        Wed, 02 Nov 2022 14:13:57 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id cc6-20020a5d5c06000000b002364835caacsm14179851wrb.112.2022.11.02.14.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 14:13:56 -0700 (PDT)
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
Subject: [PATCH 0/2] net/tcp: Dynamically disable TCP-MD5 static key
Date:   Wed,  2 Nov 2022 21:13:48 +0000
Message-Id: <20221102211350.625011-1-dima@arista.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Dmitry Safonov (2):
  net/tcp: Separate tcp_md5sig_info allocation into
    tcp_md5sig_info_add()
  net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction

 include/net/tcp.h        | 10 ++++--
 net/ipv4/tcp.c           |  5 +--
 net/ipv4/tcp_ipv4.c      | 74 +++++++++++++++++++++++++++++++---------
 net/ipv4/tcp_minisocks.c |  9 +++--
 net/ipv4/tcp_output.c    |  4 +--
 net/ipv6/tcp_ipv6.c      | 10 +++---
 6 files changed, 78 insertions(+), 34 deletions(-)


base-commit: 8f71a2b3f435f29b787537d1abedaa7d8ebe6647
-- 
2.38.1

