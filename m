Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1D3595D8E
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbiHPNmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbiHPNmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:42:09 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C04786C5
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:42:07 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id fy5so19001814ejc.3
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=PVEeRREh3OL/b4k6LxT5u166Qx4UtzET1YgBdzrdUkg=;
        b=dOGn0vFQJ8IF3fmqMG1+AWPYjqm3tXNelcq7AUGPp6R6Z6jY5cXr3zxCuYtfEE0znq
         mKfXvndFeDZK5BWYtEX6TWNr0tfw0b6c84wAakE3yUddNpstQWZLB0UodNX7dfIyRVvT
         VIQvMxzj76LcseoagEyaqa8zRZalaHy2Fz2gX0rTjBrRS02QnFSeATsddjMu7AIowFrM
         O+24Taa2taanvXO8oCwi6RWKeXtivq1lWnETcP0NsF7yNELxG1sYmKRs/ODwrS05EXEV
         OwdNBh7cM0LoVD9a0RgS9m2BajgZkqKKbmUTPtQiqgJ+y+ZJEBepcVi2NaSWbQjXqVH8
         EPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=PVEeRREh3OL/b4k6LxT5u166Qx4UtzET1YgBdzrdUkg=;
        b=6n9oG6ZabTEX/7M69L0tzFyWcX/qMbHBTuYBr0vWraTt7dImHwrR8OQgVaPe9Bn3Ud
         IhIZdcz//O1v0Tw495UllmZrQfGbohJ0s6FUUy3oOIKl0H6y4aNTeKfCPHb9X7/lzrLC
         HSKse4/RUHCDtw5GRFu7vpc6PXwi2ngbGmrigS+i2XR9PkHa6T4mBfXzYAmwF4HI+m4N
         sWYPajpYBk9+UJq/ZsmX9I6xglZsXOhbNcGo0Ye56raXd8O829ra4Gwn6K4FRuUak9tn
         i4OFj2VG01h85Mwv5UBjMIXD7mja9gPxVd4fvTaIALvPOO3gItbmp8Jb8r33CLxRpOlb
         3U4w==
X-Gm-Message-State: ACgBeo1/TSopE4o83oLpivgQxzTyMEmDJCPeu7Yt8wTktb4NcrbDSAOS
        mDqs8IBlxnNbQ9VmOnI/pFLQnkEeYkc=
X-Google-Smtp-Source: AA6agR6naYhUAX5KgHOP6PKwlHfyv1kJeaAoLg6Ae7EbM4Kv0JW96WyEWVpvLj0AtVr42UdcIVwaqQ==
X-Received: by 2002:a17:906:ee8e:b0:730:3646:d178 with SMTP id wt14-20020a170906ee8e00b007303646d178mr13610014ejb.426.1660657326281;
        Tue, 16 Aug 2022 06:42:06 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id kk8-20020a170907766800b0073080c22898sm5466117ejc.15.2022.08.16.06.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 06:42:05 -0700 (PDT)
Subject: Re: [ RFC net-next 2/3] net: flow_offload: add action stats api
To:     Oz Shlomo <ozsh@nvidia.com>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>
References: <20220816092338.12613-1-ozsh@nvidia.com>
 <20220816092338.12613-3-ozsh@nvidia.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <8415607a-04b2-1640-1c01-5d2f94330917@gmail.com>
Date:   Tue, 16 Aug 2022 14:42:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220816092338.12613-3-ozsh@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/08/2022 10:23, Oz Shlomo wrote:
> The current offload api provides visibility to flow hw stats.
> This works as long as the flow stats values apply to all the flow's
> actions. However, this assumption breaks when an action, such as police,
> decides to drop or jump over other actions.
> 
> Extend the flow_offload api to return stat record per action instance.
> Use the per action stats value, if available, when updating the action
> instance counters.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>

When I worked on this before I tried with a similar "array of action
 stats" API [1], but after some discussion it seemed cleaner to have
 a "get stats for one single action" callback [2] which then could
 be called in a loop for filter dumps but also called singly for
 action dumps (RTM_GETACTION).  I recommend this approach to your
 consideration.

[1]: https://lore.kernel.org/all/9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com/
[2]: https://lore.kernel.org/all/a3f0a79a-7e2c-4cdc-8c97-dfebe959ab1f@solarflare.com/

> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 7da3337c4356..7dc8a62796b5 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -499,7 +499,9 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
>  	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
>  			 rtnl_held);
>  
> -	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats);
> +	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats, cls_flower.act_stats);
> +
> +	kfree(cls_flower.act_stats);
>  }

Perhaps I'm being dumb, but I don't see this being allocated
 anywhere.  Is the driver supposed to be responsible for doing so?
 That seems inelegant.

-ed
