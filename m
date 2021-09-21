Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F56F41335F
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 14:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhIUMcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 08:32:48 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:56605 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232674AbhIUMcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 08:32:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632227479; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=EvHed1ChX9m4yVKaphMHzv0lmYykdQIwXZ2pn9R/wGo=; b=Jbtzzf9szumsBQOeTZmIlLcY5LwH7IRUnmZkbk3hPFIyBCG1+2TtofCumIsVoe97/B+eiSVA
 BJR1+LA5XMdEXguOw8MtNkwfv5tXDN4iAGVSuSajud15TZMccyencJNBrXieXKmsWI9rdksc
 xpnBSbumu0Z1LPA7rimpdCv3dCY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6149d06ce0f78151d660d973 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Sep 2021 12:30:36
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5F690C4360D; Tue, 21 Sep 2021 12:30:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0ED48C4338F;
        Tue, 21 Sep 2021 12:30:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 0ED48C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS \(WIRELESS\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH] [v15] wireless: Initial driver submission for pureLiFi STA devices
References: <20210226130810.119216-1-srini.raju@purelifi.com>
        <20210818141343.7833-1-srini.raju@purelifi.com>
        <87o88nwg74.fsf@codeaurora.org>
        <CWLP265MB3217BB5AA5F102629A3AD204E0A19@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
Date:   Tue, 21 Sep 2021 15:30:31 +0300
In-Reply-To: <CWLP265MB3217BB5AA5F102629A3AD204E0A19@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
        (Srinivasan Raju's message of "Tue, 21 Sep 2021 09:14:46 +0000")
Message-ID: <87ee9iun4o.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> writes:

> Thanks for reviewing the patch.
>
>>> +     hw->wiphy->bands[NL80211_BAND_2GHZ] = &mac->band;
>
>> Johannes comment about piggy-backing NL80211_BAND_2GHZ is not yet addressed:
>
>> I agree with Johannes, a Li-Fi driver should not claim to be a regular
>> 2.4 GHz Wi-Fi device.
>
> Yes, I agree, As LiFi is not standardized yet we are using the
> existing wireless frameworks. For now, piggy backing with 2.4GHz is
> seamless for users. We will undertake band and other wider change once
> IEEE 802.11bb is standardized.

I don't see why the IEEE standard needs to be final before adding the
band. Much better to add a band which is in draft stage compared to
giving false information to the user space.

BTW do not use HTML mail, our lists drop those.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
