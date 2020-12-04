Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0972CE654
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgLDDRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727463AbgLDDQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:16:59 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6310C061A51
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 19:16:19 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id n7so2688599pgg.2
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 19:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X8Qpsie2yWHM7XIKDleCvkzGz3XbJeTnKkuiCA6NJoE=;
        b=HzhCrah8oqfuCXG5jbj9d7cVnrzQoZzGPUqf6RQTUYfg8rG7fmYOh7p0Bs7RNmw9yr
         hA1r27omuusLo9gjCqtE2mg+Ecap+2uX1pNrKygQfqXaUTMJKhocfEywITEm906xqrr/
         /RMBPYI0cvOvFpHY/W/e9Q0/XV3QW49S3hXLRQ90MKwrHy91bZyt3oLXZPPSx74F6+d+
         fN1eVsyaNXdmtamDKbyLe+c5YDp8zSxbr2d7emugDB/yIxsXDd0p9PdjT3u29KKI8+xQ
         XdWSpzk0Dk7adjTkgqETsyT9Y/Q694lHSJxo98r1eZO5sz4VLT8mBuRW7OjBYAzB36O3
         7w7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X8Qpsie2yWHM7XIKDleCvkzGz3XbJeTnKkuiCA6NJoE=;
        b=I8NWww+E8iA30cAsQ1kX7pbcxfZki6PedtRYn8iNPS6YZI55325bQofmVzXshBF3lz
         UZKE5A/v2dMUXoQzlphlUM4W2Sow449ZZ5Dbq5ErmMIGdY+66+NGoyjZrbocSJjtIhSS
         NU9Fp3Cwca9cXwhhEMp+eKEQgJJ/NgVCW5eA3LazQzj98KrCJdkb9EBnfM3oAeGUWJky
         ffzX+SfKzpGwsrbI1YK6WmhEk9AImBjCaNw46xvknk4ftyRBcnhCx73C5YYvRF8s7Ike
         2yQG2Jp+ZhdphBkAd8G2M9MYtlYBMrgizTdegfTVtivipoQm2yaRK4nz/hxniJaY3+ZA
         9VGw==
X-Gm-Message-State: AOAM532RQiIyTc2iABKN7gixFIncs6yFNbeEOC0YjUdlohvgNT7ho76N
        ClIEeaS02BxdeEFo7rLAhGFg0qDgycoX3g==
X-Google-Smtp-Source: ABdhPJw1sS6ceolbuG2JQsZEQ1+6US6wkdFrWLG7D3lwutjlJDzH3V2z+Jk5P+dD2e4/bc9Y/Xwm4g==
X-Received: by 2002:a63:2885:: with SMTP id o127mr5786858pgo.391.1607051779333;
        Thu, 03 Dec 2020 19:16:19 -0800 (PST)
Received: from clinic20-Precision-T3610.hsd1.ca.comcast.net ([2601:648:8400:9ef4:bf20:728e:4c43:a644])
        by smtp.gmail.com with ESMTPSA id p1sm3383498pfb.208.2020.12.03.19.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 19:16:18 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/6] add support for RFC 8335 PROBE 
Date:   Thu,  3 Dec 2020 19:16:17 -0800
Message-Id: <cover.1607050388.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The popular utility ping has several severe limitations such as the
inability to query specific interfaces on a node and requiring
bidirectional connectivity between the probing and probed interfaces.
RFC 8335 attempts to solve these limitations by creating the new utility
PROBE which is a specialized ICMP message that makes use of the ICMP
Extention Structure outlined in RFC 4884.

This patchset adds definitions for the ICMP Extended Echo Request and
Reply (PROBE) types for both IPV4 and IPV6, adds a sysctl to enable 
response to PROBE messages, expands the list of supported ICMP messages
to accommodate PROBE types, and adds functionality to respond to PROBE
requests.

Andreas Roeseler (6):
  icmp: support for RFC 8335
  ICMPv6: support for RFC 8335
  net: add sysctl for enabling RFC 8335 PROBE messages
  net: add sysctl for enabling RFC 8335 PROBE messages
  net: add support for sending RFC 8335 PROBE messages
  icmp: add response to RFC 8335 PROBE messages

 include/net/netns/ipv4.h    |   1 +
 include/uapi/linux/icmp.h   |  22 ++++++
 include/uapi/linux/icmpv6.h |   6 ++
 net/ipv4/icmp.c             | 135 +++++++++++++++++++++++++++++++++---
 net/ipv4/ping.c             |   4 +-
 net/ipv4/sysctl_net_ipv4.c  |   7 ++
 6 files changed, 164 insertions(+), 11 deletions(-)

-- 
2.25.1

