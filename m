Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03C83F1D37
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240695AbhHSPqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 11:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240703AbhHSPqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 11:46:12 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7891C0617AD;
        Thu, 19 Aug 2021 08:45:33 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k8so9806509wrn.3;
        Thu, 19 Aug 2021 08:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eQrASbfptxTsgIiNjID9TCI5OemXiRerL5FW550+aBQ=;
        b=NCpLY4tOdyODXAAXLPv57+hr5XJs6BA9L214LOe+c2mh0wDY3kTSmtO/H25Ct/rfJZ
         RiTC1I5SSgUZeinVXAIpwLqPBFSSbw2w89eq6dNIPXV6tPSOKrSBe1cuO/rbjWOU4f+i
         CU4nlBktoV3RvXYvgC5TQy4Umrw5bt/so/ZO4Dh76Twzk/Lywr0misnxoM57Vi3xI0kV
         Xs7r6RlqYTSFlE5g2uYBidnjxKByJfuyxPhKFbDGYPQyq8r0wFyDHASmStqo1+b5Hf2K
         UH5wIS+nE/bg65/xc0B/W6T47MgIRGS3QmThpYJlFJ7gR2wscdBkX6ivLPwnW2DrKNR0
         4eCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eQrASbfptxTsgIiNjID9TCI5OemXiRerL5FW550+aBQ=;
        b=oR0gV9pUiDI9o8y9yahI0ETmcwKNlNQ4n6jp5XErJr5MpGTcnc+2kmP3usTyhyU6iL
         u5m/bV73/e3JymV027o+pkaBNHX8wxYCziadISTa/udOFU18PrGKnjjPELsopHmKCmsg
         29KT1UF9JZNERXVg7q5WFNPQnVLBrwdcVhoJJbz9IJVYVxFarHiUHTnjCCXoBYrIPR9x
         mKJ3dS9Vuza5bn0wkubQN7WtOs6SxvhY0dOXalHBW8TK4WUV91qCMvhxD16RJT2mKHYw
         98cbYjEvxNB2F4saqIQdsDx00Z5C9bf/UllUwhcstQh+IJdPJ9vyX20Pc/PNkGg87tIK
         mXnA==
X-Gm-Message-State: AOAM532SE9HLiq7Ewt4qfAcJNrsVMrNI8gj4i8Oxj/xQk+UggmXeSH20
        xqeR63AKRtH2F/DOHjgThIjwtzNP1MVN5Q==
X-Google-Smtp-Source: ABdhPJxT9bhWLMaHuIQ1DKiSTj6CRoe+fwDKB54JJuAjl7hWeEfrA6jt4H2uuruVGWORO9WAnui/Dw==
X-Received: by 2002:adf:ffd2:: with SMTP id x18mr4627498wrs.184.1629387932085;
        Thu, 19 Aug 2021 08:45:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:c830:756b:68fa:7529? (p200300ea8f084500c830756b68fa7529.dip0.t-ipconnect.de. [2003:ea:8f08:4500:c830:756b:68fa:7529])
        by smtp.googlemail.com with ESMTPSA id f17sm3270085wrt.49.2021.08.19.08.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 08:45:31 -0700 (PDT)
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     nic_swsd@realtek.com, bhelgaas@google.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210819114223.GA3189268@bjorn-Precision-5520>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v3 1/3] r8169: Implement dynamic ASPM mechanism
Message-ID: <9ebf8fa1-cbd4-75d6-1099-1a45ca8b8bb0@gmail.com>
Date:   Thu, 19 Aug 2021 17:45:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210819114223.GA3189268@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.08.2021 13:42, Bjorn Helgaas wrote:
> On Thu, Aug 19, 2021 at 01:45:40PM +0800, Kai-Heng Feng wrote:
>> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
>> Same issue can be observed with older vendor drivers.
> 
> On some platforms but not on others?  Maybe the PCIe topology is a
> factor?  Do you have bug reports with data, e.g., "lspci -vv" output?
> 
>> The issue is however solved by the latest vendor driver. There's a new
>> mechanism, which disables r8169's internal ASPM when the NIC traffic has
>> more than 10 packets, and vice versa. 
> 
> Presumably there's a time interval related to the 10 packets?  For
> example, do you want to disable ASPM if 10 packets are received (or
> sent?) in a certain amount of time?
> 
>> The possible reason for this is
>> likely because the buffer on the chip is too small for its ASPM exit
>> latency.
> 
> Maybe this means the chip advertises incorrect exit latencies?  If so,
> maybe a quirk could override that?
> 
>> Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
>> use dynamic ASPM under Windows. So implement the same mechanism here to
>> resolve the issue.
> 
> What exactly is "dynamic ASPM"?
> 
> I see Heiner's comment about this being intended only for a downstream
> kernel.  But why?
> 
We've seen various more or less obvious symptoms caused by the broken
ASPM support on Realtek network chips. Unfortunately Realtek releases
neither datasheets nor errata information.
Last time we attempted to re-enable ASPM numerous problem reports came
in. These Realtek chips are used on basically every consumer mainboard.
The proposed workaround has potential side effects: In case of a
congestion in the chip it may take up to a second until ASPM gets
disabled, what may affect performance, especially in case of alternating
traffic patterns. Also we can't expect support from Realtek.
Having said that my decision was that it's too risky to re-enable ASPM
in mainline even with this workaround in place. Kai-Heng weights the
power saving higher and wants to take the risk in his downstream kernel.
If there are no problems downstream after few months, then this
workaround may make it to mainline.

