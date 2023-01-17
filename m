Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8E666DB56
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 11:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbjAQKmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 05:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236423AbjAQKlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 05:41:25 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421A131E30;
        Tue, 17 Jan 2023 02:41:11 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id az20so55225443ejc.1;
        Tue, 17 Jan 2023 02:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0mclnxMCqmhJD9xt63v+etaE3UibmYTKCLrSfJ0XIlE=;
        b=d0rE5iT+5rdIlMUX7YCuOF4E3RR3qNqdg5Pj3PvICL8asfBQEKVURDp2OL9e6ap0yf
         EwJ+w9dk3NTTDOKX4+J3Mx/ceaYzWGfMrKlN/Uv4n8SexO5LWb3SRxle4YOQA3WEnUQA
         Xu1zIG+TNFYSo+XutFIdDvZEgZ9A3p8TIm8pt9f1sbYrI5PrQL1du6uvy4XI3pp7zWxu
         4pB1DyYJFkzrDGll8OTs23hAcT+6E/KGnmUuXT9Fop3x1b9L3rg5oXgEkJrIQe4dtAs+
         T17mREvQP07nBNUPu3gvGGVKeE32eSJwSV2r52V5FWBiuu8aOHUAvOt67r7lf4LseZVJ
         01/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0mclnxMCqmhJD9xt63v+etaE3UibmYTKCLrSfJ0XIlE=;
        b=Aq1pfseMkIhVnjTq0K5lsxBmzwHtR1kOsPG8gRSp7Ut+/7+Z24bSCteaC1ZAx3+Kvd
         JKEwDiQ42oWra6sp8Tz+j+1PVn9GeVJORmoivK9j1KiaEIRx6NacA2eoJg+x7by7T/8T
         jLoUizcSvatFYSUkw3d8tpYmTRWBdWtNqNf1H4v0SC3aNGgM5d1xzIA0m7x2TxHdR7R0
         /FZ/bgWQV2idPaQnaA1jRTA+CYcRooowcD8aYPPeDXQ1IHgu3YwwueuSHqmY0R14vCSv
         4HixoIpuzYRBAUZa/ahFd1fv8U5WR01ob4E8z5AJCNaNtsu0tlq3JvBcUxof8Rb9lFLv
         IDcg==
X-Gm-Message-State: AFqh2kohKHppnifg+YegrzBJ4s+/9FBxjm3XRUc97bzNvwsuBOc5hHMC
        taIWj2adSQvPlsTu5Xc8xatLA1FDQeXKqvDDFgs=
X-Google-Smtp-Source: AMrXdXvPTCOrOU3A5XHLAe5iH3sbcszDo0CvmptUYNUsVKJ6+qBAeGlVnymAIGkbBlt1g7/9xppbGlfbceotMsMSufI=
X-Received: by 2002:a17:906:3ecd:b0:86c:a95e:4ef7 with SMTP id
 d13-20020a1709063ecd00b0086ca95e4ef7mr232065ejj.524.1673952069470; Tue, 17
 Jan 2023 02:41:09 -0800 (PST)
MIME-Version: 1.0
References: <20230117092533.5804-1-magnus.karlsson@gmail.com> <20230117050759-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230117050759-mutt-send-email-mst@kernel.org>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 17 Jan 2023 11:40:57 +0100
Message-ID: <CAJ8uoz1SLe-AqW7Byd77g=_Z+oUy335+j18jRmZtdi+1FomCkw@mail.gmail.com>
Subject: Re: [PATCH net 0/5] net: xdp: execute xdp_do_flush() before napi_complete_done()
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, toke@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, aelior@marvell.com, manishc@marvell.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        jasowang@redhat.com, ioana.ciornei@nxp.com, madalin.bucur@nxp.com,
        bpf@vger.kernel.org
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

On Tue, Jan 17, 2023 at 11:12 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Jan 17, 2023 at 10:25:28AM +0100, Magnus Karlsson wrote:
> > Make sure that xdp_do_flush() is always executed before
> > napi_complete_done(). This is important for two reasons. First, a
> > redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
> > napi context X on CPU Y will be follwed by a xdp_do_flush() from the
> > same napi context and CPU. This is not guaranteed if the
> > napi_complete_done() is executed before xdp_do_flush(), as it tells
> > the napi logic that it is fine to schedule napi context X on another
> > CPU. Details from a production system triggering this bug using the
> > veth driver can be found in [1].
> >
> > The second reason is that the XDP_REDIRECT logic in itself relies on
> > being inside a single NAPI instance through to the xdp_do_flush() call
> > for RCU protection of all in-kernel data structures. Details can be
> > found in [2].
> >
> > The drivers have only been compile-tested since I do not own any of
> > the HW below. So if you are a manintainer, please make sure I did not
> > mess something up. This is a lousy excuse for virtio-net though, but
> > it should be much simpler for the vitio-net maintainers to test this,
> > than me trying to find test cases, validation suites, instantiating a
> > good setup, etc. Michael and Jason can likely do this in minutes.
>
> This kind of thing doesn't scale though. There are more contributors
> than maintainers. Also, I am not 100% sure what kind of XDP workload
> do I need to be a good test.

True. Is there a smoke test that could be run to check that normal
traffic is not affected? Just so we know that it works as expected.
Then we could move on to try out XDP_REDIRECT for virtio. Anyone out
there that knows of something existing that could be used for this?
Just note that reproducing the issue seems to be challenging as 10
systems running a production workload only experienced a single
failure per night due to this [1]. So I suggest we just go with
checking that existing functionality works as expected.

> >
> > Note that these were the drivers I found that violated the ordering by
> > running a simple script and manually checking the ones that came up as
> > potential offenders. But the script was not perfect in any way. There
> > might still be offenders out there, since the script can generate
> > false negatives.
> >
> > [1] https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
> > [2] https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
> >
> > Thanks: Magnus
> >
> > Magnus Karlsson (5):
> >   qede: execute xdp_do_flush() before napi_complete_done()
> >   lan966x: execute xdp_do_flush() before napi_complete_done()
> >   virtio-net: execute xdp_do_flush() before napi_complete_done()
> >   dpaa_eth: execute xdp_do_flush() before napi_complete_done()
> >   dpaa2-eth: execute xdp_do_flush() before napi_complete_done()
> >
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c        | 6 +++---
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c      | 9 ++++++---
> >  drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 6 +++---
> >  drivers/net/ethernet/qlogic/qede/qede_fp.c            | 7 ++++---
> >  drivers/net/virtio_net.c                              | 6 +++---
> >  5 files changed, 19 insertions(+), 15 deletions(-)
> >
> >
> > base-commit: 87b93b678e95c7d93fe6a55b0e0fbda26d8c7760
> > --
> > 2.34.1
>
