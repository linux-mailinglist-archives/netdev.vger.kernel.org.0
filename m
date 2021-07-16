Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599DC3CB975
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240548AbhGPPMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:12:06 -0400
Received: from mout.gmx.net ([212.227.17.22]:33033 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237211AbhGPPMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 11:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626448129;
        bh=sL/vPV8V2S1SS05EJUeg1OhF8H9B92zX2u7/UMjHgtA=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=jEGepE8cAXXPL7zxhN3bHCLkmLrr1GS6FuSRDj815tx2FTXEdiT0aYrAbnYv1UXHi
         py2XnPUBcglFYrJbbzpVpR7tbq9uPhSAPU2QA1Wdu3Fs2dQToJqHHOfXJYaHHlNBaa
         HrQYGtn6PO2nsTgjmYFQTCf9GQBqh6HfdiKFhJAg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from titan ([83.52.228.41]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MHG8m-1lrC3V2A4W-00DJQ3; Fri, 16
 Jul 2021 17:08:49 +0200
Date:   Fri, 16 Jul 2021 17:08:32 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Brian Norris <briannorris@chromium.org>,
        Pkshih <pkshih@realtek.com>
Cc:     Len Baker <len.baker@gmx.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] rtw88: Fix out-of-bounds write
Message-ID: <20210716150832.GA3963@titan>
References: <20210711141634.6133-1-len.baker@gmx.com>
 <b0811e08c4a04d2093f3251c55c0edb8@realtek.com>
 <CA+ASDXOC_dqhf84kP4LsbenJuqeDyKcNFj=EaemrvfJy1oZi_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ASDXOC_dqhf84kP4LsbenJuqeDyKcNFj=EaemrvfJy1oZi_Q@mail.gmail.com>
X-Provags-ID: V03:K1:FL6qu4j5wqlHgHFdnywZE5ywx9Klh+8cxQfSpQdCnflRsOLnkAX
 3x79fIQXKzWX/TOArPhOuW5/Gnf+ftRR3644uA+H5oICVs+w0R4sdmxzASoHM5hOoP6OChs
 ztiPnHIsI4oohN+AnhcqUVQz4l6mQmwFQXC0wC8tXfY66swuN3VLAcVarXeBvk5UCvpT91M
 fIzFKkTXwr/bh4bWd6l1g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bUASaPtJOP4=:9HHIghxNT6h204deC0zip6
 xmcF53QoWnFyNy0WQPKnTlZaSJ0Ga57bJMjEprvBNpEecxPoOu4NSthvGTZpA61gQK57CBMeD
 u+b/wP6Heq1qTLzOQtMpkSQpUyvgqn6D3SxPWqa6ZMLhzwgLojll8OobLHs+WIV+kwpQhB2pR
 gD6lPwORaR4lLVKkzT1FTIxM4juPJgW0eZRr7RvYuV/ep3ZzaWc28WvsURXqEMruAWR2cOgxp
 dyQdUigcv0Pm/FjTGeoaQ1XX55YEJDuuL53LdOm+ftYSl9oPvuGWjfPrxuuLrlPLe5mQM0GZl
 JeAKAIppHg2dpsJnnaDDgFnnb4ohUrv+5SedJAJbvfkvkpDi2Nantcqbw1Xnfp6DABWDuHbSI
 0s52TRqxg++sLyxymJSWDEMXiAYKv3/fS8j1G2/OD7VlqCaCojSaQSfTGQfe5IY/HDSf+LcH/
 QbezTZ/Xh1WNfIYyHl1LNfsAjoF76iMK8kQBcpSKG/yAVcfnWmaBFSy1nE4Ts7iW1rNxXnivw
 9njSIxC0SK3/JzECvaTS2/ukDXXJw8M/Slu6uuyKOjkmK7q8KzaA2wqMChhuDz+nMAhs8mKlJ
 3NzmmZoB8sdiuh56J/1Rkmpz7lTq30PYMdaIykMr0GcwnVAJI3HX8YCilC+EKXqH3mB5eBf2M
 1oV9fUIbvmM0l580VV6b25Z/pHTi5TRQiBussjerobwiOLQO3ZSfXOBG7N3LE18ZaP6Mj+NWT
 Rtxnci3cabTQJrp4Mh1Kocmvpbf32f2r8BYSuK3wB6s6p7fKfrfJKGv9K0nQTsezi2VNgSBj1
 DllNHNFcRiCsBo+/4gq/YGY4zLiUo5InjNtCDsRGQC3x4Tp40S9v+0Bzb5wyd3NEe0tZQ+6s2
 HS/rImag3Z3/rdyeR7J5//sx/g76Cz8nvvj8h5SP+2MS2AXuRqiD+NmEPxAZEHJNwwtVGFJ+C
 92Gzt0dvuYv+S2lR1pmqSNiaZM2SUZtMcivECVF9EpuSPcAbAAlzxmdsdMcD5hDdtO92dMfxO
 EVGQhKVV/K/gIkEsl5ZFKCD2oo3fN0WK7oqAplHcoBJlK72/1WlbFIMZY2BoWejaJBjJ4/xm4
 yOAE5BHmskQxDYLauKWUyTu3q82cAUoW755
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 11:38:43AM -0700, Brian Norris wrote:
> On Sun, Jul 11, 2021 at 6:43 PM Pkshih <pkshih@realtek.com> wrote:
> > > -----Original Message-----
> > > From: Len Baker [mailto:len.baker@gmx.com]
> > >
> > > In the rtw_pci_init_rx_ring function the "if (len > TRX_BD_IDX_MASK)=
"
> > > statement guarantees that len is less than or equal to GENMASK(11, 0=
) or
> > > in other words that len is less than or equal to 4095. However the
> > > rx_ring->buf has a size of RTK_MAX_RX_DESC_NUM (defined as 512). Thi=
s
> > > way it is possible an out-of-bounds write in the for statement due t=
o
> > > the i variable can exceed the rx_ring->buff size.
> > >
> > > Fix it using the ARRAY_SIZE macro.
> > >
> > > Cc: stable@vger.kernel.org
> > > Addresses-Coverity-ID: 1461515 ("Out-of-bounds write")
>
> Coverity seems to be giving a false warning here. I presume it's
> taking the |len| comparison as proof that |len| might be as large as
> TRX_BD_IDX_MASK, but as noted below, that's not really true; the |len|
> comparison is really just dead code.

I agree.

> > > Fixes: e3037485c68ec ("rtw88: new Realtek 802.11ac driver")
> > > Signed-off-by: Len Baker <len.baker@gmx.com>
>
> > To prevent the 'len' argument from exceeding the array size of rx_ring=
->buff, I
> > suggest to add another checking statement, like
> >
> >         if (len > ARRAY_SIZE(rx_ring->buf)) {
> >                 rtw_err(rtwdev, "len %d exceeds maximum RX ring buffer=
\n", len);
> >                 return -EINVAL;
> >         }
>
> That seems like a better idea, if we really need to patch anything.

I think it is reasonable to protect any potencial overflow (for example, i=
f
this function is used in the future with a parameter greater than 512). It
is better to be defensive in this case :)

> > But, I wonder if this a false alarm because 'len' is equal to ARRAY_SI=
ZE(rx_ring->buf)
> > for now.
>
> Or to the point: rtw_pci_init_rx_ring() is only ever called with a
> fixed constant -- RTK_MAX_RX_DESC_NUM (i.e., 512) -- so the alleged
> overflow cannot happen.
>
> Brian

I will send a v2 for review.

Thanks,
Len
