Return-Path: <netdev+bounces-505-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 113CC6F7DA3
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 09:18:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACD85280F58
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 07:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF6FC4C78;
	Fri,  5 May 2023 07:18:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AFA4C77
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 07:18:41 +0000 (UTC)
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CDF17DEF
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 00:18:37 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-24ddf274039so1015093a91.1
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 00:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1683271117; x=1685863117;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGBat/CgRbSnTAh4bkNae0IKQQw8RA2H99O/HWbocVk=;
        b=YobhmHEqJpKwlGuxR+PdlcNg4pNFd/71XZGwRAh9iNQ16sBw3sPcCs2uhlb5Cioqjy
         bilwQ0r9fNFkGWIZ0vyS3G2QRcXQCRUbzws0lxBvDlmkZs4A51dFYMdxZXpZ6c0V0ZBf
         6ZhNLxFBuuwBny4YWzKXcRwL020Wv/mzJblp13ATG0sv9HzRbZxkd+Kc4T/lXwz5gwkX
         bUfuvg/lJIXKbOfxzel1+ZvWNTCuBB3SiuNfzql8CZa8jg0OTS+baB/l2rCTNk8jKO2r
         G2waFgQkbtNOkphgRKa3y7P+AjpJc1L1/wHnOzBmtPUZvNKlrkYrv6J75oDWbRU3RdQb
         tA3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683271117; x=1685863117;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MGBat/CgRbSnTAh4bkNae0IKQQw8RA2H99O/HWbocVk=;
        b=DPe3LAsXdiPBS/fNdifL/IOMO/mwtlTcwNgjWroQApWuJRxI0PBe1Mgj1eS3l3yHkX
         +xBwvx2PEcUAS6ux3Lwb+Z0wcYDq2uvv+pj3bygPly554ag5u2Q+vIzTBfVlnur16xsy
         RnP007e2QeK3mLOj5Z56jjUm9w5SWVuIUnAHycIhACcOzOcKVCAFqy0R7vuEwx9t+ps9
         d43cIP+h5qtmwFnNaAd54vUKAWv9pefj0EPRArrI6MrjGwCWm6ZusSYtkX28pjm3eGuj
         J936p+R+e0F2J2q9yX31JvZ7mfmwrmDUMN6reQS5uGWN9JmaDr+5nnvL0pTKkyjSkmN5
         XM7w==
X-Gm-Message-State: AC+VfDw5T+V1YX0+6spCmbEQ6+EQ1CE4+mg2NYpcqY8T14P4DSNQKD85
	vIEoMz/m9g12uQ/NG7D3LgPidQ==
X-Google-Smtp-Source: ACHHUZ52pnllrRP8Kq0YP+n9IlYjk1yMj/IbEylG/jfXnVmVZOclgacQlNorsB22JL0FxY6OadbMYA==
X-Received: by 2002:a17:902:f547:b0:1a6:45e5:a26a with SMTP id h7-20020a170902f54700b001a645e5a26amr792709plf.27.1683271117016;
        Fri, 05 May 2023 00:18:37 -0700 (PDT)
Received: from [10.71.57.173] ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id z12-20020a170903018c00b001aae64e9b36sm935313plg.114.2023.05.05.00.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 May 2023 00:18:36 -0700 (PDT)
Message-ID: <f7a85b88-aa8c-a26a-8ccb-a20c62a76faa@bytedance.com>
Date: Fri, 5 May 2023 15:18:27 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: Re: [PATCH bpf-next v6 1/2] bpf: Add bpf_task_under_cgroup()
 kfunc
To: Hao Luo <haoluo@google.com>
Cc: martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
 kpsingh@kernel.org, sdf@google.com, jolsa@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
 shuah@kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 yangzhenze@bytedance.com, wangdongdong.6@bytedance.com
References: <20230505060818.60037-1-zhoufeng.zf@bytedance.com>
 <20230505060818.60037-2-zhoufeng.zf@bytedance.com>
 <CA+khW7g_gq1N=cNHC-5WG2nZ8a-wHSpwg_fc5=dQpkweGvROqA@mail.gmail.com>
From: Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CA+khW7g_gq1N=cNHC-5WG2nZ8a-wHSpwg_fc5=dQpkweGvROqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

在 2023/5/5 14:58, Hao Luo 写道:
> On Thu, May 4, 2023 at 11:08 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>>
> <...>
>> ---
>>   kernel/bpf/helpers.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
>> index bb6b4637ebf2..453cbd312366 100644
>> --- a/kernel/bpf/helpers.c
>> +++ b/kernel/bpf/helpers.c
>> @@ -2149,6 +2149,25 @@ __bpf_kfunc struct cgroup *bpf_cgroup_from_id(u64 cgid)
>>                  return NULL;
>>          return cgrp;
>>   }
>> +
>> +/**
>> + * bpf_task_under_cgroup - wrap task_under_cgroup_hierarchy() as a kfunc, test
>> + * task's membership of cgroup ancestry.
>> + * @task: the task to be tested
>> + * @ancestor: possible ancestor of @task's cgroup
>> + *
>> + * Tests whether @task's default cgroup hierarchy is a descendant of @ancestor.
>> + * It follows all the same rules as cgroup_is_descendant, and only applies
>> + * to the default hierarchy.
>> + */
>> +__bpf_kfunc long bpf_task_under_cgroup(struct task_struct *task,
>> +                                      struct cgroup *ancestor)
>> +{
>> +       if (unlikely(!ancestor || !task))
>> +               return -EINVAL;
>> +
>> +       return task_under_cgroup_hierarchy(task, ancestor);
>> +}
>>   #endif /* CONFIG_CGROUPS */
>>
> 
> I wonder in what situation a null 'task' or 'ancestor' can be passed.
> Please call out in the comment that the returned value can be a
> negative error, so that writing if(bpf_task_under_cgroup()) may cause
> surprising results.
> 
> Hao

Hmm, you are right. As kfunc, the NULL value of the parameter is judged, 
and bpf verify will prompt the developer to add it. There is really no 
need to add this part of the judgment. See other people's opinions.



