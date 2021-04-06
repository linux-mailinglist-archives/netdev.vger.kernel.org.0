Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9A1355F8A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242852AbhDFXil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:38:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36890 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233184AbhDFXil (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:38:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTvHC-00FD9K-Dh; Wed, 07 Apr 2021 01:38:30 +0200
Date:   Wed, 7 Apr 2021 01:38:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v3 09/18] include: bitmap: add macro for bitmap
 initialization
Message-ID: <YGzw9keA5yZc09bZ@lunn.ch>
References: <20210406221107.1004-1-kabel@kernel.org>
 <20210406221107.1004-10-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210406221107.1004-10-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 12:10:58AM +0200, Marek Behún wrote:
> Use the new variadic-macro.h library to implement macro
> INITIALIZE_BITMAP(nbits, ...), which can be used for compile time bitmap
> initialization in the form
>   static DECLARE_BITMAP(bm, 100) = INITIALIZE_BITMAP(100, 7, 9, 66, 98);
> 
> The macro uses the BUILD_BUG_ON_ZERO mechanism to ensure a compile-time
> error if an argument is out of range.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  include/linux/bitmap.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index 70a932470b2d..a9e74d3420bf 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -8,6 +8,7 @@
>  #include <linux/bitops.h>
>  #include <linux/string.h>
>  #include <linux/kernel.h>
> +#include <linux/variadic-macro.h>
>  
>  /*
>   * bitmaps provide bit arrays that consume one or more unsigned
> @@ -114,6 +115,29 @@
>   * contain all bit positions from 0 to 'bits' - 1.
>   */
>  
> +/**
> + * DOC: initialize bitmap
> + * The INITIALIZE_BITMAP(bits, args...) macro expands to a designated
> + * initializer for bitmap of length 'bits', setting each bit specified
> + * in 'args...'.
> + */

Doesn't the /** mean this is kernel doc? The rest does not seem to
follow kdoc. Does this compile cleanly with W=1?

       Andrew
