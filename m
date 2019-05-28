Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9912CB3B
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfE1QLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:11:05 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46975 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfE1QLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:11:05 -0400
Received: by mail-ed1-f65.google.com with SMTP id f37so32500416edb.13
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 09:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version:content-transfer-encoding;
        bh=5NKCxpzbXsbsdqOSjRjf5/FGHtpKxTTM//85T6IDabE=;
        b=cLpFVXoOfaeKqTCGXaNtMKnxeMWVwEjeFGu03K3vyZC6eBv0PiWQv6yuwybs3T2QSE
         Abu1D0JQfhjjZTh1U/U+E+6dBESTJ+sDP24AwcxnZnZW6Wdhzzspgr7zVgt+ePfOJRYf
         kVHnHSVp6kD9vLVC2eOZMhKim+NPnN2ssaoZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version
         :content-transfer-encoding;
        bh=5NKCxpzbXsbsdqOSjRjf5/FGHtpKxTTM//85T6IDabE=;
        b=E6kRuJYTVD0DbYYSsHa0JaH4uVeu4UcrlIasZlzuFTdFv2THrKL3HC1GWxpBGqCKUC
         U32DD/GBkx7Hnpp+S89qcXYc6D9f/kWuLJnMQhYFXJv+OQCaimXA/eqAd1XUDSOmPjEs
         zrQfDptbVNOFKzXGd6bC9+ipbCpTSWEvkTK8A3Ifu2nIDqXMVSPKnBaSP3OU008/pJAT
         3D783Xvd6teBjEw88VirL2JkyDIR+27hBpdiU0tA9fpZsljepPYAQFtqfUP/EfHNN/r2
         WErXkQ6TWQLMjARLbe4XC/Mm4Y8iH3oRanRweqCH2HaK2t081K8MxBnmtQni35VqjH+0
         Dtdw==
X-Gm-Message-State: APjAAAUX+XNAjwonQ5Ys7ur9ezlGrfPStYaw13mY57uDhxbIwz6RE7aV
        fhtrMD3LnVHmpVOQ/+4Wj+mxpw==
X-Google-Smtp-Source: APXvYqzO78eTgJM+fsJJF5GBrbnmxF7cyzHQDEkxqk1bfWfaLwgdTR6aYkCkV+M7paGXI74GmgyYWA==
X-Received: by 2002:a17:906:ccd8:: with SMTP id ot24mr38325047ejb.263.1559059863761;
        Tue, 28 May 2019 09:11:03 -0700 (PDT)
Received: from [192.168.178.17] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id m16sm2268549ejj.57.2019.05.28.09.11.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 May 2019 09:11:03 -0700 (PDT)
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
Date:   Tue, 28 May 2019 18:11:00 +0200
Message-ID: <16aff358a20.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <16aff33f3e0.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
References: <20190517225420.176893-2-dianders@chromium.org>
 <20190528121833.7D3A460A00@smtp.codeaurora.org>
 <CAD=FV=VtxdEeFQsdF=U7-_7R+TXfVmA2_JMB_-WYidGHTLDgLw@mail.gmail.com>
 <16aff33f3e0.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
User-Agent: AquaMail/1.20.0-1451 (build: 102000001)
Subject: Re: [PATCH 1/3] brcmfmac: re-enable command decode in sdio_aos for BRCM 4354
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On May 28, 2019 6:09:21 PM Arend Van Spriel <arend.vanspriel@broadcom.com> 
wrote:

> On May 28, 2019 5:52:10 PM Doug Anderson <dianders@chromium.org> wrote:
>
>> Hi,
>>
>> On Tue, May 28, 2019 at 5:18 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>>>
>>> Douglas Anderson <dianders@chromium.org> wrote:
>>>
>>> > In commit 29f6589140a1 ("brcmfmac: disable command decode in
>>> > sdio_aos") we disabled something called "command decode in sdio_aos"
>>> > for a whole bunch of Broadcom SDIO WiFi parts.
>>> >
>>> > After that patch landed I find that my kernel log on
>>> > rk3288-veyron-minnie and rk3288-veyron-speedy is filled with:
>>> >   brcmfmac: brcmf_sdio_bus_sleep: error while changing bus sleep state -110
>>> >
>>> > This seems to happen every time the Broadcom WiFi transitions out of
>>> > sleep mode.  Reverting the part of the commit that affects the WiFi on
>>> > my boards fixes the problem for me, so that's what this patch does.
>>> >
>>> > Note that, in general, the justification in the original commit seemed
>>> > a little weak.  It looked like someone was testing on a SD card
>>> > controller that would sometimes die if there were CRC errors on the
>>> > bus.  This used to happen back in early days of dw_mmc (the controller
>>> > on my boards), but we fixed it.  Disabling a feature on all boards
>>> > just because one SD card controller is broken seems bad.  ...so
>>> > instead of just this patch possibly the right thing to do is to fully
>>> > revert the original commit.
>>> >
>>> > Fixes: 29f6589140a1 ("brcmfmac: disable command decode in sdio_aos")
>>> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
>>>
>>> I don't see patch 2 in patchwork and I assume discussion continues.
>>
>> Apologies.  I made sure to CC you individually on all the patches but
>> didn't think about the fact that you use patchwork to manage and so
>> didn't ensure all patches made it to all lists (by default each patch
>> gets recipients individually from get_maintainer).  I'll make sure to
>> fix for patch set #2.  If you want to see all the patches, you can at
>> least find them on lore.kernel.org linked from the cover:
>>
>> https://lore.kernel.org/patchwork/cover/1075373/
>>
>>
>>> Please resend if/when I need to apply something.
>>>
>>> 2 patches set to Changes Requested.
>>>
>>> 10948785 [1/3] brcmfmac: re-enable command decode in sdio_aos for BRCM 4354
>>
>> As per Arend I'll change patch #1 to a full revert instead of a
>> partial revert.  Arend: please yell if you want otherwise.
>
> No yelling here. If any it is expected from Cypress. Maybe good to add them
> specifically in Cc:

Of the revert patch that is.

Gr. AvS


