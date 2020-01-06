Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74134130B81
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 02:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgAFBbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 20:31:18 -0500
Received: from mail1.windriver.com ([147.11.146.13]:58892 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgAFBbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 20:31:17 -0500
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail1.windriver.com (8.15.2/8.15.2) with ESMTPS id 0061UvG4010178
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=FAIL);
        Sun, 5 Jan 2020 17:30:57 -0800 (PST)
Received: from [128.224.162.195] (128.224.162.195) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server id 14.3.468.0; Sun, 5 Jan 2020
 17:30:56 -0800
Subject: Re: [PATCH] stmmac: debugfs entry name is not be changed when udev
 rename device name.
To:     David Miller <davem@davemloft.net>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, ytao <yue.tao@windriver.com>
References: <20200102013544.19271-1-jiping.ma2@windriver.com>
 <20200104.201833.91020607861340266.davem@davemloft.net>
From:   Jiping Ma <Jiping.Ma2@windriver.com>
Message-ID: <dd27bae8-46d0-6802-90b9-475d8489d528@windriver.com>
Date:   Mon, 6 Jan 2020 09:30:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.0
MIME-Version: 1.0
In-Reply-To: <20200104.201833.91020607861340266.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/05/2020 12:18 PM, David Miller wrote:
> From: Jiping Ma <jiping.ma2@windriver.com>
> Date: Thu, 2 Jan 2020 09:35:44 +0800
>
>> Add one notifier for udev changes net device name.
>>
>> Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
>> ---
>>   .../net/ethernet/stmicro/stmmac/stmmac_main.c | 28 +++++++++++++++++++
>>   1 file changed, 28 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index b14f46a57154..3b05cb80eed7 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -4038,6 +4038,31 @@ static int stmmac_dma_cap_show(struct seq_file *seq, void *v)
>>   }
>>   DEFINE_SHOW_ATTRIBUTE(stmmac_dma_cap);
>>   
>> +/* Use network device events to rename debugfs file entries.
>> + */
>> +static int stmmac_device_event(struct notifier_block *unused,
>> +			       unsigned long event, void *ptr)
>> +{
>> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>> +	struct stmmac_priv *priv = netdev_priv(dev);
>> +
>> +	switch (event) {
>> +	case NETDEV_CHANGENAME:
> This notifier gets called for every single netdevice in the entire
> system.
>
> You cannot just assume that the device that gets passed in here is
> an stmmac device.
>
> Look at how other drivers handle this to see how to do it correctly.
>
> Thank you.
Thanks to remind.  I will modify it and send it review again.
>

