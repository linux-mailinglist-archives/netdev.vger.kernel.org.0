Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9610747DF22
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 07:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346649AbhLWGli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 01:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbhLWGlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 01:41:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66F9C061401;
        Wed, 22 Dec 2021 22:41:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A64A261DDF;
        Thu, 23 Dec 2021 06:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1E7C36AE5;
        Thu, 23 Dec 2021 06:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640241696;
        bh=3pHRiHTLFloKW3FWxmNCBEl0jnX9gsNiH0b3CVJmuMM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YTB8gLXS7QmvKsOO/qXPp4xLAOAo3fmKkGg1gsdru+gMo1y/4y3tlGs5p1ifo0s3+
         LVpuDsrtiXKL5BBHcFCGferJ74jKaTpVH21Kmu8OlJHQC3EUdu8fu/8TrPNfKv+dmO
         nRDUvMwkUsRavXtzBBtqyrfIO4j4DmTbXz02VYvNBouOdKSo0BuIigeYZETcuMYS45
         srnlaFEKwqQxlajnGaOzh0RTwkOlTQSkdow55MShmQJN3HZAadp04xine4nihuOI44
         3uIx2p9jyHw0aRYHGr0n/ayobwiPu6RCzq4l9ttJb5MRZ9BZ3lRLMBoG06MDOay74k
         K10VF2NNnPvhA==
From:   Kalle Valo <kvalo@kernel.org>
To:     <Ajay.Kathat@microchip.com>
Cc:     <davidm@egauge.net>, <Claudiu.Beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/50] wilc1000: rework tx path to use sk_buffs throughout
References: <20211223011358.4031459-1-davidm@egauge.net>
        <adce9591-0cf2-f771-25b9-2eebea05f1bc@microchip.com>
Date:   Thu, 23 Dec 2021 08:41:30 +0200
In-Reply-To: <adce9591-0cf2-f771-25b9-2eebea05f1bc@microchip.com> (Ajay
        Kathat's message of "Thu, 23 Dec 2021 06:16:17 +0000")
Message-ID: <87a6grx1ph.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<Ajay.Kathat@microchip.com> writes:

> On 23/12/21 06:44, David Mosberger-Tang wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>> know the content is safe
>>
>> OK, so I'm nervous about such a large patch series, but it took a lot
>> of work to break things down into atomic changes.  This should be it
>> for the transmit path as far as I'm concerned.
>
>
> Thanks David for the efforts to break down the changes. I am still 
> reviewing and testing the previous series and found some inconsistent 
> results. I am not sure about the cause of the difference. For some 
> tests, the throughput is improved(~1Mbps) but for some CI tests, the 
> throughput is less compared(~1Mbps in same range) to the previous. 
> Though not observed much difference.
>
> Now the new patches are added to the same series so it is difficult to 
> review them in one go.
>
> I have a request, incase there are new patches please include them in 
> separate series. Breaking down the patch helps to identify the non 
> related changes which can go in separate series. The patches(change) may 
> be related to TX path flow but can go in separate series.

Yeah, a thumb of rule is to have around 10-12 patches per patchset. Then
it's still pretty easy to review them and get them accepted. Of course
it's not a hard rule, for smaller patches (like here) having more than
12 is still doable. An also the opposite, with big patches even 10
patches is too much. But 50 patches is just pure pain for the reviewers :)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
