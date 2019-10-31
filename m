Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F150EB881
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbfJaUlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:41:53 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:33659 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbfJaUlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:41:52 -0400
Received: by mail-il1-f196.google.com with SMTP id s6so6708021iln.0
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 13:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mKI0y2oFiFckExZRdMUfYw+OEUayJVMbJHlBqNKBhj8=;
        b=gox9+Jk+QENDuJyoSp9cXgM8i9qRcGudQMqWuFwpk4QQewpvy/lHTgjevRLMjNzoK+
         4kHQoQuLACrK5iIv0ID/2s1EJAvILRRHbVH8FqiVrfOpY18d6l8xaTzvNylmPZYc4dT3
         Y9qjs9fsK38/xlFJL5wQKVbFDsby/3zONa7+B2zC+wSVURr6ieWdROK0ySy6P+5J5aS9
         maknEVFDBARHC+b4ZVWh86fj8t/jO98+kSy9CwNU4deR0xAR7XszmEZf1IwpuH4o2Rpi
         tC+R87TUZeFAuDe11RMvetHsrjpGmW/F5qGo6VXXuFCqmCYM66Zr93Tlmpl2xFNQ5GgD
         m2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mKI0y2oFiFckExZRdMUfYw+OEUayJVMbJHlBqNKBhj8=;
        b=uYPPeapMCrYGkvQiOJlNq5PC/oiYz17MEvhZ+Jt5tWM/fZko9Jhyx/LfJB4+YVioe3
         kDnD1ukBeLQAmAexEqTpdHZ3bEpCogk6yDjbNMh37V8/3GbR7GmLH0+t80veX+SGKQ29
         +kFhcYQ4Neh8pXGzMB6zv3FDklUIDKiRPByX9J/0ZY+pJ+oa+7vwtMBwa+CwcF1Bv82P
         DR/tBI0hILyg8wxoSKWfEcT8EBX9H4yujnDElEDuso/DZhvTGqY2hYQ/QQjK775wovqN
         Q4vakKJf0B/NMa+JnU2+7RF/Ls37tfsC7/OB3794vqgg4mJnCazLfVx/rAvO2SyLY01z
         fS1Q==
X-Gm-Message-State: APjAAAU2NPPg7+ZQor3/EEzqsNzdry7/BMyYZGuQUt+JRk228pAbdg9d
        K6EI7uGTY3KJY/btuxJCFShHqvoH
X-Google-Smtp-Source: APXvYqy4chlkh+D4jOuv2zoN9sj1j6SCqrsrXM27XklbOtj4V0h3NJvzP+XQwI9exxiE2EHq00S5wA==
X-Received: by 2002:a92:a308:: with SMTP id a8mr7950597ili.65.1572554511390;
        Thu, 31 Oct 2019 13:41:51 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:e0f1:25db:d02a:8fc2])
        by smtp.googlemail.com with ESMTPSA id e72sm415479iof.63.2019.10.31.13.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 13:41:50 -0700 (PDT)
Subject: Re: [Possible regression?] ip route deletion behavior change
To:     Hendrik Donner <hd@os-cillation.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <603d815f-f6db-3967-c0df-cbf084a1cbcd@os-cillation.de>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9384f54f-67a0-f2dc-68f8-3216717ee63e@gmail.com>
Date:   Thu, 31 Oct 2019 14:41:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <603d815f-f6db-3967-c0df-cbf084a1cbcd@os-cillation.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 9:44 AM, Hendrik Donner wrote:
> Hello,
> 
> analyzing a network issue on our embedded system product i found a change in behavior 
> regarding the removal of routing table entries when an IP address is removed.
> 
> On older kernel releases before commit 5a56a0b3a45dd0cc5b2f7bec6afd053a474ed9f5
> (simplified example):
> 
> Routing table:
> 
> # ip r
> default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 1024
> 10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15
> 10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 1024
> 10.20.0.0/14 via 10.0.2.2 dev enp0s3 src 10.20.40.100
> 
> The last route was manually added with ip r add.
> 
> Removing the IP 10.20.40.100 from enp0s3 also removes the last route:
> 
> # ip r
> default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 1024
> 10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15
> 10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 1024
> 
> After the mentioned commit - so since v4.10 - the route will no longer be removed. At 
> least for my team that's a surprising change in behavior because our system relies on
> the old behavior.
> 
> Reverting the commit restores the old behavior.
> 
> I'm aware that our use case is a bit odd, but according to the commit message commit 
> 5a56a0b3a45dd0cc5b2f7bec6afd053a474ed9f5 was meant to fix VRF related behavior while
> having the described (maybe unintended?) user visible side effect for non-VRF usage.
> 

devices not associated with a VRF table are implicitly tied to the
default == main table.

Can you test this change:

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 0913a090b2bf..f1888c683426 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1814,8 +1814,8 @@ int fib_sync_down_addr(struct net_device *dev,
__be32 local)
        int ret = 0;
        unsigned int hash = fib_laddr_hashfn(local);
        struct hlist_head *head = &fib_info_laddrhash[hash];
+       int tb_id = l3mdev_fib_table(dev) ? : RT_TABLE_MAIN;
        struct net *net = dev_net(dev);
-       int tb_id = l3mdev_fib_table(dev);
        struct fib_info *fi;

        if (!fib_info_laddrhash || local == 0)

[ As DaveM noted, you should cc maintainers and author(s) of suspected
regression patches ]
