Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8128F19D996
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 16:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404125AbgDCO4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 10:56:06 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:54324 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404117AbgDCO4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 10:56:05 -0400
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 8AA382E14B4;
        Fri,  3 Apr 2020 17:56:02 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id ysZoBl8NAD-u19ewH8K;
        Fri, 03 Apr 2020 17:56:02 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1585925762; bh=Q7u3ANbO873KS0xB1AbSi27nApxQH0XfixpEWRWSarw=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=J6f1621N+JkGjuHiNs0fLjRg3rqlb5JEvKks79Yh6gBTXRN8g2wXq65tTVJ1QCYf2
         WIumpNhxdwK8ZKcQ/IkNJNH93yaiVHKhcjr5LiC++PYqpLxnEdqiRCIaegB/5Uxaxa
         ZkZiPi4CFs9Nj9IPk0+iAWwQpvYwovMIBYVKmWZg=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [2a02:6b8:b080:8910::1:6])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id yQV6sUDxJj-u1WWXO1Z;
        Fri, 03 Apr 2020 17:56:01 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH v3 net] inet_diag: add cgroup id attribute
To:     Tejun Heo <tj@kernel.org>
Cc:     Dmitry Yakunin <zeil@yandex-team.ru>, davem@davemloft.net,
        netdev@vger.kernel.org, cgroups@vger.kernel.org,
        bpf@vger.kernel.org
References: <20200403095627.GA85072@yandex-team.ru>
 <20200403133817.GW162390@mtj.duckdns.org>
 <c28be8aa-d91c-3827-7e99-f92ad05ef6f1@yandex-team.ru>
 <20200403144505.GZ162390@mtj.duckdns.org>
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Message-ID: <20ba0af2-66df-00da-104a-512990c316d8@yandex-team.ru>
Date:   Fri, 3 Apr 2020 17:56:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200403144505.GZ162390@mtj.duckdns.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/04/2020 17.45, Tejun Heo wrote:
> On Fri, Apr 03, 2020 at 05:37:17PM +0300, Konstantin Khlebnikov wrote:
>>> How would this work with things like inetd? Would it make sense to associate the
>>> socket on the first actual send/recv?
>>
>> First send/recv seems too intrusive.
> 
> Intrusive in terms of?

In term of adding more code to networking fast paths.

> 
>> Setsockopt to change association to current cgroup (or by id) seems more reasonable.
> 
> I'm not sure about exposing it as an explicit interface.

Yep, it's better to create thing in right place from the beginning.
Current behaviour isn't bad, just not obvious (and barely documented).
That's why I've asked Dmitry to add these notes.

> 
> Thanks.
> 
