Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7026E9BC3
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 20:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjDTShH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 14:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjDTShE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 14:37:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCA54C01
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 11:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682015714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h8fnLn8BWRY7RpMARBocXs4+D30uJmhAwI4qVpsGczo=;
        b=ZBsObSdOw/gy+/ZBLCytNnew6eZNm3sU4ukNEq0r2+lNyouuBvDTEZTX+rsJdS+0WwPDCG
        ciemPgGQLz5zHkp8d7b8nLWOeMGQDeV1fV4k+e0AmZPVNlvO3473k9FEgS2jZpSW1NJkJj
        sD9G5rrLVwghsZzDHq5waofSLhNJoTA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-uCB-MpQzMAmrYc3XocnvJA-1; Thu, 20 Apr 2023 14:35:11 -0400
X-MC-Unique: uCB-MpQzMAmrYc3XocnvJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67BF3811E7C;
        Thu, 20 Apr 2023 18:35:10 +0000 (UTC)
Received: from [10.45.226.231] (unknown [10.45.226.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A961C16024;
        Thu, 20 Apr 2023 18:35:06 +0000 (UTC)
Message-ID: <54f90db4-dc37-cee4-b5b4-3eedec7cef16@redhat.com>
Date:   Thu, 20 Apr 2023 20:35:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net] net/sched: cls_api: Initialize miss_cookie_node when
 action miss is not used
To:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20230420175952.1114302-1-ivecera@redhat.com>
 <77920a21-96ab-54e5-db3d-5083a11d5691@mojatatu.com>
Content-Language: en-US
From:   Ivan Vecera <ivecera@redhat.com>
In-Reply-To: <77920a21-96ab-54e5-db3d-5083a11d5691@mojatatu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20. 04. 23 20:21, Pedro Tammela wrote:
> On 20/04/2023 14:59, Ivan Vecera wrote:
>> Function tcf_exts_init_ex() sets exts->miss_cookie_node ptr only
>> when use_action_miss is true so it assumes in other case that
>> the field is set to NULL by the caller. If not then the field
>> contains garbage and subsequent tcf_exts_destroy() call results
>> in a crash.
>> Initialize .miss_cookie_node pointer to NULL when use_action_miss
>> parameter is false to avoid this potential scenario.
>>
>> Fixes: 80cd22c35c90 ("net/sched: cls_api: Support hardware miss to tc 
>> action")
>> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
>> ---
>>   net/sched/cls_api.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> index 35785a36c80298..8bc5b9d6a2916e 100644
>> --- a/net/sched/cls_api.c
>> +++ b/net/sched/cls_api.c
>> @@ -3224,8 +3224,12 @@ int tcf_exts_init_ex(struct tcf_exts *exts, 
>> struct net *net, int action,
>>       exts->action = action;
>>       exts->police = police;
>> -    if (!use_action_miss)
>> +    if (!use_action_miss) {
>> +#ifdef CONFIG_NET_CLS_ACT
>> +        exts->miss_cookie_node = NULL;
>> +#endif
>>           return 0;
>> +    }
>>       err = tcf_exts_miss_cookie_base_alloc(exts, tp, handle);
>>       if (err)
> 
> The problem described here also happens in the case some error happens 
> if the action array allocation fails and before the 'miss_cookie_node' 
> assignment inside 'tcf_exts_miss_cookie_base_alloc()'.
> 
> Seems like a better way to solve this issue is to just:
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 35785a36c802..3c3629c9e7b6 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3211,6 +3211,7 @@ int tcf_exts_init_ex(struct tcf_exts *exts, struct 
> net *net, int action,
>   #ifdef CONFIG_NET_CLS_ACT
>          exts->type = 0;
>          exts->nr_actions = 0;
> +       exts->miss_cookie_node = NULL;
>          /* Note: we do not own yet a reference on net.
>           * This reference might be taken later from tcf_exts_get_net().
>           */

Looks better, will repost...

Thanks

Ivan

