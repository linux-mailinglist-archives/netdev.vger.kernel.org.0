Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD1E2A8668
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbgKEStW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgKEStW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:49:22 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961CEC0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:49:20 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id z3so2025165pfz.6
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=DfZNIM80hRtEstGfUHwjwye5TbJ6mbHVgTFNstbTpnc=;
        b=qz8RT0dzNrVfiC819cIApKMDspsomeU6qmVzIdsIojyBOQUfOqiJvtcK2RMiv3oPNc
         Wc0m7lohuU+5mEOacTQSFE18OOcs9Irrv4I0l0NCKFqmbfP2QCUatq/RT1o9oRWumA62
         MwriKVjM4ATdOcvDUpcsZNGrbNqmsmhUiCStDXZ+vSjT4mB45Wugy40gbXIXM9osD67j
         BkCs6zvnT9FHkIoanod4osAmDsnS+mn37/qJ8itYcpl9GrVAdZjK3rifJ8aankhUYqQJ
         mZhSEKRH1ZSILDjgBOrH0Jz0TAV/XjLKBNqE52smICUuamu6Tc+486uOPVTYnTpotcUu
         6fKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DfZNIM80hRtEstGfUHwjwye5TbJ6mbHVgTFNstbTpnc=;
        b=twjaizrxo7CohJQaH0jMnxDpbblBKr6YOPp7cWlvh+McWHN/xNZKIk3dEPQT1cYVGj
         vQcaUZZzDS54uryF3u7gYteSqChTBvz0DA61cSzy7PcFRF41CCbFZxAkiUg/bhcaXzyO
         ysYPnqNDQA84oS6yPHOVOv/gP4DIyQqUBqQnp0ZRfinxFZlfjz/7srSv9rA8SeQsPGPi
         diPlQk4FBuSaXfXeRKxcTI0Rcok+5wWEMp3wYXygbgh63rIcJ5zp1fJBKjNFjSQ7nEeY
         jn1mcy4zrUkAq35CZ7fSByIkeKE6qUK6MtCr2ue9YYgembuvl6uDp4Y5IH23xTm67Ezq
         Zlcg==
X-Gm-Message-State: AOAM53077rDwY2UoRed18xTugCXlo+Z256A5laRPRThl75gzvehs9ok9
        Iwpvy0nuwljD9oGmIlBswQvu5A==
X-Google-Smtp-Source: ABdhPJz/YzZzsCZODIlRwa+TLI+ctf9HL3SlIY23bOtQoGVxzPfIBLczT8gBnUlatfVd57/n2zltzA==
X-Received: by 2002:aa7:8548:0:b029:164:769a:353 with SMTP id y8-20020aa785480000b0290164769a0353mr4000042pfn.45.1604602160075;
        Thu, 05 Nov 2020 10:49:20 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id v196sm3322186pfc.34.2020.11.05.10.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 10:49:19 -0800 (PST)
Subject: Re: [PATCH net-next 3/6] ionic: add lif quiesce
To:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
References: <20201104223354.63856-1-snelson@pensando.io>
 <20201104223354.63856-4-snelson@pensando.io>
 <14d1fa0c69605427a1bd99a034da3ed99075e8a2.camel@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <990beee2-15a0-65af-c074-3763ed78b51b@pensando.io>
Date:   Thu, 5 Nov 2020 10:49:18 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <14d1fa0c69605427a1bd99a034da3ed99075e8a2.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/20 4:50 PM, Saeed Mahameed wrote:
> On Wed, 2020-11-04 at 14:33 -0800, Shannon Nelson wrote:
>> After the queues are stopped, expressly quiesce the lif.
>> This assures that even if the queues were in an odd state,
>> the firmware will close up everything cleanly.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   .../net/ethernet/pensando/ionic/ionic_lif.c   | 24
>> +++++++++++++++++++
>>   1 file changed, 24 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index 519d544821af..28044240caf2 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -1625,6 +1625,28 @@ static void ionic_lif_rss_deinit(struct
>> ionic_lif *lif)
>>   	ionic_lif_rss_config(lif, 0x0, NULL, NULL);
>>   }
>>   
>> +static int ionic_lif_quiesce(struct ionic_lif *lif)
>> +{
>> +	struct ionic_admin_ctx ctx = {
>> +		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
>> +		.cmd.lif_setattr = {
>> +			.opcode = IONIC_CMD_LIF_SETATTR,
>> +			.index = cpu_to_le16(lif->index),
>> +			.attr = IONIC_LIF_ATTR_STATE,
>> +			.state = IONIC_LIF_QUIESCE,
>> +		},
>> +	};
>> +	int err;
>> +
>> +	err = ionic_adminq_post_wait(lif, &ctx);
>> +	if (err) {
>> +		netdev_err(lif->netdev, "lif quiesce failed %d\n",
>> err);
>> +		return err;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static void ionic_txrx_disable(struct ionic_lif *lif)
>>   {
>>   	unsigned int i;
>> @@ -1639,6 +1661,8 @@ static void ionic_txrx_disable(struct ionic_lif
>> *lif)
>>   		for (i = 0; i < lif->nxqs; i++)
>>   			err = ionic_qcq_disable(lif->rxqcqs[i], (err !=
>> -ETIMEDOUT));
>>   	}
>> +
>> +	ionic_lif_quiesce(lif);
> if you don't care about return value just void out the function retval
>

Sure.
sln

