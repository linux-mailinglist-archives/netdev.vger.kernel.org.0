Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA2F3E3048
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 22:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244926AbhHFUU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 16:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbhHFUU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 16:20:57 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B44C0613CF;
        Fri,  6 Aug 2021 13:20:40 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id m9so13527491ljp.7;
        Fri, 06 Aug 2021 13:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4QnWhLBGW7P4w1ngzVPzpq/T9GYh+XZ1jU3LWE7BPIk=;
        b=RUd3tRSHAJth2f/83FSeFT0g8a/JY0jh2Evyy1y7xDKQakdg+ftvPUd5/mXpOKNmHE
         R/+gy8L97UCP1NYMrKoUaly6olmYG7gCafw8KGk4C89dXTTZDMUloaKlO+OO5eLKGbXt
         f8x+odvmO6AhyiB9+/JdG3+6oOX/jUwezXlTmPABu4DLb18VHBcR/nPNB2qS4+x192PW
         lDJOkUlMouH46/ACQ2RWcWEAWdNeQlH8lB4/nmmW50CZzM2mP8wNnIdg/eYqRGCXQ3y1
         NM+qO2idQMNUSnM08C1t+TADTczsDIV2GJR3j/Q9dL13Kyr80NhN8KQ72yh/z0jwxqf3
         NVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4QnWhLBGW7P4w1ngzVPzpq/T9GYh+XZ1jU3LWE7BPIk=;
        b=EBmWVirxd2KIuqnnYH5f3G8ABqo0rbWEkIOkLO2cRsePU6Yxt0jODcVDciV2ZxbqTN
         tj16u7GVkWPEfW3QZQIAERB0Q4k0V9fa/Galunrbxklxu9EfJ1ZABhCYQoWrDwh96Stk
         wki/DhtJBfFZtFyxFb3EPHtyl1l11WQgILP7hvrs20pv7Jo17zYjN6leOAy7TSWH7yhT
         cj2vf5fTFeLWRRS+ynsduVfxwjoKQPJg0dbJpxLv+4129OtoAieAsCF6WeSPwrafiH1G
         WaAWgrBm24Icm8UilrV+c1R9CvOAxgkW09OUdJ3YUqI2RAVqac5izL80nSCLgGv2RG2M
         u9Sw==
X-Gm-Message-State: AOAM532+Y6ftTjlg2s4Y0ExKSk/X5KjBjrIwykBDWG8N2J5qZ01NjVrA
        Q+bGIvjqYCWQDRjnCEbe1hWxYXIiCJk=
X-Google-Smtp-Source: ABdhPJwU3q68sHkiPSvhLyo0OKhZrL/U8c4uz6BADVDW/9oCMf+Jia8IHf0Aa0kU6u+1YytjfAazPw==
X-Received: by 2002:a05:651c:98f:: with SMTP id b15mr7810029ljq.67.1628281239053;
        Fri, 06 Aug 2021 13:20:39 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.75.100])
        by smtp.gmail.com with ESMTPSA id y26sm448887lfl.93.2021.08.06.13.20.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 13:20:38 -0700 (PDT)
Subject: Re: [PATCH net-next v2 6/8] ravb: Add net_features and
 net_hw_features to struct ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-7-biju.das.jz@bp.renesas.com>
 <0daf8d07-b412-4cb0-cbfb-e8f8b84184e5@gmail.com>
 <OS0PR01MB5922C5EE008113DEA3354BFA86F29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <d038bed9-def6-9035-18fa-28ee527a149c@gmail.com>
Date:   Fri, 6 Aug 2021 23:20:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922C5EE008113DEA3354BFA86F29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 8/5/21 10:18 PM, Biju Das wrote:

[...]
>>> On R-Car the checksum calculation on RX frames is done by the E-MAC
>>> module, whereas on RZ/G2L it is done by the TOE.
>>>
>>> TOE calculates the checksum of received frames from E-MAC and outputs
>>> it to DMAC. TOE also calculates the checksum of transmission frames
>>> from DMAC and outputs it E-MAC.
>>>
>>> Add net_features and net_hw_features to struct ravb_hw_info, to
>>> support subsequent SoCs without any code changes in the ravb_probe
>> function.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>
>> [...]
>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>> b/drivers/net/ethernet/renesas/ravb.h
>>> index b765b2b7d9e9..3df813b2e253 100644
>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>> @@ -991,6 +991,8 @@ enum ravb_chip_id {  struct ravb_hw_info {
>>>  	const char (*gstrings_stats)[ETH_GSTRING_LEN];
>>>  	size_t gstrings_size;
>>> +	netdev_features_t net_hw_features;
>>> +	netdev_features_t net_features;
>>
>>    Do we really need both of these here? 
> 
> R-Car has only Rx Checksum on E-Mac, where as Geth supports Rx Check Sum on E-Mac or Rx/Tx CheckSum on TOE.
> So there is a hw difference. Please let me know what is the best way to handle this?

   I meant that we could go with only one field of the net_features... Alternatively, we could use our own
feature bits...

>> It seems like the 'feartures'
>> mirrors the enabled features?
> 
> Can you please explain this little bit?

   Looks like I was wrong. :-)

[...]

> Regards,
> Biju

[...]

MBR, Sergei
