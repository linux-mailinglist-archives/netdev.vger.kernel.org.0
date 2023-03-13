Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60496B7D98
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCMQcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjCMQcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:32:17 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178E57B48D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:31:48 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ek18so19958396edb.6
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1678725080;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iC/9rxrLtt9j5YQSFIj4r+xqIhr4OIPVnE5VID9BZVo=;
        b=YtADCUojuhirIfFRQL1K75A264lIItj+966LATxLRu6s7fqnP9LTwc+RnSBOr2EcbT
         E9kGP2na4r89BHbgbTu7AZ1e5R+jpSnaB0D+TpNokmpEjrkwQP1lBU1uvUz0s8u7y3LR
         5Fh+7q0UUy/aXKPe3Ahm+SWO46nK/U11SFIGasx2DnETfMGQUVbeq+JTp+mBpSLB/INF
         tAvd5mVQKWBnACY+0rdmyJFUjWUtDgiw9T+nRsuzS9o+njas4jw2XdW6qfzy0GeDSTqv
         uoipGOIKoNrL6oWZgqXGCp9qIilYErr0QQwMNpC24KPCzTPF6G30PkHQkm0kAmuqInLZ
         6XOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678725080;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iC/9rxrLtt9j5YQSFIj4r+xqIhr4OIPVnE5VID9BZVo=;
        b=kvP3/EGIVBnNTtUSjn1adddbWsZpHZAxb1mJqH/aEA05ZG521e/9MVC0dwpvoUmz/y
         b7RlikY57+VtDhDTzNRDSLQZo0XGvLX543VreDEU88Ojr3Dz4oC2aWyNw8eFyrfs+6RB
         4WMfFL4wI+g4WmJT0CBsRzr4sIUmFCgLsEcjbOzQvDORn91s+T7iSiBmRF49mnLxFe76
         IERm0sV6mjH627eExuN4rlz+GQvJGA6GxL0oys0DG4jUUaMptVL+8INiErI38Fwz1ys5
         q8fTGho+72xAlRyVrwO0jbSaHgyxRJ0Xnz69pE3h6GB6RldIJYC5jygI7H/nzGJJgsbJ
         B5Ow==
X-Gm-Message-State: AO0yUKWv6nmgljzD96S5lT2RZZfK05gk/cRh/9UaxxIUl1Wcba4k+TPc
        L7Sm/CPApLfHL6br2vbrkadkXg==
X-Google-Smtp-Source: AK7set+PlugTltwa4XqV6a/Qhb5TzyW/J1rlDrVJgoGyg5zLPsyfQOG83Zh0xrpRM/pyV7uWxPOa3A==
X-Received: by 2002:a05:6402:7d3:b0:4b0:87ec:2b98 with SMTP id u19-20020a05640207d300b004b087ec2b98mr33964833edy.16.1678725080373;
        Mon, 13 Mar 2023 09:31:20 -0700 (PDT)
Received: from [10.44.2.5] ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id pw23-20020a17090720b700b008f398f25beesm3629029ejb.189.2023.03.13.09.31.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 09:31:20 -0700 (PDT)
Message-ID: <284f332d-675c-6d7f-94f0-5d8a944ea075@tessares.net>
Date:   Mon, 13 Mar 2023 17:31:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v2 6/8] veth: take into account device reconfiguration
 for xdp_features flag
Content-Language: en-GB
To:     Eric Dumazet <edumazet@google.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, shayagr@amazon.com, akiyano@amazon.com,
        darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
References: <cover.1678364612.git.lorenzo@kernel.org>
 <f20cfdb08d7357b0853d25be3b34ace4408693be.1678364613.git.lorenzo@kernel.org>
 <f5167659-99d7-04a1-2175-60ff1dabae71@tessares.net>
 <CANn89i+4F0QUqyDTqJ8GWrWvGnTyLTxja2hbL1W_rVdMqqmxaQ@mail.gmail.com>
 <CANn89iL=zQQygGg4mkAG+MES6-CpkYBL5KY+kn4j=hAowexVZw@mail.gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <CANn89iL=zQQygGg4mkAG+MES6-CpkYBL5KY+kn4j=hAowexVZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 13/03/2023 16:53, Eric Dumazet wrote:
> On Mon, Mar 13, 2023 at 8:50 AM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Mon, Mar 13, 2023 at 7:15 AM Matthieu Baerts
>> <matthieu.baerts@tessares.net> wrote:
>>>
>>> Hi Lorenzo,
>>>
>>> On 09/03/2023 13:25, Lorenzo Bianconi wrote:
>>>> Take into account tx/rx queues reconfiguration setting device
>>>> xdp_features flag. Moreover consider NETIF_F_GRO flag in order to enable
>>>> ndo_xdp_xmit callback.
>>>>
>>>> Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
>>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>>
>>> Thank you for the modification.
>>>
>>> Unfortunately, 'git bisect' just told me this modification is the origin
>>> of a new WARN when using veth in a netns:
>>>
>>>
>>> ###################### 8< ######################
>>>
>>> =============================
>>> WARNING: suspicious RCU usage
>>> 6.3.0-rc1-00144-g064d70527aaa #149 Not tainted
>>> -----------------------------
>>> drivers/net/veth.c:1265 suspicious rcu_dereference_check() usage!
>>>
>>> other info that might help us debug this:
>>>
>>
>> Same observation here, I am releasing a syzbot report with a repro.
>>
>>
> 
> I guess a fix would be:
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 293dc3b2c84a6c1931e8df42cdcd5f2798004f3c..4da74ac27f9a2425d8d3f4ffcc93f453bd58e3a5
> 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -1262,7 +1262,7 @@ static void veth_set_xdp_features(struct net_device *dev)
>         struct veth_priv *priv = netdev_priv(dev);
>         struct net_device *peer;
> 
> -       peer = rcu_dereference(priv->peer);
> +       peer = rtnl_dereference(priv->peer);
>         if (peer && peer->real_num_tx_queues <= dev->real_num_rx_queues) {
>                 xdp_features_t val = NETDEV_XDP_ACT_BASIC |
>                                      NETDEV_XDP_ACT_REDIRECT |
> 

Thank you for having looked!

This patch avoids the warning on our side.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
