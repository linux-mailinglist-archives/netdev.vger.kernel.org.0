Return-Path: <netdev+bounces-7821-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50E18721B58
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 02:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4F651C20A75
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 00:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42652379;
	Mon,  5 Jun 2023 00:59:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359CC19B
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 00:59:27 +0000 (UTC)
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC620B8;
	Sun,  4 Jun 2023 17:59:24 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.116])
	by gateway (Coremail) with SMTP id _____8AxhPBrM31kzHcEAA--.9081S3;
	Mon, 05 Jun 2023 08:59:23 +0800 (CST)
Received: from [10.20.42.116] (unknown [10.20.42.116])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxWdJrM31kxQeKAA--.24862S3;
	Mon, 05 Jun 2023 08:59:23 +0800 (CST)
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
 <87f2b231-2e16-e7b8-963b-fc86c407bc96@loongson.cn>
 <20230604085500.ioaos3ydehvqq24i@skbuf>
From: Jianmin Lv <lvjianmin@loongson.cn>
Message-ID: <ad969019-e763-b06f-d557-be4e672c68db@loongson.cn>
Date: Mon, 5 Jun 2023 08:59:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230604085500.ioaos3ydehvqq24i@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxWdJrM31kxQeKAA--.24862S3
X-CM-SenderInfo: 5oymxthqpl0qxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7tr4rWFyUuF1kAFW7XFyxZrb_yoW8CF43pa
	y3AFWFkF4kKr4Ik3sxZw4rGF1ft39Fy395Jr4kJr90kws8Z34ftr1I9r45Xay7uw4xZay2
	vFy0qrs5Ca4kA3DanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
	bI8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
	1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
	x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2
	IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4U
	McvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487Mx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_
	Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwI
	xGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8
	JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcV
	C2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7_MaUUUUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/6/4 下午4:55, Vladimir Oltean wrote:
> On Sat, Jun 03, 2023 at 10:35:50AM +0800, Jianmin Lv wrote:
>>> How about 3. handle of_device_is_available() in the probe function of
>>> the "loongson, pci-gmac" driver? Would that not work?
>>>
>> This way does work only for the specified device. There are other devices,
>> such as HDA, I2S, etc, which have shared pins. Then we have to add
>> of_device_is_available() checking to those drivers one by one. And we are
>> not sure if there are other devices in new generation chips in future. So
>> I'm afraid that the way you mentioned is not suitable for us.
> 
> Got it, so you have more on-chip PCIe devices than the ones listed in
> loongson64-2k1000.dtsi, and you don't want to describe them in the
> device tree just to put status = "disabled" for those devices/functions
> that you don't want Linux to use - although you could, and it wouldn't
> be that hard or have unintended side effects.
> 
> Though you need to admit, in case you had an on-chip multi-function PCIe
> device like the NXP ENETC, and you wanted Linux to not use function 0,
> the strategy you're suggesting here that is acceptable for Loongson
> would not have worked.
> 
> I believe we need a bit of coordination from PCIe and device tree
> maintainers, to suggest what would be the encouraged best practices and
> ways to solve this regression for the ENETC.
> 

For a multi-function device, if func 0 is not allowed to be scanned, as 
I said in way of 2, the other funcs of the device will be described as 
platform devices instead of pci and be not scanned either, which is 
acceptable for Loongson. The main goal by any way for us is to resolve 
the problem that shared pins can not be used simultaneously by devices 
sharing them. IMO, configure them in DT one by one may be reasonable, 
but adapting each driver will be bothered.

Any way, let's listen to opinions from Bjorn and Rob.


