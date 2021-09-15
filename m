Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE40C40BDFC
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhIODJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235413AbhIODJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 23:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87C806115B;
        Wed, 15 Sep 2021 03:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631675270;
        bh=yHNeqGITtq+PSPwwH6V9gaIo+EFoUXsGp6CRrpOpzyg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hZC6zvLJpn7NIR1otajaremmLQZH96tkK73BskvqdJHcSYWZpdulDvvLiTGmEKlvN
         y0hq+PgvziSONWPiX/3VyEnVWe8SQ3vYq+lh1PEt8MK/9gfCdoSK4Wm92bpx94KHN3
         A6InMYjd8BOjafSLA3ABq5BX/Mr6IMdIzmBhIjHY+3SDAUwli3sB/mKAveD9Az/DQk
         DNnI2NSvJHkYArlmC0s4uPtIgvNuOu2jw3T8eZn2vZD0pJOJ/K1VGbUr+qRrOhXPCF
         pI5obXheUA5o9l3VPPZ6U7Ka4Bk3Zvj7csMUwjtUqBC5VHQ6YmFSWx9YgoS22ld8LI
         XibTnG3BWqCNQ==
Date:   Tue, 14 Sep 2021 20:07:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: wan: wanxl: define CROSS_COMPILE_M68K
Message-ID: <20210914200749.018391a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210912212321.10982-1-kilobyte@angband.pl>
References: <20210912212321.10982-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Sep 2021 23:23:21 +0200 Adam Borowski wrote:
> It was used but never set.  The hardcoded value from before the dawn of
> time was non-standard; the usual name for cross-tools is $TRIPLET-$TOOL
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
>  This is neither the host nor target arch, thus it's very unlikely to be
>  set by the user.  With this patch, it works out of the box on Debian
>  and Fedora.
> 
>  drivers/net/wan/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
> index f6b92efffc94..480bcd1f6c1c 100644
> --- a/drivers/net/wan/Makefile
> +++ b/drivers/net/wan/Makefile
> @@ -34,6 +34,8 @@ obj-$(CONFIG_SLIC_DS26522)	+= slic_ds26522.o
>  clean-files := wanxlfw.inc
>  $(obj)/wanxl.o:	$(obj)/wanxlfw.inc
>  
> +CROSS_COMPILE_M68K = m68k-linux-gnu-

This will not overwrite the parameter if set from command line, right?
My Makefile-foo is getting rusty.

>  ifeq ($(CONFIG_WANXL_BUILD_FIRMWARE),y)
>  ifeq ($(ARCH),m68k)
>    M68KCC = $(CC)

