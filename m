Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F77310E14F
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 10:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfLAJwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 04:52:03 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:37781 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfLAJwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 04:52:03 -0500
Received: by mail-wm1-f45.google.com with SMTP id f129so19730078wmf.2;
        Sun, 01 Dec 2019 01:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o/0gCOK+/J2G5vanbQdNvJpthNmviD8pf8+x/WflIz8=;
        b=l90aNcz7AvVz0i/UpJMPeo0N7DXsp5eykmdxs90PXWfOK2I5JQiZBkbAvBmC9TajZ8
         5225bIhoPlpaXdCmiyYNX6LkCy+V8FmpR7Co9yk75dPn/UIbTsh2SrTl48gtuG8ejxSO
         /Agx+MWNLte++FhIP/ZtcHlMJ/abqmtS4EmR8qSlUustTpqr9f7YPYS3opzzr9AVwgEo
         LHZS3nW6M7I3zJX3j5GpskGMZhjRq+4mVe7qp2I9mjhk55dpob4YbGAJjKTCXkHBF+4I
         j+k3YrRGbJis/tWl1io1tPcrdf/gFZlS1zsTITMElklCzI2wKCe4y14qNIeDV1mCovP5
         tD0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o/0gCOK+/J2G5vanbQdNvJpthNmviD8pf8+x/WflIz8=;
        b=PGrrMMhPNj2D/PceKtS9bSGfd/7SSu1AUKHP3DKELErzMFDfYIn+MuhEWFz1oUVJTX
         +lfrpyHHoVhT56SBzoxZEsE2CV2xshswLppeavETxTjfc/v8FNkjyVOdwde5tSBWbFj/
         1cU+jj5q+2Lz3H4fJqYeiclRNAAiOjfNyLrgu4S+BEtXeYmVRk81TVHgCBXb/bJsLHIc
         JzQeyenxeVjESpKRT66IKXeXFJarDQj2JICD0tQSRkiAfTXS/e7z24LvSyc1cRwdo+tX
         rRGf56Mnr3DpCUohMhl9N6Kc8/Xd2h0cPf60ub0DA7oXtgq2Rn5Zs4T0f0nGIeYjBAuf
         2CyQ==
X-Gm-Message-State: APjAAAWT7ciKevBKEjwDjoXY5TwzYcV24UFFftrLInIv+TJdQfQn+38l
        MAY+yStcK5svbxQiYiNh3KuN8yDG
X-Google-Smtp-Source: APXvYqyx4BhMD58KNQvw5Q/E45c2pzc2hFpeWVtlSygw8nWPQyLVtnfE+M5Y6byNIlhUGhrqXwKN7Q==
X-Received: by 2002:a1c:9d16:: with SMTP id g22mr23588084wme.27.1575193920886;
        Sun, 01 Dec 2019 01:52:00 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:1159:8f18:7fad:7ef1? (p200300EA8F4A630011598F187FAD7EF1.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:1159:8f18:7fad:7ef1])
        by smtp.googlemail.com with ESMTPSA id f1sm33595140wru.6.2019.12.01.01.51.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Dec 2019 01:52:00 -0800 (PST)
Subject: Re: 5.4 Regression in r8169 with jumbo frames - packet loss/delays
To:     "Alan J. Wylie" <alan@wylie.me.uk>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <24034.56114.248207.524177@wylie.me.uk>
 <75146b50-9518-8588-81fa-f2811faf6cca@gmail.com>
 <24035.32883.173899.812456@wylie.me.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0ef3ef69-bfb2-11c5-fb63-6b83cffff0ed@gmail.com>
Date:   Sun, 1 Dec 2019 10:26:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <24035.32883.173899.812456@wylie.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.12.2019 09:57, Alan J. Wylie wrote:
> at 22:37 on Sat 30-Nov-2019 Heiner Kallweit (hkallweit1@gmail.com) wrote:
> 
>> Thanks for the report. A jumbo fix for one chip version may have
>> revealed an issue with another chip version. Could you please try
>> the following?
>> I checked the vendor driver r8168 and there's no special sequence
>> to configure jumbo mode.
>>
>> What would be interesting:
>> Do you set the (jumbo) MTU before bringing the device up?
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 0b47db2ff..38d212686 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -3873,7 +3873,7 @@ static void rtl_hw_jumbo_enable(struct rtl8169_private *tp)
>>  	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
>>  		r8168dp_hw_jumbo_enable(tp);
>>  		break;
>> -	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_34:
>> +	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_33:
>>  		r8168e_hw_jumbo_enable(tp);
>>  		break;
>>  	default:
>> -- 
>> 2.24.0
> 
> That patch fixes the issue for me.
> 
Great, thanks for the feedback!

> Thanks
> 
> Alan
> 
Heineer
