Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F13F694AF0
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjBMPVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjBMPVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:21:41 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233ED4C3F
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 07:21:40 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id f16-20020a17090a9b1000b0023058bbd7b2so12552337pjp.0
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 07:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676301699;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0OTCbHJwrAzGMoQSN0j4M72/Aj40IF2WVjbbjnNmlKU=;
        b=INJD02wCYDjpa5s3FRNQgCtgbt/WUBWLOuEwVUQWQKyoJltDY1jr1VA6hBna6SZ0pp
         kBFbREI0+4g1eP3846OeO9VeTxGFH1t8TNrAr7z6USUfMtjlZr3RariyzQC9nkO5LSzQ
         1mV6GdL7Q6xLxUP+i2Q2NK3x9BDczDvjt+Vfi5bCqRQvSUmUUeHLcA75YpTV/A4yb7jm
         ytaqqa/Taxhb+O69onRvY9swGAN4ywXv5fBlmyq7y573XOvZepum3L5fHdwfzZxlJj6J
         Ocq8N3vicaTbvak18KtkCJeoUFyeUZnx7t0+pB2D3j5Y5ut59imAAbLuvECjuKMLpBX6
         v0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676301699;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0OTCbHJwrAzGMoQSN0j4M72/Aj40IF2WVjbbjnNmlKU=;
        b=yrmQod8SDeihVLYwgcai1t7suPRJI2tv4vfB3gQPyPER+s4IEC10vi8jnUunf2VChE
         3wtrLPVAbnGUMo9Qfqu3iatsew307jzT7Tmhz8U1nnug1rf5KUWvRrDeipbuLS1hlGOT
         sAv2IVfbl2OXRkflMgjTWLtdOjcJ+XdqbvOuf7fkQSwtkQ8N9NZbA0YRwKHRmc9M7TRi
         LLfWdAVfzifJF0aKKmGnIz+20ttAlYwBGaJMxMakxqcla2s6wVkKFzn4NhndwGSJPi9e
         PvkO3YeTKnNTvoWbrB8cXkFTV6n1I1jP4RhZqb7uJZFSmWshcfm8pCmlZJw9zsPgueX3
         JBcQ==
X-Gm-Message-State: AO0yUKUGIl70WrzYHk67/RQDMDzQ4B5RY5bsBzRz7gLqO+daazVhHo2t
        inqbJ61doDKNI5eBzsKzhu4mtD8mn1ndwQkZD+s=
X-Google-Smtp-Source: AK7set9OZaH74h5SnTbkp8iiTO7AmVhqyYnm68WhmOnP423Tml7nSUfv68lQqrGH2Zp2B6Y8y1lxoq1wQu8dCHjf+Nw=
X-Received: by 2002:a17:902:d342:b0:19a:8304:21fa with SMTP id
 l2-20020a170902d34200b0019a830421famr1661094plk.21.1676301699292; Mon, 13 Feb
 2023 07:21:39 -0800 (PST)
MIME-Version: 1.0
References: <cover.1675632296.git.geoff@infradead.org> <8d40259f863ed1a077687f3c3d5b8b3707478170.1675632296.git.geoff@infradead.org>
 <79eb8baa3f2d96d47ab3e4d4c4c6bdc8bacfa207.camel@gmail.com> <4ef437ef-37ef-6d3e-fd7e-d2456069f42b@infradead.org>
In-Reply-To: <4ef437ef-37ef-6d3e-fd7e-d2456069f42b@infradead.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 13 Feb 2023 07:21:27 -0800
Message-ID: <CAKgT0UfoNOPSAoC2WWAqNP+tNnDjF2Yj6+9V=Xcf5Eq1bwCrYA@mail.gmail.com>
Subject: Re: [PATCH net v4 2/2] net/ps3_gelic_net: Use dma_mapping_error
To:     Geoff Levand <geoff@infradead.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
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

On Sun, Feb 12, 2023 at 9:06 AM Geoff Levand <geoff@infradead.org> wrote:
>
> Hi Alexander,
>
> On 2/6/23 08:37, Alexander H Duyck wrote:
> > On Sun, 2023-02-05 at 22:10 +0000, Geoff Levand wrote:
> >> The current Gelic Etherenet driver was checking the return value of its
> >> dma_map_single call, and not using the dma_mapping_error() routine.
> >>
> >> Fixes runtime problems like these:
> >>
> >>   DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
> >>   WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc
> >>
> >> Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)
> >> Signed-off-by: Geoff Levand <geoff@infradead.org>
> >> ---
> >>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 52 ++++++++++----------
> >>  1 file changed, 27 insertions(+), 25 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> >> index 7a8b5e1e77a6..5622b512e2e4 100644
> >> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> >> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> >> @@ -309,22 +309,34 @@ static int gelic_card_init_chain(struct gelic_card *card,
> >>                               struct gelic_descr_chain *chain,
> >>                               struct gelic_descr *start_descr, int no)
> >>  {
> >> -    int i;
> >> +    struct device *dev = ctodev(card);
> >>      struct gelic_descr *descr;
> >> +    int i;
> >>
> >> -    descr = start_descr;
> >> -    memset(descr, 0, sizeof(*descr) * no);
> >> +    memset(start_descr, 0, no * sizeof(*start_descr));
> >>
> >>      /* set up the hardware pointers in each descriptor */
> >> -    for (i = 0; i < no; i++, descr++) {
> >> +    for (i = 0, descr = start_descr; i < no; i++, descr++) {
> >>              gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
> >>              descr->bus_addr =
> >>                      dma_map_single(ctodev(card), descr,
> >>                                     GELIC_DESCR_SIZE,
> >>                                     DMA_BIDIRECTIONAL);
> >
> > Are bus_addr and the CPU the same byte ordering? Just wondering since
> > this is being passed raw. I would have expected it to go through a
> > cpu_to_be32.
>
> As I mentioned in my reply to the first patch, the PS3's CPU is
> big endian, so we really don't need any of the endian conversions.

My advice would be to still make use of the cpu_to_be32 macros. It
will take care of any possible byte ordering issues should you work
with a different CPU architecture in the future. Otherwise if you are
certain that the values will always be CPU ordered you might try
changing the type rather than using __be32 for your descriptor
variable types.

For example most PCIe hardware is using a little endian architecture
and on x86 we don't need to do the byte swapping since the cpu is
little endian. However we still use cpu_to_le32 throughout most
drivers.

You might read through the documentation for sparse at:
https://www.kernel.org/doc/html/latest/dev-tools/sparse.html
