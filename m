Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4946B52F5
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbjCJVlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCJVlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:41:49 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4FD1308DF
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:41:47 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p16so4320277wmq.5
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678484506;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nuoaRydcdRf7QF0L4JeZFMRoaDrPqNfmXZXL2Pa7Bfw=;
        b=P8h0RrQ+lVcGC5C+fG8hwcY8azvU6az3rEaVxDuqdUPEboDZVWgdaV3rWvtl55RMjE
         lrhZf748Nsm6vcmx9++kG7ljX2bgEaT78ii51RoSD7VE23n6e0ven3umi5CPWWG9JP6R
         OyXk7gerrC958FKCr46ZCNeifh1UKqOehG8DJjPdX6uwmDb911fZtlNP6xxXtpRgCABi
         G5GnKZp2+KWTzrhKY55D3vRmJecVhZUHILK47GfXrA8tM7GHdHrRq9whfK9KedPLuLvg
         7znGY/akvLaReCCIMiRlsLhBDDGHJ1wDo5z0SIXPtvxSPtyeXuSxFxeglGFFlynPg2rT
         SLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484506;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nuoaRydcdRf7QF0L4JeZFMRoaDrPqNfmXZXL2Pa7Bfw=;
        b=6KET5lj1lBAHu2I7PhSMhLgX/VkwHKBIZ1oMj/KrUDkDdo0C62XhVBtC7yYeAhExxh
         4pnqGYwofmEdnmocQ7p+8s2vZLziTs/jOq9NxoCJ0KCp7lMV5nSAyia9qNpTvIZABEL9
         RPSWfJ6CbqdyrJeqOR5idy3i4udhM/1Kqoejf4Z1Vk9iWhNYTDZOcxE0Cu1D2hXclTtJ
         9WMOVC64A6izTKGrUFGpmN5GDxGox4/jTa/9ZHF07p4gmLhFxxCQOH4g47YXQ3fFv3Av
         xe2Ju1h1bSFX+MyDO/VxJA587ZTvo0LmvAERTpW3QwsJbxFfxFAj7NtLKUBRP3RUsL70
         HyCg==
X-Gm-Message-State: AO0yUKV0otEDBugvnwFj7FjkCTZroEFHrlJ4b+7SKtuF2XjF9JV1JkUl
        EkM1mLs7xgkbEabUiJF4KiCithyoRL0=
X-Google-Smtp-Source: AK7set9emRMklhPr+iit/H0debBHQ9EtlJz53pB2sIeOzONu3b4GnjbOuF3r37GvoAJwfNGudBp8bQ==
X-Received: by 2002:a05:600c:1546:b0:3eb:2b88:7838 with SMTP id f6-20020a05600c154600b003eb2b887838mr4091726wmg.14.1678484505923;
        Fri, 10 Mar 2023 13:41:45 -0800 (PST)
Received: from ?IPV6:2a01:c22:7669:bf00:58d7:455f:e597:a838? (dynamic-2a01-0c22-7669-bf00-58d7-455f-e597-a838.c22.pool.telefonica.de. [2a01:c22:7669:bf00:58d7:455f:e597:a838])
        by smtp.googlemail.com with ESMTPSA id k4-20020a05600c0b4400b003e21ba8684dsm976980wmr.26.2023.03.10.13.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 13:41:45 -0800 (PST)
Message-ID: <c46ccdd8-df5b-f149-b165-beb2ce9ef046@gmail.com>
Date:   Fri, 10 Mar 2023 22:41:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RFC 6/6] r8169: remove ASPM restrictions now that ASPM is
 disabled during NAPI poll
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230310211950.GA1280275@bhelgaas>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230310211950.GA1280275@bhelgaas>
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

On 10.03.2023 22:19, Bjorn Helgaas wrote:
> On Sat, Feb 25, 2023 at 10:47:32PM +0100, Heiner Kallweit wrote:
>> Now that  ASPM is disabled during NAPI poll, we can remove all ASPM
>> restrictions. This allows for higher power savings if the network
>> isn't fully loaded.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 27 +----------------------
>>  1 file changed, 1 insertion(+), 26 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 2897b9bf2..6563e4c6a 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -620,7 +620,6 @@ struct rtl8169_private {
>>  	int cfg9346_usage_count;
>>  
>>  	unsigned supports_gmii:1;
>> -	unsigned aspm_manageable:1;
>>  	dma_addr_t counters_phys_addr;
>>  	struct rtl8169_counters *counters;
>>  	struct rtl8169_tc_offsets tc_offset;
>> @@ -2744,8 +2743,7 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>>  	if (tp->mac_version < RTL_GIGA_MAC_VER_32)
>>  		return;
>>  
>> -	/* Don't enable ASPM in the chip if OS can't control ASPM */
>> -	if (enable && tp->aspm_manageable) {
>> +	if (enable) {
>>  		rtl_mod_config5(tp, 0, ASPM_en);
>>  		rtl_mod_config2(tp, 0, ClkReqEn);
>>  
>> @@ -5221,16 +5219,6 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
>>  	rtl_rar_set(tp, mac_addr);
>>  }
>>  
>> -/* register is set if system vendor successfully tested ASPM 1.2 */
>> -static bool rtl_aspm_is_safe(struct rtl8169_private *tp)
>> -{
>> -	if (tp->mac_version >= RTL_GIGA_MAC_VER_61 &&
>> -	    r8168_mac_ocp_read(tp, 0xc0b2) & 0xf)
>> -		return true;
>> -
>> -	return false;
>> -}
>> -
>>  static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>  {
>>  	struct rtl8169_private *tp;
>> @@ -5302,19 +5290,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>  
>>  	tp->mac_version = chipset;
>>  
>> -	/* Disable ASPM L1 as that cause random device stop working
>> -	 * problems as well as full system hangs for some PCIe devices users.
>> -	 * Chips from RTL8168h partially have issues with L1.2, but seem
>> -	 * to work fine with L1 and L1.1.
>> -	 */
>> -	if (rtl_aspm_is_safe(tp))
>> -		rc = 0;
>> -	else if (tp->mac_version >= RTL_GIGA_MAC_VER_46)
>> -		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
>> -	else
>> -		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
>> -	tp->aspm_manageable = !rc;
> 
> This is beautiful.  But since this series still enables/disables ASPM
> using the chip-specific knobs, I have to ask whether this is all safe
> with respect to simultaneous arbitrary ASPM enable/disable via the
> sysfs knobs.  For example, it should be safe to run these loops
> indefinitely while the NIC is operating and doing NAPI polls:
> 
Good question, but: Realtek doesn't provide any chip data sheets,
therefore I can't say what the chip-specific knobs actually do.

>   DEV=/sys/bus/pci/devices/...
>   while /bin/true; do
>     echo 1 > $DEV/link/l1_2_aspm
>     echo 0 > $DEV/link/l1_2_aspm
>   done
>   while /bin/true; do
>     echo 1 > $DEV/link/l1_1_aspm
>     echo 0 > $DEV/link/l1_1_aspm
>   done
>   while /bin/true; do
>     echo 1 > $DEV/link/l1_aspm
>     echo 0 > $DEV/link/l1_aspm
>   done
> 
> Bjorn

