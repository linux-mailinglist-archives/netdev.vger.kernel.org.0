Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C262B9CBE
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgKSVLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgKSVLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:11:42 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCF1C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:11:41 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id 7so9949314ejm.0
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wg2p5JZV2cIxsfxICO1tdBtw325z1Ixo8ebHlNFIcGs=;
        b=tgW+HhhNc9+QQOYIoMg+l16hHcgsrWMVZ4TFHXPbXpSidrjJ0qz14rGUp9xfA8BSkZ
         j0Sf4UGHzwRl9b2v8QEP+YuZumPt8po9F5tc3mTb/toyFgEGqKOzTLy9nbLrYwKGbNmj
         Q1EIrqJIA0u/VMAGpW2hb3x+yzp4XdUnp+nVEOkczeLCAwmNfh7uIu+eJYsu2RYoF5SK
         +RPWwQvItIsYzoI1LH/Uql3Kn+ZXOTQ0GGABgXOjdpq8dhQHnigXxp1O448fcp1qKAR9
         LlXnC1rBNfdSCLbL6DL+s/GawRCxbGcMe1NxaMYTc4XMYQH53cTw9tG7bagijNHJDKJ4
         i9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wg2p5JZV2cIxsfxICO1tdBtw325z1Ixo8ebHlNFIcGs=;
        b=rHTdT4pw/ZewvquYulqhus3rT4R66V+J4Lh5kCMnN6fT4BBtJ5h32menMBIHO3t2tf
         5bmU+7P3L9ZvCPGYfJCIKFWwqJnFyqo6X/LUiKIUAdlSCIP9Xyil8ftp+RR6o1jtZNdo
         FW3ClGuNoN8sQgmlEiIDHKW+utNj0LfZtd+vS7uPJ0deitniYDotDaoxR8erTkChzJhW
         Yt6No3VTe02iyO671KzajPLkocPHHmHtaIi2Ewrnf+meUXNpO50Xft9Yk/dOeWhl2nIO
         bSXKcVqxsxbt90+BuYBDXTmoTs3yK5xBu+jK7zG2POfJQ/Cl1R3L3oA5vGcIbm6nA9dM
         jP7Q==
X-Gm-Message-State: AOAM53186jEz2lTmkBLKGcfxnX9uuGInGesOjQ+DMfmBG+mMDzr8syT9
        cFlXlMzeRUW3BLklmmIGfQxa0YW1Fq4tprZz1aE3lv6y7iE=
X-Google-Smtp-Source: ABdhPJyx/xvK3NHtw9SzEpj45RaEMuK4UKDviiWlu15icLn4syjw1ChZNVNk5AoZ6l5xy1Sl6MeX2RuiCbstQqg1IX8=
X-Received: by 2002:a17:906:ae88:: with SMTP id md8mr29281796ejb.323.1605820300247;
 Thu, 19 Nov 2020 13:11:40 -0800 (PST)
MIME-Version: 1.0
References: <20201109233659.1953461-1-awogbemila@google.com>
 <20201109233659.1953461-4-awogbemila@google.com> <CAKgT0UcFxqsdWQDxueMA4X90BWM11eDR3Z5f0JhEtbezR226+g@mail.gmail.com>
 <CAL9ddJfa3dpie_zjFG+6jyJ0H9wXGWXWs_TTaL540kQbGO4U+Q@mail.gmail.com> <CAKgT0Uc8LdPKw27T-js5O-2g+e8o=QMwasA+57hjZt9ih_-T-w@mail.gmail.com>
