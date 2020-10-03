Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743612824EF
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 17:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgJCPEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 11:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgJCPEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 11:04:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDEA8206B8;
        Sat,  3 Oct 2020 15:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601737478;
        bh=mYMOEMj8bE6Mnms4S5xjwsT+ei8YeSpI0eJUCZu5mCA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=snHH6g4Y5n3I4rE75V2ohwiXIqOQTnPiXt+WHVQZ+Y1sCaKIWkRyyNqSdindkyNsn
         cwwRuT6IyeLUrKvexUVnUIPQSywWxB+Ev7PraRxIMTxpc7XRQ32SKb6mYzbDBbya6Q
         A3TiKIL5+UjiNCRD5F7lOAh1uhUGU+H3Qs5Bge4k=
Date:   Sat, 3 Oct 2020 08:04:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 03/16] devlink: Add devlink reload limit option
Message-ID: <20201003080436.40cd8eb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201003075100.GC3159@nanopsycho.orion>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
        <1601560759-11030-4-git-send-email-moshe@mellanox.com>
        <20201003075100.GC3159@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 3 Oct 2020 09:51:00 +0200 Jiri Pirko wrote:
> > enum devlink_attr {
> > 	/* don't change the order or add anything between, this is ABI! */
> > 	DEVLINK_ATTR_UNSPEC,
> >@@ -507,6 +524,7 @@ enum devlink_attr {
> > 
> > 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
> > 	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* u64 */
> >+	DEVLINK_ATTR_RELOAD_LIMIT,	/* u8 */  
> 
> Hmm, why there could be specified only single "limit"? I believe this
> should be a bitfield. Same for the internal api to the driver.

Hm I was expecting limits to be ordered (in maths sense) but you're
right perhaps that can't be always guaranteed.

Also - Moshe please double check that there will not be any kdoc
warnings here - I just learned that W=1 builds don't check headers 
but I'll fix up my bot by the time you post v2.
