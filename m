Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E282A977F
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 15:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgKFOSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 09:18:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39242 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbgKFOSd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 09:18:33 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kb2ZI-005cCn-1E; Fri, 06 Nov 2020 15:18:20 +0100
Date:   Fri, 6 Nov 2020 15:18:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alex Shi <alex.shi@linux.alibaba.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/dsa: remove unused macros to tame gcc warning
Message-ID: <20201106141820.GP933237@lunn.ch>
References: <1604641050-6004-1-git-send-email-alex.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604641050-6004-1-git-send-email-alex.shi@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 01:37:30PM +0800, Alex Shi wrote:
> There are some macros unused, they causes much gcc warnings. Let's
> remove them to tame gcc.
> 
> net/dsa/tag_brcm.c:51:0: warning: macro "BRCM_EG_RC_SWITCH" is not used
> [-Wunused-macros]
> net/dsa/tag_brcm.c:53:0: warning: macro "BRCM_EG_RC_MIRROR" is not used
> [-Wunused-macros]
> net/dsa/tag_brcm.c:55:0: warning: macro "BRCM_EG_TC_MASK" is not used
> [-Wunused-macros]
> net/dsa/tag_brcm.c:35:0: warning: macro "BRCM_IG_TS_SHIFT" is not used
> [-Wunused-macros]
> net/dsa/tag_brcm.c:46:0: warning: macro "BRCM_EG_RC_MASK" is not used
> [-Wunused-macros]
> net/dsa/tag_brcm.c:49:0: warning: macro "BRCM_EG_RC_PROT_SNOOP" is not
> used [-Wunused-macros]
> net/dsa/tag_brcm.c:34:0: warning: macro "BRCM_IG_TE_MASK" is not used
> [-Wunused-macros]
> net/dsa/tag_brcm.c:43:0: warning: macro "BRCM_EG_CID_MASK" is not used
> [-Wunused-macros]
> net/dsa/tag_brcm.c:50:0: warning: macro "BRCM_EG_RC_PROT_TERM" is not
> used [-Wunused-macros]
> net/dsa/tag_brcm.c:54:0: warning: macro "BRCM_EG_TC_SHIFT" is not used
> [-Wunused-macros]
> net/dsa/tag_brcm.c:52:0: warning: macro "BRCM_EG_RC_MAC_LEARN" is not
> used [-Wunused-macros]
> net/dsa/tag_brcm.c:48:0: warning: macro "BRCM_EG_RC_EXCEPTION" is not
> used [-Wunused-macros]
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Andrew Lunn <andrew@lunn.ch> 
> Cc: Vivien Didelot <vivien.didelot@gmail.com> 
> Cc: Florian Fainelli <f.fainelli@gmail.com> 
> Cc: Vladimir Oltean <olteanv@gmail.com> 
> Cc: "David S. Miller" <davem@davemloft.net> 
> Cc: Jakub Kicinski <kuba@kernel.org> 
> Cc: netdev@vger.kernel.org 
> Cc: linux-kernel@vger.kernel.org 
> ---
>  net/dsa/tag_brcm.c | 15 ---------------
>  1 file changed, 15 deletions(-)
> 
> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
> index e934dace3922..ce23b5d4c6b8 100644
> --- a/net/dsa/tag_brcm.c
> +++ b/net/dsa/tag_brcm.c
> @@ -30,29 +30,14 @@
>  /* 1st byte in the tag */
>  #define BRCM_IG_TC_SHIFT	2
>  #define BRCM_IG_TC_MASK		0x7
> -/* 2nd byte in the tag */
> -#define BRCM_IG_TE_MASK		0x3
> -#define BRCM_IG_TS_SHIFT	7
>  /* 3rd byte in the tag */
>  #define BRCM_IG_DSTMAP2_MASK	1
>  #define BRCM_IG_DSTMAP1_MASK	0xff

Hi Alex

It is good to remember that there are multiple readers of source
files. There is the compiler which generates code from it, and there
is the human trying to understand what is going on, what the hardware
can do, how we could maybe extend the code in the future to make use
of bits are currently don't, etc.

The compiler has no use of these macros, at the moment. But i as a
human do. It is valuable documentation, given that there is no open
datasheet for this hardware.

I would say these warnings are bogus, and the code should be left
alone.

	Andrew
