Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDF4248028
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 10:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHRIHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 04:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgHRIHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 04:07:08 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACD7C061389;
        Tue, 18 Aug 2020 01:07:08 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mw10so8894821pjb.2;
        Tue, 18 Aug 2020 01:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=StFFVCyyrqOkn7U9cLGxAfuLpee/KXFwmS5u87kiIm4=;
        b=iwISd+CWW2R7LQdicuTPCO4Djz+Ep8Wv035bwy+fTHpfPjAldOMn8249OlRIpvpyYZ
         Es6G5h55Cgvnd5ZDOOavmtGyfZnD+VnPHVberGV9wsB8LFiNcn/CCEBvZihm+MMiKOkX
         PfmRfyf3M4cNxWUJyD3RrKMTFpQ9FaIhU9R7OODxee8pa6G5EZAUreV2v6KCC+qgm3YY
         EwdmAZMuo5VKfz2Sx/rmwABbnrjqwN4nR+MNGziHsy5iJIAd2Z5/XGrc3rrnE8wUfqnA
         T0KRi/2W5GALncOgHIcHIwci8ERvgLydaFzAcNzFeG+BFq5lTQ8OdIDdcWIjCrGtuT44
         HCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=StFFVCyyrqOkn7U9cLGxAfuLpee/KXFwmS5u87kiIm4=;
        b=TDb+jx0pDP3p5VDPnrONNz2imG8tIlQu0KppL6VzcxKq3qfNvE5YIvIyLvRDCmbnQW
         ZhFzPDACYXZIXKng5Q/MZp53afYSTpM7E31vHBahiIRbr0nSGXlAQxBsPtDzAB34AYSR
         2Gu8yegmzfNmzpYUHpdfjWsAFMVnsBxDKW+gGReQNYQy1EKm09L5IRGLzEV6sNglMnB2
         lPCfzkoKcBTg29QVCNsYChcAjFv9I9rM+2P/wdUPX9MJlnfCwv9vUaV7XCGqaVcKB035
         kNZznGNRQEw+dhiRmIZswxIWNkFWy2oLwxdeH4cntzXtVXi2Fbui6mTKh+tczxB+S70q
         J2MA==
X-Gm-Message-State: AOAM531MESycJtOOg0ZZuLb+tsWGWzFgycuG9sfk747GeICoIXZwkHWk
        Y4K28LBU3DkhJjE4w6FOLjoOD1F9F1E=
X-Google-Smtp-Source: ABdhPJz8H1EB4gkEEbz+CgswsYmcAgHxH1hWTh2rxtMgeriPdI0/FERnAKJJOo4zzNahWr410ikthA==
X-Received: by 2002:a17:90a:8d85:: with SMTP id d5mr14752437pjo.45.1597738027502;
        Tue, 18 Aug 2020 01:07:07 -0700 (PDT)
Received: from oppo (69-172-89-151.static.imsbiz.com. [69.172.89.151])
        by smtp.gmail.com with ESMTPSA id kb2sm20369902pjb.34.2020.08.18.01.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 01:07:06 -0700 (PDT)
Date:   Tue, 18 Aug 2020 16:07:03 +0800
From:   Qingyu Li <ieatmuttonchuan@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/bluetooth/bnep/sock.c: add CAP_NET_RAW check.
Message-ID: <20200818080703.GA31526@oppo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating a raw PF_BLUETOOTH socket,
CAP_NET_RAW needs to be checked first.

Signed-off-by: Qingyu Li <ieatmuttonchuan@gmail.com>
---
 net/bluetooth/bnep/sock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/bnep/sock.c b/net/bluetooth/bnep/sock.c
index d515571b2afb..e06787a3b5ce 100644
--- a/net/bluetooth/bnep/sock.c
+++ b/net/bluetooth/bnep/sock.c
@@ -204,6 +204,9 @@ static int bnep_sock_create(struct net *net, struct socket *sock, int protocol,
 	if (sock->type != SOCK_RAW)
 		return -ESOCKTNOSUPPORT;

+	if (!capable(CAP_NET_RAW))
+		return -EPERM;
+
 	sk = sk_alloc(net, PF_BLUETOOTH, GFP_ATOMIC, &bnep_proto, kern);
 	if (!sk)
 		return -ENOMEM;
--
2.17.1

