Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED80F5BA523
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 05:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiIPDei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 23:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIPDeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 23:34:36 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE7060D7
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 20:34:35 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id k21so9692221pls.11
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 20:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=mKp6vF1NZIbCw4N3WYQvNYURJduoY67zBR51tNDQOtE=;
        b=K6S5IlyzWLlGZ3t+BNc5Mu4C01vHz6OWvFHyJQw/xEWdkXjiv5+cTwcLkJAiwSTbG8
         4lHYUIsUd/c+Z0yUL4D16SO+r/xDD0PNDB3SvyLD9JP4rwLySl/fD+7k+yKKJkFVUfAE
         wahSPberIjK/k/O/GbHIBRMqz7QgrgkzC6QxvVH3Pe2tWgC0vqjj0zPotJF5KkyulaCL
         tikwIIb1Sxk6+BCgGf1UOgBUKz22cm34HlBrXQwNBuzCyGeoNgHGVSfUdEvY5b2OZ/4n
         jnEI4hrSlkgnZuMrJj7qQLmOg/fbXTvAO63dL08Awy7wJNZwQ8d2zVc9770hloBfgAb5
         oJVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=mKp6vF1NZIbCw4N3WYQvNYURJduoY67zBR51tNDQOtE=;
        b=Jcc82+XbijNn/ldmDDNWasqDV62Z17eX3jZ2xAXer6NEn0MkJdcwjk60GUx4bjWHRO
         oAvtq+eGydONKAeTNl56NFg8KB5KHKMX0c5BKpwOdUsnRnrSkncEsySohaUDFUsLgFO2
         R+/D7PPXKi4At9xthNC0krv9QY4asU4GGw2Nzg7dPQKs/ckJWvNfRd5RFsrTrxbZONRR
         TeE7cYCUibTiv08LFbKSqF4XsyPx5XXEWm7n6fJjFf4LehIJnPu98/+q5lp5I3zHW4z8
         Q2nFyIHOWaIToBxuWk9rnBEvHYcNK/coUL7W/5/OwnOLCzoSgU7pHBoXzWAKhcMIX+YV
         2tLQ==
X-Gm-Message-State: ACrzQf2MENCCRG/Hw6yJAsB7oqL4gvGoNqPuuuWDoYRxSGC6PiOkv1ci
        jx46bOj4CjDB7Rs3SzYQNUGBSvavcnaNGQ==
X-Google-Smtp-Source: AMsMyM4KovNTQU6B3OMuiQJ6+jIEoQYy1MlRaWyaacLhTidpgOEDzhluv8npj62oaYhHqhtWZpWvTw==
X-Received: by 2002:a17:90b:3ec1:b0:202:f490:e508 with SMTP id rm1-20020a17090b3ec100b00202f490e508mr3285974pjb.156.1663299274450;
        Thu, 15 Sep 2022 20:34:34 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 2-20020a621902000000b0054aa69bc192sm437885pfz.72.2022.09.15.20.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 20:34:34 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2-next 0/1] ip: add NLM_F_ECHO support
Date:   Fri, 16 Sep 2022 11:34:27 +0800
Message-Id: <20220916033428.400131-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Hi,

As the patch did, here I just pust the test result for each commands

# ip -echo addr add 192.168.0.1/24 dev eth1
3: eth1    inet 192.168.0.1/24 scope global eth1
       valid_lft forever preferred_lft forever
# ip -j -p -echo addr del 192.168.0.1/24 dev eth1
[ {
        "deleted": true,
        "index": 3,
        "dev": "eth1",
        "family": "inet",
        "local": "192.168.0.1",
        "prefixlen": 24,
        "scope": "global",
        "label": "eth1",
        "valid_life_time": 4294967295,
        "preferred_life_time": 4294967295
    } ]
# ip -o -echo addr add 192.168.0.1/24 dev eth1
3: eth1    inet 192.168.0.1/24 scope global eth1\       valid_lft forever preferred_lft forever
# ip -br -echo addr del 192.168.0.1/24 dev eth1
Deleted 192.168.0.1/24

# ip -echo nexthop add id 1 via 192.168.0.254 dev eth1
id 1 via 192.168.0.254 dev eth1 scope link
# ip -j -p -echo nexthop del id 1
[ {{
            "deleted": true,
            "id": 1,
            "gateway": "192.168.0.254",
            "dev": "eth1",
            "scope": "link",
            "flags": [ ]
        }
    } ]

# ip -echo -6 route add 2022::1/64 via 2000::254 dev eth1
2022::/64 via 2000::254 dev eth1 metric 1024 pref medium
# ip -j -p -echo -6 route del 2022::1/64 via 2000::254 dev eth1
[ {{
            "deleted": true,
            "dst": "2022::/64",
            "gateway": "2000::254",
            "dev": "eth1",
            "metric": 1024,
            "flags": [ ],
            "pref": "medium"
        }
    } ]

# ip -echo rule add from 192.168.1.10 table 10
32765:  from 192.168.1.10 lookup 10
# ip -j -p -echo rule del table 10
[ {{
            "deleted": true,
            "priority": 32765,
            "src": "192.168.1.10",
            "table": "10"
        }
    } ]

# test if the cmd doesn't support -echo
# ip -echo neigh add 192.168.0.2 dev eth1 lladdr 00:00:00:00:00:01
# ip -echo neigh del 192.168.0.2 dev eth1 lladdr 00:00:00:00:00:01

Hangbin Liu (1):
  ip: add NLM_F_ECHO support

 include/utils.h |  1 +
 ip/ip.c         |  3 +++
 ip/ipaddress.c  | 23 +++++++++++++++++++++--
 ip/iplink.c     | 20 +++++++++++++++++++-
 ip/ipnexthop.c  | 21 ++++++++++++++++++++-
 ip/iproute.c    | 21 ++++++++++++++++++++-
 ip/iprule.c     | 21 ++++++++++++++++++++-
 man/man8/ip.8   |  4 ++++
 8 files changed, 108 insertions(+), 6 deletions(-)

-- 
2.37.2

