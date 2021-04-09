Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F83359E67
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 14:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhDIML4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 08:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbhDIMLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 08:11:53 -0400
Received: from forward101p.mail.yandex.net (forward101p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D210FC061760
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 05:11:40 -0700 (PDT)
Received: from sas1-892da86383b1.qloud-c.yandex.net (sas1-892da86383b1.qloud-c.yandex.net [IPv6:2a02:6b8:c08:78a8:0:640:892d:a863])
        by forward101p.mail.yandex.net (Yandex) with ESMTP id 809E43281805;
        Fri,  9 Apr 2021 15:11:36 +0300 (MSK)
Received: from sas1-f4dc5f2fc86f.qloud-c.yandex.net (sas1-f4dc5f2fc86f.qloud-c.yandex.net [2a02:6b8:c08:cb28:0:640:f4dc:5f2f])
        by sas1-892da86383b1.qloud-c.yandex.net (mxback/Yandex) with ESMTP id nW4Xx3ouN3-BaJCNsND;
        Fri, 09 Apr 2021 15:11:36 +0300
Authentication-Results: sas1-892da86383b1.qloud-c.yandex.net; dkim=pass
Received: by sas1-f4dc5f2fc86f.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id mw0DzMN0sO-BZKCvKsP;
        Fri, 09 Apr 2021 15:11:35 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [BUG / question] in routing rules, some options (e.g. ipproto,
 sport) cause rules to be ignored in presence of packet marks
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
References: <babb2ebf-862a-d05f-305a-e894e88f601e@yandex.pl>
 <YGI99fyA6MYKixuB@shredder.lan>
From:   Michal Soltys <msoltyspl@yandex.pl>
Message-ID: <24ebb842-cb3a-e1a2-c83d-44b4a5757200@yandex.pl>
Date:   Fri, 9 Apr 2021 14:11:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YGI99fyA6MYKixuB@shredder.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/21 10:52 PM, Ido Schimmel wrote:
> 
> ip_route_me_harder() does not set source / destination port in the
> flow key, so it explains why fib rules that use them are not hit after
> mangling the packet. These keys were added in 4.17, but I
> don't think this use case every worked. You have a different experience?
> 

So all the more recent additions to routing rules - src port, dst port, 
uid range and ipproto - are not functioning correctly with the second 
routing check.

Are there plans to eventually fix that ?

While I just adjusted/rearranged my stuff to not rely on those, it 
should probably be at least documented otherwise (presumably in ip-rule 
manpage and perhaps in `ip rule help` as well).
