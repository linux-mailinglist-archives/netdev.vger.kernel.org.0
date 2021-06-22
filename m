Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0653AFBB9
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 06:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhFVE1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 00:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhFVE1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 00:27:11 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08A4C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 21:24:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso1095798pjx.1
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 21:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=FtGpnc8S6utcm0+JTKR4eaVSIUB1CrTHaZk0ktULFko=;
        b=iyidxb4IDvxTWWC0+kuJFkuwjN2xKQMDZlOQQ6WH0N5fZmjd/Pj1R6JLA78TtGk+vW
         QKLBpE793irZA+TYUHJoGv+A7xbjiuUCTw3hdNA393nY+rMo6feJettcxGRWatT7Y/xf
         m9NUGk89zNX0oMuHomM8P7LP1P/YXg2ixTARJx686bEU+1v5GCRoFeyUe/+RpenoW/St
         vgo6MtvjiRHQ8oeJRumyZMNExy1t/N3Mac7yQU6VvmRlDmbiPjjFLDu00IawecuZWPur
         bIKko9uqTNkx4CCF240htdOYkcwLGvw5pXlN5Cf2HGOQlYbYIC9itmsM/pi9Xo+bS+r7
         VvfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=FtGpnc8S6utcm0+JTKR4eaVSIUB1CrTHaZk0ktULFko=;
        b=EbBMqI7wGxU1S+q4Qw3R8t1GcMrxC6vUDRzGLR2rs4Ev9JPEPGu4jeXu2MxCGsFIAH
         vvMMhi9wrJAOsvfqWF9cg8SmwqatgmjeYpwiWFKGN68rf5kQTPfPt9Jopb4+vi0zXRdG
         j32Y6NJNP2+MpEq5Mua9VvcUlOSYuR6mNII+hXjYsHCEq2grll5gLHn6osdogqG9M9Oy
         cy2LqidGoKKKE/ob+glqcttx1UvLmDRato4aDfxa4UZOMDPSbrTiTHkXb9g2TPb+Sr7C
         0qYPwgfoKfr0w6h8TByMhtbu8ezOuJHCjvgsZypplzknzt8waW+zwKbxLPZeZ1jhxEXV
         IDbA==
X-Gm-Message-State: AOAM532pokazBQY+NkXGZjPHvSuxmd0rdrBDE5/1gSgCAX1A8sJVBijW
        /uxGfkmnxrxLmTcATJL/2LY=
X-Google-Smtp-Source: ABdhPJz+QbWx/BoNK4Oy0xqIGqOhCmbvCIrtWAgOvDNNj71niDMJzxAxMVG1kd/6avEFm3xS9NAgKA==
X-Received: by 2002:a17:902:bf02:b029:11e:89a0:8694 with SMTP id bi2-20020a170902bf02b029011e89a08694mr20875730plb.83.1624335895287;
        Mon, 21 Jun 2021 21:24:55 -0700 (PDT)
Received: from [10.7.3.1] ([133.130.111.179])
        by smtp.gmail.com with ESMTPSA id s3sm1505240pfe.49.2021.06.21.21.24.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jun 2021 21:24:54 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.6\))
Subject: [PATCH v2] net/ipv4: swap flow ports when validating source
From:   Miao Wang <shankerwangmiao@gmail.com>
In-Reply-To: <c862966c-6a17-ba50-01d1-6c9227f6e29e@gmail.com>
Date:   Tue, 22 Jun 2021 12:24:50 +0800
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <04B365C6-F4FD-49AB-9C9E-35401BA309A9@gmail.com>
References: <1B652E0A-2749-4B75-BC6D-2DAE2A4555A8@gmail.com>
 <a08932fe-789d-3b38-3d92-e00225a8cf9f@gmail.com>
 <69C9F0FE-055B-4B1E-8B4B-CE9006A798BE@gmail.com>
 <c862966c-6a17-ba50-01d1-6c9227f6e29e@gmail.com>
To:     David Ahern <dsahern@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.6)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing source address validation, the flowi4 struct used for
fib_lookup should be in the reverse direction to the given skb.
fl4_dport and fl4_sport returned by fib4_rules_early_flow_dissect
should thus be swapped.

Fixes: 5a847a6e1477 ("net/ipv4: Initialize proto and ports in flow =
struct")
Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/fib_frontend.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 84bb707bd88d..647bceab56c2 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -371,6 +371,8 @@ static int __fib_validate_source(struct sk_buff =
*skb, __be32 src, __be32 dst,
 		fl4.flowi4_proto =3D 0;
 		fl4.fl4_sport =3D 0;
 		fl4.fl4_dport =3D 0;
+	} else {
+		swap(fl4.fl4_sport, fl4.fl4_dport);
 	}
=20
 	if (fib_lookup(net, &fl4, &res, 0))
--=20
2.20.1=
