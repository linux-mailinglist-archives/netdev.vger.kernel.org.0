Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40714439C16
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbhJYQxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbhJYQxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:53:51 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4267C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:51:28 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id x1-20020a17090a530100b001a1efa4ebe6so346117pjh.0
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8YeOxeNxCzH560m2MlNGrV8Ri03BGKw/sb3lzrSX+jU=;
        b=FtpPS1+Sny1mD+h/wkrOriAp0g1SHLJbheqdyQgKMWBbADFFG9R/DOyS6BRSXpJKnk
         k2NQvp6sE2ogc/3uv+JEYADlvhgPU18bffByi/H7F3+Mp3bPKG+QYSqAQoMGuX3ZHxYy
         7XE+8W9CtMHIopBVBAEz7Dycd6OQ6sUuVG1jXRSzm0neLwp6nzjVGhcnyvMlDvKnEvl3
         wm6AU3zBpS8QS/FCicxS9Szm+XrAUqW7yTOVh9kC+sx2GI514OXYyMQHCxrhELATPXy6
         ycMcpr004798z5KDX0LGzfJdOCOU3l+MXmLE6EcHQNgEzW8XexjQHXEODdka22Wtif99
         VnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8YeOxeNxCzH560m2MlNGrV8Ri03BGKw/sb3lzrSX+jU=;
        b=I2RmkC/n0rdeeZjl1tlWjnfHhFs49gBRkJYImog62jiyvSbBbhgNZC8DFp9lPQ0pX1
         5ElbzaWGXUocIsQXDRJG1K+bCvDSllDwuAUbooZ2i7oi7PqO21Pjpos1inblVfbYUx4u
         yYG4jO0SzDqj9H/b0uni0aIGYmdxfRLe+d50D5eRKhCdUkO3c382WGTP4oYHc8bMm6c9
         KeSiThsYvGn4NYDSkNxmkj+fQg0Dd5ON0f26tupqmT1DMN2uZqvzLKgRzml8XVh+HPkg
         hobn2zVxSsAlfZFOsYp0JkLWKp1a65cb6UYXJCfCzIIy9Z6QDfFR0opatBPz/2kIAjFj
         yVig==
X-Gm-Message-State: AOAM530d7ANnKzZckgw+2+yZDl9fE0lABRyHs5W2VptUjyrTdTCnr0wG
        sPcSvSriKDRNPONp+WsjItXga/Jobp0=
X-Google-Smtp-Source: ABdhPJxgLcq3yCegmy2VKvUjtwcKq+D/n3Qknl7xMPNHL2mk3NoIFFUyCfAxNCtP7S8423Jhdu28ew==
X-Received: by 2002:a17:90a:4306:: with SMTP id q6mr36602987pjg.202.1635180687997;
        Mon, 25 Oct 2021 09:51:27 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id h1sm13390531pfh.118.2021.10.25.09.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:51:24 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, roopa@nvidia.com,
        daniel@iogearbox.net, vladimir.oltean@nxp.com, idosch@nvidia.com,
        nikolay@nvidia.com, yajun.deng@linux.dev, zhutong@amazon.com,
        johannes@sipsolutions.net, jouni@codeaurora.org,
        James Prestwood <prestwoj@gmail.com>
Subject: [RESEND PATCH v7 0/3] Make neighbor eviction controllable by userspace
Date:   Mon, 25 Oct 2021 09:45:44 -0700
Message-Id: <20211025164547.1097091-1-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 -> v2:

 - It was suggested by Daniel Borkmann to extend the neighbor table settings
   rather than adding IPv4/IPv6 options for ARP/NDISC separately. I agree
   this way is much more concise since there is now only one place where the
   option is checked and defined.
 - Moved documentation/code into the same patch
 - Explained in more detail the test scenario and results

v2 -> v3:

 - Renamed 'skip_perm' to 'nocarrier'. The way this parameter is used
   matches this naming.
 - Changed logic to still flush if 'nocarrier' is false.

v3 -> v4:

 - Moved NDTPA_EVICT_NOCARRIER after NDTPA_PAD

v4 -> v5:

 - Went back to the original v1 patchset and changed:
 - Used ANDCONF for IN_DEV macro
 - Got RCU lock prior to __in_dev_get_rcu(). Do note that the logic
   here was extended to handle if __in_dev_get_rcu() fails. If this
   happens the existing behavior should be maintained and set the
   carrier down. I'm unsure if get_rcu() can fail in this context
   though. Similar logic was used for in6_dev_get.
 - Changed ndisc_evict_nocarrier to use a u8, proper handler, and
   set min/max values.

v5 -> v6

 - Added selftests for both sysctl options
 - (arp) Used __in_dev_get_rtnl rather than getting the rcu lock
 - (ndisc) Added in6_dev_put
 - (ndisc) Check 'all' option as well as device specific

v6 -> v7

 - Corrected logic checking all and netdev option

Resend v7:

 - Fixed (hopefully) the issue with CC's only getting the cover letter

James Prestwood (3):
  net: arp: introduce arp_evict_nocarrier sysctl parameter
  net: ndisc: introduce ndisc_evict_nocarrier sysctl parameter
  selftests: net: add arp_ndisc_evict_nocarrier

 Documentation/networking/ip-sysctl.rst        |  18 ++
 include/linux/inetdevice.h                    |   2 +
 include/linux/ipv6.h                          |   1 +
 include/uapi/linux/ip.h                       |   1 +
 include/uapi/linux/ipv6.h                     |   1 +
 include/uapi/linux/sysctl.h                   |   1 +
 net/ipv4/arp.c                                |  11 +-
 net/ipv4/devinet.c                            |   4 +
 net/ipv6/addrconf.c                           |  12 ++
 net/ipv6/ndisc.c                              |  12 +-
 .../net/arp_ndisc_evict_nocarrier.sh          | 181 ++++++++++++++++++
 11 files changed, 242 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh

-- 
2.31.1

