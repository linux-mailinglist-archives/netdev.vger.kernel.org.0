Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDD63DEBAF
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbhHCLZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbhHCLZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 07:25:00 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1082C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 04:24:49 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id l24so13684327qtj.4
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 04:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2P5RHXeXCy8afq7uLYOoI4479PxrXrrMNoK9Swy9ltA=;
        b=AR4Bv0Or6IBsAiUq8cv+KVCsRRZU/OufZ4DnBS6kicovruKMv/d27m9t28Ruse8s5K
         K4z6V6MDmJdSOHX9m1tQsNwy6tFJ7JElZjI9dET1J9FYZ3OrSqLfWw2yMV45IkW8gWZi
         Nf7yJwb4ftocrKJEILnFdagnV6LWEpS+EhkCC+7bt3DY9BgqZp9rhgLcPmk4T+4qflfy
         4FkyedQ1oPl1sQRH9b1JlreMbLsBBr+N/BAtHC14wxqM3KJ25m+C8aWoRkPKsSV/Nisu
         8uXZ7hwpUCYyMtiZTuVhB26zMXOLu2S8kLUWxGhJyB3r34KMsyFxVJCp2t6Htyw7wHWn
         xZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2P5RHXeXCy8afq7uLYOoI4479PxrXrrMNoK9Swy9ltA=;
        b=KhvqRLZwjuHccM3GZpTjM11EUNu8OQqpCKNMqggef3MJtnCYlCr47TpIkgo0oRh9AB
         kiJ1LuBLdNPA1g/NLamEEVz0px4bEJ/O4tArK1zIaUSCRbe/rsFIR1Vtr7Mr8jQPLAQK
         PdGxghIwuh8OtmvQeJvf5lBeEiPj/RrfPALZAoGg5tdcJIKaWX9+IgI3o3k5cKbHKCKK
         dIVRmsaLyqhJhO/K2HTTOXaD3ZrO1l2w+R/aH+ttxEVVFLU/2ihWKUQ8y7xGQswSHAlI
         gNsnqwHNXVYBzImAmpX6NrYlcS8U1TuGObyMdcg038LMtJSZTT/DoYYrImoMErOUmWTO
         4RDQ==
X-Gm-Message-State: AOAM532FIUEOqa5myfqY9FzSkFmiz4XFPFjGYt6xtisZLkbUVGmBahZd
        0+hRpORjA08qHzlrUduSHanzeA==
X-Google-Smtp-Source: ABdhPJxWEyhm2WvVuirrDe+QVFsehrGwo9edHgMMpXu9yzZmdwi+kZdqX0Y1Gz24e6Tl1P82l2SaVg==
X-Received: by 2002:ac8:59c6:: with SMTP id f6mr6801410qtf.232.1627989888716;
        Tue, 03 Aug 2021 04:24:48 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id i67sm7900124qkd.90.2021.08.03.04.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 04:24:48 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] flow_offload: add process to update action
 stats from hardware
To:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-4-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <f9a130e8-f692-69c4-8183-dc04a5340430@mojatatu.com>
Date:   Tue, 3 Aug 2021 07:24:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210722091938.12956-4-simon.horman@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-22 5:19 a.m., Simon Horman wrote:

[..]

>   /* offload the tc command after deleted */
>   int tcf_action_offload_del_post(struct flow_offload_action *fl_act,
>   				struct tc_action *actions[],
> @@ -1255,6 +1293,9 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
>   	if (p == NULL)
>   		goto errout;
>   
> +	/* update hw stats for this action */
> +	tcf_action_update_hw_stats(p);

This is more a curiosity than a comment on the patch: Is the
driver polling for these stats synchronously and what we get here
is the last update or do we end up invoking beyond
the driver when requesting for the stats?

Overall commentary from looking at the patch set:
I believe your patches will support the individual tc actions
add/del/get/dump command line requests.
What is missing is an example usage all the way to the driver. I am sure
you have additional patches that put this to good  use. My suggestion
is to test that cli with that pov against your overall patches and
show this in your commit logs - even if those patches are to follow
later.


cheers,
jamal
