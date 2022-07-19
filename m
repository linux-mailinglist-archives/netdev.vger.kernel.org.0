Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7E95791F3
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 06:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbiGSE0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 00:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbiGSEZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 00:25:59 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C4D3C8FD;
        Mon, 18 Jul 2022 21:25:58 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id f11so10881619plr.4;
        Mon, 18 Jul 2022 21:25:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VoF44j+4R9N9EU2VnEL1yhSs28fdl6vQHXX1QYJLwmo=;
        b=Y/zBYWrgc0LZItnZHTxmfnS0dmrRvg8UiohBmT74ZMQHt1nmvQzGWY0cDrPxf6rg3B
         aBRx2TNaobKQdKUc/k4KmswtIdHOhUS3MDJL8LzgNthMuy8uKlIOcfkinHO+X27ccaR6
         XmM4+1AKQZkuryvSh1/FIysTb2F2azvK3PWS5C1gQOnx+jlIn6Qzobzllfi1f2lnsTeB
         l613VKARLmkj76w0GoN3+vm3zhV2o9X5c7eKMpfgQ9nXKQcUS+2Djjt9rxQfoQ3ouaDm
         S2cGFgaaEIL71zCbpUNQeMyaMxfSj7me0/KLkFaTDD44QBOOpjXHhd5SSy6iOuLqpPBD
         cGZg==
X-Gm-Message-State: AJIora/xBgPS9YsVVdt8HRdhOq+OzJnqJpwRKqhskPs8rbN9GGDnVkhZ
        +TwsJ3/m2bnu5eTaFjM3lFI=
X-Google-Smtp-Source: AGRyM1v2VLTRIa6mxNMtcr945yR256PwAUp79CQCO3ViG5wnm5Dfgqn3+Z9w4eDbKH2iTOZEE9z51Q==
X-Received: by 2002:a17:90b:388b:b0:1f0:47d8:67fb with SMTP id mu11-20020a17090b388b00b001f047d867fbmr35942608pjb.34.1658204758078;
        Mon, 18 Jul 2022 21:25:58 -0700 (PDT)
Received: from fedora (136-24-99-118.cab.webpass.net. [136.24.99.118])
        by smtp.gmail.com with ESMTPSA id a8-20020a170902ecc800b001641b2d61d4sm10496205plh.30.2022.07.18.21.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 21:25:57 -0700 (PDT)
Date:   Mon, 18 Jul 2022 21:25:52 -0700
From:   Dennis Zhou <dennis@kernel.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Klimov <aklimov@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ben Segall <bsegall@google.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Ingo Molnar <mingo@redhat.com>,
        Isabella Basso <isabbasso@riseup.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>, Miroslav Benes <mbenes@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yonghong Song <yhs@fb.com>,
        linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 14/16] mm/percpu: optimize pcpu_alloc_area()
Message-ID: <YtYyUBcP9tPaLL/4@fedora>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-15-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718192844.1805158-15-yury.norov@gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, Jul 18, 2022 at 12:28:42PM -0700, Yury Norov wrote:
> Don't call bitmap_clear() to clear 0 bits.
> 
> bitmap_clear() can handle 0-length requests properly, but it's not covered
> with static optimizations, and falls to __bitmap_set(). So we are paying a
> function call + prologue work cost just for nothing.
> 
> Caught with CONFIG_DEBUG_BITMAP:
> [   45.571799]  <TASK>
> [   45.571801]  pcpu_alloc_area+0x194/0x340
> [   45.571806]  pcpu_alloc+0x2fb/0x8b0
> [   45.571811]  ? kmem_cache_alloc_trace+0x177/0x2a0
> [   45.571815]  __percpu_counter_init+0x22/0xa0
> [   45.571819]  fprop_local_init_percpu+0x14/0x30
> [   45.571823]  wb_get_create+0x15d/0x5f0
> [   45.571828]  cleanup_offline_cgwb+0x73/0x210
> [   45.571831]  cleanup_offline_cgwbs_workfn+0xcf/0x200
> [   45.571835]  process_one_work+0x1e5/0x3b0
> [   45.571839]  worker_thread+0x50/0x3a0
> [   45.571843]  ? rescuer_thread+0x390/0x390
> [   45.571846]  kthread+0xe8/0x110
> [   45.571849]  ? kthread_complete_and_exit+0x20/0x20
> [   45.571853]  ret_from_fork+0x22/0x30
> [   45.571858]  </TASK>
> [   45.571859] ---[ end trace 0000000000000000 ]---
> [   45.571860] b1:		ffffa8d5002e1000
> [   45.571861] b2:		0
> [   45.571861] b3:		0
> [   45.571862] nbits:	44638
> [   45.571863] start:	44638
> [   45.571864] off:	0
> [   45.571864] percpu: Bitmap: parameters check failed
> [   45.571865] percpu: include/linux/bitmap.h [538]: bitmap_clear
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  mm/percpu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 3633eeefaa0d..f720f7c36b91 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1239,7 +1239,8 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int alloc_bits,
>  
>  	/* update boundary map */
>  	set_bit(bit_off, chunk->bound_map);
> -	bitmap_clear(chunk->bound_map, bit_off + 1, alloc_bits - 1);
> +	if (alloc_bits > 1)
> +		bitmap_clear(chunk->bound_map, bit_off + 1, alloc_bits - 1);
>  	set_bit(bit_off + alloc_bits, chunk->bound_map);
>  
>  	chunk->free_bytes -= alloc_bits * PCPU_MIN_ALLOC_SIZE;
> -- 
> 2.34.1
> 

Acked-by: Dennis Zhou <dennis@kernel.org>

Thanks,
Dennis
