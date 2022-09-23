Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD915E7E72
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbiIWPcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbiIWPcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:32:10 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F66143540;
        Fri, 23 Sep 2022 08:32:09 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so6205532pjm.1;
        Fri, 23 Sep 2022 08:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Xe3XyWrqsUpCuai4jbPz6/cvFb16oXvZzjUKpqqt2d4=;
        b=pdNyL0WG+TM+D2OmwmHa3lgy/2qVjYEs4ma7S6GPiljI/h7J9uxrTXIshJRZpTLyuJ
         ADWNh/ennmmb5VuiZpuAjpfHrNtRXWUOPRTPO86XNjnUG9DHyQUULWRMgqXv+2WL82Cg
         A56cuv7CO7EIUZzobvZrcVWFv+oDKnO3hsEAHT8bCA3/yerqPfI3FfKHgSkQuIoMnQGs
         tICn+DKO3AjWeYOTBD1eOiYb8r6HQXJzF8g1Q9AU2n+SzCRG9OdMigh3MHDFApr7WSi0
         ifOEgu5qyTNdiMGfQbnSlqDBSOJsbnsJwzt58BwC7CAo461hl7d8VvcDiTIP2/1fOHFX
         EgGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Xe3XyWrqsUpCuai4jbPz6/cvFb16oXvZzjUKpqqt2d4=;
        b=lNXnufxcrQ08zb+ma9TyyfdFXxvRA+jvUvHraw2fiJ4mfZAwc8GXhzQMPB37/R77Kp
         si9nqrKn55yhaPguvaTi8/C8OYKsMu2ZTTeEi4haESZLmNZBc01wJPE0mvFKhO3Ydx7z
         XjelbvBcsSjvbQlkd9xTEh4YvRflwAXcLGc5xvvMiFFH0N3nsMf3cjqFw7vNc7RjVr8T
         J+/yuJ6ubQbhPEDy4nhJ7EZy8hR3lOLlu2WN9MQ79x24Wz4RvFIpz1pGVQQbgj3MPOQ1
         jLvFa5jn9gw6Zqz0ZJEksNi2sUIGDX3YHWlaMIjRdAYXS9lnGPcNiPfbUQtQ+/8t7KAX
         6WfQ==
X-Gm-Message-State: ACrzQf3IvetCVuHBRj6S++WF66t/Iz/4VU+UymMK+UvCQp+IV86cQAz0
        BtCiePtP2DdVFK8iKa9mb0XsYyUjXG3HXgw1KYc=
X-Google-Smtp-Source: AMsMyM4V+bhhAoWZQIUJnhCP5giOH+OiPQjy4oITXZkTIW3Z+rg7BhstdaANxGeUkZeDky5gUJezn1i+Zyp4KsdGQ94=
X-Received: by 2002:a17:902:e353:b0:178:77ca:a577 with SMTP id
 p19-20020a170902e35300b0017877caa577mr8883901plc.93.1663947129142; Fri, 23
 Sep 2022 08:32:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220629085836.18042-1-fmdefrancesco@gmail.com>
 <2254584.ElGaqSPkdT@opensuse> <CAKgT0UfThk3MLcE38wQu5+2Qy7Ld2px-2WJgnD+2xbDsA8iEEw@mail.gmail.com>
 <2834855.e9J7NaK4W3@opensuse> <d4e33ca3-92e5-ba30-f103-09d028526ea2@intel.com>
 <CAKgT0Uf1o+i0qKf7J_xqC3SACRFhiYqyhBeQydgUafB5uFkAvg@mail.gmail.com> <22aa8568-7f6e-605e-7219-325795b218b7@intel.com>
In-Reply-To: <22aa8568-7f6e-605e-7219-325795b218b7@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 23 Sep 2022 08:31:57 -0700
Message-ID: <CAKgT0UfU6Hu3XtuJS_vvmeOMDdFcVanieGXRLyVRmPF7+eRjvg@mail.gmail.com>
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

On Thu, Sep 22, 2022 at 3:38 PM Anirudh Venkataramanan
<anirudh.venkataramanan@intel.com> wrote:
>
> On 9/22/2022 1:58 PM, Alexander Duyck wrote:
> > On Thu, Sep 22, 2022 at 1:07 PM Anirudh Venkataramanan
> > <anirudh.venkataramanan@intel.com> wrote:
> >>
> >>
> >> Following Fabio's patches, I made similar changes for e1000/e1000e and
> >> submitted them to IWL [1].
> >>
> >> Yesterday, Ira Weiny pointed me to some feedback from Dave Hansen on the
> >> use of page_address() [2]. My understanding of this feedback is that
> >> it's safer to use kmap_local_page() instead of page_address(), because
> >> you don't always know how the underlying page was allocated.
> >>
> >> This approach (of using kmap_local_page() instead of page_address())
> >> makes sense to me. Any reason not to go this way?
> >>
> >> [1]
> >>
> >> https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220919180949.388785-1-anirudh.venkataramanan@intel.com/
> >>
> >> https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220919180949.388785-2-anirudh.venkataramanan@intel.com/
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

Right, but that is comparing apples and oranges. As I said for Tx it
would make sense, but since we are doing the allocations for Rx that
isn't the case so we don't need it.

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
>
> Is using page_address() directly beneficial in some way?

By that argument why don't we just leave the code alone and keep using
kmap? I am pretty certain that is the logic that had us using kmap in
the first place since it also dumps us with page_address in most cases
and we didn't care much about the other architectures. If you look at
the kmap_local_page() it just adds an extra step or two to calling
page_address(). In this case it is adding extra complication to
something that isn't needed which is the reason why we are going
through this in the first place. If we are going to pull the bandage I
suggest we might as well just go all the way and not take a half-step
since we don't actually need kmap or its related calls for this.