In-Reply-To: <CAKgT0Uc8LdPKw27T-js5O-2g+e8o=QMwasA+57hjZt9ih_-T-w@mail.gmail.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Thu, 19 Nov 2020 13:11:29 -0800
Message-ID: <CAL9ddJf7GASYX-3o7W-zdhQvVQ=9UBcrrQydT2tw8CZ_qgP7Cw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/4] gve: Rx Buffer Recycling
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 8:55 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, Nov 18, 2020 at 2:50 PM David Awogbemila <awogbemila@google.com> wrote:
> >
> > On Wed, Nov 11, 2020 at 9:20 AM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Mon, Nov 9, 2020 at 3:39 PM David Awogbemila <awogbemila@google.com> wrote:
> > > >
> > > > This patch lets the driver reuse buffers that have been freed by the
> > > > networking stack.
> > > >
> > > > In the raw addressing case, this allows the driver avoid allocating new
> > > > buffers.
> > > > In the qpl case, the driver can avoid copies.
> > > >
> > > > Signed-off-by: David Awogbemila <awogbemila@google.com>
> > > > ---
>
> <snip>
>
> > > > +static int gve_rx_can_recycle_buffer(struct page *page)
> > > > +{
> > > > +       int pagecount = page_count(page);
> > > > +
> > > > +       /* This page is not being used by any SKBs - reuse */
> > > > +       if (pagecount == 1)
> > > > +               return 1;
> > > > +       /* This page is still being used by an SKB - we can't reuse */
> > > > +       else if (pagecount >= 2)
> > > > +               return 0;
> > > > +       WARN(pagecount < 1, "Pagecount should never be < 1");
> > > > +       return -1;
> > > > +}
> > > > +
> > >
> > > So using a page count of 1 is expensive. Really if you are going to do
> > > this you should probably look at how we do it currently in ixgbe.
> > > Basically you want to batch the count updates to avoid expensive
> > > atomic operations per skb.
> >
> > A separate patch will be coming along to change the way the driver
> > tracks page count.
> > I thought it would be better to have that reviewed separately since
> > it's a different issue from what this patch addresses.
>
> Okay, you might want to call that out in your patch description then
> that this is just a temporary placeholder. Back when I did this for
> ixgbe I think we had it doing a single page update for a few years,
> however that code had a bug in it that would cause page count
> corruption as I wasn't aware at the time that the mm tree had
> functions that would take a reference on the page without us ever
> handing it out.

Ok, I'll add that to the patch description since even though this
aspect of the driver's behavior is not changing in this patch it is being
separated into its own function.

>
> > >
> > > >  static struct sk_buff *
> > > >  gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
> > > >                       struct gve_rx_slot_page_info *page_info, u16 len,
> > > >                       struct napi_struct *napi,
> > > > -                     struct gve_rx_data_slot *data_slot)
> > > > +                     struct gve_rx_data_slot *data_slot, bool can_flip)
> > > >  {
> > > > -       struct sk_buff *skb = gve_rx_add_frags(napi, page_info, len);
> > > > +       struct sk_buff *skb;
> > > >
> > > > +       skb = gve_rx_add_frags(napi, page_info, len);
> > >
> > > Why split this up?It seemed fine as it was.
> >
> > It was based on a comment from v3 of the patchset.
>
> Do you recall the comment? This just seems like noise to me since it
> is moving code and doesn't seem to address either a formatting issue,
> nor a functional issue.

The comment suggested that it might be weird to initialize a variable
with a function call and error-check after an empty line.
I realize now that what I should have done here is introduce the split
in the patch that introduced the function so
it doesn't appear as an unnecessary isolated change - I'll do that.

>
> > >
> > > >         if (!skb)
> > > >                 return NULL;
> > > >
> > > > +       /* Optimistically stop the kernel from freeing the page by increasing
> > > > +        * the page bias. We will check the refcount in refill to determine if
> > > > +        * we need to alloc a new page.
> > > > +        */
> > > > +       get_page(page_info->page);
> > > > +       page_info->can_flip = can_flip;
> > > > +
> > >
> > > Why pass can_flip and page_info only to set it here? Also I don't get
> > > why you are taking an extra reference on the page without checking the
> > > can_flip variable. It seems like this should be set in the page_info
> > > before you call this function and then you call get_page if
> > > page_info->can_flip is true.
> >
> > I think it's important to call get_page here even for buffers we know
> > will not be flipped so that if the skb does a put_page twice we would
> > not run into the WARNing in gve_rx_can_recycle_buffer when trying to
> > refill buffers.
> > (Also please note that a future patch changes the way the driver uses
> > page refcounts)
>
> It was your buffer recycling bit that I hadn't noticed. So you have
> cases where if your page count gets to 2 you push it to 3 in the hopes
> that the 2 that are already out there will be freed and you are left
> holding the one remaining count. However I am not sure how much of an
> advantage there is to that. If the page flipping is already failing I
> wonder what percentage of the time you are able to recover from that.
> It might be worthwhile to look at adding a couple of counters to track
> the number of times you couldn't flip versus the number of times you
> recycled the frame. You may find that the buffer recycling is adding
> more overhead for very little gain versus just doing the page
> flipping.

Thanks for the suggestion. Metrics tracking those sound like a good idea.
I'll look into getting that change into the patch which changes the driver's
refcount tracking method and eliminates get_page entirely.
