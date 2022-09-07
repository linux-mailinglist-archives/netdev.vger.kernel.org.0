Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4525AFCAD
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 08:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiIGGlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 02:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiIGGlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 02:41:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394899D8D9;
        Tue,  6 Sep 2022 23:40:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0D9B92007D;
        Wed,  7 Sep 2022 06:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662532803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SjrZzo9p8a85Q0L8sl+EU5f88G92ZV1ZI1cJAQMHJA0=;
        b=XVQX+0RiFfWpoLO7zW1jCZDKZe3/aN7KHUBoPDydHdPjgys0cXOTBsvpz/FFgcCEN/97HC
        T8/mWhr2qP0KTg4ZnrwIXuNbME87+MlQH74L5uEMnm01ePbsECG7CFQMuBAoeqc0UkeuK9
        friSOn+eCJ5743taMMwQ2aOcVl3hDdc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662532803;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SjrZzo9p8a85Q0L8sl+EU5f88G92ZV1ZI1cJAQMHJA0=;
        b=EqciqleFaRRsKidl0vESVYZNcA2ePQ4yqAYrz7QZCJZ03JjtWSbekoLQigQAKgQh2CvJ6+
        LjHzPqspdWGLnyDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DA38213486;
        Wed,  7 Sep 2022 06:40:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SvKGNMI8GGNbZQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 07 Sep 2022 06:40:02 +0000
Message-ID: <c0343d88-d41c-80ed-342e-8b4055cd7082@suse.cz>
Date:   Wed, 7 Sep 2022 08:40:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: linux-next: build failure after merge of the slab tree
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marco Elver <elver@google.com>
References: <20220906165131.59f395a9@canb.auug.org.au>
 <dab10759-c059-2254-116b-8360bc240e57@suse.cz>
 <CAADnVQJTDdA=vpQhrbAbX7oEQ=uaPXwAmjMzpW4Nk2Xi9f2JLA@mail.gmail.com>
 <CAADnVQKJORAcV75CHE1yG6_+c8qnoOj6gf=zJG9vnWwR5+4SqQ@mail.gmail.com>
Content-Language: en-US
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <CAADnVQKJORAcV75CHE1yG6_+c8qnoOj6gf=zJG9vnWwR5+4SqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/22 05:05, Alexei Starovoitov wrote:
> On Tue, Sep 6, 2022 at 11:37 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Tue, Sep 6, 2022 at 12:53 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>> >
>> > On 9/6/22 08:51, Stephen Rothwell wrote:
>> > > Hi all,
>> >
>> > Hi,
>> >
>> > > After merging the slab tree, today's linux-next build (powerpc
>> > > ppc64_defconfig) failed like this:
>> > >
>> > > kernel/bpf/memalloc.c: In function 'bpf_mem_free':
>> > > kernel/bpf/memalloc.c:613:33: error: implicit declaration of function '__ksize'; did you mean 'ksize'? [-Werror=implicit-function-declaration]
>> > >    613 |         idx = bpf_mem_cache_idx(__ksize(ptr - LLIST_NODE_SZ));
>> > >        |                                 ^~~~~~~
>> > >        |                                 ksize
>> >
>> > Could you use ksize() here? I'm guessing you picked __ksize() because
>> > kasan_unpoison_element() in mm/mempool.c did, but that's to avoid
>> > kasan_unpoison_range() in ksize() as this caller does it differently.
>> > AFAICS your function doesn't handle kasan differently, so ksize() should
>> > be fine.
>>
>> Ok. Will change to use ksize().
> 
> Just pushed the following commit to address the issue:
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=1e660f7ebe0ff6ac65ee0000280392d878630a67
> 
> It will get to net-next soon.

Thanks!
