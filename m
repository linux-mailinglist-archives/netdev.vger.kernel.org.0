Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0143552005
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241048AbiFTPMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243269AbiFTPMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:12:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F585FAA;
        Mon, 20 Jun 2022 08:02:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0447B80F4B;
        Mon, 20 Jun 2022 15:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B6EC3411B;
        Mon, 20 Jun 2022 15:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655737338;
        bh=L0RJ688oW+gNmui5vJ2YfJZGJk8akIpoKMPkkgDcaNw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RiiFCcJA3SkJPDlOmUocOC9rzARGtL727yrGxz3EYPEW71x6RFYFyU5FJXFrCtl+D
         F/CvzvCSJsQH1qn2NKTc1QQx5yc8cgQpwThNX/qAdpkfRtYSFslFlEr7EEKesrbfHZ
         nw122++e6NQB/7sb68L3B22Qk9xBc6Y1R8PCEjRy2YgDbFH2VmeNFjmvKSSh8Tuhy7
         ZUH5X4La2PoHlmmGx3tfb29Nq/KTa76VGs/fu3gzINV4RJ34wh1EijYKoUTIH0lbGs
         dt3V7N/T9/9AIe0TF1mhz7EocqweWH6UtL9UTna7LjUVzGT3xf7xDIkv10hDN/aYcn
         YW7wm+7yS+z3A==
Date:   Mon, 20 Jun 2022 08:02:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jon Mason <jdmason@kudzu.us>
Cc:     Wentao_Liang <Wentao_Liang_g@163.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH net v2]vexy: Fix a use-after-free bug in
 vxge-main.c
Message-ID: <20220620080216.363e57ea@kernel.org>
In-Reply-To: <YrCG0CZy4Onh/8RI@kudzu.us>
References: <20220615013816.6593-1-Wentao_Liang_g@163.com>
        <20220615195050.6e4785ef@kernel.org>
        <YrCG0CZy4Onh/8RI@kudzu.us>
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

On Mon, 20 Jun 2022 10:40:16 -0400 Jon Mason wrote:
> On Wed, Jun 15, 2022 at 07:50:50PM -0700, Jakub Kicinski wrote:
> > Jon, if you're there, do you have any sense on whether this HW is still
> > in production somewhere? I scrolled thru last 5 years of the git history
> > and there doesn't seem to be any meaningful change here while there's a
> > significant volume of refactoring going in.   
> 
> Neterion was killed off by Exar after acquiring it roughly a decade
> ago.  To my knowledge no one ever acquired the IP.  So, this should be
> viewed as an EOL'ed part.  It is a mature driver and I believe there are
> parts out in the field still.  So, no need to kill off the driver.

There is a real cost to maintaining this driver, refactoring it and
dealing with all the poor quality fixes it attracts.
