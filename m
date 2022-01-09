Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43008488CC1
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 22:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbiAIV6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 16:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbiAIV6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 16:58:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4A5C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 13:58:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4368B60EEE
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 21:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC11C36AED;
        Sun,  9 Jan 2022 21:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641765522;
        bh=kpeVU4OEvgxip3fjbIboWKuo/kkruqVQADAIeGKE4E4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=im/lwyxZQ3xMC3EZvjsCIr1zNO/1WBwWFZqT+KBsgKLb6HUuBUvpbKyOJschdJno5
         +4lFUie9h1ySn0MRS47TFz6irEgPiUiKPwtWVU7xV5zFjFHwbXztcw0MgmcNf5LdEE
         VfzFYjOEYnt5UbyxpyUFYywf8rNVWhXkOsGyox6PwjSIWK9aqCIPFcwm3n8nvUgPPB
         rsO0B1hWq77T9pE3+SX04miws9/AWPcQLlToEIiYT2AZSO4CGNQ51t079VE2eSDfhQ
         yfTc3Ek70zSNYLmyVQH24VHyK5Q1/gjx5Gs0/P6LTh6aDYkLHlRKlf03shUKb8h6wP
         L7IqlMk88aaIw==
Date:   Sun, 9 Jan 2022 13:58:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next 3/4] bnxt_en: use firmware provided max timeout
 for messages
Message-ID: <20220109135841.1cebb7d5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1641692328-11477-4-git-send-email-michael.chan@broadcom.com>
References: <1641692328-11477-1-git-send-email-michael.chan@broadcom.com>
        <1641692328-11477-4-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  8 Jan 2022 20:38:47 -0500 Michael Chan wrote:
> -#define FLASH_NVRAM_TIMEOUT	((HWRM_CMD_TIMEOUT) * 100)
> -#define FLASH_PACKAGE_TIMEOUT	((HWRM_CMD_TIMEOUT) * 200)
> -#define INSTALL_PACKAGE_TIMEOUT	((HWRM_CMD_TIMEOUT) * 200)
> +#define FLASH_NVRAM_TIMEOUT	(bp->hwrm_cmd_max_timeout)
> +#define FLASH_PACKAGE_TIMEOUT	(bp->hwrm_cmd_max_timeout)
> +#define INSTALL_PACKAGE_TIMEOUT	(bp->hwrm_cmd_max_timeout)

> -#define HWRM_COREDUMP_TIMEOUT		((HWRM_CMD_TIMEOUT) * 12)
> +#define HWRM_COREDUMP_TIMEOUT		(bp->hwrm_cmd_max_timeout)

Please don't use variables which are not argument of the macro.
Why not replace the uses?
