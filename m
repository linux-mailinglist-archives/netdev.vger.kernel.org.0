Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AF846E9A1
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 15:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238387AbhLIOOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 09:14:00 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:57854 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhLIOOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 09:14:00 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id CBA26200C96B;
        Thu,  9 Dec 2021 15:10:24 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be CBA26200C96B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1639059024;
        bh=3nVVSPqG8CKLxKDGQj8yx3RvZL9TlFIg6XheRFahFI4=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=FiqN4dKQSM2En8yq2t2e1irSmxldo/JfbrNRRrNOCT5qnE/dPkeEY57in7D1NWZ/a
         84UI+djWoTy/gGR6WdyvW+PYkD1GyuQHi/zg/Qymfe5kJcrAfGGU/ynJEnRQKLfEh2
         o0FcIDEF392wgYi+jY+RAmAn+OG89ToPuK5TBmXNAdEUjlH5BmyQ+vNB4l5QGzr+XE
         ZLSRlLRKMwBc/1iaEbtwwAHTY8+SOdcQh4yH8lNwcIMPJCeeTrwN/NyaHE0xegYa2d
         dYOFeh+toHajP9wniM9EYEYyjUTIDFt0UuxN19zUyIZr7H1nHrXcwfnuj6fbLAp08g
         46x34nUCcsP2Q==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id BA9BE6008D5A9;
        Thu,  9 Dec 2021 15:10:24 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RHBR6gHoZDsB; Thu,  9 Dec 2021 15:10:24 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 97FF06008D50B;
        Thu,  9 Dec 2021 15:10:24 +0100 (CET)
Date:   Thu, 9 Dec 2021 15:10:24 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com,
        iamjoonsoo kim <iamjoonsoo.kim@lge.com>,
        akpm@linux-foundation.org, vbabka@suse.cz
Message-ID: <1067680364.223350225.1639059024535.JavaMail.zimbra@uliege.be>
In-Reply-To: <20211208141825.3091923c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211206211758.19057-1-justin.iurman@uliege.be> <20211206161625.55a112bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <262812089.220024115.1638878044162.JavaMail.zimbra@uliege.be> <20211207075037.6cda8832@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1045511371.220520131.1638894949373.JavaMail.zimbra@uliege.be> <20211207090700.55725775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1665643630.220612437.1638900313011.JavaMail.zimbra@uliege.be> <20211208141825.3091923c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF94 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for Buffer occupancy data field
Thread-Index: lo9bTMAPwXOPEVq4KAaNz9YJDLyd/w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> True. But keep also in mind the scope of IOAM which is not to be
>> deployed widely on the Internet. It is deployed on limited (aka private)
>> domains where each node is therefore managed by the operator. So, I'm
>> not really sure why you think that the implementation specific thing is
>> a problem here. Context of "unit" is provided by the IOAM Namespace-ID
>> attached to the trace, as well as each Node-ID if included. Again, it's
>> up to the operator to interpret values accordingly, depending on each
>> node (i.e., the operator has a large and detailed view of his domain; he
>> knows if the buffer occupancy value "X" is abnormal or not for a
>> specific node, he knows which unit is used for a specific node, etc).
> 
> It's quite likely I'm missing the point.

Let me try again to make it all clear on your mind. Here are some quoted
paragraphs from the spec:

  "Generic data: Format-free information where syntax and semantic of
   the information is defined by the operator in a specific
   deployment.  For a specific IOAM-Namespace, all IOAM nodes have to
   interpret the generic data the same way.  Examples for generic
   IOAM data include geo-location information (location of the node
   at the time the packet was processed), buffer queue fill level or
   cache fill level at the time the packet was processed, or even a
   battery charge level."

This one basically says that the IOAM Namespace-ID (in the IOAM Trace
Option-Type header) is responsible for providing context to data fields
(i.e., for "units" too, in case of generic fields such as queue depth or
buffer occupancy). So it's up to the operator to gather similar nodes
within a same IOAM Namespace. And, even if "different" kind of nodes are
within an IOAM Namespace, you still have a fallback solution if Node IDs
are part of the trace (the "hop-lim & node-id" data field, bit 0 in the
trace type). Indeed, the operator (or the collector/interpretor) knows if
node A uses "bytes" or any other units for a generic data field.

  "It should be noted that the semantics of some of the node data fields
   that are defined below, such as the queue depth and buffer occupancy,
   are implementation specific.  This approach is intended to allow IOAM
   nodes with various different architectures."

The last sentence is important here and is, in fact, related to what you
describe below. Having genericity on units for such data fields allows
for supporting multiple architectures. Same idea for the following
paragraph:

  "Data fields and associated data types for each of the IOAM-Data-
   Fields are specified in the following sections.  The definition of
   IOAM-Data-Fields focuses on the syntax of the data-fields and avoids
   specifying the semantics where feasible.  This is why no units are
   defined for data-fields like e.g., "buffer occupancy" or "queue
   depth".  With this approach, nodes can supply the information in
   their native format and are not required to perform unit or format
   conversions.  Systems that further process IOAM information, like
   e.g., a network management system are assumed to also handle unit
   conversions as part of their IOAM data-fields processing.  The
   combination of a particular data-field and the namespace-id provides
   for the context to interpret the provided data appropriately."

Does it make more sense now on why it's not really a problem to have
implementation specific units for such data fields?

>> [...]
>>
>> Do you believe this patch does not provide what is defined in the spec?
>> If so, I'm open to any suggestions.
> 
> The opposite, in a sense. I think the patch does implement behavior
> within a reasonable interpretation of the standard. But the feature
> itself seems more useful for forwarding ASICs than Linux routers,

Good point. Actually, it's probably why such data field was defined as it
is.

> because Linux routers can run a full telemetry stack and all sort
> of advanced SW instrumentation. The use case for reporting kernel
> memory use via IOAM's constrained interface does not seem particularly
> practical since it's not providing a very strong signal on what's
> going on.

I agree and disagree. I disagree because this value definitely tells you
that something (potentially bad) is going on, when it increases
significantly enough to reach a critical threshold. Basically, we need
more skb's, but oh, the pool is exhausted. OK, not a problem, expand the
pool. Oh wait, no memory left. Why? Is it only due to too much
(temporary?) load? Should I put the blame on the NIC? Is it a memory
issue? Is it something else? Or maybe several issues combined? Well, you
might not know exactly why (though you know there is a problem), which is
also why I agree with you. But, this is also why you have other data
fields available (i.e., detecting a problem might require 2+ symptoms
instead of just one).

> For switches running Linux the switch ASIC buffer occupancy can be read
> via devlink-sb that'd seem like a better fit for me, but unfortunately
> the devlink calls can sleep so we can't read such device info from the
> datapath.

Indeed, would be a better fit. I didn't know about this one, thanks for
that. It's a shame it can't be used in this context, though. But, at the
end of the day, we're left with nothing regarding buffer occupancy. So
I'm wondering if "something" is not better than "nothing" in this case.
And, for that, we're back to my previous answer on why I agree and
disagree with what you said about its utility.
