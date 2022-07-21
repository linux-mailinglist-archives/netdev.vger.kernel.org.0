Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8668357CC34
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiGUNnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiGUNmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:42:55 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E787A820C3;
        Thu, 21 Jul 2022 06:42:50 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h9so2382307wrm.0;
        Thu, 21 Jul 2022 06:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lwvps79KHy7KtNwizeez/x07YLJTzOBA86WUP3rssec=;
        b=C8Zdxg5er8MUPNN9oQiV3qXhfuJ5hYaUTQGmoR0lUVY4fXPDKonsTKS8YjJxbgoEWR
         Jb9VRF2CvWBWccr3kEf21h5OJEM3pDQ2ozIRsYoX3bQ4eIhHou23cwSzZRTMoVdmql+A
         GtIsvt861XpM5hBJ7mIaB/84bATU/SiuRFz/NOWEpslSJi7O/LevCogNk2Kxtt0TTOeM
         nWrCxqKqu8wcfrK+UXbFVibsFZsEvlMzxtooVCvWJ7sqfsXm2EP+6kfpiyC49mPCnN9T
         aaeFd9zrBTXo3EpwH26S5GuwMMifk6Y6RTG77nRnOmfCx0iVxGNTl41OjfoqJ/yDwJCj
         H7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lwvps79KHy7KtNwizeez/x07YLJTzOBA86WUP3rssec=;
        b=OzPsqTscsZPcPK83t8uHCsc/3VroTEgs9RJVXQfmBMELm5rpWWePED799Orm9EwnqG
         nX2yTBV2f5liFz3e7ssYmwWAEraN/WMYMwGCbgpnMu14NCd78CaRHbnXr65EVYtnjKur
         aJ2VmCavs3q6LpCcGG0FOdR10ytvGPtOeCW6UIT3lmxjjO/4iMcf0Zb3W3eP2AE42BB9
         21WLv3Mn/NiFylwo+UHKXq1Jv4/cBpuYTr55nOQyJNe/hZOZXy7Dyg+Gg580V6s6i8xP
         Y7LDL5ZJa6xcdeWMzD6z3VUZK6S9oe10RaDWnw3vlqr084QgKvqXcT8yrWZablJyVKyI
         yeDw==
X-Gm-Message-State: AJIora/dc3MYR3fmwOZTnjiUdVM/gbefUweivnNt0qKxAD6/RXFTBebt
        pTfQUr8c5xbjZFhh6hQwFu1Iyh8FehXflQ==
X-Google-Smtp-Source: AGRyM1syeWeyZz6c/Nf6eP86lznLszZWeVFyQPp8kbzWXcccS8fYoFr+IAphnHeM+y7H8usW/oNrQg==
X-Received: by 2002:a05:6000:886:b0:21e:2786:4145 with SMTP id ca6-20020a056000088600b0021e27864145mr13472071wrb.541.1658410968334;
        Thu, 21 Jul 2022 06:42:48 -0700 (PDT)
Received: from localhost (212.191.202.62.dynamic.cgnat.res.cust.swisscom.ch. [62.202.191.212])
        by smtp.gmail.com with ESMTPSA id o8-20020a05600c378800b003a2e7c13a3asm1791349wmr.42.2022.07.21.06.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:42:47 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v7 00/13] New nf_conntrack kfuncs for insertion, changing timeout, status
Date:   Thu, 21 Jul 2022 15:42:32 +0200
Message-Id: <20220721134245.2450-1-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4703; i=memxor@gmail.com; h=from:subject; bh=6NY4iFk7x2B7UPaLQA3xE204dN1Rh6iBPE59zmuigpE=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi2VfNFMuugN7XXj2+oHdXc86aKpJCdHOaI2vF7Atf t/wrJ4qJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtlXzQAKCRBM4MiGSL8RygJID/ 4pkixRRBpzunPIrOmcjwiKFD/QBXrs44yj8p7tOBxXWN35Dxwd2DsZLAbL1IDutnO5A2BFxPqdD2CY NDgSNIlC/EiGePnXk9yUUmUOMQn8FwtFlGREvRf0k36mFU+jLdXbw7YeyI+DWQ6RPm29grvF5QZU4C n8lhp4O+00YLKbwuAkqFqkRQPpwX1LMgsKRVIG7sPp0QDH/oJFMFkFhNQJAoyii9gqR8WM9kpcTnAC jmokD+7KH0CrcPsLiHuhKqI50TcssduYNg4bQYJpST2xh+Be4OATxQ0zrGK8NPfFJEJzlxtEyMBRSe GxrGQOS6kvyh3e2unUCqWJ0b2MGlfxtnQelj0QlG3wNHbXnBhls4gEhlSyWFDmBMXf2fYeTYJJkCyb EqpVRCn25qhndyPT8DHx6j1iybeL8eS1/NwDBf07SPiymc7VELrM9w2yAKIp/ZEXN1gJ0qp2wKbaFk O75Zxmb/5JBSVPyIZgDKPEe6nLRGZ0HJ/DTDqAzjqahO96AOHyaHj1jnYI9U/glhqLBTSn6X89fEOQ FYVQylf7ozGiaCuajeMwzAWFn2NqwsYYQUcdZUIyBPN8s/sPIT53HULdCwKy40btUBwaC7hF+cPDnq paX8XNVfkZGsUx+ngx2dFpNy/rzC9fABdJGDAL082yF/cgPMJj20Ta/yR1zA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
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

