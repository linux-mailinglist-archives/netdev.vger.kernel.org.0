Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA80449E89
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 22:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238713AbhKHWCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 17:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbhKHWCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 17:02:14 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC297C061570;
        Mon,  8 Nov 2021 13:59:29 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w1so68810527edd.10;
        Mon, 08 Nov 2021 13:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m7ZGdMsF2LF80W4Ei62QyUvyEYdZksqCOjuZgbdTzXM=;
        b=g1JAYgK6w6gF2Ckz262/LCX5T7nKXH6ANG22Q6bKY4eChnuJspaOw9Z5lQIFANWuon
         zVglVuFe31XoGdNQwReaOBfsfy+IWWVUNFaCaOffC2kFBlEYF0g8/o0MYh5Ucx5A+r3D
         u+4ZmcVfZ3Oh28XFxhDH8BTbB2NgufAJUOFGjjV9WV04FlkmtJzYHiippV6Tj4yDHzbY
         xTB/q8tyDKlx4GIO4+mjFYwVYTy1hHSrzWuSk8IfIsacqna+cQqkAjdIhp1wzQVh4p9X
         r7np7JtFmyjvt4SHsqPTQh2Az7He5l0uDcMtYBs0+xtinS7miDPOR/xz/S9jgnJQFto6
         QgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m7ZGdMsF2LF80W4Ei62QyUvyEYdZksqCOjuZgbdTzXM=;
        b=GhLYVi7QGzvHRBSugcqGmxJMg+09FoBCT8FgiaJpOkfPoZBkBN40munmEkyCUsvsEy
         ZVE5jUJN/lh8R8qK/0ZuuMSZpsitE/HUnB3/3fTRXMfcouChm5jwwQwrTn3VG83saABi
         Br+tqYrBSQ6Lprc16K0vgQ2uEk12GaITN1bvZASlbkfUoqhAL8/OdOZkENDnU4ibBM7q
         kWBon3tXu/AmzUsiazzui18trPRiviYGTNd9CEPwiL+rPewr2PiPCk+qFfhVf0XKHYRi
         /SHuvQ0zIctJ3ovkw/HD/iO7ccYnPz1HwP7xM9Sai29KYIqFNiFzgkKFnDES4i1d4IDr
         wHtQ==
X-Gm-Message-State: AOAM530lJUewvYLKmxWsUeH3ZNYkQGRdd7NjdDs0llFIVaxNRtP7A6Iy
        1PlNo+zNYnckNb9jgyt402s=
X-Google-Smtp-Source: ABdhPJy2AlBqCOnX3v2S5xt2+xkkhUEAkj7GsSIGWYaIw/iYw6UZ7PN3MN8bT8VGq7wPQFcABt3aRg==
X-Received: by 2002:a17:906:c152:: with SMTP id dp18mr3046856ejc.241.1636408768345;
        Mon, 08 Nov 2021 13:59:28 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id g9sm8473027ejo.60.2021.11.08.13.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 13:59:28 -0800 (PST)
Date:   Mon, 8 Nov 2021 23:59:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabor Juhos <j4g8y7@gmail.com>, John Crispin <john@phrozen.org>
Subject: Re: [net-next] net: dsa: qca8k: only change the MIB_EN bit in
 MODULE_EN register
Message-ID: <20211108215926.hnrmqdyxbkt7lbhl@skbuf>
References: <20211104124927.364683-1-robert.marko@sartura.hr>
 <20211108202058.th7vjq4sjca3encz@skbuf>
 <CA+HBbNE_jh_h9bx9GLfMRFz_Kq=Vx1pu0dE1aK0guMoEkX1S5A@mail.gmail.com>
 <20211108211811.qukts37eufgfj4sc@skbuf>
 <CA+HBbNGvg43wMNbte827wmK_fnWuweKSgA-nWW+UPGCvunUwGA@mail.gmail.com>
 <20211108214613.5fdhm4zg43xn5edm@skbuf>
 <CA+HBbNEKOW3F6Yu=OV3BDea+KKNH6AEUMS07az6=62aEAKHGgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+HBbNEKOW3F6Yu=OV3BDea+KKNH6AEUMS07az6=62aEAKHGgw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 10:56:51PM +0100, Robert Marko wrote:
