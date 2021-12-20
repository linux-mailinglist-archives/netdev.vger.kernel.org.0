Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4885347B0E7
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 17:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbhLTQJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 11:09:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49576 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbhLTQJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 11:09:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5969C61221;
        Mon, 20 Dec 2021 16:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EE4C36AE7;
        Mon, 20 Dec 2021 16:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640016551;
        bh=gzoRgQxpys+HNQmnuLWHS2lX5rCyeJ+e1FP5NKT14/Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=r4t8vvEVe+sy8r8YQqlTT18Gg786RZqjV9MomFT1Qc00T8pM7Erq4wxTHfzKnYv4E
         kT08//W88lmcdB9X8MzsmO+AZM6J5iUBMwBnBlw45cppsbZM1nxTlqg4vYakiZrOte
         oJ1ySee7bPDczSCHVD2GRmOmAy4fFARW5W39IYBr91Kbue52BcAYrVSNdFYvMt1W4V
         VBV3UMPeRxyrqzNRhHdxivtP2saqFeVe4a+YFBEbIWx5bMT7rFXd6qZjncbQE5ftOB
         rL/ID1kQ1eqVNkxI1CJawgP8RIekpss3J+HfCJWr3s/5yHcYitwTflNZxB4o9PX0XO
         xnl0dADEO4lJw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2 (RESEND)] ath9k_htc: fix NULL pointer dereference at
 ath9k_htc_rxep()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <2b88f416-b2cb-7a18-d688-951e6dc3fe92@i-love.sakura.ne.jp>
References: <2b88f416-b2cb-7a18-d688-951e6dc3fe92@i-love.sakura.ne.jp>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164001654478.2023.4087324781381514269.kvalo@kernel.org>
Date:   Mon, 20 Dec 2021 16:09:10 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> syzbot is reporting lockdep warning followed by kernel panic at
> ath9k_htc_rxep() [1], for ath9k_htc_rxep() depends on ath9k_rx_init()
> being already completed.
> 
> Since ath9k_htc_rxep() is set by ath9k_htc_connect_svc(WMI_BEACON_SVC)
>  from ath9k_init_htc_services(), it is possible that ath9k_htc_rxep() is
> called via timer interrupt before ath9k_rx_init() from ath9k_init_device()
> is called.
> 
> Since we can't call ath9k_init_device() before ath9k_init_htc_services(),
> let's hold ath9k_htc_rxep() no-op until ath9k_rx_init() completes.
> 
> Link: https://syzkaller.appspot.com/bug?extid=4d2d56175b934b9a7bf9 [1]
> Reported-by: syzbot <syzbot+4d2d56175b934b9a7bf9@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Tested-by: syzbot <syzbot+4d2d56175b934b9a7bf9@syzkaller.appspotmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

2 patches applied to ath-next branch of ath.git, thanks.

b0ec7e55fce6 ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()
8b3046abc99e ath9k_htc: fix NULL pointer dereference at ath9k_htc_tx_get_packet()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/2b88f416-b2cb-7a18-d688-951e6dc3fe92@i-love.sakura.ne.jp/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

