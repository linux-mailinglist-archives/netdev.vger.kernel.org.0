Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23ABD41C86E
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345315AbhI2Pbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345318AbhI2Pbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:31:42 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA93AC061766
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:30:00 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id v18so10021816edc.11
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RORmnbMamSWP20gxhIBLtuOROhna0ytkGWjrtiRS5iw=;
        b=wiUIOKfegn/6CoTa+63SQoaTWUzzjp/EHE80mg51JbbpZfYhRSr4jQgMBMirTOWyh5
         7Lt6nGG68eyabCgj8OQN10hapyXpCXMgtejQ2ncmb0KMHprJlynsGOh4JLl3R4IGTVd2
         JGcM8+FAjehSHhkyw2uRRMot/Sa1FsvwfFmsXWRlDfIhUskbcFo+W3faSeAnZeDLm2Jr
         kkk1EjdhLfD6f2urltrfb5ibKw/GLM4i7tKILVwgAexWFqKE4KF0PY195YOYNCbbXqkp
         NnClZHHra0zYdWU5PlpWpBV/FckkscQe9PcqebbV+7nFOfPpgy5ZnyJxgxbkolB6k+qD
         SuIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RORmnbMamSWP20gxhIBLtuOROhna0ytkGWjrtiRS5iw=;
        b=J7qEQAnJX+h8XuAFAS7GXaqQ18pyLzc2qcz/KGIYTtTolJwPhjpOQ+E4E43Utu/Zir
         9eCmyPynfAwyiv51gQoz6CgHiseNiXNpKGdA412IRqX5j0beJ8bt+rJlHPQg/kjutR9r
         JG243KLwcmuQJNYY1Awxg/egNaoBOO6QkBjzfE6R5bjjPgk7wwr0z8K7EU7smVSPcmd1
         Azro3Au5x+yBLAApOJFxNDd/bKgS6uxOeTmpST4j9O5M6CuW5Xl+pNJF36rFcDUJUB8P
         MEw0zHALFGz5W5/jsejZGMfwfmBf1o7JsgwQoG4OVxElTT9jHeeWrtv6ODIjgbq/GmML
         4CIQ==
X-Gm-Message-State: AOAM533vG02CtgGUgD6/T1XavGPBmWrB5Ojxer1Ut0+5W4h5OhVXbAAY
        nr+GNoJk75CShgRwvDkX9dXr129sIeKBrAqo
X-Google-Smtp-Source: ABdhPJxQl4RdUNHROfLjAjx/lKr2QtCA0JI3e8q5s2YdeWSMMHY1oShdmv9Nlxj2fcJdnB/dS3jJbA==
X-Received: by 2002:a50:da0a:: with SMTP id z10mr575367edj.298.1632929333001;
        Wed, 29 Sep 2021 08:28:53 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q12sm108434ejs.58.2021.09.29.08.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 08:28:52 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC iproute2-next 00/11] ip: nexthop: cache nexthops and print routes' nh info
Date:   Wed, 29 Sep 2021 18:28:37 +0300
Message-Id: <20210929152848.1710552-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This set tries to help with an old ask that we've had for some time
which is to print nexthop information while monitoring or dumping routes.
The core problem is that people cannot follow nexthop changes while
monitoring route changes, by the time they check the nexthop it could be
deleted or updated to something else. In order to help them out I've
added a nexthop cache which is populated (only used if -d / show_details
is specified) while decoding routes and kept up to date while monitoring.
The nexthop information is printed on its own line starting with the
"nh_info" attribute and its embedded inside it if printing JSON. To
cache the nexthop entries I parse them into structures, in order to
reuse most of the code the print helpers have been altered so they rely
on prepared structures. Nexthops are now always parsed into a structure,
even if they won't be cached, that structure is later used to print the
nexthop and destroyed if not going to be cached. New nexthops (not found
in the cache) are retrieved from the kernel using a private netlink
socket so they don't disrupt an ongoing dump, similar to how interfaces
are retrieved and cached.

I have tested the set with the kernel forwarding selftests and also by
stressing it with nexthop create/update/delete in loops while monitoring.

Comments are very welcome as usual. :)

Patch breakdown:
Patches 1-2: update current route helpers to take parsed arguments so we
             can directly pass them from the nh_entry structure later
Patch     3: adds the new nh_entry structure and a helper to parse nhmsg
             into it
Patch     4: adds resilient nexthop group structure and a parser for it
Patch     5: converts current nexthop print code to always parse the
             nhmsg into nh_entry structure and use it for printing
Patch     6: factors out ipnh_get's rtnl talk part and allows to use a
             different rt handle for the communication
Patch     7: adds nexthop cache and helpers to manage it, it uses the
             new __ipnh_get to retrieve nexthops
