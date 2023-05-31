Return-Path: <netdev+bounces-6676-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 893CD71766E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:57:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 266C71C20D36
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFE963AD;
	Wed, 31 May 2023 05:57:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FB52103
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:57:46 +0000 (UTC)
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AE311C;
	Tue, 30 May 2023 22:57:45 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d2e1a72fcca58-64f48625615so1246942b3a.0;
        Tue, 30 May 2023 22:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685512664; x=1688104664;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hy91tU5qgmSF/dPJqb9doc7KPtlQi2WovOSJrUGZGjs=;
        b=QV0/YyF93YQTFfNLpq/d0LtdVwCOodWpMc51/82q4Ngazwi8J0GIRo1tiHjJX2yZ8b
         kekb+jq38gUwSD6yMgywBEteAJAB553wdsTGHdFsFBV38qYNAFK4UIRZ85lDrXOAV8Ki
         ba0kjeWmOMSyKPffzrL8p32koDcVrEUhgbDLmCUVSHswsFCQ/0KK9TyXd00OVdgKd6lR
         aqa1vIGvnQTfetwI5GAsAeR2X+B3KgQ9oYzrv2TYMz97rYYW9uDAAN5znwJY85WR3NIz
         6k9xI4zXHDRSMwutcspbxFsPk2sTidLrWcxWZVvjZ1CR+u2dHqjCE+ULvKsl/A5lGzKr
         f76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685512664; x=1688104664;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hy91tU5qgmSF/dPJqb9doc7KPtlQi2WovOSJrUGZGjs=;
        b=lBA7r5C8Sy0ZuxwofyVPJisl6UKqLshANXOS3Nt5osboKm2+gsagXt/K9t9SfsGqge
         VpQsYP2lSEYoPV/kdBkp0afOoR0seEFZoGUiIUoZjO0z4MkihvI4fIo6zOprzPgmnIGc
         whVqjes2WRro8JerXOFPhF6agdIwJX+/mm1eqJYH80/aPoJVLTmC2lWNxXybLjm2kb5V
         WqAKGfc46ESrVE/5P/MGRfbPHEXOoNCfgjHVPnzI5I2No8MVNr1WI9iaEzlzYlW70qxr
         CG1d4BBCwqOVhBM/Oq7RbWuufzB2j2Md4xCCNTXT5tNrTHOKfoLX0lKtxX7QcH7RDQka
         IMHg==
X-Gm-Message-State: AC+VfDw1Plt6X5TFUEmtXn/RN/RYXGuHXHVYQhhmKorNRqDxLa46p8FM
	NkxMVNBTp/gAaKVWfSruYiJyZqoMP1T7cxoV
X-Google-Smtp-Source: ACHHUZ4uuGqqlhyc5sZWMhFk/IgVH9Ddvhlv5sfttTWsmKL63qgG+xKqyFiVY6Q6wBf6si3k07LOyw==
X-Received: by 2002:a05:6a20:158a:b0:111:ee3b:59a7 with SMTP id h10-20020a056a20158a00b00111ee3b59a7mr4830662pzj.5.1685512664532;
        Tue, 30 May 2023 22:57:44 -0700 (PDT)
Received: from [127.0.0.1] ([2404:c140:1f03::caf2])
        by smtp.gmail.com with ESMTPSA id a9-20020aa78649000000b0064f83595bbcsm2550287pfo.58.2023.05.30.22.57.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 22:57:43 -0700 (PDT)
Message-ID: <db846ae8-d1e8-5539-30a2-4bd04f9d3d9d@gmail.com>
Date: Wed, 31 May 2023 13:57:38 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] net: sched: fix possible OOB write in fl_set_geneve_opt()
Content-Language: en-US
To: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
 Simon Horman <simon.horman@corigine.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230529043615.4761-1-hbh25y@gmail.com>
 <ZHXf29es/yh3r6jq@corigine.com>
 <4ec4bcb1-fc18-578d-fee5-cad5166f3c2c@amd.com>
From: Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <4ec4bcb1-fc18-578d-fee5-cad5166f3c2c@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 30/5/2023 22:29, Pieter Jansen van Vuuren wrote:
> 
> 
> On 30/05/2023 12:36, Simon Horman wrote:
>> [Updated Pieter's email address, dropped old email address of mine]
> 
> Thank you Simon.
> 
>>
>> On Mon, May 29, 2023 at 12:36:15PM +0800, Hangyu Hua wrote:
>>> If we send two TCA_FLOWER_KEY_ENC_OPTS_GENEVE packets and their total
>>> size is 252 bytes(key->enc_opts.len = 252) then
>>> key->enc_opts.len = opt->length = data_len / 4 = 0 when the third
>>> TCA_FLOWER_KEY_ENC_OPTS_GENEVE packet enters fl_set_geneve_opt. This
>>> bypasses the next bounds check and results in an out-of-bounds.
>>>
>>> Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
>>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>>
>> Hi Hangyu Hua,
>>
>> Thanks. I think I see the problem too.
>> But I do wonder, is this more general than Geneve options?
>> That is, can this occur with any sequence of options, that
>> consume space in enc_opts (configured in fl_set_key()) that
>> in total are more than 256 bytes?
>>
> 
> Hi Hangyu Hua,
> 
> Thank you for the patch. In addition to Simon's comment; I think the subject
> headline should include net, i.e. [PATCH net]. Also could you please provide

My bad. I forgot this rule. It seems this won't be included in the final 
patch. Do i need to send a v2?

> an example tc filter add dev... command to replicate the issue? (Just to make
> it a bit easier to understand).
> 

I use poc.c instead of commands to trigger this bug. If you want poc You
can check if there is an email named "Re: A possible LPE vulnerability 
in fl_set_geneve_opt" in your e-mail. I should have sent it to you and 
Simon while replying to security@kernel.org.

Thanks,
Hangyu

>>> ---
>>>   net/sched/cls_flower.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>>> index e960a46b0520..a326fbfe4339 100644
>>> --- a/net/sched/cls_flower.c
>>> +++ b/net/sched/cls_flower.c
>>> @@ -1153,6 +1153,9 @@ static int fl_set_geneve_opt(const struct nlattr *nla, struct fl_flow_key *key,
>>>   	if (option_len > sizeof(struct geneve_opt))
>>>   		data_len = option_len - sizeof(struct geneve_opt);
>>>   
>>> +	if (key->enc_opts.len > FLOW_DIS_TUN_OPTS_MAX - 4)
>>> +		return -ERANGE;
>>> +
>>>   	opt = (struct geneve_opt *)&key->enc_opts.data[key->enc_opts.len];
>>>   	memset(opt, 0xff, option_len);
>>>   	opt->length = data_len / 4;
>>> -- 
>>> 2.34.1
>>>
>>>

