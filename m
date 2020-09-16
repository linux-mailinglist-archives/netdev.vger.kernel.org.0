Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDB526CCA4
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgIPUrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbgIPRBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:01:20 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC9BC0086D1;
        Wed, 16 Sep 2020 06:41:01 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t7so1622229pjd.3;
        Wed, 16 Sep 2020 06:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=a7VpgUXD3etb/W2u95CFqiHYYBXyXu79NXiK4t98Blw=;
        b=I+qQ5j9mEE3iA0H4ZUBphMax7ReOC8kLIFC4DG0UZcKdQnYem3m8Y+7sCVJiRZJ/B/
         pw8tMLhpfRFVWel7rSka1hqv7O+41MZIaPaAoRO64Re5IL8TAkR1wJJOSWwT10WJMY1S
         MmLmpoRxLod/Oqy9GDd2FhG94gZ7/74YYZ25q0zp1FMPB/mZFfmEX8B2sotKLoWCAR9m
         ScqhB8raR4jlvngSTMKThpKS98ZX+BfZbhZnmqcHUcIZJeWdC/MkkwOEN+mlx2nDXPJ+
         rGBjZ0Qawi4ak9DsvFSaQWQtOz12PLCl68CPxiYgA+fLS6yRBLooKDQ4+D0XFi4PMMz6
         4PZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=a7VpgUXD3etb/W2u95CFqiHYYBXyXu79NXiK4t98Blw=;
        b=hn+VglDnqbU6nU8bK3NmY/Nqmd/OsbglntwwyiW4BwxLcGPPyWrAN+BYfmR9mBENhw
         kRPvC6BJee56w4g5VlTv0LCEz9d2w+sQmEnHK93co54v6XqCOEgT6GMH2Ap4/Fp6mCis
         uGRUYLu5AKjehB/iAHMvSFoTRMxAAYmxEbdzf9JnyiM0ZDUmzALBlNe5tKXYHoxCaow1
         1+ZoBEYqzTRLPSD3BiC2rIMd4RTFwEiUtVK5CGtaMHBi9ywdGKLH/Njn+8TnpI0WgJwL
         0KTohg6vvyj1LrXePhi238b/A9JD7qqs+k3pPcNDYLMBGgkyPJYHuhqFW2yJ8JQEwPnO
         T9ag==
X-Gm-Message-State: AOAM533giAi5udOIqwEqYtzsfrKM2bynIw61Ja3tjU273s9tnd3Z3B4A
        /gyKvHQU++nEGKl7JwGkJKodk6E2nwpOnNJDQxE=
X-Google-Smtp-Source: ABdhPJwsdlcogMP86H7W0+GT+TmcgrKpclDe9FF5ms19t0nLyBthmXVXaKb8aLBdzPeosDJc3+hC3w==
X-Received: by 2002:a17:90a:7ac1:: with SMTP id b1mr3975237pjl.121.1600263660892;
        Wed, 16 Sep 2020 06:41:00 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.198.18])
        by smtp.gmail.com with ESMTPSA id gm17sm2784507pjb.46.2020.09.16.06.40.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2020 06:41:00 -0700 (PDT)
Subject: Re: [Linux-kernel-mentees][PATCH] rtl8150: set memory to all 0xFFs on
 failed register reads
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200916050540.15290-1-anant.thazhemadam@gmail.com>
 <20200916062227.GD142621@kroah.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <dfdb48b8-5cd9-2b19-11cc-b17f45904e0f@gmail.com>
Date:   Wed, 16 Sep 2020 19:10:55 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200916062227.GD142621@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16/09/20 11:52 am, Greg KH wrote:
> On Wed, Sep 16, 2020 at 10:35:40AM +0530, Anant Thazhemadam wrote:
>> get_registers() copies whatever memory is written by the
>> usb_control_msg() call even if the underlying urb call ends up failing.
>>
>> If get_registers() fails, or ends up reading 0 bytes, meaningless and 
>> junk register values would end up being copied over (and eventually read 
>> by the driver), and since most of the callers of get_registers() don't 
>> check the return values of get_registers() either, this would go unnoticed.
>>
>> It might be a better idea to try and mirror the PCI master abort
>> termination and set memory to 0xFFs instead in such cases.
> It would be better to use this new api call instead of
> usb_control_msg():
> 	https://lore.kernel.org/r/20200914153756.3412156-1-gregkh@linuxfoundation.org
>
> How about porting this patch to run on top of that series instead?  That
> should make this logic much simpler.
This looks viable to me. I'll be sure to try this out.
>> Fixes: https://syzkaller.appspot.com/bug?extid=abbc768b560c84d92fd3
>> Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
>> Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
>> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
>> ---
>>  drivers/net/usb/rtl8150.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
>> index 733f120c852b..04fca7bfcbcb 100644
>> --- a/drivers/net/usb/rtl8150.c
>> +++ b/drivers/net/usb/rtl8150.c
>> @@ -162,8 +162,13 @@ static int get_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
>>  	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
>>  			      RTL8150_REQ_GET_REGS, RTL8150_REQT_READ,
>>  			      indx, 0, buf, size, 500);
>> -	if (ret > 0 && ret <= size)
>> +
>> +	if (ret < 0)
>> +		memset(data, 0xff, size);
>> +
>> +	else
>>  		memcpy(data, buf, ret);
>> +
>>  	kfree(buf);
>>  	return ret;
>>  }
>> @@ -276,7 +281,7 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
>>  
>>  static inline void set_ethernet_addr(rtl8150_t * dev)
>>  {
>> -	u8 node_id[6];
>> +	u8 node_id[6] = {0};
> This should not be needed to be done.

Noted.

Thank you for your time.

Thanks,
Anant

