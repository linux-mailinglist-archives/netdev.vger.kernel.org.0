Return-Path: <netdev+bounces-6976-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B24B0719139
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:17:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAC1328169E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04E5C4C94;
	Thu,  1 Jun 2023 03:17:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CB64C83
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 03:17:11 +0000 (UTC)
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399C3C9;
	Wed, 31 May 2023 20:16:51 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
	by APP-03 (Coremail) with SMTP id rQCowABXXDCNDXhk6FzJCA--.6399S2;
	Thu, 01 Jun 2023 11:16:29 +0800 (CST)
From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
To: justin.chen@broadcom.com,
	f.fainelli@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	bcm-kernel-feedback-list@broadcom.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: [PATCH] net: systemport: Add and correct check for platform_get_irq
Date: Thu,  1 Jun 2023 11:16:35 +0800
Message-Id: <20230601031635.28361-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABXXDCNDXhk6FzJCA--.6399S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KFW8Zr4DGFyxJF1UAw4kXrb_yoW8Ww43pa
	1DJrWrX3y8WF4Yvas7Z3W8AFsxZw4Fvw4UGrW7tr13Z3s0yr1xAa48KF13uFnrAr4rGw43
	ZFyjva93CFn8ZaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
	628vn2kIc2xKxwCY02Avz4vE14v_Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxh
	VjvjDU0xZFpf9x0JU-miiUUUUU=
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 06:42:26AM +0800, Justin Chen wrote:
> On 5/31/23 2:11 AM, Jiasheng Jiang wrote:
>> Add the missing check for "priv->wol_irq".
>> Use "<" instead of "<=" to check the irqs since the platform_get_irq
>> returns non-zero IRQ number on success and negative error number on
>> failure, shown in `driver/base/platform.c`.
>> 
>> Fixes: 83e82f4c706b ("net: systemport: add Wake-on-LAN support")
>> Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
>> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>> ---
>>   drivers/net/ethernet/broadcom/bcmsysport.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
>> index 38d0cdaf22a5..16c9c0be1a33 100644
>> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
>> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
>> @@ -2535,7 +2535,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
>>   	} else {
>>   		priv->wol_irq = platform_get_irq(pdev, 1);
>>   	}
>> -	if (priv->irq0 <= 0 || (priv->irq1 <= 0 && !priv->is_lite)) {
>> +	if (priv->irq0 < 0 || (priv->irq1 < 0 && !priv->is_lite) || priv->wol_irq < 0) {
>>   		ret = -EINVAL;
>>   		goto err_free_netdev;
>>   	}
> 
> wol_irq is optional so we don't want to error out. Guess we should 
> probably replace platform_get_irq with platform_get_irq_optional(). "<=" 
> is fine. As you mentioned, a non-zero is success, so zero is considered 
> invalid.

Yes, you are right.
I will submit a new patch that replace platform_get_irq with
platform_get_irq_optional.

Thanks,
Jiasheng


