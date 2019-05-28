Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33BCC2CB25
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfE1QJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:09:23 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35722 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbfE1QJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:09:23 -0400
Received: by mail-ed1-f67.google.com with SMTP id p26so32571576edr.2
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 09:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version:content-transfer-encoding;
        bh=vRk13UBuyghmarVtMoNipwKyhaNgI5UNFGabtsK6EmA=;
        b=Yj+KkVBDDnZ/8AIrhCHLvON4pXXCjGtHPQEEoz8vJKL4kIw6tZM7+98BwwKEPq9FXc
         etAAdMu8UNml1JLKYqAsmy5Nos+w6uoFPRMqYeXDGpAPKgYVsKUSwKcjt+G7pfRPnZDa
         6FHHHI+ccxt0J39FNntur+/ef6vR55E+EF5d8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version
         :content-transfer-encoding;
        bh=vRk13UBuyghmarVtMoNipwKyhaNgI5UNFGabtsK6EmA=;
        b=msBZsmldttLPpIBDHzuByBH9bFLR0NS3MHqZEBv9v8FanJXH6Ay5FSsySKP/iRyBr2
         Q+71eDmP28MR1hscKESdfTx2BQTewCXoYfvoV2c7iXtMxAKRabvvx1D+2m+KEGTNOvDV
         I4QgTEe/1VTgBQP4Hmc7sAt7axesQZNxo3pORDYNi0VJZ62Rw0BkIch4UgtKslGWAT47
         xpAKuTQKBnPmi4H8fr96BQDAZD5Gv1BS1gxZTfu3DS8pEcqEyxm+PMptTfltnK9uF9sN
         3TtUwJ9dnfiVP3lS1hV/n5cfHua2IisPVxwKFqpubcdV3gOTHFw99cgAbo2sMm2thsPL
         nZpw==
X-Gm-Message-State: APjAAAWiBFbCi0mtzR8zHKDs25me7+QjKOHiSC52m1Hc4GrbrRzcKqTO
        yJ7sS9b1BqkoH0LR8dzbV4F2TA==
X-Google-Smtp-Source: APXvYqwe2ChVgm/bVKPGBtODYBSt/7WwWY5djEtxSUGcNmr9IvNbLckoqL7DhwjmZsR7FQA8nMCQBw==
X-Received: by 2002:aa7:cccc:: with SMTP id y12mr2546618edt.124.1559059761737;
        Tue, 28 May 2019 09:09:21 -0700 (PDT)
Received: from [192.168.178.17] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id u47sm4347734edm.86.2019.05.28.09.09.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 May 2019 09:09:21 -0700 (PDT)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Doug Anderson <dianders@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "Chi-Hsien Lin" <chi-hsien.lin@cypress.com>,
        Brian Norris <briannorris@chromium.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        <brcm80211-dev-list@cypress.com>,
        Double Lo <double.lo@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>
Date:   Tue, 28 May 2019 18:09:16 +0200
Message-ID: <16aff33f3e0.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <CAD=FV=VtxdEeFQsdF=U7-_7R+TXfVmA2_JMB_-WYidGHTLDgLw@mail.gmail.com>
References: <20190517225420.176893-2-dianders@chromium.org>
 <20190528121833.7D3A460A00@smtp.codeaurora.org>
 <CAD=FV=VtxdEeFQsdF=U7-_7R+TXfVmA2_JMB_-WYidGHTLDgLw@mail.gmail.com>
User-Agent: AquaMail/1.20.0-1451 (build: 102000001)
Subject: Re: [PATCH 1/3] brcmfmac: re-enable command decode in sdio_aos for BRCM 4354
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On May 28, 2019 5:52:10 PM Doug Anderson <dianders@chromium.org> wrote:

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
>
>
>> Please resend if/when I need to apply something.
>>
>> 2 patches set to Changes Requested.
>>
>> 10948785 [1/3] brcmfmac: re-enable command decode in sdio_aos for BRCM 4354
>
> As per Arend I'll change patch #1 to a full revert instead of a
> partial revert.  Arend: please yell if you want otherwise.

No yelling here. If any it is expected from Cypress. Maybe good to add them 
specifically in Cc:

Regards,
Arend


