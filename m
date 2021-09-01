Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091933FE2C1
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 21:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245632AbhIATIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 15:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhIATIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 15:08:48 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34997C061575;
        Wed,  1 Sep 2021 12:07:51 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id m2so551483wmm.0;
        Wed, 01 Sep 2021 12:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VlxpC9lDcNfm5/MrHEbTwt24xdblO89YiUemKXyk9E0=;
        b=HXzvWAWkwzbfgkwgM/JalnBWgV47/Ad35YKCpSZOHXL1fHob+hWFTdCBbczPz0WUTH
         pMMHfc6kzxXoxT8dCbbpgN3jhQdoDHnI4e9t9NnYdcm+u7qyhV76x0rcQji3mgq2eSea
         vn34Io8AkUNtY7nUsi+AfG2uHEVvjKK44MaFf2uoS0qzlLKuQlhMYP95dpApSqEGhrCp
         YmaBo0QplNTfZzZJOI6ypi3Q4W0zQZE6ZmLW5JhVhtZ+6V7Auh2G/NGbDmSpji5J/nzn
         p4XrK/7G6sl/J2dg7EheEvU9ImDQfydLuogcyNhoM+lVxGRgYV6UcFoGBfB4byDw5qAH
         484g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VlxpC9lDcNfm5/MrHEbTwt24xdblO89YiUemKXyk9E0=;
        b=BdILeyNCrZVlk7v+8NchsYdeoivdR6CdCv5jXDKdlmImElYnaiZt+Y4achTr3bOycu
         MTCfnRYIgyVM2+75gr70+DI/yEXPozeINg7HwtbbEPaJLVluvzv7JoR8qxzuRKnrSkoS
         N3aGKUS98bGJTtE6JryTaGWVGtW7J9/s4AmhTW+s1p1kCfHxu7I4S6FM3fE5f7rZ2xAo
         a+hUugrTEctfU0uczKDlA1g5c05dwS3qU/PIRAE0pFxZnb2hTaL4QSdh+OXtG1o6JC5g
         qJT8WEVxxB1peBG+knE2IXWT4MDLf08zqgRiREofU+R+OdFwZ199ZCvsf0DP89vA7SEy
         0TEg==
X-Gm-Message-State: AOAM533pUfIsaUE/U5nHb63QUO5Yts+NPqb4DiFWj/DgHc9F4EyEPJl6
        Xrn+npPMgzMSdw3lykvMsIRXV1XyV8A=
X-Google-Smtp-Source: ABdhPJxSZZGUgVWnZkWdhRw0jGWmjP1Uu9GgKWAOMmDEZ1X8omYDe5qEq9dPb23dMFGI19ElKsFt5w==
X-Received: by 2002:a7b:cc0a:: with SMTP id f10mr957580wmh.32.1630523269835;
        Wed, 01 Sep 2021 12:07:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:58da:e5eb:c867:1a2c? (p200300ea8f08450058dae5ebc8671a2c.dip0.t-ipconnect.de. [2003:ea:8f08:4500:58da:e5eb:c867:1a2c])
        by smtp.googlemail.com with ESMTPSA id x18sm306969wrw.19.2021.09.01.12.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 12:07:49 -0700 (PDT)
To:     Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20210830123704.221494-1-verdre@v0yd.nl>
 <20210830123704.221494-2-verdre@v0yd.nl>
 <CAHp75VeAKs=nFw4E20etKc3C_Cszyz9AqN=mLsum7F-BdVK5Rg@mail.gmail.com>
 <7e38931e-2f1c-066e-088e-b27b56c1245c@v0yd.nl>
 <20210901155110.xgje2qrtq65loawh@pali>
 <985049b8-bad7-6f18-c94f-368059dd6f95@gmail.com>
 <f293c619399ba8bd60240879a20ee34db1248255.camel@sipsolutions.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
Message-ID: <eb555433-ade1-e89e-30e4-f4c1c24c25e7@gmail.com>
Date:   Wed, 1 Sep 2021 21:07:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f293c619399ba8bd60240879a20ee34db1248255.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.09.2021 19:07, Johannes Berg wrote:
> On Wed, 2021-09-01 at 18:51 +0200, Heiner Kallweit wrote:
>> On 01.09.2021 17:51, Pali Rohár wrote:
>>> On Wednesday 01 September 2021 16:01:54 Jonas Dreßler wrote:
>>>> On 8/30/21 2:49 PM, Andy Shevchenko wrote:
>>>>> On Mon, Aug 30, 2021 at 3:38 PM Jonas Dreßler <verdre@v0yd.nl> wrote:
>>>>>>
>>>>>> On the 88W8897 card it's very important the TX ring write pointer is
>>>>>> updated correctly to its new value before setting the TX ready
>>>>>> interrupt, otherwise the firmware appears to crash (probably because
>>>>>> it's trying to DMA-read from the wrong place).
>>>>>>
>>
>> This sounds somehow like the typical case where you write DMA descriptors
>> and then ring the doorbell. This normally requires a dma_wmb().
>> Maybe something like that is missing here?
> 
> But it looks like this "TX ring write pointer" is actually the register?
> 
> However, I would agree that doing it in mwifiex_write_reg() is possibly
> too big a hammer - could be done only for reg->tx_wrptr, not all the
> registers?
> 
> Actually, can two writes actually cross on PCI?
> 
> johannes
> 

In case we're talking about the following piece of code both register
writes are IOMEM writes that are ordered. Maybe the writes arrive properly
ordered but some chip-internal delays cause the issue? Then the read-back
would be something like an ordinary udelay()?
Instead of always reading back register writes, is it sufficient to read
an arbitrary register after mwifiex_write_reg(adapter, reg->tx_wrptr ?


		/* Write the TX ring write pointer in to reg->tx_wrptr */
		if (mwifiex_write_reg(adapter, reg->tx_wrptr,
				      card->txbd_wrptr | rx_val)) {
			mwifiex_dbg(adapter, ERROR,
				    "SEND DATA: failed to write reg->tx_wrptr\n");
			ret = -1;
			goto done_unmap;
		}
		if ((mwifiex_pcie_txbd_not_full(card)) &&
		    tx_param->next_pkt_len) {
			/* have more packets and TxBD still can hold more */
			mwifiex_dbg(adapter, DATA,
				    "SEND DATA: delay dnld-rdy interrupt.\n");
			adapter->data_sent = false;
		} else {
			/* Send the TX ready interrupt */
			if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
					      CPU_INTR_DNLD_RDY)) {
