Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A43931DECE
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 19:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhBQSIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 13:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbhBQSIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 13:08:21 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6EDC061574
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:07:40 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id z7so7833636plk.7
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z4/i6rLKj2YZJx0Q229EFTSAvUAIipbYauZPBEm/7sY=;
        b=fjzCJzz2a5R6kyB1x/GyJXjIEIKunZMT+UK3gBCA8gQljw6R/sP+zs5i4INBPWTv3u
         OJTyHlsDF1nFwnL5yorQRaCKx8gv/n3jEBcpg4wpLuhfPW1cIEBA/0BGgl9rlv5k8AsL
         Vbcnxfkp5bZ6bl+bL8996jWRcXxLu/ghFzjTeQ1dAchb/tkemF9g5NFgmcphYQ8F5N+C
         AuSP8kd1IIK2Q5KDKLtOT7FJtPC4w0X8aW5XvFYZ/vf5ky8IAJK+Sk8SiT5Jrbrg0qgf
         nh8vxWQabL9SASAZhoYweuD4mQh2Uh183Wl1GPa0dEt0dMomYFT88d6qH0xM4PooYUS2
         pJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z4/i6rLKj2YZJx0Q229EFTSAvUAIipbYauZPBEm/7sY=;
        b=TucxI6qnUwtvjDjoMwlFPwUuj0OELlN3lOzPSev63s1/1OL8Z1T5OmoJ1xYkFH/h1y
         1fsSKQXg1nrabWhvCVXg+KqQ8FknJbRqLq2s1vSqcbRWTcGVMbnJEIy5/q+GJK54VBiW
         UDxBp8kSAXaOmI/nodUMoEu9CxiTEgU/vaE5QtV9IDrkK6+NttzPYvveERptmKtnufqm
         cxuNBRdqRF4mr5S/WmP5nyU+GMqeuCl0gDxRBy8fDw4svxWIJt6kKevjictAiE+mJ3qs
         xLO95PquUxpZojowKUfIHq8b+uJnRpn9/5ryAoLxVF8eV4pvJFGKekokLqCcfUxkbn8W
         1nqA==
X-Gm-Message-State: AOAM532Yofjv0OQaS621hwZ7ItkX8RudmyR7Mfm/4s9iDs3bC0xHYp9W
        G96C3OuW0hAOKZg6L6qkAEI=
X-Google-Smtp-Source: ABdhPJwIFb5t9EhhiB9I9w20WsPm9+8r4UI50mQJ/cmL8H1DeoR01A71928TT12O2pm8IONS8by51A==
X-Received: by 2002:a17:90a:5d0d:: with SMTP id s13mr54065pji.156.1613585260100;
        Wed, 17 Feb 2021 10:07:40 -0800 (PST)
Received: from localhost.localdomain (h134-215-166-75.lapior.broadband.dynamic.tds.net. [134.215.166.75])
        by smtp.gmail.com with ESMTPSA id 30sm3412107pgl.77.2021.02.17.10.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 10:07:39 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH V3 net-next 0/5] add support for RFC 8335 PROBE
Date:   Wed, 17 Feb 2021 10:07:38 -0800
Message-Id: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
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

Changes since v1:
 - Add AFI definitions
 - Switch to functions such as dev_get_by_name and ip_dev_find to lookup
   net devices 

Changes since v2:
Suggested by Willem de Brujin <willemdebrujin.kernel@gmail.com>
 - Add verification of incoming messages before looking up netdev
 - Add prefix for PROBE specific defined variables
 - Use proc_dointvec_minmax with zero and one  
 - Create struct icmp_ext_echo_iio for parsing incoming packet
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
 - Include net/addrconf.h library for ipv6_dev_find

Andreas Roeseler (5):
  icmp: add support for RFC 8335 PROBE
  ICMPV6: add support for RFC 8335 PROBE
  net: add sysctl for enabling RFC 8335 PROBE messages
  net: add support for sending RFC 8335 PROBE messages
  icmp: add response to RFC 8335 PROBE messages

 include/net/netns/ipv4.h    |   1 +
 include/uapi/linux/icmp.h   |  40 +++++++++++
 include/uapi/linux/icmpv6.h |   6 ++
 net/ipv4/icmp.c             | 133 +++++++++++++++++++++++++++++++++---
 net/ipv4/ping.c             |   4 +-
 net/ipv4/sysctl_net_ipv4.c  |   9 +++
 6 files changed, 181 insertions(+), 12 deletions(-)

-- 
2.25.1

