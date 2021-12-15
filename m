Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793604750F4
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 03:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235381AbhLOC24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 21:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235326AbhLOC2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 21:28:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B682C061574;
        Tue, 14 Dec 2021 18:28:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C86DB61792;
        Wed, 15 Dec 2021 02:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C317CC34601;
        Wed, 15 Dec 2021 02:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639535334;
        bh=4xECLiwNF6RfSg/fD9+GkSYYgP5ENXEYZA4FCnBxU48=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T0ie4K1o9H9176ExdBqc4TWMYWdcaL9/qKCaQEvhZ1tnWUMCv38QP5BR04su7Pje5
         zmpEcvxAbEOhAAlf+OruLtIArOHE4xTjNOkPCBrsUWQplaRWe2JY4q3ygyxcTwES7P
         mPHhXYo2J1IRPVZ7YcscFrrI8MtUh+8FLU6M93lO5hwzX5s++dS+vjJlRXJC8vhAg8
         lK7CS/f3Hqy+25BAaauKl209NM3rECefgUlE8Cp/4IJXET+pMvUT5hvJaLefqT6/Us
         lDfh3z+ZpOZdc0ikGxWY+WPoZzTyPrpYDwqawMQHYCo8/CxfbMcymiM5IoKyZYQXjG
         yJo2OSCE/MHSA==
Date:   Tue, 14 Dec 2021 18:28:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     kvalo@codeaurora.org, briannorris@chromium.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dianders@chromium.org, pillair@codeaurora.org,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ath10k: enable threaded napi on ath10k driver
Message-ID: <20211214182852.6ebafb24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211214223901.1.I777939e0ef1e89872d4ab65340f3fd756615a047@changeid>
References: <20211214223901.1.I777939e0ef1e89872d4ab65340f3fd756615a047@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Dec 2021 22:39:36 +0000 Abhishek Kumar wrote:
> NAPI poll can be done in threaded context along with soft irq
> context. Threaded context can be scheduled efficiently, thus
> creating less of bottleneck during Rx processing. This patch is
> to enable threaded NAPI on ath10k driver.

You need to explain in more detail what you mean by "can be scheduled
efficiently". mt76 had an issue where Rx and Tx would use the same IRQ 
and threaded NAPI allowed them to be run on separate cores. What's the
challenge for ath10k HW?
