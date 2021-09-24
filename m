Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C46416D44
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 10:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244516AbhIXIBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 04:01:42 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:35459 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244433AbhIXIBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 04:01:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632470408; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=TSws/164fiyq3oktWfzcBH/e+yGW2wBhhF/5uUAH+OQ=; b=ohpMaCMT9xB+3PGmbW5nwPG3NB3jnJY57Mpy9E1+1KBCZqafbc8YYANc4MDhE5/r2EFXPjiQ
 4Mas7Wf/MzK8tf8anw9An8oqGond+M3Aj1Dj09Dwj/5U5zxTvqwRmymIa1Lv9ezES2PDZ6G8
 pRsGDOo185miwLA2iFGIjLyH1EY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 614d857b648642cc1c339f72 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 24 Sep 2021 07:59:55
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AC15DC43617; Fri, 24 Sep 2021 07:59:55 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B3E77C4338F;
        Fri, 24 Sep 2021 07:59:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B3E77C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     pillair@codeaurora.org, ath10k@lists.infradead.org,
        govinds@codeaurora.org, kuabhs@chromium.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        youghand@codeaurora.org
Subject: Re: [PATCH] ath10k: Don't always treat modem stop events as crashes
References: <002501d7af73$ae0a7620$0a1f6260$@codeaurora.org>
        <CAE-0n52DcCwcdR07fvMLrj=RJFtNthy0FdWmt1gBWiD9eLrOvQ@mail.gmail.com>
Date:   Fri, 24 Sep 2021 10:59:47 +0300
In-Reply-To: <CAE-0n52DcCwcdR07fvMLrj=RJFtNthy0FdWmt1gBWiD9eLrOvQ@mail.gmail.com>
        (Stephen Boyd's message of "Wed, 22 Sep 2021 15:20:07 -0700")
Message-ID: <87bl4itnd8.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Boyd <swboyd@chromium.org> writes:

> Quoting pillair@codeaurora.org (2021-09-21 22:35:34)
>> On 9/5/21 4:04 PM, Stephen Boyd wrote:
>>
>> > +static int ath10k_snoc_modem_notify(struct notifier_block *nb, unsigned long
> [...]
>>
>> > +
>>
>> > +          return NOTIFY_OK;
>>
>> > +}
>>
>>
>>
>> Thanks for posting the patch. It would be preferable to use a different flag
>> instead of ATH10K_SNOC_FLAG_UNREGISTERING,
>>
>> since we are not unloading the ath10k driver.

Weird, I don't see pillair's email on patchwork[1] and not in the ath10k
list either. Was it sent as HTML or something?

[1] https://patchwork.kernel.org/project/linux-wireless/patch/20210905210400.1157870-1-swboyd@chromium.org/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
