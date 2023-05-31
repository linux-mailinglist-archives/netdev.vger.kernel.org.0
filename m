Return-Path: <netdev+bounces-6672-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 477C671764B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:39:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0B691C20C5C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C04D63AD;
	Wed, 31 May 2023 05:38:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD695395
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:38:58 +0000 (UTC)
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DC6EE;
	Tue, 30 May 2023 22:38:57 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d2e1a72fcca58-64d3bc0dce9so1212244b3a.0;
        Tue, 30 May 2023 22:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685511536; x=1688103536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nnQk6J1N7k/8h6FVLVnLBiuJAo005sGCro1rlFM76hg=;
        b=F210SJWQyDbyen0gbpq5wzMpl8EHqto+1Nz4gacdt9NguYg/My4jcfi+z4dkcEFpAs
         CoUwVgp7/YdKI+Kf52AfPb+b/agCb8rtvvGRFvHmzPNBhXK40zDGDAoTauCUMKZi+c89
         9w36b0OsoOKTNIrWCNzKFODiwszBMx+SKNJVrDfvShGD2WOmLNXCTIY6rm8ZcNshpqBe
         S1n4AwjQfHvofX7eEfQBa+eLV5KVd4VUuHz72gwQnfx7nnW0WcdFdCTfGzTnJTj9K5nN
         R9NKmgOPXixAJpJrLECW3sJHNIp8nE0e8CkbRF2w9mN0IpRVEG5Pe5CCqBRRlTiKSUUs
         dYGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685511536; x=1688103536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nnQk6J1N7k/8h6FVLVnLBiuJAo005sGCro1rlFM76hg=;
        b=RXXTYyKNZ4tVO4Fz9TzvE0BdAKbwAsiTR+4WZAorsiWbnPbQgWP/2IohA6A1oeNbNE
         ekqXy9ggI5yz+O62h5SMniTZeZO36ud55HBOnXlWF+bxRFfzkE+nVKfRr2w8gQBSsUUM
         2VcM+JG6IYRbym7wywVRGIhGS32KiQ4P6cVqr1dMnjBQwLpoWlDW5kk0lv+t6FaX3Q6k
         juxLyCT4sjCxu/Y2wg9toPLvbLuGtcvmrZT+LpfKyDzsQE8HHUedF4nClUK8g5sFLdbp
         3uENfu1YQMT9Ep3JKc0505WNK2dTE8cE/t1HgCF9THiz29ic2OuC5rbOQ3PGI/5M9qCO
         NMlA==
X-Gm-Message-State: AC+VfDzAa8V5lLRimNRkEh7rgx3wKRTMKeCH+MbgBZ/s9xIyfoBBCm2y
	mVLMZFXIpo682qsWtwPQRao=
X-Google-Smtp-Source: ACHHUZ70eED/hF3467VY3RnuCPWOOjMAwG1tnefnlyWx0PbXUUN7A9Rl3yYEpUPcoUWeWtklm8og9g==
X-Received: by 2002:a05:6a20:8e09:b0:10c:8939:fc48 with SMTP id y9-20020a056a208e0900b0010c8939fc48mr1594528pzj.3.1685511536405;
        Tue, 30 May 2023 22:38:56 -0700 (PDT)
Received: from [127.0.0.1] ([2404:c140:1f03::caf2])
        by smtp.gmail.com with ESMTPSA id c5-20020aa781c5000000b006439df7ed5fsm2561902pfn.6.2023.05.30.22.38.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 22:38:55 -0700 (PDT)
Message-ID: <e9925aef-fefc-24b9-dea3-bd3bcca01b35@gmail.com>
Date: Wed, 31 May 2023 13:38:49 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] net: sched: fix possible OOB write in fl_set_geneve_opt()
To: Simon Horman <simon.horman@corigine.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, simon.horman@netronome.com,
 pieter.jansen-van-vuuren@amd.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230529043615.4761-1-hbh25y@gmail.com>
 <ZHXf29es/yh3r6jq@corigine.com>
Content-Language: en-US
From: Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <ZHXf29es/yh3r6jq@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 30/5/2023 19:36, Simon Horman wrote:
> [Updated Pieter's email address, dropped old email address of mine]
> 
> On Mon, May 29, 2023 at 12:36:15PM +0800, Hangyu Hua wrote:
>> If we send two TCA_FLOWER_KEY_ENC_OPTS_GENEVE packets and their total
>> size is 252 bytes(key->enc_opts.len = 252) then
>> key->enc_opts.len = opt->length = data_len / 4 = 0 when the third
>> TCA_FLOWER_KEY_ENC_OPTS_GENEVE packet enters fl_set_geneve_opt. This
>> bypasses the next bounds check and results in an out-of-bounds.
>>
>> Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> 
> Hi Hangyu Hua,
> 
> Thanks. I think I see the problem too.
> But I do wonder, is this more general than Geneve options?
> That is, can this occur with any sequence of options, that
> consume space in enc_opts (configured in fl_set_key()) that
> in total are more than 256 bytes?
> 

I think you are right. It is a good idea to add check in 
fl_set_vxlan_opt and fl_set_erspan_opt and fl_set_gtp_opt too.
But they should be submitted as other patches. fl_set_geneve_opt has 
already check this with the following code:

static int fl_set_geneve_opt(const struct nlattr *nla, struct 
fl_flow_key *key,
			     int depth, int option_len,
			     struct netlink_ext_ack *extack)
{
...
		if (new_len > FLOW_DIS_TUN_OPTS_MAX) {
			NL_SET_ERR_MSG(extack, "Tunnel options exceeds max size");
			return -ERANGE;
		}
...
}

This bug will only be triggered under this special 
condition(key->enc_opts.len = 252). So I think it will be better 
understood by submitting this patch independently.

By the way, I think memset's third param should be option_len in 
fl_set_vxlan_opt and fl_set_erspan_opt. Do I need to submit another 
patch to fix all these issues?

Thanks,
Hangyu

>> ---
>>   net/sched/cls_flower.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>> index e960a46b0520..a326fbfe4339 100644
>> --- a/net/sched/cls_flower.c
>> +++ b/net/sched/cls_flower.c
>> @@ -1153,6 +1153,9 @@ static int fl_set_geneve_opt(const struct nlattr *nla, struct fl_flow_key *key,
>>   	if (option_len > sizeof(struct geneve_opt))
>>   		data_len = option_len - sizeof(struct geneve_opt);
>>   
>> +	if (key->enc_opts.len > FLOW_DIS_TUN_OPTS_MAX - 4)
>> +		return -ERANGE;
>> +
>>   	opt = (struct geneve_opt *)&key->enc_opts.data[key->enc_opts.len];
>>   	memset(opt, 0xff, option_len);
>>   	opt->length = data_len / 4;
>> -- 
>> 2.34.1
>>
>>

