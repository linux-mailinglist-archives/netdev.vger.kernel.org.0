Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3C52AB6BF
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 12:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgKILZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 06:25:56 -0500
Received: from z5.mailgun.us ([104.130.96.5]:15039 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgKILZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 06:25:56 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604921155; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=LXllegkU9Hqrn8ABy4ZLKOXWg3z4jJFDK0NqabfEc9c=; b=nhaLo8Ony/WzbycffTPQu+ZvC6HYIaFYLtGDgnFZvRSYLxInVJziZvK89V1vjggJgqfM8MSf
 snDS9lW/1fZRMQBm8sqsJen+rn6e3uUtUN32DXBo+b4NJ3gKlYrCOLUsa5jfY/AQ3cXBcY/c
 qZtbnibyPyJIdC0EcCGwDfKhCzU=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5fa92743c1b74298b7447133 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 09 Nov 2020 11:25:55
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8314EC433FF; Mon,  9 Nov 2020 11:25:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8792BC433C8;
        Mon,  9 Nov 2020 11:25:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8792BC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org, linux-hams@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next 00/28] ndo_ioctl rework
References: <20201106221743.3271965-1-arnd@kernel.org>
        <20201107160612.2909063a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87tuu05c23.fsf@tynnyri.adurom.net>
        <CAK8P3a3y5WxsibmTzvhv76G+rQ1Zjo_tW0UkXku0VnZdQa-__A@mail.gmail.com>
Date:   Mon, 09 Nov 2020 13:25:48 +0200
In-Reply-To: <CAK8P3a3y5WxsibmTzvhv76G+rQ1Zjo_tW0UkXku0VnZdQa-__A@mail.gmail.com>
        (Arnd Bergmann's message of "Sun, 8 Nov 2020 12:42:49 +0100")
Message-ID: <87imaeg4ar.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> On Sun, Nov 8, 2020 at 12:21 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>>
>> So I don't know what to do. Should we try adding a warning like below? :)
>>
>>   "This ancient driver will be removed from the kernel in 2022, but if
>>    it still works send report to <...@...> to avoid the removal."
>>
>> How do other subsystems handle ancient drivers?
>
> A good way to get everyone's attention would be to collect as many
> drivers as possible that are almost certainly unused and move them to
> drivers/staging/ with a warning like the above, as I just did for
> drivers/wimax. That would make it to the usual news outlets
> and lead to the remaining users (if any) noticing it so they can then
> ask for the drivers to be moved back -- or decide it's time to let go
> if the hardware can easily be replaced.

I like that. I think we first should make a list of drivers which we
suspect are either unused or not working anymore.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
