Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904BA5902B3
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbiHKQMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbiHKQMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:12:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A7098D04;
        Thu, 11 Aug 2022 08:56:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80C58B8214A;
        Thu, 11 Aug 2022 15:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC8AC43470;
        Thu, 11 Aug 2022 15:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233417;
        bh=ZnvyI0mIDZodC4vJ4wFlk3LaRrrpcSAdA/qWbSvK0Ww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VyTG+PqH1Ss6lWD9+43NRO+a8Zc9sDT5QCM1yCT0VHmH5KHToaawkMLHjbNRGY2d4
         oLJTtmvzXEmqHhJv3ujJXyyheP/cLFOcfZ2QTlUfobFk22UNQjxaqWK4SLOybqdGyc
         2vRz5S9aT43mFmp3CZHTRFjqYEicpk/P/nfPVPUjsBKxbCzRizt4hGgKlQiwzCJTAL
         nkDHujCTcl1pJ0Bemc8Pzs5Nj5MxxaaWAcAjQekmWIBhnjtviXcLwmK+DhHoM3X9qw
         YHH5vDvzB2aP9lQIoacCx19LjwtUikeVVME2cCIuJI+MVHjmVVW9y9q6KXHhP+tN8K
         6seOBjZe/JW/w==
Date:   Thu, 11 Aug 2022 08:56:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 076/105] net: devlink: avoid false DEADLOCK
 warning reported by lockdep
Message-ID: <20220811085648.33664dda@kernel.org>
In-Reply-To: <20220811152851.1520029-76-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
        <20220811152851.1520029-76-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 11:28:00 -0400 Sasha Levin wrote:
> From: Moshe Shemesh <moshe@nvidia.com>
> 
> [ Upstream commit e26fde2f5befad0951fe6345403616bf51e901be ]
> 
> Add a lock_class_key per devlink instance to avoid DEADLOCK warning by
> lockdep, while locking more than one devlink instance in driver code,
> for example in opening VFs flow.

I think we can drop this one, no driver locks multiple instances 
in 5.19. The whole infra for that stuff is new. Not that adding 
a lockdep key can hurt in any way..
