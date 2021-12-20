Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFE947B32B
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 19:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240577AbhLTSs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 13:48:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54764 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239750AbhLTSs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 13:48:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B29DBB80E4F;
        Mon, 20 Dec 2021 18:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E44C36AEA;
        Mon, 20 Dec 2021 18:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640026103;
        bh=TOaC8RLdhcvB6ECmuBAReG8nP+L3K/DiJNXdeO8ZTsU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Z9sPAjfiXfdcJQREqqv1nsAvVDYXE8TcQVuZ9ODcSV9r1auqbjVAY5HMsWDHIRI/K
         STzTN/S8HrptINF5JyWXv7J7q81Rz7nKxRE0/Us/bE5U1ejns9u8g87MShwe+9AfRL
         B8Me+o0s9ih4tS9D0Ggk24z+X5OzLlTN46URVLY+n9l/isABwetUBHrfUlvW1JF5df
         RS2bcLCqVyr1hiF8nEIhn8GaPpz7u+sRO/n0R4MShmy4MgI5y0LRfTdOMG21fKVRCi
         fIo985zXgFwjPnPJr5/+xvWM/0uHsyY6jSeBjQFf1Opi9HrUiJfkY4rNdHwU05MvqQ
         Icv7mFiKn96aQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4] rtw88: Disable PCIe ASPM while doing NAPI poll on
 8821CE
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211215114635.333767-1-kai.heng.feng@canonical.com>
References: <20211215114635.333767-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     tony0620emma@gmail.com, pkshih@realtek.com, jian-hong@endlessm.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Hao Huang <phhuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164002609722.16553.11425068672466234976.kvalo@kernel.org>
Date:   Mon, 20 Dec 2021 18:48:20 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:

> Many Intel based platforms face system random freeze after commit
> 9e2fd29864c5 ("rtw88: add napi support").
> 
> The commit itself shouldn't be the culprit. My guess is that the 8821CE
> only leaves ASPM L1 for a short period when IRQ is raised. Since IRQ is
> masked during NAPI polling, the PCIe link stays at L1 and makes RX DMA
> extremely slow. Eventually the RX ring becomes messed up:
> [ 1133.194697] rtw_8821ce 0000:02:00.0: pci bus timeout, check dma status
> 
> Since the 8821CE hardware may fail to leave ASPM L1, manually do it in
> the driver to resolve the issue.
> 
> Fixes: 9e2fd29864c5 ("rtw88: add napi support")
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215131
> BugLink: https://bugs.launchpad.net/bugs/1927808
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Acked-by: Jian-Hong Pan <jhp@endlessos.org>

Patch applied to wireless-drivers-next.git, thanks.

24f5e38a13b5 rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211215114635.333767-1-kai.heng.feng@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

