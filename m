Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242D05538A7
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 19:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352680AbiFURPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 13:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbiFURPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 13:15:39 -0400
Received: from smtp14.infineon.com (smtp14.infineon.com [IPv6:2a00:18f0:1e00:4::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E5B2A409;
        Tue, 21 Jun 2022 10:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1655831739; x=1687367739;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Oa2rFnX3lqAyXLuHHr44CEvOkTd44U44GyCOxUF6RI0=;
  b=JgfNab0jsVFLcg6DAs9p0mv7ewySupTyrNWB+hYGj/rep0czFeU+wAyK
   ORJIrjyMTxCeqylZKwmroMTEHl3vd/UWBa2YSqax/HRdZBX4sB/hJhAYJ
   44mADZVLLyzDRE66yXYpwwA8e3gJNWRNsATADYxL5VPZCaJqWrLWODJpk
   A=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="127395062"
X-IronPort-AV: E=Sophos;i="5.92,209,1650924000"; 
   d="scan'208";a="127395062"
Received: from unknown (HELO mucxv001.muc.infineon.com) ([172.23.11.16])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 19:15:36 +0200
Received: from MUCSE822.infineon.com (MUCSE822.infineon.com [172.23.29.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv001.muc.infineon.com (Postfix) with ESMTPS;
        Tue, 21 Jun 2022 19:15:36 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 21 Jun
 2022 19:15:35 +0200
Received: from [10.160.196.13] (172.23.8.247) by MUCSE807.infineon.com
 (172.23.29.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 21 Jun
 2022 19:15:34 +0200
Message-ID: <72cd312f-f843-6a85-b9e7-db8fcb952af8@infineon.com>
Date:   Tue, 21 Jun 2022 19:15:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 4/4] Bluetooth: hci_bcm: Increase host baudrate for
 CYW55572 in autobaud mode
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
References: <cover.1655723462.git.hakan.jansson@infineon.com>
 <386b205422099c795272ad8b792091b692def3cd.1655723462.git.hakan.jansson@infineon.com>
 <1a554d8e-c479-f646-ce9d-25871affbcee@molgen.mpg.de>
From:   Hakan Jansson <hakan.jansson@infineon.com>
In-Reply-To: <1a554d8e-c479-f646-ce9d-25871affbcee@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE824.infineon.com (172.23.29.55) To
 MUCSE807.infineon.com (172.23.29.33)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

On 6/20/2022 2:21 PM, Paul Menzel wrote:
>> Add device specific data for max baudrate in autobaud mode. This 
>> allows the
>> host to use a baudrate higher than "init speed" when loading FW in 
>> autobaud
>> mode.
>
> Please mention 921600 in the commit message, and maybe also document
> what the current default is.

Sure, I can do that if I submit a new rev. The default is 115200.

> Please also add the measurement data to the commit message, that means,
> how much is the time to load the firmware decreased.

The actual load time will depend on the specific FW used but I could add 
an example. It would be in the order of seconds.

>> Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
>> ---
>>   drivers/bluetooth/hci_bcm.c | 20 ++++++++++++++++----
>>   1 file changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
>> index 0ae627c293c5..d7e0b75db8a6 100644
>> --- a/drivers/bluetooth/hci_bcm.c
>> +++ b/drivers/bluetooth/hci_bcm.c
>> @@ -53,10 +53,12 @@
>>    * struct bcm_device_data - device specific data
>>    * @no_early_set_baudrate: Disallow set baudrate before driver setup()
>>    * @drive_rts_on_open: drive RTS signal on ->open() when platform 
>> requires it
>> + * @max_autobaud_speed: max baudrate supported by device in autobaud 
>> mode
>>    */
>>   struct bcm_device_data {
>>       bool    no_early_set_baudrate;
>>       bool    drive_rts_on_open;
>> +     u32     max_autobaud_speed;
>
> Why specify the length, and not just `unsigned int`? Maybe also add the
> unit to the variable name?

See below.

>>   };
>>
>>   /**
>> @@ -100,6 +102,7 @@ struct bcm_device_data {
>>    * @drive_rts_on_open: drive RTS signal on ->open() when platform 
>> requires it
>>    * @pcm_int_params: keep the initial PCM configuration
>>    * @use_autobaud_mode: start Bluetooth device in autobaud mode
>> + * @max_autobaud_speed: max baudrate supported by device in autobaud 
>> mode
>>    */
>>   struct bcm_device {
>>       /* Must be the first member, hci_serdev.c expects this. */
>> @@ -139,6 +142,7 @@ struct bcm_device {
>>       bool                    drive_rts_on_open;
>>       bool                    use_autobaud_mode;
>>       u8                      pcm_int_params[5];
>> +     u32                     max_autobaud_speed;
>
> Ditto.

I'm trying to following the style of the existing code which already had 
struct members "oper_speed" and "init_speed" declared as u32.


Regards,
Håkan
