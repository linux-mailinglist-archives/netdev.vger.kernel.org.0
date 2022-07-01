Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D58563704
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiGAPg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiGAPgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:36:50 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4546939BA4;
        Fri,  1 Jul 2022 08:36:47 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id pk21so4776980ejb.2;
        Fri, 01 Jul 2022 08:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kVWP9v9nuRHyTkGEYSrcvx5uXVMOYJJ1wNoS0VDXg9k=;
        b=SqZhVjf7YNNWixNsKmBLY6iXajXocLtajbIf7Rwa4/DgzXmfZOf929koyVGp5a4cJM
         9rrisSEADI6F7uCEphtjMSxcfpYNk6hkQn7MYGwsnEJI42VB5gSdrHMeISl1m0u/uNbM
         FKmTJpDjug72jjNeo2v6vGUKbrRVU6PK9rTE7g6l/txGHCOGAsbNNk3zbSU9w/LpDtbQ
         Qz0foezAvyKetuqKHK/Epagqzwa+luCiiN6hbGSzAqzVloMh5MoCcakiImRU8hb+v4tP
         LIlhFcBX1UfLysKyB5fLC+xNhn/ly0jvmTgqbw6LSKbR909kFJAWzGLH8VnoYHpd3R6d
         tXeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kVWP9v9nuRHyTkGEYSrcvx5uXVMOYJJ1wNoS0VDXg9k=;
        b=YKq8NJhHKbzPHz3BY36bJNlM9UQCfncHPgFHcTpxauBwqmWbXa7U5UBHv6XK8B4FIt
         kJd3AdUwblEUSOPIlbrWHg4ghyD6MXOGiY77pQ1DpTgy2OY5gPhI6GCj74I4DfD87+0n
         P0kN+gqDYU+PijmcnLtrcGyJoMImQOvFJOJX0IcwXk7EINu7pKx/7sHFuGLPrtHyzyem
         yj1z9rnFgxrg2ak/4UJYiQzjz8oxVoKOk8LntY+3bK2+wr0F2xsRzPPeCuyxyAV32fzB
         E1gSZNb4ckrK0Fy0Gl/fZJVPkOPpKa9XQR4r7MnQtZ6YJO5NCCL+oap1wa1QinGO+N40
         cMmA==
X-Gm-Message-State: AJIora95TztoNYBtbQegTcYwzOkNHYIdbrw5pY84kwrARFJlIWnH9x1w
        y0U3/M9T4NweWWv+u1UN1v8=
X-Google-Smtp-Source: AGRyM1sbuKQmRTnINPADgbGRg8JQE2qKqhXWTCOypWUscwCJZKjHhyoe3fG2hqQGXqGDHtdjsw8lJA==
X-Received: by 2002:a17:907:628a:b0:6fe:526c:ebc with SMTP id nd10-20020a170907628a00b006fe526c0ebcmr14194125ejc.531.1656689805755;
        Fri, 01 Jul 2022 08:36:45 -0700 (PDT)
Received: from opensuse.localnet (host-79-53-109-127.retail.telecomitalia.it. [79.53.109.127])
        by smtp.gmail.com with ESMTPSA id c12-20020a170906d18c00b00727c6da69besm3853562ejz.38.2022.07.01.08.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 08:36:44 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in ixgbe_check_lbtest_frame()
