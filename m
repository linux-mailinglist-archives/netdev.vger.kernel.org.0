Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51486877F8
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjBBIzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjBBIzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:55:38 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7864DC64D;
        Thu,  2 Feb 2023 00:55:36 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id me3so3934106ejb.7;
        Thu, 02 Feb 2023 00:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1HYgDyfnnHKk/OQESGkNzkdr8YYuZQecT/WNQVKdOjI=;
        b=J40f4wvG8CkTHewvl8K8SMq7UxsAY97JjAcLJ5wWrS4b3HjAi/SwTKrEunFRfstlQG
         8+qiSkp7pm98Oyg0PSNRDcqNCvcH9ewu1Xj06WpTJIe/Nl1R/N+hhC11BgV8tOVyZEhf
         m9tfIIWgWvZGU97PgL63oju5YrkERo8Z98TDiwnYwQLaw8nuDVkqk+dAuAc0YaOt39il
         z9xnmNlsCX88//VoaCFz0O829pgILlEHhLIlPj8e8xb8HurDbsE1E52NKq5lDf5aBdYe
         OXSEaGnmAZzkQrYHWbnGV9ZOmGmsP2LtsZHI65bgjIfzNn1CPg8PaCvvSeqFmGW+f9sU
         fvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1HYgDyfnnHKk/OQESGkNzkdr8YYuZQecT/WNQVKdOjI=;
        b=4CBYOf6i8RHsjVIQtawq7t6JkGRkjRCgSWBn0c59RJxn5NjNux+s0hrdPdeGoY/Wdu
         CMHCG2I65gBJwpP2g+xACBJlNR5M8aRajbbGuF+ZpQZaS8+v1gp5NbgF8Wja6VhidgGy
         gZ2cerGRRm9PRbBmcAHw1vFBlDSpv2CZVxRXEKdoWEATqSMhF2VjP0jGXFvvoxuCoLOc
         IsTYIkDCp+9EQcO8KlkFGkcV/PVeXA5es7XOIzncM2JMvU1G7x6RZtu11me38nxEfbtr
         BBHJrZLg+idMzUgAVOx20X6kQGtKuL1QxCpv+QOAWL7dft0Vjap9N1VCpvZufdfg0dgC
         +T4w==
X-Gm-Message-State: AO0yUKUEZYxGqbEAOatNL2ftxhoagtjTZ/rc/DZLjQY/A2zPrlf588cP
        TPtd0Gccx9bXq52bbp/uZAQ=
X-Google-Smtp-Source: AK7set8F2jLZO079OG8blF5c1tA44UsJa3gV7lMeGUo6AMS3TkIJSBIvNRY1XmCXcYS7Pa320BTCTw==
X-Received: by 2002:a17:906:646:b0:878:79a4:26b6 with SMTP id t6-20020a170906064600b0087879a426b6mr5633731ejb.74.1675328134891;
        Thu, 02 Feb 2023 00:55:34 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id op27-20020a170906bcfb00b0084bfd56fb3bsm11246231ejb.162.2023.02.02.00.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 00:55:34 -0800 (PST)
Date:   Thu, 2 Feb 2023 09:55:34 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v4 ethtool-next 2/2] add support for IEEE 802.3cg-2019
 Clause 148 - PLCA RS
Message-ID: <Y9t6hlh2eRHGyq5m@gvm01>
References: <cover.1671236215.git.piergiorgio.beruto@gmail.com>
 <1ddabd3850c3f3aea4b2ce840a053f0e917803ba.1671236216.git.piergiorgio.beruto@gmail.com>
 <20230201212845.t5qriiofktivtzse@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201212845.t5qriiofktivtzse@lion.mk-sys.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 10:28:45PM +0100, Michal Kubecek wrote:
