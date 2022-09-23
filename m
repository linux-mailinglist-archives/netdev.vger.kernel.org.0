Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BAB5E84EF
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiIWVbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiIWVbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:31:17 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5D8B6D1B;
        Fri, 23 Sep 2022 14:31:15 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id c7so1355275pgt.11;
        Fri, 23 Sep 2022 14:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=onRZypm85DpA8F8xppQeAp1Vjn+WOvdDaZWVxEq3cLc=;
        b=AeUNuttHkTaoXwu2MlIkDD2woBAl8avyM41dVZduixGhJTCYnqihozhDNDuvmvRqbu
         +u0g4u3ztcyq2l97S51FzEVJhiwGEt9SBftjI8gKnb6sZY1EzYZkeKvEwMyqgWKyXwJG
         ZjlRrhe9fVXoE8B1bVn3qhbZAdSNoUKZBqa8zpBBn/m4qIkT/y4hnFnRkUg+jRmH4gp4
         BKG8PYXtMccnfGNFz5UVvPv9kC853jR7svR1stpYtYmuTIgpRaG1ISQsbE4h+ftIcV48
         2z+V+d/75k/6aacdfZnoe73t9ciMSNCt5LxEhZRHuTDpiBJBbtEjAmBdt5J5H6pwuZjw
         Ykpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=onRZypm85DpA8F8xppQeAp1Vjn+WOvdDaZWVxEq3cLc=;
        b=0JClvZcGxumQsR/nlUwhl533KEaiqe4heSjZKsOHH8breUNYNKb3CisJX4O8Eps2B0
         N76YpmSbI303cguMLVHzS5Ac7UDyMldw0+V8xIub1HfWvXX/WO1oh1EKlmhrUHuPnamP
         Fv3Id66fsrW5iRhaAsdm8EKmaTVOB+srFWjIHmcLw6If/TZHj0CSO7P78Il34Tabm7M2
         +7h/jZDBVL4sH0dZzDhGMj3BnF/+v1i1qf5qhULpyEVfe9omOvc/5F8a4LtFuTCErWgW
         mW9YId+paqmKLbGGXu/huQSvYhqze6gsy31wFTG2yByUdyRpL6MkOKwpaBAYK8WFjLU9
         tXyg==
X-Gm-Message-State: ACrzQf3HxvXwpQ0fGMZcyjTO+YKaG/BUbpbw4W3PHc/GUA6dOqyKi3NA
        9VK46AhapYdK16qvDACNR5da7HTrJlSva2nuqws=
X-Google-Smtp-Source: AMsMyM5/kokYfSEaldCoGBdzMKYQ2l0ms9OVcQvuTon6Yt4h5vSgBS0LuY0eA2e8/jJPXCsYLA1MCVthbGeyahsD5Qo=
X-Received: by 2002:a05:6a00:a95:b0:547:b3e0:b1c0 with SMTP id
 b21-20020a056a000a9500b00547b3e0b1c0mr11273947pfl.53.1663968674771; Fri, 23
 Sep 2022 14:31:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220629085836.18042-1-fmdefrancesco@gmail.com>
 <2254584.ElGaqSPkdT@opensuse> <CAKgT0UfThk3MLcE38wQu5+2Qy7Ld2px-2WJgnD+2xbDsA8iEEw@mail.gmail.com>
 <2834855.e9J7NaK4W3@opensuse> <d4e33ca3-92e5-ba30-f103-09d028526ea2@intel.com>
 <CAKgT0Uf1o+i0qKf7J_xqC3SACRFhiYqyhBeQydgUafB5uFkAvg@mail.gmail.com>
 <22aa8568-7f6e-605e-7219-325795b218b7@intel.com> <CAKgT0UfU6Hu3XtuJS_vvmeOMDdFcVanieGXRLyVRmPF7+eRjvg@mail.gmail.com>
 <f32338c8-db1a-ba0c-9254-922d96f2e601@intel.com>
In-Reply-To: <f32338c8-db1a-ba0c-9254-922d96f2e601@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 23 Sep 2022 14:31:03 -0700
Message-ID: <CAKgT0Ucr7s48WskQikmLcukrvC-34Nd8NwCbFG=vF0wn0VbfDQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in ixgbe_check_lbtest_frame()
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
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
        Ira Weiny <ira.weiny@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
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

