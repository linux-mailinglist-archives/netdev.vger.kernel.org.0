Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E405AE1A0
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 09:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbiIFHyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 03:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238599AbiIFHxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 03:53:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA3074DD9;
        Tue,  6 Sep 2022 00:53:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 718C31F96A;
        Tue,  6 Sep 2022 07:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662450812; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e3QUGRmGqEl6xPagnkOR/JexF9yw1PltCqI7wAdRJxg=;
        b=szOuRIs0cCBK1H6PKsUsPpAeNxWI1rQoZXD8JHcTFx4Pd4FbY7Zaow4t6VKG/eCu28Uykw
        08koAlFpwrqRPIvX38x8DqEATR+CgzjdatCWvZqWD9zJUc9QEGvodSEKfvbHt+mPuOUIAC
        d4uII081ZhK5cB5AQX5syr5K/Cq58DM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662450812;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e3QUGRmGqEl6xPagnkOR/JexF9yw1PltCqI7wAdRJxg=;
        b=LbJNw5OZF+aS6zamEygbmkEhapLIQEGf++3G6rX+mlhq4ujGasckDo8OXslkEh1swKvhC7
        MzjHTvKXXrH4vpDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2DEE313A7A;
        Tue,  6 Sep 2022 07:53:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Qs4TCnz8FmOnQAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Tue, 06 Sep 2022 07:53:32 +0000
Message-ID: <dab10759-c059-2254-116b-8360bc240e57@suse.cz>
Date:   Tue, 6 Sep 2022 09:53:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: linux-next: build failure after merge of the slab tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marco Elver <elver@google.com>
References: <20220906165131.59f395a9@canb.auug.org.au>
Content-Language: en-US
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20220906165131.59f395a9@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/6/22 08:51, Stephen Rothwell wrote:
> Hi all,

Hi,

> After merging the slab tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> kernel/bpf/memalloc.c: In function 'bpf_mem_free':
> kernel/bpf/memalloc.c:613:33: error: implicit declaration of function '__ksize'; did you mean 'ksize'? [-Werror=implicit-function-declaration]
>    613 |         idx = bpf_mem_cache_idx(__ksize(ptr - LLIST_NODE_SZ));
>        |                                 ^~~~~~~
>        |                                 ksize

Could you use ksize() here? I'm guessing you picked __ksize() because 
kasan_unpoison_element() in mm/mempool.c did, but that's to avoid 
kasan_unpoison_range() in ksize() as this caller does it differently.
AFAICS your function doesn't handle kasan differently, so ksize() should 
be fine.

> Caused by commit
> 
>    8dfa9d554061 ("mm/slab_common: move declaration of __ksize() to mm/slab.h")
> 
> interacting with commit
> 
>    7c8199e24fa0 ("bpf: Introduce any context BPF specific memory allocator.")
> 
> from the bpf-next tree.
> 
> I have reverted the slab tree commit for today.
> 

