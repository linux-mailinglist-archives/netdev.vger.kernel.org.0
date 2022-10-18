Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BAC60247F
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiJRGgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJRGgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:36:51 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E3774DEA;
        Mon, 17 Oct 2022 23:36:50 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id bu30so21850962wrb.8;
        Mon, 17 Oct 2022 23:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Srd8wu/h4bks84F/OuwafoEn79kDxKLL/Z3QEdcLzH8=;
        b=TAjd5oozb4Lh2IDoDeIjAt8jc/SXH7+hLBCJ/VUIvAAhVNCaAODapRPRiWqfRbLToi
         c0CXhbj+vqPETWHERWYCAHYovrVjrGJ4OVUKx6UPqjCqbFQnFwwmBeUC/LUAIot6VoPt
         f7HkzvgY98biJYzmVeC/JoNwuqtfZzor0DUpZx+BX07r1mkxczgFuFoJxqbW19ruqpy2
         srnWn7pdCzXmQoJTN71m34+oAe4uRSaEqi733no+NGE3WaSx4v1BAL1MIhod++x9EEvS
         80StZt8mTJNQhDRt53W3MCWxHcrO3aJ9sXGXty96KBcAWFlVb0REC8jP4ACTvjqb5qsX
         1uug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Srd8wu/h4bks84F/OuwafoEn79kDxKLL/Z3QEdcLzH8=;
        b=M87WL5nVSjoL+uXtCNsKo4f2bMkWcDjdsW1QJVe+eCAh5J8OAXFmsmORCfzLtfQ3Gz
         vpMmWldn9oxb2AbyZb9Kvz+axBJmRoY+dQCh45uPekiESELZgP1lg+YlP30rB+mKrJfd
         kd1ehlamImZTMb70fA7f6KofV3AwgwzfGp3PueUHRMxk2gm02XJINskOi0wcJ+lRil2E
         tWfEfLT4fSbWkUtSvUYX9WmS3a03AhQUNnZ6LsNBt4gd74yKeoGVjg/CiZLwpVvJ5Rh5
         qDl+u4RcekrQH7VBGHY6j5nXIdQmoyj6SyQwKg1zPlo6XZ/A9vOz3Jpj5Uv9W9Eh/+Hv
         ZwOQ==
X-Gm-Message-State: ACrzQf3ApuywKd7BiRA7E9eNEgn0GDBqH0iciF2Fk0KbjkOxtFF3u86q
        1+tkEb2XhZAZeZQV8NOx1YQ=
X-Google-Smtp-Source: AMsMyM5VbpZU4b1m0B7ePZeQ3IPgx00GNiJIBOlWXF49ZU4DiCP8ccF7W/LQeU4EBnxBabgwxwAjzA==
X-Received: by 2002:adf:d1ed:0:b0:230:9355:8da3 with SMTP id g13-20020adfd1ed000000b0023093558da3mr825931wrd.258.1666075008531;
        Mon, 17 Oct 2022 23:36:48 -0700 (PDT)
Received: from [192.168.0.106] ([77.126.16.127])
        by smtp.gmail.com with ESMTPSA id p3-20020a05600c358300b003bdd2add8fcsm18432630wmq.24.2022.10.17.23.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 23:36:48 -0700 (PDT)
Message-ID: <07a034cf-507a-e4ad-d78c-e5dd5a8d98b5@gmail.com>
Date:   Tue, 18 Oct 2022 09:36:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH v4 0/7] sched, net: NUMA-aware CPU spreading interface
Content-Language: en-US
To:     Valentin Schneider <vschneid@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <20220923132527.1001870-1-vschneid@redhat.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220923132527.1001870-1-vschneid@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/23/2022 4:25 PM, Valentin Schneider wrote:
> Hi folks,
> 
> Tariq pointed out in [1] that drivers allocating IRQ vectors would benefit
> from having smarter NUMA-awareness (cpumask_local_spread() doesn't quite cut
> it).
> 
> The proposed interface involved an array of CPUs and a temporary cpumask, and
> being my difficult self what I'm proposing here is an interface that doesn't
> require any temporary storage other than some stack variables (at the cost of
> one wild macro).
> 
> Please note that this is based on top of Yury's bitmap-for-next [2] to leverage
> his fancy new FIND_NEXT_BIT() macro.
> 
> [1]: https://lore.kernel.org/all/20220728191203.4055-1-tariqt@nvidia.com/
> [2]: https://github.com/norov/linux.git/ -b bitmap-for-next
> 
> A note on treewide use of for_each_cpu_andnot()
> ===============================================
> 
> I've used the below coccinelle script to find places that could be patched (I
> couldn't figure out the valid syntax to patch from coccinelle itself):
> 
> ,-----
> @tmpandnot@
> expression tmpmask;
> iterator for_each_cpu;
> position p;
> statement S;
> @@
> cpumask_andnot(tmpmask, ...);
> 
> ...
> 
> (
> for_each_cpu@p(..., tmpmask, ...)
> 	S
> |
> for_each_cpu@p(..., tmpmask, ...)
> {
> 	...
> }
> )
> 
> @script:python depends on tmpandnot@
> p << tmpandnot.p;
> @@
> coccilib.report.print_report(p[0], "andnot loop here")
> '-----
> 
> Which yields (against c40e8341e3b3):
> 
> .//arch/powerpc/kernel/smp.c:1587:1-13: andnot loop here
> .//arch/powerpc/kernel/smp.c:1530:1-13: andnot loop here
> .//arch/powerpc/kernel/smp.c:1440:1-13: andnot loop here
> .//arch/powerpc/platforms/powernv/subcore.c:306:2-14: andnot loop here
> .//arch/x86/kernel/apic/x2apic_cluster.c:62:1-13: andnot loop here
> .//drivers/acpi/acpi_pad.c:110:1-13: andnot loop here
> .//drivers/cpufreq/armada-8k-cpufreq.c:148:1-13: andnot loop here
> .//drivers/cpufreq/powernv-cpufreq.c:931:1-13: andnot loop here
> .//drivers/net/ethernet/sfc/efx_channels.c:73:1-13: andnot loop here
> .//drivers/net/ethernet/sfc/siena/efx_channels.c:73:1-13: andnot loop here
> .//kernel/sched/core.c:345:1-13: andnot loop here
> .//kernel/sched/core.c:366:1-13: andnot loop here
> .//net/core/dev.c:3058:1-13: andnot loop here
> 
> A lot of those are actually of the shape
> 
>    for_each_cpu(cpu, mask) {
>        ...
>        cpumask_andnot(mask, ...);
>    }
> 
> I think *some* of the powerpc ones would be a match for for_each_cpu_andnot(),
> but I decided to just stick to the one obvious one in __sched_core_flip().
>    
> Revisions
> =========
> 
> v3 -> v4
> ++++++++
> 
> o Rebased on top of Yury's bitmap-for-next
> o Added Tariq's mlx5e patch
> o Made sched_numa_hop_mask() return cpu_online_mask for the NUMA_NO_NODE &&
>    hops=0 case
> 
> v2 -> v3
> ++++++++
> 
> o Added for_each_cpu_and() and for_each_cpu_andnot() tests (Yury)
> o New patches to fix issues raised by running the above
> 
> o New patch to use for_each_cpu_andnot() in sched/core.c (Yury)
> 
> v1 -> v2
> ++++++++
> 
> o Split _find_next_bit() @invert into @invert1 and @invert2 (Yury)
> o Rebase onto v6.0-rc1
> 
> Cheers,
> Valentin
> 

Hi,

What's the status of this?
Do we have agreement on the changes needed for the next respin?

Regards,
Tariq
