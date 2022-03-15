Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71E94D90CD
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236386AbiCOAGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235153AbiCOAGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:06:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879DD1B79C
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:04:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 337F3B81055
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 00:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD88AC340F4;
        Tue, 15 Mar 2022 00:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647302697;
        bh=5RABnsH6pmmvvgLtf3BPaRRDdyXIuSh+2Fwb6xJ7FKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fLxB9rOCt5CsefjhESrsS4b0+7sqwPcHfV+9ArAWR2LnAeDtH2BgCcxpF7QkOz5Il
         A3V04TOSRqfNhjDracvZy/5bOZ7sQKEBgvx9CktascXXQfT1TqMNFafJTzCUWrwjqB
         qVelZkig3jffJIs99hs3dGQ9xZP1yYFrmB0WnGC0bHxGtE5lZt4IOD7RQcp8qEGexW
         7bUek4/vQkg6j7n82ZyTYA2m21FmAZDo8WN5vkej6xAFwZ6JieNvbCyaY+IlN0fKxB
         AgLjtJQ/zhkpUz06R8AagQLctlwlfhxRKHgu3KCJ/cIgNcrkwrcPyerJeEAzhjPOW9
         5w5rb+uBEGM4A==
Date:   Mon, 14 Mar 2022 17:04:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jan =?UTF-8?B?QsSbdMOtaw==?= <hagrid@svine.us>
Subject: Re: [PATCH net] net: dsa: fix panic when port leaves a bridge
Message-ID: <20220314170455.3cebf839@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220314164236.5s4g2w453fxuulzw@skbuf>
References: <20220314153410.31744-1-kabel@kernel.org>
        <87tuc0lelc.fsf@waldekranz.com>
        <20220314170529.2b71978d@dellmb>
        <20220314161706.mo3ph3aadzdqwdag@skbuf>
        <20220314173433.793d25e8@dellmb>
        <20220314164236.5s4g2w453fxuulzw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 16:42:37 +0000 Vladimir Oltean wrote:
> > I can, but I thought it should only be done after it gets merged to
> > Linus' master.  
> 
> Ah, now I re-read Tobias' discussion with Jakub from the cover letter.
> I've never seen that procedure in action, to be honest, let's see how it goes.

I guess we could have applied it to both trees and dealt with 
the merge :S No point doing it now, tho, merge window is afoot.
