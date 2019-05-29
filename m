Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC352E02A
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfE2Ov4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:51:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46762 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfE2Ov4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 10:51:56 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CDDBC60A63; Wed, 29 May 2019 14:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559141514;
        bh=wB2s6eG/yS7NJpG9iQQVkTE5phJzfMsxILOMCQ9VtJk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PRu92ve5m+yFMyE9ZOAdUy7oR9ClsAMW+nPqlk0MeENffS9VWqE4AG9Bk2Fl2uVTe
         wsdxUerQ3mWSqESfJ09yzyx0wUvIqu/SucsItWJYlTRAMxSnXU3LFte+BPXUxihO8x
         3CCwJ/JB9AKhd+x6pYKiS0YfM3vEae3r2NClMWoM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3C6DE60741;
        Wed, 29 May 2019 14:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559141513;
        bh=wB2s6eG/yS7NJpG9iQQVkTE5phJzfMsxILOMCQ9VtJk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PUY+3yOpoSS6ECOQcR7KVN3EseXspgVDwsrgZ2LmWoKOYCAxv9uR0r7CR5blyzPFa
         63L6qrquF0de4y/HH33Ihl1Y7nVLLuOoUVQIE6BXGxLh52uP0dToSPOekIusE1vIQI
         D9zR5uLY8FF9zhHUEcF1rgdALzzb2MFTlRHnWWd0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3C6DE60741
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "open list\:ARM\/Rockchip SoC..." 
        <linux-rockchip@lists.infradead.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        Matthias Kaehlcke <mka@chromium.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list@cypress.com, Double Lo <double.lo@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>
Subject: Re: [PATCH 1/3] brcmfmac: re-enable command decode in sdio_aos for BRCM 4354
References: <20190517225420.176893-2-dianders@chromium.org>
        <20190528121833.7D3A460A00@smtp.codeaurora.org>
        <CAD=FV=VtxdEeFQsdF=U7-_7R+TXfVmA2_JMB_-WYidGHTLDgLw@mail.gmail.com>
Date:   Wed, 29 May 2019 17:51:47 +0300
In-Reply-To: <CAD=FV=VtxdEeFQsdF=U7-_7R+TXfVmA2_JMB_-WYidGHTLDgLw@mail.gmail.com>
        (Doug Anderson's message of "Tue, 28 May 2019 08:51:53 -0700")
Message-ID: <87h89d2u0s.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

> Hi,
>
> On Tue, May 28, 2019 at 5:18 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Douglas Anderson <dianders@chromium.org> wrote:
>>
>> > In commit 29f6589140a1 ("brcmfmac: disable command decode in
>> > sdio_aos") we disabled something called "command decode in sdio_aos"
>> > for a whole bunch of Broadcom SDIO WiFi parts.
>> >
>> > After that patch landed I find that my kernel log on
>> > rk3288-veyron-minnie and rk3288-veyron-speedy is filled with:
>> >   brcmfmac: brcmf_sdio_bus_sleep: error while changing bus sleep state -110
>> >
>> > This seems to happen every time the Broadcom WiFi transitions out of
>> > sleep mode.  Reverting the part of the commit that affects the WiFi on
>> > my boards fixes the problem for me, so that's what this patch does.
>> >
>> > Note that, in general, the justification in the original commit seemed
>> > a little weak.  It looked like someone was testing on a SD card
>> > controller that would sometimes die if there were CRC errors on the
>> > bus.  This used to happen back in early days of dw_mmc (the controller
>> > on my boards), but we fixed it.  Disabling a feature on all boards
>> > just because one SD card controller is broken seems bad.  ...so
>> > instead of just this patch possibly the right thing to do is to fully
>> > revert the original commit.
>> >
>> > Fixes: 29f6589140a1 ("brcmfmac: disable command decode in sdio_aos")
>> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
>>
>> I don't see patch 2 in patchwork and I assume discussion continues.
>
> Apologies.  I made sure to CC you individually on all the patches but
> didn't think about the fact that you use patchwork to manage and so
> didn't ensure all patches made it to all lists (by default each patch
> gets recipients individually from get_maintainer).  I'll make sure to
> fix for patch set #2.  If you want to see all the patches, you can at
> least find them on lore.kernel.org linked from the cover:
>
> https://lore.kernel.org/patchwork/cover/1075373/

No worries, I had the thread on my email but was just too busy to check.
So I instead wrote down my thought process so that somebode can correct
me in case I have misunderstood. I usually do that when it's not clear
what the next action should be.

-- 
Kalle Valo
