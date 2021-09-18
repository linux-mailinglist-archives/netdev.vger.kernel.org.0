Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772E64107C3
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 19:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbhIRRNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 13:13:45 -0400
Received: from mout.gmx.net ([212.227.15.19]:44729 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233210AbhIRRNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 13:13:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631985125;
        bh=HaaOH1N5B34fUsGwuYxHkOP8Bmo2FI+Nxh0L4luHKr8=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=VB7DZQsSQo3NdthY+tY5Lzk2zptqyURBOMmdUSo5Agucie2GLm8aROBoioKi0lKvD
         Ld0DnLhHissWEqrg7drrzOVbytBJyYGOyLxJ3qg2tzLEjpw/pEc89piEVlG0qFH81L
         TTNjPM3g0mTe/KElMKvOXjWbqSwUF9dVX+7en8AU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from titan ([79.150.72.99]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M8hV5-1mWIaL2lUX-004l1v; Sat, 18
 Sep 2021 19:12:04 +0200
Date:   Sat, 18 Sep 2021 19:11:47 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Len Baker <len.baker@gmx.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Colin Ian King <colin.king@canonical.com>,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH] net: mana: Prefer struct_size over open coded arithmetic
Message-ID: <20210918152604.GB15999@titan>
References: <20210911102818.3804-1-len.baker@gmx.com>
 <20210918132010.GA15999@titan>
 <D81D1EE2-92A0-42D5-9238-9B05E4BDE230@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D81D1EE2-92A0-42D5-9238-9B05E4BDE230@chromium.org>
X-Provags-ID: V03:K1:/jOFZgiazp1Mu4q1yJZMZHCqZguWrTCVgOiUcRwDstkREyaTGYs
 UBQwp8eIVfvNPaQRfAJFF6LevZRZFI3xZ7MwzMmBLXd1W+g/m5XnL7waXh0U0kTdndpmAi0
 ep8beAtJmIfSZXxkf5ZwEUPtSYRTGnVO38vTd3E9Hlc/eloGCAHpZj4eeqnyIixDxUm7vwb
 h6tbGt6bwtugEagOhPyqw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4M+R8W0zYpQ=:FygVzFs7OR1agH0Yq+kqbo
 4yXp3xJ45NY4137+M42bmwT+MbhbJ0gdkcvFzqOqph1/eLu8KfjQNG6U4FE9XtJiC1sSCxdNW
 EaufVRWhjFaqnoorFfuL9EVRZH7P7TkwnjcfrDZFLcu/1h1zopwG6y4FkcZOZkxk0juI65Y4A
 WjzLJj+NfCR10KLu37ov9IZGJ+Q/30nFgC0dQ/gQXYcMxe9e784tPXZN0/kdwrjB0nfu6XRXQ
 2ZuzQIcW7PNfpl+RwMalhB8F+zffRXsJKZPc32CwByUD9+FLsMRUWEJv1IK3VdZzjXFL0mhBD
 U9be7KyiyTTldxEjrJPDRSgWcNLDb/zr5cpMo827V1uzexubCxYgrbX5+gigQQ/p0cBfUs421
 qvxH+F10bxectyJ9DisLbsYTx04tO36WbLKZ1dtN4QvcbzMeDsiUTVcTWBzPEM93Il2ERzZDN
 93wmvaFCe3p38Ihg6h+E75ndNbMScdzS1PInTaJ7GAh0rsxMqdUuc27M7qzsqJcWFV0LAis+V
 TWXqh1Uf7wk6dQ9rpiAHZjsfZrO9bTkD5a/faEQbpkH1vC4AHtydAbNzwTY5uubOj8uLZ9MbY
 6anjM+JsE0XYCGgvaxeQoFkdbW+TP3LO6i6NeQ4ifONktoaMAjW8D+8hGzSIuyoYJ9SHgRLc/
 VIyr/mORl/sE1edb5tClgyOVEyaXz6/pHdD5QjpzT91ISUXJdtMsqpEsX24DQaO/Jhh/7m2Rt
 tmNp3MoQeutCBpKxwWBjy1mTBUnPkG1lHUiWWpC3vm9mZPgsVoHTuC7RkZ0h2XcqE82B3mOOV
 cfRegKZakpuFCCJ4vtOe6Pm7Q68C5wFFCRmPnfQcprgnnIECvazOq2VEaS/YEtctIV+08BSjs
 1FOxrecBbk0+gCKqzDR2w8D+2kvagp+vz+VJvR2+LwWRPjHgJW+Q/JjylBMEK8Bj56dNMkydi
 TBKvRa7/lp1mUKg4Aak9PeyvqUFz/GZK1sYg3JAnmEyKgADMCV3MSyW6KWijB9lxp9fJtI+bZ
 2Z3i4YDjxzyt+SfTI18TVMJ8NW2ti2a1PussYNfR0/ZxbZteypJI16nT5m5IGWPzZJi4l0o8A
 ze7E3OPLoamLG0=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kees,

On Sat, Sep 18, 2021 at 06:51:51AM -0700, Kees Cook wrote:
>
>
> On September 18, 2021 6:20:10 AM PDT, Len Baker <len.baker@gmx.com> wrot=
e:
> >Hi,
> >
> >On Sat, Sep 11, 2021 at 12:28:18PM +0200, Len Baker wrote:
> >> As noted in the "Deprecated Interfaces, Language Features, Attributes=
,
> >> and Conventions" documentation [1], size calculations (especially
> >> multiplication) should not be performed in memory allocator (or simil=
ar)
> >> function arguments due to the risk of them overflowing. This could le=
ad
> >> to values wrapping around and a smaller allocation being made than th=
e
> >> caller was expecting. Using those allocations could lead to linear
> >> overflows of heap memory and other misbehaviors.
> >>
> >> So, use the struct_size() helper to do the arithmetic instead of the
> >> argument "size + count * size" in the kzalloc() function.
> >>
> >> [1] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#ope=
n-coded-arithmetic-in-allocator-arguments
> >>
> >> Signed-off-by: Len Baker <len.baker@gmx.com>
> >> ---
> >>  drivers/net/ethernet/microsoft/mana/hw_channel.c | 4 +---
> >>  1 file changed, 1 insertion(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drive=
rs/net/ethernet/microsoft/mana/hw_channel.c
> >> index 1a923fd99990..0efdc6c3c32a 100644
> >> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> >> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> >> @@ -398,9 +398,7 @@ static int mana_hwc_alloc_dma_buf(struct hw_chann=
el_context *hwc, u16 q_depth,
> >>  	int err;
> >>  	u16 i;
> >>
> >> -	dma_buf =3D kzalloc(sizeof(*dma_buf) +
> >> -			  q_depth * sizeof(struct hwc_work_request),
> >> -			  GFP_KERNEL);
> >> +	dma_buf =3D kzalloc(struct_size(dma_buf, reqs, q_depth), GFP_KERNEL=
);
> >>  	if (!dma_buf)
> >>  		return -ENOMEM;
> >>
> >> --
> >> 2.25.1
> >>
> >
> >I have received a email from the linux-media subsystem telling that thi=
s
> >patch is not applicable. The email is the following:
> >
> >Hello,
> >
> >The following patch (submitted by you) has been updated in Patchwork:
> >
> > * linux-media: net: mana: Prefer struct_size over open coded arithmeti=
c
> >     - http://patchwork.linuxtv.org/project/linux-media/patch/202109111=
02818.3804-1-len.baker@gmx.com/
> >     - for: Linux Media kernel patches
> >    was: New
> >    now: Not Applicable
> >
> >This email is a notification only - you do not need to respond.
> >
> >The question is: Why it is not applicable?. I have no received any bad =
comment
> >and a "Reviewed-by:" tag from Haiyang Zhang. So, what is the reason for=
 the
> >"Not Applicable" state?.
>
> That is the "Media" subsystem patch tracker. The patch appears to be for=
 networking, so the Media tracker has marked it as "not applicable [to the=
 media subsystem]".
>
> The CC list for this patch seems rather wide (media, dri). I would have =
expected only netdev. Were you using scripts/get_maintainer.pl for getting=
 addresses?

Yes, my workflow is scripts/checkpatch.pl and then scripts/get_maintainer.=
pl
before sending any patch :)

Regards,
Len
>
> -Kees
