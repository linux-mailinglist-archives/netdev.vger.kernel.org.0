Return-Path: <netdev+bounces-10962-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBAE8730D78
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 05:24:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 131DB1C20DA9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 03:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF32D39F;
	Thu, 15 Jun 2023 03:24:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CC336A
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 03:24:54 +0000 (UTC)
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E987A1BE5;
	Wed, 14 Jun 2023 20:24:51 -0700 (PDT)
Received: from ed3e173716be.home.arpa (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowAAHKQZxhIpk8PiSAg--.655S2;
	Thu, 15 Jun 2023 11:24:33 +0800 (CST)
From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
To: kuba@kernel.org
Cc: vburru@marvell.com,
	aayarekar@marvell.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	sburla@marvell.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: [PATCH] octeon_ep: Add missing check for ioremap
Date: Thu, 15 Jun 2023 11:24:31 +0800
Message-Id: <20230615032431.48930-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAHKQZxhIpk8PiSAg--.655S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xr18Ary3Kw43Wr15Xw1fWFg_yoWDGrX_Xr
	4F9348WrWDJrn7J3Z8Jr1jk3sxJrn7Gwn3XFW5uF4vyws8Zry0vr4UuwnYgFykJ393Krn8
	tr92vay7Cr12vjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbV8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkIecxEwVAFwVW8GwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x0JU-miiUUUUU=
X-Originating-IP: [124.16.138.129]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 15 Jun 2023 03:53:04 +0800 Jakub Kicinski wrote:
> On Wed, 14 Jun 2023 11:23:47 +0800 Jiasheng Jiang wrote:
>> @@ -981,6 +981,9 @@ int octep_device_setup(struct octep_device *oct)
>>  		oct->mmio[i].hw_addr =
>>  			ioremap(pci_resource_start(oct->pdev, i * 2),
>>  				pci_resource_len(oct->pdev, i * 2));
>> +		if (!oct->mmio[i].hw_addr)
>> +			goto unsupported_dev;
>> +
>>  		oct->mmio[i].mapped = 1;
>>  	}
>>  
>> @@ -1015,8 +1018,8 @@ int octep_device_setup(struct octep_device *oct)
>>  	return 0;
>>  
>>  unsupported_dev:
>> -	for (i = 0; i < OCTEP_MMIO_REGIONS; i++)
>> -		iounmap(oct->mmio[i].hw_addr);
>> +	for (j = 0; j < i; j++)
>> +		iounmap(oct->mmio[j].hw_addr);
> 
> Assuming @i is not changed by the rest of the function is a bit fragile.
> 
> Better way of handling this situation is:
> 
> unsupported_dev:
> 	i = OCTEP_MMIO_REGIONS;
> unmap_prev:
> 	while (i--)
> 		iounmap(oct->mmio[i].hw_addr);
> 
> and jump to unmap_prev

Fine, I will submit a v2 to fix it.

Thanks,
Jiasheng