On Fri, Sep 23, 2022 at 11:51 AM Anirudh Venkataramanan
<anirudh.venkataramanan@intel.com> wrote:
>
> On 9/23/2022 8:31 AM, Alexander Duyck wrote:
> > On Thu, Sep 22, 2022 at 3:38 PM Anirudh Venkataramanan
> > <anirudh.venkataramanan@intel.com> wrote:
> >>
> >> On 9/22/2022 1:58 PM, Alexander Duyck wrote:
> >>> On Thu, Sep 22, 2022 at 1:07 PM Anirudh Venkataramanan
> >>> <anirudh.venkataramanan@intel.com> wrote:
> >>>>
> >>>>
> >>>> Following Fabio's patches, I made similar changes for e1000/e1000e and
> >>>> submitted them to IWL [1].
> >>>>
> >>>> Yesterday, Ira Weiny pointed me to some feedback from Dave Hansen on the
> >>>> use of page_address() [2]. My understanding of this feedback is that
> >>>> it's safer to use kmap_local_page() instead of page_address(), because
> >>>> you don't always know how the underlying page was allocated.
> >>>>
> >>>> This approach (of using kmap_local_page() instead of page_address())
> >>>> makes sense to me. Any reason not to go this way?
> >>>>
> >>>> [1]
> >>>>
> >>>> https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220919180949.388785-1-anirudh.venkataramanan@intel.com/
> >>>>
> >>>> https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220919180949.388785-2-anirudh.venkataramanan@intel.com/
> >>>>
> >>>> [2]
> >>>> https://lore.kernel.org/lkml/5d667258-b58b-3d28-3609-e7914c99b31b@intel.com/
> >>>>
> >>>> Ani
> >>>
> >>> For the two patches you referenced the driver is the one allocating
> >>> the pages. So in such a case the page_address should be acceptable.
> >>> Specifically we are falling into alloc_page(GFP_ATOMIC) which should
> >>> fall into the first case that Dave Hansen called out.
> >>
> >> Right. However, I did run into a case in the chelsio inline crypto
> >> driver where it seems like the pages are allocated outside the driver.
> >> In such cases, kmap_local_page() would be the right approach, as the
> >> driver can't make assumptions on how the page was allocated.
> >
> > Right, but that is comparing apples and oranges. As I said for Tx it
> > would make sense, but since we are doing the allocations for Rx that
> > isn't the case so we don't need it.
> >
> >> ... and this makes me wonder why not just use kmap_local_page() even in
> >> cases where the page allocation was done in the driver. IMO, this is
> >> simpler because
> >>
> >> a) you don't have to care how a page was allocated. kmap_local_page()
> >> will create a temporary mapping if required, if not it just becomes a
> >> wrapper to page_address().
> >>
> >> b) should a future patch change the allocation to be from highmem, you
> >> don't have to change a bunch of page_address() calls to be
> >> kmap_local_page().
> >>
> >> Is using page_address() directly beneficial in some way?
> >
> > By that argument why don't we just leave the code alone and keep using
> > kmap? I am pretty certain that is the logic that had us using kmap in
> > the first place since it also dumps us with page_address in most cases
> > and we didn't care much about the other architectures.
>
> Well, my understanding is that kmap_local_page() doesn't have the
> overheads kmap() has, and that alone is reason enough to replace kmap()
> and kmap_atomic() with kmap_local_page() where possible.

It has less overhead, but there is still some pretty significant code
involved. Basically in the cases where it can't bail out and just call
page_address it will call __kmap_local_page_prot(),
https://elixir.bootlin.com/linux/v6.0-rc4/source/mm/highmem.c#L517.

> > If you look at
> > the kmap_local_page() it just adds an extra step or two to calling
> > page_address(). In this case it is adding extra complication to
> > something that isn't needed which is the reason why we are going
> > through this in the first place. If we are going to pull the bandage I
> > suggest we might as well just go all the way and not take a half-step
> > since we don't actually need kmap or its related calls for this.
>
> I don't really see this as "pulling the kmap() bandage", but a "use a
> more appropriate kmap function if you can" type situation.

My concern is that it is more of a half step in the case of the
e1000/e1000e drivers. We likely should have fixed this some time ago
when I had rewritten the Rx path for the igb and ixgbe drivers, but I
just didn't get around to it because if I messed with other areas it
would have required more validation. I'd rather not carry around the
extra code or function calls if we don't need it.

> FWIW, I am not against using page_address(). Just wanted to hash this
> out and get to a conclusion before I made new changes.
>
> Ani

I gathered as much based on your other conversation. This is
essentially the module-local case you had referred to in which the
page is allocated and used within the module so there is no need to be
concerned about it possibly being a highmem page.

Thanks,

- Alex
