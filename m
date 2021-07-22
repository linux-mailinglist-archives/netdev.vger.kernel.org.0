Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5632F3D24AB
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 15:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhGVMwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhGVMwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 08:52:36 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A90FC061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 06:33:12 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id k3so4209424qtq.7
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 06:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a8cJpCaB8s42a39L5HqhxKqGl3pOrVnUmJfRFJRvs4s=;
        b=vOUSlJJvJPemivKTqJcZSCYRb4GAkN7aUdpE9uMucY9SWwI0esP/trVOOaWYylnyKV
         esL3BIkLKKIz7PLq4j21zkKjbt3nB2DxQFGk7k/pNGpTDEjXfrBuG+kpcydBGGFTzE6t
         tWwQZlkOfuR1kuAX286t+uJHYXeoa9y131Hjmj096V9ZcjRBHPb/YCBDKVDkDpME4xbV
         eVmkDNC0fTpX0YzMd307N5GLv8OWSMuPVQVvOHRSc2YuU6o0TS84l84Nu2hGEGDmI0Fm
         EGHQaNXAMCdDpW4RHTDjYhNUxczwcEEQ7Awzt8h1vkBBt7qXnksYTDdMq5gSA0Dg68bi
         It4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a8cJpCaB8s42a39L5HqhxKqGl3pOrVnUmJfRFJRvs4s=;
        b=n9vMeZe/pMdLRy7qOzb6UInSZqntDmKqB0pWErhxncKYJ0yhwIol3t6qP5/E1sTAN0
         OvcRoP2C96WW9VY5j3qhWBLeBO1axHtUmzwCClWu9kbnAxHyPC+qy59NJBDOhjqabUxV
         ZU0vJsyti13AwnwK7V9wnvNFWCwQZqkWq28BX6f3ZTGSMmYiRyVl+rG4drTQGreIp7+c
         FNjzChyh+Vt3TDvs8bOrXUIUoaBfeBvFtbhqUSDJhjdXzFFWOFK9FRlCA55QUP0Mg/R9
         7wLxOu2xdDg+AZiNqa8cqX3ovDiz8KEZ1fBF8Yz0VbbhpAxZp2w25zCNqsKcjI409bnp
         JwLg==
X-Gm-Message-State: AOAM532Fa5zhmge1IBeUVUNqenPZapkhsWiynQEG+9PVq1IAR4ztOkpg
        4+bRkpCKv3g0VfH63PkogMDGkQ==
X-Google-Smtp-Source: ABdhPJzqU+jnNekrcCIDj6E379xkVJy1ROBa/vu+uGNKTYIneKb9VJWQV9LB37zORu7b12SXNMUAxw==
X-Received: by 2002:ac8:4a19:: with SMTP id x25mr35911607qtq.389.1626960791158;
        Thu, 22 Jul 2021 06:33:11 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id e123sm12791185qkf.103.2021.07.22.06.33.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 06:33:10 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
To:     Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
Date:   Thu, 22 Jul 2021 09:33:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ygnhim12qxxy.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-22 9:29 a.m., Vlad Buslov wrote:
> On Thu 22 Jul 2021 at 12:19, Simon Horman <simon.horman@corigine.com> wrote:
>> From: Baowen Zheng <baowen.zheng@corigine.com>
>>
>> Use flow_indr_dev_register/flow_indr_dev_setup_offload to
>> offload tc action.
>>
>> We offload the tc action mainly for ovs meter configuration.
>> Make some basic changes for different vendors to return EOPNOTSUPP.
>>
>> We need to call tc_cleanup_flow_action to clean up tc action entry since
>> in tc_setup_action, some actions may hold dev refcnt, especially the mirror
>> action.
>>
>> As per review from the RFC, the kernel test robot will fail to run, so
>> we add CONFIG_NET_CLS_ACT control for the action offload.
>>
>> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
>> Signed-off-by: Louis Peens <louis.peens@corigine.com>
>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
>> ---
>>   drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
>>   .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  3 ++

>>   			    void *data,
>>   			    void (*cleanup)(struct flow_block_cb *block_cb))
>>   {
>> +	if (!netdev)
>> +		return -EOPNOTSUPP;
>> +
>>   	switch (type) {
>>   	case TC_SETUP_BLOCK:
>>   		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
>> diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c

[..]

>>   
>> +	/* offload actions to hardware if possible */
>> +	tcf_action_offload_cmd(actions, extack);
>> +
> 
> I think this has already been suggested for RFC, but some sort of
> visibility for offload status of action would be extremely welcome.
> Perhaps "IN_HW" flag and counter, similar to what we have for offloaded
> filters.
> 

Also showing a tc command line in the cover letter on how one would
ask for a specific action to be offloaded.

cheers,
jamal