Patch     8: factors out nh_entry printing into a separate helper called
             __print_nexthop_entry
Patch     9: adds a new helper print_cache_nexthop_id that prints nexthop
             information from its id, if the nexthop is not found in the
             cache it fetches it
Patch    10: the new print_cache_nexthop_id helper is used when printing
             routes with show_details (-d) to output detailed nexthop
             information, the format after nh_info is the same as
             ip nexthop show
Patch    11: changes print_nexthop into print_cache_nexthop which always
             outputs the nexthop information and can also update the cache
             (based on process_cache argument), it's used to keep the
             cache up to date while monitoring

Example outputs (monitor):
[NEXTHOP]id 101 via 169.254.2.22 dev veth2 scope link proto unspec 
[NEXTHOP]id 102 via 169.254.3.23 dev veth4 scope link proto unspec 
[NEXTHOP]id 103 group 101/102 type resilient buckets 512 idle_timer 0 unbalanced_timer 0 unbalanced_time 0 scope global proto unspec 
[ROUTE]unicast 192.0.2.0/24 nhid 203 table 4 proto boot scope global 
	nh_info id 203 group 201/202 type resilient buckets 512 idle_timer 0 unbalanced_timer 0 unbalanced_time 0 scope global proto unspec 
	nexthop via 169.254.2.12 dev veth3 weight 1 
	nexthop via 169.254.3.13 dev veth5 weight 1 

[NEXTHOP]id 204 via fe80:2::12 dev veth3 scope link proto unspec 
[NEXTHOP]id 205 via fe80:3::13 dev veth5 scope link proto unspec 
[NEXTHOP]id 206 group 204/205 type resilient buckets 512 idle_timer 0 unbalanced_timer 0 unbalanced_time 0 scope global proto unspec 
[ROUTE]unicast 2001:db8:1::/64 nhid 206 table 4 proto boot scope global metric 1024 pref medium
	nh_info id 206 group 204/205 type resilient buckets 512 idle_timer 0 unbalanced_timer 0 unbalanced_time 0 scope global proto unspec 
	nexthop via fe80:2::12 dev veth3 weight 1 
	nexthop via fe80:3::13 dev veth5 weight 1 

[NEXTHOP]id 2  encap mpls  200/300 via 10.1.1.1 dev ens20 scope link proto unspec onlink 
[ROUTE]unicast 2.3.4.10 nhid 2 table main proto boot scope global 
	nh_info id 2  encap mpls  200/300 via 10.1.1.1 dev ens20 scope link proto unspec onlink 

JSON:
 {
        "type": "unicast",
        "dst": "198.51.100.0/24",
        "nhid": 103,
        "table": "3",
        "protocol": "boot",
        "scope": "global",
        "flags": [ ],
        "nh_info": {
            "id": 103,
            "group": [ {
                    "id": 101,
                    "weight": 11
                },{
                    "id": 102,
                    "weight": 45
                } ],
            "type": "resilient",
            "resilient_args": {
                "buckets": 512,
                "idle_timer": 0,
                "unbalanced_timer": 0,
                "unbalanced_time": 0
            },
            "scope": "global",
            "protocol": "unspec",
            "flags": [ ]
        },
        "nexthops": [ {
                "gateway": "169.254.2.22",
                "dev": "veth2",
                "weight": 11,
                "flags": [ ]
            },{
                "gateway": "169.254.3.23",
                "dev": "veth4",
                "weight": 45,
                "flags": [ ]
            } ]
  }

Thank you,
 Nik

Nikolay Aleksandrov (11):
  ip: print_rta_if takes ifindex as device argument instead of attribute
  ip: export print_rta_gateway version which outputs prepared gateway
    string
  ip: nexthop: add nh struct and a helper to parse nhmsg into it
  ip: nexthop: parse resilient nexthop group attribute into structure
  ip: nexthop: always parse attributes for printing
  ip: nexthop: pull ipnh_get_id rtnl talk into a helper
  ip: nexthop: add cache helpers
  ip: nexthop: factor out entry printing
  ip: nexthop: add a helper which retrieves and prints cached nh entry
  ip: route: print and cache detailed nexthop information when requested
  ip: nexthop: add print_cache_nexthop which prints and manages the nh
    cache

 ip/ip_common.h |   4 +-
 ip/ipmonitor.c |   3 +-
 ip/ipnexthop.c | 455 +++++++++++++++++++++++++++++++++++++++----------
 ip/iproute.c   |  32 ++--
 ip/nh_common.h |  53 ++++++
 5 files changed, 446 insertions(+), 101 deletions(-)
 create mode 100644 ip/nh_common.h

-- 
2.31.1

