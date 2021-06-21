Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD053AEC29
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 17:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhFUPTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 11:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbhFUPTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 11:19:52 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12CCC061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 08:17:37 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bb20so5999849pjb.3
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 08:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=+EfZrKKsVuzlv0m0wyLYMNoyhM9Xel2Xe4VU3OaRUJw=;
        b=UP5Rf6FEzB4HKZ0p3cI2SCBzKi+6X2PUAwTtZL8pgpB9MDC6nWFaxlkHIsKg358akI
         Qm/ZnoG/+ivuue4v2r3tJDB2M2opNcFRiq/h3Qvhlrlg1Vx55QjjWzzEgH66SGMI6wXG
         aPYuoVjMxjhLw+nR3HXXqfqEffaW4o+TcIdhdjytzcAblU19K2sqGgf8KLiNUgRKtw+C
         Ti0p2ewOu00NxPDw3JAYoQyh+xPxae2yvP6Ssf2dcZRUn9G03NWkh3lKArV814XiV4fv
         Aah6sKw0Rte7K/+r6exWbrjrEOuemkZB5EJwZrYHJkPkdBZOHwkhVEy2vmnkyrNMTfUB
         nFMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=+EfZrKKsVuzlv0m0wyLYMNoyhM9Xel2Xe4VU3OaRUJw=;
        b=N2jNx6xlQpPi0aesLbXW2gLITjIkxyZ0HJhK2G38QvJhpU/pL8IFuTKXsxYImFpxgs
         99FX4Z4lQgq/7gC11rA/EGnbQILMUnBzFyH96Krlc1U9xm6KhNZ6/MVs1iLCtZTDfThV
         KPtwft9ma7gUoZfoDlGSzvbebZwclyqdtZF+yXXpGVNajgB3tpCToMEOLMtj+TPESm6N
         UVwzJIIy3yONFPAMPx7wbjcOJvs88oBouoCzbSmWlexlMD8Avvp9FJvqBAYp/kkLLDcA
         79bMg58OC4oJcwYAk7lpm+DKjgXQodQ+UXetCIjQ6cP5/S3podj/cyhZVqRTf+j0ICMI
         04dg==
X-Gm-Message-State: AOAM530jRLt6n0/UIUSqC4bMi98cDHiNj2klnavU/OfH8ZjdXhapgno4
        lwlsG0SYVBimrqQL2TKJkzvUec+UcPc=
X-Google-Smtp-Source: ABdhPJwTjY+dpsgyHBMYexHJNK0k4MHECa8qRAloAaEezeLemqEMEs/XIzrLS5IUHBxcQsM/6qFIsA==
X-Received: by 2002:a17:90a:fb48:: with SMTP id iq8mr27555421pjb.135.1624288657174;
        Mon, 21 Jun 2021 08:17:37 -0700 (PDT)
Received: from [10.7.1.2] ([133.130.111.179])
        by smtp.gmail.com with ESMTPSA id b10sm15793692pfi.122.2021.06.21.08.17.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jun 2021 08:17:36 -0700 (PDT)
From:   Wang Shanker <shankerwangmiao@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.6\))
Subject: [PATCH] net/ipv4: swap flow ports when validating source
Message-Id: <1B652E0A-2749-4B75-BC6D-2DAE2A4555A8@gmail.com>
Date:   Mon, 21 Jun 2021 23:17:32 +0800
Cc:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.6)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing source address validation, the flowi4 struct used for
fib_lookup should be in the reverse direction to the given skb.
fl4_dport and fl4_sport returned by fib4_rules_early_flow_dissect
should thus be swapped.

Fixes: 5a847a6 ("net/ipv4: Initialize proto and ports in flow struct")
Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
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
