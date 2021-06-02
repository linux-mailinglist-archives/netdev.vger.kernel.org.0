Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505ED3994E6
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhFBUzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 16:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhFBUyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 16:54:45 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80840C06174A
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 13:53:01 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id n12so3263094pgs.13
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 13:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wvBVKKuCkHy2pwXOhSmYF/8asqpcAnySspHtL7Uf0EY=;
        b=GDb7DdnITH1/95qRk77G6hq5OLr2t1g+co9KRVhEi+aWul1jaq6z2UDQvaMBNXNCkd
         XU1hsCa6WHRjDmMikEUzUuYq/c5MBH2aD7ZaQ8j3rC3CyvpdEuVEVGT2JGwp+R1oNaau
         Zx+hSd72dIvWSuFCrKKhXruFxv7IB2leWk3FA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wvBVKKuCkHy2pwXOhSmYF/8asqpcAnySspHtL7Uf0EY=;
        b=QiHRKGyJDmgMN9d7xT1EJRJGseXJyVJMUjxRBvqoO45IMrwedmTHcJueRgUnjIaW/T
         cU+3YUd7SvvUo+rCIiHvji3/YI5ChVh0leTAo6jmxZOdHjp2fms3M8IoQ2mRYQs78dCy
         QbO14+Cfxr6v/2b9yfgLxfVWLdt6A3jV5f97fHJhzwA93pKidDj6ZFrOtAyotUJfs12k
         zmDxsOePtnUt7tNRGLsQlbpa382UqReAEA3AIFh/6DjBe78LlwxE330LNb8XMPu8dmSV
         q4rUiVJbtYhst+vSC5iMtJZZd2gBxQrYuOUmcRId2EGqTXKLCDL+kScnJ1AWHfhKbzaa
         aj8w==
X-Gm-Message-State: AOAM531XKNITJmCvisZwauzqkPet7Ij45dbltCnJLTnRJcv3sjE5NEeI
        y7l1fdJlzXwCZ+ISJTD0+nOQxA==
X-Google-Smtp-Source: ABdhPJzQA2Kuv7FOGj+yBnevenaxOfCwvvS+TKqCt5Se8cg0JQNeLpwmhDa3WvqEYQgAIc8sX114Bw==
X-Received: by 2002:a05:6a00:84f:b029:2be:3b80:e9eb with SMTP id q15-20020a056a00084fb02902be3b80e9ebmr28959717pfk.39.1622667181114;
        Wed, 02 Jun 2021 13:53:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f28sm545147pgb.12.2021.06.02.13.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 13:53:00 -0700 (PDT)
Date:   Wed, 2 Jun 2021 13:52:59 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     kernel test robot <lkp@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] net: bonding: Use strscpy() instead of
 manually-truncated strncpy()
Message-ID: <202106021352.484D660@keescook>
References: <20210602203138.4082470-1-keescook@chromium.org>
 <7214.1622666840@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7214.1622666840@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 01:47:20PM -0700, Jay Vosburgh wrote:
> Kees Cook <keescook@chromium.org> wrote:
> 
> >Silence this warning by just using strscpy_pad() directly:
> >
> >>> drivers/net/bonding/bond_main.c:4877:3: warning: 'strncpy' specified bound 16 equals destination size [-Wstringop-truncation]
> >    4877 |   strncpy(params->primary, primary, IFNAMSIZ);
> >         |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> >Additionally replace other strncpy() uses, as it is considered deprecated:
> >https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings
> >
> >Reported-by: kernel test robot <lkp@intel.com>
> >Link: https://lore.kernel.org/lkml/202102150705.fdR6obB0-lkp@intel.com
> >Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> 	There's one more "strncpy(...); primary[IFNAMSIZ - 1] = 0;" set
> in bond_options.c:bond_option_primary_set(), doesn't it also generate
> this warning?

Gah, I was looking only in the same file not the whole directory. :)

v3 on the way!

> 
> 	Either way, the change looks good to me.

Thanks!

> 
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> 
> 	-J
> 
> 
> >---
> >v2:
> > - switch to strscpy_pad() and replace earlier strncpy() too
> >v1: https://lore.kernel.org/lkml/20210602181133.3326856-1-keescook@chromium.org
> >---
> > drivers/net/bonding/bond_main.c | 8 +++-----
> > 1 file changed, 3 insertions(+), 5 deletions(-)
> >
> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >index c5a646d06102..e9cb716ad849 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -620,7 +620,7 @@ static int bond_check_dev_link(struct bonding *bond,
> > 		 */
> > 
> > 		/* Yes, the mii is overlaid on the ifreq.ifr_ifru */
> >-		strncpy(ifr.ifr_name, slave_dev->name, IFNAMSIZ);
> >+		strscpy_pad(ifr.ifr_name, slave_dev->name, IFNAMSIZ);
> > 		mii = if_mii(&ifr);
> > 		if (ioctl(slave_dev, &ifr, SIOCGMIIPHY) == 0) {
> > 			mii->reg_num = MII_BMSR;
> >@@ -5329,10 +5329,8 @@ static int bond_check_params(struct bond_params *params)
> > 			(struct reciprocal_value) { 0 };
> > 	}
> > 
> >-	if (primary) {
> >-		strncpy(params->primary, primary, IFNAMSIZ);
> >-		params->primary[IFNAMSIZ - 1] = 0;
> >-	}
> >+	if (primary)
> >+		strscpy_pad(params->primary, primary, sizeof(params->primary));
> > 
> > 	memcpy(params->arp_targets, arp_target, sizeof(arp_target));
> > 
> >-- 
> >2.25.1
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com

-- 
Kees Cook