>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
>> v3:
>>  - Use msecs_to_jiffies() for delay time
>>  - Use atomic_t instead of mutex for bh
>>  - Mention the buffer size and ASPM exit latency in commit message
>>
>> v2: 
>>  - Use delayed_work instead of timer_list to avoid interrupt context
>>  - Use mutex to serialize packet counter read/write
>>  - Wording change
>>
>>  drivers/net/ethernet/realtek/r8169_main.c | 44 ++++++++++++++++++++++-
>>  1 file changed, 43 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 7a69b468584a2..3359509c1c351 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -624,6 +624,10 @@ struct rtl8169_private {
>>  
>>  	unsigned supports_gmii:1;
>>  	unsigned aspm_manageable:1;
>> +	unsigned rtl_aspm_enabled:1;
>> +	struct delayed_work aspm_toggle;
>> +	atomic_t aspm_packet_count;
>> +
>>  	dma_addr_t counters_phys_addr;
>>  	struct rtl8169_counters *counters;
>>  	struct rtl8169_tc_offsets tc_offset;
>> @@ -2665,8 +2669,13 @@ static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)
>>  
>>  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>>  {
>> +	if (!tp->aspm_manageable && enable)
>> +		return;
>> +
>> +	tp->rtl_aspm_enabled = enable;
>> +
>>  	/* Don't enable ASPM in the chip if OS can't control ASPM */
>> -	if (enable && tp->aspm_manageable) {
>> +	if (enable) {
>>  		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
>>  		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
>>  	} else {
>> @@ -4415,6 +4424,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
>>  
>>  	dirty_tx = tp->dirty_tx;
>>  
>> +	atomic_add(tp->cur_tx - dirty_tx, &tp->aspm_packet_count);
>>  	while (READ_ONCE(tp->cur_tx) != dirty_tx) {
>>  		unsigned int entry = dirty_tx % NUM_TX_DESC;
>>  		u32 status;
>> @@ -4559,6 +4569,8 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
>>  		rtl8169_mark_to_asic(desc);
>>  	}
>>  
>> +	atomic_add(count, &tp->aspm_packet_count);
>> +
>>  	return count;
>>  }
>>  
>> @@ -4666,8 +4678,32 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
>>  	return 0;
>>  }
>>  
>> +#define ASPM_PACKET_THRESHOLD 10
>> +#define ASPM_TOGGLE_INTERVAL 1000
>> +
>> +static void rtl8169_aspm_toggle(struct work_struct *work)
>> +{
>> +	struct rtl8169_private *tp = container_of(work, struct rtl8169_private,
>> +						  aspm_toggle.work);
>> +	int packet_count;
>> +	bool enable;
>> +
>> +	packet_count = atomic_xchg(&tp->aspm_packet_count, 0);
>> +	enable = packet_count <= ASPM_PACKET_THRESHOLD;
>> +
>> +	if (tp->rtl_aspm_enabled != enable) {
>> +		rtl_unlock_config_regs(tp);
>> +		rtl_hw_aspm_clkreq_enable(tp, enable);
>> +		rtl_lock_config_regs(tp);
>> +	}
>> +
>> +	schedule_delayed_work(&tp->aspm_toggle, msecs_to_jiffies(ASPM_TOGGLE_INTERVAL));
>> +}
>> +
>>  static void rtl8169_down(struct rtl8169_private *tp)
>>  {
>> +	cancel_delayed_work_sync(&tp->aspm_toggle);
>> +
>>  	/* Clear all task flags */
>>  	bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
>>  
>> @@ -4694,6 +4730,8 @@ static void rtl8169_up(struct rtl8169_private *tp)
>>  	rtl_reset_work(tp);
>>  
>>  	phy_start(tp->phydev);
>> +
>> +	schedule_delayed_work(&tp->aspm_toggle, msecs_to_jiffies(ASPM_TOGGLE_INTERVAL));
>>  }
>>  
>>  static int rtl8169_close(struct net_device *dev)
>> @@ -5354,6 +5392,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>  
>>  	INIT_WORK(&tp->wk.work, rtl_task);
>>  
>> +	INIT_DELAYED_WORK(&tp->aspm_toggle, rtl8169_aspm_toggle);
>> +
>> +	atomic_set(&tp->aspm_packet_count, 0);
>> +
>>  	rtl_init_mac_address(tp);
>>  
>>  	dev->ethtool_ops = &rtl8169_ethtool_ops;
>> -- 
>> 2.32.0
>>

