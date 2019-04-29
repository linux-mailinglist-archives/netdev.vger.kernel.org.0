Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621CAE545
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 16:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbfD2Oso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 10:48:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39800 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbfD2Osn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 10:48:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B70F7608BA; Mon, 29 Apr 2019 14:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556549322;
        bh=NcFqWJZM8KHVVeLy31Z4V83m0XnDaKF7vCAx6RUJ4kQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Wh/qgAmhyh7cA6V9hWUzr5W7oCSXScy5XwDthvFwo0xAf6rePnkuUxoaODcND7TXw
         tLMHQZbSslvkTGFQCZmELkS2os0DDmXXpS0jd8MSklqBxQ/GqLVW9cnLP0TO9S4b6t
         UNsnlSPkIZXHFOx0V861hIanpHY4dfsjQNyLsk+w=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF25760134;
        Mon, 29 Apr 2019 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556549322;
        bh=NcFqWJZM8KHVVeLy31Z4V83m0XnDaKF7vCAx6RUJ4kQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=k5rSRXEu3lTa/+KjDCIwxoOyt7MXBCnBHltcQsIQJHPowy4bg6iHAmqOHnrLmsnWb
         ehJSTJTtnV99sNUBNQAubQeAHzYENPFIIgDKVNX8Xv8sTdG5PIN1Grw7EcnhAfdU1u
         IQXFaioSpe6//5LnSBnl/9R+2jnLdDG6NYchdhr4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AF25760134
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath6kl: wmi: use struct_size() helper
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190403184949.GA7597@embeddedor>
References: <20190403184949.GA7597@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190429144842.B70F7608BA@smtp.codeaurora.org>
Date:   Mon, 29 Apr 2019 14:48:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, replace code of the following form:
> 
> sizeof(*ev) + ev->num_neighbors * sizeof(struct wmi_neighbor_info)
> 
> with:
> 
> struct_size(ev, neighbor, ev->num_neighbors)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

83d9562b6478 ath6kl: wmi: use struct_size() helper

-- 
https://patchwork.kernel.org/patch/10884343/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

