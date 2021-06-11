Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80B73A3EE5
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhFKJS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:18:26 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:44015 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhFKJSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 05:18:20 -0400
Received: by mail-wr1-f43.google.com with SMTP id r9so5239786wrz.10
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 02:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K8F10TRyleI4UPtq6CmbqILrYPwMwqooKyNnGn2buJw=;
        b=M05MxjZX6m1dTN5keWfOdaJ3t9eB3Suqc7AOitI2q+OPpRaLHyHP1sCeS70qYzxIPm
         62wU1zkFsMnxfm+OLnUw37P/WmKUimpE6h0CDgqJUfOTuptkG8gkp4PwjzTHXD5cBq+4
         S3E+AoKCg6IdgkacN/GsmO9Aeg2GvPhhTrvo5R57r6Z8F5B90Q7bhQLTnNVDQds5Dwnz
         CYfRg/JjuiNGZ4v1p4I3WiY4HQ/+JVvFeOf8jANLdTTLQZx2kdR8nKTDvYmqX/GIa6Py
         UfdoxIK3rTUjC4Iw29eWTOngMLHJh1QbqJRueh14mH9WidLTiO53xzSHm5aBS5+Ec0k6
         lTrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K8F10TRyleI4UPtq6CmbqILrYPwMwqooKyNnGn2buJw=;
        b=qvt0JopSdZnOrU1cb9kWydZCxBAkGlf2I0PbIitSPtyHIjnfLnO5KvB8lbVAgmb5S5
         uU3V46WUbSai9ph41+Lkiy+UkIKv+M96QguFC6GFUR7f+dEovHmWxmT/t9Jefsp+Wcz8
         lguf0wd/lnAW8eIyP/DheEcQS26TrJc+1px8tP1bCD5nKmD9x8QV1fEtufs3ta2WhPeB
         VrcIPNzv1LTshJBwcX6iU5VpNiFOdHMfHubt8Ac3IoTJwhgwa2t23tzWB2GQBjP82Aga
         uDy90GOYsNOajsbFbLGdEkXb5R9T4DKNTWxgX4mAETSLejMiLus9yTRXGT5B4uctqR0t
         FFCA==
X-Gm-Message-State: AOAM531FxVKv7OrPb8rtKnWRbrfHaoaokrDeCZH0gBNgsfAxuUzhfl7I
        p+uleWo5oNiSbkgiJBJS7A883e9P/Ds=
X-Google-Smtp-Source: ABdhPJx+lIlMhfC9qgvUPp/rVIci3MgdiTxy0tJLLzqZnkRQ7eOv01EKvHFpbeutJpHVuP1bDlsJRQ==
X-Received: by 2002:a5d:4538:: with SMTP id j24mr2872452wra.391.1623402906253;
        Fri, 11 Jun 2021 02:15:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:3800:6d14:9c4d:7f29:fc0d? (p200300ea8f2938006d149c4d7f29fc0d.dip0.t-ipconnect.de. [2003:ea:8f29:3800:6d14:9c4d:7f29:fc0d])
        by smtp.googlemail.com with ESMTPSA id n18sm6016562wmq.41.2021.06.11.02.15.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 02:15:05 -0700 (PDT)
To:     Koba Ko <koba.ko@canonical.com>,
        Kai Heng Feng <kai.heng.feng@canonical.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7060a8ba-720f-904f-a6c6-c873559d8dbe@gmail.com>
 <CAJB-X+WXVcd21eoT_usuVASa8D34Vkrbt5q7dcHSyE1T-vZD8A@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] r8169: avoid link-up interrupt issue on RTL8106e
 if user enables ASPM
Message-ID: <d7358ff5-d037-b539-f373-d28fc402cff4@gmail.com>
Date:   Fri, 11 Jun 2021 11:14:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAJB-X+WXVcd21eoT_usuVASa8D34Vkrbt5q7dcHSyE1T-vZD8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.06.2021 10:04, Koba Ko wrote:
> On Fri, Jun 11, 2021 at 4:57 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> It has been reported that on RTL8106e the link-up interrupt may be
>> significantly delayed if the user enables ASPM L1. Per default ASPM
>> is disabled. The change leaves L1 enabled on the PCIe link (thus still
>> allowing to reach higher package power saving states), but the
>> NIC won't actively trigger it.
>>
>> Reported-by: Koba Ko <koba.ko@canonical.com>
>> Tested-by: Koba Ko <koba.ko@canonical.com>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 64f94a3fe..6a9fe9f7e 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -3508,7 +3508,6 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
>>         rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
>>
>>         rtl_pcie_state_l2l3_disable(tp);
>> -       rtl_hw_aspm_clkreq_enable(tp, true);
>>  }
> 
> As per 0866cd15029b, this also affects the intel soc idle state.
> Even the result is positive currently, I think this modification would
> have higher risk.
> 
At the time of 0866cd15029b ASPM was enabled in r8169. Interesting that
after 0866cd15029b nobody reported the link-up issue you're facing.
A few months later (with b75bb8a5b755) we had to disable ASPM again
because of several problem reports. Since then 0866cd15029b has no
practical relevance in mainline.

>>
>>  DECLARE_RTL_COND(rtl_mac_ocp_e00e_cond)
>> --
>> 2.32.0
>>

