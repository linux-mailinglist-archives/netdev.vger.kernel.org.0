Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7292AEB91
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 15:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732385AbfIJN3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 09:29:06 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43526 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfIJN3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 09:29:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 23E80602BC; Tue, 10 Sep 2019 13:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568122145;
        bh=Qd5RfGYiHCwy3bpUbxAghJdbdVfjVR23GDfE0IN+sDE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Xq1EY1oHMatnwSDvLZVni9wYYLrfShk4joikKGtrueRyzCw7o70EwRWEn+REWMHU8
         r6CDDRJkSprxSv3H0aO16dbruS6RYlXvWnQZCjJxyOdoFgAaElgS8VGsR/E0vZQ8pM
         7JqAxbuWFOt/seuurC32awoDKILZVR2Cu6R2ihh0=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E8A9F602BC;
        Tue, 10 Sep 2019 13:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568122144;
        bh=Qd5RfGYiHCwy3bpUbxAghJdbdVfjVR23GDfE0IN+sDE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=X1zbG0bNjqXZ7i3dokzqk0OdZlF7b4Hc651P4oLZw6EVg9zWWNBhJ2gl+UXcN5GjG
         G9A7O8eIBgZTTS4LLckcKxV9CgpLxaDSN0LHTNcFUJ8BtfBxLMIZwt43kJLwIL6qGV
         7mPEe8wMPrGZeNA3bRP+w5Nw+eUlB3ivYOeRgOAo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E8A9F602BC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k_htc: release allocated buffer if timed out
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190906182604.9282-1-navid.emamdoost@gmail.com>
References: <20190906182604.9282-1-navid.emamdoost@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input) emamd001@umn.edu,
        smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)emamd001@umn.edu
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190910132905.23E80602BC@smtp.codeaurora.org>
Date:   Tue, 10 Sep 2019 13:29:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> wrote:

> In htc_config_pipe_credits, htc_setup_complete, and htc_connect_service
> if time out happens, the allocated buffer needs to be released.
> Otherwise there will be memory leak.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

853acf7caf10 ath9k_htc: release allocated buffer if timed out

-- 
https://patchwork.kernel.org/patch/11135781/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

