Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F222DEFB9
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 14:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgLSNHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 08:07:40 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:62831 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbgLSNHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 08:07:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608383236; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=2rdcGMoZjvwEI14/iE0GeGMU3+IFUPK3B3exsw9OHwk=; b=o+5lrR8mkjZh2eClHECwgUBRA94KmUsgk1CE3ltx9qhgJ8WikjFRE3IySwMpap8BUrAuQ3oB
 OGZkRMTYNpQdBtQ2t2nOpmvqBVEI+QMOmwju8te56JpuhbuwXi9e2/PEfQsygEXllkfY7Lli
 PLHHxPB1Hb/pOmzhkuZ7EXLl+MQ=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fddfaeaf5e9af65f825920e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 19 Dec 2020 13:06:50
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 62DF3C43469; Sat, 19 Dec 2020 13:06:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A5697C43462;
        Sat, 19 Dec 2020 13:06:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A5697C43462
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: Re: [PATCH] [v11] wireless: Initial driver submission for pureLiFi STA devices
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20201208115719.349553-1-srini.raju@purelifi.com>
Date:   Sat, 19 Dec 2020 15:06:42 +0200
In-Reply-To: <20201208115719.349553-1-srini.raju@purelifi.com> (Srinivasan
        Raju's message of "Tue, 8 Dec 2020 17:27:04 +0530")
Message-ID: <87sg82q719.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> writes:

> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices.
>
> This driver implementation has been based on the zd1211rw driver.
>
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management.
>
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture.

Is endianess support is properly implemented?

> +			fw_data[tbuf_idx] =
> +				((fw_data[tbuf_idx] & 128) >> 7) |
> +				((fw_data[tbuf_idx] &  64) >> 5) |
> +				((fw_data[tbuf_idx] &  32) >> 3) |
> +				((fw_data[tbuf_idx] &  16) >> 1) |
> +				((fw_data[tbuf_idx] &   8) << 1) |
> +				((fw_data[tbuf_idx] &   4) << 3) |
> +				((fw_data[tbuf_idx] &   2) << 5) |
> +				((fw_data[tbuf_idx] &   1) << 7);

Is this cpu_to_le16() or what? Try avoid reinventing the wheel and use
what kernel provides you.

Also noticed lots of dev_info() spamming, please convert those to debug
messages.

And rx_usb_enabled is racy and it will not work if there are multiple
devices. Maybe move it to struct purelifi_usb or similar?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
