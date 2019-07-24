Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1A772E47
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387419AbfGXL5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:57:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55464 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387394AbfGXL5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:57:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8C77060588; Wed, 24 Jul 2019 11:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563969471;
        bh=UlD9ONR4gdd/8IBYIJgOTY7Frhi5AOymDoq37yXpRpA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UH/NEb1hbOvQnrbCbL+zgm5JWYJDIlxzbb6AM7+u0GSPUQ5SGq0y9o1tcQmJDeNJp
         5lcuNevUQocw5xN5QT2nlzS2itV7BFm4XRlg731EsxgMqgMzXUOWRWOyvOyuYlHgeH
         fSq3TXU3gLskr/+o1lmseVcb693ULOOYQci+LTto=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 49BBB60237;
        Wed, 24 Jul 2019 11:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563969470;
        bh=UlD9ONR4gdd/8IBYIJgOTY7Frhi5AOymDoq37yXpRpA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ODg2bXeId2bBC+5P/L9QX/SFzT7wu2AUUtGB23mDOsnz6AQFd1mWC+3kMJejXTD4e
         N4JasSxRSehZT2R+0PA+WKGUrlOaM9D9EYGgMqcP8I/rWVMpQfbj+x8vV1VjXlLGl0
         MuPQI3r9EO4yHdeK2BWHnV29ZeDNuMVtFHB9UD6M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 49BBB60237
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Maya Erez <merez@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Mart in Habets <mhabets@solarflare.com>,
        netdev@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] Use dev_get_drvdata where possible
References: <20190724112524.13042-1-hslester96@gmail.com>
Date:   Wed, 24 Jul 2019 14:57:42 +0300
In-Reply-To: <20190724112524.13042-1-hslester96@gmail.com> (Chuhong Yuan's
        message of "Wed, 24 Jul 2019 19:25:24 +0800")
Message-ID: <87zhl3zlu1.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuhong Yuan <hslester96@gmail.com> writes:

> These patches use dev_get_drvdata instead of
> using to_pci_dev + pci_get_drvdata to make
> code simpler.
>
> Chuhong Yuan (10):
>   net: marvell: Use dev_get_drvdata where possible
>   forcedeth: Use dev_get_drvdata where possible
>   sfc: Use dev_get_drvdata where possible
>   sfc-falcon: Use dev_get_drvdata where possible
>   ath: Use dev_get_drvdata where possible
>   iwlegacy: Use dev_get_drvdata where possible
>   iwlwifi: Use dev_get_drvdata where possible
>   mwifiex: pcie: Use dev_get_drvdata
>   qtnfmac_pcie: Use dev_get_drvdata
>   rtlwifi: rtl_pci: Use dev_get_drvdata
>
>  drivers/net/ethernet/marvell/skge.c                |  6 ++----
>  drivers/net/ethernet/marvell/sky2.c                |  3 +--
>  drivers/net/ethernet/nvidia/forcedeth.c            |  3 +--
>  drivers/net/ethernet/sfc/ef10.c                    |  4 ++--
>  drivers/net/ethernet/sfc/efx.c                     | 10 +++++-----
>  drivers/net/ethernet/sfc/falcon/efx.c              |  6 +++---
>  drivers/net/ethernet/sfc/falcon/falcon_boards.c    |  4 ++--
>  drivers/net/wireless/ath/ath5k/pci.c               |  3 +--
>  drivers/net/wireless/ath/ath9k/pci.c               |  5 ++---
>  drivers/net/wireless/ath/wil6210/pcie_bus.c        |  6 ++----
>  drivers/net/wireless/intel/iwlegacy/common.c       |  3 +--
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 12 ++++--------
>  drivers/net/wireless/marvell/mwifiex/pcie.c        |  8 ++------
>  drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |  4 ++--
>  drivers/net/wireless/realtek/rtlwifi/pci.c         |  6 ++----
>  15 files changed, 32 insertions(+), 51 deletions(-)

Do note that wireless patches go to wireless-drivers-next, not net-next.
But I assume Dave will ignore patches 5-10 and I can take them.

-- 
Kalle Valo
