Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968B746E169
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 05:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhLIEJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 23:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhLIEJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 23:09:51 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CB4C061746;
        Wed,  8 Dec 2021 20:06:18 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id t18so7463906wrg.11;
        Wed, 08 Dec 2021 20:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vB7vf04khtLpot9rZbmXXqywxXnX7jptLuFGr0t8mBs=;
        b=GdqKeA9sECyA6rYV+IyJ201R7AoUgLExWyx24/UKgXAnJna9qHcpRh+NZu9AKQWPKF
         d/jo0wxOxcgf561XJLQPRcMh1spxIVL20QCR3/VUrPohapqfB0b9D5lPHye3WGzoqejd
         P4FjCddQ84Vm0+49Esiy0W7sVPXckGgFt9tIGVuKiAnBXjFbiHEVQON6Ck7dFUmBH8LR
         yuYMQldFSxhUxgWD5MvdCBYfkIArFNaf0GknUHavaNOKo8cZZHhcEDDCZqeVxT6EIrNZ
         vJnEF7Ej9LdmHdLCu0u+pAmR6t3LNF643+yvRQNGBwvJA8HQDsWChCAia8ErGFt92sRa
         6f7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vB7vf04khtLpot9rZbmXXqywxXnX7jptLuFGr0t8mBs=;
        b=jFS7/vyO3JOnQg4x7r23ky3eH7XHDSOafQoPy/raX9LaZEQGHfiZI6tp6CsTq6QBBC
         CgjikhGzgOtVP99w01Es97AOHfM0HqMkbvjgI5gxdqX5Nxjg4Fkhq4V+aBOUJ6MEAXHz
         a1eGud6cTUa0jkFVZHLsSD2qjSxMivw5oCXVdyO/lUfUqpb1Ho/KuZgb2jQRTbtBOwcw
         uoM1XMSMJnvTfxtYNAnc5bnX5v/wr0ZZnu5yxnx/Ir+g9soHtfZmHcRrqFld2uUKx19Q
         qc3A8d0svreyXHUvPZDFohcFIzKZ9kEyP6Gfz0bExovRAgdfuAOmIVCjF62pggpLCUpb
         5nXg==
X-Gm-Message-State: AOAM532SU01uS6uo7Z7mW/SPAF/p/CodRh8eD011/eQ1GvHUfC/2qUww
        Hy5sQM7WEwESPKoNwkC0DSU=
X-Google-Smtp-Source: ABdhPJweD8dPzgaoC31LkS1f7mc8cR9iottf4zcRruQMcplEhyYdCKvnNiRL2kC3KjZjx0OpJD/kRA==
X-Received: by 2002:a5d:6ac7:: with SMTP id u7mr3456465wrw.57.1639022777278;
        Wed, 08 Dec 2021 20:06:17 -0800 (PST)
Received: from hamza-OptiPlex-7040 ([39.48.134.175])
        by smtp.gmail.com with ESMTPSA id w15sm4389717wrk.77.2021.12.08.20.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 20:06:16 -0800 (PST)
Date:   Thu, 9 Dec 2021 09:06:12 +0500
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kabel@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: dsa: mv88e6xxx: error handling for serdes_power
 functions
Message-ID: <20211209040612.GA8939@hamza-OptiPlex-7040>
References: <20211208164042.6fbcddb1@thinkpad>
 <20211208155809.103089-1-amhamza.mgc@gmail.com>
 <20211208172820.1f273b3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208172820.1f273b3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 05:28:20PM -0800, Jakub Kicinski wrote:
> On Wed,  8 Dec 2021 20:58:09 +0500 Ameer Hamza wrote:
> > @@ -1507,7 +1510,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
> >  			    bool on)
> >  {
> >  	u8 cmode = chip->ports[port].cmode;
> > -	int err = 0;
> > +	int err;
> >  
> >  	if (port != 0 && port != 9 && port != 10)
> >  		return -EOPNOTSUPP;
> 
> This is on top of v1? It doesn't seem to apply, v1 was not merged.
Oh, sorry! Its not incremental but I think my repository was a
few commits old. Let me send the updated patch.

> Also can you please add Fixes tags?
Sure.
