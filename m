Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA47340A1A3
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 01:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244075AbhIMXl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 19:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243370AbhIMXlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 19:41:16 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAF7C061764
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 16:39:58 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id h133so16386887oib.7
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 16:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ihysQIdGR8w+AiS+ReWp8DK2aVapwmF1UvOCNcDhHKc=;
        b=IRIIEViIbrzd5kpmoPo6R+Oy3FbupEZKJ6mcTM8r782MvEpzOb2C7MJtR4EBx3lXie
         CHl/9FYY3aeP6vQqOWBveC/ddBGSnwPWxnSDNX+l8j/LyDSs0YyJA0V5kzPVq7OqGLUj
         AEtm0/7Jp51ctNjxsGlrTzmlPOU5/8x2CSs0IpWDN90SvGP5TfTkt/g/hzR+tufLr6UW
         yuDGmsKRIR8E1QzgPqi5oDRRANvSTE9+mxDwDs94C0lx6P9LsTFRwoTL9CrjQGlmDaN4
         HDVImDXi1v0SNfnC3VTDuj2dkOAwgst8eQllcU1qKkyr+yCz3r7Jo2YSvd1sJU/nVriu
         D+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ihysQIdGR8w+AiS+ReWp8DK2aVapwmF1UvOCNcDhHKc=;
        b=Nhv2NTCyKroLzOzq1+3gDMJyz28BIE7mGQXQoIZCzEQuVJCnwetzDTOMPDbRwVghQq
         V366dJyE3hNmvsgfh1jW9olpnm8RVn47Ti2M4ibESi7+MI6CaO3tWlCAzOcpstZ03Zyw
         GqaOIRI8OO3jmvT2pRvwr3tDcawj61Fm9qzZrG/ZiTh/eknJzFODzTJre7a1I21y8/Gd
         vm9Pbrd+V7fW/MmE4TvOOIRD2LcxQ97LjVMOLb5IrBqgp4R0n9XxEO78pUNHJWtcV0NU
         dFmoki9I4efWK0OzQY34hpUK/U5uz5lFzi95Zn1IrEt53ZNIZrl1OBHgQwym+ejRIFcl
         Ld7w==
X-Gm-Message-State: AOAM5305uEyH+W2a782CToJ9KFmAkHFTZlWdgS7QO6h1ph4K/2IsCPLk
        MwCxrgPUbMBRSxtN8OxXxrbAmRK+Z2PR37RY
X-Google-Smtp-Source: ABdhPJwV6GzMZQ+mNOpdRRBX3HLArICooddBup3dlenG8aQ6qcgGviIlOFg9Jtdit/VWiu2IZB/GZw==
X-Received: by 2002:aca:914:: with SMTP id 20mr9750235oij.9.1631576397694;
        Mon, 13 Sep 2021 16:39:57 -0700 (PDT)
Received: from MacBook-Pro.hackershack.net (cpe-173-173-107-246.satx.res.rr.com. [173.173.107.246])
        by smtp.gmail.com with ESMTPSA id u15sm2208500oor.34.2021.09.13.16.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 16:39:57 -0700 (PDT)
Subject: Re: [RFC v2 00/13] create power sequencing subsystem
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210829131305.534417-1-dmitry.baryshkov@linaro.org>
From:   Steev Klimaszewski <steev@kali.org>
Message-ID: <4a508fc1-6253-9c11-67fb-f84f17fd2719@kali.org>
Date:   Mon, 13 Sep 2021 18:39:55 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210829131305.534417-1-dmitry.baryshkov@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/29/21 8:12 AM, Dmitry Baryshkov wrote:
> This is the second RFC on the proposed power sequencer subsystem. This
> is a generification of the MMC pwrseq code. The subsystem tries to
> abstract the idea of complex power-up/power-down/reset of the devices.
>
> To ease migration to pwrseq and to provide compatibility with older
> device trees, while keeping drivers simple, this iteration of RFC
> introduces pwrseq fallback support: pwrseq driver can register fallback
> providers. If another device driver requests pwrseq instance and none
> was declared, the pwrseq fallback code would go through the list of
> fallback providers and if the match is found, driver would return a
> crafted pwrseq instance. For now this mechanism is limited to the OF
> device matching, but it can be extended further to use any combination
> of device IDs.
>
> The primary set of devices that promted me to create this patchset is
> the Qualcomm BT+WiFi family of chips. They reside on serial+platform or
> serial + SDIO interfaces (older generations) or on serial+PCIe (newer
> generations).  They require a set of external voltage regulators to be
> powered on and (some of them) have separate WiFi and Bluetooth enable
> GPIOs.
>
> This patchset being an RFC tries to demonstrate the approach, design and
> usage of the pwrseq subsystem. Following issues are present in the RFC
> at this moment but will be fixed later if the overall approach would be
> viewed as acceptable:
>
>  - No documentation
>    While the code tries to be self-documenting proper documentation
>    would be required.
>
>  - Minimal device tree bindings changes
>    There are no proper updates for the DT bindings (thus neither Rob
>    Herring nor devicetree are included in the To/Cc lists). The dt
>    schema changes would be a part of v1.
>
>  - Lack of proper PCIe integration
>    At this moment support for PCIe is hacked up to be able to test the
>    PCIe part of qca6390. Proper PCIe support would require automatically
>    powering up the devices before the bus scan depending on the proper
>    device structure in the device tree.
>
> Changes since RFC v1:
>  - Provider pwrseq fallback support
>  - Implement fallback support in pwrseq_qca.
>  - Mmove susclk handling to pwrseq_qca.
>  - Significantly simplify hci_qca.c changes, by dropping all legacy
>    code. Now hci_qca uses only pwrseq calls to power up/down bluetooth
>    parts of the chip.
>
I tested this here, on the Lenovo Yoga C630, after creating a patch to
do basically the same thing as the db845c does.  One thing I noticed, if
PWRSEQ=y and the rest are =m, there is a build error.  I suppose once
the full set is posted and not RFC, I can send the patch for that. 

One question I have, if you don't mind, in patch 11, you add a second
channel to qca power sequencer.  I've added that here, but in the c630's
dts, "vreg_l23a_3p3: ldo23" is empty, so I added the same numbers in for
the regulator, and I'm wondering how to test that it's actually working
correctly?

-- steev

