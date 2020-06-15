Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFE41F9C1D
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 17:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgFOPlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 11:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgFOPlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 11:41:50 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5049BC061A0E;
        Mon, 15 Jun 2020 08:41:50 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id o26so11867414edq.0;
        Mon, 15 Jun 2020 08:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F8hJ5rGc1yt9gJcBhxVHwGATuGB6QrIWDgNmuWtUHcU=;
        b=NiK0ob6PcHupDGlSao3KXhlaO2eD0vY3jWkQCXapgfyVDtvdximJgOO1FpxDJO2yj7
         x7YI20+B1tW9KwL/XsujWeVvnWgpOIf0jCOED+uNIHBZVBZKqvrmw101BBlzPsRZ/R4L
         53zPc8DYRCG/sXF6WD+wLN6e7jJ7fRcYlEQFK/EXvEHqFCjiCgHavUgz3wHTvIbCpONH
         n1ROcCc70TOrvefzt7V8x0+8LvFEtat73HOjm50fTfbi9Qvx57CDer9jHiM8KLKzGgYL
         Fww7AmrgaqJilm5qHQHzPmdrcPtYB9g7WbQTMSZSNTRF2ekskYu3W48uvoyggBh3Z8yu
         aL5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F8hJ5rGc1yt9gJcBhxVHwGATuGB6QrIWDgNmuWtUHcU=;
        b=KR3eJkTPOPhedFvfA5Y6yV3O8l1fikrmBCumpf/d2APYCd7oivbjYSOe8EzbR3XAeu
         daLoxjMCOxnFNbWZJX9rA146V7io5RfPkx0zcjJGTlmPG4r+Io7plOpIVAMoiUu9+0xA
         fyTxG3+1ndG6YQ3zmyxKwa6TN0XLVhayx7c4aOLmqz7Z3tdvqtR2/SEybugOKFpLRiZX
         40vJAC5ZDK9jyKvdB7l4UT5PwjuXLZEt+PKZtVn/ImSKzVXGF3AFSPorCHMKXhV7jzYg
         RtApZzzw5kZa7/Y7kUHA5d+l9KmeE4+YELP3s2y+EwJnQ9Yk6RUvzQjY0X+x5Dej5l0y
         XKMA==
X-Gm-Message-State: AOAM531PpDOz+zDJcX5Psjel+22vi9I55uSxYUK6gXQN0WA02bOfmRhT
        +BidtR2PP6ZkE2+P5fDkztSoDJbey4ekD5KsgV4=
X-Google-Smtp-Source: ABdhPJxibbRCNd/tvyo6m20dcs2/YXa4Sxtc2dYQac2u97kF49P35ry4Ek9AMY/wWQ/IzxM8u6N8WLt8uyZVj293HgY=
X-Received: by 2002:aa7:d98e:: with SMTP id u14mr24958056eds.247.1592235708904;
 Mon, 15 Jun 2020 08:41:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
 <20200615130139.83854-5-mika.westerberg@linux.intel.com> <CA+CmpXtpAaY+zKG-ofPNYHTChTiDtwCAnd8uYQSqyJ8hLE891Q@mail.gmail.com>
 <20200615135112.GA1402792@kroah.com> <CA+CmpXst-5i4L5nW-Z66ZmxuLhdihjeNkHU1JdzTwow1rNH7Ng@mail.gmail.com>
 <20200615142247.GN247495@lahna.fi.intel.com> <CA+CmpXuN+su50RYHvW4S-twqiUjScnqM5jvG4ipEvWORyKfd1g@mail.gmail.com>
 <20200615153249.GR247495@lahna.fi.intel.com>
In-Reply-To: <20200615153249.GR247495@lahna.fi.intel.com>
From:   Yehezkel Bernat <yehezkelshb@gmail.com>
Date:   Mon, 15 Jun 2020 18:41:32 +0300
Message-ID: <CA+CmpXtRZ4JMe2V2-kWiYWR0pnnzLQMbXQESni6ne8eFeDCCXg@mail.gmail.com>
Subject: Re: [PATCH 4/4] thunderbolt: Get rid of E2E workaround
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 6:32 PM Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
>
> On Mon, Jun 15, 2020 at 06:15:47PM +0300, Yehezkel Bernat wrote:
> > On Mon, Jun 15, 2020 at 5:22 PM Mika Westerberg
> > <mika.westerberg@linux.intel.com> wrote:
> > >
> > > On Mon, Jun 15, 2020 at 05:18:38PM +0300, Yehezkel Bernat wrote:
> > > > On Mon, Jun 15, 2020 at 4:51 PM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Mon, Jun 15, 2020 at 04:45:22PM +0300, Yehezkel Bernat wrote:
> > > > > > On Mon, Jun 15, 2020 at 4:02 PM Mika Westerberg
> > > > > > <mika.westerberg@linux.intel.com> wrote:
> > > > > > >
> > > > > > > diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
> > > > > > > index ff397c0d5c07..5db2b11ab085 100644
> > > > > > > --- a/include/linux/thunderbolt.h
> > > > > > > +++ b/include/linux/thunderbolt.h
> > > > > > > @@ -504,8 +504,6 @@ struct tb_ring {
> > > > > > >  #define RING_FLAG_NO_SUSPEND   BIT(0)
> > > > > > >  /* Configure the ring to be in frame mode */
> > > > > > >  #define RING_FLAG_FRAME                BIT(1)
> > > > > > > -/* Enable end-to-end flow control */
> > > > > > > -#define RING_FLAG_E2E          BIT(2)
> > > > > > >
> > > > > >
> > > > > > Isn't it better to keep it (or mark it as reserved) so it'll not cause
> > > > > > compatibility issues with older versions of the driver or with Windows?
> > > > >
> > > > >
> > > > > How can you have "older versions of the driver"?  All drivers are in the
> > > > > kernel tree at the same time, you can't ever mix-and-match drivers and
> > > > > kernels.
> > > > >
> > > > > And how does Windows come into play here?
> > > > >
> > > >
> > > > As much as I remember, this flag is sent as part of creating the
> > > > interdomain connection.
> > > > If we reuse this bit to something else, and the other host runs an
> > > > older kernel or
> > > > Windows, this seems to be an issue.
> > > > But maybe I don't remember it correctly.
> > >
> > > We never send this flag anywhere. At the moment we do not announce
> > > support the "full E2E" in the network driver. Basically this is dead
> > > code what we remove.
> >
> > OK, maybe we never sent it, but Windows driver does send such a flag somewhere.
>
> It does yes but that is optional and we chose not to support it in
> Linux TBT network driver.
>
> > This is the only way both sides can know both of them support it and that they
> > should start using it. I'd prefer at least leaving a comment here that mentions
> > this, so if someone goes to add flags in the future, they will know to
> > take it into consideration.
>
> This flag here (RING_FLAG_E2E) is not exposed anywhere outside of
> thunderbolt driver.
>
> I think you are talking about the "prtstns" property in the network
> driver. There we only set TBNET_MATCH_FRAGS_ID (bit 1). This is the
> thing that get exposed to the other side of the connection and we never
> announced support for full E2E.


Ah, yes, this one, Thanks!
As Windows driver uses it for flagging full-E2E, and we completely drop E2E
support here, it may worth to mention there that this is what bit 2 is used in
Windows so any reuse should consider the possible compatibility issue.
