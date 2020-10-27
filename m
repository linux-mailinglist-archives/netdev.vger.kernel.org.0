Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC4629A480
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 07:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506353AbgJ0GPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 02:15:51 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:21832 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506335AbgJ0GPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 02:15:43 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603779342; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=trsiEXZJk2vC/ZEaP8BBvrYNABoGfpAwdcCpaKv/QVI=; b=xKDZL1lGnZ0NSSVAgYmM9XtvjlrQn6+Xoll4Tu8uBRM1hYUyr2ehr8MiQw1DRKK/3IkOls9E
 X+K4bXdnwSBCLkGrWreKwZ6R/G2vKG2B5hBy7lG7/IVFSiQEgSKWqCWHkSa6LIEbBFSihtkc
 devKinP4tWEAcGP0NjPXYKIY4cw=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5f97bb0d3ecd8ffc943b6b1b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 27 Oct 2020 06:15:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 810EAC43387; Tue, 27 Oct 2020 06:15:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5A859C433F0;
        Tue, 27 Oct 2020 06:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5A859C433F0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Raja Mani <rmani@qca.qualcomm.com>,
        Suraj Sumangala <surajs@qca.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Vivek Natarajan <nataraja@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 09/11] ath6kl: fix enum-conversion warning
References: <20201026213040.3889546-1-arnd@kernel.org>
        <20201026213040.3889546-9-arnd@kernel.org>
Date:   Tue, 27 Oct 2020 08:15:33 +0200
In-Reply-To: <20201026213040.3889546-9-arnd@kernel.org> (Arnd Bergmann's
        message of "Mon, 26 Oct 2020 22:29:56 +0100")
Message-ID: <873620p52y.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> gcc -Wextra points out a type mismatch
>
> drivers/net/wireless/ath/ath6kl/wmi.c: In function 'ath6kl_wmi_cmd_send':
> drivers/net/wireless/ath/ath6kl/wmi.c:1825:19: warning: implicit conversion from 'enum <anonymous>' to 'enum wmi_data_hdr_data_type' [-Wenum-conversion]
>  1825 |            false, false, 0, NULL, if_idx);
>       |                   ^~~~~
>
> As far as I can tell, the numeric value is current here,
> so just use the correct enum literal instead of 'false'.
>
> Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks good to me. I'll take this to my ath.git tree.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
