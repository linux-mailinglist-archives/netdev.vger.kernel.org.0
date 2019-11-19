Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9D4101A52
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 08:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfKSHa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 02:30:26 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52787 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfKSHa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 02:30:26 -0500
Received: by mail-wm1-f68.google.com with SMTP id l1so1967000wme.2
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 23:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=54M9SJ7ipHl9CMC/eI7daudua/MTq9asr1/Z0lh58Ds=;
        b=LWlTne4r1/ognEd9xAUCYa9pcBn+4do+2trO6bpmqR4CLCgytPZ33xMblbAa8icfM/
         CkCk5AjKnIeizEzMBi7SDeksnpqo+m5BezJ42tXH1bNDTiE33TGfkw+poz3/T/uPmOQs
         4LEnMjYxJwyMQkAqX4TyzSfaCrMCt6mWEze2a5I3C2B4N2WvRVDlV2PMZOKiEVaFe4dm
         cYNgkFURB5yBjGqq/XWdUL43S/sD2vECQKGVh0szymNbsG+JM62OOG3s8rCiI4lkryr9
         HGY4DLt3fczN/f4A9yG67FPlXo+Kvtl4Jirom4Xh9a9H0omKfKRj0BfF5z/TawlHhRkL
         vnwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=54M9SJ7ipHl9CMC/eI7daudua/MTq9asr1/Z0lh58Ds=;
        b=KNhsLZoe9ni7xej+td9nJhdJ1fb3wI/bLNbMuhvZjTU1TetrWq/zqP8IUGB8tm1UYo
         KQA9wN+GRXVyhLbFJJCjfuPFawGiTL6GxQaglI0YqZCfrveGRzPzmvxY6K4OCOe4H8mR
         OLjY6cx2/MUo/sPxJSz9XN+l9OR5x1Swrx0ckVDRFBoXJaFYvEzxfCoh2D5Z5rckVOrt
         kg9zml51HMCw0cp9yFlvLVQxeFF+jeiZmuHa337l2cYOpGO1crsZ8afQ0nJIAxorMW5B
         t7LvUp/uMfCeYceH9c4ykrC40FuREjBSF+Nw+MiI0to99pXhwvAkedP8pdAof3DM1X1Y
         6dNQ==
X-Gm-Message-State: APjAAAUaehuejJfSarAOdGvXZjKtIj/RnzRA2fsaUJhjHUeDs28bxm+P
        +v+8v1JRXVYVWW6iD/HQCJxRBqL7VAm+AnPhYuk=
X-Google-Smtp-Source: APXvYqwQkQ/95I0fzc054JUC1Fh43YEYXmetYPxWlChU8TNNBStJ8Lc6Oh13xr5q+sPTLvWL3aWP2fNypJYViPa107w=
X-Received: by 2002:a1c:bc89:: with SMTP id m131mr4043690wmf.14.1574148623618;
 Mon, 18 Nov 2019 23:30:23 -0800 (PST)
MIME-Version: 1.0
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
 <1574007266-17123-2-git-send-email-sunil.kovvuri@gmail.com> <20191118131230.6114a357@cakuba.netronome.com>
In-Reply-To: <20191118131230.6114a357@cakuba.netronome.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Tue, 19 Nov 2019 13:00:12 +0530
Message-ID: <CA+sq2Cd63iyhw_=EC_=NL9+QWzRHi_0Vu0d1WAuiDhGRntAYTg@mail.gmail.com>
Subject: Re: [PATCH 01/15] octeontx2-af: Interface backpressure configuration support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 2:42 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Sun, 17 Nov 2019 21:44:12 +0530, sunil.kovvuri@gmail.com wrote:
> > From: Geetha sowjanya <gakula@marvell.com>
> >
> > Enables backpressure and assigns BPID for CGX and LBK channels.
> > 96xx support upto 512 BPIDs, these BPIDs are statically divided
> > across CGX/LBK/SDP interfaces as follows.
> > BPIDs   0 - 191 are mapped to LMAC channels.
> > BPIDs 192 - 255 are mapped to LBK channels.
> > BPIDs 256 - 511 are mapped to SDP channels.
> >
> > BPIDs across CGX LMAC channels are divided as follows.
> > CGX(0)_LMAC(0)_CHAN(0 - 15) mapped to BPIDs(0 - 15)
> > CGX(0)_LMAC(1)_CHAN(0 - 15) mapped to BPIDs(16 - 31)
> > .......
> > CGX(1)_LMAC(0)_CHAN(0 - 15) mapped to BPIDs(64 - 79)
> > ....
> >
> > Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
>
> Can you explain what is being done here from user perspective?
> How is this thing configured? Looks like you just added some
> callbacks for device-originating events?
>

Yes these are mbox handlers which help the netdev and userspace drivers to
configure hardware. The hardware functionality is divided across three entities.
The AF - Admin function, which has the highest privilege to configure
various HW blocks.
The SRIOV PF & VFs, Netdev or userspace drivers register to these
devices and send
communicate with the AF via mbox for configuration, information (eg
stats, hw capabilities) retrieval.

This patchset adds mbox handlers into the AF driver. Right after this
patchset we will submit the
netdev driver patches which will have ethtool etc support with which
user can configure HW.

> And please keep the acronyms which are meaningless to anyone
> upstream to a minimum.

Sure, will try, in this instance the commit message is needed for
future reference
incase someone working on this platform need to understand how the backpressure
IDs (BPIDs) are divided across various physical links through which
traffic flows.

Thanks,
Sunil.
