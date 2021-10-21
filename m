Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B8D4357DA
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhJUAkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJUAkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 20:40:01 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4DAC06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 17:37:46 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so4713035pjd.1
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 17:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VCY6buxruuWHeABeyFy1uxLNrBUhAzhty4X5Yus45LM=;
        b=bA1FVJsxUeb4K8uwI9/5gyGPdBEvK+pvFLgVzV2DPRvFJfeIUSj8xLrr0DEz7u1I/k
         nNPt3U+DUTI4/ceSbKcPgFmtuNmhFh5NNrcKXD2ugx1P6Rn1um9ikMVyjyl6QtbRo4tN
         +C0F/GJx+icDjrq+IChOWMRWtJ4Z7aY7awH3dDDei8/DKImtNGqqnZiMknoSha9JB2g4
         KhU1GUBGCkhjBMKum+dAcqbJwMmTSU2EW5bih03q+OnTM3xM4+QB1q3Q/cS0v7V6H0Z+
         9pPrYHjfLsAk2hIc9m1F+9VFRtpJVC5a55q3VyUeBl4ZuoQCyn0L7BKVh2AuDA0+txzU
         ViFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VCY6buxruuWHeABeyFy1uxLNrBUhAzhty4X5Yus45LM=;
        b=i9qNtkxEbknPU3mE3V3XGJ2pCq5EH9nI5c80AxLUnEOVvCJoNby48BQlkjst+xorez
         XKkSe3rwvhW9a5MbPJcur0ADKA2yDEiekk+nf3S8bgg+j7owLg/tDsAD5LkDqYVPr7sH
         J6rh7l752/+HKBq6V2Z4JQ10UO/9OeEF/cu76bS3E7aQoKZ6YXd+KELo9OlM8CXvXsNj
         urB+rbkQhBDf3JMUhE/o/FndOu7Uc0nho5LlOV1OYRDwzQyec65f3J1J5gtaru3K/qYQ
         IZBWl0IiPw+7q1rKjplh3OoUzq+yftkImUVYC6h3CpECzNe+ILW7fGb0oN3RcICmTqkY
         1PsQ==
X-Gm-Message-State: AOAM5337jjsqkEDPSB+A2bEIY1kCzGHpw3KAqHdL1bz5JC2r0q0wXk7d
        uL2pQYcbdOBZM4pIznZQXlAdB63KsrLZ+Q==
X-Google-Smtp-Source: ABdhPJyuDNWXHhG35mep/385xBTVOFiAoXEYHtqEulIBYQIsYFdbPqbn59+T9zL8l8A58hZOEr4WuQ==
X-Received: by 2002:a17:90b:224c:: with SMTP id hk12mr2718538pjb.242.1634776665355;
        Wed, 20 Oct 2021 17:37:45 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id t22sm4164755pfg.148.2021.10.20.17.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 17:37:45 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     James Prestwood <prestwoj@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Chinmay Agarwal <chinagar@codeaurora.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH v5 0/2] Make neighbor eviction controllable by userspace
Date:   Wed, 20 Oct 2021 17:32:10 -0700
Message-Id: <20211021003212.878786-1-prestwoj@gmail.com>
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


Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: Chinmay Agarwal <chinagar@codeaurora.org>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Tong Zhu <zhutong@amazon.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni@codeaurora.org>

James Prestwood (2):
  net: arp: introduce arp_evict_nocarrier sysctl parameter
  net: ndisc: introduce ndisc_evict_nocarrier sysctl parameter

 Documentation/networking/ip-sysctl.rst | 18 ++++++++++++++++++
 include/linux/inetdevice.h             |  2 ++
 include/linux/ipv6.h                   |  1 +
 include/uapi/linux/ip.h                |  1 +
 include/uapi/linux/ipv6.h              |  1 +
 include/uapi/linux/sysctl.h            |  1 +
 net/ipv4/arp.c                         | 13 ++++++++++++-
 net/ipv4/devinet.c                     |  4 ++++
 net/ipv6/addrconf.c                    | 12 ++++++++++++
 net/ipv6/ndisc.c                       |  5 ++++-
 10 files changed, 56 insertions(+), 2 deletions(-)

-- 
2.31.1

