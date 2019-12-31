Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F422312D5C7
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 03:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfLaCWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 21:22:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfLaCWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 21:22:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=58v/ii0gXmhprKWGTsyF0arcFN3stGWSym0mBK9JFjs=; b=hxr4BDI6FxfK5HLfr82SeUKc1
        FrWVE4KJov7sXIoQgeGU0QRUUdULRJE/lfe+g5B5o1i5mkZn4pTt+SRDRW/gMRGyIBj0YmXVAbWyN
        tna05XxbJzTlSMgInkLWWeKhS1N9kV3hg2nagHYivpr27coS3OOAljbxfOnuWndHU1yN+ira1rBoG
        cexVQ3rJYoIOd9pHmXyWk+TjFBoL1nRJbS1yQLZ4cv5b37SI2Sx7cCJtuxqePfLnh6mUBrayuwiL0
        UyfzV0v5wPSmdgR8U2vqoEZNBD1N5NXglw4dTC+KObm+OsMAg0iscur/KXlPVgyyvhAIsHnuoXc/h
        xyt0HpK+w==;
Received: from [2601:1c0:6280:3f0::34d9]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1im7B6-00075R-5O; Tue, 31 Dec 2019 02:22:36 +0000
Subject: Re: [PATCH] stmmac: debugfs entry name is not be changed when udev
 rename device name.
To:     Jiping Ma <Jiping.Ma2@windriver.com>, peppe.cavallaro@st.com,
        alexandre.torgue@st.com
Cc:     joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
References: <20191231020302.71792-1-jiping.ma2@windriver.com>
 <5b10a5ff-8428-48c7-a60d-69dd62009716@infradead.org>
 <719d8dd3-0119-0c93-b299-d2b3d66b1e06@windriver.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <adc6d2bc-a92c-703f-2e27-d905c6322c17@infradead.org>
Date:   Mon, 30 Dec 2019 18:22:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <719d8dd3-0119-0c93-b299-d2b3d66b1e06@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30/19 6:16 PM, Jiping Ma wrote:
> 
> 
> On 12/31/2019 10:11 AM, Randy Dunlap wrote:
>> Hi,
>>
>> On 12/30/19 6:03 PM, Jiping Ma wrote:
>>> Add one notifier for udev changes net device name.
>>>
>>> Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
>>> ---
>>>   .../net/ethernet/stmicro/stmmac/stmmac_main.c | 38 ++++++++++++++++++-
>>>   1 file changed, 37 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>> index b14f46a57154..c1c877bb4421 100644
>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>> @@ -4038,6 +4038,40 @@ static int stmmac_dma_cap_show(struct seq_file *seq, void *v)
>>>   }
>>>   DEFINE_SHOW_ATTRIBUTE(stmmac_dma_cap);
>>>   +/**
>> Just use /* here since this is not a kernel-doc comment.
>> /** is reserved for kernel-doc comments/notation.
> I use checkpatch.pl to check my patch, it show one warning, then I change * to **.   I will change it back to *.

It should be more like:

/* Use network device events to create/remove/rename
 * debugfs file entries.
 */

> WARNING: networking block comments don't use an empty /* line, use /* Comment...
> #23: FILE: drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:4042:
> +/*
> + * Use network device events to create/remove/rename
>>
>>> + * Use network device events to create/remove/rename
>>> + * debugfs file entries
>>> + */
>>> +static int stmmac_device_event(struct notifier_block *unused,
>>> +                   unsigned long event, void *ptr)
>>> +{
>>


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
