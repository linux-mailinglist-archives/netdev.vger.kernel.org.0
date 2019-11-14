Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A837FFD04A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 22:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKNV0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 16:26:03 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:44880 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfKNV0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 16:26:02 -0500
Received: by mail-oi1-f193.google.com with SMTP id s71so6649569oih.11;
        Thu, 14 Nov 2019 13:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TFR+TtqF6/JMeXXEQsjA3XB1eHekCwxMmHu25rIKAXQ=;
        b=jq/VN2VpxXQXSDLBocWQfRD+pEdZ+BrjwyCXdiKdJWDTu7tfUQBoms0ZmYExWhLx6E
         V8ob11JHEnf++VgGNCvXmJOupTDUlvCvpjoontoISl3cU1eTyNz/P74bymHOrjVvKa9K
         L4k4JnIOukpcOyJFBl/3uwT465gtBh7+gXJ5f9XEFwt/d8gqQKZfMf4KiC5q7IXoFR/E
         BVc8wrUG5fRb/C5WOcM4AYf8LF0aMkujq7eKAm0J4LyNk6iYgkMLmgMyFqePS7NIyXuN
         UGnCy45CvR4plmm7IBmk3FfL/uugogc/4yuIDCspB9aeDpOA/3GGTF4QmykzVr570IT5
         F0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TFR+TtqF6/JMeXXEQsjA3XB1eHekCwxMmHu25rIKAXQ=;
        b=hFVakRsQXM6uXOJ2G0xvlpIOIy2JHUjXrBqfAe1vbieRuQefzBWkuPH2mYJPGwNSxs
         eI7/zZE53SFAuetoS1AbaDigLHGITdwcd69tbrElRZmo+bRsIMIAy3dEvmExP7BSE4vU
         umPityFe34FebZfXy7aHhVrnnvupyu8NFq1TR5+mYKe5ktM9Dn7d2rQ9yfmW0PE8NTeI
         ANJwS3VA5hQa7pu2CE237fzSBhhO7hZWuPbX1gBBMMfh/nSKLVn7a0HoaYflQE5727eM
         cz13/AviRj0+mqVBDE9NmLU1mwx2gKg32FglsW2dmBD/lz90GTO8cU94U0odAKffJ2UH
         GAUw==
X-Gm-Message-State: APjAAAWFqrS4Ttw0S6JVWh6CANJXMX2Gu3esPa9uHZkC1RF9RGiDzETU
        86mc/unbiHgg1yL/cmi3THKkzAnA
X-Google-Smtp-Source: APXvYqydKiXRWb2L3E7XdTr31RA/x3x+GhV0iO0y95QIr36ToSUkbV2amXsDka6hSJDhY/9KXBHYag==
X-Received: by 2002:aca:c702:: with SMTP id x2mr4877309oif.167.1573766761156;
        Thu, 14 Nov 2019 13:26:01 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d5sm2068375oic.23.2019.11.14.13.26.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 13:26:00 -0800 (PST)
Subject: Re: long delays in rtl8723 drivers in irq disabled sections
To:     Pkshih <pkshih@realtek.com>, Lucas Stach <dev@lynxeye.de>,
        wlanfae <wlanfae@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <5de65447f1d115f436f764a7ec811c478afbe2e0.camel@lynxeye.de>
 <5B2DA6FDDF928F4E855344EE0A5C39D1D5C9CE47@RTITMBSVM04.realtek.com.tw>
 <e83f5b699c5652cbe2350ac3576215d24b748e03.camel@lynxeye.de>
 <5B2DA6FDDF928F4E855344EE0A5C39D1D5C9D5F6@RTITMBSVM04.realtek.com.tw>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a6d55cfc-9de9-ce6e-1dcf-814372772327@lwfinger.net>
