Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603582AC47
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 23:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfEZVPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 17:15:25 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42341 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfEZVPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 17:15:25 -0400
Received: by mail-pg1-f195.google.com with SMTP id 33so4937375pgv.9
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 14:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=wHzzHDXmT/wyOK/78DA6P0YEHWnpFSLyKAwzLPK2T6Y=;
        b=FVg0dypoYMjFolSeCG0HK1P9ypMvPA7JhcGIdyawuEbUn3zIlGleh77+jXCgsuE8wZ
         co5Ut/RBjv92WVytLvxM/5x78HjyVKaTHdCF8rkF8WtTFe7TK1ttz41Cw177BM5JTCK5
         Iu+uAT25CilPhUkkr0wOoqlcb+LBck74e/ogjDyXMHHC/tpTTnOLQ2CpbPfSRrXW9sYJ
         erwd0ANCMszDPPhbQ5zUigdVf4aHNa72IK0JsI4iLbOCfnFw6x+JjZBd4s9nJ3nNInFb
         vv7B4gfo+L6Qhz5s/uOZyVs9JybPoJaK7t6OLdA6jLeqblW+Fprd7Ce64tHXsviaV400
         EPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wHzzHDXmT/wyOK/78DA6P0YEHWnpFSLyKAwzLPK2T6Y=;
        b=YOrSUUnnEcXbp5AoFfV2ku9SHRWe6XwODaUQbYAgfJOapWG2xnT2pfcMyra8dPT1Ch
         BhfETmTuf3NeLhqcGNrLrsLpGHaYlQgNDS+c7Zj3+E8au+W2GB7x5pm07ODfi33YN8Cs
         FCGL3F12bq3F3kADOJ8AfntIZG7a8NRxVK5dXEkR6h0WgfLVZnHixXyK5f1sJX2PGq6P
         PHAJFMa/vxTGtMX6nN6dPaE3DJXcS5IUTFlrsfYWQ+rTaCJGDwzih4TSEozEea8rz7gQ
         KuYQ8QoUX0NZVXzBH7gmKmGzGcoE2yZuSZvWYcXcjBfyjx6FuCxZwVKahSyiT46Osvz3
         lYgg==
X-Gm-Message-State: APjAAAVUb1rlr44rnkxTlTJE1I+SMnGnb6EZUcSlbbHSovtFUV6mroOe
        lqrrMgHTeZPA9vPg3rWZfLt3Ew==
X-Google-Smtp-Source: APXvYqzFtCWTdBbsqC0u/9L1b42HoqMV+Gzb4gdsjI5OE1k4bdkz4I2mYL/wjiVNGsZBP87gDtqa7w==
X-Received: by 2002:a17:90a:c682:: with SMTP id n2mr27385414pjt.31.1558905324862;
        Sun, 26 May 2019 14:15:24 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id f40sm13325325pjg.9.2019.05.26.14.15.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 26 May 2019 14:15:24 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 0/4] ipv6: Update RFC references and implement ICMP errors for limits
Date:   Sun, 26 May 2019 14:15:02 -0700
Message-Id: <1558905306-2968-1-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set contains:

- Resolve comment for ipv6_skip_exthdr that the function is
  non conformant with RFC2460. I requested and received an
  on the interpretation of the requirements on 6man list.
- Update references, in comments, of RFC2460 to be RFC8200.
  RFC8200 (aka IPv6) is now a full Internet standard.
- Add references to RFC8504 (updated node requirements) for
  extension header limits and limits on padding in Destination
  and Hop-by-Hop options.
- Send ICMP errors for exceeding extension header limits. These
  are specified in Internet Draft draft-ietf-6man-icmp-limits-02
  (that draft is in working group last call in IETF)

Tom Herbert (4):
  ipv6: Resolve comment that EH processing order is being violated
  ipv6: Update references from RFC2460 to RFC8200
  ipv6: Reference RFC8504 for limits in padding and EH
  ipv6: Send ICMP errors for exceeding extension header limits

 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   |  2 +-
 drivers/net/usb/smsc95xx.c                         |  2 +-
 include/net/ipv6.h                                 |  9 ++---
 include/uapi/linux/icmpv6.h                        |  6 ++++
 net/ipv6/exthdrs.c                                 | 42 +++++++++++++++++-----
 net/ipv6/exthdrs_core.c                            | 23 ++++--------
 net/ipv6/netfilter/nf_conntrack_reasm.c            |  2 +-
 net/ipv6/reassembly.c                              |  2 +-
 net/ipv6/syncookies.c                              |  2 +-
 net/ipv6/tcp_ipv6.c                                |  2 +-
 net/ipv6/udp.c                                     |  2 +-
 net/netfilter/xt_TCPMSS.c                          |  2 +-
 12 files changed, 60 insertions(+), 36 deletions(-)

-- 
2.7.4