Date:   Fri, 01 Jul 2022 17:36:42 +0200
Message-ID: <2834855.e9J7NaK4W3@opensuse>
In-Reply-To: <CAKgT0UfThk3MLcE38wQu5+2Qy7Ld2px-2WJgnD+2xbDsA8iEEw@mail.gmail.com>
References: <20220629085836.18042-1-fmdefrancesco@gmail.com> <2254584.ElGaqSPkdT@opensuse> <CAKgT0UfThk3MLcE38wQu5+2Qy7Ld2px-2WJgnD+2xbDsA8iEEw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On gioved=C3=AC 30 giugno 2022 23:59:23 CEST Alexander Duyck wrote:
> On Thu, Jun 30, 2022 at 11:18 AM Fabio M. De Francesco
> <fmdefrancesco@gmail.com> wrote:
> >
> > On gioved=C3=AC 30 giugno 2022 18:09:18 CEST Alexander Duyck wrote:
> > > On Thu, Jun 30, 2022 at 8:25 AM Eric Dumazet <edumazet@google.com>=20
wrote:
> > > >
> > > > On Thu, Jun 30, 2022 at 5:17 PM Alexander Duyck
> > > > <alexander.duyck@gmail.com> wrote:
> > > > >
> > > > > On Thu, Jun 30, 2022 at 3:10 AM Maciej Fijalkowski
> > > > > <maciej.fijalkowski@intel.com> wrote:
> > > > > >
> > > > > > On Wed, Jun 29, 2022 at 10:58:36AM +0200, Fabio M. De Francesco
> > wrote:
> > > > > > > The use of kmap() is being deprecated in favor of
> > kmap_local_page().
> > > > > > >
> > > > > > > With kmap_local_page(), the mapping is per thread, CPU local=
=20
and
> > not
> > > > > > > globally visible. Furthermore, the mapping can be acquired=20
from
> > any context
> > > > > > > (including interrupts).
> > > > > > >
> > > > > > > Therefore, use kmap_local_page() in=20
ixgbe_check_lbtest_frame()
> > because
> > > > > > > this mapping is per thread, CPU local, and not globally=20
visible.
> > > > > >
> > > > > > Hi,
> > > > > >
> > > > > > I'd like to ask why kmap was there in the first place and not=20
plain
> > > > > > page_address() ?
> > > > > >
> > > > > > Alex?
> > > > >
> > > > > The page_address function only works on architectures that have
> > access
> > > > > to all of physical memory via virtual memory addresses. The kmap
> > > > > function is meant to take care of highmem which will need to be
> > mapped
> > > > > before it can be accessed.
> > > > >
> > > > > For non-highmem pages kmap just calls the page_address function.
> > > > > https://elixir.bootlin.com/linux/latest/source/include/linux/
highmem-internal.h#L40
> > > >
> > > >
> > > > Sure, but drivers/net/ethernet/intel/ixgbe/ixgbe_main.c is=20
allocating
> > > > pages that are not highmem ?
> > > >
> > > > This kmap() does not seem needed.
> > >
> > > Good point. So odds are page_address is fine to use. Actually there=20
is
> > > a note to that effect in ixgbe_pull_tail.
> > >
> > > As such we could probably go through and update igb, and several of
> > > the other Intel drivers as well.
> > >
> > > - Alex
> > >
> > I don't know this code, however I know kmap*().
> >
> > I assumed that, if author used kmap(), there was possibility that the=20
page
> > came from highmem.
> >
> > In that case kmap_local_page() looks correct here.
> >
> > However, now I read that that page _cannot_ come from highmem.=20
Therefore,
> > page_address() would suffice.
> >
> > If you all want I can replace kmap() / kunmap() with a "plain"
> > page_address(). Please let me know.
> >
> > Thanks,
> >
> > Fabio
>=20
> Replacing it with just page_address() should be fine. Back when I
> wrote the code I didn't realize that GFP_ATOMIC pages weren't
> allocated from highmem so I suspect I just used kmap since it was the
> way to cover all the bases.
>=20
> Thanks,
>=20
> - Alex
>=20

OK, I'm about to prepare another patch with page_address() (obviously, this=
=20
should be discarded).

Last thing... Is that page allocated with dma_pool_alloc() at
ixgbe/ixgbe_fcoe.c:196? Somewhere else?

Thanks,

=46abio

P.S.: Can you say something about how pages are allocated in intel/e1000=20
and in intel/e1000e? I see that those drivers use kmap_atomic().



