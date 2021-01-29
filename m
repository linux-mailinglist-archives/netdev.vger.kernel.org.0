Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1852E308F85
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhA2Vhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbhA2Vha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 16:37:30 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E529FC061573
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 13:36:49 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id gx5so15012694ejb.7
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 13:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sNuR3hXEPY6HolODqvub5IQGhDTifhbUsM7DRSWHek8=;
        b=GcSBsGB9p0Jkkk3E1GLegiVyPeDLcZsu4omphslhvOyaP1fbw0jEj323850H5rEjGe
         vFet8r0yDXTvM/gT8n+na2yiYQpsd7veUR1enxnLOpCE+Ed2ikP0AjxwsX033tJ21iXI
         Bhw3MAq8SCma0Z44cNj1+W4V/mKMu/fGDLH74Xa5PJjII7TorU9QluXtr69Bc3yOHL7v
         WVept3C0mV/HVJevbYaGRuAuuJTMBeu8rZh/WEV5oDSMywlqS4mE5XvrbHknqbHKpgZS
         MS7S/epsyhKOMSM2M5/l0dUEd+HZ8qki5mBwj48kKMHt7V4BVXYXJPMylUdVFRETSKl4
         z90A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sNuR3hXEPY6HolODqvub5IQGhDTifhbUsM7DRSWHek8=;
        b=C2FE5+slJ5yA/VNu2t9nXANskX1adyMoB1dTgP0fuc9NLsO1F21WCiUXljH5/wsryW
         /VejpF6VJCOG6UzEDjn3JptJTzzxqarfRZOdrnMjr8LO7WV/rAzL48IXveDNwQiOQjjn
         LqnKbY8XUOBujGM7lfHcKQ/DGrUinx0ajzDzYH2XZtI9HSdX4wqwTOuSn8xUxW7AXok6
         8Ws4jDbKVWnt36ps6p8E04P+Q6N1SYgCt6D7HNjhS1bQAiKoW1KwOfBKjoP5OtqkeNpS
         G2ZoYOg2pl+slVkaEYKvGmWMQC35VSnJb2Q+HC+0kyTnnGfdGsW1dOAhGm0Aml3kO/DA
         77ow==
X-Gm-Message-State: AOAM532z5346Lc0+utFtFlXBcESL4yZwk5luVxFdHqoS0lIB3Tcw/URy
        NHUbefVIpmH2tJ10pws/9LUa+BBbCoqadvpepss=
X-Google-Smtp-Source: ABdhPJxKgZ7jjYI25zre7Vi5lW7b+HTiy0mSwX5drhPjDMORQ8Iwl3b+MsLhpOQgE1V7T4Qhc5qUyDsKcdKTsLitvr4=
X-Received: by 2002:a17:906:fc5:: with SMTP id c5mr6274714ejk.538.1611956208587;
 Fri, 29 Jan 2021 13:36:48 -0800 (PST)
MIME-Version: 1.0
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
 <20210129004332.3004826-3-anthony.l.nguyen@intel.com> <CAF=yD-LVEWjcezKidh-JUcuON-L8GWvs34EeMNRrQK1tn0YD8w@mail.gmail.com>
 <CAF=yD-JEFCz9OK2mgC7Xpka+HxnyQyKLx-REKwmoK6fjcntmRQ@mail.gmail.com> <0ce0a270-7985-2d59-59dc-a4d7f8c9b04e@intel.com>
In-Reply-To: <0ce0a270-7985-2d59-59dc-a4d7f8c9b04e@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 Jan 2021 16:36:12 -0500
Message-ID: <CAF=yD-Lq=NMVYBHO1RNBQSd2W2zaaJPUz2On8zmgsc-QmLx43Q@mail.gmail.com>
Subject: Re: [PATCH net-next 02/15] ice: cache NVM module bank information
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        sassmann@redhat.com, Tony Brelinski <tonyx.brelinski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 4:32 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
>
>
>
> On 1/29/2021 1:04 PM, Willem de Bruijn wrote:
> > On Fri, Jan 29, 2021 at 4:01 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> >>
> >> On Thu, Jan 28, 2021 at 7:46 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
> >>>
> >>> From: Jacob Keller <jacob.e.keller@intel.com>
> >>>
> >>> The ice flash contains two copies of each of the NVM, Option ROM, and
> >>> Netlist modules. Each bank has a pointer word and a size word. In order
> >>> to correctly read from the active flash bank, the driver must calculate
> >>> the offset manually.
> >>>
> >>> During NVM initialization, read the Shadow RAM control word and
> >>> determine which bank is active for each NVM module. Additionally, cache
> >>> the size and pointer values for use in calculating the correct offset.
> >>>
> >>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> >>> Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
> >>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> >>> ---
> >>>  drivers/net/ethernet/intel/ice/ice_nvm.c  | 151 ++++++++++++++++++++++
> >>>  drivers/net/ethernet/intel/ice/ice_type.h |  37 ++++++
> >>>  2 files changed, 188 insertions(+)
> >>>
> >>> diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
> >>> index b0f0b4fc266b..308344045397 100644
> >>> --- a/drivers/net/ethernet/intel/ice/ice_nvm.c
> >>> +++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
> >>> @@ -603,6 +603,151 @@ static enum ice_status ice_discover_flash_size(struct ice_hw *hw)
> >>>         return status;
> >>>  }
> >>>
> >>> +/**
> >>> + * ice_read_sr_pointer - Read the value of a Shadow RAM pointer word
> >>> + * @hw: pointer to the HW structure
> >>> + * @offset: the word offset of the Shadow RAM word to read
> >>> + * @pointer: pointer value read from Shadow RAM
> >>> + *
> >>> + * Read the given Shadow RAM word, and convert it to a pointer value specified
> >>> + * in bytes. This function assumes the specified offset is a valid pointer
> >>> + * word.
> >>> + *
> >>> + * Each pointer word specifies whether it is stored in word size or 4KB
> >>> + * sector size by using the highest bit. The reported pointer value will be in
> >>> + * bytes, intended for flat NVM reads.
> >>> + */
> >>> +static enum ice_status
> >>> +ice_read_sr_pointer(struct ice_hw *hw, u16 offset, u32 *pointer)
> >>> +{
> >>> +       enum ice_status status;
> >>> +       u16 value;
> >>> +
> >>> +       status = ice_read_sr_word(hw, offset, &value);
> >>> +       if (status)
> >>> +               return status;
> >>> +
> >>> +       /* Determine if the pointer is in 4KB or word units */
> >>> +       if (value & ICE_SR_NVM_PTR_4KB_UNITS)
> >>> +               *pointer = (value & ~ICE_SR_NVM_PTR_4KB_UNITS) * 4 * 1024;
> >>> +       else
> >>> +               *pointer = value * 2;
> >>
> >> Should this be << 2, for 4B words?
> >
> > Never mind, sorry. I gather from patch 3 that wordsize is 16b.
> >
>
>
> Ah, yes that could have been explained a bit better. In this context, a
> word is indeed 2 bytes.
>
> Perhaps we could have used "<< 1" and "<< 12" or similar instead of the
> multiplication, but I felt this was a bit more clear.

Thanks. That doesn't matter (for me). I just wrongly assumed wordsize to be 4B.
