Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890012D22D8
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 06:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgLHFCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 00:02:45 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:16837 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgLHFCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 00:02:45 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607403739; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=tj9rBjSpnqQrd08gg6qirCgLleskHe5sgj9qm4KfQbE=; b=vOnuKMl4vVQaJWiZcUmD2vXJmWoEw6pB/GxFU9q/0ICoMqnE/Q3UPL8uyKjbWyr2Ts4nR7hs
 D/AEjAtRzG9FDGtX2tI5T0W0Ss78+0o7Icv5sIGMe5dhlsTnEjlRf5dKrkSSOWXyjHaFClaY
 ohU/jyfolLDzSMapLjPEBBd5AzI=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fcf08bfae7b1057669c658d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 08 Dec 2020 05:01:51
 GMT
Sender: pillair=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A7AAFC433ED; Tue,  8 Dec 2020 05:01:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from Pillair (unknown [49.205.247.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 317A4C433C6;
        Tue,  8 Dec 2020 05:01:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 317A4C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'Abhishek Kumar'" <kuabhs@chromium.org>, <kvalo@codeaurora.org>
Cc:     <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <ath10k@lists.infradead.org>, <briannorris@chromium.org>,
        <dianders@chromium.org>, "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>, <netdev@vger.kernel.org>
References: <20201207231824.v3.1.Ia6b95087ca566f77423f3802a78b946f7b593ff5@changeid>
In-Reply-To: <20201207231824.v3.1.Ia6b95087ca566f77423f3802a78b946f7b593ff5@changeid>
Subject: RE: [PATCH v3] ath10k: add option for chip-id based BDF selection
Date:   Tue, 8 Dec 2020 10:31:42 +0530
Message-ID: <005d01d6cd1f$3c469ff0$b4d3dfd0$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQCE8JkGD3TKZlrmAmVZX18lYRS3TayQXLQA
Content-Language: en-us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


> -----Original Message-----
> From: Abhishek Kumar <kuabhs@chromium.org>
> Sent: Tuesday, December 8, 2020 4:50 AM
> To: kvalo@codeaurora.org
> Cc: linux-kernel@vger.kernel.org; kuabhs@chromium.org; linux-
> wireless@vger.kernel.org; ath10k@lists.infradead.org;
> pillair@codeaurora.org; briannorris@chromium.org;
> dianders@chromium.org; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; netdev@vger.kernel.org
> Subject: [PATCH v3] ath10k: add option for chip-id based BDF selection
> 
> In some devices difference in chip-id should be enough to pick
> the right BDF. Add another support for chip-id based BDF selection.
> With this new option, ath10k supports 2 fallback options.
> 
> The board name with chip-id as option looks as follows
> board name 'bus=snoc,qmi-board-id=ff,qmi-chip-id=320'
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
> Tested-on: QCA6174 HW3.2 WLAN.RM.4.4.1-00157-QCARMSWPZ-1
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> ---
> 
> Changes in v3:
> - Resurreted Patch V1 because as per discussion we do need two
> fallback board names and refactored ath10k_core_create_board_name.
> 
>  drivers/net/wireless/ath/ath10k/core.c | 41 +++++++++++++++++++-------
>  1 file changed, 30 insertions(+), 11 deletions(-)

Reviewed-by: Rakesh Pillai <pillair@codeaurora.org>

Thanks,
Rakesh Pillai.


