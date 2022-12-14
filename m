Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0721F64CFFB
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 20:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbiLNTRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 14:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238944AbiLNTRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 14:17:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632C91DA7C
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 11:17:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1169CB81A21
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 19:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6E7C433D2;
        Wed, 14 Dec 2022 19:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671045440;
        bh=+vJnXnLlwiJaY7yN2YO6ELW2brYzX6QVPwdjB0gIlUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kEPqF1K+4Urg1OheceKRVcJu5Jew1t18uKjWpTOOzCu7QD7D4IkJ0kiH8iYtUscEr
         oJJ4jdVqRMvdzdd+fhi2XvHp+H1ZCLx0U+7ie949YHlvXA+B7wkA7q1SOMMBOFUS/k
         4cy0Qq+h2qkRI5K4TxQp8jeX87RwQ6rkaUQSeNjf5yKfJ6XSrszXprO1n1XV7NtsTf
         YVotSlTSjjBZiQb+NUSlvPy/KgoNtez8bYKDZ7mGrNaz4iGoStzCyFom3V/4YLUF5C
         Qanzh4IFDvEOOlYudLQr4ISmNTeC+WiA54QPjqG189GDzUy3hFT5FYkYbxWRxU//61
         j2pPxYZz0vtwQ==
Date:   Wed, 14 Dec 2022 21:17:10 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nir Levy <bhr166@gmail.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: atm: Fix use-after-free bug in
 atm_dev_register()
Message-ID: <Y5ohNlJ4moB+wwdA@unreal>
References: <20221211124943.3004-1-bhr166@gmail.com>
 <Y5bUXjhM3mvUkwNL@unreal>
 <20221213191233.5d0a7c8f@kernel.org>
 <Y5mAbfpeHEuQp0BE@unreal>
 <20221214084358.161f9d6f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214084358.161f9d6f@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 08:43:58AM -0800, Jakub Kicinski wrote:
> On Wed, 14 Dec 2022 09:51:09 +0200 Leon Romanovsky wrote:
> > > Also atm_dev_register() still frees the dev on atm_register_sysfs()
> > > failure, is that okay?  
> > 
> > Yes, the kernel panic points that class_dev (not dev) had use-after-free.
> 
> How is that possible? "class_dev" is embedded in dev (struct atm_dev).

Right, the more I think about this call trace, the less I'm sure.

Thanks
