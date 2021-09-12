Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D279408204
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 00:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbhILWQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 18:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbhILWQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 18:16:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0174C061574
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 15:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=lAe3YOlZG7Aqii7WC6mYBe4Mp7UcIkZ5vNx+VF5FLwM=; b=nuFJ7lIyqV0pfS23GrUA3v5lk5
        3JS6eRUE+9cVeHw3sv1kYqQfig8pfXg9WSJP2zYBF86KKXivpbvcvMyj2+fhNRCCnkfvIUNsF6KVq
        bQMm8bW0abcmkLg7+UVn5MSTW6CgiCz9NC1o6SzlHRIGDUMd74HAsmdySt9H/Bt6ptlV4+HfR3Sz7
        vwPuOXFU4zPYdsXQAaZLaRH6u5GV/FcWyWeVNdLRy40q0GzwB2h9RITntBC+z5fFCAIjRKllp6zOG
        yLnjrARqbATgD/MPY6oDy10I4Zh/pY3YCEHgu7gAmxI1POcF2aAm+eMSSZSwmpknTs8fL9HeV4A+m
        wLKMmXXg==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPXkt-00HRYB-7p; Sun, 12 Sep 2021 22:15:19 +0000
Subject: Re: [PATCH] net: wan: wanxl: define CROSS_COMPILE_M68K
To:     Adam Borowski <kilobyte@angband.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
References: <20210912212321.10982-1-kilobyte@angband.pl>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <882b37d0-5e3a-2453-c9f1-827de127bd01@infradead.org>
Date:   Sun, 12 Sep 2021 15:15:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210912212321.10982-1-kilobyte@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/21 2:23 PM, Adam Borowski wrote:
> It was used but never set.  The hardcoded value from before the dawn of
> time was non-standard; the usual name for cross-tools is $TRIPLET-$TOOL
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
>   This is neither the host nor target arch, thus it's very unlikely to be
>   set by the user.  With this patch, it works out of the box on Debian
>   and Fedora.
> 
>   drivers/net/wan/Makefile | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
> index f6b92efffc94..480bcd1f6c1c 100644
> --- a/drivers/net/wan/Makefile
> +++ b/drivers/net/wan/Makefile
> @@ -34,6 +34,8 @@ obj-$(CONFIG_SLIC_DS26522)	+= slic_ds26522.o
>   clean-files := wanxlfw.inc
>   $(obj)/wanxl.o:	$(obj)/wanxlfw.inc
>   
> +CROSS_COMPILE_M68K = m68k-linux-gnu-
> +
>   ifeq ($(CONFIG_WANXL_BUILD_FIRMWARE),y)
>   ifeq ($(ARCH),m68k)
>     M68KCC = $(CC)
> 

Just curious: why is all of that M68K/m68k stuff
even in this makefile?

thanks.
-- 
~Randy

