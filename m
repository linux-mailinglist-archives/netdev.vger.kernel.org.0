Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545A6326C00
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 07:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhB0GlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 01:41:03 -0500
Received: from z11.mailgun.us ([104.130.96.11]:47173 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhB0GlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Feb 2021 01:41:00 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614408035; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=8AdlFgeUHuBNLMUzlvExMrmuQf9OlMgU52eM3n/J5Ro=; b=B83Mfii9rkPw5fg9c0UHhBVsLZTgcmflmE/NjcDDFHh6BNpbN69Tfwipfy8SoW5jtXW0Uct1
 +ZmpsE8BMhAQhJOGCj+/vee1ubMjdRjZeHr6eh+Ksbnh+CqxwMnCVz8Wa2KsXwcpr66ZGpKC
 D0gUR171zzl6adVuSmuEpNNyIN8=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 6039e9419e950d0db19f1726 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 27 Feb 2021 06:40:01
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 958C4C43461; Sat, 27 Feb 2021 06:40:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 89F59C433C6;
        Sat, 27 Feb 2021 06:39:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 89F59C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Gil Adam <gil.adam@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: mvm: add terminate entry for dmi_system_id tables
References: <20210223140039.1708534-1-weiyongjun1@huawei.com>
        <20210226210640.GA21320@MSI.localdomain>
Date:   Sat, 27 Feb 2021 08:39:54 +0200
In-Reply-To: <20210226210640.GA21320@MSI.localdomain> (Nathan Chancellor's
        message of "Fri, 26 Feb 2021 14:06:40 -0700")
Message-ID: <87h7ly9fph.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nathan Chancellor <nathan@kernel.org> writes:

> On Tue, Feb 23, 2021 at 02:00:39PM +0000, Wei Yongjun wrote:
>> Make sure dmi_system_id tables are NULL terminated.
>> 
>> Fixes: a2ac0f48a07c ("iwlwifi: mvm: implement approved list for the PPAG feature")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>
> We received a report about a crash in iwlwifi when compiled with LTO and
> this fix resolves it.

That information should be added to the commit log.

Luca, should I take this to wireless-drivers?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
