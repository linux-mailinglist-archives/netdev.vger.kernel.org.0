Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E822EC6C1
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbhAFXTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbhAFXTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 18:19:11 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02BAC061786
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 15:18:49 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id k10so3698450wmi.3
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 15:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WTmzRVtm/ED0Q2dM5QFp+kj2K19IjcXs46VVV6jD77o=;
        b=hmQWuHPXr1qY4LeNXQ/tG3w+9HhGpbpcHbZS+P7WM8tclWiSb3qO1EBBFteSqI+DjL
         4c8ETqmyJZ9MkjKKkV76etITKj+gcx+yiE1AR92LbUX12Yy5XFjtd69QMBt9I2s+vXWa
         Rc5BsiFX+SWdmftM5EAlQkrAC616o2XO//dddrGu1uHPDLencE0ecyGoFxs+5rf6RZjS
         t5gTBIMY3uExycGGqmd3D+QVRDzFLsuqnjOmnKoZs9jSqPdOQ7TGgjJ1Cq4ty93ldas0
         ZIMSgyX0sSt5mtlWdxiMhrEIapLnisHN1R+RHY9oKuKbItN87wMp+GAGE+LsavQ3Exa4
         MkTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WTmzRVtm/ED0Q2dM5QFp+kj2K19IjcXs46VVV6jD77o=;
        b=g3xPlk6nppr3sBJMrDItI1yQ3fNc3rb8Ts1KnQ6QB65wB9sTBNcGgTKyC+FErd93EM
         mU7J+zE7ldegFKyGEyQIqIE8m/F474DT3GU7xh9Ci36bdluOkD2GNIWyU8AIOaJr/IwZ
         i2Ned7WB12MvV/USPPxvax7QLrdxeUTdlguGddDs8IABgYSE1pgLTWfk8xnScPePioQ1
         9P4IpOFyImuulBhZM5xz+jd2yfHbVVKjz/j+eNPVseUWo3/ja1GCAM+TaPduaqa6kK+K
         60TlyvpKdUXRUFNx4CiJHR/zusrN4wbQ3409VGp6taxfxsrLoWJGkWDRrVsebjX4tCpB
         Xvqg==
X-Gm-Message-State: AOAM532q8v+mW69I69MlrNaH60qIk5aNtzfH9z5dMWHzmcgW6g254/CN
        5Bn0usr5mVN/crDZuHGGNAyGZepuodc=
X-Google-Smtp-Source: ABdhPJye0QOLjtEgN0F5K9WwnQmUpzjgsQoLzD3gfUf0ZCOYlBHLkgnsFS0TJc9gngwhRPKCTJIrJw==
X-Received: by 2002:a1c:6689:: with SMTP id a131mr5515061wmc.33.1609975128503;
        Wed, 06 Jan 2021 15:18:48 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id m14sm4851132wrh.94.2021.01.06.15.18.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 15:18:47 -0800 (PST)
Subject: Re: [PATCH net-next 1/3] r8169: replace BUG_ON with WARN in
 _rtl_eri_write
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f89bf2f3-5324-b635-4253-8a8be316c15b@gmail.com>
 <619e6cc2-9253-fd1e-564a-eec944ee31e1@gmail.com>
 <CAKgT0UcbDT_ccC0M=hC121YZ3pVC1ht2uv9-vPDjMFtM5mKDWw@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <eaa484aa-5033-d635-6292-e512534cb168@gmail.com>
Date:   Thu, 7 Jan 2021 00:02:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UcbDT_ccC0M=hC121YZ3pVC1ht2uv9-vPDjMFtM5mKDWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.01.2021 23:18, Alexander Duyck wrote:
> On Wed, Jan 6, 2021 at 5:32 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> Use WARN here to avoid stopping the system. In addition print the addr
>> and mask values that triggered the warning.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 024042f37..9af048ad0 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -763,7 +763,7 @@ static void _rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
>>  {
>>         u32 cmd = ERIAR_WRITE_CMD | type | mask | addr;
>>
>> -       BUG_ON((addr & 3) || (mask == 0));
>> +       WARN(addr & 3 || !mask, "addr: 0x%x, mask: 0x%08x\n", addr, mask);
>>         RTL_W32(tp, ERIDR, val);
>>         r8168fp_adjust_ocp_cmd(tp, &cmd, type);
>>         RTL_W32(tp, ERIAR, cmd);
> 
> Would it make more sense to perhaps just catch the case via an if
> statement, display the warning, and then return instead of proceeding
> with the write with the bad values?
> 
> I'm just wondering if this could make things worse by putting the
> device in a bad state in some way resulting in either a timeout
> waiting for a response or a hang.
> 
I tend to agree. Typically I'd expect that this warning is triggered
during development only, but yes: Returning instead of writing to a
wrong register is better.
