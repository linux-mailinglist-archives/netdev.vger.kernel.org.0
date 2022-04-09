Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347014FA6F0
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 13:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239974AbiDILG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiDILG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:06:57 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AFF23E3FA
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 04:04:50 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id u18so2017749eda.3
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 04:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9IipWlcL21uLDKcWxlDWy0bD+PCM4ppsm473BRxELzQ=;
        b=yVm732pr+7Rc8HCzyPkFvK7KZmPJ9hjLwHH19jaclrFSfiUUCB+E7P9YfaiFCKwO1Q
         oUoi5p0ej5eZ25mnWbSuhS5Wlklhe3KlCKQNwqnaYbuYLGv8D3d6mFSwQIIdyE64ED66
         LNd01CyigRgXJiiuiZWERLH4fpEYCklvhf1IZUEKMekoZD7hymWsd2s7EQHnMUQgU7qS
         lGg69Li7f/EHw8Qr9YhrpxpFtm5BrPdiexLKVUjlv/rialKDydRono5upsrRWznsvLG8
         7xyf7Se8JrS/lMa+KBuMq10Au9dlQ4q/gBIMsl0/SryTZwRZxcFDFoW7FKWp1TebXX3i
         mvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9IipWlcL21uLDKcWxlDWy0bD+PCM4ppsm473BRxELzQ=;
        b=AMD/W37llEKxGHppcxJYw+PQul8SPBwhIcmQdzRZVla/Me/1TxXSojM8YrGo/SApH/
         H/xOC14Kh68VUnX71SrV5kJ8RPDe7j7X/SouypC8oBWuEqRVauyD8270OVBD8JdVFS7x
         fzAVqWaZzQxuO6k1S6LfDWdCxJM1jqcf14Y2nuX3AxiCAaCUMfrFi2drJbNDyypWHrhk
         Keyxcl/i4Z470QQgHKmkYQZBGinjjIuN3CtUl2b7VDegdEARjFb178rSoDxxTUN/zjnx
         vGY2iLJcz1QNq5shyXnoFSO9js9SO2mkGsq4OWhLhNTlfNls4/agipplbd6muiOgNqfH
         LBCA==
X-Gm-Message-State: AOAM5323yWh+Q24BFPb1LGNBLcfgQCIM9b/nRo20IutNFVfzW67Dl9R1
        mN1N3hD0STMGCXRjsJrYVq/7gfaQNhYhOBCh8RY=
X-Google-Smtp-Source: ABdhPJxOwMDpQ4YHJfYKRsSvU2ldqF9FFsS/dbI/M4lQglQa083pyMLFZp/2LHtu9Ojn04lkeR2Srg==
X-Received: by 2002:a05:6402:2707:b0:419:5b7d:fd21 with SMTP id y7-20020a056402270700b004195b7dfd21mr23710656edd.51.1649502289095;
        Sat, 09 Apr 2022 04:04:49 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id r11-20020a1709064d0b00b006e87938318dsm179574eju.39.2022.04.09.04.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 04:04:48 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next 0/6] net: bridge: add flush filtering support
Date:   Sat,  9 Apr 2022 13:58:51 +0300
Message-Id: <20220409105857.803667-1-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This patch-set adds support to specify filtering conditions for a flush
operation. Initially only FDB flush filtering is added, later MDB
support will be added as well. Some user-space applications need a way
to delete only a specific set of entries, e.g. mlag implementations need
a way to flush only dynamic entries excluding externally learned ones
or only externally learned ones without static entries etc. Also apps
usually want to target only a specific vlan or port/vlan combination.
The current 2 flush operations (per port and bridge-wide) are not
extensible and cannot provide such filtering, so a new bridge af
attribute is added (IFLA_BRIDGE_FLUSH) which contains the filtering
information for each object type which has to be flushed.
An example structure for fdbs:
     [ IFLA_BRIDGE_FLUSH ]
      `[ BRIDGE_FDB_FLUSH ]
        `[ FDB_FLUSH_NDM_STATE ]
        `[ FDB_FLUSH_NDM_FLAGS ]

I decided against embedding these into the old flush attributes for
multiple reasons - proper error handling on unsupported attributes,
older kernels silently flushing all, need for a second mechanism to
signal that the attribute should be parsed (e.g. using boolopts),
special treatment for permanent entries.

Examples:
$ bridge fdb flush dev bridge vlan 100 static
< flush all static entries on vlan 100 >
$ bridge fdb flush dev bridge vlan 1 dynamic
< flush all dynamic entries on vlan 1 >
$ bridge fdb flush dev bridge port ens16 vlan 1 dynamic
< flush all dynamic entries on port ens16 and vlan 1 >
$ bridge fdb flush dev bridge nooffloaded nopermanent
< flush all non-offloaded and non-permanent entries >
$ bridge fdb flush dev bridge static noextern_learn
< flush all static entries which are not externally learned >
$ bridge fdb flush dev bridge permanent
< flush all permanent entries >

Note that all flags have their negated version (static vs nostatic etc)
and there are some tricky cases to handle like "static" which in flag
terms means fdbs that have NUD_NOARP but *not* NUD_PERMANENT, so the
mask matches on both but we need only NUD_NOARP to be set. That's
because permanent entries have both set so we can't just match on
NUD_NOARP. Also note that this flush operation doesn't treat permanent
entries in a special way (fdb_delete vs fdb_delete_local), it will
delete them regardless if any port is using them. We can extend the api
with a flag to do that if needed in the future.

Patches in this set:
 1. adds the new IFLA_BRIDGE_FLUSH bridge af attribute
 2. adds a basic structure to describe an fdb flush filter
 3. adds fdb netlink flush call via BRIDGE_FDB_FLUSH attribute
 4 - 6. add support for specifying various fdb fields to filter

Patch-sets (in order):
 - Initial flush infra and fdb flush filtering (this set)
 - iproute2 support
 - selftests

Future work:
 - mdb flush support

Thanks,
 Nik

Nikolay Aleksandrov (6):
  net: bridge: add a generic flush operation
  net: bridge: fdb: add support for fine-grained flushing
  net: bridge: fdb: add new nl attribute-based flush call
  net: bridge: fdb: add support for flush filtering based on ndm flags
    and state
  net: bridge: fdb: add support for flush filtering based on ifindex
  net: bridge: fdb: add support for flush filtering based on vlan id

 include/uapi/linux/if_bridge.h |  22 ++++++
 net/bridge/br_fdb.c            | 128 +++++++++++++++++++++++++++++++--
 net/bridge/br_netlink.c        |  59 ++++++++++++++-
 net/bridge/br_private.h        |  12 +++-
 net/bridge/br_sysfs_br.c       |   6 +-
 5 files changed, 215 insertions(+), 12 deletions(-)

-- 
2.35.1

