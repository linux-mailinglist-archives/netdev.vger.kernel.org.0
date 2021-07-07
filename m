Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAEC3BE42D
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 10:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhGGIS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 04:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGGIS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 04:18:59 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568C2C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 01:16:18 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t9so1435477pgn.4
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 01:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5tR/o3/NLK0dRyuu757qsHSZHI8/DaAVKjJu1n5u8pg=;
        b=jatEtj5EDt2YcKd52ZMRulsXq50HVlaFVMqKY3idw0WH3xdwnnY+vo8v9MGFkRlYEE
         21sSFWG6R9ru+/zEV2IdXgHBTLo2m/vjl0GUkpOOqL6iwxf4+N6V00PZRy06bNy1ws6Q
         6TcH+LpOzG0rbpfE7YfuTyhO7EqZH3MgTtCK0g9gh5N8pP/5m2PuBBc3dGIgK1YQ44WV
         gOoO1vWn0bfXqEEd0YYyxz+0Du6rbZuzhEDQxL4aS+QnZYet6dhggiuzwTied8BQvxbg
         MaS07a5DqAW36PPUVuMXE1dzlGhPPECplQDAu5A8wRn22j9Ig8VV0ggxn2caNxhTUbwc
         +4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5tR/o3/NLK0dRyuu757qsHSZHI8/DaAVKjJu1n5u8pg=;
        b=ECXQQplB5oWxiSebr2MMCnMg73QjRP7EKsjZPeLUlwUL8/WBLpJ42tbwSVzNCu8WLc
         ITumSfEMDVduUebVs6VZDSoNwORuDobuOsYRpxlI0T+EvXgQ1VFZgP/yffbWdPe0magq
         HOgCgVTuTQtFv7wOdpBlxFhZRUd/f8BEV5UXB2YaIzwmxCx0lZobwzeLlh5zhHrV5TZP
         eLQRHHZm3rJ7HXBrPS3wBWrF9ZmuhfiqIM8g1IwHvGfNRE3ej/dJFjTFcm3IC6gvVAvh
         oIIKtKjHWUS9bBSEKoG8vxGanS3Z9LRmxQmyHc5pbA+1yjhfuKC43D/eEmKJUMmdUYs7
         BQow==
X-Gm-Message-State: AOAM5316xmVKYNcPFjxnqF+ZxOCzoTLG4f4z7os4pV04yTQmK6ggaZF+
        2fHF9ViC5yWyGDPhPy6Ic/oruKz3EcRlAw5u
X-Google-Smtp-Source: ABdhPJz9eRNp57kmtov+D+Jfd1L9Y9iQBAKhda5VeR/rfUG2fgfaPRTNQAn5aPGMJ40aL7grNUUhvQ==
X-Received: by 2002:a63:515f:: with SMTP id r31mr24820067pgl.406.1625645777698;
        Wed, 07 Jul 2021 01:16:17 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u40sm15476365pfg.19.2021.07.07.01.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 01:16:17 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 0/2] Fix selftests icmp_redirect.sh failures
Date:   Wed,  7 Jul 2021 16:15:28 +0800
Message-Id: <20210707081530.1107289-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes 2 failures for selftests icmp_redirect.sh.

The first patch is for IPv6 redirecting tests. When disable option
CONFIG_IPV6_SUBTREES, there is not "from ::" info in ip route output.
So we should not check this key word.

The second patch is for testing "mtu exception plus redirect", which do
a PMTU update first and do redirect second. For topology like

                         (MTU 1300)
       |----- R1_1 -------- R1_2 --------|
H1  ---|                                 | ---- H2 (MTU 1500)
       |----- R2_1 -------- R2_2 --------|

After redirecting to R2 patch, the PMTU info in R1 path should be cleard.
So we should not check PMTU info for test "mtu exception plus redirect".

After the fixes, all the test passed now

]# ./icmp_redirect.sh

###########################################################################
Legacy routing
###########################################################################

TEST: IPv4: redirect exception                                      [ OK ]
TEST: IPv6: redirect exception                                      [ OK ]
TEST: IPv4: redirect exception plus mtu                             [ OK ]
TEST: IPv6: redirect exception plus mtu                             [ OK ]
TEST: IPv4: routing reset                                           [ OK ]
TEST: IPv6: routing reset                                           [ OK ]
TEST: IPv4: mtu exception                                           [ OK ]
TEST: IPv6: mtu exception                                           [ OK ]
TEST: IPv4: mtu exception plus redirect                             [ OK ]
TEST: IPv6: mtu exception plus redirect                             [ OK ]

[...]

###########################################################################
Routing with nexthop objects and VRF
###########################################################################

TEST: IPv4: redirect exception                                      [ OK ]
TEST: IPv6: redirect exception                                      [ OK ]
TEST: IPv4: redirect exception plus mtu                             [ OK ]
TEST: IPv6: redirect exception plus mtu                             [ OK ]
TEST: IPv4: routing reset                                           [ OK ]
TEST: IPv6: routing reset                                           [ OK ]
TEST: IPv4: mtu exception                                           [ OK ]
TEST: IPv6: mtu exception                                           [ OK ]
TEST: IPv4: mtu exception plus redirect                             [ OK ]
TEST: IPv6: mtu exception plus redirect                             [ OK ]

Tests passed:  40
Tests failed:   0
Tests xfailed:   0

Hangbin Liu (2):
  selftests: icmp_redirect: remove from checking for IPv6 route get
  selftests: icmp_redirect: IPv6 PMTU info should be cleared after
    redirect

 tools/testing/selftests/net/icmp_redirect.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.31.1

