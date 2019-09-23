Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5512BAF55
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 10:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406886AbfIWI0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 04:26:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54632 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406738AbfIWI0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 04:26:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9978E60850; Mon, 23 Sep 2019 08:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569227183;
        bh=FRNWtcgHJO1U7E9Ufj5wpR5AmqzrG6aAdy6ArMEfzIo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=c9ta0fnUo2lVWsK/yDoFzW3W8iKjJPQcA02aIxzz+yMnxXt0ZvPAZXQvbJxs6E5gN
         FOMBr9uJTIr0wrfVzG0RJj4WdwXL/sgWpiCwxagtFLRM7OCdA6ftXmFOuphke9eQK+
         wXvPz92jWBdAyQfl0cZT6K9DKH0625wgUfwBp7F4=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 474EC6034D;
        Mon, 23 Sep 2019 08:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569227183;
        bh=FRNWtcgHJO1U7E9Ufj5wpR5AmqzrG6aAdy6ArMEfzIo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=oSRcADRF6EJ6AEbi54n0IbypAyhGfGC58MTU+MtaaSgstAm7P3FAcLnyCgdKQ722k
         JlTa+sS/ON8MEwtYW4rbTLNPpsEZYqNHM8GpNPWW4UmI5FxALDQNCMbDJIhdirB0XY
         p/UP+wZV5gGpK60iWO+8EJmHgkd82r/Qn5U+bY0A=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 474EC6034D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next 05/10] ath: Use dev_get_drvdata where possible
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190724112720.13349-1-hslester96@gmail.com>
References: <20190724112720.13349-1-hslester96@gmail.com>
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input)
        Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Maya Erez <merez@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wil6210@qti.qualcomm.com,
        Chuhong Yuan <hslester96@gmail.com>
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)Jiri Slaby <jirislaby@gmail.com>
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190923082623.9978E60850@smtp.codeaurora.org>
Date:   Mon, 23 Sep 2019 08:26:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuhong Yuan <hslester96@gmail.com> wrote:

> Instead of using to_pci_dev + pci_get_drvdata,
> use dev_get_drvdata to make code simpler.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

5d7e4b4935e4 ath: Use dev_get_drvdata where possible

-- 
https://patchwork.kernel.org/patch/11056619/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

