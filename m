Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540DF27D22A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbgI2PIe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Sep 2020 11:08:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37301 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728492AbgI2PId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 11:08:33 -0400
Received: from mail-pj1-f72.google.com ([209.85.216.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kNHF1-000575-0S
        for netdev@vger.kernel.org; Tue, 29 Sep 2020 15:08:31 +0000
Received: by mail-pj1-f72.google.com with SMTP id r1so3549190pjp.5
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 08:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=QlTx6aJc1D++8TL3j2iwVRwTgFTiw+vWij/OcnAzmKQ=;
        b=M/JT1TKV95rBJ2v3MBf1N+KM2cFl0KIUi/5PkgRrQgPnvFr7K2Zif4eBhm987Ljcp+
         C5xd7CyByB51Yc90yVmqnNA+MrN/VMh9LxkE/MqyMTRlZ2UvFeRDevNy0y0E0XGtj6IE
         0SVz1Eg9/ilQXAZzPIL3Uz7/Y/ubMi28JoTgxj6xp6W+rHr3BLC+T+UoWNj+kVCR+YVf
         Lp19Kgrv7XuzzttNqi0MQGi2ylnIuGq995Anuj8Fty+Ry6dYMZ+OBAD/EoBcgObTcyaM
         mEsBFi8oahja4VoN4sRJAw3sQVwKutSI0RR5zHLRW6ERIVwvNL1uXeEF7TWwmJT8qw0W
         g/oQ==
X-Gm-Message-State: AOAM531PSOo/aUXiycLFAU2pLrLEawBt2QXAALvLNx+v1HsS9+rQsqqG
        ugXXEDDaKhc5luBT4Kj6UpYrAI96XFHOwEKuXlTyM9B/UTtrukFfp/ijmgvvWl3x+WG3MCEfcEf
        fjZAN7flYjR2S9/XfOclPKvLnWrKrZpwiIA==
X-Received: by 2002:a63:4c4e:: with SMTP id m14mr3370898pgl.199.1601392109526;
        Tue, 29 Sep 2020 08:08:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxotBxEPfO2A7Zw2hT2M3MgeYjDoKR1OQVz5gvxGY1sHqup/qknE2eGfjCc967g+jDuC3NmzQ==
X-Received: by 2002:a63:4c4e:: with SMTP id m14mr3370864pgl.199.1601392109063;
        Tue, 29 Sep 2020 08:08:29 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id t6sm5040797pgj.86.2020.09.29.08.08.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 08:08:27 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [Intel-wired-lan] [PATCH v4] e1000e: Increase polling timeout on
 MDIC ready bit
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <345fffcd-e9f1-5881-fba1-d7313876e943@intel.com>
Date:   Tue, 29 Sep 2020 23:08:23 +0800
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <3DA721C5-F656-4085-9113-A0407CDF90FB@canonical.com>
References: <20200924164542.19906-1-kai.heng.feng@canonical.com>
 <20200928083658.8567-1-kai.heng.feng@canonical.com>
 <469c71d5-93ac-e6c7-f85c-342b0df78a45@intel.com>
 <30761C6B-28B8-4464-8615-55EF3E090E07@canonical.com>
 <345fffcd-e9f1-5881-fba1-d7313876e943@intel.com>
To:     "Neftin, Sasha" <sasha.neftin@intel.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 29, 2020, at 21:46, Neftin, Sasha <sasha.neftin@intel.com> wrote:
> 
> Hello Kai-Heng,
> On 9/29/2020 16:31, Kai-Heng Feng wrote:
>> Hi Sasha,
>>> On Sep 29, 2020, at 21:08, Neftin, Sasha <sasha.neftin@intel.com> wrote:
>>> 
>>> On 9/28/2020 11:36, Kai-Heng Feng wrote:
>>>> We are seeing the following error after S3 resume:
>>>> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>>>> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
>>>> [  704.902817] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>>>> [  704.903075] e1000e 0000:00:1f.6 eno1: reading PHY page 769 (or 0x6020 shifted) reg 0x17
>>>> [  704.903281] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>>>> [  704.903486] e1000e 0000:00:1f.6 eno1: writing PHY page 769 (or 0x6020 shifted) reg 0x17
>>>> [  704.943155] e1000e 0000:00:1f.6 eno1: MDI Error
>>>> ...
>>>> [  705.108161] e1000e 0000:00:1f.6 eno1: Hardware Error
>>>> As Andrew Lunn pointed out, MDIO has nothing to do with phy, and indeed
>>>> increase polling iteration can resolve the issue.
>>>> This patch only papers over the symptom, as we don't really know the
>>>> root cause of the issue. The most possible culprit is Intel ME, which
>>>> may do its own things that conflict with software.
>>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>>> ---
>>>> v4:
>>>>  - States that this patch just papers over the symptom.
>>>> v3:
>>>>  - Moving delay to end of loop doesn't save anytime, move it back.
>>>>  - Point out this is quitely likely caused by Intel ME.
>>>> v2:
>>>>  - Increase polling iteration instead of powering down the phy.
>>>>  drivers/net/ethernet/intel/e1000e/phy.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>> diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
>>>> index e11c877595fb..e6d4acd90937 100644
>>>> --- a/drivers/net/ethernet/intel/e1000e/phy.c
>>>> +++ b/drivers/net/ethernet/intel/e1000e/phy.c
>>>> @@ -203,7 +203,7 @@ s32 e1000e_write_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 data)
>>>>  	 * Increasing the time out as testing showed failures with
>>>>  	 * the lower time out
>>>>  	 */
>>>> -	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
>>>> +	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 10); i++) {
>>> As we discussed (many threads) - AMT/ME systems not supported on Linux as properly. I do not think increasing polling iteration will solve the problem. Rather mask it.
>> I am aware of the status quo of no proper support on Intel ME.
>>> I prefer you check option to disable ME vi BIOS on your system.
>> We can't ask user to change the BIOS to accommodate Linux. So before a proper solution comes out, masking the problem is good enough for me.
>> Until then, I'll carry it as a downstream distro patch.
> What will you do with system that even after increasing polling time will run into HW error?

Hope we finally have proper ME support under Linux?

Kai-Heng

>> Kai-Heng
>>>>  		udelay(50);
>>>>  		mdic = er32(MDIC);
>>>>  		if (mdic & E1000_MDIC_READY)
>>> Thanks,
>>> Sasha
> Thanks,
> Sasha

