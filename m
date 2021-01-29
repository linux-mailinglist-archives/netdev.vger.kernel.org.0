Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A48F308EFB
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhA2VGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbhA2VGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 16:06:17 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43531C061573
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 13:05:36 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id s11so12167354edd.5
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 13:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0XX6bJD3knielzWhxls2g+jOfpC8zytYPezell7AkYo=;
        b=iKUZLvezgvLkWs8O6dGSzFoV7YYJ3IFwxuXmC+4nEuHLZKcJWC6sDNJwKa4JjKbbB5
         MtrrCFgyekIohraMx8uT+cPv18eEO7Ao1D6cTOQ7Wi5lNnd6EXnpvxkAKmSpc2JhQvjD
         F1kT9EOznmrdFLr8gXsJ8xSqPDi1+5BSDt171eo/9i3ihl3XG4l1EQWOSPVW9SzR0Fua
         8OQD5lGZbGukoqN0rcclH5l2qfEO13vO19NogEc634hXZi+TL1kADZ9YF3Nrb2okBBEz
         Lua7LccgFov6GvHa32iIFHjiKa0tBVf8iZD2m6XqEC9G8Buc6O4N7BvfEpzSGWVJZS4q
         pu4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0XX6bJD3knielzWhxls2g+jOfpC8zytYPezell7AkYo=;
        b=LhDftQE0u/jxdPggtOm/2SBoPCF2x5/Dr+jJ31Qrl67+JfQqs4KI98VnpoJNEBU57j
         RP+ef+cqvq6k5wCVMJzutxDWDtsnCj9g7htGmC4+9jKQqvHwikXQzhWtcVnecUPFUvzK
         luTEV+iSqUryuMmR/1AH5jXsZr/vq9eC9AYsBa0X+gCq8gMmFdt7/i0bLlz6GLevVlXH
         Ksix4oJ37gYF+E+0dopf4y3DIy7gL7NFvNLAX2r/WqYzwbAaaduqB84OWppV4JwIe6V4
         zu1cQoOtLM3Z/6/5mifgFFAIsIdAkUiQl8Gryhz2ruDPh/UdFqDEdrMmVNOTMBvSR7i+
         1pLQ==
X-Gm-Message-State: AOAM5323f2hMO5JcEN/2tV8oDj28QjY+MWgvXM0HGNdlCf9tJ4JbwF3N
        QRJGJUbrfWUZsAaNHCRipFpw6pkZen53WIj3IIc=
X-Google-Smtp-Source: ABdhPJxCFbcbX8QcUSGwNcD+ToSgVr9Sv6ZIks6FkMZyb1o7wFS66Gf59OLYofljLFOd5XDAthHqkEfcJrbBH2ytCr0=
X-Received: by 2002:aa7:d1d7:: with SMTP id g23mr7364271edp.6.1611954335014;
 Fri, 29 Jan 2021 13:05:35 -0800 (PST)
MIME-Version: 1.0
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
 <20210129004332.3004826-3-anthony.l.nguyen@intel.com> <CAF=yD-LVEWjcezKidh-JUcuON-L8GWvs34EeMNRrQK1tn0YD8w@mail.gmail.com>
In-Reply-To: <CAF=yD-LVEWjcezKidh-JUcuON-L8GWvs34EeMNRrQK1tn0YD8w@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 Jan 2021 16:04:58 -0500
Message-ID: <CAF=yD-JEFCz9OK2mgC7Xpka+HxnyQyKLx-REKwmoK6fjcntmRQ@mail.gmail.com>
Subject: Re: [PATCH net-next 02/15] ice: cache NVM module bank information
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        sassmann@redhat.com, Tony Brelinski <tonyx.brelinski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 4:01 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Jan 28, 2021 at 7:46 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
> >
> > From: Jacob Keller <jacob.e.keller@intel.com>
> >
> > The ice flash contains two copies of each of the NVM, Option ROM, and
> > Netlist modules. Each bank has a pointer word and a size word. In order
> > to correctly read from the active flash bank, the driver must calculate
> > the offset manually.
> >
> > During NVM initialization, read the Shadow RAM control word and
> > determine which bank is active for each NVM module. Additionally, cache
> > the size and pointer values for use in calculating the correct offset.
> >
> > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> > Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_nvm.c  | 151 ++++++++++++++++++++++
> >  drivers/net/ethernet/intel/ice/ice_type.h |  37 ++++++
> >  2 files changed, 188 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
> > index b0f0b4fc266b..308344045397 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_nvm.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
> > @@ -603,6 +603,151 @@ static enum ice_status ice_discover_flash_size(struct ice_hw *hw)
> >         return status;
> >  }
> >
> > +/**
> > + * ice_read_sr_pointer - Read the value of a Shadow RAM pointer word
> > + * @hw: pointer to the HW structure
> > + * @offset: the word offset of the Shadow RAM word to read
> > + * @pointer: pointer value read from Shadow RAM
> > + *
> > + * Read the given Shadow RAM word, and convert it to a pointer value specified
> > + * in bytes. This function assumes the specified offset is a valid pointer
> > + * word.
> > + *
> > + * Each pointer word specifies whether it is stored in word size or 4KB
> > + * sector size by using the highest bit. The reported pointer value will be in
> > + * bytes, intended for flat NVM reads.
> > + */
> > +static enum ice_status
> > +ice_read_sr_pointer(struct ice_hw *hw, u16 offset, u32 *pointer)
> > +{
> > +       enum ice_status status;
> > +       u16 value;
> > +
> > +       status = ice_read_sr_word(hw, offset, &value);
> > +       if (status)
> > +               return status;
> > +
> > +       /* Determine if the pointer is in 4KB or word units */
> > +       if (value & ICE_SR_NVM_PTR_4KB_UNITS)
> > +               *pointer = (value & ~ICE_SR_NVM_PTR_4KB_UNITS) * 4 * 1024;
> > +       else
> > +               *pointer = value * 2;
>
> Should this be << 2, for 4B words?

Never mind, sorry. I gather from patch 3 that wordsize is 16b.
