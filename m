Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618A54106BB
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 15:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbhIRNWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 09:22:15 -0400
Received: from mout.gmx.net ([212.227.17.20]:47769 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhIRNWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 09:22:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631971222;
        bh=utd0q4hqIMtuJEsThLosqrfrDQjZp+7lfixpFX7XqnI=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=LWTfMYcASFTf67QItbBWAZMgfjABOCJnq4qSUTWVkOAtVhBwNq0hgqMVJFGO0reQV
         1OBScoMwlAruAkx1+LnLyWnUG6F6mthX3pbBDxBChCBtPm0B2giHjopoBJR5qik4og
         rHuMrAeT599Y25tj4UQbiNY3NSjUBCCyqyswkthg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from titan ([79.150.72.99]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MNKhm-1mH5ci08wk-00OmPk; Sat, 18
 Sep 2021 15:20:22 +0200
Date:   Sat, 18 Sep 2021 15:20:10 +0200
From:   Len Baker <len.baker@gmx.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Kees Cook <keescook@chromium.org>
Cc:     Len Baker <len.baker@gmx.com>,
        Colin Ian King <colin.king@canonical.com>,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH] net: mana: Prefer struct_size over open coded arithmetic
Message-ID: <20210918132010.GA15999@titan>
References: <20210911102818.3804-1-len.baker@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210911102818.3804-1-len.baker@gmx.com>
X-Provags-ID: V03:K1:BPsfjmvLWKWmUtY2rfEeoDvxY6Wuum+kDmKPnYfRtNYpw8qgDAD
 RhTDWgmsIEN+bzwDQEpc3L/j6yAPdII+XK7ekbbFRT+WCGCF+/aq+yq2YmAPesXrZu3fRfx
 wW7jNo6iQ7H5V5LYlTFcYwbOe4bNIRmOLUTAIiWaGRfv2n3S9hvz/U7QU1NsODbw6onb6aM
 LL0BxR0LXzP/M0XqAQB0g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qStfD7wYGCw=:CcrsvfQSdNHEuPuePCcNlz
 IO+6yJb1Wzy05aUq3UsQCasVn8xv1ZUVRo6mHXjGimDZR4Did1bGuQyqPt+XUG1jlB05UqUJ0
 nWgRzgDrI1CHIz5yOaIEMUilrjTv/tXfj4iWBp/wcdvTqycEWi2GeWER1sCrx5m01Vc0gA8as
 uve1NAj8KXEdS8aPmN4KTN5acD0gl75Z98tR9G8pEJfcYjb8YHzSO6JgkXKvJwVwdXHkbKs3i
 RxcNn1X7TnutYQShodSla+6tgDLTiZQQMwpJ2yH6Njx7FkubrnJdiwL54PO9mcQbTy6snpaMY
 5xtq1LtIyYUghT5r3+nPkI9AOX7fTLY2DxioCYD0CTZfvbFlAKBY8NYq2TghQDzNHD2t18w7N
 xmmOnWY9cQ31BmrpEQSwPsDlp3Wn9wUK1RZC9tPJ8Qac7X7qry31ZjiQTjHf3Dh6rfZxogl+H
 lwi7zwkbJx6YysMfJaWcDR2JtUjIi3SXCoWF5+qI2tNCwJcjyQXcxJuKcXkDrm4tamdeLfNAH
 OnOogVvQ3bz2Y2lxjadQn7BaA/OMwM3boxeoHeWgowB2OiJAfnWTeieKs+WreKsZfZ3SN02PK
 muAQRPzfq004pN3SeI0zhzo0TPv3jzasctsi3/9NsGnnBnbcaN3yWu9brDUVxYQ7u4N6Ry7lY
 aE/f4oqeplwQASCnvDVWBW+M6vSyREznTSVBFi7zYxPoJ6KEolM5NgS4zvjYiE1kL0Yosoami
 mLe4VLryD/hSLshKzRqi6HGK7pWpGygCdX1XeGol4LhPoEyogqJoDeZFIuCWosuOvp7aB+RRv
 CrdE0Y2dbmIC9zbUA/etHs6BsBKe876fVfiUWARtpd13vusxAgNMlbOC7+WMv3ObKb15g795X
 tLuzE2X5o6emAtu47HgKo668A8WeIvtw9rM/NXc23EPhjK2jlLxPHKWgzqUNGXq394CArijMk
 z/+md7oA7PQVxaXk7GCAIdke1ektjaz+8eadbTr1h898jGZUljVJzOIEFA22xNnMFXitgDuK6
 ninxUQ4qfEUX0wYviLSceiJ0FVn98lk7BQ7qtWOplhQCIlzH8Fi0luyTAbzFUSSo7F5wv8zaK
 THujcWZZ3EUjUQ=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Sep 11, 2021 at 12:28:18PM +0200, Len Baker wrote:
> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or similar)
> function arguments due to the risk of them overflowing. This could lead
> to values wrapping around and a smaller allocation being made than the
> caller was expecting. Using those allocations could lead to linear
> overflows of heap memory and other misbehaviors.
>
> So, use the struct_size() helper to do the arithmetic instead of the
> argument "size + count * size" in the kzalloc() function.
>
> [1] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#open-c=
oded-arithmetic-in-allocator-arguments
>
> Signed-off-by: Len Baker <len.baker@gmx.com>
> ---
>  drivers/net/ethernet/microsoft/mana/hw_channel.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/=
net/ethernet/microsoft/mana/hw_channel.c
> index 1a923fd99990..0efdc6c3c32a 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -398,9 +398,7 @@ static int mana_hwc_alloc_dma_buf(struct hw_channel_=
context *hwc, u16 q_depth,
>  	int err;
>  	u16 i;
>
> -	dma_buf =3D kzalloc(sizeof(*dma_buf) +
> -			  q_depth * sizeof(struct hwc_work_request),
> -			  GFP_KERNEL);
> +	dma_buf =3D kzalloc(struct_size(dma_buf, reqs, q_depth), GFP_KERNEL);
>  	if (!dma_buf)
>  		return -ENOMEM;
>
> --
> 2.25.1
>

I have received a email from the linux-media subsystem telling that this
patch is not applicable. The email is the following:

Hello,

The following patch (submitted by you) has been updated in Patchwork:

 * linux-media: net: mana: Prefer struct_size over open coded arithmetic
     - http://patchwork.linuxtv.org/project/linux-media/patch/202109111028=
18.3804-1-len.baker@gmx.com/
     - for: Linux Media kernel patches
    was: New
    now: Not Applicable

This email is a notification only - you do not need to respond.

The question is: Why it is not applicable?. I have no received any bad com=
ment
and a "Reviewed-by:" tag from Haiyang Zhang. So, what is the reason for th=
e
"Not Applicable" state?.

Regards,
Len
