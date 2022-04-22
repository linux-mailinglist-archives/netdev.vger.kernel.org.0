Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43F650C0F2
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 23:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiDVVKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 17:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiDVVKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 17:10:14 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C827225FD7
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 13:05:57 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id w19so16095967lfu.11
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 13:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uID8iZcNLBme4rZdpwP2elgnitNvjR/PYrEFPkEMrt4=;
        b=K87wFhFCqh3RUSfcjyHWaJ/5OlWIaCtbKiOBy/+lg00oDsHo00dI9Rz913ownD+DBL
         47j/1FQaoHEzvRGxNbrxGsgl7+D50V85YT1FdoRMTvK7qMkmsNqF9izOyRDx+dPlVcrN
         PuU5VqnxQaMP1XvJIEFREriWuLui4ThOlm6RCIy09TlUR3zrwFtmnqN//0XUrW33aZyh
         HKhKRwmvqOV03Ak4cj8WgBUbW7mMsZ2Dg0uMMOqoASX+5BJ0q9R/08Zvy/VmFiAMWiAq
         NlhqszFUOsK5gPC6/k2K5W00Ot+1S6YmXD7AVIwsTs2LI83qY3/jotSduWfGx+K0rKII
         rUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uID8iZcNLBme4rZdpwP2elgnitNvjR/PYrEFPkEMrt4=;
        b=VOH4uPQ6pYbYfMoiIOcVV1PlxBIDNFqfu6ciVIK11Ix1SLv4JEYQKm5lL12787bAiw
         VVvJvuFHYz/CuMauv5Pawo0PueR5iqSPo3my4QStXBzuEie+dQNTdWEDlyqUqZE//WAO
         Q/eGUYH8MaaeXlXx9M01Hm8/f4oQ/qIKQqkxXeoDd8rw7Kqfd1xFJlXyRnxmh0QeJ+HX
         k5mCifh+kiCGP8akWLkHws/xpGIZRLXvcygiKZgin/i3JRFtpTT32fkNJGG5SrJ+kQ4Z
         eQe/mfzRJnEQf5V4zzBgQfl6SCNNAmkA/e2EDMQY6rU6YYM05gF2zgpXRtt9GYKt8xsv
         ucHg==
X-Gm-Message-State: AOAM532qEr8nnZOR5zrAuG8eTG2XzCaLKa2P7klftYZ97I55NR3CB7K+
        XBzvGYXU0JhpOAae1oz+swq6+w==
X-Google-Smtp-Source: ABdhPJxKLv+z6Br2tuUL+prEzz5FUlfWTCd6C3ag34B5uJ22tX+4eTJVuOo3jnoNg0E6Y/cSpI48ww==
X-Received: by 2002:a05:6512:228d:b0:471:a5b8:d51a with SMTP id f13-20020a056512228d00b00471a5b8d51amr4118108lfu.411.1650657674555;
        Fri, 22 Apr 2022 13:01:14 -0700 (PDT)
Received: from [192.168.1.65] ([46.188.121.177])
        by smtp.gmail.com with ESMTPSA id e5-20020ac25ca5000000b004705dbcc329sm332547lfq.222.2022.04.22.13.01.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 13:01:14 -0700 (PDT)
Message-ID: <964ae72a-0484-67de-8143-a9a2d492a520@openvz.org>
Date:   Fri, 22 Apr 2022 23:01:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH memcg RFC] net: set proper memcg for net_init hooks
 allocations
Content-Language: en-US
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>, kernel@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <46c1c59e-1368-620d-e57a-f35c2c82084d@linux.dev>
 <55605876-d05a-8be3-a6ae-ec26de9ee178@openvz.org>
 <CALvZod47PARcupR4P41p5XJRfCaTqSuy-cfXs7Ky9=-aJQuoFA@mail.gmail.com>
From:   Vasily Averin <vvs@openvz.org>
In-Reply-To: <CALvZod47PARcupR4P41p5XJRfCaTqSuy-cfXs7Ky9=-aJQuoFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/22 18:56, Shakeel Butt wrote:
> On Sat, Apr 16, 2022 at 11:39 PM Vasily Averin <vvs@openvz.org> wrote:
>> @@ -1147,7 +1148,13 @@ static int __register_pernet_operations(struct list_head *list,
>>                  * setup_net() and cleanup_net() are not possible.
>>                  */
>>                 for_each_net(net) {
>> +                       struct mem_cgroup *old, *memcg = NULL;
>> +#ifdef CONFIG_MEMCG
>> +                       memcg = (net == &init_net) ? root_mem_cgroup : mem_cgroup_from_obj(net);
> 
> memcg from obj is unstable, so you need a reference on memcg. You can
> introduce get_mem_cgroup_from_kmem() which works for both
> MEMCG_DATA_OBJCGS and MEMCG_DATA_KMEM. For uncharged objects (like
> init_net) it should return NULL.

Could you please elaborate with more details?
It seems to me mem_cgroup_from_obj() does everything exactly as you say:
- for slab objects it returns memcg taken from according slab->memcg_data
- for ex-slab objects (i.e. page->memcg_data & MEMCG_DATA_OBJCGS)
    page_memcg_check() returns NULL
- for kmem objects (i.e. page->memcg_data & MEMCG_DATA_KMEM) 
    page_memcg_check() returns objcg->memcg
- in another cases
    page_memcg_check() returns page->memcg_data,
    so for uncharged objects like init_net NULL should be returned.

I can introduce exported get_mem_cgroup_from_kmem(), however it should only
call mem_cgroup_from_obj(), perhaps under read_rcu_lock/unlock.

Do you mean something like this?

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1768,4 +1768,14 @@ static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
 
 #endif /* CONFIG_MEMCG_KMEM */
 
+static inline struct mem_cgroup *get_mem_cgroup_from_kmem(void *p)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_obj(p);
+	rcu_read_unlock();
+
+	return memcg;
+}
 #endif /* _LINUX_MEMCONTROL_H */
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a5b5bb99c644..4003c47965c9 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -26,6 +26,7 @@
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 
+#include <linux/sched/mm.h>
 /*
  *	Our network namespace constructor/destructor lists
  */
@@ -1147,7 +1148,14 @@ static int __register_pernet_operations(struct list_head *list,
 		 * setup_net() and cleanup_net() are not possible.
 		 */
 		for_each_net(net) {
+			struct mem_cgroup *old, *memcg;
+
+			memcg = get_mem_cgroup_from_kmem(net);
+			if (memcg == NULL)
+				memcg = root_mem_cgroup;
+			old = set_active_memcg(memcg);
 			error = ops_init(ops, net);
+			set_active_memcg(old);
 			if (error)
 				goto out_undo;
 			list_add_tail(&net->exit_list, &net_exit_list);
