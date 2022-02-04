Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7024A9A71
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 14:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359153AbiBDN6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 08:58:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359114AbiBDN6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 08:58:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643983095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=PllD//4dUqneGZn34uKS0AY6GrlRGlNTYyXkeRJT1VE=;
        b=hc0dyx2BWXPDHZ2Cv3eLGv26muedOUQyAzg5KC+fOxqcZpzf/ERhA+cJbQJaoL/6r+wtkI
        4qDmD1J+9YSsxwMW9H06LL+jq29q6GHJNirA897QKFungwJx3v+4raZvhhTHc71XXDN0+o
        S2ADgQ9Ap1a66P5KlQPLheeQje3oMlY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-InrSeg5wPPWkJwUmlneCTQ-1; Fri, 04 Feb 2022 08:58:14 -0500
X-MC-Unique: InrSeg5wPPWkJwUmlneCTQ-1
Received: by mail-wr1-f69.google.com with SMTP id l22-20020adfa396000000b001d8e6467fe8so2054281wrb.6
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 05:58:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=PllD//4dUqneGZn34uKS0AY6GrlRGlNTYyXkeRJT1VE=;
        b=eCB4Yq34oQgQv++J2e9Ecbosc0kUCz7B/pA5vpjs/c8bSUcMwGJT/cG7AaR4OQbYiL
         tZ1XIlfwbVd4YcZNNUaYpaDIaPgitTBtSMs/J6N1ibRMgPbO/W9VyDzrIRvLilOduQ0T
         XkoBXM2NLELVxHsOuehJMov3R8s+dOWj5wL+OO6U1fqLhDc6LAkUlPRQ0t2sYrNh5qx1
         Ln6xmEU5TyShPlZnwRmZhTYUeuKOZ2zTsyIOqQMuH41Hcsdq53zUuHyGM4lTskPwTZVQ
         sxQPjvwYuQy5c14ZW/Pm2A7IyHnmztLMVUgZkRlLTbqNQldgzeyL5seNh/I2ypwzzUVF
         85Sg==
X-Gm-Message-State: AOAM533psr7z+eHay8LqwmZAezbcUCrYNMFN5BA5WCQYNPN0QVm8m7tq
        XNkQ1bdWdxgpXfoty3dqpbkc0UZPc6oPnuZNiNH77N8Lm3ZQqoHyR64FrwuwUv/CXY6ssHap0D7
        1UFbKvvhLivqcs777
X-Received: by 2002:a05:6000:25c:: with SMTP id m28mr2505740wrz.511.1643983093135;
        Fri, 04 Feb 2022 05:58:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzvWgx88FBLYJwVxCD0tSV+ahh+IyiHu+VjnVjTKy/n8tock/JycKmzf58BqQzVi2PvYy8Bzw==
X-Received: by 2002:a05:6000:25c:: with SMTP id m28mr2505731wrz.511.1643983092934;
        Fri, 04 Feb 2022 05:58:12 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id g9sm2167329wri.95.2022.02.04.05.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 05:58:12 -0800 (PST)
Date:   Fri, 4 Feb 2022 14:58:09 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Russell Strong <russell@strong.id.au>,
        Dave Taht <dave.taht@gmail.com>
Subject: [PATCH net-next 0/4] inet: Separate DSCP from ECN bits using new
 dscp_t type
Message-ID: <cover.1643981839.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The networking stack currently doesn't clearly distinguish between DSCP
and ECN bits. The entire DSCP+ECN bits are stored in u8 variables (or
structure fields), and each part of the stack handles them in their own
way, using different macros. This has created several bugs in the past
and some uncommon code paths are still unfixed.

Such bugs generally manifest by selecting invalid routes because of ECN
bits interfering with FIB routes and rules lookups (more details in the
LPC 2021 talk[1] and in the RFC of this series[2]).

This patch series aims at preventing the introduction of such bugs (and
detecting existing ones), by introducing a dscp_t type, representing
"sanitised" DSCP values (that is, with no ECN information), as opposed
to plain u8 values that contain both DSCP and ECN information. dscp_t
makes it clear for the reader what we're working on, and Sparse can
flag invalid interactions between dscp_t and plain u8.

