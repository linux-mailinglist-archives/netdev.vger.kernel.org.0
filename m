Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9158268D1F5
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 10:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjBGJDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 04:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjBGJDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 04:03:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B74367E5
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 01:03:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D321C6122C
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 09:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B477CC433EF;
        Tue,  7 Feb 2023 09:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675760583;
        bh=XuwzWbuiv9PRXatJlaU27ApwiZpspE+xfbUMrMdXr80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ifr2F1s53Be1i3fzNmU6/bW9QYAAdeGiOmVZijr3sG7Ir7aciUOrou7tJkmbAiuY3
         SgS3d7giy19onhBPQNUAKmYnmVcnFn0B+F//XYtLK1znyvGAzAlM8pBWUyvEUZO8p9
         3M/rF5fNruo86Sh6GqwuyfLg/GWK/AfJ6w9jN3PyzeZDuZCEjXFIS9p8c3KBbCji1F
         zq21e3lSQ5WDxMRtX3GH+IoBa32fhhvJEnp2lVjyLvV1mgOO9WKlbFdWNee1lQYWXB
         bBstrC28YASynsKtxXqd2Yx3T+fCfgPQH8gHejiPiGYe0B1ElTm5VrhTQkBt0WvibF
         xx7/7xAOGN+ag==
Date:   Tue, 7 Feb 2023 11:02:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     b.a.t.m.a.n@lists.open-mesh.org, Jiri Pirko <jiri@resnulli.us>,
        Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] batman-adv: Start new development cycle
Message-ID: <Y+ITwsu5Lg5DxgRt@unreal>
References: <20230127102133.700173-1-sw@simonwunderlich.de>
 <Y9wEdn1MJBOjgE5h@sellars>
 <Y9zF/kEDF7hAAlsB@nanopsycho>
 <8520325.EvYhyI6sBW@ripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8520325.EvYhyI6sBW@ripper>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 10:38:07AM +0100, Sven Eckelmann wrote:
> On Friday, 3 February 2023 09:29:50 CET Jiri Pirko wrote:
> [...]
> > Why kernel version is not enough for you? My point is, why to maintain
> > internal driver version alongside with the kernel version?
> [...]
> > >Also note that we can't do a simple kernel version to year
> > >notation mapping in userspace in batctl. OpenWrt uses the most
> > >recent Linux LTS release. But might feature a backport of a more
> > >recent batman-adv which is newer than the one this stable kernel
> > >would provide. Or people also often use Debian stable but compile
> > >and use the latest batman-adv version with it.
> > 
> > Yeah, for out of tree driver, have whatever.
> 
> A while back, my personal opinion changed after there were various Linux 
> developers/maintainers were trying to either remove it or wondering about this 
> bump. The idea which I've proposed was to:
> 
> * still ship the "backports" like out-of-tree tarball with a module version - 
>   but directly in its "compat" code
> * continue to use in projects (which for whatever reason cannot use the in-
>   kernel implementation) a version which represents their upstream backports 
>   tarball + their (patch) revision: Something like "2022.0-openwrt-7"
> * for the in-kernel module, just return either 
> 
>   - remove the version information completely from the kernel module 
>     MODULE_VERSION + drop BATADV_ATTR_VERSION + modifying batctl to fetch that 
>     from uname(). But of course, that would break old batctl versions [1]
>   - or by setting BATADV_SOURCE_VERSION to UTS_RELEASE (+suffix?) or 
>     UTS_VERSION
> 
> 
> But this wasn't well received when mentioning it to Simon+Linus (but I could 
> misremember the persons involved here).

In cases where you can prove real userspace breakage, we simply stop to
update module versions.

Thanks

> 
> Kind regards,
> 	Sven
> 
> [1] https://lore.kernel.org/r/20201205085604.1e3fcaee@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com


