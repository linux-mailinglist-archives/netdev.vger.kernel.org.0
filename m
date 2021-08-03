Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B193DEB60
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbhHCK72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbhHCK7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 06:59:25 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCE7C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 03:59:14 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id d17so10332017qvn.13
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 03:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WqVDOOD2CmKl6daNIP1LxWICSx1HFmBFzl92dEBDb3M=;
        b=JgNpSD02DGbL/Do79TXqndWg1jhAI7+ryBiBrx/gKnwy4XXw07wn7kLxVIabhr697x
         jNGafa/brMUU5ldpqwW3mM6G/cy+uNa/6QWou8QByaraqxbbZvgB+RWF9PAtxEylUCiZ
         0xMB71DXXf1jDfwMePvBxflHmj5wBm7cIUnxsw8S320LvJkScqq5bqxeqHSFme/4uUdq
         YcVbgg5LChufE/gSL+xI7n9JCDmNN939wOO+AKlnh5IwCibwqP8bkDxi5a4ttzW0/kkd
         LxfS1knFgAkbQ5X9PfmL3ushcfYmCO112najEoJ8VL+JnRKFhO15pvB5OWQlY3zf4FFz
         v+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WqVDOOD2CmKl6daNIP1LxWICSx1HFmBFzl92dEBDb3M=;
        b=lPd70tRaAVqbzo+NJvnAnvE38NSzEaSK8b99ATStPeNi/TaPXBahCrLhv5R2py7tZs
         4626FxA0qbKMKCBG8L1zYISES7sts6y+AR6obGHnCwuYciiUUkTfESWKJ4oTscGzyDzc
         QA67cg7+tK26WXHvMWyEoI/dPdjv9KnBW/cPup39aKy5N50Y7sH4znv/PEW2kp0+4wQc
         H6Ftk5FPwXG9R11dOOGLHYM6WwiGQab/+69gel9c3pvBc1Uc+iUfZ4vocAQ6WSSQCcnj
         HkTCi1aj2PimIdfSEw3C13D2K3CF9MFBameTQMf56nCpnFrUDxqZbkFYd/etBQWAdA9L
         5Fqw==
X-Gm-Message-State: AOAM532idEEqQ2ukY+ziLzBhje8oKOxqgVy9ay0flvmBJxNts5wkEgb8
        k2PeH/f+4K8w0FJzDA8c7ohB5Q==
X-Google-Smtp-Source: ABdhPJykA1h7C8UXuT3CGb2hp7m0iz+G6oC54temsQcRRKpqtv8+oq0Ln5g179+JX4ARa7iFRLIb5w==
X-Received: by 2002:ad4:4152:: with SMTP id z18mr8416214qvp.43.1627988354110;
        Tue, 03 Aug 2021 03:59:14 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id c3sm7673248qkd.12.2021.08.03.03.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 03:59:13 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] flow_offload: add process to delete
 offloaded actions from net device
To:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-3-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <676ab9e4-c05b-ddfd-fb97-6560e5d1a9b4@mojatatu.com>
Date:   Tue, 3 Aug 2021 06:59:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210722091938.12956-3-simon.horman@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-22 5:19 a.m., Simon Horman wrote:

[..]


>   tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
>   	      u32 portid, int event, struct netlink_ext_ack *extack)
>   {
> -	int i, ret;
>   	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
>   	struct tc_action *act;
>   	size_t attr_size = 0;
>   	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {};
> +	struct flow_offload_action *fl_act;
> +	int i, ret, fallback_num;
>   
>   	ret = nla_parse_nested_deprecated(tb, TCA_ACT_MAX_PRIO, nla, NULL,
>   					  extack);
> @@ -1492,7 +1568,9 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
>   	if (event == RTM_GETACTION)
>   		ret = tcf_get_notify(net, portid, n, actions, event, extack);
>   	else { /* delete */
> -		ret = tcf_del_notify(net, n, actions, portid, attr_size, extack);
> +		tcf_action_offload_cmd_pre(actions, FLOW_ACT_DESTROY, extack, &fl_act);
> +		ret = tcf_del_notify(net, n, actions, portid, attr_size, extack, &fallback_num);
> +		tcf_action_offload_del_post(fl_act, actions, extack, fallback_num);
>   		if (ret)
>   			goto err;

It is hard to read from a patch context, but iiuc:
if the hardware update fails in tcf_action_offload_del_post() then
user space would still have been notified that it succeeded via
tcf_del_notify()... and there is no remediation after the fact.


cheers,
jamal

