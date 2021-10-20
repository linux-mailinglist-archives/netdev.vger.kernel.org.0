Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45921434759
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhJTIyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:54:20 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:62226 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhJTIyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 04:54:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634719925; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=ZYuf2JfwuSM+9+A5y3eGiMTK0+DdPpzjW4F8eq56Ksk=;
 b=rwCBx609D7wLW4nF0xDmbn3qDKInRZ31o5ELQD2K1jkAj87T6Gmo33/YvcAmPYZu/+NJWpIR
 S59YKKs9D8FosAYmOePy/j338dMESVMbOF/P5jRyJpeqfQIEgIe/GYlXASbJSSWeW8e4zy+T
 el5mgPKMseVNxsdFACVvmf93zuE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 616fd8a514914866fa2d8d50 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 20 Oct 2021 08:51:49
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9848FC4361C; Wed, 20 Oct 2021 08:51:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 66968C4338F;
        Wed, 20 Oct 2021 08:51:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 66968C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 1/5] mwifiex: Don't log error on suspend if
 wake-on-wlan is
 disabled
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211016153244.24353-2-verdre@v0yd.nl>
References: <20211016153244.24353-2-verdre@v0yd.nl>
To:     =?utf-8?q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163471990247.1743.10996489794553301742.kvalo@codeaurora.org>
Date:   Wed, 20 Oct 2021 08:51:48 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonas Dreßler <verdre@v0yd.nl> wrote:

> It's not an error if someone chooses to put their computer to sleep, not
> wanting it to wake up because the person next door has just discovered
> what a magic packet is. So change the loglevel of this annoying message
> from ERROR to INFO.
> 
> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>

5 patches applied to wireless-drivers-next.git, thanks.

03893e93aff8 mwifiex: Don't log error on suspend if wake-on-wlan is disabled
fd7f8c321b78 mwifiex: Log an error on command failure during key-material upload
a8a8fc7b2a71 mwifiex: Fix an incorrect comment
cc8a8bc37466 mwifiex: Send DELBA requests according to spec
5943a864fe84 mwifiex: Deactive host sleep using HSCFG after it was activated manually

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211016153244.24353-2-verdre@v0yd.nl/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

