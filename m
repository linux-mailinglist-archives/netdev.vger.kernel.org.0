Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D186BCDB9
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjCPLOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjCPLOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:14:03 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFEE4685;
        Thu, 16 Mar 2023 04:14:00 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x3so5995338edb.10;
        Thu, 16 Mar 2023 04:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678965238;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kf9VABIVOXX7/7LxcY4mylSn5iYQiggUdSc2+7iu714=;
        b=f26FCLf5bKyz8TEND2RwiGcVx7exjC1455NLAbSV38Gr9VKpmhRcMy2G4S079F1YFo
         cJ6bNRMBM2HB2uiZxGwO4NMWRmafTsVLROnEEpzEPX8k/GXXa+xDebgej00NwJPdfghz
         kxQrnrhfEEuy5gCxcCNRNms3KUge+tzjpIDUi9YgoWTuQZM3fwZQFgGmkpPLy3N7GBJ2
         8e8lCOkPjxq4OF1vHtgS2HmwKv/eezlFFx5t5AQHh8289KWhbtO/0UXgfgETq2CTbenD
         agiKnGWk4hQC3UD5TTLBYo6L4ZzDQhXmi5g5+RdQXE/ekWScjOKnKv1cfuOxrSRoHfV5
         oeiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678965238;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kf9VABIVOXX7/7LxcY4mylSn5iYQiggUdSc2+7iu714=;
        b=d5u7SFo7tCinZ+WbiFwvFnFNy/q1UWVtrCDe3+YADBqGsCCGXhiyjIc2XPGAGjZm00
         2Mf8q/prXs0qrv6cX5uEAybw4tpIyUAoi0dcw4tBS8ePuvINqvCu+YKnNtBB/ziz/btX
         pF40f8sJd8Xy9zzvu65lLOksNwX7/tVMo+YTPHzMGftm6eSy3P5fZLjkn8oJgqMyGCVV
         A40JdWYCY33rbtsgeW+z0sRorh+91VFP82CArOgOUkkEUjd1LotfOdn1lyEC0hrzmkUn
         zuG1wCprLnTZFbhZNbuazR1sAusGQqaRND4u44Q6dIxoDHCUnfg4srG/hKXa7vQB8LJF
         0Htg==
X-Gm-Message-State: AO0yUKVKrZYaW56CbCXXhRbuyRFNjhAlME5NYfVq0Hi/uZSJvN2SFkwr
        ODrWIpKYpfA4ZRCMjDLRuiI=
X-Google-Smtp-Source: AK7set8GdijChZp2etOVM7wySEyMIywYpKQQdPooVf2smGDOjb5h7VdmrdjoEtg4Ek+GqKunj/ACcQ==
X-Received: by 2002:a17:907:7ba6:b0:8af:ef00:b853 with SMTP id ne38-20020a1709077ba600b008afef00b853mr11325578ejc.73.1678965238423;
        Thu, 16 Mar 2023 04:13:58 -0700 (PDT)
Received: from [192.168.50.20] (077222238142.warszawa.vectranet.pl. [77.222.238.142])
        by smtp.gmail.com with ESMTPSA id i24-20020a170906851800b00930d505a567sm347738ejx.128.2023.03.16.04.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 04:13:58 -0700 (PDT)
Message-ID: <9e84b812-d32d-14fc-d2ae-0c8e82d6cdc5@gmail.com>
Date:   Thu, 16 Mar 2023 12:13:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH] net: usb: smsc95xx: Limit packet length to skb->len
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230313220124.52437-1-szymon.heidrich@gmail.com>
 <20230315212425.12cb48ca@kernel.org>
Content-Language: en-US
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
In-Reply-To: <20230315212425.12cb48ca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2023 05:24, Jakub Kicinski wrote:
> On Mon, 13 Mar 2023 23:01:24 +0100 Szymon Heidrich wrote:
>> Packet length retrieved from skb data may be larger than
> 
> nit: s/skb data/descriptor/ may be better in terms of terminology
> 
>> the actual socket buffer length (up to 1526 bytes). In such
> 
> nit: the "up to 1526 bytes" is a bit confusing, I'd remove it.
> 
>> case the cloned skb passed up the network stack will leak
>> kernel memory contents.
> 
> 
> 
>> Fixes: 2f7ca802bdae ("net: Add SMSC LAN9500 USB2.0 10/100 ethernet adapter driver")
>> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
>> ---
>>  drivers/net/usb/smsc95xx.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
>> index 32d2c60d3..ba766bdb2 100644
>> --- a/drivers/net/usb/smsc95xx.c
>> +++ b/drivers/net/usb/smsc95xx.c
>> @@ -1851,7 +1851,8 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
>>  			}
>>  		} else {
>>  			/* ETH_FRAME_LEN + 4(CRC) + 2(COE) + 4(Vlan) */
>> -			if (unlikely(size > (ETH_FRAME_LEN + 12))) {
>> +			if (unlikely(size > (ETH_FRAME_LEN + 12) ||
>> +				     size > skb->len)) {
> 
> We need this check on both sides of the big if {} statement.
> 
> In case the error bit is set and we drop the packet we still
> end up in skb_pull() which if size > skb->len will panic the
> kernel.
> 
> So let's do this check right after size and align are calculated?
> The patch for smsc75xx has sadly already been applied so you'll
> need to prepare a fix to the fix :(
> 
>>  				netif_dbg(dev, rx_err, dev->net,
>>  					  "size err header=0x%08x\n", header);
>>  				return 0;
> 

Thank you very much for you suggestions Kuba, I provided an updated patch for
smsc95xx and a new patch addressing smsc75xx. Please let me know in case additional
amendments are required.
