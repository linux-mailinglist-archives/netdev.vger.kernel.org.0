Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDF5632DAE
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiKUUNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiKUUND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:13:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D9C1D310;
        Mon, 21 Nov 2022 12:13:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89651B8101C;
        Mon, 21 Nov 2022 20:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AA2C433C1;
        Mon, 21 Nov 2022 20:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669061579;
        bh=G1aWu2eNylL7AnCEGaprf9Ch5gNCAnR+u01eObsqiyo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uz5O4s0YU0hU4FkIy8AzFKEKK4nLKm9rYuKXLC35La/ngQObCDX9Gula9d+m5R4sl
         8MFPYSoYPa1ziBJmFnb+kM/A8cQPE3Ce9lJPOOdWxwfdJbJYEf1Bzrnx6xy7tYEAOG
         3Xpiswts8AfuRZX45DysKhngAlfnlItS4lMQ/hp2UpMWkjupZxSvmdboWLMX0ZV43j
         VrsArtVQx4b3k/2VCkiSQ93b3wqKss51K1A32IWRKCiT9Jg/BPsZ9AbNY+VJU5ldA+
         c0iUl+PrJ3c2VBvk/oP2ww6R9mEgoTi5Bmzex96CkevbOD2jmqgOyN+SuLsnY/ZH4Y
         A9pD/qjnOAGsw==
Date:   Mon, 21 Nov 2022 12:12:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>, Tom Rix <trix@redhat.com>,
        Marco Bonelli <marco@mebeim.net>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] ethtool: avoiding integer overflow in ethtool_phys_id()
Message-ID: <20221121121258.4f359da8@kernel.org>
In-Reply-To: <20221121075618.15877-1-korotkov.maxim.s@gmail.com>
References: <20221121075618.15877-1-korotkov.maxim.s@gmail.com>
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

On Mon, 21 Nov 2022 10:56:18 +0300 Maxim Korotkov wrote:
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 2adc6edcaec0 ("ethtool: fix error handling in ethtool_phys_id")

I'm leaning towards dropping the fixes tag, and applying to -next.
Drivers returning high enough rc to cause an overflow seems theoretical, 
and is pretty harmless. Please LMK if I'm missing something.
