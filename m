Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9032C38E6
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 07:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgKYF7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 00:59:18 -0500
Received: from z5.mailgun.us ([104.130.96.5]:39694 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgKYF7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 00:59:18 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606283957; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=fH6XRHzas3OBVohyMiwnIkDxrr1F8paJHfjb0IVmSv8=; b=mFZwwVbaAy+9yqmuUBLv7sM9XTJ2Ud90ihtIzTz/BFfGslQXyXKtMJ90zzadzMjdi8abd6Te
 k6vq4ud4w6hwcaIEB+kBLG5h1EFtQBmdrWsdsoBnA8VCgjlXsLVAOR28C4O7EbJfITubJ0ZY
 vfiiK7wnVUfOG5dBefk3wXbLtLE=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5fbdf2b5fa67d9becf8d9978 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 25 Nov 2020 05:59:17
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5EE1AC43461; Wed, 25 Nov 2020 05:59:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B8E09C433C6;
        Wed, 25 Nov 2020 05:59:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B8E09C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Alex Elder <elder@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2] soc: qcom: ipa: Constify static qmi structs
References: <20201122234031.33432-1-rikard.falkeborn@gmail.com>
        <20201122234031.33432-2-rikard.falkeborn@gmail.com>
        <20201124144721.3e80698c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 25 Nov 2020 07:59:11 +0200
In-Reply-To: <20201124144721.3e80698c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Tue, 24 Nov 2020 14:47:21 -0800")
Message-ID: <87h7pe9du8.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 23 Nov 2020 00:40:30 +0100 Rikard Falkeborn wrote:
>> These are only used as input arguments to qmi_handle_init() which
>> accepts const pointers to both qmi_ops and qmi_msg_handler. Make them
>> const to allow the compiler to put them in read-only memory.
>> 
>> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
>
> I can take this one if Alex acks it.
>
> The other patch is probably best handled by Kalle.

Yes, patch 2 is in my queue.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
