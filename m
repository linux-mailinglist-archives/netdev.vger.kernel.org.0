Return-Path: <netdev+bounces-7606-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EF0A720D4F
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 04:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5A1C1C2125B
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 02:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ADBDC12B;
	Sat,  3 Jun 2023 02:35:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E10CC128
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 02:35:55 +0000 (UTC)
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 269E0E41;
	Fri,  2 Jun 2023 19:35:52 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.116])
	by gateway (Coremail) with SMTP id _____8Bx3+sHp3pkddQDAA--.8080S3;
	Sat, 03 Jun 2023 10:35:51 +0800 (CST)
Received: from [10.20.42.116] (unknown [10.20.42.116])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxMuUGp3pkSMKGAA--.19982S3;
	Sat, 03 Jun 2023 10:35:50 +0800 (CST)
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Liu Peibao <liupeibao@loongson.cn>, Bjorn Helgaas <helgaas@kernel.org>,
 linux-pci@vger.kernel.org, netdev@vger.kernel.org,
 Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
 Claudiu Manoil <claudiu.manoil@nxp.com>, Michael Walle <michael@walle.cc>,
 linux-kernel@vger.kernel.org, Binbin Zhou <zhoubinbin@loongson.cn>,
 Huacai Chen <chenhuacai@loongson.cn>
References: <20230601163335.6zw4ojbqxz2ws6vx@skbuf>
 <ZHjaq+TDW/RFcoxW@bhelgaas> <20230601221532.2rfcda4sg5nl7pzp@skbuf>
 <dc430271-8511-e6e4-041b-ede197e7665d@loongson.cn>
 <7a7f78ae-7fd8-b68d-691c-609a38ab3161@loongson.cn>
 <20230602101628.jkgq3cmwccgsfb4c@skbuf>
From: Jianmin Lv <lvjianmin@loongson.cn>
Message-ID: <87f2b231-2e16-e7b8-963b-fc86c407bc96@loongson.cn>
Date: Sat, 3 Jun 2023 10:35:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230602101628.jkgq3cmwccgsfb4c@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxMuUGp3pkSMKGAA--.19982S3
X-CM-SenderInfo: 5oymxthqpl0qxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7ur18Zr4rJF13Ww1UWw1ftFb_yoW8ArW3p3
	y3AFyFkFs8KFsFkw1qqw4rWa4Yyr48t3s5Wr4DWrn7u398X348tw4Ikw4Yga9rCw4xK3W2
	vayYqF4xCFWqyFJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
	bxkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
	1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwA2z4
	x0Y4vEx4A2jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64
	kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04
	k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18
	MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr4
	1lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1l
	IxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4
	A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zwZ7UUUUU==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/6/2 下午6:16, Vladimir Oltean wrote:
> Hi Jianmin,
> 
> On Fri, Jun 02, 2023 at 03:36:18PM +0800, Jianmin Lv wrote:
>> On 2023/6/2 下午3:21, Liu Peibao wrote:
>>> Hi all,
>>>
>>> It seems that modification for current PCI enumeration framework is
>>> needed to solve the problem. If the effect of this modification is not
>>> easy to evaluate, for the requirement of Loongson, it should be OK that
>>> do the things in Loongson PCI controller driver like discussed
>>> before[1].
>>>
>>> Br,
>>> Peibao
>>>
>>> [1] https://lore.kernel.org/all/20221114074346.23008-1-liupeibao@loongson.cn/
>>>
>>
>> Agree. For current pci core code, all functions of the device will be
>> skipped if function 0 is not found, even without the patch 6fffbc7ae137
>> (e.g. the func 0 is disabled in bios by setting pci header to 0xffffffff).
>> So it seems that there are two ways for the issue:
>>
>> 1. Adjust the pci scan core code to allow separate function to be
>> enumerated, which will affect widely the pci core code.
>> 2. Only Adjust loongson pci controller driver as Peibao said, and any
>> function of the device should use platform device in DT if function 0 is
>> disabled, which is acceptable for loongson.
>>
>> Thanks,
>> Jianmin
> 
> How about 3. handle of_device_is_available() in the probe function of
> the "loongson, pci-gmac" driver? Would that not work?
> 
This way does work only for the specified device. There are other 
devices, such as HDA, I2S, etc, which have shared pins. Then we have to 
add of_device_is_available() checking to those drivers one by one. And 
we are not sure if there are other devices in new generation chips in 
future. So I'm afraid that the way you mentioned is not suitable for us.

Thanks,
Jianmin


