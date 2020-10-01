Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B724A280023
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 15:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732343AbgJAN3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 09:29:02 -0400
Received: from z5.mailgun.us ([104.130.96.5]:60669 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731993AbgJAN3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 09:29:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601558940; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=fE++3/ie3cIRDvVj3xrUA5Hv0AvaLq6A86WkYmYj+60=;
 b=IfPogxxPBblW7qxXcMxJfNYfK3P6WDMFhJTpuQlDD2ls4iElfozq74KmQWDFO7BYuJk9GD8K
 bdswhR75FRrkMm92VtgVJlEHL/c+5pgfbkIUUUC9mA3B2rS0iXDLukhxIxfWqCXpPT2Ar85P
 XgsBlfrnV3kQ4TE1XR5/Y/71gYU=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f75d999f4f360f889b1a70e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 01 Oct 2020 13:28:57
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 57A09C433C8; Thu,  1 Oct 2020 13:28:56 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5A6A9C433CA;
        Thu,  1 Oct 2020 13:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5A6A9C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtw88: pci: Power cycle device during shutdown
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200928165508.20775-1-kai.heng.feng@canonical.com>
References: <20200928165508.20775-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     yhchuang@realtek.com, briannorris@chromium.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtw88)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201001132856.57A09C433C8@smtp.codeaurora.org>
Date:   Thu,  1 Oct 2020 13:28:56 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:

> There are reports that 8822CE fails to work rtw88 with "failed to read DBI
> register" error. Also I have a system with 8723DE which freezes the whole
> system when the rtw88 is probing the device.
> 
> According to [1], platform firmware may not properly power manage the
> device during shutdown. I did some expirements and putting the device to
> D3 can workaround the issue.
> 
> So let's power cycle the device by putting the device to D3 at shutdown
> to prevent the issue from happening.
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=206411#c9
> 
> BugLink: https://bugs.launchpad.net/bugs/1872984
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

44492e70adc8 rtw88: pci: Power cycle device during shutdown

-- 
https://patchwork.kernel.org/patch/11804271/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

