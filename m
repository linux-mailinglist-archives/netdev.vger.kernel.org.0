Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1017348BDD0
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 05:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350553AbiALEEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 23:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiALEEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 23:04:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFC6C06173F;
        Tue, 11 Jan 2022 20:04:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 311F6B81DC3;
        Wed, 12 Jan 2022 04:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB90C36AE5;
        Wed, 12 Jan 2022 04:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641960272;
        bh=eGRlpg3VxAY5n3m2OpliJ4gtpt/6kROMKWXtYJ8Kqgo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=orETFnpTdbqZ95McoFABt5RqtThiZqm/TkCEOEitnJ9AAPdoMJyO7dz/HdaVX6IkU
         Cd4UqH/QEZu+NfHXcT1Xzm8RXoFlZAL1LyDwv3l008Q2/gGOVGrXZ/PGGc8BsyWogN
         x83fCMHFe2NPxX/3sV15OKdy2KbHt787jvR0ICWFlmE95gwxxgwDN2Gz0ynfvwG7Ff
         GFdRzkUiz5aFcfrMPnpaRQDIPGfRTY5GamFatZbTBEYBNS6acUBD55NxopJoCKKvdw
         4GNySUOb2sy8xhkb7k1V6q6aqUER/uKDO5ZDq6iJZsVVUIusBJDGftYBxRoA2J72fZ
         WMGIT9k55V20w==
Date:   Tue, 11 Jan 2022 20:04:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, jponduru@codeaurora.org,
        avuyyuru@codeaurora.org, bjorn.andersson@linaro.org,
        agross@kernel.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: ipa: prevent concurrent replenish
Message-ID: <20220111200426.37fd9f67@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220111192150.379274-3-elder@linaro.org>
References: <20220111192150.379274-1-elder@linaro.org>
        <20220111192150.379274-3-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jan 2022 13:21:50 -0600 Alex Elder wrote:
> Use a new atomic variable to ensure only replenish instance for an
> endpoint executes at a time.

Why atomic_t? test_and_set_bit() + clear_bit() should do nicely here?
