Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF536B5215
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbjCJUmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjCJUmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:42:49 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E23D135520;
        Fri, 10 Mar 2023 12:42:47 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id o5-20020a05600c510500b003ec0e4ec6deso890843wms.3;
        Fri, 10 Mar 2023 12:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678480966;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xtdqo2ZxphSElsKQbC7tvl0caLRLqCXXyE2IaE675+8=;
        b=FTT4ONWceB/5GsdfPoOPF7cMWniFtzHvok1pdW4JldPu+5WJtcsRq3m7mcxfM5HY5H
         h6agUt2CK7MYmBiLSjw/MBp5pFgjipGJM897tYNGwzOysVXrTXman290g9TOAUxnC7+H
         ZORaN5MBBMQhD1FTJmYoyuO4oER3hT+dKOa+lDblrO29j7nm5ymJvRpDbHeLR7OwFEd9
         Evc6ZmDTIXzUyK04Su3WZdkr83dn1LRrs3V5AEv+/R1JcDtyosTBPn6jc+D/GuImw9nQ
         jHOCEnfrLO+4Un4zY+Km4yA3I7ZWAJYpxjU9pmN+J5YxOdPjSVvzZXXMrjYcQDXwKYar
         RjZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678480966;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xtdqo2ZxphSElsKQbC7tvl0caLRLqCXXyE2IaE675+8=;
        b=MGyo549oZ2EOFc9cRbfKMisDdcDfYzHBrsHTETXMnlTq8y5mPE3Zg8mr1HZhtiK5sM
         ZCB7lIN6eJu6PFkVRqefNlQZNOLgl1tc0Fm89NczkKxqd76b0f1zGPCnbClDpjVDsaQ/
         k22b9qsQHbvlEL2eR/8FWWpAbNJ3yRvaLgOPIWq8J2kU895PEOKQK8Nv9AehKPD3qlTH
         KMjXQDijoKusf8EFytmtihp6xZhReBfp4J+K6n134LgcxKty2KilPDoUP/JCljSUy2k9
         ZXETmEZ/uRIqmEywwGXdEJPFEDp8sIJVRVQW6xEU29Gaji9Y10wMngYKvemCaArZ1AiY
         mmfA==
X-Gm-Message-State: AO0yUKW4nyC2Fz8mT2svUOqmrQY2c2Of+8VEBsiduBh5a5Sa2npZl8+1
        TvZxAKMICyvSB4q7urOBSns=
X-Google-Smtp-Source: AK7set9i/H7lcl1NiLITrPig13UwQIZ46O/VTbTxY7tSer8zWM3Q7SYO2ulKXHjtb5w01F+NRCNjAQ==
X-Received: by 2002:a05:600c:3b13:b0:3eb:2e32:72b4 with SMTP id m19-20020a05600c3b1300b003eb2e3272b4mr3947184wms.15.1678480965890;
        Fri, 10 Mar 2023 12:42:45 -0800 (PST)
Received: from ?IPV6:2a01:c22:7669:bf00:58d7:455f:e597:a838? (dynamic-2a01-0c22-7669-bf00-58d7-455f-e597-a838.c22.pool.telefonica.de. [2a01:c22:7669:bf00:58d7:455f:e597:a838])
        by smtp.googlemail.com with ESMTPSA id a7-20020a5d5707000000b002c54f4d0f71sm670939wrv.38.2023.03.10.12.42.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 12:42:21 -0800 (PST)
Message-ID: <eb2bee03-1b2c-384b-e9c1-5ddf2240c828@gmail.com>
Date:   Fri, 10 Mar 2023 21:42:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v9 3/5] r8169: Consider chip-specific ASPM can be
 enabled on more cases
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     nic_swsd@realtek.com, bhelgaas@google.com, koba.ko@canonical.com,
        acelan.kao@canonical.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, vidyas@nvidia.com,
        rafael.j.wysocki@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <20230309201705.GA1165139@bhelgaas>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230309201705.GA1165139@bhelgaas>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.03.2023 21:17, Bjorn Helgaas wrote:
