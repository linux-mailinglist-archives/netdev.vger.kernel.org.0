Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896BA4A9100
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 00:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355929AbiBCXK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 18:10:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41792 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbiBCXK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 18:10:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2859B835E8;
        Thu,  3 Feb 2022 23:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2279DC340E8;
        Thu,  3 Feb 2022 23:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643929823;
        bh=9nlI9+KCIgp6rqiYYJPe3fzW1xxTvg1lpzDst24Ejr0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=etXgFFNnWHK+YXX0jgh/G1dt7rJ5d/E/XSCeAILkSM18nCQkuc26QdQBIC42/lZNO
         90S6cgV1VugLyPvDy4qWuj8ghnCH/mQa4w1JXsUdidsrj1kLWrH98XoIsbuPSbQPwF
         lfpuz9etAaS5EqT4OA/5+bIUMC1yRhgQOE49B+187ZeC3bepBHYQFB6y4s8+MDFmG5
         hn5Ryg6V6x04IELZ+GxUwyyvYkOnVvAEcGMNVB60YF9OuXQGmdDOFsKU153dx7YBuC
         Eyi0bUuxkraIvNiG9CriEK8gztU4il5I+xRF4iAJFYsYV6LetYUs5sN8C33uxnRU6/
         8bTIm4HQBosHQ==
Date:   Thu, 3 Feb 2022 15:10:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, oliver@neukum.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, stefan@datenfreihafen.org,
        jk@codeconstruct.com.au, matt@codeconstruct.com.au,
        linux-usb@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next] net: don't include ndisc.h from ipv6.h
Message-ID: <20220203151021.6a276271@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <df19b376-49a3-1ef2-0664-a23a48e128dc@gmail.com>
References: <20220203043457.2222388-1-kuba@kernel.org>
        <df19b376-49a3-1ef2-0664-a23a48e128dc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 15:48:28 -0700 David Ahern wrote:
> > --- a/include/net/ndisc.h
> > +++ b/include/net/ndisc.h
> > @@ -71,7 +71,6 @@ do {								\
> >  
> >  struct ctl_table;
> >  struct inet6_dev;
> > -struct net_device;  
> 
> ndisc_parse_options references net_device. This part seems unrelated to
> the patch intent.

Indeed, I'll post v2 with this fixed. The reason was this header
includes linux/netdevice.h so the forward declaration is unnecessary.
