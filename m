Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2421F3F3AC9
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 15:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbhHUNff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 09:35:35 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:48871 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbhHUNfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 09:35:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629552890; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=95lCQMtRZ3oSzWOdDjJ1909AnLQq/yrMzjCJjr9CGRU=; b=pGGJIme4z/9C8auD/1I4CvCrYnXIhqJSdRjXy1ia8hrq6X68dfyWgstuSBUBjU748DwWlsDL
 Ko9zPC6DfhhBUILBNDQFF+CDfmomIMeWn4Xqkc1x88g6WvtE1/BaZe48vXfocIamtTHMUDCl
 PU3YxRencY9NhymA9S17LrhqzOc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 612100e70f9b337f11ccf688 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Aug 2021 13:34:31
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E4E9AC43617; Sat, 21 Aug 2021 13:34:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7EEBBC4338F;
        Sat, 21 Aug 2021 13:34:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 7EEBBC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jaehoon Chung <jh80.chung@samsung.com>
Cc:     Justin Forbes <jmforbes@linuxtx.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        ybaruch <yaara.baruch@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org,
        "open list\:BPF \(Safe dynamic programs and tools\)" 
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        yj99.shin@samsung.com
Subject: Re: [PATCH] iwlwifi Add support for ax201 in Samsung Galaxy Book Flex2 Alpha
References: <20210702223155.1981510-1-jforbes@fedoraproject.org>
        <CGME20210709173244epcas1p3ea6488202595e182d45f59fcba695e0a@epcas1p3.samsung.com>
        <CAFxkdApGUeGdg4=rH=iC2SK58FO6yzbFiq3uSFMFTyZsDQ5j5w@mail.gmail.com>
        <8c55c7c9-a5ae-3b0e-8a0f-8954a8da7e7b@samsung.com>
        <94edb3c4-43a6-1031-8431-2befb0eca2bf@samsung.com>
Date:   Sat, 21 Aug 2021 16:34:23 +0300
In-Reply-To: <94edb3c4-43a6-1031-8431-2befb0eca2bf@samsung.com> (Jaehoon
        Chung's message of "Fri, 13 Aug 2021 07:26:06 +0900")
Message-ID: <87ilzyudk0.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jaehoon Chung <jh80.chung@samsung.com> writes:

> Hi
>
> On 8/9/21 8:09 AM, Jaehoon Chung wrote:
>> Hi
>> 
>> On 7/10/21 2:32 AM, Justin Forbes wrote:
>>> On Fri, Jul 2, 2021 at 5:32 PM Justin M. Forbes
>>> <jforbes@fedoraproject.org> wrote:
>>>>
>>>> The Samsung Galaxy Book Flex2 Alpha uses an ax201 with the ID a0f0/6074.
>>>> This works fine with the existing driver once it knows to claim it.
>>>> Simple patch to add the device.
>>>>
>>>> Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
>
> If this patch is merged, can this patch be also applied on stable tree?

Luca, what should we do with this patch?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
