Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700223149D3
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 08:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhBIH6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 02:58:44 -0500
Received: from so15.mailgun.net ([198.61.254.15]:27201 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229720AbhBIH6j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 02:58:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612857500; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=HlLCxrME5LL6cQqOWNNXfJ9eXlWM3eHBp2+kv5xNFDM=;
 b=P1Ezr6TKt3Ss1LPxIDI4JviUCdZAF2OtfzHC+5ff5SAfG7E1Q3IpIcGMBf8qt0ye1eEp4BVd
 aWnXtnLAPISLraKTvkptLFJfH/hkKoVaUA9TDutb8U0ZCkrIs01gaOyB16SSBiZamF82/SdH
 Yfz47upS9gGmzqHTDtFG3MifhNM=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60224075e3df861f4b5786fa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 09 Feb 2021 07:57:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B1AD2C43464; Tue,  9 Feb 2021 07:57:40 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 754BEC433C6;
        Tue,  9 Feb 2021 07:57:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 754BEC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] brcmfmac: add support for CQM RSSI notifications
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210208125738.3546557-1-alsi@bang-olufsen.dk>
References: <20210208125738.3546557-1-alsi@bang-olufsen.dk>
To:     =?utf-8?q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210209075740.B1AD2C43464@smtp.codeaurora.org>
Date:   Tue,  9 Feb 2021 07:57:40 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alvin Šipraga <ALSI@bang-olufsen.dk> wrote:

> Add support for CQM RSSI measurement reporting and advertise the
> NL80211_EXT_FEATURE_CQM_RSSI_LIST feature. This enables a userspace
> supplicant such as iwd to be notified of changes in the RSSI for roaming
> and signal monitoring purposes.
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

7dd56ea45a66 brcmfmac: add support for CQM RSSI notifications

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210208125738.3546557-1-alsi@bang-olufsen.dk/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

