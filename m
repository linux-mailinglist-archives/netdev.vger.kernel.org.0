Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05D9495344
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 18:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiATRaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 12:30:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58166 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiATRaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 12:30:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA61AB81E01
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 17:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E59FC340E0;
        Thu, 20 Jan 2022 17:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642699852;
        bh=vNtcYmMDAf3NyX5HLs8XIs2jLBbhymJLy8MCiFCuvY8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vP4nOOiqsZfXwFg+le7gWzOsobETImOvWZCBBsrfUrUA+QnJf6WIRU3O+XomOHXfm
         bbA+hqEhr8fnTE4vJLqubgBwxp/7GXSDe9Hw1aI1HrQD+hNJYc9BVIpcZmkpswmJjs
         m2KBWnTKYdHoy02OiBQYymsBCjn74Mmj5EJkzeq2ygyRaTVFNepAG+qwFc7sK6rFq/
         1Q57nRPq6iyehRiMQbqsASzAEPYBfUy2TTfOapfLtTiLaxINSyKQWlARcH4veleZup
         bmoN/JvWojkONG8wwNnWbGUE7UvxKJtY7Ok78g+ObXvpuvjB9LxdY1zeGwQIV7frkv
         QA0BBu7CplIwA==
Date:   Thu, 20 Jan 2022 09:30:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, michel@fb.com,
        dcavalca@fb.com, Andrew Lunn <andrew@lunn.ch>
Subject: Re: ethtool 5.16 release / ethtool -m bug fix
Message-ID: <20220120093051.70845141@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <YekVLcKZxa7ojNYc@shredder>
References: <20220118145159.631fd6ed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <YefdxW/V/rjiiw2x@shredder>
        <20220119073902.507f568c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <YekVLcKZxa7ojNYc@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jan 2022 09:54:21 +0200 Ido Schimmel wrote:
> > What about drivers which do implement get_module_eeprom_by_page? Can we
> > somehow ensure they DTRT and are consistent with the legacy / flat API?  
> 
> Not sure what you mean by that (I believe they are already doing the
> right thing). Life is much easier for drivers that implement
> get_module_eeprom_by_page() because they only need to fetch the
> information user space is asking for. They need not perform any parsing
> of the data, unlike in the legacy callbacks.

I see, my concern was that overzealous driver or FW may try to validate
the page number rather than just performing the read.
