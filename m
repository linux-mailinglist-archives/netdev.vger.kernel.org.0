Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D76B0D7527
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 13:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbfJOLgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 07:36:49 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55954 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfJOLgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 07:36:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E956C60DA7; Tue, 15 Oct 2019 11:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571139408;
        bh=ovkt4b2nKzMchB9ZgtQWzeYw6k1PJKUjpwtIZzO24Mc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Us3gxveSa+uHoCXf77KwRimlDca9sam72HCL1c5NuUiD+9Nn/z1Ma5tVBqgA45tOe
         pjpZwD9AVkVOOlsNzlazbkBlJq5dDG5NeZWA5UQd1EdXhWlzSXHSRAAqIN7qZIlg6A
         Sz43FdW37JmUiBoKIbILCsqCuToy1ORroFawcuNU=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (176-93-78-119.bb.dnainternet.fi [176.93.78.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 19E6760D80;
        Tue, 15 Oct 2019 11:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571139406;
        bh=ovkt4b2nKzMchB9ZgtQWzeYw6k1PJKUjpwtIZzO24Mc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Qeo9I8PLZsA311E0L8wsSnMmwlaCDk/23SZZipiccN6Usk65XBM4XNss+gMJBmRHv
         umFfG+lEAOr2jOeOZUmiGA+KRe9YWex6yOojDRaB38k/2/dbGcxsL5AD1OSuAj8RwU
         h6BSEKzfYJ4rgJqhpw3MbzQDQjE0OUMa3oMlxd+0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 19E6760D80
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Subject: Re: [PATCH] rtl8xxxu: fix RTL8723BU connection failure issue after warm reboot
References: <20191015102109.4701-1-chiu@endlessm.com>
Date:   Tue, 15 Oct 2019 14:36:41 +0300
In-Reply-To: <20191015102109.4701-1-chiu@endlessm.com> (Chris Chiu's message
        of "Tue, 15 Oct 2019 18:21:09 +0800")
Message-ID: <874l0ansty.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessm.com> writes:

> The RTL8723BU has problems connecting to AP after each warm reboot.
> Sometimes it returns no scan result, and in most cases, it fails
> the authentication for unknown reason. However, it works totally
> fine after cold reboot.
>
> Compare the value of register SYS_CR and SYS_CLK_MAC_CLK_ENABLE
> for cold reboot and warm reboot, the registers imply that the MAC
> is already powered and thus some procedures are skipped during
> driver initialization. Double checked the vendor driver, it reads
> the SYS_CR and SYS_CLK_MAC_CLK_ENABLE also but doesn't skip any
> during initialization based on them. This commit only tells the
> RTL8723BU to do full initialization without checking MAC status.
>
> https://phabricator.endlessm.com/T28000
>
> Signed-off-by: Chris Chiu <chiu@endlessm.com>

If you send a new version of patch mark it as v2 and include a
changelog:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

-- 
Kalle Valo
