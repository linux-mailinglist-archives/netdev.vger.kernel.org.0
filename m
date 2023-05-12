Return-Path: <netdev+bounces-2022-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E9A6FFFD0
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 07:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34C281C210A6
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 05:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEE10A56;
	Fri, 12 May 2023 05:06:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC3DA54
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 05:06:59 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0098F40DD
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 22:06:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b9963a72fd9so20840364276.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 22:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683868017; x=1686460017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XEaR3Dr2C8Lj1JCkXuxURcDiSzXLw0/h58n+0eTFpXk=;
        b=h2TzF1Sm4wgRUFzC402/r2JRCTOK95t1n6LIDMbVzltdZxZ1uErK2N2BwmqWhMnZ2x
         gDJIw0J+ieOpsXu8IU+C+9duObCvbbPPNDpYL988Bbh3KOzpvj3WlzGRiCq3UgH/fKdN
         jnwqcwBkrJpjqMeb1gRz3IRnnjZdtsx6i43myLWpj4bq54RB0Rl+g5e4CVUWGbG7PuB/
         R7uGjC+ttKIstS0IoBo1yuXXZ2eT57tZ2egiGWEnJXomBv7Vlig+QVZOkQZLtcw28KJY
         LFbjerQqdZ+UkjE5fPUKDWc2gKvjdO5IUEWfiXlrRyC0zWLen+gMgJyctE6BqErCTj8Y
         hz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683868017; x=1686460017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XEaR3Dr2C8Lj1JCkXuxURcDiSzXLw0/h58n+0eTFpXk=;
        b=Mxe0C5gPyP9BW3wvueqOzBPnksqgDs6ESVnQrWSzrkQ7GpRsjs8OPcYgUZKGGe0b9J
         WQ5AzygUuxOmfkIETTxqdtPD9tgwWr7L1i0ooGDWIVskIBMjLrqMSapnrQVcOqKw87Ng
         /VdzMfBKzh8Nx11DFsAhKHhclK7L0ejIeN5Ueaypu5AQzyPjta5yB8+Z40ums2hBrTRP
         x3vndPP4MlkRSY++O4sQFs8Rzor0HsMvE0OB77hyUvp0WidtLvtAbzNiWoL/x+/Xdgvc
         hlEw0+hAI2ksX7L0SZgZtQodDA4ufhXbccAMJxUcaHjYQAT7jcUb0PWUmjJQT73bvk4/
         vjDQ==
X-Gm-Message-State: AC+VfDwQfxbuc/G1wtBWPgGHQ8m2iFNfTnYtHSTbTkS2qj7SODs70kTE
	Sk5620Bct5/8a9AIXD2RIK/RT744wd3GRQ==
X-Google-Smtp-Source: ACHHUZ7DT3BCZCjNOk8XAjSIGAmryIlHycJZyc76A2YAWgJLUvsduVjlwCBoIYJxBL1Q7Z3AnsVenTZUavGcRg==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a25:6b11:0:b0:b9d:a7a1:cab8 with SMTP id
 g17-20020a256b11000000b00b9da7a1cab8mr14344595ybc.7.1683868017143; Thu, 11
 May 2023 22:06:57 -0700 (PDT)
Date: Fri, 12 May 2023 05:06:55 +0000
In-Reply-To: <CH3PR11MB7345F99927E27ED49EEFC6E5FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
 <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
 <IA0PR11MB7355E486112E922AA6095CCCFC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <CANn89iJbAGnZd42SVZEYWFLYVbmHM3p2UDawUKxUBhVDH5A2=A@mail.gmail.com>
 <IA0PR11MB73557DEAB912737FD61D2873FC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <20230511211338.oi4xwoueqmntsuna@google.com> <CH3PR11MB734512D5836DBA1F1F3AE7CDFC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB7345F99927E27ED49EEFC6E5FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
Message-ID: <20230512050429.22du3gt6rrq6e37a@google.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
From: Shakeel Butt <shakeelb@google.com>
To: cathy.zhang@intel.com
Cc: Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>, 
	Cgroups <cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net, 
	kuba@kernel.org, Brandeburg@google.com, 
	Brandeburg Jesse <jesse.brandeburg@intel.com>, Srinivas Suresh <suresh.srinivas@intel.com>, 
	Chen Tim C <tim.c.chen@intel.com>, You Lizhen <lizhen.you@intel.com>, eric.dumazet@gmail.com, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 03:23:45AM +0000, Zhang, Cathy wrote:
> Remove the invalid mail addr added unintentionally.
> 

Sorry that was my buggy script.

[...]
> > 
> > Hi Shakeel,
> > 
> > Run with the temp change you provided,  the output shows it comes to
> > drain_stock_1(), Here is the call trace:
> > 
> >      8.96%  mc-worker        [kernel.vmlinux]            [k] page_counter_cancel
> >             |
> >              --8.95%--page_counter_cancel
> >                        |
> >                         --8.95%--page_counter_uncharge
> >                                   drain_stock_1
> >                                   __refill_stock
> >                                   refill_stock
> >                                   |
> >                                    --8.88%--try_charge_memcg
> >                                              mem_cgroup_charge_skmem
> >                                              |
> >                                               --8.87%--__sk_mem_raise_allocated
> >                                                         __sk_mem_schedule
> >                                                         |
> >                                                         |--5.37%--tcp_try_rmem_schedule
> >                                                         |          tcp_data_queue
> >                                                         |          tcp_rcv_established
> >                                                         |          tcp_v4_do_rcv
> 

Thanks a lot. This tells us that one or both of following scenarios are
happening:

1. In the softirq recv path, the kernel is processing packets from
multiple memcgs.

2. The process running on the CPU belongs to memcg which is different
from the memcgs whose packets are being received on that CPU.

BTW have you seen this performance issue when you run the client and
server on different machines? I am wondering if RFS would be good enough
for such scenario and we only need to worry about the same machine case.

