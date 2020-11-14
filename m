Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172972B30CF
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 21:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgKNU4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 15:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKNU4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 15:56:01 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E7BC0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 12:56:01 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id f12so1975530pjp.4
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 12:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X6HQyQjs8/Q8phh3T7uapsXTlo+TZEJY7ce7ooOp9ZM=;
        b=sZ1A1zZRiKhMzq54aG7fRP9c/rvQpO6NfHz6XzSK6IsIefhYcgEO9dOj418H/fCxMg
         Vp74Nclm7WTvczNN7ikWWTmwsn+jOMg/522yboS4QKh+zbZjDxAvJ/zairWrFwl0jDYj
         fk3fjK0e+pmwA1i7gVxiivCyWOMgueWlNOxUymRCvdhaSX+3W+u8+E1snqgwO1+3Z8Ws
         yPulLo9E1bbL2FuBMzfHOaFsaUl5Is7GrKIsREiVCVYBgd9g/kZXyzGhjlbuOpEDpuov
         2AKP3jF+xW8a5wBfCk0cm6fJvNI5TelQNPcU/NlP4NJrg8fMDXp6Ky1YiqWmHQ8owqsZ
         W0Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X6HQyQjs8/Q8phh3T7uapsXTlo+TZEJY7ce7ooOp9ZM=;
        b=auRJHqbDXF+9d0vRxsHRsD2SX3K7zQ70GCosGFbbHJjwSNf0X5YyTr7iXiPOMOeMvR
         3UJ+Zr3L3OLXJ6s2+fFgWKzeAQkVbzuaCse2dFsOCnSqY4o1HTpWNDveyUuYP2absVMJ
         SMV3hdmdhxzjjw07z+AKa77NUq5D9SXSuZdcPEYZWFhVxYkNrm8MtBjICrCKe+xXeGow
         IG6qHjWhqyBdpyFYPbdZFZB2dhK/CUHt40kQ64iS9VYyMQGxGeIhQylkShO68ZU1c6/B
         10n6DrxNyN3rQjgTPB6dlQIx2Mc+MEbaSAOol5lz6ZuZdAvqZ3A6qexiImqI7T4MTXxa
         QGFQ==
X-Gm-Message-State: AOAM533JvcNAelHo4VmiSgKzdgZFpXgnepfBHgMG86PC0OvUUEEmMDDn
        07c3If2JfxssIMmXumrIjsSO31gzP5faGPUs
X-Google-Smtp-Source: ABdhPJyUL51wNZjbvmP4V0cCIXnlylMIAao4XM2NXCgPnX4FKrKCpbdi3FJm5QLicWyLhrEdciAIOQ==
X-Received: by 2002:a17:90a:34ca:: with SMTP id m10mr8956364pjf.193.1605387360935;
        Sat, 14 Nov 2020 12:56:00 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id u24sm13669726pfm.51.2020.11.14.12.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 12:56:00 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 net-next 0/3] add support sending RFC8335 PROBE 
Date:   Sat, 14 Nov 2020 12:55:57 -0800
Message-Id: <cover.1605386600.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The popular utility ping has several severe limitations such as the
inability to query specific  interfaces on a node and requiring
bidirectional connectivity between the probing and the probed
interfaces. RFC8335 attempts to solve these limitations by creating the
new utility PROBE which is a specialized ICMP message that makes use of
the ICMP Extension Structure outlined in RFC4884.

This patchset adds definitions for the ICMP Extended Echo Request and
Reply (PROBE) types for both IPv4 and IPv6. It also expands the list of
supported ICMP messages to accommodate PROBEs.

Changes since v1:
 - Switch to correct base tree

Changes since v2:
 - Switch to net-next tree 67c70b5eb2bf7d0496fcb62d308dc3096bc11553

Andreas Roeseler (3):
  net: add support for sending RFC8335 PROBE
  icmp: define PROBE message types
  ICMPv6: define PROBE message types

 include/uapi/linux/icmp.h   | 3 +++
 include/uapi/linux/icmpv6.h | 6 ++++++
 net/ipv4/ping.c             | 4 +++-
 3 files changed, 12 insertions(+), 1 deletion(-)

-- 
2.29.2

