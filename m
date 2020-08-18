Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289EA24800A
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 09:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgHRH4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 03:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgHRH4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 03:56:54 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244BCC061389;
        Tue, 18 Aug 2020 00:56:54 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y206so9548664pfb.10;
        Tue, 18 Aug 2020 00:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=0a8ZXLhEGMn1gXIxhyv1oqNmrc1yvciM66y5dEH31qA=;
        b=OnMPWYm8lscfbPQyj1djbb0PioZoTGd5x4JH/p04tOQzntO2w3QdMDxT4Vh3tE6Kpp
         JEfePTroeo3muKV9QU6EQicNZyKS1IUHCaxsGZAe6s8+MGYiA+oAiwz9p5ucVc5j8A/z
         +3JgFIXMFVippgcpe7Ab4SDXt3aYmlLU+u8nx7Tj+g/zovWtHaOEOv2YXc9//frymD1+
         p7wAkJFfgHwjxsUzpHXxKKCDlPtBwf46S8k/8QxlMToSmWkj7plbCYY6hbGxptfuKAhv
         W8oZ/FBjzR/kmFc8lnUnnrfx2KykJWhD4fhHA9k7P0/9WEubGAoG2ln+MWK2q+39qh9A
         AM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=0a8ZXLhEGMn1gXIxhyv1oqNmrc1yvciM66y5dEH31qA=;
        b=sHsvUjuY63MmHIX7X/Azg0PS78IiR2xjrBD9QZWaSaPs2aiuanzGhaT0ET4T3v22IT
         KGanZHJg/gmpXolC8mS9Sb5bexrqv4rmMz4rRVe2w+HoyCYC9/SnGqiiBZcQBix4zMqq
         0FclGWM7BrlPxsgoxOt1KU5659vrFM5nJTJrHGwmO/7T/jQQpyj5Qrl3SHwex+11W/kc
         /KAAXfsoYaf6T8stoFWU0/NRn7zOi5kgMvPFJ9VeEM8Ok1YAxogG8eaHBDzdX3ox4Ts1
         1j5Ak2p08Rq2UaFZlbp5eFX1WSSO8k+7MMuc5lu4GKTxOMdc8/8wucA5tKyHkKpmKjmL
         KnSw==
X-Gm-Message-State: AOAM533EtORE7fQds3hELoSniNnfyMjPPy9QzCZdolVjoHbOCFh2SsQ1
        Xfr1OSGFFP7mK39ASW2+Xic8kviWlMg=
X-Google-Smtp-Source: ABdhPJwCldrcVcuZK3TXMeMsmX3YZ82dces6WA6CSG6z3pNHH/qbchCc3BqaDK6HrNnLWrmYWImFHg==
X-Received: by 2002:aa7:99cc:: with SMTP id v12mr14322545pfi.255.1597737412978;
        Tue, 18 Aug 2020 00:56:52 -0700 (PDT)
Received: from oppo (69-172-89-151.static.imsbiz.com. [69.172.89.151])
        by smtp.gmail.com with ESMTPSA id r28sm23400867pfg.158.2020.08.18.00.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 00:56:51 -0700 (PDT)
Date:   Tue, 18 Aug 2020 15:56:48 +0800
From:   Qingyu Li <ieatmuttonchuan@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/bluetooth/hci_sock.c: add CAP_NET_RAW check.
Message-ID: <20200818075648.GA29124@oppo>
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
 net/bluetooth/hci_sock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 251b9128f530..c0919e209f05 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -2034,6 +2034,9 @@ static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
 	if (sock->type != SOCK_RAW)
 		return -ESOCKTNOSUPPORT;

+	if (!capable(CAP_NET_RAW))
+		return -EPERM;
+
 	sock->ops = &hci_sock_ops;

 	sk = sk_alloc(net, PF_BLUETOOTH, GFP_ATOMIC, &hci_sk_proto, kern);
--
2.17.1

