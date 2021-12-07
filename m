Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15D346C0D1
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 17:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhLGQj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 11:39:26 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:53530 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhLGQjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 11:39:22 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 92BFB200F81B;
        Tue,  7 Dec 2021 17:35:49 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 92BFB200F81B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1638894949;
        bh=kCTMHmqBI/ompkL5Jcr5fy8SFmAAf7AcqDUt71hh6iI=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=QUcrWDBRVdeof0Tamz/6wWdRNkuTRM+2DV/WAYNedOIXmSo79HDP/JPcfchkIR7nH
         ZI/h4Zss710v8QwUCcq7XKzntGrurML9s5akt6k0eBR1qa6r/eJl0MWk1zNo9N7hl4
         kgJnhHDKeiSExcM5AXRgsGMveB6cS5kAnbtHOoXEkU8pq/25Ab277MmwLfDTKodPy8
         KNe5oDgRQqo06gfyuTf+bjYZuVTTSqxAtT4c9Bc01zTV9l5mTy25J34SR9aQGWlwhZ
         u7F0FLeq3MJWiRqH4hOT6q522Euxy2BMtIQACHUzQlhTju/Od+J66YROlmFtqlNYXi
         BPAXeZzpRHS5Q==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 858C260225373;
        Tue,  7 Dec 2021 17:35:49 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yUnivlg35vCE; Tue,  7 Dec 2021 17:35:49 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 688BF6008D79D;
        Tue,  7 Dec 2021 17:35:49 +0100 (CET)
Date:   Tue, 7 Dec 2021 17:35:49 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com,
        iamjoonsoo kim <iamjoonsoo.kim@lge.com>,
        akpm@linux-foundation.org, vbabka@suse.cz
Message-ID: <1045511371.220520131.1638894949373.JavaMail.zimbra@uliege.be>
In-Reply-To: <20211207075037.6cda8832@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211206211758.19057-1-justin.iurman@uliege.be> <20211206211758.19057-3-justin.iurman@uliege.be> <20211206161625.55a112bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <262812089.220024115.1638878044162.JavaMail.zimbra@uliege.be> <20211207075037.6cda8832@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF94 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for Buffer occupancy data field
Thread-Index: Avbm4/re1gCK09gzGU7eD5s9hVgDug==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Dec 7, 2021, at 4:50 PM, Jakub Kicinski kuba@kernel.org wrote:
> On Tue, 7 Dec 2021 12:54:04 +0100 (CET) Justin Iurman wrote:
>> >> The function kmem_cache_size is used to retrieve the size of a slab
>> >> object. Note that it returns the "object_size" field, not the "size"
>> >> field. If needed, a new function (e.g., kmem_cache_full_size) could be
>> >> added to return the "size" field. To match the definition from the
>> >> draft, the number of bytes is computed as follows:
>> >> 
>> >> slabinfo.active_objs * size
>> > 
>> > Implementing the standard is one thing but how useful is this
>> > in practice?
>> 
>> IMHO, very useful. To be honest, if I were to implement only a few data
>> fields, these two would be both included. Take the example of CLT [1]
>> where the queue length data field is used to detect low-level issues
>> from inside a L5-7 distributed tracing tool. And this is just one
>> example among many others. The queue length data field is very specific
>> to TX queues, but we could also use the buffer occupancy data field to
>> detect more global loads on a node. Actually, the goal for operators
>> running their IOAM domain is to quickly detect a problem along a path
>> and react accordingly (human or automatic action). For example, if you
>> monitor TX queues along a path and detect an increasing queue on a
>> router, you could choose to, e.g.,  rebalance its queues. With the
>> buffer occupancy, you could detect high-loaded nodes in general and,
>> e.g., rebalance traffic to another branch. Again, this is just one
>> example among others. Apart from more accurate ECMPs, you could for
>> instance deploy a smart (micro)service selection based on different
>> metrics, etc.
>> 
>>   [1] https://github.com/Advanced-Observability/cross-layer-telemetry
> 
> Ack, my question was more about whether the metric as implemented

Oh, sorry about that.

> provides the best signal. Since the slab cache scales dynamically
> (AFAIU) it's not really a big deal if it's full as long as there's
> memory available on the system.

Well, I got the same understanding as you. However, we do not provide a
value meaning "X percent used" just because it wouldn't make much sense,
as you pointed out. So I think it is sound to have the current value,
even if it's a quite dynamic one. Indeed, what's important here is to
know how many bytes are used and this is exactly what it does. If a node
is under heavy load, the value would be hell high. The operator could
define a threshold for each node resp. and detect abnormal values.

We probably want the metadata included for accuracy as well (e.g.,
kmem_cache_size vs new function kmem_cache_full_size).
