Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B78367B2C0
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 13:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbjAYMuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 07:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjAYMuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 07:50:02 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B69577D3;
        Wed, 25 Jan 2023 04:50:01 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id q10-20020a1cf30a000000b003db0edfdb74so2447380wmq.1;
        Wed, 25 Jan 2023 04:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GIWztrViLruhqrA3Sum0LxEzXWQEdtdzBQds6pkFKVQ=;
        b=KbH6fGsbbkOaLqn+1voZeYNsvQihRMEymKPXvDMGWJ8kVstAgUm7hxzYTKPoPlkLVS
         pL8XDMr0mMecvJhA9v8fKJ0p1Fha+uLhpR1O+fqALjUp4ZRfab0DiLwg527vGUlXwaOW
         IQpx5gI9KUFYBN9rs2hCYHYnNp/HIHnPUIon6Fdqmmeve/oPLO+nI5Qe/5TO0+8W8kbi
         t5AhKH/8Ldw0ExeF95YekjnIprXxOOUvtwIUj529Nf1VsCsT+cGkpp4gtLzPQzfD/9lC
         krJaEpU2zfXQ0zGim6I9DH4P6v1ffrbgAXTvCyz+JzMzhxszIJjfeVEnQ4t5EMluA3rJ
         ZJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GIWztrViLruhqrA3Sum0LxEzXWQEdtdzBQds6pkFKVQ=;
        b=43nnYq/HBvUYhuy5ncYdYbO4SeM46UyzulK2hCQL+bMyBBnOoOzzNu+PFtzzyetBJR
         Z+YcsbFXSPE2xFZA+WlodN73Z/Z+EN/K5fyI86EMoXJWAFVojiPH4kxT6+S49OMNftMz
         iM3AYH+r4a7mnmfq6t8l3/TgeiUL5zTrm0up4A3cMMTZYDZYYD63uKMe5HYnJO6PpGYs
         s5bqcdReJIyXiiBoyAa4cGzwyURXzKKiZURlHRkRy39HCzPMylpQsGzlQGKntAJJ7oBs
         G+vZxYwyuTx7m9If+/AD+qLp/hwE7ry1o2b27YFEeTo+KAWKETkjG3xzcCbremTAu2fM
         y8JQ==
X-Gm-Message-State: AFqh2kqH2/ctRYtaDHq5ZXngs7cEef45PbdN5gRpOsL+n+cr1tG4mJvN
        kGi+eADpRMN9Ipv/SfIHz6c=
X-Google-Smtp-Source: AMrXdXsqgd1xkyIrOp/l2qeZpSLtDd2Yf3DWYBOc7sm9H9eqdqhK3FFrGkami/yFu77+6pReYCDYjA==
X-Received: by 2002:a05:600c:540a:b0:3db:a3a:45ac with SMTP id he10-20020a05600c540a00b003db0a3a45acmr31559568wmb.32.1674651000193;
        Wed, 25 Jan 2023 04:50:00 -0800 (PST)
Received: from [192.168.0.106] ([77.126.163.156])
        by smtp.gmail.com with ESMTPSA id d24-20020a05600c4c1800b003db0cab0844sm1674479wmp.40.2023.01.25.04.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 04:49:59 -0800 (PST)
Message-ID: <6ab07d63-10c7-c591-152b-473ebf37b5ff@gmail.com>
Date:   Wed, 25 Jan 2023 14:49:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Content-Language: en-US
To:     Maxim Mikityanskiy <maxtram95@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andy Gospodarek <gospo@broadcom.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com> <87k0234pd6.fsf@toke.dk>
 <20230103172153.58f231ba@kernel.org> <Y73Ry+nNqOkeZtaj@dragonfly.lan>
 <4866ab1d-4d3c-577c-c94f-a51d82ca56a7@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <4866ab1d-4d3c-577c-c94f-a51d82ca56a7@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13/01/2023 23:07, Tariq Toukan wrote:
> 
> 
> On 10/01/2023 22:59, Maxim Mikityanskiy wrote:
>> On Tue, Jan 03, 2023 at 05:21:53PM -0800, Jakub Kicinski wrote:
>>> On Tue, 03 Jan 2023 16:19:49 +0100 Toke Høiland-Jørgensen wrote:
>>>> Hmm, good question! I don't think we've ever explicitly documented any
>>>> assumptions one way or the other. My own mental model has certainly
>>>> always assumed the first frag would continue to be the same size as in
>>>> non-multi-buf packets.
>>>
>>> Interesting! :) My mental model was closer to GRO by frags
>>> so the linear part would have no data, just headers.
>>>
>>> A random datapoint is that bpf_xdp_adjust_head() seems
>>> to enforce that there is at least ETH_HLEN.
>>
>> Also bpf_xdp_frags_increase_tail has the following check:
>>
>>     if (!rxq->frag_size || rxq->frag_size > xdp->frame_sz)
>>         return -EOPNOTSUPP;
>>
>> However, I can't seem to find where the `frag_size > frame_sz` part is
>> actually used. Maybe this condition can be dropped? Can someone shed
>> some light?
>>
>> BTW, Tariq, we seem to have missed setting frag_size to a non-zero
>> value.
> 
> Hey Maxim,
> Indeed. We use xdp_rxq_info_reg, it passes 0 as frag_size.
> 
>> Could you check that increasing the tail indeed doesn't work on
>> fragmented packets on mlx5e? I can send a oneliner to fix that.
> 
> I can test early next week, and update.

Hi Maxim,

Hacking the existing adjust_tail sample program, in between other high 
prio tasks, to make it work with frags took me some time.
But I can approve the fix below (or equivalent) is needed. Please go on 
and submit it.

Regards,
Tariq

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -600,7 +600,7 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel 
*c, struct mlx5e_params *param
         if (err)
                 return err;

-       return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, 
c->napi.napi_id);
+       return __xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, 
c->napi.napi_id, PAGE_SIZE);
  }

  static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
