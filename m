Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94A0A4D488
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 19:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbfFTRHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 13:07:23 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39894 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfFTRHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 13:07:23 -0400
Received: by mail-qt1-f195.google.com with SMTP id i34so3915917qta.6
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 10:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PmGxDTvsnf0wiDDnvBb94eyhG78DMALvgC9UTaOZKRg=;
        b=SpwIZPvA5iu/kofN1hoIfZkccjqW9o+MQmTCesIkzdSngkhvvaM0j5p9/bNeEbVSOr
         mKfOZGPsY9KFWb4yT+hCcU+8RV+fnzMYxtMCW9rnLbR9+nf/5ZIlM0UP5utdgz6Xwlxt
         w6TsxK2wWjbOINCMbdzHPUFMh1TsMKGHMYtnye43PPuqOGC4ugSFRhi87l+TLdiA3unT
         tqjv4uL20ZExJS186hNv9i4jeK1GVrLvDFWPzV5w2xSza2kVWlxQjOefKRHS3eJ76Vio
         LongcpQZYS88HdCeFNR9LNf6XCl+KQtvGIKOu5tQFJYi/ltOa2/M2wqTYWNQnjbxzvBw
         aPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PmGxDTvsnf0wiDDnvBb94eyhG78DMALvgC9UTaOZKRg=;
        b=t1DUv4iILs9QNLmooVNTT6JGTUg9x7x0qr7mXPEa3LE8RMYEIdJOEtHyWNiJcXL2e1
         GXpIrCm34olUdcmjKNyhF8pteqBzWe99pjlradTzvO9xeGGBgGTCb2+hWlbT31GUthZd
         Ftl0A4CgD9yr3LybRsTJu91JOwj4Um9zlaTrdv70pGruS0dflOFKK9s4gOhIhCQ5qV0L
         Sf7TH3KyjD8qJyIYxcPdz+jYdcMpxH9i0L6FZY5qJjV6jv7q3zs0BdSUhdpyyM/DenUK
         7I5CqWqChip5AcdqbxfIvs/kzxcau1pFOswn4oXHErM4xppQaMQXKYOU7yBq6NFoagKc
         xoKg==
X-Gm-Message-State: APjAAAUWJl2Kj8QlIrvcICyQcM58GmE5VuTTO/1xvZ3szvDoMgMCn7xB
        naNE8EA/p+Hlx5DIczvfQz8=
X-Google-Smtp-Source: APXvYqzAfpPbvHo+KK/zW6sRTus5Kt9dQHHtl2u82Wm8mgZptCwIXzzaqPuCxqyuLrnQtkOGg2oPrQ==
X-Received: by 2002:a0c:887c:: with SMTP id 57mr39349919qvm.192.1561050442489;
        Thu, 20 Jun 2019 10:07:22 -0700 (PDT)
Received: from [10.195.149.182] ([144.121.20.163])
        by smtp.gmail.com with ESMTPSA id r40sm122772qtr.57.2019.06.20.10.07.21
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 10:07:21 -0700 (PDT)
Subject: Re: [PATCH net-next v4 1/7] igb: clear out tstamp after sending the
 packet
To:     "Patel, Vedang" <vedang.patel@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
References: <1560966016-28254-1-git-send-email-vedang.patel@intel.com>
 <1560966016-28254-2-git-send-email-vedang.patel@intel.com>
 <d6655497-5246-c24e-de35-fc6acdad0bf1@gmail.com>
 <A1A5CF42-A7D4-4DC4-9D57-ED0340B04A6F@intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <99e834ed-1c78-d35c-84dc-511d377284a1@gmail.com>
Date:   Thu, 20 Jun 2019 13:07:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <A1A5CF42-A7D4-4DC4-9D57-ED0340B04A6F@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/20/19 9:49 AM, Patel, Vedang wrote:
> 
> 
>> On Jun 20, 2019, at 3:47 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 6/19/19 10:40 AM, Vedang Patel wrote:
>>> skb->tstamp is being used at multiple places. On the transmit side, it
>>> is used to determine the launchtime of the packet. It is also used to
>>> determine the software timestamp after the packet has been transmitted.
>>>
>>> So, clear out the tstamp value after it has been read so that we do not
>>> report false software timestamp on the receive side.
>>>
>>> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
>>> ---
>>> drivers/net/ethernet/intel/igb/igb_main.c | 1 +
>>> 1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
>>> index fc925adbd9fa..f66dae72fe37 100644
>>> --- a/drivers/net/ethernet/intel/igb/igb_main.c
>>> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
>>> @@ -5688,6 +5688,7 @@ static void igb_tx_ctxtdesc(struct igb_ring *tx_ring,
>>> 	 */
>>> 	if (tx_ring->launchtime_enable) {
>>> 		ts = ns_to_timespec64(first->skb->tstamp);
>>> +		first->skb->tstamp = 0;
>>
>> Please provide more explanations.
>>
>> Why only this driver would need this ?
>>
> Currently, igb is the only driver which uses the skb->tstamp option on the transmit side (to set the hardware transmit timestamp). All the other drivers only use it on the receive side (to collect and send the hardware transmit timestamp to the userspace after packet has been sent).
> 
> So, any driver which supports the hardware txtime in the future will have to clear skb->tstamp to make sure that hardware tx transmit and tx timestamping can be done on the same packet.

The changelog is rather confusing :

"So, clear out the tstamp value after it has been read so that we do not
 report false software timestamp on the receive side."

I have hard time understanding why sending an skb through this driver
could cause a problem on receive side ?

I suggest to rephrase it to clear the confusion.

> 
> Thanks,
> Vedang
>>
>>> 		context_desc->seqnum_seed = cpu_to_le32(ts.tv_nsec / 32);
>>> 	} else {
>>> 		context_desc->seqnum_seed = 0;
>>>
> 
