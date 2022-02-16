Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB1B4B7FAD
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 05:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344418AbiBPErq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 23:47:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344467AbiBPEro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 23:47:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659D2F4639
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:47:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 006DF61975
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 04:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221CBC340ED;
        Wed, 16 Feb 2022 04:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644986849;
        bh=XijFaTOnpbWzcGZXbGvlTSqjr/7Wj6Aa1QWxaGnY2+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p4N37zgmokhMxbQ1WUU40mTV57jvpHpwoh9izv+AxyeuSbyADB+hdNwajtADeA+P+
         XT+bPnF4TAq9zGrkmqoTvvhHLsFElDyWhfrinz0rS+YeGvx1YZiC847jJrykjy3+dE
         pGeWWnylvsAk2p66h+7F7VMIdpEPrFvsjJJ+0LucHbrZ2oWT05NFjhtcW3VlI1KnrJ
         rGbvJ3P4cjm9Nks00gf63FhwTDynbtXcQHs/to2qEmugAyKken47XGEOM56VqcV51P
         wqRGf6C4d5gWk/KevgSXz4s4WGgU4kxswaigs+VgT1/khI9xMzQqeJNWh0ulH6mgMW
         eHCa5vjvEr/mA==
Date:   Tue, 15 Feb 2022 20:47:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacques de Laval <Jacques.De.Laval@westermo.com>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 1/1] net: Add new protocol attribute to IP
 addresses
Message-ID: <20220215204728.1954e7b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220214155906.906381-1-Jacques.De.Laval@westermo.com>
References: <20220214155906.906381-1-Jacques.De.Laval@westermo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Feb 2022 16:59:06 +0100 Jacques de Laval wrote:
> @@ -4626,6 +4631,7 @@ static const struct nla_policy ifa_ipv6_policy[IFA_MAX+1] = {
>  	[IFA_FLAGS]		= { .len = sizeof(u32) },
>  	[IFA_RT_PRIORITY]	= { .len = sizeof(u32) },
>  	[IFA_TARGET_NETNSID]	= { .type = NLA_S32 },
> +	[IFA_PROTO]             = { .len = sizeof(u8) },
>  };

Is there a reason this is not using type = NLA_U8?