> On Mon, Nov 8, 2021 at 10:46 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Mon, Nov 08, 2021 at 10:39:27PM +0100, Robert Marko wrote:
> > > On Mon, Nov 8, 2021 at 10:18 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > >
> > > > On Mon, Nov 08, 2021 at 10:10:19PM +0100, Robert Marko wrote:
> > > > > On Mon, Nov 8, 2021 at 9:21 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > > >
> > > > > > Timed out waiting for ACK/NACK from John.
> > > > > >
> > > > > > On Thu, Nov 04, 2021 at 01:49:27PM +0100, Robert Marko wrote:
> > > > > > > From: Gabor Juhos <j4g8y7@gmail.com>
> > > > > > >
> > > > > > > The MIB module needs to be enabled in the MODULE_EN register in
> > > > > > > order to make it to counting. This is done in the qca8k_mib_init()
> > > > > > > function. However instead of only changing the MIB module enable
> > > > > > > bit, the function writes the whole register. As a side effect other
> > > > > > > internal modules gets disabled.
> > > > > >
> > > > > > Please be more specific.
> > > > > > The MODULE_EN register contains these other bits:
> > > > > > BIT(0): MIB_EN
> > > > > > BIT(1): ACL_EN (ACL module enable)
> > > > > > BIT(2): L3_EN (Layer 3 offload enable)
> > > > > > BIT(10): SPECIAL_DIP_EN (Enable special DIP (224.0.0.x or ff02::1) broadcast
> > > > > > 0 = Use multicast DP
> > > > > > 1 = Use broadcast DP)
> > > > > >
> > > > > > >
> > > > > > > Fix up the code to only change the MIB module specific bit.
> > > > > >
> > > > > > Clearing which one of the above bits bothers you? The driver for the
> > > > > > qca8k switch supports neither layer 3 offloading nor ACLs, and I don't
> > > > > > really know what this special DIP packet/header is).
> > > > > >
> > > > > > Generally the assumption for OF-based drivers is that one should not
> > > > > > rely on any configuration done by prior boot stages, so please explain
> > > > > > what should have worked but doesn't.
> > > > >
> > > > > Hi,
> > > > > I think that the commit message wasn't clear enough and that's my fault for not
> > > > > fixing it up before sending.
> > > >
> > > > Yes, it is not. If things turn out to need changing, you should resend
> > > > with an updated commit message.
> > > >
> > > > > MODULE_EN register has 3 more bits that aren't documented in the QCA8337
> > > > > datasheet but only in the IPQ4019 one but they are there.
> > > > > Those are:
> > > > > BIT(31) S17C_INT (This one is IPQ4019 specific)
> > > > > BIT(9) LOOKUP_ERR_RST_EN
> > > > > BIT(10) QM_ERR_RST_EN
> > > >
> > > > Are you sure that BIT(10) is QM_ERR_RST_EN on IPQ4019? Because in the
> > > > QCA8334 document I'm looking at, it is SPECIAL_DIP_EN.
> > >
> > > Sorry, QM_ERR_RST_EN is BIT(8) and it as well as LOOKUP_ERR_RST_EN should
> > > be exactly the same on QCA833x switches as well as IPQ4019 uses a
> > > variant of QCA8337N.
> > > >
> > > > > Lookup and QM bits as well as the DIP default to 1 while the INT bit is 0.
> > > > >
> > > > > Clearing the QM and Lookup bits is what is bothering me, why should we clear HW
> > > > > default bits without mentioning that they are being cleared and for what reason?
> > > >
> > > > To be fair, BIT(9) is marked as RESERVED and documented as being set to 1,
> > > > so writing a zero is probably not very smart.
> > > >
> > > > > We aren't depending on the bootloader or whatever configuring the switch, we are
> > > > > even invoking the HW reset before doing anything to make sure that the
> > > > > whole networking
> > > > > subsystem in IPQ4019 is back to HW defaults to get rid of various
> > > > > bootloader hackery.
> > > > >
> > > > > Gabor found this while working on IPQ4019 support and to him and to me it looks
> > > > > like a bug.
> > > >
> > > > A bug with what impact? I don't have a description of those bits that
> > > > get unset. What do they do, what doesn't work?
> > >
> > > LOOKUP_ERR_RST_EN:
> > > 1b1:Enableautomatic software reset by hardware due to
> > > lookup error.
> > >
> > > QM_ERR_RST_EN:
> > > 1b1:enableautomatic software reset by hardware due to qm
> > > error.
> > >
> > > So clearing these 2 disables the built-in error recovery essentially.
> > >
> > > To me clearing the bits even if they are not breaking something now
> > > should at least have a comment in the code that indicates that it's intentional
> > > for some reason.
> > > I wish John would explain the logic behind this.
> >
> > That sounds... aggressive. Have you or Gabor exercised this error path?
> > What is supposed to happen? Is software prepared for the hardware to
> > automatically reset?
> 
> I am not trying to be aggressive, but to me, this is either a bug or they are
> intentionally cleaned but it's not documented.
> Have tried triggering the QM error, but couldn't hit it even when
> doing crazy stuff.
> It should be nearly impossible to hit it, but it's there to prevent
> the switch from just locking up
> under extreme conditions (At least that is how I understand it).
> 
> I don't think the driver currently even monitors the QM registers at all.
> I can understand clearing these bits intentionally, but it's gotta be
> documented otherwise
> somebody else is gonna think is a bug/mistake/whatever in the code.

Oh no no, I'm not saying that you're aggressive, but the hardware
behavior of automatically performing a software reset.

The driver keeps state. If the switch just resets by itself, what do you
think will continue to work fine afterwards? The code path needs testing.
I am not convinced that a desynchronized software state is any better
than a lockup.
