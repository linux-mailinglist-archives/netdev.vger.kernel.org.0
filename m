Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E4F42831
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 15:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409262AbfFLN6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 09:58:09 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41991 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409245AbfFLN6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 09:58:09 -0400
Received: by mail-ed1-f67.google.com with SMTP id z25so25912780edq.9
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 06:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version:content-transfer-encoding;
        bh=Y+4CclOchg68MnXlcf58UCwueBz0Zes4t/blHlilXOM=;
        b=g0wJ6bpZk6ogq2pFPm12oLk0Yrtzf26EwY4s3uS4fyOd6DhxzmisPT5DBzV21l6Erd
         8xZ853XwfPK15Zq64UL6RB8AuP6abPIlPzfZH+D8IuaOfO5wLiRJMFLfbYg0x6wxkchX
         HX/TXdun2GZFn1lb1gKb3lWu60z7OGNBd2wN8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version
         :content-transfer-encoding;
        bh=Y+4CclOchg68MnXlcf58UCwueBz0Zes4t/blHlilXOM=;
        b=KmcDKiC9zbodqHBJlxMuzb3vedCpb0kMf1QQPJXp+KV34nTQ88thwIotZyzQsEb9C3
         vPDwlW6UOLRlFA7ZfiPSfJRs3zZkx/yixt0pL+wBdVUHlZVrE/+0WAAjhpU2kCmPcJVF
         ISBocaTGGAxwDZnxuXOLBhjVe25G0IdKS1kjgIAzmt4G+VFAwz/OS7mym/4r3BsYlP3W
         b0V3BBjhKaNOhNoD6jmsPkwETmBu1k5TuQCS0g9Lg4kEbtJbwLvov5y6uLkE6GfJe3Sk
         Q++iUpO0SWWaSovSMPu6HESreNlRITMs0wDQxiCOYwdgTW56hfg87R/LFhxETycUCV4X
         vCAw==
X-Gm-Message-State: APjAAAWYr3Inr2lELV3jzifyaCq9JX2iDfYNnSm9q9ZE2WxpVCj86TRv
        +5K9sN4OnR01Q3F0yPKPQrUaxA==
X-Google-Smtp-Source: APXvYqx5QFCQSwGLkC7MLW22rxzxN0yYWE/WednBPqVlB7ZnJV0pXPuAI6oipqRdLLV5RQdCZqU/cQ==
X-Received: by 2002:a50:974b:: with SMTP id d11mr51553467edb.24.1560347887655;
        Wed, 12 Jun 2019 06:58:07 -0700 (PDT)
Received: from [192.168.178.17] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id h5sm4614214ede.74.2019.06.12.06.58.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 06:58:06 -0700 (PDT)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
CC:     Doug Anderson <dianders@chromium.org>,
        "Hunter, Adrian" <adrian.hunter@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <linux-rockchip@lists.infradead.org>,
        Double Lo <double.lo@cypress.com>, <briannorris@chromium.org>,
        <linux-wireless@vger.kernel.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        <mka@chromium.org>, Wright Feng <wright.feng@cypress.com>,
        "Chi-Hsien Lin" <chi-hsien.lin@cypress.com>,
        <netdev@vger.kernel.org>, <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        <linux-kernel@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 12 Jun 2019 15:58:05 +0200
Message-ID: <16b4bfb39e0.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <CAPDyKFpM0+FfvoMo8Z_hxM9rzSjeQZHCsA2SPa8WP+SRDhhsPA@mail.gmail.com>
References: <20190607223716.119277-1-dianders@chromium.org>
 <20190607223716.119277-4-dianders@chromium.org>
 <363DA0ED52042842948283D2FC38E4649C52F8A0@IRSMSX106.ger.corp.intel.com>
 <CAD=FV=U8eo78Ee9xjhGXJMv=8YF9o89KLX024GH3iBRnRjCRvQ@mail.gmail.com>
 <CAPDyKFo=QMRTkNYUVSE2AqiZgytkTVRXF0Mvznn6trVT4-cR=Q@mail.gmail.com>
 <c7c6d3f4-ebb1-8964-0616-973fae1ab47d@broadcom.com>
 <CAPDyKFpM0+FfvoMo8Z_hxM9rzSjeQZHCsA2SPa8WP+SRDhhsPA@mail.gmail.com>
User-Agent: AquaMail/1.20.0-1458 (build: 102100001)
Subject: Re: [PATCH v3 3/5] brcmfmac: sdio: Disable auto-tuning around commands expected to fail
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/12/2019 1:48 PM, Ulf Hansson wrote:
> On Wed, 12 Jun 2019 at 13:11, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>>
>> On 6/12/2019 12:10 PM, Ulf Hansson wrote:
>>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c:
>>>>     mmc_set_data_timeout(md, func->card);
>>>>     mmc_wait_for_req(func->card->host, mr);
>>> These are not okay, none of these things calls should really be done
>>> from an SDIO func driver.
>>>
>>> It tells me that the func driver is a doing workaround for something
>>> that should be managed in a common way.
>>
>> We are using some low-level functions passing chain of skbuff to the
>> device using CMD53 with scatterlist. If I recall correctly Marvell made
>> an attempt to have a similar function for it in the mmc stack. Not sure
>> if that ever made it in. If so I can rework our driver using that API.
>> If not, I can make a new attempt.
> 
> I recall there were some patches, but not sure why we didn't merge them.
> 
> Anyway, if you want to move this forward, that would be awesome!

Let's scope it before moving forward. Our use-case is to transfer a
chain of skbuff's. I am pretty sure that is not something we want to
deal with in mmc stack api. So I suppose passing a scatterlist is more
sensible, right? Maybe on sdio layer of the stack we could consider
dealing with skbuff's for network func drivers?

Let me see if I can find those Marvell patches. Might be a good start.

Regards,
Arend


