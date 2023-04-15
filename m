Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DC46E32D4
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjDORQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjDORQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:16:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C5810E7
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 10:16:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3333614C4
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 17:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92B4C433D2;
        Sat, 15 Apr 2023 17:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681578985;
        bh=YBy+HV96SaoTKtOsia7TJlcxUKngGg+lySmETOQFiDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pZvRlbzT8g5sy23nmcxRBsbVliB3K69RMZK9GfGuGewFuTM60q8Xt9M0SZsC9ZggF
         JIP9LLcA9muJvutXm8HpKDZbLGIqg9UUX/GbRxTu+pnyRzPnErb/WD5XtJ2ntNtIGU
         C+NN8tcZELaSLs94/daCY9+ZfZPx65DRoHlvbzmRfpv3MpacEiTiEUjQoxpvW4GB9s
         +qSarNqzLR5ICpSaM0lniqYbvjS0HyX23uok11az6zs9yxXuBKW9yqsUMmIsdYoi6Q
         0wEjHqA3zgVtHeVdHkO0y7HVmTZhBp5DMQ5vaCKBa4db7aFaGNVEtAy1FODgyxIDZk
         VzAOwq7QM1COQ==
Date:   Sat, 15 Apr 2023 13:16:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        willemb@google.com, decot@google.com, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        pabeni@redhat.com, davem@davemloft.net
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 00/15] Introduce Intel IDPF
 driver
Message-ID: <ZDrb58HEqLvG6ZoQ@sashalap>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <ZDb3rBo8iOlTzKRd@sashalap>
 <643703892094_69bfb294a3@willemb.c.googlers.com.notmuch>
 <d2585839-fcec-4a68-cc7a-d147ce7deb04@intel.com>
 <20230412192434.53d55c20@kernel.org>
 <ZDnNRs6sWb45e4F6@sashalap>
 <20230414152744.4fd219f9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230414152744.4fd219f9@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 03:27:44PM -0700, Jakub Kicinski wrote:
>On Fri, 14 Apr 2023 18:01:42 -0400 Sasha Levin wrote:
>>> As I said previously in [0] until there is a compatible, widely
>>> available implementation from a second vendor - this is an Intel
>>> driver and nothing more. It's not moving anywhere.
>>
>> My concern isn't around the OASIS legal stuff, it's about the users who
>> end up using this and will end up getting confused when we have two (or
>> more) in-kernel "IDPF" drivers.
>>
>> I don't think that moving is an option - it'll brake distros and upset
>> users: we can't rename drivers as we go because it has a good chance of
>> breaking users.
>
>Minor pain for backports but I don't think we need to rename anything,
>just move.
>
>Or we can just leave it be under intel/, since there are not other
>participant now. Unless perhaps under google/ is a better option?
>
>Drivers are organized by the vendor for better or worse. We have a
>number of drivers under the "wrong directly" already. Companies merge /
>buy each others product lines, there's also some confusion about common
>IP drivers. It's all fine, whatever.
>
>Users are very, very unlikely to care.
>
>>> I think that's a reasonable position which should allow Intel to ship
>>> your code and me to remain professional.
>>
>> No concerns about OASIS or the current code, I just don't want to make
>> this a mess for the users.
>
>It's not a standard until someone else actually adopts it. What stops
>all the other vendors from declaring that their driver interface is a
>standard now, too?
>
>We have a long standing rule in netdev against using marketing language.

Sorry, I may not have explained myself well. My concern is not around
what's standard and what's not, nor around where in the kernel tree
these drivers live.

I'm concerned that down the road we may end up with two drivers that
have the same name, and are working with hardware so similar that it
might be confusing to understand which driver a user should be using.

Yes, it's not something too big, but we have an opportunity to think
about this before committing to anything that might be a pain down the
road.

-- 
Thanks,
Sasha
