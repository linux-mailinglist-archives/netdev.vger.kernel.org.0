Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C0A2D1849
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 19:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgLGSPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 13:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgLGSPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 13:15:43 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E82EC061794
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 10:15:03 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id r17so13029207ilo.11
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 10:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hHq/xb/pv02EeD0pGYHlEothdFGwrB90EzBmPugYcJk=;
        b=UJk5hX3f/G45RB0dkq6NiZ9xtAqfaiiCloepRguEu/toNsMFu9fzC2vlYRnhXYDgrY
         9kNzZVKSt6cdZbZqbosNM8PlPhPLhlrsgMBWynGHmRUbinruP9SnWdjX1cWyvZKDNXge
         4ndH0FDCK69tg5mKFiYTL5iPbHTMiTkRBq9yo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hHq/xb/pv02EeD0pGYHlEothdFGwrB90EzBmPugYcJk=;
        b=WLi+etQtF2E+F1o3ouZqTEGR8rAKeHVG1xUeex21cUQi8uSG95i0nO7lk2YxWkNJKE
         ch/IRAtfGM46lU/gw6dUBuYIvC9B59tbT7IQpHD1luQWejFo6apzHmhgJGq9H+NbsXW7
         CdJlBnRAZXwH8D8F0ypGGQJEi80XBg1cH308KN9VzIJo7ltyfYUD4M/42Ck0T7bhoyZ2
         xJZmaLButJxCmgxphUXhFwV2hNahZDgFDOUQUZG5kGadHfRvfXVgzFDhMue2nPtatHSm
         T350hieignH2vF29+zk9AoFQpetl62md6r2W8d3KBkJ3dGbgJlNMLN0pFYUtPvU+KyaQ
         mHkw==
X-Gm-Message-State: AOAM531o6Jv7eyKRUhObNQT4vnbvqfK7OH0rHWrH8KsMOD+OriON/+P4
        +zNuZCDdJaEXjcewj1TBqM/rryUnGhkmEJ0SLP6gZQ==
X-Google-Smtp-Source: ABdhPJxuUl78F1hJprmwBVxcZo32iPF/WVnvcbVvMQRF7A3m+Ae5s+gUqX9bce5XoCfml84l1vnwZkm4PJJACuAUaKc=
X-Received: by 2002:a05:6e02:a:: with SMTP id h10mr6300702ilr.235.1607364902407;
 Mon, 07 Dec 2020 10:15:02 -0800 (PST)
MIME-Version: 1.0
References: <20201112200906.991086-1-kuabhs@chromium.org> <20201112200856.v2.1.Ia526132a366886e3b5cf72433d0d58bb7bb1be0f@changeid>
 <CAD=FV=XKCLgL6Bt+3KfqKByyP5fpwXOh6TNHXAoXkaQJRzjKjQ@mail.gmail.com>
 <002401d6c242$d78f2140$86ad63c0$@codeaurora.org> <CAD=FV=UnecON-M9eZVQePuNpdygN_E9OtLN495Xe1GL_PA94DQ@mail.gmail.com>
 <002d01d6c2dd$4386d880$ca948980$@codeaurora.org> <CAD=FV=WQPMnor3oTefDHd6JP6UmpyBo7UsOJ1Sg4Ly1otxr6hw@mail.gmail.com>
 <004301d6c968$12ef1b10$38cd5130$@codeaurora.org> <CAD=FV=VCbjRUxUsmyk=64FLDGU=W41EXh5tdfQr1Lg83T8jiEA@mail.gmail.com>
In-Reply-To: <CAD=FV=VCbjRUxUsmyk=64FLDGU=W41EXh5tdfQr1Lg83T8jiEA@mail.gmail.com>
From:   Abhishek Kumar <kuabhs@chromium.org>
Date:   Mon, 7 Dec 2020 10:14:51 -0800
Message-ID: <CACTWRwsdVLGWfd28QHE5UnjETDcG4tPq+sXkK_Eu_yc_ThNwAQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] ath10k: add option for chip-id based BDF selection
To:     Doug Anderson <dianders@chromium.org>
Cc:     Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> > (no changes since v1)
>
> I think you need to work on the method you're using to generate your
> patches.  There are most definitely changes since v1.  You described
> them in your cover letter (which you don't really need for a singleton
> patch) instead of here.
I agree, this was not intentional, I will fix this in the upcoming patches.

On Thu, Dec 3, 2020 at 7:34 AM Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Thu, Dec 3, 2020 at 3:33 AM Rakesh Pillai <pillair@codeaurora.org> wrote:
> >
> > > What I'm trying to say is this.  Imagine that:
> > >
> > > a) the device tree has the "variant" property.
> > >
> > > b) the BRD file has two entries, one for "board-id" (1) and one for
> > > "board-id + chip-id" (2).  It doesn't have one for "board-id + chip-id
> > > + variant" (3).
> > >
> > > With your suggestion we'll see the "variant" property in the device
> > > tree.  That means we'll search for (1) and (3).  (3) isn't there, so
> > > we'll pick (1).  ...but we really should have picked (2), right?
> >
> > Do we expect board-2.bin to not be populated with the bdf with variant field (if its necessary ?)
>
> The whole fact that there is a fallback to begin with implies that
> there can be a mismatch between the board-2.bin and the device tree
> file.  Once we accept that there can be a mismatch, it seems good to
> try all 3 fallbacks in order.
>
> > Seems fine for me, if we have 2 fallback names if that is needed.
> OK, sounds good.  So hopefully Abhishek can post a v3 based on what's
> in <https://crrev.com/c/2556437> and you can confirm you're good with
> it there?
I agree, with this patch there can be mismatch between what's provided
in the Board file and what required board name we are generating, so
three calls are needed. So in a sense, we want to keep the V1 patch
with fix to reuse the same BDF.

I am making V3 changes and will address and push that out.

Thanks
Abhishek
