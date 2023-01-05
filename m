Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDC865E940
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 11:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbjAEKr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 05:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbjAEKrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 05:47:17 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07E950054;
        Thu,  5 Jan 2023 02:47:16 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id jo4so89170002ejb.7;
        Thu, 05 Jan 2023 02:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1LL4PmBB1pvqQG5tOhMu+jjeyKAtVmuz5IqwO930qQU=;
        b=QBsTEvPO+m09NOsi5gTFe7aqT7oPRZbnlKzfg/LIrZtl+r3bBd1XM/AVhNXEMXBLIx
         JuA1o/Xe6J8KPFdXWKpjZ1eRfVqh6ld0S/BhRA8OqBG1NfGbj/Hr86Vrvfbh2UBF6YDJ
         U3oznAWuhyYmTr3SPTqUmhm2YwLJ5cEAtKExeLyuzaG2Rj/CSaF6paZMRR2rWxJu3Zko
         UYR96R+O4itXF4HVwhVLmEYB53ZF5QVvxtb2dtx/4JFYXLzBOQ7yJqFIuCEgRZr73prS
         vW9KAfzkGtqBHJ3MIxHxRdn+IwNbL26a82gRTA1LfnsXFYfa558VLoREhsQ1+Cfc9nFt
         8zSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1LL4PmBB1pvqQG5tOhMu+jjeyKAtVmuz5IqwO930qQU=;
        b=lAI0qraa4Ftx1TVn3bW+YAQJgZ4s5gLp7zJwXLaN8+4p7CjsVVOO1X84+4kMUCc6fo
         eNCnPedGlmNBuxYL05HyUIISVpNLal5L3qse7miOMrRB41oCW2iVFzgg+1sacfH3uxux
         Pzi4/2jifcDPTkuGAo6iVGpkSisNdnsRM4IJGdUe0rQYHSCU9/PVgZdQ+Z5OPDCjKwf9
         PqhST2pCZiASL/PYXsdHlpR7Aw7Obdi6UKChLR2sLyNXxrP/CHlNnXGZtbBQeBtGvvGo
         rSx5WcX30/kPNw8piIzrb+eAIeBMymSfZNG3uc42y812iMcAIa1rkIOhq6yFKx1pZKhc
         g51Q==
X-Gm-Message-State: AFqh2krjbWnd+ynhuTEzgMyajUCCKls4lcRybQMC07YfoGMfrqHQXMQZ
        4C8nPE2IO+kM/DNSPPKA7PEHMhSFL8Bpx8+0
X-Google-Smtp-Source: AMrXdXsQ1UzaCEtGI2BREzyrMKBffvNVBx05JVKcDdsthUI8/V4jqM9V6DUdrt1BUz00IqmXeingPw==
X-Received: by 2002:a17:907:6d0b:b0:83f:1f64:c1e with SMTP id sa11-20020a1709076d0b00b0083f1f640c1emr48651653ejc.47.1672915635162;
        Thu, 05 Jan 2023 02:47:15 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id u18-20020a1709061db200b007c073be0127sm16050618ejh.202.2023.01.05.02.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 02:47:14 -0800 (PST)
Date:   Thu, 5 Jan 2023 11:47:20 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 1/5] net/ethtool: add netlink interface for the
 PLCA RS
Message-ID: <Y7aquABWDDmPeRAV@gvm01>
References: <cover.1672840325.git.piergiorgio.beruto@gmail.com>
 <76d0a77273e4b4e7c1d22a897c4af9109a8edc51.1672840325.git.piergiorgio.beruto@gmail.com>
 <Y7aQcgR4C9Lg/+yK@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7aQcgR4C9Lg/+yK@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Leon for your review.
Please, see my comments below.

On Thu, Jan 05, 2023 at 10:55:14AM +0200, Leon Romanovsky wrote:
> On Wed, Jan 04, 2023 at 03:05:44PM +0100, Piergiorgio Beruto wrote:
> > Add support for configuring the PLCA Reconciliation Sublayer on
> > multi-drop PHYs that support IEEE802.3cg-2019 Clause 148 (e.g.,
> > 10BASE-T1S). This patch adds the appropriate netlink interface
> > to ethtool.
> > 
> > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > ---
> >  Documentation/networking/ethtool-netlink.rst | 138 ++++++++++
> >  MAINTAINERS                                  |   6 +
> >  include/linux/ethtool.h                      |  12 +
> >  include/linux/phy.h                          |  57 ++++
> >  include/uapi/linux/ethtool_netlink.h         |  25 ++
> >  net/ethtool/Makefile                         |   2 +-
> >  net/ethtool/netlink.c                        |  29 ++
> >  net/ethtool/netlink.h                        |   6 +
> >  net/ethtool/plca.c                           | 276 +++++++++++++++++++
> >  9 files changed, 550 insertions(+), 1 deletion(-)
> >  create mode 100644 net/ethtool/plca.c
> 
> <...>
> 
> > --- /dev/null
> > +++ b/net/ethtool/plca.c
> > @@ -0,0 +1,276 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +
> > +#include <linux/phy.h>
> > +#include <linux/ethtool_netlink.h>
> > +
> > +#include "netlink.h"
> > +#include "common.h"
> > +
> > +struct plca_req_info {
> > +	struct ethnl_req_info		base;
> > +};
> > +
> > +struct plca_reply_data {
> > +	struct ethnl_reply_data		base;
> > +	struct phy_plca_cfg		plca_cfg;
> > +	struct phy_plca_status		plca_st;
> > +};
> > +
> > +// Helpers ------------------------------------------------------------------ //
> > +
> > +#define PLCA_REPDATA(__reply_base) \
> > +	container_of(__reply_base, struct plca_reply_data, base)
> > +
> > +static inline void plca_update_sint(int *dst, const struct nlattr *attr,
> > +				    bool *mod)
> 
> No inline function in *.c files.
Fixed, thanks.
> 
> > +{
> > +	if (attr) {
> > +		*dst = nla_get_u32(attr);
> > +		*mod = true;
> > +	}
> 
> Success oriented approach, please
> if (!attr)
>   return;
Fixed.
> 
> > +}
> > +
> > +// PLCA get configuration message ------------------------------------------- //
> > +
> > +const struct nla_policy ethnl_plca_get_cfg_policy[] = {
> > +	[ETHTOOL_A_PLCA_HEADER]		=
> > +		NLA_POLICY_NESTED(ethnl_header_policy),
> > +};
> > +
> > +static int plca_get_cfg_prepare_data(const struct ethnl_req_info *req_base,
> > +				     struct ethnl_reply_data *reply_base,
> > +				     struct genl_info *info)
> > +{
> > +	struct plca_reply_data *data = PLCA_REPDATA(reply_base);
> > +	struct net_device *dev = reply_base->dev;
> > +	const struct ethtool_phy_ops *ops;
> > +	int ret;
> > +
> > +	// check that the PHY device is available and connected
> > +	if (!dev->phydev) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	// note: rtnl_lock is held already by ethnl_default_doit
> > +	ops = ethtool_phy_ops;
> > +	if (!ops || !ops->get_plca_cfg) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	ret = ethnl_ops_begin(dev);
> > +	if (ret < 0)
> > +		goto out;
> 
> I see that many places in the code used this ret > 0 check, but it looks
> like the right check is if (ret).
Thanks. I've fixed those, although I copied this code from similar files
(like cable test). Maybe we should check these out as well?
> 
> Thanks

Thanks!
Piergiorgio
