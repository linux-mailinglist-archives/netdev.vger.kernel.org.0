Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FDE492FE8
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349011AbiARVKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:10:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39012 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245724AbiARVKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:10:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB1F961329
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 21:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0791FC340E1;
        Tue, 18 Jan 2022 21:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642540208;
        bh=30/u5QIriczMv+Bo30FkZz1LXNS6Qh1fpW1Li7V6gKM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uc7Igl8gRzMsdMcLVUEtamLqnGL/3e8Z8kNqG2HoXkopg6dpSdiBe6CfojXqFZo3C
         oSduQapRI99JuJbpTeBwwMPdPerIEBsqpas5WOzyIp67tAh2vrAwHhdV+Bst4Thcj4
         5tSKTCSdruaUTutLstOocDjV036LHrW0f92rE+h2cQ3cpeaNTuekN/IEXypKGya9/n
         qKDcBdNTz7zmj+qvgIRB5+KVU+H2QJUIKlNPsTab9jRVSgt7oGuyFVcsBdqAQELKCl
         RNcMib6MvSyI5fcljYdxVD77FafAh/O79mLc7yybukjJlOFFEhm9CwQGNT/ckwQvkd
         RyRJodfwpAt1A==
Date:   Tue, 18 Jan 2022 13:10:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     ooppublic@163.com
Cc:     davem@davemloft.net, dsahern@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: fix fragments have the disallowed options
Message-ID: <20220118131006.083f8b23@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220112104324.61b15b51@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220107080559.122713-1-ooppublic@163.com>
        <20220112104324.61b15b51@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 10:43:24 -0800 Jakub Kicinski wrote:
> On Fri,  7 Jan 2022 16:05:59 +0800 ooppublic@163.com wrote:
> > From: caixf <ooppublic@163.com>
> > 
> > When in function ip_do_fragment() enter fsat path,  
> 
> fsat -> fast
> 
> > if skb have opthons, all fragments will have the same options.  
> 
> opthons -> options
> 
> > Just guarantee the second fragment not have the disallowed options.  
> 
> You're right. Can you send a patch which explicitly reverts these
> two commits instead:
> 
>  1b9fbe813016b08e08b22ddba4ddbf9cb1b04b00
>  faf482ca196a5b16007190529b3b2dd32ab3f761
> 
> I prefer the code the way it was before them, plus keeping the code how
> it was could help backports.

Please let us know if you're planning to send the new patch otherwise
I'll do the revert myself, it's a clear bug.
