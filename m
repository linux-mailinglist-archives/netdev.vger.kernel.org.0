Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A640B46BA73
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 12:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbhLGL5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 06:57:37 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:39722 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhLGL5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 06:57:36 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 73CEF2011FC5;
        Tue,  7 Dec 2021 12:54:04 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 73CEF2011FC5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1638878044;
        bh=h0esAj2xKshe76Bcdcb7j84+3ZjwY3yEI4Sjor/fygY=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=NIGDNM4Fl3gIhz9ZecMtgDv0BvV1HlVcFlmdf/vbiO7CoQ4yeftfbRTW4+sf/Zx50
         9yB2QnrOt+5XIcVfgcy5ua1EJwnhLPfwtD5RzG5GM7UHBJFvAAqoSdTSIeaDRRfNlE
         fL9U3v7gvRRTvZm0b9IGBYIW0Mhm/W8AoC2pFeskWlbqn88JE7vyo//yuuSRmDQoX2
         JfLHYf4NcxTes+0OhxGa7vScLp72cPoRdSOnalcC41O/jjw5948p//0cbBYvsH4Y4Y
         V4H8RF2uKhM4zqWIepWyIGaUMzamiJNgmPEf5jOR9kAr2/KPTI8Dl2Satd8y99I8xE
         6Dnu/u2L9fGRg==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 6645F6016F3FB;
        Tue,  7 Dec 2021 12:54:04 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id F8dmo4N07pEJ; Tue,  7 Dec 2021 12:54:04 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 438536008D432;
        Tue,  7 Dec 2021 12:54:04 +0100 (CET)
Date:   Tue, 7 Dec 2021 12:54:04 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com,
        iamjoonsoo kim <iamjoonsoo.kim@lge.com>,
        akpm@linux-foundation.org, vbabka@suse.cz
Message-ID: <262812089.220024115.1638878044162.JavaMail.zimbra@uliege.be>
In-Reply-To: <20211206161625.55a112bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211206211758.19057-1-justin.iurman@uliege.be> <20211206211758.19057-3-justin.iurman@uliege.be> <20211206161625.55a112bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF94 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for Buffer occupancy data field
Thread-Index: YNRqiUsLNmHepOUpxfeZtjCAUfYBYQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

>> [...]
>>
>> The function kmem_cache_size is used to retrieve the size of a slab
>> object. Note that it returns the "object_size" field, not the "size"
>> field. If needed, a new function (e.g., kmem_cache_full_size) could be
>> added to return the "size" field. To match the definition from the
>> draft, the number of bytes is computed as follows:
>> 
>> slabinfo.active_objs * size
>> 
>> Thoughts?
> 
> Implementing the standard is one thing but how useful is this
> in practice?

IMHO, very useful. To be honest, if I were to implement only a few data
fields, these two would be both included. Take the example of CLT [1]
where the queue length data field is used to detect low-level issues
from inside a L5-7 distributed tracing tool. And this is just one
example among many others. The queue length data field is very specific
to TX queues, but we could also use the buffer occupancy data field to
detect more global loads on a node. Actually, the goal for operators
running their IOAM domain is to quickly detect a problem along a path
and react accordingly (human or automatic action). For example, if you
monitor TX queues along a path and detect an increasing queue on a
router, you could choose to, e.g.,  rebalance its queues. With the
buffer occupancy, you could detect high-loaded nodes in general and,
e.g., rebalance traffic to another branch. Again, this is just one
example among others. Apart from more accurate ECMPs, you could for
instance deploy a smart (micro)service selection based on different
metrics, etc.

  [1] https://github.com/Advanced-Observability/cross-layer-telemetry
