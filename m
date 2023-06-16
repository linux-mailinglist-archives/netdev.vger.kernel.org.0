Return-Path: <netdev+bounces-11262-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CFB1732513
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 04:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30E212815A3
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 02:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3247B62D;
	Fri, 16 Jun 2023 02:12:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C09627
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:12:34 +0000 (UTC)
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 923B62967;
	Thu, 15 Jun 2023 19:12:32 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.116])
	by gateway (Coremail) with SMTP id _____8Cxd+kPxYtkhMsFAA--.10389S3;
	Fri, 16 Jun 2023 10:12:31 +0800 (CST)
Received: from [10.20.42.116] (unknown [10.20.42.116])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxauUNxYtkj8AcAA--.16275S3;
	Fri, 16 Jun 2023 10:12:30 +0800 (CST)
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
 <ad969019-e763-b06f-d557-be4e672c68db@loongson.cn>
 <20230605093459.gpwtsr5h73eonxt5@skbuf>
From: Jianmin Lv <lvjianmin@loongson.cn>
Message-ID: <ec5039c1-61d7-6958-ef92-bf5b8c8db64d@loongson.cn>
Date: Fri, 16 Jun 2023 10:12:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230605093459.gpwtsr5h73eonxt5@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxauUNxYtkj8AcAA--.16275S3
X-CM-SenderInfo: 5oymxthqpl0qxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Ar1UWF43CF4DKw4kXFW3CFX_yoW8Ww15pF
	43AF4SkFn8Gr4Sy34DZw4ruFyfua93Xw45Jr48J34v93y5WFySvrWYqa1Iqay7Gr18AF1a
	vFWjqw1vk3WDWagCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4
	CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j1WlkU
	UUUU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/6/5 下午5:34, Vladimir Oltean wrote:
> On Mon, Jun 05, 2023 at 08:59:23AM +0800, Jianmin Lv wrote:
>> For a multi-function device, if func 0 is not allowed to be scanned, as I
>> said in way of 2, the other funcs of the device will be described as
>> platform devices instead of pci and be not scanned either, which is
>> acceptable for Loongson. The main goal by any way for us is to resolve the
>> problem that shared pins can not be used simultaneously by devices sharing
>> them. IMO, configure them in DT one by one may be reasonable, but adapting
>> each driver will be bothered.
> 
> Could you give an example of PCIe functions being described as platform
> devices, and how does that work for Loongson? Are you saying that there
> will be 2 drivers for the same hardware, one pci_driver and one platform_driver?
> In the case of the platform_driver, who will do the PCI-specific stuff
> required by the IP, like function level reset and enabling the memory space?
> 

E.g. there are two functions , func0 is HDA controller and func1 is I2S 
controller and they have shared pins.
When HDA or I2S is used, both are disabled for PCI enumeration in BIOS 
(e.g. by filling PCI header with 0xffffffff), and mem space has been 
reserved from host bridge window for them in BIOS, of cause, reserved 
space will not be seen by kernel because it has been removed in host 
bridge mem range when passed to kernel in DT. Then the reserved mem base 
is passed into kernel by DT, CPU will use remapped address of the mem 
base, and these devices will not be enumerated in PCI bus. The way is 
only used for PCI devices (share common pins and exist on bus 0) 
integrated in Loongson CPU or chipset.


