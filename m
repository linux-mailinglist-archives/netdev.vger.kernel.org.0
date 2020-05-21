Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF811DC376
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgEUAQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:16:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgEUAQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 20:16:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73BA82075F;
        Thu, 21 May 2020 00:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590020217;
        bh=vpUl3gwqBy+NPooBY4DI9i39/98qG+inSt4+hzHVzC0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2CMJHb0gvOo23X2ynuQdsui4/skdQscOOiV7UPVyF6RaMaxfKO8ROBZhFnS3RsGfb
         7NNY8HZw9f0RWX8CGsqbls97lYdMSAtFD0MCTRfMVt+uMpVCph/559ge2Le5Fo58uu
         GCGto5yX7M16Yys+ADkOs4CaozBqtFrcjFXvho4M=
Date:   Wed, 20 May 2020 17:16:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: devlink interface for asynchronous event/messages from
 firmware?
Message-ID: <20200520171655.08412ba5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fea3e7bc-db75-ce15-1330-d80483267ee2@intel.com>
References: <fea3e7bc-db75-ce15-1330-d80483267ee2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 17:03:02 -0700 Jacob Keller wrote:
> Hi Jiri, Jakub,
> 
> I've been asked to investigate using devlink as a mechanism for
> reporting asynchronous events/messages from firmware including
> diagnostic messages, etc.
> 
> Essentially, the ice firmware can report various status or diagnostic
> messages which are useful for debugging internal behavior. We want to be
> able to get these messages (and relevant data associated with them) in a
> format beyond just "dump it to the dmesg buffer and recover it later".
> 
> It seems like this would be an appropriate use of devlink. I thought
> maybe this would work with devlink health:
> 
> i.e. we create a devlink health reporter, and then when firmware sends a
> message, we use devlink_health_report.
> 
> But when I dug into this, it doesn't seem like a natural fit. The health
> reporters expect to see an "error" state, and don't seem to really fit
> the notion of "log a message from firmware" notion.
> 
> One of the issues is that the health reporter only keeps one dump, when
> what we really want is a way to have a monitoring application get the
> dump and then store its contents.
> 
> Thoughts on what might make sense for this? It feels like a stretch of
> the health interface...
> 
> I mean basically what I am thinking of having is using the devlink_fmsg
> interface to just send a netlink message that then gets sent over the
> devlink monitor socket and gets dumped immediately.

Why does user space need a raw firmware interface in the first place?

Examples?
