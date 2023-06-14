Return-Path: <netdev+bounces-10863-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B09C730955
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:42:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B6C7280EB7
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F23C1097C;
	Wed, 14 Jun 2023 20:42:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512406D3F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:42:14 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD55295D;
	Wed, 14 Jun 2023 13:41:35 -0700 (PDT)
Received: from [192.168.1.141] ([37.4.248.58]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MFKCV-1qKnhr0xDd-00FkkA; Wed, 14 Jun 2023 22:40:58 +0200
Message-ID: <3452498b-b89c-c72d-d196-950520ed8c50@i2se.com>
Date: Wed, 14 Jun 2023 22:40:57 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net resend] net: qca_spi: Avoid high load if QCA7000 is
 not available
To: Simon Horman <simon.horman@corigine.com>,
 Stefan Wahren <stefan.wahren@chargebyte.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230614111714.3612-1-stefan.wahren@chargebyte.com>
 <ZInxqMtr4Gk4Kz0V@corigine.com>
Content-Language: en-US
From: Stefan Wahren <stefan.wahren@i2se.com>
In-Reply-To: <ZInxqMtr4Gk4Kz0V@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:MBWMtSe0RlgtR4GS7ahkYpnqCeam0fqC+fQby5LzYsqtoo0yqF4
 ncMlaoZ9aYlDxv+mGIIRFh8J5sQlWn0d5tg7M847pVbskYOYfuf8el019Di08HFXPlGnXWK
 JRle2g6v/axneWk8TkuNe4z2KvQWgJezknQnOPw03Qe/XPblTenRJBG+mw5bAQCGLl2MriP
 wgcaV3uMBZjMJEF3PW5dg==
UI-OutboundReport: notjunk:1;M01:P0:xEjrCgTC/PE=;1tcII32h7xg30xifKXCIzgP44f/
 xCFysj98luC2C009BHkWeLwsLQOmfwEJULRj51BOCDsb3UAEX6qx5cY/zeiFgR1wsVQPlnGh2
 bs8ZWjE32VtlRMSthcDmEivFhjDQtjO6ZL9lPDe7l/4XVpLq9EMcuCXFPcK0dU+vsAMv/jPMI
 R7m+Vrwh7Nt/+pr8bCAvyQm4AGdD2HW1sN6i5LsmY42Q+h1zS9i5dKjbnkMV0r4cBaC93qh2E
 gT9vgm1uPswWpvT2RhO9FS3VCaUFxbK93OINKIDqQu2AME4NCLpnGOMkLM6EjNR6I1nR0gHuT
 pSbaVaBs4LAoMuswwLwI9WN9p7hHLTHwfvl64Yi1Z91GLiSghvQooiBTs0R/2FnakEDqYpboC
 P1oriYcKBHonA+vu6VRZBVmhxynScplGRhRmyFxqMo6RPVp7poZ2zPJ+5KVs3x9js2RyeyxFw
 cHERfoCzQw9IOCsrFt6arG5OvHzi4QymzUmmVrmdsjEYq7GpAmirCzyX1gTYLwaOfBKwTQL3I
 YyTzeDhXUu1sNDQzrqF+sEGKCoxmGU2tZ3lP9hT2idHmzzHrHsj0tPCTtax9oDeD/aa6jloKd
 LtYJUFRwxmHldVy2gqoE81rkiGY/qm3Fl54RZ8C8btJgCsx50ENc/7hJd6KG38g1jyoxjRz38
 CtULlpz7GNO3WvDEDEtnrnB70EcZHlTJuBkvodIgAA==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon,

Am 14.06.23 um 18:58 schrieb Simon Horman:
> On Wed, Jun 14, 2023 at 01:17:14PM +0200, Stefan Wahren wrote:
>> In case the QCA7000 is not available via SPI (e.g. in reset),
>> the driver will cause a high load. The reason for this is
>> that the synchronization is never finished and schedule()
>> is never called. Since the synchronization is not timing
>> critical, it's safe to drop this from the scheduling condition.
>>
>> Signed-off-by: Stefan Wahren <stefan.wahren@chargebyte.com>
>> Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for
>>   QCA7000")
> 
> Hi Stefan,
> 
> the Fixes should be on a single line.
> 
> Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")

thanks for pointing out. Unfortunately this comes from the mail server, 
which line warp here. I will try to use a different account. Sorry about 
this mess :-(

> 
>> ---
>>   drivers/net/ethernet/qualcomm/qca_spi.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c
>>   b/drivers/net/ethernet/qualcomm/qca_spi.c
> 
> Likewise, the above two lines should be a single line.
> Unfortunately it seems that because it is not git doesn't apply
> this patch, which creates problems for automation linked to patchwork.
> 
> I think it would be best to repost after resolving these minor issues.
> 
>> index bba1947792ea16..90f18ea4c28ba1 100644
>> --- a/drivers/net/ethernet/qualcomm/qca_spi.c
>> +++ b/drivers/net/ethernet/qualcomm/qca_spi.c
>> @@ -582,8 +582,7 @@ qcaspi_spi_thread(void *data)
>>   	while (!kthread_should_stop()) {
>>   		set_current_state(TASK_INTERRUPTIBLE);
>>   		if ((qca->intr_req == qca->intr_svc) &&
>> -		    (qca->txr.skb[qca->txr.head] == NULL) &&
>> -		    (qca->sync == QCASPI_SYNC_READY))
>> +		    !qca->txr.skb[qca->txr.head])
>>   			schedule();
>>   
>>   		set_current_state(TASK_RUNNING);
>>
> 

