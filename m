Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC65F27BCF6
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 08:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgI2GTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 02:19:04 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:20739 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgI2GTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 02:19:03 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601360342; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=3ZmhyJ+bnkMgvll9uWcnOHqot4LSzTj4yI0xK/E1JGk=; b=rIxRJabKNcyDN1CzUFWBdUKqsvlir8p4X5615rUqydRUTB/wNPIPaYiIQAojNDa2J269qdyL
 FjELSuav1oeilFMQxfZwh838v+kn+DORa8fs4Ulbs0jFgkeKF/iUUo+n9hBff83A9USTiBl9
 Yalltj3JKqM1Do4xEjVDsCi4uD4=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f72d1be2892e2043e47e447 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 29 Sep 2020 06:18:38
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6CDA9C43385; Tue, 29 Sep 2020 06:18:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 67515C433C8;
        Tue, 29 Sep 2020 06:18:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 67515C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Loic Poulain <loic.poulain@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Govind Singh <govinds@codeaurora.org>,
        ath11k@lists.infradead.org
Subject: Re: linux-next: build failure after merge of the mhi tree
References: <20200928184230.2d973291@canb.auug.org.au>
        <20200928091035.GA11515@linux> <87eemmfdn3.fsf@codeaurora.org>
        <20200928094704.GB11515@linux> <87a6x9g89a.fsf@codeaurora.org>
        <20200928170403.GA2222@Mani-XPS-13-9360>
Date:   Tue, 29 Sep 2020 09:18:30 +0300
In-Reply-To: <20200928170403.GA2222@Mani-XPS-13-9360> (Manivannan Sadhasivam's
        message of "Mon, 28 Sep 2020 22:34:04 +0530")
Message-ID: <875z7xf6mh.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:

>> I was looking at commit ed39d7816885 ("bus: mhi: Remove auto-start
>> option") and noticed this in the commit log:
>> 
>>     This is really up to the MHI device(channel) driver to manage the state
>>     of its channels.
>> 
>> So does this mean we have to make changes in ath11k to accomodate this?
>
> Nope. The change is needed in the MHI client driver like qrtr which is already
> taken care: https://lkml.org/lkml/2020/9/28/30

Ok, that's good.

> Will make sure to include ath11k list for any future API changes.

Thanks!

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
