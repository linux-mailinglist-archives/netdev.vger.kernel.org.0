Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D371F4E3C
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 08:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgFJGbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 02:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgFJGbG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 02:31:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77AC320760;
        Wed, 10 Jun 2020 06:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591770666;
        bh=HWqfOjSKZShVNILAl4Rwx3P52sNZxPeoQVKJIj6dIEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E8Cvgegk66cCXmlxVRnTbOP7DpmPu5rN+pO2KqHRyhnv/CabF0fwKFwbWzu+l0hYQ
         IM90rm9VemBskzD0IvXHXOA9jewhU/xl7ji+nePWuDVYBIvD//3KQwBdgJHupS60Cb
         Mp4tTOCmUlP2s0Dvu08GFR/RNf9CfM/iCqVNvE2o=
Date:   Wed, 10 Jun 2020 08:31:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jim Cromie <jim.cromie@gmail.com>
Subject: Re: [PATCH v3 1/7] Documentation: dynamic-debug: Add description of
 level bitmask
Message-ID: <20200610063103.GD1907120@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-2-stanimir.varbanov@linaro.org>
 <20200609111615.GD780233@kroah.com>
 <ba32bfa93ac2e147c2e0d3a4724815a7bbf41c59.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba32bfa93ac2e147c2e0d3a4724815a7bbf41c59.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 09:58:07AM -0700, Joe Perches wrote:
> On Tue, 2020-06-09 at 13:16 +0200, Greg Kroah-Hartman wrote:
> > What is wrong with the existing control of dynamic
> > debug messages that you want to add another type of arbitrary grouping
> > to it? 
> 
> There is no existing grouping mechanism.

info/warn/err/dbg is what I am referring to.

> Many drivers and some subsystems used an internal one
> before dynamic debug.
> 
> $ git grep "MODULE_PARM.*\bdebug\b"|wc -l
> 501

Yes, and it's horrid and needs to be cleaned up, not added to.

In the beginning, yes, adding loads of different types of debugging
options to a driver is needed by the author, but by the time it is added
to the kernel, all of that should be able to be removed and only a
single "enable debug" should be all that is needed.

We do not need each individual driver thinking it needs to have some
sort of special classification of each type of debug message.  Just use
the framework that we have, you can enable/disable them on a
line-by-line basis as needed.

> This is an attempt to unify those homebrew mechanisms.

All of those should just be removed.

> Stanimir attempted to add one for his driver via a
> driver specific standardized format substring for level.
> 
> > And who defines that grouping?
> 
> Individual driver authors

That way lies madness, let's try to fix all of that up.

greg k-h
