Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB6B2C8CFA
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387746AbgK3SjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:39:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727451AbgK3SjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:39:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606761457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vti/hioQ1b48TeV8bk5Pw23Zejok0uePKJw0B2VVoEs=;
        b=WT9YTZDYXK891A/zJlFgxilLaSbhvMf51TDX7+b729/xUm1TMraADCJVZeakB0ri9wc+EZ
        tgnkqcywnzODzCD4JhD2+Nc2QqiXpN27lC/j/vDbP4O0WfRm5hHrcH3y3bPLu4U7O0mJaX
        ZSO8QsJi91Aj4VHugGZLgThLSm4MJQ8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-R99E2iUmOYG_FFkzua0gtA-1; Mon, 30 Nov 2020 13:37:35 -0500
X-MC-Unique: R99E2iUmOYG_FFkzua0gtA-1
Received: by mail-ed1-f69.google.com with SMTP id x71so3971856ede.9
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 10:37:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vti/hioQ1b48TeV8bk5Pw23Zejok0uePKJw0B2VVoEs=;
        b=e+dNYhQtJRCYWgSTBHs+kQ8Jv2+d+M8DTBULkPvI7PABvPPIH4gSvwebqRQ+H/R/nX
         5JUb91dPWBkAoN/VCuhUsixEmqvfYmLgLutZ4Ec0X5zVJs+ibNKiu2D+wcp4RiMSe7pN
         W4d/XHfAkAXWUF/a9K3GoqGTiqJ2pqmrTmC0PJagoJ9PA9YGz3KbCuB4LOk9fCGkuQDs
         8sGSNVcndw+g4ttoiYPgqLg8/ua+NlKuUld3r3nLSDUUCmAn4HhjiYjWh/FdA69bTwRR
         hZ3As82tbIKEaphM6AUPI/wRO1lpHeocct0UgN22ir4+7j8hTJnGgzCrdFUsYOgYgm99
         rfNg==
X-Gm-Message-State: AOAM530Lb/3fRSZBdshah8zG+0YBfGn9QMkezALkC8CNnrMtkgVy2EUz
        Jw3uJVHbxcIjbseNz2va66fiOvVKI1qwVkIsru3aRqzYNVSmOpSRvcq1uINxYOI2v9pCsfLzbpH
        JJ9dC1PBbZYstn/CO
X-Received: by 2002:a17:906:391b:: with SMTP id f27mr20464979eje.195.1606761453969;
        Mon, 30 Nov 2020 10:37:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyd9xfdyzfYJ2lw1X/IgAiuN3edERGd+ctA3CbqEVNPiUlUooI47U9taql0gTC41xZh3aPygA==
X-Received: by 2002:a17:906:391b:: with SMTP id f27mr20464933eje.195.1606761453351;
        Mon, 30 Nov 2020 10:37:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a10sm507720ejk.92.2020.11.30.10.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:37:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C5B8B181AD4; Mon, 30 Nov 2020 19:37:30 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, Jonathan Morton <chromatix99@gmail.com>,
        Pete Heist <pete@heistp.net>
Subject: [PATCH net] inet_ecn: Fix endianness of checksum update when setting ECT(1)
Date:   Mon, 30 Nov 2020 19:37:05 +0100
Message-Id: <20201130183705.17540-1-toke@redhat.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding support for propagating ECT(1) marking in IP headers it seems I
suffered from endianness-confusion in the checksum update calculation: In
fact the ECN field is in the *lower* bits of the first 16-bit word of the
IP header when calculating in network byte order. This means that the
addition performed to update the checksum field was wrong; let's fix that.

Fixes: b723748750ec ("tunnel: Propagate ECT(1) when decapsulating as recommended by RFC6040")
Reported-by: Jonathan Morton <chromatix99@gmail.com>
Tested-by: Pete Heist <pete@heistp.net>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/inet_ecn.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/inet_ecn.h b/include/net/inet_ecn.h
index e1eaf1780288..563457fec557 100644
--- a/include/net/inet_ecn.h
+++ b/include/net/inet_ecn.h
@@ -107,7 +107,7 @@ static inline int IP_ECN_set_ect1(struct iphdr *iph)
 	if ((iph->tos & INET_ECN_MASK) != INET_ECN_ECT_0)
 		return 0;
 
-	check += (__force u16)htons(0x100);
+	check += (__force u16)htons(0x1);
 
 	iph->check = (__force __sum16)(check + (check>=0xFFFF));
 	iph->tos ^= INET_ECN_MASK;
-- 
2.29.2