This series converts only a few variables and structures:

  * Patch 1 converts the tclass field of struct fib6_rule. It
    effectively forbids the use of ECN bits in the tos/dsfield option
    of ip -6 rule. Rules now match packets solely based on their DSCP
    bits, so ECN doesn't influence the result any more. This contrasts
    with the previous behaviour where all 8 bits of the Traffic Class
    field were used. It is believed that this change is acceptable as
    matching ECN bits wasn't usable for IPv4, so only IPv6-only
    deployments could be depending on it. Also the previous behaviour
    made DSCP-based ip6-rules fail for packets with both a DSCP and an
    ECN mark, which is another reason why any such deploy is unlikely.

  * Patch 2 converts the tos field of struct fib4_rule. This one too
    effectively forbids defining ECN bits, this time in ip -4 rule.
    Before that, setting ECN bit 1 was accepted, while ECN bit 0 was
    rejected. But even when accepted, the rule would never match, as
    the packets would have their ECN bits cleared before doing the
    rule lookup.

  * Patch 3 converts the fc_tos field of struct fib_config. This is
    equivalent to patch 2, but for IPv4 routes. Routes using a
    tos/dsfield option with any ECN bit set is now rejected. Before
    this patch, they were accepted but, as with ip4 rules, these routes
    couldn't match any packet, since their ECN bits are cleared before
    the lookup.

  * Patch 4 converts the fa_tos field of struct fib_alias. This one is
    pure internal u8 to dscp_t conversion. While patches 1-3 had user
    facing consequences, this patch shouldn't have any side effect and
    is there to give an overview of what future conversion patches will
    look like. Conversions are quite mechanical, but imply some code
    churn, which is the price for the extra clarity a possibility of
    type checking.

To summarise, all the behaviour changes required for the dscp_t type
approach to work should be contained in patches 1-3. These changes are
edge cases of ip-route and ip-rule that don't currently work properly.
So they should be safe. Also, a kernel selftest is added for each of
them.

Finally, this work also paves the way for allowing the usage of the 3
high order DSCP bits in IPv4 (a few call paths already handle them, but
in general the stack clears them before IPv4 rule and route lookups).

References:
  [1] LPC 2021 talk:
        - https://linuxplumbersconf.org/event/11/contributions/943/
        - Direct link to slide deck:
            https://linuxplumbersconf.org/event/11/contributions/943/attachments/901/1780/inet_tos_lpc2021.pdf
  [2] RFC version of this series:
      - https://lore.kernel.org/netdev/cover.1638814614.git.gnault@redhat.com/

Changes since RFC:
  - Use simple mask instead of a bit shift to converting between u8
    and dscp_t (Toke).
  - Reword patch 4 to make it clear that no behaviour change is
    intended (Toke).
  - Add kernel selftests.
  - Rebase on latest net-next.

Guillaume Nault (4):
  ipv6: Define dscp_t and stop taking ECN bits into account in
    fib6-rules
  ipv4: Stop taking ECN bits into account in fib4-rules
  ipv4: Reject routes specifying ECN bits in rtm_tos
  ipv4: Use dscp_t in struct fib_alias

 include/net/inet_dscp.h                       | 57 ++++++++++++++
 include/net/ip_fib.h                          |  3 +-
 include/net/ipv6.h                            |  6 ++
 net/ipv4/fib_frontend.c                       | 11 ++-
 net/ipv4/fib_lookup.h                         |  3 +-
 net/ipv4/fib_rules.c                          | 18 +++--
 net/ipv4/fib_semantics.c                      | 14 ++--
 net/ipv4/fib_trie.c                           | 58 ++++++++------
 net/ipv4/route.c                              |  3 +-
 net/ipv6/fib6_rules.c                         | 19 +++--
 tools/testing/selftests/net/fib_rule_tests.sh | 60 ++++++++++++++-
 tools/testing/selftests/net/fib_tests.sh      | 76 +++++++++++++++++++
 12 files changed, 278 insertions(+), 50 deletions(-)
 create mode 100644 include/net/inet_dscp.h

-- 
2.21.3

