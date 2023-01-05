Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6802A65F3A4
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbjAESYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbjAESYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:24:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA14059FB7
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 10:24:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D039B81BA8
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 18:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D259FC433D2;
        Thu,  5 Jan 2023 18:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672943079;
        bh=UOmZihg6V20tTnX1/KVFnJY9YOI6gLnEK8K7jr1n1ik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MKxJR9pOitjhd+eVcGQiW//T0g0zQijeGkz33EAvAj2Cdj+z3KQKCZuStOe1lQZ/7
         T2s9DFefblWyDA44M7a5scClOoiVWOrRWhWimG+yfNOfJdnnF2VOuOr9hq5aKHYBF1
         Se2mAx4vAjQipqGARjdWr4hqL22yz34B758XfKNhkR2yK2APnsQTyFAGexn6uE0QgE
         Iyh3lmZo4KLVNiHTq9RO2wfsSDIX2rBu9uApY2gmB9A47g418AIB0EqvTvkZQPkUJe
         SM5lo17Bf5/tZYTIqEQ+oMX5s4R5tmuMpnAyoNRA+X90nRUaWXZY7CmedWdaros/JE
         HdY+0nNcKlnxw==
Date:   Thu, 5 Jan 2023 10:24:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 13/14] devlink: add by-instance dump infra
Message-ID: <20230105102437.0d2bf14e@kernel.org>
In-Reply-To: <Y7aSPuRPQxxQKQGN@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
        <20230104041636.226398-14-kuba@kernel.org>
        <Y7WuWd2jfifQ3E8A@nanopsycho>
        <20230104194604.545646c5@kernel.org>
        <Y7aSPuRPQxxQKQGN@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Jan 2023 10:02:54 +0100 Jiri Pirko wrote:
> Thu, Jan 05, 2023 at 04:46:04AM CET, kuba@kernel.org wrote:
> >> What is "gen"? Generic netlink?  
> >
> >Generic devlink command. In other words the implementation 
> >is straightforward enough to factor out the common parts.  
> 
> Could it be "genl" then?

Why? What other kind of command is there?
The distinction is weird vs generic, not genl vs IDK-what.

> >> Do you plan to have more callbacks here? If no, wouldn't it be better
> >> to just have typedef and assign the pointer to the dump_one in
> >> devl_gen_cmds array?  
> >
> >If I find the time - yes, more refactoring is possible.  
> 
> Could you elaborate a bit more about that?

If I recall I was thinking about adding a "fill" op and policy related
info to the structure. The details would fall into place during coding..

> >You mean it doesn't have nl, cmd, dump_one in the name?
> >Could you *please* at least say what you want the names to be if you're
> >sending all those subjective nit picks? :/  
> 
> Well, I provided a suggested name, not sure why that was not clear.
> The point was s/dump/dumpit/ to match the op name.

Oh, just the "it" at the end? Sorry, I don't see the point.
