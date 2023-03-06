Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEAB6AC7E9
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCFQ2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCFQ2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:28:13 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B8B1258F;
        Mon,  6 Mar 2023 08:27:36 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id l15-20020a9d7a8f000000b0069447f0db6fso5633036otn.4;
        Mon, 06 Mar 2023 08:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678119994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JXnJjEIOpZbPuEgqFoR8MuwGlYRD8/do8e4iqVYe9jA=;
        b=g2J1sOvHFScq9ttVIurPqh6uAVdu9A9+zHDROKJbzN8VcYNxBAVfI+tsucHnUA8/Ac
         8tq9jyUdB63cpoi9l0zvWwyf2mdYmtBfgqEwUkHi5aw4AKS2lLQoG6JZoCTo1EQXpC5d
         mjQ2vS7bP7YwIcosH996Cgf2tKcoXLNfKwZnuXvOnKDJG4r5Tpyqs1JdvZakHp1KvNlZ
         0YDzTjz7eakWo+QR8wrkz7uT/6nAcIhTBWimKa/6KmyM+YEXfapBRIqwUSKh215xAUn6
         VlfoXFS+0t0Gl5NLgaJ6Ar1Ld4OjC4EX5wk1s2WenrPJoIy34wEEqo2rC/EF/8eFOMA/
         CKsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678119994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JXnJjEIOpZbPuEgqFoR8MuwGlYRD8/do8e4iqVYe9jA=;
        b=yhnUEvPCVdbCytJ3F6i7RXjbWGWmbXX/An2SJ18HEG4I9FWLAidnotpynQG513YhGj
         Imuf/7rAUnQwnuSpDZW9nVAB9149gptTNZ26aLThIA2W3NEYKJ5hMBhSHbWdDTvhoHG9
         EjFTtz+HOl4XrtEMuHl9KWNMQvf+BskamKTy3lFGrd/Tz6IHWi3ETf46TFe7mLRetrH4
         h+ZYhTSHgLnbFDrC3LhMChdWa2a1DSDJ5AlUb1zZ7p3iMct3SVuGJuKHNdOawkeY+HjZ
         gPtTTh7WDAoKlm1y2V9E2NYJOLfPLS0nkPfeAxmlnNYavk5czdv9wVJaPfOovlc8QqWz
         Hv9Q==
X-Gm-Message-State: AO0yUKXeyZYec/WsRHJIYK989P/FaqkJCY58PeCavUsm5pPkIPb73VNL
        1HHpN6zlM085/MFzs7oBWDo=
X-Google-Smtp-Source: AK7set854bcEzEyHdjoLmMiODiDoqSho1Jnq1WR5UQCRePSQOWlyKsiQ7DfOgrVk6sIwi1qC6U3GzQ==
X-Received: by 2002:a9d:718e:0:b0:694:1f5b:9a81 with SMTP id o14-20020a9d718e000000b006941f5b9a81mr4626020otj.28.1678119993802;
        Mon, 06 Mar 2023 08:26:33 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id f9-20020a9d5f09000000b0068bce0cd4e1sm4260265oti.9.2023.03.06.08.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 08:26:33 -0800 (PST)
Date:   Mon, 6 Mar 2023 08:26:32 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Vernon Yang <vernon2gm@gmail.com>
Cc:     torvalds@linux-foundation.org, tytso@mit.edu, Jason@zx2c4.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        james.smart@broadcom.com, dick.kennedy@broadcom.com,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/5] random: fix try_to_generate_entropy() if no further
 cpus set
Message-ID: <ZAYUODI1yaH5PqHk@yury-laptop>
References: <20230306160651.2016767-1-vernon2gm@gmail.com>
 <20230306160651.2016767-2-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306160651.2016767-2-vernon2gm@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 12:06:47AM +0800, Vernon Yang wrote:
> After commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
> optimizations"), when NR_CPUS <= BITS_PER_LONG, small_cpumask_bits used
> a macro instead of variable-sized for efficient.
> 
> If no further cpus set, the cpumask_next() returns small_cpumask_bits,
> it must greater than or equal to nr_cpumask_bits, so fix it to correctly.
> 
> Signed-off-by: Vernon Yang <vernon2gm@gmail.com>

Hi Vernon,

In all that cases, nr_cpu_ids must be used. The difference is that
nr_cpumask_bits is an upper limit for possible CPUs, and it's derived
from compile-time NR_CPUS, unless CPUMASK_OFFSTACK is enabled.

nr_cpu_ids is an actual number of CPUS as counted on boot.

So, nr_cpu_ids is always equal or less than nr_cpumask_bits, and we'd
compare with the smaller number.

Nor sure, but maybe it's worth to introduce a macro like:
 #define valid_cpuid(cpu) (cpu) < nr_cpu_ids

Thanks,
Yury
> ---
>  drivers/char/random.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index ce3ccd172cc8..d76f12a5f74f 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1311,7 +1311,7 @@ static void __cold try_to_generate_entropy(void)
>  			/* Basic CPU round-robin, which avoids the current CPU. */
>  			do {
>  				cpu = cpumask_next(cpu, &timer_cpus);
> -				if (cpu == nr_cpumask_bits)
> +				if (cpu >= nr_cpumask_bits)
>  					cpu = cpumask_first(&timer_cpus);
>  			} while (cpu == smp_processor_id() && num_cpus > 1);
>  
> -- 
> 2.34.1
