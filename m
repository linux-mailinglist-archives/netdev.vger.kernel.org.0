Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90374FBD58
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346546AbiDKNlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343598AbiDKNlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:41:09 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E4F21E15
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:38:54 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id t25so26676076lfg.7
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=KP4a5Nq5xLfHHBjrnafFha3MFdJr67mljPaP7U+xutA=;
        b=F1Dl0ogpPpEfisEpBYoUipD0dtHfWYZsL+vsWu36yEcuSnNWht4iB9T1IjrVDNe+oA
         wmM7GmbVwYTm+tzx12ALZ9nrfvLtBsh1cOkktEHvS7YhbjL+YtND53Wgg7IEe9rsOvvv
         LDdhVTta2Xu2Z4RDG0OmzHfuryBWnrogT1WHfoxfXTYa4IyIinbz5uRNw1QEvQQX3N9q
         KZyOPbrJhJHwxIcO/SHOqZbCCdW5rLHrJ5hK8bi2WMvc3wb+EYhaHhDl/2r7ylQc5MRH
         T57oax7TN3zqjTm/2bp6gct/420puw8j5X9LGnYpCmhF/vb9aF+XK2II+IJ15KhsSR7a
         oaDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=KP4a5Nq5xLfHHBjrnafFha3MFdJr67mljPaP7U+xutA=;
        b=FuwtnWFg7Vg3hyzinJHIFqtU/2IkQFRnZdexts/AV7y+4vASvMER5DyMg6xtebx2RR
         q3BzNBwW5u5ssDLx5gINioED8Jgt6PFVfmojKqIDwii19V8xS2YbssB3kdoPxa++pcHw
         vtz9G0blKidfP0dvYWKZsGrU/gGvTdaRG4/aluUNonQ10Grs9AZtRgyGWFBpyVxDU2dP
         1Pgqh1Jrolbi0Fj6gqBbUy4iWXCnuSVg1zhsqrozh8ELctdRo4+ZiR+c4RbRCdWVrYew
         gJPkHxzEnz2ZYtHHjFxep2QvYz7DF0gVVrlkYsvntuKoegyCE3auoUCsV9vGkxvkJX68
         oXJA==
X-Gm-Message-State: AOAM531dPB5XguTZUpEP8ES3FTQzdjIVH99aaPcqhxhMS5uAhkP0EvDL
        N1sbAVQEMCsxv6eBkd9s/eg=
X-Google-Smtp-Source: ABdhPJxLZjiseNnsvsyE9ERiXNC4Cju5eMhw1wxqy7+WLlloblSPYHmdBFXjkMsYrYZKCRsxH49ztw==
X-Received: by 2002:a05:6512:3b8:b0:46b:a79a:3686 with SMTP id v24-20020a05651203b800b0046ba79a3686mr2944539lfp.350.1649684332221;
        Mon, 11 Apr 2022 06:38:52 -0700 (PDT)
Received: from wbg.labs.westermo.se (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id p12-20020a056512138c00b0044833f1cd85sm3336847lfa.62.2022.04.11.06.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:38:51 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC net-next 00/13] net: bridge: forwarding of unknown IPv4/IPv6/MAC BUM traffic
Date:   Mon, 11 Apr 2022 15:38:24 +0200
Message-Id: <20220411133837.318876-1-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a proposal to improve forwarding control of BUM traffic to the
bridge itself.  Another, related, issue regarding loss of function when
an IP multicast router is detected, is also brought up here which can be
a separate series in v2.

First, we add BROPT_BCAST_FLOOD, BROPT_UNICAST_FLOOD, BROPT_MCAST_FLOOD
flags for unknown traffic to the bridge itself, with netlink support and
a selftest.  We ensure backwards compatible forwarding behavior is
preserved by enabling these flags by default.  Please note however,
these flags do not affect the behavior of IFF_PROMISC on the bridge
interface.

Second, and with the above in place, we set out to verify flooding of
unknown *and* known multicast to regular bridge ports, including the
bridge itself.  We use `tcpdump -p` in the tests to ensure we do not
trigger IFF_PROIMISC.  Unknown multicast should be forwarded according
to the MCAST_FLOOD flag, and known multicast according the MDB and to
multicast router ports.

We find that forwarding of unknown IP multicast stops[1] as soon as a
multicast router is known.  Affecting all ports, including the bridge
itself (this series).  The root cause for this is the classification
`mrouters_only` in br_multicast_rcv().

Dropping this classification of unknown IP multicast and moving the
multicast flow handling from br_multicast_flood() to br_flood() fixes
this problem.  The bridge now properly floods all unknown multicast, and
this can now be controlled using the MCAST_FLOOD flag on all ports
including the bridge itself.

The use of br_flood() opens up the need for the multicast 'rport' API,
but that is behind CONFIG_BRIDGE_IGMP_SNOOPING, which is the primary
reason for this being an RFC series.  I'd love some feedback on how to
go about all this, opening up that API and even the take on the issue as
a whole.

Honestly, despite taking great care to not change the bridge's default
behavior the patch series in itself propose quite radical changes that
alone mandate RFC status at this point.  There has been some discussion
already on this in 20220410220324.4c3l3idubwi3w6if@skbuf and I expect
more disucssion here.

Note: this series builds upon my previous patch for host l2 mdb entries,
      20220411084054.298807-1-troglobit@gmail.com, extending the test
      bridge_mdb.sh

Best regards
 /Joachim

[1]: MAC multicast is not affected.

net/bridge/br_device.c                        |   4 +
 net/bridge/br_forward.c                       |  11 +
 net/bridge/br_input.c                         |  11 +-
 net/bridge/br_multicast.c                     |   6 +-
 net/bridge/br_netlink.c                       | 170 +++++++---
 net/bridge/br_private.h                       |   7 +-
 net/bridge/br_switchdev.c                     |   8 +-
 net/bridge/br_sysfs_if.c                      |   2 +-
 .../drivers/net/ocelot/tc_flower_chains.sh    |  24 +-
 .../testing/selftests/net/forwarding/Makefile |   3 +-
 .../selftests/net/forwarding/bridge_flood.sh  | 170 ++++++++++
 .../selftests/net/forwarding/bridge_mdb.sh    | 321 +++++++++++++++++-
 tools/testing/selftests/net/forwarding/lib.sh |  33 +-
 13 files changed, 683 insertions(+), 87 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_flood.sh
 mode change 100644 => 100755 tools/testing/selftests/net/forwarding/lib.sh
