Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281F75621D9
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 20:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236167AbiF3SNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 14:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbiF3SNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 14:13:43 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12249393F5;
        Thu, 30 Jun 2022 11:13:42 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id fd6so27625291edb.5;
        Thu, 30 Jun 2022 11:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8glAiFvvYAhfMI+vcfTy74bCy0VAErz9qlw2gOrB7qA=;
        b=l1r+1Vmf9q2oWvjMcHJzsqJnIeHo07Lf7an896wGvxkwuV/81/9kjyXcVpowrnWjQR
         MebPRwlejspQtTlgWcn6o56P0UE9VvteQLMMl153TNVbdz3gnJurMJCXzIV31PI9f3Gy
         +LsuxTKlXXI3+buzGcTM0g9BN49+68ylLEbbQovNwqhHwMFaFnB1VL8mE/Cesmwq7RWw
         w7MHT1YsfBSOYyRXOaoseLr8ybSjV+UhnJC0OkCsWNmyGRAgpQR3e8C+LMj+4S9UO4gm
         fm1ma4xUoIcEn6Rwa4zlti9dlk2NSt+9w82HeC4rueqqWCPMsgeEzo7+9g5osgVQ7q4W
         x00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8glAiFvvYAhfMI+vcfTy74bCy0VAErz9qlw2gOrB7qA=;
        b=AXVUwmM0aa3B4qJq9Z1N2gf4rA9Bo9OOrd/8d3XeKvHH3Kw3wRDWn0Ep6jYPIP6n0X
         yGRKlFGKggWTYgRi1LBoTuBO2hXsrh2DWJyQSjUGwjd2LuTdVrojfq0PvQ6YlqO6cxXO
         xQQrWHAJAWQTOc1VUW15qns1gk8snQEyfp3x532tOSyGlk/iAVF4BIUGOpzAsxuSliX2
         u33RhkkvSiX/lofasGcn4siPa+1LMUU+COTtbPqdMl82PvVfAR07liRZcnBVT0ZfIrvW
         6TiH1oAZKZZczPLbceBQW/L8GVAOs4pPttflGS+rA9bEWLrU0qrZZG+n4H+dvBjvhnEL
         8etQ==
X-Gm-Message-State: AJIora9GLg9yNwRxfs48PE9u0Iv0LFRFp3E9+RMcvSlXjIA2+Ob7LFCv
        +IPpTjQFxLVumfy3xKIKVhs=
X-Google-Smtp-Source: AGRyM1tRbV9myCID4do+RE+BD6VuESTf79GpY37rWF1nuOjpF2gsd4l25Fxd/4Kig/NcRnR7mdixUA==
X-Received: by 2002:a05:6402:26d6:b0:435:ba41:dbb0 with SMTP id x22-20020a05640226d600b00435ba41dbb0mr13327972edd.242.1656612820518;
        Thu, 30 Jun 2022 11:13:40 -0700 (PDT)
Received: from opensuse.localnet (host-87-6-98-182.retail.telecomitalia.it. [87.6.98.182])
        by smtp.gmail.com with ESMTPSA id p5-20020a17090653c500b00722e8c47cc9sm1833654ejo.181.2022.06.30.11.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 11:13:38 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in ixgbe_check_lbtest_frame()
Date:   Thu, 30 Jun 2022 20:13:37 +0200
Message-ID: <12017329.O9o76ZdvQC@opensuse>
In-Reply-To: <CAKgT0UfGM8nCZnnYjWPKT+JXOwVJx1xj6n7ssGi41vH4GrUy0Q@mail.gmail.com>
References: <20220629085836.18042-1-fmdefrancesco@gmail.com> <Yr12jl1nEqqVI3TT@boxer> <CAKgT0UfGM8nCZnnYjWPKT+JXOwVJx1xj6n7ssGi41vH4GrUy0Q@mail.gmail.com>
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

On gioved=C3=AC 30 giugno 2022 17:17:24 CEST Alexander Duyck wrote:
> On Thu, Jun 30, 2022 at 3:10 AM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > On Wed, Jun 29, 2022 at 10:58:36AM +0200, Fabio M. De Francesco wrote:
> > > The use of kmap() is being deprecated in favor of kmap_local_page().
> > >
> > > With kmap_local_page(), the mapping is per thread, CPU local and not
> > > globally visible. Furthermore, the mapping can be acquired from any=20
context
> > > (including interrupts).
> > >
> > > Therefore, use kmap_local_page() in ixgbe_check_lbtest_frame()=20
because
> > > this mapping is per thread, CPU local, and not globally visible.
> >
> > Hi,
> >
> > I'd like to ask why kmap was there in the first place and not plain
> > page_address() ?
> >
> > Alex?
>=20
> The page_address function only works on architectures that have access
> to all of physical memory via virtual memory addresses. The kmap
> function is meant to take care of highmem which will need to be mapped
> before it can be accessed.
>=20
> For non-highmem pages kmap just calls the page_address function.
> https://elixir.bootlin.com/linux/latest/source/include/linux/highmem-inte=
rnal.h#L40

Please take a look at documentation (highmem.rst). I've recently reworked=20
it and added information about kmap_local_page()

Thanks,

=46abio

>=20
> Thanks,
>=20
> - Alex
>=20




