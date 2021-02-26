Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A514325E12
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 08:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhBZHN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 02:13:26 -0500
Received: from z11.mailgun.us ([104.130.96.11]:13219 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230142AbhBZHNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 02:13:09 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614323568; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=RWm26C6uYDpSadKJBqd9m+6DvYzgFfycib1pUY7Kcqg=; b=MdPiCJYGDY3Pdy+FS5ZN17lC5jlrQFiuqvlqwjzl9nza/8d6+cb2/ERnsLuEhg9BJsfc2bWV
 8HDvqI8LUk11yvRh/N3yncWnaYLsWkC6iFalHO1HKCDbGz+junoNchYWn5N7WQ7kboOWw32F
 UT/ILNIxQ99aHJR1f2ms7oozr74=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 60389f576ba9d8a92b635103 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 26 Feb 2021 07:12:23
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 544FFC433ED; Fri, 26 Feb 2021 07:12:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 32330C433CA;
        Fri, 26 Feb 2021 07:12:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 32330C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     bhelgaas@google.com, Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list),
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/3] PCI: Convert rtw88 power cycle quirk to shutdown quirk
References: <20210225174041.405739-1-kai.heng.feng@canonical.com>
        <20210225174041.405739-3-kai.heng.feng@canonical.com>
Date:   Fri, 26 Feb 2021 09:12:17 +0200
In-Reply-To: <20210225174041.405739-3-kai.heng.feng@canonical.com> (Kai-Heng
        Feng's message of "Fri, 26 Feb 2021 01:40:40 +0800")
Message-ID: <87o8g7e20e.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> writes:

> Now we have a generic D3 shutdown quirk, so convert the original
> approach to a PCI quirk.
>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 2 --
>  drivers/pci/quirks.c                     | 6 ++++++
>  2 files changed, 6 insertions(+), 2 deletions(-)

It would have been nice to CC linux-wireless also on patches 1-2. I only
saw patch 3 and had to search the rest of patches from lkml.

I assume this goes via the PCI tree so:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