> On Sat, Feb 25, 2023 at 11:46:33AM +0800, Kai-Heng Feng wrote:
>> To really enable ASPM on r8169 NICs, both standard PCIe ASPM and
>> chip-specific ASPM have to be enabled at the same time.
>>
>> Before enabling ASPM at chip side, make sure the following conditions
>> are met:
>> 1) Use pcie_aspm_support_enabled() to check if ASPM is disabled by
>>    kernel parameter.
>> 2) Use pcie_aspm_capable() to see if the device is capable to perform
>>    PCIe ASPM.
>> 3) Check the return value of pci_disable_link_state(). If it's -EPERM,
>>    it means BIOS doesn't grant ASPM control to OS, and device should use
>>    the ASPM setting as is.
>>
>> Consider ASPM is manageable when those conditions are met.
>>
>> While at it, disable ASPM at chip-side for TX timeout reset, since
>> pci_disable_link_state() doesn't have any effect when OS isn't granted
>> with ASPM control.
> 
> 1) "While at it, ..." is always a hint that maybe this part could be
> split to a separate patch.
> 
> 2) The mix of chip-specific and standard PCIe ASPM configuration is a
> mess.  Does it *have* to be intermixed at run-time, or could all the
> chip-specific stuff be done once, e.g., maybe chip-specific ASPM
> enable could be done at probe-time, and then all subsequent ASPM
> configuration could done via the standard PCIe registers?
> 
> I.e., does the chip work correctly if chip-specific ASPM is enabled,
> but standard PCIe ASPM config is *disabled*?
> 
> The ASPM sysfs controls [1] assume that L0s, L1, L1.1, L1.2 can all be
> controlled simply by using the standard PCIe registers.  If that's not
> the case for r8169, things will break when people use the sysfs knobs.
> 
This series has been superseded meanwhile and what is being discussed
here has become obsolete.

> Bjorn
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/ABI/testing/sysfs-bus-pci?id=v6.2#n420
> 
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
>> v9:
>>  - No change.
>>
>> v8:
>>  - Enable chip-side ASPM only when PCIe ASPM is already available.
>>  - Wording.
>>
>> v7:
>>  - No change.
>>
>> v6:
>>  - Unconditionally enable chip-specific ASPM.
>>
>> v5:
>>  - New patch.
>>
>>  drivers/net/ethernet/realtek/r8169_main.c | 22 ++++++++++++++++++----
>>  1 file changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 45147a1016bec..a857650c2e82b 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -2675,8 +2675,11 @@ static void rtl_disable_exit_l1(struct rtl8169_private *tp)
>>  
>>  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>>  {
>> -	/* Don't enable ASPM in the chip if OS can't control ASPM */
>> -	if (enable && tp->aspm_manageable) {
>> +	/* Skip if PCIe ASPM isn't possible */
>> +	if (!tp->aspm_manageable)
>> +		return;
>> +
>> +	if (enable) {
>>  		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
>>  		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
>>  
>> @@ -4545,8 +4548,13 @@ static void rtl_task(struct work_struct *work)
>>  		/* ASPM compatibility issues are a typical reason for tx timeouts */
>>  		ret = pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_L1 |
>>  							  PCIE_LINK_STATE_L0S);
>> +
>> +		/* OS may not be granted to control PCIe ASPM, prevent the driver from using it */
>> +		tp->aspm_manageable = 0;
>> +
>>  		if (!ret)
>>  			netdev_warn_once(tp->dev, "ASPM disabled on Tx timeout\n");
>> +
>>  		goto reset;
>>  	}
>>  
>> @@ -5227,13 +5235,19 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>  	 * Chips from RTL8168h partially have issues with L1.2, but seem
>>  	 * to work fine with L1 and L1.1.
>>  	 */
>> -	if (rtl_aspm_is_safe(tp))
>> +	if (!pcie_aspm_support_enabled() || !pcie_aspm_capable(pdev))
>> +		rc = -EINVAL;
>> +	else if (rtl_aspm_is_safe(tp))
>>  		rc = 0;
>>  	else if (tp->mac_version >= RTL_GIGA_MAC_VER_46)
>>  		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
>>  	else
>>  		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
>> -	tp->aspm_manageable = !rc;
>> +
>> +	/* -EPERM means BIOS doesn't grant OS ASPM control, ASPM should be use
>> +	 * as is. Honor it.
>> +	 */
>> +	tp->aspm_manageable = (rc == -EPERM) ? 1 : !rc;
>>  
>>  	tp->dash_type = rtl_check_dash(tp);
>>  
>> -- 
>> 2.34.1
>>

