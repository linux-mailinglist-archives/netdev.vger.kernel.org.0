Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C8F69FC47
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 20:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjBVTeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 14:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbjBVTeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 14:34:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872B8A4
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 11:33:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34697B8160D
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 19:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE49C4339B;
        Wed, 22 Feb 2023 19:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677094415;
        bh=jou6uLIFl8wFkZwIOa9BfGdcKxHRSdoLKWrAorZ1/3s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JkLhVehb+g+CC5pudqXA0yjTG2ssnUwViytVHCYSJpaWuToPPeM5WrYQrxdNQJEtk
         H/faTkGiDnbkmW/qH9AZ1mlFaPyNJalBRns8U7KwCz3/1isolQEogmZLC4K9XJAKKB
         GWP6qkE7E+4pEhtaY218oBYhdeZOhtGLuP4UwNEnrQcoee2ahK/DD/u6oQdr5PMyDX
         V/Nh6zGiPqnTYaEwEl9Q9WHwLxNTUVn99RA0ymF4Av4pb72eSe4H+JW+HvAqf/aobF
         LFTlE35Gn9lmclPeiE0EWbnJlpty0sN+0rpBAxSYwCKPpo+oJQwxW0o3Emxr9jDlbd
         mQmOOBfT26khQ==
Date:   Wed, 22 Feb 2023 11:33:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [PULL] Networking for v6.3
Message-ID: <20230222113334.0fb37d5f@kernel.org>
In-Reply-To: <d04f822b-ac63-7f45-ef4d-978876d57307@intel.com>
References: <20230221233808.1565509-1-kuba@kernel.org>
        <CAHk-=wi_410KZqHwF-WL5U7QYxnpHHHNP-3xL=g_y89XnKc-uw@mail.gmail.com>
        <d04f822b-ac63-7f45-ef4d-978876d57307@intel.com>
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

On Wed, 22 Feb 2023 20:07:21 +0100 Alexander Lobakin wrote:
> > I suspect it would be as simple as adding a
> > 
> >         depends on ICE != n
> > 
> > to that thing, but I didn't get around to testing that. I thought it
> > would be better to notify the guilty parties.  
> 
> Patch is on its way already, it just drops the opt and uses CONFIG_GNSS
> directly.

You got me slightly worried now. The overall idea of using Kconfig 
to resolve the dependency and compile out the entire file was right.
Are you planing to wrap the entire source in IS_REACHABLE() ?
