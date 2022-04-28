Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0015131C7
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbiD1LAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbiD1LAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:00:40 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A738F191;
        Thu, 28 Apr 2022 03:57:26 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id w4so6204352wrg.12;
        Thu, 28 Apr 2022 03:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qOfh1COvoyM3AZfvmUJWlbfIX8rXmjd7VDG1F1LShxs=;
        b=ZH5AvLjAUdN7EMRNbLW3yrATVhRnYjMfgKaDBi6dfzcTAsrnCKBK9UuRE3M8HAJPSI
         vOEPR1RaGX13td0wrXAKqODPSf+hpJWnabVrkgypQ/6HsZj826/5seKEgzmBwd8dpUgN
         wKCBAGmxiNtvTyi90EPqT+2Kb9uuJduSbZKFD0hyaa0xB3gTuQzavbsqI+5aIQTApCnn
         Y68FLssgft+ueSp+6Wu4fBguex7pG6aUuqmOmXRGGxrhxvktqdJvaMTY9ED7lHd7q8xw
         unDWkiUSglqdHD+oQ5oeGm9GdbgT1N/QAeK4H3K6q2wWHlkUArkhSFdq/+jhW4JTFS8J
         QFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qOfh1COvoyM3AZfvmUJWlbfIX8rXmjd7VDG1F1LShxs=;
        b=VqOs7LeQhN/0PIxCbbOiaeo+BgZDZ62Z7E48klWtlSgplrWl5mnj2+Yyj/pONl3dMn
         hMogWKQGDwGDV1pP0q7tj7vQCu8R3DD8ZggMZUy6Lwiin7Ga1d7S3qP4DTa7FkCJ5sG0
         P45DLSEhsXU00UusfPz+ppCO/+4KTqS9fPF0BRpEAODgHkBlFN2PV+FGrf2LFOj4r/XI
         pnjuS8ZbKdf7JUNFZVYj1iXK75hz+c5vhECtNdRjXaWad5sXJEj+sKIcLPOfXN2nanNX
         2EmsigGYgwgPOYdTaTEiC1Ab6bTorfB8WhKONJL3V7wsok7RuXwuLKlXf516rZC+SMhE
         /3Mw==
X-Gm-Message-State: AOAM530kx9oMBdB/9EaMHP5vcdOKVbbWRDUZLCrvNulwBu0lR5ITivi9
        RZAzKgcfdo+bw13+Tm2TNe7a/dT3IYk=
X-Google-Smtp-Source: ABdhPJwAGBZir4sJBoK5shGZ7MlV9Up15O81dvS08lr4v78slykStvPEzX1jqYmifykmPhHBsjkHVw==
X-Received: by 2002:adf:f0cc:0:b0:20a:dfae:c13a with SMTP id x12-20020adff0cc000000b0020adfaec13amr13474443wro.335.1651143444292;
        Thu, 28 Apr 2022 03:57:24 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 00/11] UDP/IPv6 refactoring
Date:   Thu, 28 Apr 2022 11:56:31 +0100
Message-Id: <cover.1651071843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
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

Refactor UDP/IPv6 and especially udpv6_sendmsg() paths. The end result looks
cleaner than it was before and the series also removes a bunch of instructions
and other overhead from the hot path positively affecting performance.

It was a part of a larger series, there were some perf numbers for it, see
https://lore.kernel.org/netdev/cover.1648981570.git.asml.silence@gmail.com/

Pavel Begunkov (11):
  ipv6: optimise ipcm6 cookie init
  udp/ipv6: refactor udpv6_sendmsg udplite checks
  udp/ipv6: move pending section of udpv6_sendmsg
  udp/ipv6: prioritise the ip6 path over ip4 checks
  udp/ipv6: optimise udpv6_sendmsg() daddr checks
  udp/ipv6: optimise out daddr reassignment
  udp/ipv6: clean up udpv6_sendmsg's saddr init
  ipv6: partially inline fl6_update_dst()
  ipv6: refactor opts push in __ip6_make_skb()
  ipv6: improve opt-less __ip6_make_skb()
  ipv6: clean up ip6_setup_cork

 include/net/ipv6.h    |  24 +++----
 net/ipv6/datagram.c   |   4 +-
 net/ipv6/exthdrs.c    |  15 ++--
 net/ipv6/ip6_output.c |  53 +++++++-------
 net/ipv6/raw.c        |   8 +--
 net/ipv6/udp.c        | 158 ++++++++++++++++++++----------------------
 net/l2tp/l2tp_ip6.c   |   8 +--
 7 files changed, 122 insertions(+), 148 deletions(-)

-- 
2.36.0

