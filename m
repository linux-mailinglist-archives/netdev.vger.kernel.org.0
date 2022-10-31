Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B11614058
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 23:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJaWDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 18:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJaWDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 18:03:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3B912625;
        Mon, 31 Oct 2022 15:03:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDDFAB818CE;
        Mon, 31 Oct 2022 22:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6F0C433D6;
        Mon, 31 Oct 2022 22:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667253821;
        bh=2KrZvtoNAsvlrd6mkck8oLOBW7LkNWzEtbJB0OtVx0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pr0rLvp6Ddz7hufAntFY7GdWEptpMWSaBr2Pdx/XF6qwEwrNDueWnlLgbZI6S4D1p
         q+aHp8T0wSwQdZzy7NIP4ZEb34q4lbg58e9D4iVtZQd4853dIlmsZ5djqUrKCTXVpC
         d6Q8dD6o2K1dhls5uB1LhGb42cfsUa2Ly0EeLrZQsQ8J/+pXIT/rMzz9jk8t75kRXd
         JYBZQzGLx2pCXGbATtW6SZ0gXtUxmhxjrZpNWmeMSOXaaPaZPCtW+v9M4Eg5ZsMtzG
         TG86tSh3LXFlNBOOn1NtS7dYB9C/oS50iHyKIFsz+h8OXPa94SRUClfD5HEScZq8d6
         VKU5XHOgBK3Iw==
Date:   Mon, 31 Oct 2022 16:03:25 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 1/6] cfg80211: Avoid clashing function prototypes
Message-ID: <Y2A4HS36KtXYKvE7@work>
References: <cover.1666894751.git.gustavoars@kernel.org>
 <c8239f5813dec6e5cfb554ca92b1783a18ac5537.1666894751.git.gustavoars@kernel.org>
 <a92ffa8db8228b5cb41939dc37d6ee677aef0619.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a92ffa8db8228b5cb41939dc37d6ee677aef0619.camel@sipsolutions.net>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 10:22:47AM +0200, Johannes Berg wrote:
> Hm.
> 
> If you're splitting out per driver,
> 
> > +++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> > @@ -9870,7 +9870,7 @@ static int ipw_wx_sw_reset(struct net_device *dev,
> >  
> >  /* Rebase the WE IOCTLs to zero for the handler array */
> >  static iw_handler ipw_wx_handlers[] = {
> > -	IW_HANDLER(SIOCGIWNAME, (iw_handler)cfg80211_wext_giwname),
> > +	IW_HANDLER(SIOCGIWNAME, cfg80211_wext_giwname),
> 
> I can see how this (and similar) still belongs into this patch since
> it's related to the cfg80211 change, but
> 
> > +++ b/drivers/net/wireless/intersil/orinoco/wext.c
> > @@ -154,9 +154,10 @@ static struct iw_statistics *orinoco_get_wireless_stats(struct net_device *dev)
> >  
> >  static int orinoco_ioctl_setwap(struct net_device *dev,
> >  				struct iw_request_info *info,
> > -				struct sockaddr *ap_addr,
> > +				union iwreq_data *wrqu,
> >  				char *extra)
> >  {
> > +	struct sockaddr *ap_addr = &wrqu->ap_addr;
> 
> why this (and similar) too?

mmh... yeah; orinoco should be a separate patch. :)

Thanks
--
Gustavo
