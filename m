Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4026BB828
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjCOPmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjCOPms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:42:48 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706901514C
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:47 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-541942bfdccso106439977b3.14
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678894966;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k4PbTIpNUgac/hHMBpgIYKuqv9heXHCBHSul7ap4hpo=;
        b=kQChG5lcncfz2z5Ht6Z6libykBVGK9gIUAkX4UR7JI8EfFq0W1TMiPyzcXCr3AYooD
         BWhuUiFtWACjlMd61aeafIagoBvp5JU702+rgoiEDh1eS2RUbsv6v9IW7w6T7BBwbiu+
         fsO+ng0AiFzgW/LJpTOF3eQVQ9USXI0SbUBqfmguenq2lV+q+a9gZnRBFLrVgnaDcVDl
         khEvxoO3yAftluof0m/F9X0Cg5ZqvBDaUi6GDRkTupJw9T6EFIrXejHwMp9/cQfnwj49
         s5jNlm3NHOu9NxQcVqv5HPHsRdZgiXJVgAejtu2CB2qBf0hj+XGOMiWSCO8KDJ5Ef+Gi
         zV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894966;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k4PbTIpNUgac/hHMBpgIYKuqv9heXHCBHSul7ap4hpo=;
        b=BfedTwoltmnCHHaTHnbzBYuhnMRWelEq2vZuC99LjfxhXhwjzH3qP5f/0A0/aEdWWF
         EFQSSVBDcpu8Q3qzG13dWlap+XByhzDe/6/xwSgJS1C4QaECRawFn1b7Ve0Rp9H96imI
         UcBr5+TqLguEugQ9bJD+QnCf11fHFr8cgFDn8SeN+bJ8i3l5rY4CO/NjhLRJY0c1K6Q3
         6c2qkd6OKJKnafpp/eORXeVBUjnrWuUfgPmWe5jSiWiZJnfs4y0xeui3u6YGIPvaD7mx
         9ujncY/d1WvRRCO2NhHLQVatmaRLmBr5J+azMNv6CiBw5AOmTrG38k7cHGIDAupRmSlF
         1+cQ==
X-Gm-Message-State: AO0yUKUXVPVDoiQTvq294iNe8oJ+nxMmLr8aE1Gz8H/dOAwtaHrlk9DV
        tt2kQJw+yMzabfjOUlSr7ryBLQ787hgjKA==
X-Google-Smtp-Source: AK7set+mOTEuQy80pl3dZEELZ2JIuP7TGPnashO1UIqDwBKju6SsnJizOg/Dzdyp8qm8FVl6QazRcaEEcDfQ2Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:c4a:0:b0:b31:34ab:5ca0 with SMTP id
 d10-20020a5b0c4a000000b00b3134ab5ca0mr9331098ybr.11.1678894966752; Wed, 15
 Mar 2023 08:42:46 -0700 (PDT)
Date:   Wed, 15 Mar 2023 15:42:37 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315154245.3405750-1-edumazet@google.com>
Subject: [PATCH net-next 0/8] inet: better const qualifier awareness
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

inet_sk() can be changed to propagate const qualifier.

Following patches adds more const qualifiers.

Eric Dumazet (8):
  inet: preserve const qualifier in inet_sk()
  ipv4: constify ip_mc_sf_allow() socket argument
  udp: constify __udp_is_mcast_sock() socket argument
  ipv6: constify inet6_mc_check()
  udp6: constify __udp_v6_is_mcast_sock() socket argument
  ipv6: raw: constify raw_v6_match() socket argument
  ipv4: raw: constify raw_v4_match() socket argument
  inet_diag: constify raw_lookup() socket argument

 include/linux/igmp.h        | 2 +-
 include/net/addrconf.h      | 2 +-
 include/net/inet_sock.h     | 9 +++++----
 include/net/raw.h           | 2 +-
 include/net/rawv6.h         | 2 +-
 include/trace/events/sock.h | 4 ++--
 include/trace/events/tcp.h  | 2 +-
 net/ipv4/igmp.c             | 4 ++--
 net/ipv4/ip_output.c        | 5 +++--
 net/ipv4/raw.c              | 4 ++--
 net/ipv4/raw_diag.c         | 2 +-
 net/ipv4/udp.c              | 4 ++--
 net/ipv6/mcast.c            | 8 ++++----
 net/ipv6/ping.c             | 2 +-
 net/ipv6/raw.c              | 2 +-
 net/ipv6/udp.c              | 6 +++---
 net/mptcp/sockopt.c         | 2 +-
 security/lsm_audit.c        | 4 ++--
 18 files changed, 34 insertions(+), 32 deletions(-)

-- 
2.40.0.rc1.284.g88254d51c5-goog

