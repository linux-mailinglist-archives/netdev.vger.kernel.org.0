Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15792DCC8B
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 07:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgLQGkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 01:40:05 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:45615 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgLQGkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 01:40:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608187179; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=v9dVYGbG3Dl98V1iYFZEWhPG3mgZAntKN97hbxxOUWg=; b=kklyxvd2G5wrZbCsnY4j/9mBjAwb75BtCL6rNBZLEnGhkbNtjCNfqiuN+jrnI8HCnXeNmoJH
 YnD1KNmIgLcfBLrOyckU9Y5GokbygMUtloV+m8f5fHtLmD3p4ncwbfpdB1ITxKkf0dZpxXjW
 ri70tJOQdeUtq4o3j3f0dxc4inY=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5fdafd093d3433393d37f0c6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 17 Dec 2020 06:39:05
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2DB93C43463; Thu, 17 Dec 2020 06:39:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 262F3C433CA;
        Thu, 17 Dec 2020 06:39:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 262F3C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Colin King <colin.king@canonical.com>
Cc:     kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        Carl Huang <cjhuang@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH][next] ath11k: add missing null check on allocated skb
References: <20201214232417.84556-1-colin.king@canonical.com>
        <20201217063600.E5DB2C43461@smtp.codeaurora.org>
Date:   Thu, 17 Dec 2020 08:39:00 +0200
In-Reply-To: <20201217063600.E5DB2C43461@smtp.codeaurora.org> (Kalle Valo's
        message of "Thu, 17 Dec 2020 06:36:00 +0000 (UTC)")
Message-ID: <87ft45uebf.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Colin King <colin.king@canonical.com> wrote:
>
>> Currently the null check on a newly allocated skb is missing and
>> this can lead to a null pointer dereference is the allocation fails.
>> Fix this by adding a null check and returning -ENOMEM.
>> 
>> Addresses-Coverity: ("Dereference null return")
>> Fixes: 43ed15e1ee01 ("ath11k: put hw to DBS using WMI_PDEV_SET_HW_MODE_CMDID")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>
> Patch applied to ath-current branch of ath.git, thanks.
>
> c86a36a621f2 ath11k: add missing null check on allocated skb

I did a mistake and that commit id will change, so please disregard
this. There will be a new mail soon.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