> On Sat, Dec 17, 2022 at 01:50:39AM +0100, Piergiorgio Beruto wrote:
> > This patch adds support for the Physical Layer Collision Avoidance
> > Reconciliation Sublayer which was introduced in the IEEE 802.3
> > standard by the 802.3cg working group in 2019.
> > 
> > The ethtool interface has been extended as follows:
> > - show if the device supports PLCA when ethtool is invoked without FLAGS
> >    - additionally show what PLCA version is supported
> >    - show the current PLCA status
> > - add FLAGS for getting and setting the PLCA configuration
> > 
> > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > ---
> >  Makefile.am        |   1 +
> >  ethtool.c          |  21 ++++
> >  netlink/extapi.h   |   6 +
> >  netlink/plca.c     | 295 +++++++++++++++++++++++++++++++++++++++++++++
> >  netlink/settings.c |  86 ++++++++++++-
> 
> Please update also the manual page (ethtool.8.in), this should be done
> whenever adding a new feature so that documented and implemented
> features don't diverge.
I wrote the required text, please have a look and see it's ok!
> 
> [...]
> > diff --git a/netlink/extapi.h b/netlink/extapi.h
> > index 1bb580a889a8..0add156e644a 100644
> > --- a/netlink/extapi.h
> > +++ b/netlink/extapi.h
> [...]
> > @@ -114,6 +117,9 @@ nl_get_eeprom_page(struct cmd_context *ctx __maybe_unused,
> >  #define nl_getmodule		NULL
> >  #define nl_gmodule		NULL
> >  #define nl_smodule		NULL
> > +#define nl_get_plca_cfg		NULL
> > +#define nl_set_plca_cfg		NULL
> > +#define nl_get_plca_status	NULL
> >  
> >  #endif /* ETHTOOL_ENABLE_NETLINK */
> >  
> 
> The function names are misspelled here so that a build with
> --disable-netlink fails.
Ok, sorry about that. I've fixed the problem and tested with
--disable-netlink. Should be OK now.
> 
> [...]
> > diff --git a/netlink/plca.c b/netlink/plca.c
> > new file mode 100644
> > index 000000000000..f7d7bdbc5c84
> > --- /dev/null
> > +++ b/netlink/plca.c
> > @@ -0,0 +1,295 @@
> > +/*
> > + * plca.c - netlink implementation of plca command
> > + *
> > + * Implementation of "ethtool --show-plca <dev>" and
> > + * "ethtool --set-plca <dev> ..."
> > + */
> > +
> > +#include <errno.h>
> > +#include <string.h>
> > +#include <stdio.h>
> > +
> > +#include "../internal.h"
> > +#include "../common.h"
> > +#include "netlink.h"
> > +#include "bitset.h"
> > +#include "parser.h"
> > +
> > +/* PLCA_GET_CFG */
> [...]
> > +int plca_get_cfg_reply_cb(const struct nlmsghdr *nlhdr, void *data)
> > +{
> > +	const struct nlattr *tb[ETHTOOL_A_PLCA_MAX + 1] = {};
> > +	DECLARE_ATTR_TB_INFO(tb);
> > +	struct nl_context *nlctx = data;
> > +	bool silent;
> > +	int idv, val;
> > +	int err_ret;
> > +	int ret;
> [...]
> > +		// The node count is ignored by follower nodes. However, it can
> > +		// be pre-set to enable fast coordinator role switchover.
> > +		// Therefore, on a follower node we still wanto to show it,
> > +		// indicating it is not currently used.
> > +		if (tb[ETHTOOL_A_PLCA_NODE_ID] && idv != 0)
> > +			printf(" (ignored)");
> 
> The compiler warns that idv may be uninitialized here. While it's in
> wrong, AFAICS, not even gcc13 is smart enough to recognize that it's not
> actually possible so let's initialize the variable to make it happy.
> Also, both idv and val are used to store unsigned values so they should
> be unsigned int.
> 
> Other than these, the patch looks good to me. The next branch already
> has the UAPI updates needed for it so patch 1 won't be needed any more
> if you rebase on top of current next.
> 
> Michal
Thanks,
Piergiorgio
