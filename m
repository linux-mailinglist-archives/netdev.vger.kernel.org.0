Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C686242FCD1
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 22:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242943AbhJOUOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 16:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242934AbhJOUOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 16:14:39 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B2FC061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 13:12:32 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so3365614pjd.1
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 13:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RJvf1Tv6inpUxxE+QveTqyG06l+u41Z+ojphJLx7wwY=;
        b=C6w9xDV+bK4eXUBrgVMqv5TvBC1OfvjucfJVKLNzaiNserCJbVxS1lvzBrUFeaDm2G
         v1HOQACEguXSidN5gXRaSb8PRCHgvXersg8Sk6XbmOMVuwTOGSpA0PU+Wg8v62mMEfuM
         b8cHPygwG39/kYp/+UVukPuJPu7yC+3/y+a9UtaDftAhhXhuE853fvLy7/54+2b3BVmE
         0j4I/mCGuNBw+VzVnTs3hIjl+DR3QgyMqTxghhkFswMWndbjns4HxMh8WMBDIfT5Hv8p
         lT6FLrH0orgaX4kXevwfeXPjOxqNTkvpJokktMsJzh16Qv8onx9bJHWTKvTwyHA64o90
         v84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RJvf1Tv6inpUxxE+QveTqyG06l+u41Z+ojphJLx7wwY=;
        b=Q0l5BE5Wf8o0W3stgzM4umAsdr6XU7KV3o5LH3rDO7LjALeF3AMSvIHOjdBzQH0Ruh
         q7AWhuMJmANG/QwSaH1Q8DA3WpjlEeGDx/T9naf+amiLnJenM6Nj9ebewkzbJ7lwa4xM
         CKv124xqfZ/WPi+O4+cwO35dqtK/Hi5rsOxUg5yqaYgSHyb/zfpShXt9YHbMmnFcC8yc
         9cR5sG3rLMKsqDV9JjFrcgoxohafzRFF1emu0SoZ9ufivRKoaMWeGPlCjYKnOpHzaC5J
         SY9Zl7jTsMiO1jcLtM/5ONeShB8Iaza5hnFRdorNTCAcbnxTISZ0YyNqCcbMP2d3/6QF
         R3NQ==
X-Gm-Message-State: AOAM532Vuiw1o1D75SNE3a1+0OlBrxl2D/0m5abhcWFalde9/Lf8fYmu
        aSNfSDoeAz9ql+eyXqJ99qEvTu2OheMl8w==
X-Google-Smtp-Source: ABdhPJwQcb6ysbTxchAQqJmZjupx42rCpUMbTbBV5XST4bz8kUJQQ18w4yNnBGZpFKH+NYdUXtBLMQ==
X-Received: by 2002:a17:90b:3901:: with SMTP id ob1mr30370892pjb.12.1634328752058;
        Fri, 15 Oct 2021 13:12:32 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id g11sm6058546pfc.194.2021.10.15.13.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 13:12:31 -0700 (PDT)
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
Subject: [PATCH v2 0/1] Make neighbor eviction controllable by userspace
Date:   Fri, 15 Oct 2021 13:06:47 -0700
Message-Id: <20211015200648.297373-1-prestwoj@gmail.com>
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

James Prestwood (1):
  net: neighbour: introduce EVICT_NOCARRIER table option

 Documentation/networking/ip-sysctl.rst |  9 +++++++++
 include/net/neighbour.h                |  5 +++--
 include/uapi/linux/neighbour.h         |  1 +
 net/core/neighbour.c                   | 12 ++++++++++--
 net/ipv4/arp.c                         |  1 +
 net/ipv6/ndisc.c                       |  1 +
 6 files changed, 25 insertions(+), 4 deletions(-)

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

-- 
2.31.1

