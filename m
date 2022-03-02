Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445AC4C9B1E
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239080AbiCBCWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiCBCWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:22:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903458BF4A
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 18:21:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27E8C6168F
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 02:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588FFC340EE;
        Wed,  2 Mar 2022 02:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646187714;
        bh=wYSwITO/MLJSe6g515C8Pm7/Xx6z+IZ0RirKja5rQCc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Th40gYxCzIPGb1cPE11+htotzzV4JE7CkwpShHSS2ISZVJKvHjMfosyxR9M0swFXu
         r1M6bjuvjmzj7NnAL0OT7M6bnSQanrVA+VMYi40OcpwjJP7I2hbv7Gux0ao/ogbGiQ
         5uxTN+u2wE7nU7s0g0es4sVBKxzdXdpJsxjAC1b8+SS8txFPm7lfbPOEYYdzY4qOgy
         oST6VimKpPVjFe2jE79mm5UrFiLwetNO/QE8ouMUHQ1pocaZV+tuuS2INKN5PiwCYc
         EGUb1YcNqXQq5yfW3+hQ+2ZAbkGGjT6zp6QjD3jYr73sJ1hBHN1tVs2oAKxjIkQfvh
         XT2UIOKjQVCqw==
Date:   Tue, 1 Mar 2022 18:21:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        richardcochran@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH net-next] ptp: ocp: Add ptp_ocp_adjtime_coarse for large
 adjustments
Message-ID: <20220301182153.6a1a8e89@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220228203957.367371-1-jonathan.lemon@gmail.com>
References: <20220228203957.367371-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 12:39:57 -0800 Jonathan Lemon wrote:
> In ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime."), the
> ns adjustment was written to the FPGA register, so the clock could
> accurately perform adjustments.
> 
> However, the adjtime() call passes in a s64, while the clock adjustment
> registers use a s32.  When trying to perform adjustments with a large
> value (37 sec), things fail.
> 
> Examine the incoming delta, and if larger than 1 sec, use the original
> (coarse) adjustment method.  If smaller than 1 sec, then allow the
> FPGA to fold in the changes over a 1 second window.
> 
> Fixes: 6d59d4fa1789 ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime.")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

This one's tagged for net-next - do you intend for it to go to net-next,
or is that a typo?
