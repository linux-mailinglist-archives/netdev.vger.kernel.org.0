Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2879ABFD2D
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 04:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfI0C0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 22:26:51 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36566 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfI0C0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 22:26:51 -0400
Received: by mail-io1-f67.google.com with SMTP id b136so12295942iof.3;
        Thu, 26 Sep 2019 19:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J+nWDXgsaBZmvMaavFN8h6cOxrOj2KF3ILHKLIPO34A=;
        b=JV+juN59ZPmDpNQQVwV9fNjDwZNgGQkJrE+FskTjP4/yLYblFCQ8crGR2KH9/UavpQ
         8UWVi99lmbiCXWTbvuQLcCzx+/7aSKDs+DxOMfmysiIWaDWaSyvjha97wFTrxHuel5iv
         XX0LjeHToZfIC22nz0lL7jtaAThdXPR+JbL9AuWcadDU/xPFSX0Lcp6max3OsW/O39zW
         LZGctE5D28CrQ09RAYeXHERwv/kMoxa3UrsO0B40XX/05jP4vkmtR0YsPxx4s+wBNDLx
         q9Kz+kRAwGu3jaAJNVOuCb2+RqchXh82/TTj4kLgRbVpCYlcc/31FpcTkfTR1WJxvLQs
         o16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J+nWDXgsaBZmvMaavFN8h6cOxrOj2KF3ILHKLIPO34A=;
        b=csl4YsNYZkaE94xt6dVQQ5VEwVcGtfF4PkMb/3FaR/XKLNsEuMk5c4mZ64viMQfjHE
         rmTfICpb5Znl4YlkGggnOdQG9T3bt85mGn1B3xMiMCsZ4ckh89jNum/PsDQec1FEFpH4
         bjMZK8ojU1GvoeQbVIeInfrShb70I2CKUfNlzsEg86sLIu9PJ8mO8NH/1j2BR2QtqEI7
         rxUfLnFKoU/G/TVv6eu6sAZ4RrFPT5yxmXl7U5Yyez1nz3c0ASujukEoVtlgMGVaOi7i
         VU6We8ZOCF/PxuNFtKUd+L99l3ivbIVfiIbmb5LAbAKImnQlkglHQbYMTMJuQQqrw/GJ
         NNZA==
X-Gm-Message-State: APjAAAXtPiNnE2IoIxIQr3g5X718EUblffJuDAgbtV3BLkCaakBdYkpJ
        XKenbqHcbOVZIAxB+4UYDEk=
X-Google-Smtp-Source: APXvYqyoAakGX8Luwy1IiwMejmdpn88lbSaWc7uYSTk6Gkq85Z5M4KT6sRybkLzNVx9+598g06YZWA==
X-Received: by 2002:a5e:8216:: with SMTP id l22mr6394174iom.252.1569551210117;
        Thu, 26 Sep 2019 19:26:50 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.gmail.com with ESMTPSA id o8sm657890ild.55.2019.09.26.19.26.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 26 Sep 2019 19:26:49 -0700 (PDT)
Date:   Thu, 26 Sep 2019 21:26:47 -0500
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        John Hurley <john.hurley@netronome.com>,
        Colin Ian King <colin.king@canonical.com>,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: flow_offload: fix memory leak in
 nfp_abm_u32_knode_replace
Message-ID: <20190927022647.GC22969@cs-dulles.cs.umn.edu>
References: <20190925182846.69a261e8@cakuba.netronome.com>
 <20190926022240.3789-1-navid.emamdoost@gmail.com>
 <20190925215314.10cf291d@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925215314.10cf291d@cakuba.netronome.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 09:53:14PM -0700, Jakub Kicinski wrote:
> On Wed, 25 Sep 2019 21:22:35 -0500, Navid Emamdoost wrote:
> > In nfp_abm_u32_knode_replace if the allocation for match fails it should
> > go to the error handling instead of returning.
> > 
> > Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> > ---
> > Changes in v2:
> > 	- Reused err variable for erorr value returning.
> 
> Thanks, there's another goto up top. And I think subject prefix could
> be "nfp: abm:", perhaps?
> 
Thanks, v3 was sent which fixes this.

Navid.
> >  drivers/net/ethernet/netronome/nfp/abm/cls.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
> > index 23ebddfb9532..b0cb9d201f7d 100644
> > --- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
> > +++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
> > @@ -198,14 +198,18 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
> >  		if ((iter->val & cmask) == (val & cmask) &&
> >  		    iter->band != knode->res->classid) {
> >  			NL_SET_ERR_MSG_MOD(extack, "conflict with already offloaded filter");
> > +			err = -EOPNOTSUPP;
> >  			goto err_delete;
> >  		}
> >  	}
> >  
> >  	if (!match) {
> >  		match = kzalloc(sizeof(*match), GFP_KERNEL);
> > -		if (!match)
> > -			return -ENOMEM;
> > +		if (!match) {
> > +			err = -ENOMEM;
> > +			goto err_delete;
> > +		}
> > +
> >  		list_add(&match->list, &alink->dscp_map);
> >  	}
> >  	match->handle = knode->handle;
> > @@ -221,7 +225,7 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
> >  
> >  err_delete:
> >  	nfp_abm_u32_knode_delete(alink, knode);
> > -	return -EOPNOTSUPP;
> > +	return err;
> >  }
> >  
> >  static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
> 
