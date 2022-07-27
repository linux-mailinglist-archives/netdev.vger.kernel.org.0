Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3B0581DC3
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 04:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiG0C4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 22:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiG0C4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 22:56:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1931357CB
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 19:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B4FE6178A
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB5EC433D6;
        Wed, 27 Jul 2022 02:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658890582;
        bh=AG7dd4K/CnHCHaBHMZJfShZVr4X0Wk6i6JQ+reKkYsE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tj/fNfwd+v2BY9e81QiM0R/SCa7Vkl+KxcuDuB6cNyujj8B4EDV7wkKzVEXtBybzW
         y0ef5ZdP4RJ6ZyXfsWW0vHhfPVAkyrsKrM6oOEonmRjHWKgS6oaOQ2N41adW5g66z/
         0xkd656Crh2gdLLgVgxUbmKNiOc2u5Z/Wg6F4XrwwqeIbzjc+HOFvASjsIghg266Po
         7dWFgIa9vebQdYCDDdGEloP5pX491HqR+9M7Tbuj7AWH95c/4CyFioUDO403lE8yR0
         BHYrSB41nhS0Wz/J7MoEMXCcjSxJ+r8jyjS6yvWuoevvqk/6KNfIaw4jOOE8wYIM4y
         X/joID4xwcM2g==
Date:   Tue, 26 Jul 2022 19:56:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, patches@lists.linux.dev,
        kernel test robot <lkp@intel.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] ptp: ocp: select CRC16 to fix build error
Message-ID: <20220726195621.1b023508@kernel.org>
In-Reply-To: <20220727011213.24274-1-rdunlap@infradead.org>
References: <20220727011213.24274-1-rdunlap@infradead.org>
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

On Tue, 26 Jul 2022 18:12:13 -0700 Randy Dunlap wrote:
> ptp_ocp.c uses crc16(), so it should select CRC16 to
> prevent a build error:
> 
> ERROR: modpost: "crc16" [drivers/ptp/ptp_ocp.ko] undefined!
> 
> Fixes: 3c3673bde50c ("ptp: ocp: Add firmware header checks")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Vadim Fedorenko <vadfed@fb.com>
> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>

Jonathan just posted this fix a few hours ago:

 https://lore.kernel.org/all/20220726220604.1339972-1-jonathan.lemon@gmail.com/

