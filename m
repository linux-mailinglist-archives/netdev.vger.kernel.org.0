Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A17A2F44AD
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 07:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbhAMGvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 01:51:12 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:15631 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbhAMGvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 01:51:11 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610520648; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=LEaPdDLevh2p3sskm5HfcmgXr0Bdw4YtFZo1OimLfYE=; b=px64J8IGwuz1IGtXJk7QO2uyGYzHUqUIV531dr003+knAE8Dio3Tx6jZbp3CL2o0iUI+WneX
 urMMXyvsWK/DWcCvZ1yk7Ksr262tdlM6kARB9rRXmQGYLGrnAfs9JCdqS9x0bsNh6MCOctGD
 vcVv+NTTdc1QkQ+Jx4Meu+iwVls=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5ffe98212a47972bcc779b74 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 13 Jan 2021 06:50:09
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D36FCC43461; Wed, 13 Jan 2021 06:50:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C538DC433C6;
        Wed, 13 Jan 2021 06:50:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C538DC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Coelho\, Luciano" <luciano.coelho@intel.com>
Cc:     "tiwai\@suse.de" <tiwai@suse.de>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] iwlwifi: dbg: Mark ucode tlv data as const
References: <20210112132449.22243-1-tiwai@suse.de>
        <20210112132449.22243-3-tiwai@suse.de> <87pn2arw69.fsf@codeaurora.org>
        <s5h4kjmqgxw.wl-tiwai@suse.de>
        <636fdc5b53b6f4855e25981e0454064524e6905d.camel@intel.com>
Date:   Wed, 13 Jan 2021 08:50:04 +0200
In-Reply-To: <636fdc5b53b6f4855e25981e0454064524e6905d.camel@intel.com>
        (Luciano Coelho's message of "Tue, 12 Jan 2021 17:13:59 +0000")
Message-ID: <87lfcxs543.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Coelho, Luciano" <luciano.coelho@intel.com> writes:

> On Tue, 2021-01-12 at 17:05 +0100, Takashi Iwai wrote:
>> On Tue, 12 Jan 2021 16:50:54 +0100,
>> Kalle Valo wrote:
>> > 
>> > Takashi Iwai <tiwai@suse.de> writes:
>> > 
>> > > The ucode TLV data may be read-only and should be treated as const
>> > > pointers, but currently a few code forcibly cast to the writable
>> > > pointer unnecessarily.  This gave developers a wrong impression as if
>> > > it can be modified, resulting in crashing regressions already a couple
>> > > of times.
>> > > 
>> > > This patch adds the const prefix to those cast pointers, so that such
>> > > attempt can be caught more easily in future.
>> > > 
>> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> > 
>> > So this need to go to -next, right?
>> 
>> Yes, this isn't urgently needed for 5.11.
>
> Acked-by: Luca Coelho <luciano.coelho@intel.com>
>
>
>> > Does this depend on patch 1 or can
>> > this be applied independently?
>> 
>> It depends on the first patch, otherwise you'll get the warning in the
>> code changing the const data (it must warn -- that's the purpose of
>> this change :)
>> 
>> So, if applying to a separate branch is difficult, applying together
>> for 5.11 would be an option.
>
> It doesn't matter to me how you apply it.  Applying together is
> obviously going to be easier, but applying separately wouldn't be that
> hard either.  You'd just have to track when 1/2 went into net-next
> before applying this one.  Kalle's call.

Ok, I'll apply this to wireless-drivers-next after wireless-drivers is
merged to -next. It might take a while.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
