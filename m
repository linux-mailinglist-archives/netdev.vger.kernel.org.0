Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8264A4EFF
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355490AbiAaSzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240050AbiAaSzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:55:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1761EC061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 10:55:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA6D2B82BD1
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 18:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365E4C340E8;
        Mon, 31 Jan 2022 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643655300;
        bh=Fv4HJLlX9GPe/d3zEKjhYV4A2ms6AT7a9ZjgqT70rEQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D1qMD2/pZleTtMzdTJeqi0VAkwtuAZOJblFBiEXB9t+Zrr0Q/y86tAGArLg14Oe//
         HiD59uAAYQ3z6fiyl3zZHco/kDbOJi3ip3QilnQmLx3USLlJsxtRZJHueGgIStTAh3
         +F1NOv3ezKsY0tfyTeuuVCmBQ/Xmr7AfdIYDVgOhZn/HTMf0OVMQm49HCDYrNzOa9v
         AOZmi45BP72T/JyPOjX3ocFwYBHFvziZCp/Md29EhpURp66OGkc6S04GjGDbSQ57vy
         ypPgegWH2SMHbjos+JwSsFxbJpkOXCSpmFB3Q233QPC8Lauhbkp74O/FsR6CtEn0g2
         HvnZ4YTzJi41g==
Date:   Mon, 31 Jan 2022 10:54:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: Re: [PATCH net-next 1/2] uapi: ioam: Insertion frequency
Message-ID: <20220131105458.4a7c182f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <31581393.9071156.1643455487833.JavaMail.zimbra@uliege.be>
References: <20220126184628.26013-1-justin.iurman@uliege.be>
        <20220126184628.26013-2-justin.iurman@uliege.be>
        <20220128173121.7bb0f8b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <31581393.9071156.1643455487833.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Jan 2022 12:24:47 +0100 (CET) Justin Iurman wrote:
> >> +	IOAM6_IPTUNNEL_FREQ_K,		/* s32 */
> >> +	IOAM6_IPTUNNEL_FREQ_N,		/* s32 */  
> > 
> > You can't insert into the middle of a uAPI enum. Binary compatibility.  
> 
> Is it really the middle? I recall adding the "mode" at the top (still
> below the "_UNSPEC"), which I thought was correct at that time (and had
> no objection).

Maybe because both changes were made in the same kernel release?
Not sure.

> That's why I did the same here. Should I move it to the end, then?

You have to move it. I don't see how this patch as is wouldn't change
the value of IOAM6_IPTUNNEL_MODE.
