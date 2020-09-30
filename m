Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7789527E1E1
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 08:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgI3Gyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 02:54:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:43531 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI3Gyo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 02:54:44 -0400
IronPort-SDR: XwhjWoHnujRo0JJkWMKVp5R/207w+qf+Z6QXtr38LgNGi4qBXPzFS/6Fl9dfxcTtCaacR9bHbt
 CZOQswWZKEtQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="150038965"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="150038965"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 23:54:43 -0700
IronPort-SDR: Gfpdp7Y9dMlx7b+VHP8NAWeVpmdwsnI1FQZmFMYAmSi2kInT4nF7ARrT3sm3njgd5TV4+i88SB
 KVj0xEirhEsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="294518632"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 29 Sep 2020 23:54:42 -0700
Received: from hasmsx603.ger.corp.intel.com (10.184.107.143) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 29 Sep 2020 23:54:41 -0700
Received: from [10.251.178.101] (10.184.70.1) by HASMSX603.ger.corp.intel.com
 (10.184.107.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 30 Sep
 2020 09:54:39 +0300
Subject: Re: [Intel-wired-lan] [PATCH v4] e1000e: Increase polling timeout on
 MDIC ready bit
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
References: <20200924164542.19906-1-kai.heng.feng@canonical.com>
 <20200928083658.8567-1-kai.heng.feng@canonical.com>
 <469c71d5-93ac-e6c7-f85c-342b0df78a45@intel.com>
 <30761C6B-28B8-4464-8615-55EF3E090E07@canonical.com>
 <345fffcd-e9f1-5881-fba1-d7313876e943@intel.com>
 <3DA721C5-F656-4085-9113-A0407CDF90FB@canonical.com>
From:   Vitaly Lifshits <vitaly.lifshits@intel.com>
Message-ID: <adb2f604-8c98-8799-6ed1-b8889b8cd0f6@intel.com>
Date:   Wed, 30 Sep 2020 09:54:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <3DA721C5-F656-4085-9113-A0407CDF90FB@canonical.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.70.1]
X-ClientProxiedBy: lcsmsx601.ger.corp.intel.com (10.109.210.10) To
 HASMSX603.ger.corp.intel.com (10.184.107.143)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/2020 18:08, Kai-Heng Feng wrote:

Hello Kai-Heng,
> 
> 
>> On Sep 29, 2020, at 21:46, Neftin, Sasha <sasha.neftin@intel.com> wrote:
>>
>> Hello Kai-Heng,
>> On 9/29/2020 16:31, Kai-Heng Feng wrote:
>>> Hi Sasha,
>>>> On Sep 29, 2020, at 21:08, Neftin, Sasha <sasha.neftin@intel.com> wrote:
>>>>
>>>> On 9/28/2020 11:36, Kai-Heng Feng wrote:
>>>>> We are seeing the following error after S3 resume:
>>>>> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>>>>> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
>>>>> [  704.902817] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>>>>> [  704.903075] e1000e 0000:00:1f.6 eno1: reading PHY page 769 (or 0x6020 shifted) reg 0x17
>>>>> [  704.903281] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>>>>> [  704.903486] e1000e 0000:00:1f.6 eno1: writing PHY page 769 (or 0x6020 shifted) reg 0x17
>>>>> [  704.943155] e1000e 0000:00:1f.6 eno1: MDI Error
>>>>> ...
>>>>> [  705.108161] e1000e 0000:00:1f.6 eno1: Hardware Error
>>>>> As Andrew Lunn pointed out, MDIO has nothing to do with phy, and indeed
>>>>> increase polling iteration can resolve the issue.
>>>>> This patch only papers over the symptom, as we don't really know the
>>>>> root cause of the issue. The most possible culprit is Intel ME, which
>>>>> may do its own things that conflict with software.
>>>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>>>> ---
>>>>> v4:
>>>>>   - States that this patch just papers over the symptom.
>>>>> v3:
>>>>>   - Moving delay to end of loop doesn't save anytime, move it back.
>>>>>   - Point out this is quitely likely caused by Intel ME.
>>>>> v2:
>>>>>   - Increase polling iteration instead of powering down the phy.
>>>>>   drivers/net/ethernet/intel/e1000e/phy.c | 2 +-
>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>> diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
>>>>> index e11c877595fb..e6d4acd90937 100644
>>>>> --- a/drivers/net/ethernet/intel/e1000e/phy.c
>>>>> +++ b/drivers/net/ethernet/intel/e1000e/phy.c
>>>>> @@ -203,7 +203,7 @@ s32 e1000e_write_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 data)
>>>>>   	 * Increasing the time out as testing showed failures with
>>>>>   	 * the lower time out
>>>>>   	 */
>>>>> -	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
>>>>> +	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 10); i++) {
>>>> As we discussed (many threads) - AMT/ME systems not supported on Linux as properly. I do not think increasing polling iteration will solve the problem. Rather mask it.
>>> I am aware of the status quo of no proper support on Intel ME.
>>>> I prefer you check option to disable ME vi BIOS on your system.
>>> We can't ask user to change the BIOS to accommodate Linux. So before a proper solution comes out, masking the problem is good enough for me.
>>> Until then, I'll carry it as a downstream distro patch.
>> What will you do with system that even after increasing polling time will run into HW error?
> 
> Hope we finally have proper ME support under Linux?
> 
> Kai-Heng
> 
>>> Kai-Heng
>>>>>   		udelay(50);
>>>>>   		mdic = er32(MDIC);
>>>>>   		if (mdic & E1000_MDIC_READY)
>>>> Thanks,
>>>> Sasha
>> Thanks,
>> Sasha
> 

On which device ID/platform do you see the issue? What is the Firmware 
version on your platform? What is the ME firmware version that you have?

I am asking these questions, since I know there is supposed to be a fix 
in the firmware to many issues that are related to ME and device 
interoperability.

Thanks,

Vitaly
