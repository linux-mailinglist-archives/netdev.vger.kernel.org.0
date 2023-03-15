Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3BB66BB4DC
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjCONiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjCONiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:38:52 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C80D7EFC;
        Wed, 15 Mar 2023 06:38:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5D8B31FD76;
        Wed, 15 Mar 2023 13:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1678887528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wQFuKBaF6WvGk6vzttY4i4tA7syyP5hs6IrhdtonffA=;
        b=cqxP2twoRj+fcrs/+8lehtiDgnL4jr0LNZ6a5rdur0lBr0tEWrBncWCbZJ6/bK8EyWpU4x
        gZ0F+4c+4+XXRkr56WDNiSySqXnP6VfvK3ui99h+DhlZDvTySsKKDiEo77yQOun5YA6Xyt
        sgYbKyd2dOq4T+lsVt4cYW7F2JRPFGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1678887528;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wQFuKBaF6WvGk6vzttY4i4tA7syyP5hs6IrhdtonffA=;
        b=w6coZ/Uw88fhU8aHcGl6eDCI1gHVg0UOGUkVaXsHulRwjbstUIgG9UCupGjq6fQNmDKLo6
        x/lC0q/mxOCeVZCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0211513A2F;
        Wed, 15 Mar 2023 13:38:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id e+dPO2fKEWQSLwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 15 Mar 2023 13:38:47 +0000
Message-ID: <14043bee-af7d-38f3-5a46-f63940e56c1e@suse.cz>
Date:   Wed, 15 Mar 2023 14:38:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 7/7] mm/slab: document kfree() as allowed for
 kmem_cache_alloc() objects
Content-Language: en-US
To:     Mike Rapoport <mike.rapoport@gmail.com>
Cc:     Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-8-vbabka@suse.cz> <ZA2ic9JYXGVzps1+@kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <ZA2ic9JYXGVzps1+@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/23 10:59, Mike Rapoport wrote:
> On Fri, Mar 10, 2023 at 11:32:09AM +0100, Vlastimil Babka wrote:
>> This will make it easier to free objects in situations when they can
>> come from either kmalloc() or kmem_cache_alloc(), and also allow
>> kfree_rcu() for freeing objects from kmem_cache_alloc().
>> 
>> For the SLAB and SLUB allocators this was always possible so with SLOB
>> gone, we can document it as supported.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: "Paul E. McKenney" <paulmck@kernel.org>
>> Cc: Frederic Weisbecker <frederic@kernel.org>
>> Cc: Neeraj Upadhyay <quic_neeraju@quicinc.com>
>> Cc: Josh Triplett <josh@joshtriplett.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
>> Cc: Joel Fernandes <joel@joelfernandes.org>
>> ---
>>  Documentation/core-api/memory-allocation.rst | 15 +++++++++++----
>>  include/linux/rcupdate.h                     |  6 ++++--
>>  mm/slab_common.c                             |  5 +----
>>  3 files changed, 16 insertions(+), 10 deletions(-)
>> 
>> diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
>> index 5954ddf6ee13..f9e8d352ed67 100644
>> --- a/Documentation/core-api/memory-allocation.rst
>> +++ b/Documentation/core-api/memory-allocation.rst
>> @@ -170,7 +170,14 @@ should be used if a part of the cache might be copied to the userspace.
>>  After the cache is created kmem_cache_alloc() and its convenience
>>  wrappers can allocate memory from that cache.
>>  
>> -When the allocated memory is no longer needed it must be freed. You can
>> -use kvfree() for the memory allocated with `kmalloc`, `vmalloc` and
>> -`kvmalloc`. The slab caches should be freed with kmem_cache_free(). And
>> -don't forget to destroy the cache with kmem_cache_destroy().
>> +When the allocated memory is no longer needed it must be freed. Objects
> 
> I'd add a line break before Objects                               ^
> 
>> +allocated by `kmalloc` can be freed by `kfree` or `kvfree`.
>> +Objects allocated by `kmem_cache_alloc` can be freed with `kmem_cache_free`
>> +or also by `kfree` or `kvfree`, which can be more convenient as it does
> 
> Maybe replace 'or also by' with a coma:
> 
> Objects allocated by `kmem_cache_alloc` can be freed with `kmem_cache_free`,
> `kfree` or `kvfree`, which can be more convenient as it does

But then I need to clarify what the "which" applies to?

> 
>> +not require the kmem_cache pointed.
> 
>                              ^ pointer.
> 
>> +The rules for _bulk and _rcu flavors of freeing functions are analogical.
> 
> Maybe 
> 
> The same rules apply to _bulk and _rcu flavors of freeing functions.

So like this incremental diff?

diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
index f9e8d352ed67..1c58d883b273 100644
--- a/Documentation/core-api/memory-allocation.rst
+++ b/Documentation/core-api/memory-allocation.rst
@@ -170,12 +170,14 @@ should be used if a part of the cache might be copied to the userspace.
 After the cache is created kmem_cache_alloc() and its convenience
 wrappers can allocate memory from that cache.
 
-When the allocated memory is no longer needed it must be freed. Objects
-allocated by `kmalloc` can be freed by `kfree` or `kvfree`.
-Objects allocated by `kmem_cache_alloc` can be freed with `kmem_cache_free`
-or also by `kfree` or `kvfree`, which can be more convenient as it does
-not require the kmem_cache pointed.
-The rules for _bulk and _rcu flavors of freeing functions are analogical.
+When the allocated memory is no longer needed it must be freed.
+
+Objects allocated by `kmalloc` can be freed by `kfree` or `kvfree`. Objects
+allocated by `kmem_cache_alloc` can be freed with `kmem_cache_free`, `kfree`
+or `kvfree`, where the latter two might be more convenient thanks to not
+needing the kmem_cache pointer.
+
+The same rules apply to _bulk and _rcu flavors of freeing functions.
 
 Memory allocated by `vmalloc` can be freed with `vfree` or `kvfree`.
 Memory allocated by `kvmalloc` can be freed with `kvfree`.

