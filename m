Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119CD47FD6D
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 14:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbhL0Nen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 08:34:43 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49697 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232207AbhL0Nen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 08:34:43 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6B1F85C02F9;
        Mon, 27 Dec 2021 08:34:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 27 Dec 2021 08:34:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=eccas9txqRwzn420RGikmBO1/MZ
        DbjZfs4wleP6OsIM=; b=ZgsNEY4++wR5G04uS8sN8hd6DQV3i0jkHjaIo4gnRwF
        DAflW3o5AbucVwGR+3R6FBmqbTrI3od1pLdb95xxfZMIwhxGeuEI+ZBNzE4Ygpj6
        MmZcEJ1fGTn0P9pNFOdm3GN2tqj/FP+MkPJmWZP9OEdPYolcsgCaCAEjG/hek1b+
        BhBZMgdQOeKJBPK2luLtb5WJgUAMI55TOMBmiyTqQoDXxAVgCzaMzSmgo/+sY7oi
        hPyxTFoesKn6wUfIDScbIQhmb0+bzAQ2MxswrE0Uuj/77dZFR3pgi/OePXsglcFR
        jSswb9CShezR7IKghvC072ufnn+Hy7XcNtdBEdDarLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=eccas9
        txqRwzn420RGikmBO1/MZDbjZfs4wleP6OsIM=; b=ZU7J9hWtuOKV/8JJK3tNdh
        Op/Ilj+OpLZxPHJb/hM/QCeni97pFBVnSPOQPoIgsQMHRVWcaf7f/zoGhTbinn8P
        eLa5l/907sgwJgNXQCrF0yvoRdbszlOzjCCTcS1lqOm4QKXvFMYai8rjtx/sN7g8
        NkZNbVaSlVhxr3qezULj3/6076XotRKrTNSwhr1O3tbYyyHROQs0E9PAbLH53fSy
        w8mOWzkXsurZ++diujuCl+W557xZS4wzgjizP2h96aayvaJnrzURbyhlXBp9rySV
        7BEYauPFGUzCOCbt2WKLdSznJmNFPq54cAP0EIllc4uzAGKGX8dfu/iW5l6uyduQ
        ==
X-ME-Sender: <xms:8sDJYdZ5dBQF1YYJyyeiKcF7OIhcSEeomSJLuXxcHm63OCqo4w2cfg>
    <xme:8sDJYUZATIgZvFoHnxCtMLjiCi9mt1vLzItzSD5p8ds6xcIzfvMkHAMUBUnW0N5Jk
    C6OrNKsW6vC0g>
X-ME-Received: <xmr:8sDJYf-ZHnb0GzH2Pnhw9v79IJxAJYGGHjh-pxDSlFXMG6xnwTRgdTZPDNS2kQdXnOpgbApdBd7V06YeTjnnjwlRsL-dTPog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddujedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepveeuheejgfffgfeivddukedvkedtleelleeghfeljeeiue
    eggeevueduudekvdetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:8sDJYboXWieQS8LFk_J_IPnVQM4Clh8pOObiWQwPoaaEEpomqXdWuQ>
    <xmx:8sDJYYr6aBqT1AswuXP4QFmPxqcyN-WMQSO8189NansCMRnnM6B9Cg>
    <xmx:8sDJYRRF6bOYyMSXCEg085ngujmdxycOilb_f-JjJAlNDPweBR61vA>
    <xmx:8sDJYRkZxcj76a71TNKu6fTHKOC2DA534qY1zOSgeCyzpl-yURFySg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Dec 2021 08:34:41 -0500 (EST)
Date:   Mon, 27 Dec 2021 14:34:40 +0100
From:   Greg KH <greg@kroah.com>
To:     Adam Kandur <sys.arch.adam@gmail.com>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev
Subject: Re: [PATCH] qlge: rewrite qlge_change_rx_buffers()
Message-ID: <YcnA8LBwH1X/xqKt@kroah.com>
References: <CAE28pkNNsUnp4UiaKX-OjAQHPGjSNY6+hn-oK39m8w=ybXSO6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE28pkNNsUnp4UiaKX-OjAQHPGjSNY6+hn-oK39m8w=ybXSO6Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 04:19:10PM +0300, Adam Kandur wrote:
> I replaced while loop with for. It looks nicer to me.
> 
> Signed-off-by: Adam Kandur <sys.arch.adam@gmail.com>
> 
> ---
>  drivers/staging/qlge/qlge_main.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 9873bb2a9ee4..69d57c2e199a 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -4012,19 +4012,17 @@ static int qlge_change_rx_buffers(struct
> qlge_adapter *qdev)
> 
>         /* Wait for an outstanding reset to complete. */
>         if (!test_bit(QL_ADAPTER_UP, &qdev->flags)) {
> -               int i = 4;
> +               for (int i = 4; !test_bit(QL_ADAPTER_UP, &qdev->flags); i--) {
> +                       if (!i) {
> +                               netif_err(qdev, ifup, qdev->ndev,
> +                                         "Timed out waiting for adapter UP\n");
> +                               return -ETIMEDOUT;
> +                       }
> 
> -               while (--i && !test_bit(QL_ADAPTER_UP, &qdev->flags)) {
>                         netif_err(qdev, ifup, qdev->ndev,
>                                   "Waiting for adapter UP...\n");
>                         ssleep(1);
>                 }
> -
> -               if (!i) {
> -                       netif_err(qdev, ifup, qdev->ndev,
> -                                 "Timed out waiting for adapter UP\n");
> -                       return -ETIMEDOUT;
> -               }
>         }
> 
>         status = qlge_adapter_down(qdev);
> -- 
> 2.34.0
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch is malformed (tabs converted to spaces, linewrapped, etc.)
  and can not be applied.  Please read the file,
  Documentation/email-clients.txt in order to fix this.

- You did not specify a description of why the patch is needed, or
  possibly, any description at all, in the email body.  Please read the
  section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what is needed in order to
  properly describe the change.

- You did not write a descriptive Subject: for the patch, allowing Greg,
  and everyone else, to know what this patch is all about.  Please read
  the section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what a proper Subject: line should
  look like.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
