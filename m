Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89048214902
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 00:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgGDWLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 18:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgGDWLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 18:11:39 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C63C061794;
        Sat,  4 Jul 2020 15:11:38 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id b6so36608419wrs.11;
        Sat, 04 Jul 2020 15:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZMOjjBuoh2tQ18+I+Ei9Hr4tOOAs3+zliLyALfVwD6w=;
        b=iYtwKXSeaCyMs8CQdm5dxUxBy/F6NPv+0J+jHKk/920RUHkma9y7CgaHI8yroMcpJn
         XI3vajGxGom0c6ZIprj4yZ9195bR9Ptw+OaBC5fuIS69x8nc4qDEfqOuwSqokHUMbUSW
         qeshMSuERqw+tiVwNHW3lm+aySzaNQl+8smrsFrgpKAWgrZskhRpBpwcKZ2vQhsf2dF0
         DqJNFGvtl1Q/pDKfizfABgjdVDni7ZRq0ZcJGHrSy2PtDciCBFgQyq1V0NUuz9PhaT/J
         nouGDXeZE40Xmgd8OEjSZAs3DFBvTBVfg7JIVaOv4VHyYkrCXPQFuotS01j+NJb8LyiX
         Jq4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZMOjjBuoh2tQ18+I+Ei9Hr4tOOAs3+zliLyALfVwD6w=;
        b=o5mCKcoiYnc+xsETgXS5vKm+gq+uCwv1hQa9HC501TY3Pqg5Yao9CyrMsFLoulzx36
         SbHxa0Scxokk+bOa/eRyvW/pL+kMQtEwS7qkQqU5YAOwpU4BD1qJDbU5W67HfWvot+cn
         n04ytLZA22QGUlXpkdbn6NMrU2K/8QSxeBlxXilU+eP3Yil70myjzyuZ4l9aMiKZ9+4h
         PZ0M1CVREy2JuUb2ASf0Rf80t4BhOfil0MrEh1WF6BUMHOqzbVfeUwXqNFc5iI6Iu2wJ
         dTJc72Vcz1d5zRh7I97kZ1IR890OgMdqq3+3NT79wZiWKAbqmy7+kgT5davLumAOGQ5N
         BDKg==
X-Gm-Message-State: AOAM531ocu5WRfzgXvcpDMg9suGufC4H38m35pAiewIdx9tdaz7Wnwjn
        AR25aKsRVMhrK1fa8SAcY7Hck2qvLE/Pf4wdWkREcg==
X-Google-Smtp-Source: ABdhPJwk+QowS0xAsT5XIvOxqwz+VBTILCeJa9En5hyRX4Z29zmj+99X4Mi1DUpybnl7Yw8g/F7kk4p8p7SsTeMeA9I=
X-Received: by 2002:adf:ee0b:: with SMTP id y11mr19673009wrn.360.1593900697518;
 Sat, 04 Jul 2020 15:11:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200703182010.1867-1-bruceshenzk@gmail.com> <CAKgT0Uc0sxRmADBozs3BvK2HFsDAcgzwUKWHyu91npQvyFRM1w@mail.gmail.com>
 <CAHE_cOvFC4sjVvVuC-7A8Zqw6=uJP5AAUmZOk5sQ=7bD+ePpgA@mail.gmail.com> <CAKgT0UdFPjD5YEBjVxkgCc65muNnxq54QPt3iBzm60QY46BCTA@mail.gmail.com>
In-Reply-To: <CAKgT0UdFPjD5YEBjVxkgCc65muNnxq54QPt3iBzm60QY46BCTA@mail.gmail.com>
From:   Zekun Shen <bruceshenzk@gmail.com>
Date:   Sat, 4 Jul 2020 18:11:26 -0400
Message-ID: <CAHE_cOtP+BD+6jyBCoADz1CsZaLgKTknE+OFHnDyDPMrwxo=wQ@mail.gmail.com>
Subject: Re: [PATCH] net: fm10k: check size from dma region
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 04, 2020 at 12:41:07PM -0700, Alexander Duyck wrote:
> On Sat, Jul 4, 2020 at 9:37 AM Zekun Shen <bruceshenzk@gmail.com> wrote:
> >
> > On Sat, Jul 04, 2020 at 09:05:48AM -0700, Alexander Duyck wrote:
> > > The upper limitation for the size should be 2K or FM10K_RX_BUFSZ, not
> > > PAGE_SIZE. Otherwise you are still capable of going out of bounds
> > > because the offset is used within the page to push the start of the
> > > region up by 2K.
> > PAGE_SIZE can drop the warning, as the dma allocated size is PAGE_SIZE.
>
> Yes, but the point I was getting at is that if you are just going to
> squelch the warning, but leave the code broken then the warning isn't
> of any use and might as well be discarded. Either you limit the value
> to 2K which is what the hardware is expected to max out at anyway, or
> you just skip the warning and assume hardware will do the right thing.
> I'm not even sure this patch is worth the effort if it is just using
> some dummy value that is still broken and simply squelches the
> warning.
>
> Could you provide more information about how you are encountering the
> error? Is this something you are seeing with an actual fm10k device,
> or is this something found via code review or static analysis?
I did not see it on a real device. I got the warning through emulation
and fuzzing, treating dma, mmio and interrupts as input vectors.
My research is on the peripheral/driver boundary.
>
> > > If this is actually fixing the warning it makes me wonder if the code
> > > performing the check is broken itself since we would still be
> > > accessing outside of the accessible DMA range.
> > The unbounded size is only passed to fm10k_add_rx_frag, which expects
> > and checks size to be less than FM10K_RX_HDR_LEN which is 256.
> >
> > In this way, any boundary between 256 and 4K should work. I could address
> > that with a second version.
>
> I was referring to the code in the DMA-API that is generating the
> warning being broken, not the code itself. If you can tell me how you
> are getting to the warning it would be useful.
>
> Anything over FM10K_RX_BUFSZ will break things. I think that is what
> you are missing. The driver splits a single 4K page into 2 pieces and
> then gives half off to the stack and uses the other half for the next
> receive. If you have a value over 2K you are going to be overwritting
> data in another buffer and/or attempting to access memory outside the
> DMA region. Both of which would likely cause significant issues and
> likely panic the system.
I agree. FM10K_RX_BUFSZ is the right boundary in that sense.
