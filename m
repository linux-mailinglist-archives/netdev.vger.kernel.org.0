Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECED2162FA
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 02:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgGGAZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 20:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgGGAZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 20:25:46 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F4EC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 17:25:46 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id k18so36645120qke.4
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 17:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lfQM2j8ID42GuSnytC7+EbvegsKv4a7VePL+Vx70p/0=;
        b=R5rjX2767+OUEP3hNKSZwKF9BEu9sEjVxVDBI9NI6Nr0LYZTGodiSStMVLnkVKWVQP
         hrWRtKzvLpD3139eOISY+QTUsHB7hxKIsulKjYtCe/V/AfhxbzW5mrGZdmqshIY4NiJU
         S9RUFMugPE4WPoejp4Y+8sNJ16rVJVo3Is3nD2uSVALmRhGRGQKlxrKwCE4BnES7ZFvz
         iKlL33p+U1NUl01XRoiWhA0kdZfOlbF5Cw/SDEZZ3DRQiudRyernS2XmXsLEOuOo/j+L
         0PUA2b5Ngq3YZ9MyABcanwkrTdDsOEkQaQNVtJZ+dLQ++/lbE9QSvuBZf5uMN6bd4HKA
         zB7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lfQM2j8ID42GuSnytC7+EbvegsKv4a7VePL+Vx70p/0=;
        b=oTHwS0pZ4WFR9K7c0wMJftIF0BtEFNMrl07p4McOvpxZRwyHt0e686IA5P9uZRKGMG
         0aP+03hKGKSEeILQ7tkod7o88GhUMLSOlYrwBoaDS6ntltBEXGf7+xkDmzKQi3mWdsR9
         SEm7e/+jK+oN1a50mYycuRMX4igZ2Sl1g9SeHfAfVq/j6spD6RAYzkr7oEI4TLOjw65A
         BcwFPaGVmjeH8DhtuKZKq0O3CZqF+6OeAY90r5l7q4xyLO5QU0b+PFu8O4A56kBs41Fy
         Dcy3VHuIr+UnMExi9j6M4whbU4+MGIpAhZk7r+VP59RPpH4x8hMyuNWzNSYVX+Ng90OH
         LqhQ==
X-Gm-Message-State: AOAM532XU9bkZjDbMbDgwLNuEpJR8yHm9ZVUA/G1fjUa8K2hnWQL36m8
        kRvxoIENuKWNzu6yTI8iPNNVjsBC
X-Google-Smtp-Source: ABdhPJyk4CjeBs97hV6USStna5qjyTkkr864wdET9iKDpjIGjcRYQUT6OmhNOA+/jjiWJx+Zs05yyg==
X-Received: by 2002:a37:e217:: with SMTP id g23mr50687039qki.108.1594081545721;
        Mon, 06 Jul 2020 17:25:45 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:e8c0:721c:c5ae:c15b? ([2601:282:803:7700:e8c0:721c:c5ae:c15b])
        by smtp.googlemail.com with ESMTPSA id r6sm13514981qtt.81.2020.07.06.17.25.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 17:25:44 -0700 (PDT)
Subject: Re: PROBLEM: can't ping anycast IPv6 address on lo interface
To:     thomas.gambier@nexedi.com, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, Julien Muchembled <jm@nexedi.com>,
        Jean-Paul Smets <jp@nexedi.com>
References: <fcb3d6853922beec880dda255e249288@nexedi.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4a87a3f2-8960-b7dc-47c0-1801d92b544e@gmail.com>
Date:   Mon, 6 Jul 2020 18:25:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fcb3d6853922beec880dda255e249288@nexedi.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ sorry for the delay; on PTO for a couple weeks ]

On 6/26/20 3:20 AM, thomas.gambier@nexedi.com wrote:
> Hello,
> 
> this is the first time I report a bug to the kernel team. Please let me
> know if there are any missing information or if I should post on
> bugzilla instead.
> 
> 
> Since Linux 5.2, I can't ping anycast address on lo interface.
> 
> If you enable IPv6 forwarding for an interface and add a IPv6 address
> range on this interface, it is possible to ping the addres 0 of the
> range (anycast address). This doesn't work for "lo" interface since
> Linux 5.2.
> 
> I bisected to find that the commit
> c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
> (https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43)
> introduced the regression. Please note that the regression is still
> present on master branch of net repository (commit
> 2570284060b48f3f79d8f1a2698792f36c385e9a from yesterday).
> 
> I attach my config file to this email (this config was used to compile
> latest master branch).
> 
> In order to reproduce you can use this small script:
> 
> root@kernel-compil-vm:~# cat test.bash
> #! /bin/bash
> echo 1 >  /proc/sys/net/ipv6/conf/all/forwarding
> ip -6 a add fc12::1/16 dev lo
> sleep 2
> echo "pinging lo"
> ping6 -c 2 fc12::
> 

Thanks for the quick reproducer.

> 
> Before the regression you will see:
> pinging lo
> PING fc12::(fc12::) 56 data bytes
> 64 bytes from fc12::1: icmp_seq=1 ttl=64 time=0.111 ms
> 64 bytes from fc12::1: icmp_seq=2 ttl=64 time=0.062 ms
> 
> 
> After the regression you will see:
> pinging lo
> PING fc12::(fc12::) 56 data bytes
> From fc12::: icmp_seq=1 Destination unreachable: No route
> From fc12::: icmp_seq=2 Destination unreachable: No route
> 

This solves the problem for me; can you try it out in your environment?

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index ea0be7cf3d93..f3279810d765 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3405,7 +3405,7 @@ static bool fib6_is_reject(u32 flags, struct
net_device *dev, int addr_type)
        if ((flags & RTF_REJECT) ||
            (dev && (dev->flags & IFF_LOOPBACK) &&
             !(addr_type & IPV6_ADDR_LOOPBACK) &&
-            !(flags & RTF_LOCAL)))
+            !(flags & (RTF_ANYCAST | RTF_LOCAL))))
                return true;

        return false;
