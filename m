Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BAD6E4E60
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 18:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjDQQij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 12:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjDQQig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 12:38:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8125AF38
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 09:38:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E3D561182
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 16:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C882C433D2;
        Mon, 17 Apr 2023 16:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681749513;
        bh=UIcbgmX53wdhHABZ1JIhU1zwxYYSwNI6E1wGq28Ge0c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n27BAVd2rXyx+l7JMv4M/tvCuSp6LLB+GuxvMUmppwqQqxyRcqHG8mM+9RbC4ixb9
         s0m41VPJ1LQQ3u/4IY3xRgIdx37yV+ViBqx75xs8JUe89PSkBmDLHdBW12gZKhmOSO
         l0Bj7/RskmXXfR5P/SNi+EqOkqyaPYb1tzb+MMotVgant1HkzA2uEF31rKmkkbS35h
         WhpCxCK7bRKy/tGyfMeSZrWWowYs6ZY9MxAl0M7zm6/09p6O9Ilw/HDoxJzyzLPnnc
         mPAToxURSYi9xtUpnnft66wUwQKzRFZBOKSaeIrdUaCq7M1dr3ZLKpTO7Wta4GQVzb
         74695ZdRWNkXA==
Date:   Mon, 17 Apr 2023 09:38:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        willemb@google.com, decot@google.com, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        pabeni@redhat.com, davem@davemloft.net
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 00/15] Introduce Intel
 IDPF driver
Message-ID: <20230417093832.686d0799@kernel.org>
In-Reply-To: <ZDrb58HEqLvG6ZoQ@sashalap>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
        <ZDb3rBo8iOlTzKRd@sashalap>
        <643703892094_69bfb294a3@willemb.c.googlers.com.notmuch>
        <d2585839-fcec-4a68-cc7a-d147ce7deb04@intel.com>
        <20230412192434.53d55c20@kernel.org>
        <ZDnNRs6sWb45e4F6@sashalap>
        <20230414152744.4fd219f9@kernel.org>
        <ZDrb58HEqLvG6ZoQ@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 Apr 2023 13:16:23 -0400 Sasha Levin wrote:
> Sorry, I may not have explained myself well. My concern is not around
> what's standard and what's not, nor around where in the kernel tree
> these drivers live.

My bad, I thought you were looking at this from the stable tree's angle.

> I'm concerned that down the road we may end up with two drivers that
> have the same name, and are working with hardware so similar that it
> might be confusing to understand which driver a user should be using.
> 
> Yes, it's not something too big, but we have an opportunity to think
> about this before committing to anything that might be a pain down the
> road.

Indeed, the "update" Willem mentioned should be at most a quirk or
capability exchange with the device within this driver. Two drivers
would be unacceptable.
