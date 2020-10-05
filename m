Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A025283056
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 08:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgJEGYE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 5 Oct 2020 02:24:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55324 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgJEGYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 02:24:04 -0400
Received: from mail-pj1-f70.google.com ([209.85.216.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kPJuj-0002lu-Ie
        for netdev@vger.kernel.org; Mon, 05 Oct 2020 06:24:01 +0000
Received: by mail-pj1-f70.google.com with SMTP id m3so883465pjg.0
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 23:24:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=On9/o/TdMtEJnMs6mNj8Zxe3/XpxeHUB6X2k3tQLabY=;
        b=n3OKvNA6ME3ZF7qzBzNSfnfY6HD8AsDqu3X7tL0JbY0CvPlXNhrzQ/RyzqUoI0f3Lm
         qYe4tyEwzxCC+4D++CsgcnhDP5XzBgoZFWyBhf8ChZ4l7dC8Td//UPw8WGTmUjf49poL
         9Yu4e8BrdeBqRVazsshaVpxOMCd9OC5T/7pdyU0rpI/MqDvUaOgTQGLgoU6+p87kd1SU
         ZhMLbgeKOYu3iAWjTUEEmPWpYDU3CuuLLkpm7c8zfTNApDv1xm6CfhPQMT6DqQY8eylA
         CBOtuCeGTXagJDtyb83NNR0mUL6EpRcMvyLNQMMHlGFlqfvvFUQE3RK4xjojMzXZWgtS
         7jXg==
X-Gm-Message-State: AOAM5337gHJ5jQzDVsW8sMnWEmSO6O+/0DZGwwZYTsn2iJPcuFCPD9a4
        eClN79sRzDR9JDwaN/qzra5yB+qUWpg5GFVQDaMx3l7So46bFQ+/gTfUsJNrjum8BzyfKYL63UZ
        3LuQyj9KOiXot9t+f8BZQly//v8FoFNkUEQ==
X-Received: by 2002:a62:1410:0:b029:13e:d13d:a129 with SMTP id 16-20020a6214100000b029013ed13da129mr15524199pfu.17.1601879039865;
        Sun, 04 Oct 2020 23:23:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwj86RHXCI8tLUf5xVY+qSZRCtIeIlhl7QK6o6CLyjeCqdInuvdVQhRQHa/EguNW+tUS0aZJQ==
X-Received: by 2002:a62:1410:0:b029:13e:d13d:a129 with SMTP id 16-20020a6214100000b029013ed13da129mr15524146pfu.17.1601879039461;
        Sun, 04 Oct 2020 23:23:59 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id z23sm10891534pfj.177.2020.10.04.23.23.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2020 23:23:58 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [Intel-wired-lan] [PATCH v4] e1000e: Increase polling timeout on
 MDIC ready bit
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <adb2f604-8c98-8799-6ed1-b8889b8cd0f6@intel.com>
Date:   Mon, 5 Oct 2020 14:23:55 +0800
Cc:     "Neftin, Sasha" <sasha.neftin@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <D37AEA82-9BA5-4CE0-8859-F8E7054895B3@canonical.com>
References: <20200924164542.19906-1-kai.heng.feng@canonical.com>
 <20200928083658.8567-1-kai.heng.feng@canonical.com>
 <469c71d5-93ac-e6c7-f85c-342b0df78a45@intel.com>
 <30761C6B-28B8-4464-8615-55EF3E090E07@canonical.com>
 <345fffcd-e9f1-5881-fba1-d7313876e943@intel.com>
 <3DA721C5-F656-4085-9113-A0407CDF90FB@canonical.com>
 <adb2f604-8c98-8799-6ed1-b8889b8cd0f6@intel.com>
To:     Vitaly Lifshits <vitaly.lifshits@intel.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vitaly,

> On Sep 30, 2020, at 14:54, Vitaly Lifshits <vitaly.lifshits@intel.com> wrote:
> 
> On 9/29/2020 18:08, Kai-Heng Feng wrote:
> 
> Hello Kai-Heng,
>>> On Sep 29, 2020, at 21:46, Neftin, Sasha <sasha.neftin@intel.com> wrote:
>>> 
>>> Hello Kai-Heng,
>>> On 9/29/2020 16:31, Kai-Heng Feng wrote:
>>>> Hi Sasha,
>>>>> On Sep 29, 2020, at 21:08, Neftin, Sasha <sasha.neftin@intel.com> wrote:
>>>>> 
>>>>> On 9/28/2020 11:36, Kai-Heng Feng wrote:
>>>>>> We are seeing the following error after S3 resume:
>>>>>> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>>>>>> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
>>>>>> [  704.902817] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>>>>>> [  704.903075] e1000e 0000:00:1f.6 eno1: reading PHY page 769 (or 0x6020 shifted) reg 0x17
>>>>>> [  704.903281] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>>>>>> [  704.903486] e1000e 0000:00:1f.6 eno1: writing PHY page 769 (or 0x6020 shifted) reg 0x17
>>>>>> [  704.943155] e1000e 0000:00:1f.6 eno1: MDI Error
>>>>>> ...
>>>>>> [  705.108161] e1000e 0000:00:1f.6 eno1: Hardware Error
>>>>>> As Andrew Lunn pointed out, MDIO has nothing to do with phy, and indeed
>>>>>> increase polling iteration can resolve the issue.
>>>>>> This patch only papers over the symptom, as we don't really know the
>>>>>> root cause of the issue. The most possible culprit is Intel ME, which
>>>>>> may do its own things that conflict with software.
>>>>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>>>>> ---
>>>>>> v4:
>>>>>>  - States that this patch just papers over the symptom.
>>>>>> v3:
>>>>>>  - Moving delay to end of loop doesn't save anytime, move it back.
>>>>>>  - Point out this is quitely likely caused by Intel ME.
>>>>>> v2:
>>>>>>  - Increase polling iteration instead of powering down the phy.
>>>>>>  drivers/net/ethernet/intel/e1000e/phy.c | 2 +-
>>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>> diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
>>>>>> index e11c877595fb..e6d4acd90937 100644
>>>>>> --- a/drivers/net/ethernet/intel/e1000e/phy.c
>>>>>> +++ b/drivers/net/ethernet/intel/e1000e/phy.c
>>>>>> @@ -203,7 +203,7 @@ s32 e1000e_write_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 data)
>>>>>>  	 * Increasing the time out as testing showed failures with
>>>>>>  	 * the lower time out
>>>>>>  	 */
>>>>>> -	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
>>>>>> +	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 10); i++) {
>>>>> As we discussed (many threads) - AMT/ME systems not supported on Linux as properly. I do not think increasing polling iteration will solve the problem. Rather mask it.
>>>> I am aware of the status quo of no proper support on Intel ME.
>>>>> I prefer you check option to disable ME vi BIOS on your system.
>>>> We can't ask user to change the BIOS to accommodate Linux. So before a proper solution comes out, masking the problem is good enough for me.
>>>> Until then, I'll carry it as a downstream distro patch.
>>> What will you do with system that even after increasing polling time will run into HW error?
>> Hope we finally have proper ME support under Linux?
>> Kai-Heng
>>>> Kai-Heng
>>>>>>  		udelay(50);
>>>>>>  		mdic = er32(MDIC);
>>>>>>  		if (mdic & E1000_MDIC_READY)
>>>>> Thanks,
>>>>> Sasha
>>> Thanks,
>>> Sasha
> 
> On which device ID/platform do you see the issue?

HP Z4 G4 Workstation,
00:1f.6 Ethernet controller [0200]: Intel Corporation Ethernet Connection (2) I219-LM [8086:15b7]

> What is the Firmware version on your platform?

BIOS version: P61 v02.59


> What is the ME firmware version that you have?

ME version: 11.11.50.1422
ME mode: AMT disable

Kai-Heng

> 
> I am asking these questions, since I know there is supposed to be a fix in the firmware to many issues that are related to ME and device interoperability.
> 
> Thanks,
> 
> Vitaly