Date:   Thu, 14 Nov 2019 15:25:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D1D5C9D5F6@RTITMBSVM04.realtek.com.tw>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/19 7:41 PM, Pkshih wrote:
> 
> 
>> -----Original Message-----
>> From: Lucas Stach [mailto:dev@lynxeye.de]
>> Sent: Thursday, November 14, 2019 6:11 AM
>> To: Pkshih; wlanfae
>> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org
>> Subject: Re: long delays in rtl8723 drivers in irq disabled sections
>>
>> Hi PK,
>>
>> Am Mittwoch, den 13.11.2019, 03:43 +0000 schrieb Pkshih:
>>>> -----Original Message-----
>>>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On
>> Behalf
>>>> Of Lucas Stach
>>>> Sent: Wednesday, November 13, 2019 5:02 AM
>>>> To: wlanfae; Pkshih
>>>> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org
>>>> Subject: long delays in rtl8723 drivers in irq disabled sections
>>>>
>>>> Hi all,
>>>>
>>>> while investigating some latency issues on my laptop I stumbled across
>>>> quite large delays in the rtl8723 PHY code, which are done in IRQ
>>>> disabled atomic sections, which is blocking IRQ servicing for all
>>>> devices in the system.
>>>>
>>>> Specifically there are 3 consecutive 1ms delays in
>>>> rtl8723_phy_rf_serial_read(), which is used in an IRQ disabled call
>>>> path. Sadly those delays don't have any comment in the code explaining
>>>> why they are needed. I hope that anyone can tell if those delays are
>>>> strictly neccessary and if so if they really need to be this long.
>>>>
>>>
>>> These delays are because read RF register is an indirect access that hardware
>>> needs time to accomplish read action, but there's no ready bit, so delay
>>> is required to guarantee the read value is correct.
>>
>> Thanks for the confirmation, I suspected something like this.
>>
>>> It is possible to use smaller delay, but it's exactly required.
>>
>> 1ms seems like an eternity on modern hardware, even for an indirect
>> read.
>>
> 
> For 8723be, three 1ms delays can be replaced by one 120us delay, likes
> 
> @@ -89,12 +89,10 @@ u32 rtl8723_phy_rf_serial_read(struct ieee80211_hw *hw,
>              (newoffset << 23) | BLSSIREADEDGE;
>          rtl_set_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD,
>                        tmplong & (~BLSSIREADEDGE));
> -       mdelay(1);
>          rtl_set_bbreg(hw, pphyreg->rfhssi_para2, MASKDWORD, tmplong2);
> -       mdelay(1);
>          rtl_set_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD,
>                        tmplong | BLSSIREADEDGE);
> -       mdelay(1);
> +       udelay(120);
>          if (rfpath == RF90_PATH_A)
>                  rfpi_enable = (u8) rtl_get_bbreg(hw, RFPGA0_XA_HSSIPARAMETER1,
>                                                   BIT(8));
> 
> I think it'd be better.
> 
>>>
>>> An alternative way is to prevent calling this function in IRQ disabled flow.
>>> Could you share the calling trace?
>>
>> Sure, trimmed callstack below. As you can see the IRQ disabled section
>> is started via a spin_lock_irqsave(). The trace is from a 8723de
>> module, which is still out of tree, but the same code is present in
>> mainline and used by the other 8723 variants.
> 
> By now, 8723DE will be upstream through rtw88 instead of rtlwifi.
> 
>> I don't know if this function needs to guard against something running
>> in the IRQ handler, so depending on the answer to that the solution
>> might be as simple as not disabling IRQs when taking the spinlock.
>>
>> kworker/-276     4d...    0us : _raw_spin_lock_irqsave
>> kworker/-276     4d...    0us : rtl8723_phy_rf_serial_read <-rtl8723de_phy_set_rf_reg
>> kworker/-276     4d...    1us : rtl8723_phy_query_bb_reg <-rtl8723_phy_rf_serial_read
>> kworker/-276     4d...    3us : rtl8723_phy_set_bb_reg <-rtl8723_phy_rf_serial_read
>> kworker/-276     4d...    4us : __const_udelay <-rtl8723_phy_rf_serial_read
>> kworker/-276     4d...    4us!: delay_mwaitx <-rtl8723_phy_rf_serial_read
>> kworker/-276     4d... 1004us : rtl8723_phy_set_bb_reg <-rtl8723_phy_rf_serial_read
>> [...]
>>
> 
> I check TX/RX interrupt handlers, and I don't find one calls RF read function
> by now. I suspect that old code controls RF to do PS in interrupt context, so
> _irqsave version is used to ensure read RF isn't interrupted or deadlock.
> So, I change spin_lock to non-irqsave version, and do some tests on 8723BE
> that works well.
> 
> What do you think about two fixes mentioned above? If they're ok, I can send
> two patches to resolve this long delays.

Lucas,

If the above patch fixes the problem with the 8723de, I will modify the GitHub 
driver. Although 8723de will be added to rtw88, I will keep the driver in 
rtlwifi_new.

Larry

