Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44A65E7DE3
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiIWPFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiIWPFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:05:50 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1274EB6015;
        Fri, 23 Sep 2022 08:05:49 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id n10so385845wrw.12;
        Fri, 23 Sep 2022 08:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=IbrAq0owyuBI2vDk7UuHuInHGIm6YEu/yGe6vOTOGVE=;
        b=YX51EvCicYLzsulTEP+TH4axgTjVnMmSsyVPa+FXuodPd6MQGGx9arVG+4ivuuELXZ
         uORO/ruHsPkcE+pKMLy42QhjFDrZkbMxhY1chRB3sqVO1n4kLje/IZ25T/2nwamTHjoh
         SzhM9Xz+6mr7tounkShKfyJZVvzooFBTUcOhz8811BPjwBIt+W9qrbk5eT3OyLF+7PM5
         Ct1cH5ihg9w0uCGMyQ8Mms/+2/cTarUB3+RF04TXLByxsAexBHUAzlnUf/WWdgf+h8+Y
         MwV7ClhMs/0cxAxZ4O65oVTYx9VaLbVAHSAkHVxK+6BfXypTycz8ODgUFs+8+DH0ATpP
         PpXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=IbrAq0owyuBI2vDk7UuHuInHGIm6YEu/yGe6vOTOGVE=;
        b=5rgrIqFosS/c3xb0eqSu7RT5nYRHM04RnW4crFAeixBuj41B0KB/F/qAazCWfpW7Lj
         wcaMuFxmKgelIRzJ5MdTZRUfbnQoDp559iDnK1XoierjFcF4KGKGCq/yeAL7qORPpjov
         BBMrMc30OQWCu0IiSQYNDGadWZuyOYfTnbJPO1UpHaCpCKKW9mtwUJxnlcWTQDdrRvDj
         kfHfSn/3JNY5YFzHIf1Ro1GVGAuwxNTvYo8bAZyjA7NAEMLzqbyRhsXczw78OLS49Wyh
         WUKadQOKGbHFqn0iXPRG/ryyIicdthR569Ew34gebVzFvSW6jUiuTQcdXWT/tsvZz2s0
         OFbA==
X-Gm-Message-State: ACrzQf1pnV162FBh1SQwwTLtPQD324CTKFIYWgUG56UYcAlXWzgxVMRX
        dpGBBzU4UKGC0M/zlYrLmyI=
X-Google-Smtp-Source: AMsMyM7vxshdv9NcCk1eQtMtBrLoSSkn6Iwj/Y3O/y/lDxIl1BYy0YkD1UzgB9nDCy+zd1CmfS/6wA==
X-Received: by 2002:a05:6000:124f:b0:228:8713:ced9 with SMTP id j15-20020a056000124f00b002288713ced9mr5630819wrx.198.1663945547426;
        Fri, 23 Sep 2022 08:05:47 -0700 (PDT)
Received: from localhost.localdomain (host-79-34-226-61.business.telecomitalia.it. [79.34.226.61])
        by smtp.gmail.com with ESMTPSA id z19-20020a1cf413000000b003a541d893desm2518606wma.38.2022.09.23.08.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 08:05:46 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ira Weiny <ira.weiny@intel.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in ixgbe_check_lbtest_frame()
Date:   Fri, 23 Sep 2022 17:05:43 +0200
Message-ID: <27280395.gRfpFWEtPU@localhost.localdomain>
In-Reply-To: <22aa8568-7f6e-605e-7219-325795b218b7@intel.com>
References: <20220629085836.18042-1-fmdefrancesco@gmail.com> <CAKgT0Uf1o+i0qKf7J_xqC3SACRFhiYqyhBeQydgUafB5uFkAvg@mail.gmail.com> <22aa8568-7f6e-605e-7219-325795b218b7@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Anirudh,

On Friday, September 23, 2022 12:38:02 AM CEST Anirudh Venkataramanan wrote:
> On 9/22/2022 1:58 PM, Alexander Duyck wrote:
> > On Thu, Sep 22, 2022 at 1:07 PM Anirudh Venkataramanan
> > <anirudh.venkataramanan@intel.com> wrote:
> >>
> >>
> >> Following Fabio's patches, I made similar changes for e1000/e1000e and
> >> submitted them to IWL [1].

I saw your patches and they look good to me. I might comment and probably 
review them, however I prefer to wait for Ira to do that. Furthermore, looking 
again at your patches made me recall that I need to talk with him about 
something that is only indirectly related with you work.

Please don't rely on older patches of mine as models for your next patches. In 
the last months I changed many things in the way I handle the removal of 
kmap() in favour of a plain page_address() or decide to convert to 
kmap_local_page(). Obviously I'm talking about pages which cannot come from 
ZONE_HIGHMEM.

> >> Yesterday, Ira Weiny pointed me to some feedback from Dave Hansen on the
> >> use of page_address() [2]. My understanding of this feedback is that
> >> it's safer to use kmap_local_page() instead of page_address(), because
> >> you don't always know how the underlying page was allocated.

Your understanding of Dave's message is absolutely correct.

