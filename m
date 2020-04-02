Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86C6B19CA68
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 21:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388560AbgDBTpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 15:45:12 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43122 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729123AbgDBTpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 15:45:12 -0400
Received: by mail-pf1-f195.google.com with SMTP id f206so2243584pfa.10
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 12:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UF0I/Xrt+GYFl38Z5n0Hg4BS0pk4GtZM3oG2pJnSjrg=;
        b=RsYRQkGc0jzB+pa9Fjxr16mKubtEgxFtorrga9P9j+vcj/LhG8OZ3B7ZDYl1HDqV/g
         VJSWz2RLXMj34xMjJI9q5DEyHebPzMHDJ4Bl0ylsU97bD2inJ2qMTq5n1vl+q3L5SxFO
         1/3r6M8yyejo1fXvFm/2mpr8B5Tb2HFwxZi9lCASryc5broXrDb+Th4MWHNtrqW5i2I9
         eQzvLNbofhiHftSFbL0RDz72rq8rIdxCr0ERofR4GRcz0JogjcvVIuML5Sx8jK/Q47zH
         4f6bWFIAJItbmyUyTlrD/bmZbHjOcZZYxfKUF3l7fgYbIzIK3Emrk4+r5pNEm4t9WSt0
         zffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UF0I/Xrt+GYFl38Z5n0Hg4BS0pk4GtZM3oG2pJnSjrg=;
        b=rv1ZysXHgiM+nfP7C+6UW+1qpn09cS7hxinUG7qtqO16hbAW0tl68bkrLdtkkfvlWs
         NcvftPbcFJniMrfj9UYORK/5lw9iZXr2FEp0AFRcaYUjr11hRSQAOWteE0Pd6g8uaub+
         GZ4BwiHt4GkNN/tEyexJkEBXnZGufPtTGvKoZzEB6TJvuZ97d85MVGQ9uEI32F7E3Tsv
         JoSO71lq3I3ZBzaON4fWUl5yxJ3oV5tAiCBEg1NUVnbT3543sh19x1kAi3hAdES2plPq
         Vh7+FkBVifeB15LuVtbwjngYkQ2w2lxRm+fokFMPxHuAcKO2N6qGgeK5Tv6JMAkAcLEd
         xhQw==
X-Gm-Message-State: AGi0PuZPcRVp9505iAnpu3UPktzZmbF3iCLNniA2JWu7Ii5MLuqGZy+W
        v2cQEe11gqpEG+SN63Mn+ofiPsYv
X-Google-Smtp-Source: APiQypIlnarlMBqHZXC0B6FYmsp5nCRywWDumT5UPSvB8PR4FtLvUoF6oXC7op1aeqpsLJBIj8645w==
X-Received: by 2002:a62:87cc:: with SMTP id i195mr4774589pfe.75.1585856711388;
        Thu, 02 Apr 2020 12:45:11 -0700 (PDT)
Received: from [192.168.0.16] ([97.115.140.8])
        by smtp.gmail.com with ESMTPSA id y4sm4356907pfo.39.2020.04.02.12.45.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2020 12:45:10 -0700 (PDT)
Subject: Re: [ovs-dev] [PATCH] net: openvswitch: use hlist_for_each_entry_rcu
 instead of hlist_for_each_entry
To:     xiangxia.m.yue@gmail.com, pshelar@ovn.org
Cc:     dev@openvswitch.org, netdev@vger.kernel.org
References: <1585168044-102049-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <9efd290a-aac7-c139-63ab-58f71fee49cf@gmail.com>
Date:   Thu, 2 Apr 2020 12:45:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1585168044-102049-1-git-send-email-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/25/2020 1:27 PM, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> The struct sw_flow is protected by RCU, when traversing them,
> use hlist_for_each_entry_rcu.
> 
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>   net/openvswitch/flow_table.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index fd8a01c..b7b5744 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -462,12 +462,14 @@ static void flow_table_copy_flows(struct table_instance *old,
>   		struct hlist_head *head = &old->buckets[i];
>   
>   		if (ufid)
> -			hlist_for_each_entry(flow, head,
> -					     ufid_table.node[old_ver])
> +			hlist_for_each_entry_rcu(flow, head,
> +						 ufid_table.node[old_ver],
> +						 lockdep_ovsl_is_held())
>   				ufid_table_instance_insert(new, flow);
>   		else
> -			hlist_for_each_entry(flow, head,
> -					     flow_table.node[old_ver])
> +			hlist_for_each_entry_rcu(flow, head,
> +						 flow_table.node[old_ver],
> +						 lockdep_ovsl_is_held())
>   				table_instance_insert(new, flow);
>   	}
>   
> 

Applies cleanly and compile test passes.  Passes openvswitch kernel 
testsuite.  Code looks fine to me.

Tested-by: Greg Rose <gvrose8192@gmail.com>
Reviewed-by: Greg Rose <gvrose8192@gmail.com>

