Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360633AFAEA
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 04:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhFVCNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 22:13:23 -0400
Received: from mail.loongson.cn ([114.242.206.163]:46256 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229663AbhFVCNX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 22:13:23 -0400
Received: from [10.130.0.191] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9BxIOKSRtFgxZ4VAA--.3572S3;
        Tue, 22 Jun 2021 10:10:40 +0800 (CST)
Subject: Re: [PATCH 1/4] stmmac: pci: Add dwmac support for Loongson
To:     Andrew Lunn <andrew@lunn.ch>
References: <20210618025337.5705-1-zhangqing@loongson.cn>
 <YM//kGGAp3vz8OYb@lunn.ch>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Rob Herring <robh+dt@kernel.org>,
        Huacai Chen <chenhc@lemote.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>
From:   zhangqing <zhangqing@loongson.cn>
Message-ID: <d66e6af7-7384-41aa-76a7-7017f27d43cb@loongson.cn>
Date:   Tue, 22 Jun 2021 10:10:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <YM//kGGAp3vz8OYb@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9BxIOKSRtFgxZ4VAA--.3572S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CF4ftw17JryxXw1xArykuFg_yoW8JF4fpa
        srGa9xKFZFgFyxCr1FqFWkXFyvvr4Skay0k3y2yFnxK3ZYyrWfX34jgrWUCas3CFZ5Cw45
        Zw1jgr48Wa4kKrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9Kb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJV
        W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
        wI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_Gr1l42xK82IYc2Ij64vIr41l4I
        8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AK
        xVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
        AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8I
        cIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
        v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7NBMDUUUU
X-CM-SenderInfo: x2kd0wptlqwqxorr0wxvrqhubq/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/21/2021 10:55 AM, Andrew Lunn wrote:
>> +static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>> +{
>> +	struct plat_stmmacenet_data *plat;
>> +	struct stmmac_resources res;
>> +	int ret, i, mdio;
>> +	struct device_node *np;
>> +
>> +	np = dev_of_node(&pdev->dev);
>> +
>> +	if (!np) {
>> +		pr_info("dwmac_loongson_pci: No OF node\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (!of_device_is_compatible(np, "loongson, pci-gmac")) {
>> +		pr_info("dwmac_loongson_pci: Incompatible OF node\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
>> +	if (!plat)
>> +		return -ENOMEM;
>> +
>> +	if (plat->mdio_node) {
>> +		dev_err(&pdev->dev, "Found MDIO subnode\n");
> It is an error is an MDIO node is found?

Hi，Andrew

Thanks for your advice,

Using dev_ DEG () is appropriate,

and other issues I will fix in v2.

Thanks,

-Qing

>
>> +		mdio = true;
>> +	}
>> +
> ...
>
>> +
>> +	plat->phy_interface = device_get_phy_mode(&pdev->dev);
>> +	if (plat->phy_interface < 0)
>> +		dev_err(&pdev->dev, "phy_mode not found\n");
>> +
>> +	plat->interface = PHY_INTERFACE_MODE_GMII;
> Seems odd you call device_get_phy_mode() but then have this hard coded
> PHY_INTERFACE_MODE_GMII?
>
> 	Andrew

