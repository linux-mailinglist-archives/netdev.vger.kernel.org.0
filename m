Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E9B248047
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 10:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgHRIQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 04:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgHRIP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 04:15:59 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AB6C061389;
        Tue, 18 Aug 2020 01:15:59 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o5so9421042pgb.2;
        Tue, 18 Aug 2020 01:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=efKFji4wZbV4ryr84E81ykO6FthaFggVytOSX8yMq3Y=;
        b=j+erm+9yXM4DR4o7ac1+SNFpUbtVt7I+meQmJ9mwt1rWnlVx3+DV0yFmieYZ9XpIUz
         fj9fyWBBf0gLW3MQKfglYyXP62+cvv12b+wuDmpcOqZDvXab83Hf+/cMrnmlNSaItrO1
         CpIw1hvTMf+QACLdXFmi7Y/BI3Ohgo17bIrAkONlOeYksHZ7jjNNYJWzRMdTENdsGqjO
         PpG0yz734CNm3MvjDxWeG7hNf44ABwTgVnkf+CTRyIEWBaGklzmuAupD5C2idxmBfCPy
         DruKenMqsbuJLjKLMpFo3J095x95IG9MMeoeCDmExu/OyAJUWoYwgZ7D5/+c7hkNDF3H
         ITJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=efKFji4wZbV4ryr84E81ykO6FthaFggVytOSX8yMq3Y=;
        b=r3IE5poXfBQCalz4YvMP01y5oHZm8c0246lXhlrX3snH+CCU48qVN4q73cD9l9yQ/y
         g26X6MpcnLK1tlofc1o+IADaqZKhzFELX2mErQD7wD/zOhrxGDsEMcPSzWDFPoo83r9+
         5hGYnIbIW6nd3Nbv+XQOWPEZThND5R9JM/jEINMaDIQ3vFW/T6utcjScSnacZqkoFsTs
         nFCLWQF2KXYp/8SptEG8fgHAU0FhW2dlJBrgd7bUAiD0LczKsfXwjjMmLPW7DEcS8LEx
         5MshqqfQuhUC/XjbwfsXNtZ7ahqRrFbvp111EDOT4kibk2n9rR8TYDx5UxEuekjA/lRM
         w4dQ==
X-Gm-Message-State: AOAM530Nsy8QmhAjXPUJnaybATvY8te2LhR0ShKpB1wV0ZFtGy4NX4Z0
        ZLXpw3YkSj85m9fNfnt5pcLx+TvPT+M=
X-Google-Smtp-Source: ABdhPJyHJGPp/aTkTMW7Ie/M2t3v4BMfISMnMoQO4IWHF2fIZIMsBP0/H7MRTu+ep8AUqS87MVWcQA==
X-Received: by 2002:a62:9254:: with SMTP id o81mr14137225pfd.73.1597738558202;
        Tue, 18 Aug 2020 01:15:58 -0700 (PDT)
Received: from oppo (69-172-89-151.static.imsbiz.com. [69.172.89.151])
        by smtp.gmail.com with ESMTPSA id d13sm23367913pfq.118.2020.08.18.01.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 01:15:57 -0700 (PDT)
Date:   Tue, 18 Aug 2020 16:15:55 +0800
From:   Qingyu Li <ieatmuttonchuan@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        kuba@kernel.org, isdn@linux-pingi.de
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/bluetooth/cmtp/sock.c: add CAP_NET_RAW check.
Message-ID: <20200818081555.GA1349@oppo>
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
 net/bluetooth/cmtp/sock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
index 96d49d9fae96..476ccc9bee7c 100644
--- a/net/bluetooth/cmtp/sock.c
+++ b/net/bluetooth/cmtp/sock.c
@@ -207,6 +207,9 @@ static int cmtp_sock_create(struct net *net, struct socket *sock, int protocol,
 	if (sock->type != SOCK_RAW)
 		return -ESOCKTNOSUPPORT;

+	if (!capable(CAP_NET_RAW))
+		return -EPERM;
+
 	sk = sk_alloc(net, PF_BLUETOOTH, GFP_ATOMIC, &cmtp_proto, kern);
 	if (!sk)
 		return -ENOMEM;
--
2.17.1

