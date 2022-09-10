Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C10F5B48BE
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 22:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiIJURB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 16:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiIJURA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 16:17:00 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CCC3ECD0
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 13:16:59 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id c142-20020a621c94000000b005324991c5b8so3004527pfc.15
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 13:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=4va1A6Pg2FoWWuqwQXukPIMsWe3nsr0ZDePQdQ01AZ4=;
        b=a8tWm/37FKsRqQy7rz4vFhHqkt1oTaqUqWqMfxuj4Z3PoNBLQ8k6sVoudqZrELblra
         HElCNtZueoE1bRj2S/RCGKVvxUzozHNgxCWata8SWq/FHW2JoFE6VUOyRiQNl12sJr1P
         0vYow+f0EgaA0hNRQdfHHT9I9U9GN5RPsvYp1e1V4c+KaZnmoZaf4J/WQsoK1me8VkSZ
         /97RJjYKFLznSkZw4NzBWMI30ADKK25J1P0U10ak/tcA377oD7A8USzZavkKVY6tyQhu
         Q9rFMgNpzbTNSPj23CImAWV6Y9kEhUxHC1IOuTr9LdBpubPZcKj5DGNwUSFWzWeI1wk2
         nBSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=4va1A6Pg2FoWWuqwQXukPIMsWe3nsr0ZDePQdQ01AZ4=;
        b=BI0gPG2F+0XPFYMXhV/cojnepSmAGT7nBO8VPZbrvnSF4yD5VxXZPAjZsO0AWbQfya
         dpSt/T0RugFXXZBJWLqJL5PYLzeaoC3LI9Gi9yBSdrFBqX0dacgIK3/uVrf91nGVQRCu
         3FjT7jVf4oaQAFcxxp37qYMLh9nby3mAXU7CpIEzRs1hsiASS85HuxZ7xmHSTauzkBlP
         nfcb76305cJfxq78Nb+WpNDR8q3Jgxv4ITT+5vZCDXR8fybxycLylpstvSWPKjcCU3H3
         wzzI+j/MhZiYB7sR5+5WFOxYJhWO+S4lreZSRRItJcz4ojOZdpH6PaSyqpNzc2gGQkEu
         7gWw==
X-Gm-Message-State: ACgBeo0wu0PgVBG/rw0sdM3BK7C/S5zRUgdYaWUoOu8SSkbAd3ueD9f+
        yKb2Oc9uFIN/qTWFyGPKuHgIf/Q=
X-Google-Smtp-Source: AA6agR6EuvMwcPFuFlavgsX74oFaHl6/mgTnhPkeK37dno4GZPGuS2fbQUSbXTIX43lpJLYWWewLHsY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:10a:b0:200:2849:235f with SMTP id
 p10-20020a17090b010a00b002002849235fmr223959pjz.1.1662841018240; Sat, 10 Sep
 2022 13:16:58 -0700 (PDT)
Date:   Sat, 10 Sep 2022 13:16:56 -0700
In-Reply-To: <e2e4cc0e-9d36-4ca1-9bfa-ce23e6f8310b@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
References: <0000000000005ed86405e846585a@google.com> <e2e4cc0e-9d36-4ca1-9bfa-ce23e6f8310b@I-love.SAKURA.ne.jp>
Message-ID: <YxzwuDgGF6qBhWct@google.com>
Subject: Re: [PATCH] bpf: add missing percpu_counter_destroy() in htab_map_alloc()
From:   sdf@google.com
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        syzbot <syzbot+5d1da78b375c3b5e6c2b@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11, Tetsuo Handa wrote:
> syzbot is reporting ODEBUG bug in htab_map_alloc() [1], for
> commit 86fe28f7692d96d2 ("bpf: Optimize element count in non-preallocated
> hash map.") added percpu_counter_init() to htab_map_alloc() but forgot to
> add percpu_counter_destroy() to the error path.

> Link: https://syzkaller.appspot.com/bug?extid=5d1da78b375c3b5e6c2b [1]
> Reported-by: syzbot  
> <syzbot+5d1da78b375c3b5e6c2b@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Thanks!

Reviewed-by: Stanislav Fomichev <sdf@google.com>

> Fixes: 86fe28f7692d96d2 ("bpf: Optimize element count in non-preallocated  
> hash map.")
> ---
>   kernel/bpf/hashtab.c | 2 ++
>   1 file changed, 2 insertions(+)

> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 0fe3f136cbbe..86aec20c22d0 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -622,6 +622,8 @@ static struct bpf_map *htab_map_alloc(union bpf_attr  
> *attr)
>   free_prealloc:
>   	prealloc_destroy(htab);
>   free_map_locked:
> +	if (htab->use_percpu_counter)
> +		percpu_counter_destroy(&htab->pcount);
>   	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
>   		free_percpu(htab->map_locked[i]);
>   	bpf_map_area_free(htab->buckets);
> --
> 2.18.4

