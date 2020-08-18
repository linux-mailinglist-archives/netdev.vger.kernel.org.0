Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41DE24806D
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 10:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHRIVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 04:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgHRIVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 04:21:08 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FEAC061389;
        Tue, 18 Aug 2020 01:21:08 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y6so8882586plt.3;
        Tue, 18 Aug 2020 01:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=R6UfMfJwqHE+FvqFjrSG5hHKZrDmBk/7qX6MpbTswn4=;
        b=P+O+y6fHin2i63yQXnz5g3IAJ2NyZIMZ1e9cDB3VdSIrWcUAfL5/9ydchAsgXekI/6
         nNHfNWZovhWixT/cctY0wawTSq7P3mL8gyCOCJtcvt2Rn9Pskgy6Gt6fR517kpfHPXKM
         FL8uePTrKBJYJZTFqeGjrRUnMWqMScl/eK3kBuVT9xBeRohWi+4O7ALoUGKDUgH9oV91
         InGy8RhGQJjYhDKiUXaC9K4itTlqZm0OKqvXKocL0qwuc0YiBdIksHA4KX4dQELsPvvZ
         JplSArwK3psUnHIdO0iKEMCzwvBsr7NthpCB1DYxdISthYp7QD+NTVdCQFD9Up3+AfbC
         vtZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=R6UfMfJwqHE+FvqFjrSG5hHKZrDmBk/7qX6MpbTswn4=;
        b=X3xVog0QJIqXEhQfrdGlY+2xbFb6j6d3cEWR11KfEY7u4vfypmgJm4Q9LrjSh8Z/L/
         kXGa+EtVEQtBSkoXY32rXv0p27zGJDbDKoOpDnlr53QihBtuC7/+TgC8q6G4tQIYvHXg
         xYmVyTCE/TfNkGvBgDctw6qYLwgpyihdYixfzpG70hpulUSwgGeWQ4ry61embmdcqY+e
         Qq+bpGKE8SUMuNt9cQV5b6R6fCjPv7p4bZFCehyYy5U9Y33Nf0nSeMrqJvaNpLHg/Crm
         8xjZGQYK6muG8SMQ5kDT/9CU8jxWL09wl1ahg/htk4nTKaothq1yV1J7Oot/9jID/UdN
         PfqA==
X-Gm-Message-State: AOAM533LEMlvPIA3b4C8wCZkxdE/OnJUh4GDBB1CmmfdYhEUo/57D3gu
        UbBFeyriIRaJJho91CqPWIj2PRAAvxY=
X-Google-Smtp-Source: ABdhPJw29b/0fFyJtX5wxY8KVFb2zCD7jrzyjFsJtlVcZkoELYesRJIsd5ew9C3u9p0L9p2Qspv+UQ==
X-Received: by 2002:a17:90b:4a4e:: with SMTP id lb14mr15864480pjb.228.1597738867036;
        Tue, 18 Aug 2020 01:21:07 -0700 (PDT)
Received: from oppo (69-172-89-151.static.imsbiz.com. [69.172.89.151])
        by smtp.gmail.com with ESMTPSA id u65sm23398632pfb.102.2020.08.18.01.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 01:21:06 -0700 (PDT)
Date:   Tue, 18 Aug 2020 16:21:03 +0800
From:   Qingyu Li <ieatmuttonchuan@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/bluetooth/hidp/sock.c: add CAP_NET_RAW check.
Message-ID: <20200818082103.GA2692@oppo>
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
 net/bluetooth/hidp/sock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index 595fb3c9d6c3..3dd9c8e0419a 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -255,6 +255,9 @@ static int hidp_sock_create(struct net *net, struct socket *sock, int protocol,
 	if (sock->type != SOCK_RAW)
 		return -ESOCKTNOSUPPORT;

+	if (!capable(CAP_NET_RAW))
+		return -EPERM;
+
 	sk = sk_alloc(net, PF_BLUETOOTH, GFP_ATOMIC, &hidp_proto, kern);
 	if (!sk)
 		return -ENOMEM;
--
2.17.1

