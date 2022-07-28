Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F4073583730
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 04:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbiG1Cvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 22:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbiG1Cvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 22:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2486E52FCE
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 19:51:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0C8F61957
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 02:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E011CC433C1;
        Thu, 28 Jul 2022 02:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658976690;
        bh=8CM6gHjjRz6JK5sh4S1FIuPuoM5wGf1lcREqsAHnRM4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZILHO+dH60xX6+clrPYwlaDqq8P8zBfnwP4s60sDq/0LZymV8v85E1HbVNc8hyysT
         UwztbZiA4IrUJB5jJI5qohC8n0kot7glNXj6e99SSmpCpSFwgijbVEfUm+Yb1txB0j
         J9RkdmfThRjCgrgsaojAKksm0X3q+6Q6Gtq8JzkETo6Em8GxVKuCDODoT31UFOnI+O
         CR4L2TrYLYJEnBimsy4QSML8109k4xX7uCUaB4A3S3mt5m39NbRnSmQ/mrjSeKX1p/
         xFkvpqETau0GjZHqAOc7Q/6qiaHoaLjiU3gyJeAQyZpfUOOQgJo9EAzS4EGUvv+GA0
         NVgWunEAWqGVw==
Date:   Wed, 27 Jul 2022 19:51:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <sgoutham@marvell.com>, <netdev@vger.kernel.org>,
        Harman Kalra <hkalra@marvell.com>
Subject: Re: [net v2 PATCH 2/5] octeontx2-af: suppress external profile
 loading warning
Message-ID: <20220727195128.3a5b4297@kernel.org>
In-Reply-To: <20220727194120.62af8ee7@kernel.org>
References: <1658844682-12913-1-git-send-email-sbhatta@marvell.com>
        <1658844682-12913-3-git-send-email-sbhatta@marvell.com>
        <20220727194120.62af8ee7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 19:41:20 -0700 Jakub Kicinski wrote:
> On Tue, 26 Jul 2022 19:41:19 +0530 Subbaraya Sundeep wrote:
> > -	if (!request_firmware(&fw, kpu_profile, rvu->dev)) {
> > +	if (!firmware_request_nowarn(&fw, kpu_profile, rvu->dev)) {  
> 
> Consider switching to request_firmware_direct() in net-next.
> I doubt you need the sysfs fallback, I think udev dropped 
> the support for it.

Well, the next patch needs work, so perhaps do it in v3?