> >> This approach (of using kmap_local_page() instead of page_address())
> >> makes sense to me. Any reason not to go this way?

> >> [1]
> >>
> >> https://patchwork.ozlabs.org/project/intel-wired-lan/patch/
20220919180949.388785-1-anirudh.venkataramanan@intel.com/
> >>
> >> https://patchwork.ozlabs.org/project/intel-wired-lan/patch/
20220919180949.388785-2-anirudh.venkataramanan@intel.com/
> >>
> >> [2]
> >> https://lore.kernel.org/lkml/5d667258-b58b-3d28-3609-e7914c99b31b@intel.com/
> >>
> >> Ani
> > 
> > For the two patches you referenced the driver is the one allocating
> > the pages. So in such a case the page_address should be acceptable.
> > Specifically we are falling into alloc_page(GFP_ATOMIC) which should
> > fall into the first case that Dave Hansen called out.
> 
> Right. However, I did run into a case in the chelsio inline crypto 
> driver where it seems like the pages are allocated outside the driver. 
> In such cases, kmap_local_page() would be the right approach, as the 
> driver can't make assumptions on how the page was allocated.

The mere fact that we are still discussing this particular topic is my only 
fault. I mean that the guidelines about what to do with ZONE_NORMAL or lower 
pages is not enough clear. I'll have to improve that paragraph.

For now let me tell you what I'm doing whenever I have to decide between a 
conversion  from kmap{,_atomic}() to kmap_local_page() or a kmap() removal  in 
favour of page_address() use.

> ... and this makes me wonder why not just use kmap_local_page() even in 
> cases where the page allocation was done in the driver. IMO, this is 
> simpler because
> 
> a) you don't have to care how a page was allocated. kmap_local_page() 
> will create a temporary mapping if required, if not it just becomes a 
> wrapper to page_address().
> 
> b) should a future patch change the allocation to be from highmem, you 
> don't have to change a bunch of page_address() calls to be 
> kmap_local_page().

"a" and "b" are good arguments with sound logic. However there are a couple of 
cases that you are not yet considering.

As my main rule I prefer the use of kmap_local_page() whenever tracking if 
pages can't come from Highmem is complex, especially when allocation is 
performed in other translation units of the same driver or, worse, pages come 
from different subsystems.

Instead, I don't like to use kmap_local_page() when the allocation is in the 
same function and you see immediately that it cannot come from ZONE_HIGHMEM.

Sometimes it's so clear that using kmap_local_page() looks silly to me :-)
For example...

void *silly_alloc_and_map() {
         	struct *page;
	
	page = alloc_page(GFP_KERNEL);
	return kmap_local_page(page);
}

In this case you know without any effort that the page cannot come from 
ZONE_HIGHMEM. Therefore, why bother with mapping and unmapping (and perhaps 
write a function for unmapping).

While working on the removals or the conversions of kmap(), I noticed that 
people tend to forget to call kunmap(). We have a limited amount of kmap() 
slots. If the mapping space is fully utilized we'll have the next slot 
available only after reboot or unloading and reloading a module.

If I recall correctly, with kmap_local_page() we can map a maximum of 16 pages 
per task_struct. Therefore, limits are everywhere and people tend to leak 
resources.

To summarize: whenever allocation is easily trackable, and pages cannot come 
from ZONE_HIGHMEM, I prefer page_address().

Honestly, if code is well designed I don't care whether or not within 5 days 
or 10 years decide to change the allocation. I think it's like to refrain from 
deleting unreachable code, variables, partially implemented functions, and so 
on just because one day someone may think to make something useful from those 
things. 

Greg K-H taught me that I must see the code as is now and don't speculate 
about possible future scenarios. I agree with him in full :-)

Very different case where I _need_ page_address() are due to the strict rules 
of nesting mapping and unmapping-mapping. I recall that I spent days on a 
function in Btrfs because I could not map and unmap with the usual Last In - 
First Out (LIFO) rule. 

A function was so complex and convoluted that nobody could know in advance the 
order of execution of the mappings of two pages. Lots of goto, breaks, loops 
made impossible to unmap in the correct order at the "clean and exit" label.

I made a first attempt using a two element array as a stack which registered 
the mappings and then I used it to unmap in the correct order at exit.

It was intentionally a means to draw the attention of the maintainers. One of 
them proposed to split that very complex function in several helpers, and 
isolate the mappings one by one. It was OK to me.

After weeks, David Sterba noticed that he knew that one of the pages came from 
the page cache and we had to map it, but the second page was allocated inside 
Btrfs with GFP_KERNEL. Therefore, the better suited solution was to use 
kmap_local_page() for the first and page address() for the second.

My stack based solution was working but nobody should write such an ugly code 
just to enforce local mapping :-) 

> Is using page_address() directly beneficial in some way?

A possible call chain on 32 bits kernels is the following:

kmap_local_page() ->
 __kmap_local_page_prot() { 
	if (!IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP) && |
PageHighMem(page))
		return page_address(page);

....
}

How many instructions can you save calling page_address() directly?
If you don't know, look at the assembly.

Thanks,

Fabio		

> Ani
> 
> 




