Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90DE54C1868
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242725AbiBWQU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234267AbiBWQU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:20:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2672BC4E22;
        Wed, 23 Feb 2022 08:20:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA9C9B82086;
        Wed, 23 Feb 2022 16:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4853C340F0;
        Wed, 23 Feb 2022 16:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645633226;
        bh=iwzxRJ3WVWy1eMmDfafaRhAbMtXzmT+t5EvSTlNcAhw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g4BRZ7ssHQH3BTFNVPjOS3ckd3nmgvpjeaE6eLm4+XUXP0p5axjNrcGTtMfzhmrq7
         Nhcbf3g9R8hNq0paOiE1nVkEqAotlMxe0EaQZQadN0Uhz+KTv7PmTPenDkuPRDcuQR
         Tt1uJZ4G4Kq6w+taKyNr/4T9SwKhCu8dSVdDotMfP28fc1ubQRb7y84aXgqkPWSaLi
         9fl+THewyu4XI3Mmd4yN5JxIfYW9UzLW+ETSwyjh2IAtNPq2MhczbUAgXaxV6LgxEV
         N1JZPlcngeU5p4x7XKaQM51n98/bb2knKdm8kOW7TlJOqAK2PEQ2IiLNdXp7jQPJZJ
         h1T0z0snwRKCQ==
Date:   Wed, 23 Feb 2022 08:20:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/5] Add support for locked bridge ports
 (for 802.1X)
Message-ID: <20220223082024.6ab51265@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <86y222vuuc.fsf@gmail.com>
References: <20220222132818.1180786-1-schultz.hans+netdev@gmail.com>
        <20220222111523.030ab13d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <86y222vuuc.fsf@gmail.com>
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

On Wed, 23 Feb 2022 09:40:59 +0100 Hans Schultz wrote:
> > You still haven't answer my question. Is the data plane clear text in
> > the deployment you describe?  
> 
> Sorry, I didn't understand your question in the first instance. So as
> 802.1X is only about authentication/authorization, the port when opened
> for a host is like any other switch port and thus communication is in
> the clear.

Alright, thanks for clarifying!

> I have not looked much into macsec (but know ipsec), and that is a
> crypto (key) based connection mechanism, but that is a totally different
> ballgame, and I think it would for most practical cases require hardware 
> encryption.
