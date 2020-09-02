Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C0F25A222
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 02:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgIBABg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 20:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbgIBAB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 20:01:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40C85206EF;
        Wed,  2 Sep 2020 00:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599004889;
        bh=2byf7P5pdje8ox7sGxqSU/UpVlQAQT9pJnkpvN+6Miw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gBbMphiMHjQ1mgPGTdTf++sI6IMZWjkh9BUMZ0LMqzCy/XJ2gzRr5eLrvXhZwXrY4
         DYlDks9wDXv4p498PjU+aa4Mc5IZHNh6uhESPtvPlPvkf8RcyiaVtQ/xytjwqFEMoe
         Bx0r1DRTgwoDsPCDgSbeC4MZDTY3YtdmwINoHebw=
Date:   Tue, 1 Sep 2020 17:01:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next RFC v3 02/14] devlink: Add reload actions
 counters
Message-ID: <20200901170127.7bf0d045@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1fa33c3c-57b8-fe38-52d6-f50a586a8d3f@nvidia.com>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
        <1598801254-27764-3-git-send-email-moshe@mellanox.com>
        <20200831104827.GB3794@nanopsycho.orion>
        <1fa33c3c-57b8-fe38-52d6-f50a586a8d3f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Sep 2020 22:05:36 +0300 Moshe Shemesh wrote:
> >> +void devlink_reload_actions_cnts_update(struct devlink *devlink, unsigned long actions_done)
> >> +{
> >> +	int action;
> >> +
> >> +	for (action = 0; action < DEVLINK_RELOAD_ACTION_MAX; action++) {
> >> +		if (!test_bit(action, &actions_done))
> >> +			continue;
> >> +		devlink->reload_actions_cnts[action]++;
> >> +	}
> >> +}
> >> +EXPORT_SYMBOL_GPL(devlink_reload_actions_cnts_update);  
> > I don't follow why this is an exported symbol if you only use it from
> > this .c. Looks like a leftover...
> >  
> Not leftover, in the commit message I notified and explained why I 
> exposed it.

We should generate devlink notifications on this event (down and up)
so the counters don't have to be exposed to drivers. We need a more
thorough API.
