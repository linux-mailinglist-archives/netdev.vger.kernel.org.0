Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4041632CA
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgBRUQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:16:27 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39536 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgBRUQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:16:23 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so25516511wrt.6;
        Tue, 18 Feb 2020 12:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ot6ftoBvywFIPbQBl7QRXXyQKytR59k2PPdj1umDHHE=;
        b=mwjU0e8lGOQLNEe4L13MCWGOUaA2tOW1fWokTjK2gVzlu0TRM7uiHTiJl96OIGUcFk
         AkkohWT3v27SOLagAUNF7s7m77CMlknD85iZ5w5FKumFSL12F3indLSVaBBi2n5rfb0q
         U4c2aJbvRv6uJeIn1wRhu04OmmguXzGHh+/xev4K8CC6cYkqNs6w5sTONC6xdtwNYvgi
         i7dyFw2XVhRRMtF9pk9zfMJVe0CPlRzZt08bCicHsCvcET8l+BM3nTREQmpIbaNFJ/vq
         ck3AqHaxugwc2ZK++6VZcVebQUJCbrvrZCE+SUnulF+E/2z16ZB2m+GzIgfSMwGb3zT1
         FDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ot6ftoBvywFIPbQBl7QRXXyQKytR59k2PPdj1umDHHE=;
        b=sCXd4CtwJagi/4OtPAM5pcqcgSsuhDPkA94ASLQqjnFRg4mGx47k8smHzQx7NkXB1g
         JJh7tUoa4ZTGOykyME39GYS9Gy77ct1x8/pThzhriusR67NiMnNSoCuf0HqongNO+3m9
         IVxaTrNfcq2hZ5O6NZ2nBlwbAiOhAuP9KSjXCMvKuwK8eduB1SA56EjCNCW8FrfM0QlU
         fcOON5EgQzIt4qeQYlyO9+jEaYqG637QKYleWZM/Jj8qpHT4y0MvEDj+cApSqQR5eHHN
         mISEoKhBRE2lLwO2njQyOomYDvqwamb89IzjFzph5kWOA+r81pVVEXNwMxldDoAER+mK
         gZZg==
X-Gm-Message-State: APjAAAVhEwv4yGlaHBFLsfMYtaqcEkgr8WECselnSQeGHGcPFizlelo9
        i4EwoSkAnwAdGmjHwa5tKNd1P0ml
X-Google-Smtp-Source: APXvYqxJQGTDEBu/gswzJM8KSbgz12pSk/OeKS6xYG8/W7JgZ1WY4LxyyAhWwNjARpc1m9rf8mztxw==
X-Received: by 2002:adf:f091:: with SMTP id n17mr29853689wro.387.1582056981873;
        Tue, 18 Feb 2020 12:16:21 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id s65sm4859862wmf.48.2020.02.18.12.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:16:21 -0800 (PST)
Subject: [PATCH net-next v2 13/13] vmxnet3: use new helper
 tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Message-ID: <b0b506d9-29b2-c1be-9f88-0c9a8c9e63fe@gmail.com>
Date:   Tue, 18 Feb 2020 21:13:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new helper tcp_v6_gso_csum_prep in additional network drivers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 18f152fa0..722cb054a 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -942,10 +942,7 @@ vmxnet3_prepare_tso(struct sk_buff *skb,
 		tcph->check = ~csum_tcpudp_magic(iph->saddr, iph->daddr, 0,
 						 IPPROTO_TCP, 0);
 	} else if (ctx->ipv6) {
-		struct ipv6hdr *iph = ipv6_hdr(skb);
-
-		tcph->check = ~csum_ipv6_magic(&iph->saddr, &iph->daddr, 0,
-					       IPPROTO_TCP, 0);
+		tcp_v6_gso_csum_prep(skb);
 	}
 }
 
-- 
2.25.1