Introduce the following new kfuncs:
 - bpf_{xdp,skb}_ct_alloc
 - bpf_ct_insert_entry
 - bpf_ct_{set,change}_timeout
 - bpf_ct_{set,change}_status

The setting of timeout and status on allocated or inserted/looked up CT
is same as the ctnetlink interface, hence code is refactored and shared
with the kfuncs. It is ensured allocated CT cannot be passed to kfuncs
that expected inserted CT, and vice versa. Please see individual patches
for details.

Changelog:
----------
v6 -> v7:
v6: https://lore.kernel.org/bpf/20220719132430.19993-1-memxor@gmail.com

 * Use .long to encode flags (Alexei)
 * Fix description of KF_RET_NULL in documentation (Toke)

v5 -> v6:
v5: https://lore.kernel.org/bpf/20220623192637.3866852-1-memxor@gmail.com

 * Introduce kfunc flags, rework verifier to work with them
 * Add documentation for kfuncs
 * Add comment explaining TRUSTED_ARGS kfunc flag (Alexei)
 * Fix missing offset check for trusted arguments (Alexei)
 * Change nf_conntrack test minimum delta value to 8

v4 -> v5:
v4: https://lore.kernel.org/bpf/cover.1653600577.git.lorenzo@kernel.org

 * Drop read-only PTR_TO_BTF_ID approach, use struct nf_conn___init (Alexei)
 * Drop acquire release pair code that is no longer required (Alexei)
 * Disable writes into nf_conn, use dedicated helpers (Florian, Alexei)
 * Refactor and share ctnetlink code for setting timeout and status
 * Do strict type matching on finding __ref suffix on argument to
   prevent passing nf_conn___init as nf_conn (offset = 0, match on walk)
 * Remove bpf_ct_opts parameter from bpf_ct_insert_entry
 * Update selftests for new additions, add more negative tests

v3 -> v4:
v3: https://lore.kernel.org/bpf/cover.1652870182.git.lorenzo@kernel.org

 * split bpf_xdp_ct_add in bpf_xdp_ct_alloc/bpf_skb_ct_alloc and
   bpf_ct_insert_entry
 * add verifier code to properly populate/configure ct entry
 * improve selftests

v2 -> v3:
v2: https://lore.kernel.org/bpf/cover.1652372970.git.lorenzo@kernel.org

 * add bpf_xdp_ct_add and bpf_ct_refresh_timeout kfunc helpers
 * remove conntrack dependency from selftests
 * add support for forcing kfunc args to be referenced and related selftests

v1 -> v2:
v1: https://lore.kernel.org/bpf/1327f8f5696ff2bc60400e8f3b79047914ccc837.1651595019.git.lorenzo@kernel.org

 * add bpf_ct_refresh_timeout kfunc selftest

Kumar Kartikeya Dwivedi (10):
  bpf: Introduce 8-byte BTF set
  tools/resolve_btfids: Add support for 8-byte BTF sets
  bpf: Switch to new kfunc flags infrastructure
  bpf: Add support for forcing kfunc args to be trusted
  bpf: Add documentation for kfuncs
  net: netfilter: Deduplicate code in bpf_{xdp,skb}_ct_lookup
  net: netfilter: Add kfuncs to set and change CT timeout
  selftests/bpf: Add verifier tests for trusted kfunc args
  selftests/bpf: Add negative tests for new nf_conntrack kfuncs
  selftests/bpf: Fix test_verifier failed test in unprivileged mode

Lorenzo Bianconi (3):
  net: netfilter: Add kfuncs to allocate and insert CT
  net: netfilter: Add kfuncs to set and change CT status
  selftests/bpf: Add tests for new nf_conntrack kfuncs

 Documentation/bpf/index.rst                   |   1 +
 Documentation/bpf/kfuncs.rst                  | 170 ++++++++
 include/linux/bpf.h                           |   3 +-
 include/linux/btf.h                           |  65 ++--
 include/linux/btf_ids.h                       |  68 +++-
 include/net/netfilter/nf_conntrack_core.h     |  19 +
 kernel/bpf/btf.c                              | 123 +++---
 kernel/bpf/verifier.c                         |  14 +-
 net/bpf/test_run.c                            |  75 ++--
 net/ipv4/bpf_tcp_ca.c                         |  18 +-
 net/ipv4/tcp_bbr.c                            |  24 +-
 net/ipv4/tcp_cubic.c                          |  20 +-
 net/ipv4/tcp_dctcp.c                          |  20 +-
 net/netfilter/nf_conntrack_bpf.c              | 365 +++++++++++++-----
 net/netfilter/nf_conntrack_core.c             |  62 +++
 net/netfilter/nf_conntrack_netlink.c          |  54 +--
 tools/bpf/resolve_btfids/main.c               |  40 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  10 +-
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  64 ++-
 .../testing/selftests/bpf/progs/test_bpf_nf.c |  85 +++-
 .../selftests/bpf/progs/test_bpf_nf_fail.c    | 134 +++++++
 .../selftests/bpf/verifier/bpf_loop_inline.c  |   1 +
 tools/testing/selftests/bpf/verifier/calls.c  |  53 +++
 23 files changed, 1139 insertions(+), 349 deletions(-)
 create mode 100644 Documentation/bpf/kfuncs.rst
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c

-- 
2.34.1

