Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D8419F6BB
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgDFNS1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Apr 2020 09:18:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33489 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728219AbgDFNS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:18:27 -0400
Received: from mail-pl1-f197.google.com ([209.85.214.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jLRdx-0000wJ-3W
        for netdev@vger.kernel.org; Mon, 06 Apr 2020 13:18:25 +0000
Received: by mail-pl1-f197.google.com with SMTP id k12so10969831pls.23
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 06:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yfh8auMdoRigiRys04NLUbX84A9moSV9U1pPae/atro=;
        b=prl8qFagriW4xVyExPjuun8R3UX+BKlC+UVjPsRFCjeMflscs8jYXX2G7ZHHizfUah
         nmCJxRh//EBbIkjJ24xPW9VQqNuTTGa10hMuOBFUKkaf3EAZ0xVx4mw4e2He7Zx8b7b4
         B38rA7Qd1IY15o6BxVnWtgbxy9GAiSzzR4T8ug1/YNKu5/5G6A1jEEb+AMaCI//+JGG+
         eLrSljAyCBQ81F34/VIaH/DuNvUJR8m//pqQdXfRpJRfB68JpqnaGBHUoHTK+tze8v46
         gK39FiPySIGsSCco/VVPtv5GyfbbOanyX4SyYObSFFQJIVQva9GApjQhqdUZH80NV5aw
         zmBQ==
X-Gm-Message-State: AGi0PuYV0KeJP5Q6VOxQ22RNcg4CNeEjzhD5o/NRAgrlGYxRVsQ9TAgZ
        POT7FbZmDBa+iJIRCRaFtS41FPFQmT/bZARJ8FdlsOpw8BnL382sehc5+nliQL0LH1qoRQB4HU7
        KOuw7Qf5lBw57YzV8gKHeipwTX4oF4BrFVw==
X-Received: by 2002:a63:e558:: with SMTP id z24mr20646321pgj.368.1586179103758;
        Mon, 06 Apr 2020 06:18:23 -0700 (PDT)
X-Google-Smtp-Source: APiQypIRNNfP69Byee6DnP3oE8819ZQmmW1WafsLeF6MlX6NhlFtF3wCeXFKCIqmcsiELvOx6719nA==
X-Received: by 2002:a63:e558:: with SMTP id z24mr20646297pgj.368.1586179103368;
        Mon, 06 Apr 2020 06:18:23 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id 135sm11948080pfu.207.2020.04.06.06.18.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Apr 2020 06:18:22 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] rtw88: Add delay on polling h2c command status bit
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <87v9mczu4h.fsf@kamboji.qca.qualcomm.com>
Date:   Mon, 6 Apr 2020 21:18:20 +0800
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:REALTEK WIRELESS DRIVER (rtw88)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <94EAAF7E-66C5-40E2-B6A9-0787CB13A3A9@canonical.com>
References: <20200406093623.3980-1-kai.heng.feng@canonical.com>
 <87v9mczu4h.fsf@kamboji.qca.qualcomm.com>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 6, 2020, at 20:17, Kalle Valo <kvalo@codeaurora.org> wrote:
> 
> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
> 
>> On some systems we can constanly see rtw88 complains:
>> [39584.721375] rtw_pci 0000:03:00.0: failed to send h2c command
>> 
>> Increase interval of each check to wait the status bit really changes.
>> 
>> While at it, add some helpers so we can use standarized
>> readx_poll_timeout() macro.
> 
> One logical change per patch, please.

Will split it into two separate patches.

> 
>> --- a/drivers/net/wireless/realtek/rtw88/hci.h
>> +++ b/drivers/net/wireless/realtek/rtw88/hci.h
>> @@ -253,6 +253,10 @@ rtw_write8_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u8 data)
>> 	rtw_write8(rtwdev, addr, set);
>> }
>> 
>> +#define rr8(addr)      rtw_read8(rtwdev, addr)
>> +#define rr16(addr)     rtw_read16(rtwdev, addr)
>> +#define rr32(addr)     rtw_read32(rtwdev, addr)
> 
> For me these macros reduce code readability, not improve anything. They
> hide the use of rtwdev variable, which is evil, and a name like rr8() is
> just way too vague. Please keep the original function names as is.

The inspiration is from another driver.
readx_poll_timeout macro only takes one argument for the op.
Some other drivers have their own poll_timeout implementation,
and I guess it makes sense to make one specific for rtw88.

Kai-Heng

> 
> -- 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

