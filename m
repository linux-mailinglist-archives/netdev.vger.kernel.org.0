Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D0645DC0F
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355654AbhKYOO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349711AbhKYOM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:12:26 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAE5C06173E
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:15 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z5so26315560edd.3
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gBPQNvEnJJLckxCSGc4J1L8KyXXtbTMRUV/7fFvFRTE=;
        b=tUh/OpvG7z1rjD7dxAfgfm1IICN1lrCRRj/ZQfgIIB/2U8cf7uPLBiusc412bdcK0+
         XeQkPBcLgEmqVIaFlewufk1pI0ldkn4GtbqJH/qTRXbMm6OCpOTUjYP8cYclPqhT6LTs
         f6sK2aO8xQsGoFciaI1XV6gkvkxMc1R5j39wXpj7jcphJBchGEDD+XLuLWlyq9D13zxs
         c63PstJyt49FcQWI8Ewv0PN3/4tbSowgAtwTLnDKW2XztthDsha5+q6VRnTgHEGVShR+
         HdA3YHrpLs1vdb+G83LwfLTnc6pW4PwGk1GlxKZZbA5K/sezuLOgI7rGGtx8zF21YwYx
         WDGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gBPQNvEnJJLckxCSGc4J1L8KyXXtbTMRUV/7fFvFRTE=;
        b=d/j3eaBQbNnMElzmDKpUTydeGql74vF2phzaaox6sZkfacuLzJDdBL67gwAkVbJIdL
         Huz5ld5RGVUN6+QYrF3GNB6Zbdien6ZD34lqCz8sSxr8w39zP5jhcnuKLXKLq6E+BmLk
         kC2o3zS8lYBimNefNs+QzCssqzHN6ze8kdN25HT3p44h0hbAEXBnhpfaSKQahZwnMoaS
         9Du42cYy/hLPNVs4KgAoGveH50MkJTuyQd+pD7tKGfnrbpU2GTx3lVzp/TbG4WyLVPZo
         DBFBTro2WMAzV/u+ArGKTA1knDSWeqdvqoan3x095rc7wM6VmzZvS8QrpQWvVORwxXIK
         hXmQ==
X-Gm-Message-State: AOAM533nJR0vuKmRtIIMPurEfg7FsjQG3fOmJ2YzPK2EqMzq5Mm08xKM
        m+xCykKShQW0RvlnX6ONC/Kwc2Ql5xVLUFuK
X-Google-Smtp-Source: ABdhPJxtzljFWtJbmwjKGq0+TnPcIMH50jUxSx4pgGj6rStfSLc61ZKboN0ua317zV3hJo63HStbGw==
X-Received: by 2002:a17:907:7da8:: with SMTP id oz40mr31378937ejc.105.1637849353806;
        Thu, 25 Nov 2021 06:09:13 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id sc7sm1889863ejc.50.2021.11.25.06.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 06:09:13 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, ivecera@redhat.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 00/10] selftests: net: bridge: vlan multicast tests
Date:   Thu, 25 Nov 2021 16:08:48 +0200
Message-Id: <20211125140858.3639139-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This patch-set adds selftests for the new vlan multicast options that
were recently added. Most of the tests check for default values,
changing options and try to verify that the changes actually take
effect. The last test checks if the dependency between vlan_filtering
and mcast_vlan_snooping holds. The rest are pretty self-explanatory.

TEST: Vlan multicast snooping enable                                [ OK ]
TEST: Vlan global options existence                                 [ OK ]
TEST: Vlan mcast_snooping global option default value               [ OK ]
TEST: Vlan 10 multicast snooping control                            [ OK ]
TEST: Vlan mcast_querier global option default value                [ OK ]
TEST: Vlan 10 multicast querier enable                              [ OK ]
TEST: Vlan 10 tagged IGMPv2 general query sent                      [ OK ]
TEST: Vlan 10 tagged MLD general query sent                         [ OK ]
TEST: Vlan mcast_igmp_version global option default value           [ OK ]
TEST: Vlan mcast_mld_version global option default value            [ OK ]
TEST: Vlan 10 mcast_igmp_version option changed to 3                [ OK ]
TEST: Vlan 10 tagged IGMPv3 general query sent                      [ OK ]
TEST: Vlan 10 mcast_mld_version option changed to 2                 [ OK ]
TEST: Vlan 10 tagged MLDv2 general query sent                       [ OK ]
TEST: Vlan mcast_last_member_count global option default value      [ OK ]
TEST: Vlan mcast_last_member_interval global option default value   [ OK ]
TEST: Vlan 10 mcast_last_member_count option changed to 3           [ OK ]
TEST: Vlan 10 mcast_last_member_interval option changed to 200      [ OK ]
TEST: Vlan mcast_startup_query_interval global option default value   [ OK ]
TEST: Vlan mcast_startup_query_count global option default value    [ OK ]
TEST: Vlan 10 mcast_startup_query_interval option changed to 100    [ OK ]
TEST: Vlan 10 mcast_startup_query_count option changed to 3         [ OK ]
TEST: Vlan mcast_membership_interval global option default value    [ OK ]
TEST: Vlan 10 mcast_membership_interval option changed to 200       [ OK ]
TEST: Vlan 10 mcast_membership_interval mdb entry expire            [ OK ]
TEST: Vlan mcast_querier_interval global option default value       [ OK ]
TEST: Vlan 10 mcast_querier_interval option changed to 100          [ OK ]
TEST: Vlan 10 mcast_querier_interval expire after outside query     [ OK ]
TEST: Vlan mcast_query_interval global option default value         [ OK ]
TEST: Vlan 10 mcast_query_interval option changed to 200            [ OK ]
TEST: Vlan mcast_query_response_interval global option default value   [ OK ]
TEST: Vlan 10 mcast_query_response_interval option changed to 200   [ OK ]
TEST: Port vlan 10 option mcast_router default value                [ OK ]
TEST: Port vlan 10 mcast_router option changed to 2                 [ OK ]
TEST: Flood unknown vlan multicast packets to router port only      [ OK ]
TEST: Disable multicast vlan snooping when vlan filtering is disabled   [ OK ]

Thanks,
 Nik

Nikolay Aleksandrov (10):
  selftests: net: bridge: add vlan mcast snooping control test
  selftests: net: bridge: add vlan mcast querier test
  selftests: net: bridge: add vlan mcast igmp/mld version tests
  selftests: net: bridge: add vlan mcast_last_member_count/interval
    tests
  selftests: net: bridge: add vlan mcast_startup_query_count/interval
    tests
  selftests: net: bridge: add vlan mcast_membership_interval test
  selftests: net: bridge: add vlan mcast_querier_interval tests
  selftests: net: bridge: add vlan mcast query and query response
    interval tests
  selftests: net: bridge: add vlan mcast_router tests
  selftests: net: bridge: add test for vlan_filtering dependency

 .../net/forwarding/bridge_vlan_mcast.sh       | 543 ++++++++++++++++++
 1 file changed, 543 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh

-- 
2.31.1

