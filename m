Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D82B46C111
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 17:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbhLGQ5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 11:57:52 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:54817 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbhLGQ5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 11:57:51 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 9FC7E200DF98;
        Tue,  7 Dec 2021 17:54:20 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 9FC7E200DF98
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1638896060;
        bh=n5h8FzeGgzXEqqQle82qpupLUwzcL7koe3AYUv3UNDk=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=nMMt76n+/2Z6BjwN9U5sMmP/pcRIFuhMHIgrumaxeHH/PidKx1I0BJGc4pjQn53zg
         VuOlsGEXqHuuThQ8+XPRD6mnaOtdXvthRL3+5fwWEfa/sFz6okLBImSEaXgS2Zk390
         AWGec4bAO/rQ/hj5C20RdW5jxRxy237/j8R4O6BhvB9W+ZELeSRtCclNUcZZZxOnCF
         9HVGESpgadjpKQRitdsYKfDSAv0v9721WnOr1whk8pxnxIqgbvDryuWEnh9QdXfG2V
         ijHtxyY9dUqOwRuVDp1TBrYEYxjGUiypuDKiZVCB/Bmcn/CV9cckv3/9N8yDWwd07v
         aGuAuJv5Bn8wA==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 92C2160309F57;
        Tue,  7 Dec 2021 17:54:20 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OJ4IGATe_JN0; Tue,  7 Dec 2021 17:54:20 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 749226008D842;
        Tue,  7 Dec 2021 17:54:20 +0100 (CET)
Date:   Tue, 7 Dec 2021 17:54:20 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org, linux-mm@kvack.org,
        cl@linux.com, penberg@kernel.org, rientjes@google.com,
        iamjoonsoo kim <iamjoonsoo.kim@lge.com>,
        akpm@linux-foundation.org, vbabka@suse.cz
Message-ID: <1780306528.220542320.1638896060436.JavaMail.zimbra@uliege.be>
In-Reply-To: <ca0f1801-8bbb-6013-cda5-8cf924d51fc6@gmail.com>
References: <20211206211758.19057-1-justin.iurman@uliege.be> <20211206211758.19057-3-justin.iurman@uliege.be> <ca0f1801-8bbb-6013-cda5-8cf924d51fc6@gmail.com>
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF94 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for Buffer occupancy data field
Thread-Index: OPnAWXSx+qj8/fLoEdzv0hG4gKW+dg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

>> [...]
>>
>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
>> ---
>>  include/linux/slab.h | 15 +++++++++++++++
>>  mm/slab.h            | 14 --------------
>>  net/ipv6/ioam6.c     | 13 ++++++++++++-
>>  3 files changed, 27 insertions(+), 15 deletions(-)
>> 
> 
> this should be 2 patches - one that moves the slabinfo struct and
> function across header files and then the ioam6 change.

Agree. I didn't do it since it's "just" a RFC for now though.

> [ I agree with Jakub's line of questioning - how useful is this across
> nodes with different OS'es and s/w versions. ]

See my answer to Jakub. Also, as the draft says:

   "The units of this field
   are implementation specific.  Hence, the units are interpreted within
   the context of an IOAM-Namespace and/or node-id if used.  The authors
   acknowledge that in some operational cases there is a need for the
   units to be consistent across a packet path through the network,
   hence it is recommended for implementations to use standard units
   such as Bytes."

Therefore, what we define here is the behavior of the Linux kernel
regarding the way it handles the buffer occupancy for IOAM, and the
meaning/semantic of its value (in bytes). Having different OS'es and
s/w versions across nodes is not a problem, it's up to the operators
to bring more context to their own domains.
