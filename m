Return-Path: <netdev+bounces-967-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE10E6FB837
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 22:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEABF1C209F5
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 20:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53ACD11C94;
	Mon,  8 May 2023 20:21:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B674411
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 20:21:56 +0000 (UTC)
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FC130D7
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 13:21:54 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-7577f03e131so79330985a.0
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 13:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683577313; x=1686169313;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HhKtkwIfsZwfdqGABp7LItMJIoNYpSoQuJkQ1zL9aoY=;
        b=cLCqXxCOGtYovP01M6MgIjxstQOEQCPtHj1N3j+dtER5a5PCqL9vjNgf1/ro+kf0/O
         npwFDGVlisy7z8dAk90OvSezadE8ZTcgLCcGpLrBmU4PPbKNkcBwKYWTIk88UL1Py/Af
         VzbnEQCC8I7f59nhXOGGWYlXpIhlXRL+oI2W9ba2NsvCvkBdHz9/0gkOiYkbzIBhFe9O
         oSRp3gPTMarAAd4FDKp8+Ba/1dSoD7SweRzDICe5fwN84PZmc+PjQn8hzlBctZW5Jbpm
         5p6vQJ4pHx0hWBAwKFcQz3tgp1SCvxTi90Gz48HCcptlz4zlT9pE+Ik6PCoNBlGwR0t3
         Y5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683577313; x=1686169313;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhKtkwIfsZwfdqGABp7LItMJIoNYpSoQuJkQ1zL9aoY=;
        b=bE+zRhYylhuEd6VT/w3DF41ojgNSCcg0N70efKUuXFgDUTy+xT3Mn84qkFShG7YGqA
         gs5VnrF2OzETwmOZwvufWeHFs4wLb2fYdEzGii5/rnz72zuDBfRu4n9JnlGVp3+tsPq4
         TvDXCoecLdEMnDYfi+IyjF/Kdz5W0VK0Okvo0Qkg/t74ghrS/3utXlJlG2IGqVxhNv55
         s5F9fLSO3FrInP0FNoCktWZiXuWyyk2sgLsz+MFH2LrdY8JsA7odt5NUkMIas81Gw23G
         MGYDvHpDwaxI9yXd1d1XNhsIgknKTExZn5CKAD7pvr6Thtq01F/W12KVAmWHqfdvLTES
         W05w==
X-Gm-Message-State: AC+VfDydeJltJrMywMf3wZuSOcBXegGKUsfD1a/FsZP019MeACHcPdl+
	SjY99zn+5KZA6rrPqnQL2ig=
X-Google-Smtp-Source: ACHHUZ6kBwcRsBpJvwMNRnywmyWgeN0XhS3PJaxeT5V3iRKkTn5gava0oF01CWopl/xa4dmjjBN2Tw==
X-Received: by 2002:a05:6214:234a:b0:5f1:5cf1:b4c8 with SMTP id hu10-20020a056214234a00b005f15cf1b4c8mr17121145qvb.35.1683577313258;
        Mon, 08 May 2023 13:21:53 -0700 (PDT)
Received: from ?IPV6:2602:47:d92c:4400:8175:87b7:e4c6:a5bb? ([2602:47:d92c:4400:8175:87b7:e4c6:a5bb])
        by smtp.gmail.com with ESMTPSA id o20-20020a0ce414000000b0061b77fde8b5sm239829qvl.56.2023.05.08.13.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 13:21:52 -0700 (PDT)
Message-ID: <551ba931-3f59-6f66-93b5-b6aeeaa595ff@gmail.com>
Date: Mon, 8 May 2023 16:21:51 -0400
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH ethtool] Fix argc and argp handling issues
Content-Language: en-US
To: Michal Kubecek <mkubecek@suse.cz>
Cc: netdev@vger.kernel.org
References: <4b89caeddf355b07da0ba68ea058a94e5a55ff59.1683549750.git.nvinson234@gmail.com>
 <20230508200104.ktrzgazsn3t54n2a@lion.mk-sys.cz>
From: Nicholas Vinson <nvinson234@gmail.com>
In-Reply-To: <20230508200104.ktrzgazsn3t54n2a@lion.mk-sys.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/8/23 16:01, Michal Kubecek wrote:
> On Mon, May 08, 2023 at 08:45:33AM -0400, Nicholas Vinson wrote:
>> Fixes issues that were originally found using gcc's static analyzer. The
>> flags used to invoke the analyzer are given below.
>>
>> Upon manual review of the results and discussion of the previous patch
>> '[PATCH ethtool 3/3] Fix potentinal null-pointer derference issues.', it
>> was determined that when using a kernel lacking the execve patch ( see
>> https://github.com/gregkh/linux/commit/dcd46d897adb70d63e025f175a00a89797d31a43),
>> it is possible for argc to be 0 and argp to be an array with only a
>> single NULL entry. This scenario would cause ethtool to read beyond the
>> bounds of the argp array. However, this scenario should not be possible
>> for any Linux kernel released within the last two years should have the
>> execve patch applied.
>>
>>      CFLAGS=-march=native -O2 -pipe -fanalyzer       \
>>          -Werror=analyzer-va-arg-type-mismatch       \
>>          -Werror=analyzer-va-list-exhausted          \
>>          -Werror=analyzer-va-list-leak               \
>>          -Werror=analyzer-va-list-use-after-va-end
>>
>>      CXXCFLAGS=-march=native -O2                     \
>>          -pipe -fanalyzer                            \
>>          -Werror=analyzer-va-arg-type-mismatch       \
>>          -Werror=analyzer-va-list-exhausted          \
>>          -Werror=analyzer-va-list-leak               \
>>          -Werror=analyzer-va-list-use-after-va-end
>>
>>      LDFLAGS="-Wl,-O1 -Wl,--as-needed"
>>
>>      GCC version is gcc (Gentoo 13.1.0-r1 p1) 13.1.0
> This looks good to me, except for the missing Signed-off-by (as
> mentioned by Jesse). IMHO it's not necessary to resubmit the patch,
> replying with the Signed-off-by line should suffice. If you can do that
> by tomorrow, I'll include the patch in 6.3 release.
>
> Michal

I'll send an updated version momentarily. I noticed some spelling 
mistakes that I'd like to fix.

Thanks,

Nicholas Vinson

>> ---
>>   ethtool.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/ethtool.c b/ethtool.c
>> index 98690df..0752fe4 100644
>> --- a/ethtool.c
>> +++ b/ethtool.c
>> @@ -6405,6 +6405,9 @@ int main(int argc, char **argp)
>>   
>>   	init_global_link_mode_masks();
>>   
>> +	if (argc < 2)
>> +		exit_bad_args();
>> +
>>   	/* Skip command name */
>>   	argp++;
>>   	argc--;
>> @@ -6449,7 +6452,7 @@ int main(int argc, char **argp)
>>   	 * name to get settings for (which we don't expect to begin
>>   	 * with '-').
>>   	 */
>> -	if (argc == 0)
>> +	if (!*argp)
>>   		exit_bad_args();
>>   
>>   	k = find_option(*argp);
>> -- 
>> 2.40.1
>>
>>

