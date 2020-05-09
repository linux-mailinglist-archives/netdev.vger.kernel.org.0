Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCD61CBD93
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgEIEsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgEIEsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:48:42 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F899C05BD09
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 21:48:42 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id t3so3799459qkg.1
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 21:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t1LjLC1s4sCP//+D9ivHb061ksMa6R7nzDgbCchd/Aw=;
        b=hW0p/Hi561SjkDi8KJwWBN/Sd1BQzn/AFk8N18aeXEHY1FmVbkQ74voXCXVYKv/Wnm
         z5oLDLRq1bPZigqeQHzi5ltNDWm0clHQTNNZTcR9z1lgLMHElWRVZWRgIyY9mHLa8tBl
         1zBBhaXWMaDQyKsIs8rp3sXK/jiQEE9BexXMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t1LjLC1s4sCP//+D9ivHb061ksMa6R7nzDgbCchd/Aw=;
        b=srx3rioMIGhNJPjZWaIZZQBO1XeXcVfkRqnZzDbO04jkbv0SUdzIvA/MwLhtvVAtId
         GqGS03V+Op9D3if6MID2wESHhLa/C3lMBSM80WFQyE052LuQqDVcP/tDzZt4stDLIncw
         WWms+zIURiaiEIBd1Q3n3i7F9IJIVtZm61JrQzGHyailu8oRJu6RkRpZGA34RWnQMaVn
         B7/rmpOcPRtMKBGxcfP+Y+tD/vO+Yb99gcOB2pKG53OxWZ63c7oo06skGV95ZW8nDioy
         sTocSkILC5EA1eUBa+0d9y1VIo1j5EoUd/4iiIVgrAn/2zKImsbH13Y6J5sHzBrbRKDO
         N2Qw==
X-Gm-Message-State: AGi0PuYFi+487H002AXQWxvtr/6seJjlgJ16Y6Ui3gGtJqqmn1HXtUHr
        ahDjH/lXK0Q0AgEeFw9M3jsKN67zgGofDNX3H+Jgiw==
X-Google-Smtp-Source: APiQypIyMwru08xTnu+fFuU8vtzhTVdr50TwJ2cPHujqapbgnzcOUWJEfe7EXsEdE7dCmjUvzZrJH1wdZK19ZmFERZA=
X-Received: by 2002:a05:620a:688:: with SMTP id f8mr6019779qkh.431.1588999721764;
 Fri, 08 May 2020 21:48:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200508225301.484094-1-colin.king@canonical.com>
 <1890306fc8c9306abe11186d419d84f784ee6144.camel@perches.com>
 <160ce1ee-3bb5-3357-64f3-e5dea8c0538d@canonical.com> <20200508184814.45e10c12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <fbd61323358554b00460c97ec303572189f99544.camel@perches.com>
In-Reply-To: <fbd61323358554b00460c97ec303572189f99544.camel@perches.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 8 May 2020 21:48:30 -0700
Message-ID: <CACKFLi=A_43O6OqNGfiybpnJyuQJFV0MjoG-mrRHD0RbNumQnA@mail.gmail.com>
Subject: Re: [PATCH] net: tg3: tidy up loop, remove need to compute off with a multiply
To:     Joe Perches <joe@perches.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 7:31 PM Joe Perches <joe@perches.com> wrote:
>
> On Fri, 2020-05-08 at 18:48 -0700, Jakub Kicinski wrote:
> > On Sat, 9 May 2020 00:31:03 +0100 Colin Ian King wrote:
> > > > My preference would be for
> > > >
> > > > {
> > > >   int i;
> > > >   u32 off = 0;
> > > >
> > > >   for (i = 0; i < TG3_SD_NUM_RECS; i++) {
> > > >           tg3_ape_scratchpad_read(tp, (u32 *)ocir, off, TC3_OCIR_LEN);
> > > >
> > > >           if (ocir->signature != TG3_OCIR_SIG_MAGIC ||
> > > >               !(ocir->version_flags & TG3_OCIR_FLAG_ACTIVE))
> > > >                   memset(ocir, 0, TG3_OCIR_LEN);
> > > >
> > > >           off += TG3_OCIR_LEN;
> > > >           ocir++;
> > > >   }
> > > >
> > > OK, I'll send a V3 tomorrow.
> >
> > I already reviewed and applied v2, just waiting for builds to finish,
> > let's leave it.
>
>
> I think clarity should be preferred.

Either way is fine with me.  I'm fine with v2 since it's already applied.
