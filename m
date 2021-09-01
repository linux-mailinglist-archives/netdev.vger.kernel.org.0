Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3E63FE05F
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 18:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344237AbhIAQwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 12:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245530AbhIAQw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 12:52:28 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AC5C061575;
        Wed,  1 Sep 2021 09:51:31 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b6so530589wrh.10;
        Wed, 01 Sep 2021 09:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RTD1viy9sw5ExgLARnDLkuiurxfEpvNu7YsBvXrRNP0=;
        b=GQyDH60MECuiTOMVOM4CVk9XxVDko5MCcWL7QJU/PTcuDHH/b5TuZgIfz5gPt7DMkr
         jvWIQwJ3SavA8l3Z4GqQEK5rPLL4w8osRGeADFsj2OLqNG4PCw7MZmhGcyXBFRF9uynD
         OrOeW55tlvaeRetbQslRukbSThkoVtjPMQnJtWPtFniNkf5WjXxwXbkyGtDVDx6ENbkS
         vrIzmiMBffXa7O2ImEzWTXX56Ta8bl1qNHrz1G0i+tXzoKWhuZ2RDT+tmAm769a0Agh4
         AcAqEzNehTuJOpIUvj93/Ea3Cz7cpmeRMia9gsOCErgso58ohtP2doA8nIFGdF271mbi
         TQog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RTD1viy9sw5ExgLARnDLkuiurxfEpvNu7YsBvXrRNP0=;
        b=To2bDtm04jeJzcvTkyJBLgnba+uHu7AbTuC9a9+c+Lrvnsj76tuBIhoaKTIkA/kljL
         2lRBEHcLb5WbzgGOqPJnQfaVmrdTl88dZnlnFwps60MNLGZ2EjRw4g8L45FJonUQADye
         7yLPP8VfQ3jd0GmLycvvf01A3gP1j5OAMaz4rDwCAjv9E0oozluAHC+P3MlmoutjbnWh
         eRWbu3UL43HgCTumPLllNh8oIILGEzNynk65DNDOtUg5b2OY0C4zvKhVxR2nJrPmGr1k
         SAsDY4UjeAqMUiyUJYpNxdVV2OtjBgQ5vGVSQd8Djwuc8J0Bd4z0odAjvfaSRL4QG+03
         qIDA==
X-Gm-Message-State: AOAM533I5wxJQzmxe9V5sxSqwFwUud871tAP2ZNl7MpR/wePqCS98SnA
        hpBD4XbtkTlAWlQLMfzRUFJsYPLX49Q=
X-Google-Smtp-Source: ABdhPJxChaNBdaszOD4eWL66SjCR9oYNCiqOueVyyZ2xO/WUp49wV+n6QH5g12HEHmEC/r26G4XX8A==
X-Received: by 2002:adf:efc2:: with SMTP id i2mr438135wrp.94.1630515090220;
        Wed, 01 Sep 2021 09:51:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:58da:e5eb:c867:1a2c? (p200300ea8f08450058dae5ebc8671a2c.dip0.t-ipconnect.de. [2003:ea:8f08:4500:58da:e5eb:c867:1a2c])
        by smtp.googlemail.com with ESMTPSA id g1sm19007wrb.27.2021.09.01.09.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 09:51:29 -0700 (PDT)
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20210830123704.221494-1-verdre@v0yd.nl>
 <20210830123704.221494-2-verdre@v0yd.nl>
 <CAHp75VeAKs=nFw4E20etKc3C_Cszyz9AqN=mLsum7F-BdVK5Rg@mail.gmail.com>
 <7e38931e-2f1c-066e-088e-b27b56c1245c@v0yd.nl>
 <20210901155110.xgje2qrtq65loawh@pali>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
Message-ID: <985049b8-bad7-6f18-c94f-368059dd6f95@gmail.com>
Date:   Wed, 1 Sep 2021 18:51:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210901155110.xgje2qrtq65loawh@pali>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.09.2021 17:51, Pali Rohár wrote:
> On Wednesday 01 September 2021 16:01:54 Jonas Dreßler wrote:
>> On 8/30/21 2:49 PM, Andy Shevchenko wrote:
>>> On Mon, Aug 30, 2021 at 3:38 PM Jonas Dreßler <verdre@v0yd.nl> wrote:
>>>>
>>>> On the 88W8897 card it's very important the TX ring write pointer is
>>>> updated correctly to its new value before setting the TX ready
>>>> interrupt, otherwise the firmware appears to crash (probably because
>>>> it's trying to DMA-read from the wrong place).
>>>>

This sounds somehow like the typical case where you write DMA descriptors
and then ring the doorbell. This normally requires a dma_wmb().
Maybe something like that is missing here?

Reading back all register writes may cause a certain performance impact,
and if it can be avoided we should try to avoid it.

>>>> Since PCI uses "posted writes" when writing to a register, it's not
>>>> guaranteed that a write will happen immediately. That means the pointer
>>>> might be outdated when setting the TX ready interrupt, leading to
>>>> firmware crashes especially when ASPM L1 and L1 substates are enabled
>>>> (because of the higher link latency, the write will probably take
>>>> longer).
>>>>
>>>> So fix those firmware crashes by always forcing non-posted writes. We do
>>>> that by simply reading back the register after writing it, just as a lot
>>>> of other drivers do.
>>>>
>>>> There are two reproducers that are fixed with this patch:
>>>>
>>>> 1) During rx/tx traffic and with ASPM L1 substates enabled (the enabled
>>>> substates are platform dependent), the firmware crashes and eventually a
>>>> command timeout appears in the logs. That crash is fixed by using a
>>>> non-posted write in mwifiex_pcie_send_data().
>>>>
>>>> 2) When sending lots of commands to the card, waking it up from sleep in
>>>> very quick intervals, the firmware eventually crashes. That crash
>>>> appears to be fixed by some other non-posted write included here.
>>>
>>> Thanks for all this work!
>>>
>>> Nevertheless, do we have any commits that may be a good candidate to
>>> be in the Fixes tag here?
>>>
>>
>> I don't think there's any commit we could point to, given that the bug is
>> probably somewhere in the firmware code.
> 
> Then please add Cc: stable@vger.kernel.org tag into commit message. Such
> bugfix is a good candidate for backporting into stable releases.
> 
>>>> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>

