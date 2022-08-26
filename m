Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E80E5A2605
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 12:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245143AbiHZKm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 06:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235942AbiHZKmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 06:42:55 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC33CD7D29
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:42:53 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w10so1605904edc.3
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=FdN5zUKkGBOrKQLV1ZvOfR+0BymNM0OiS2f3bVRX744=;
        b=lP4MJLrNb44wCWfMLmIlPju1yCW7rK0R8KfTUPb7rSuL8Cko7DR4sIFwSZb7NJis/i
         9l2csiqFrj1avUvnZ6lxI1xBHiM3TR+JPwdXyLrv2JHGN+tPXUR94QmaiISKQNegmxpN
         AqdRvZveLIYdc6u5qbXamR6EnKVLgbjwL37ca+Uqz8MH5Kc7ZUdUKQ+dphmj4vL7oPnN
         fIuHNnhAjrLnWIguCqH0nDnZ7CE1oH3LP5+U+QzxMgE15y7jwIcVZP6/FJZ973Ik841O
         hi/rBGnK+7u1re4vNyVCl9t38k3eEd8UFr1WojHaHUktbXvFcEM8kLEMeF3zvPEa0tI0
         uemw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=FdN5zUKkGBOrKQLV1ZvOfR+0BymNM0OiS2f3bVRX744=;
        b=0VQm/rLimC3SrdAU0KSME8zHGrk04Kr6a6XSmfTrKemRemMpG2NgccazwIlyjseYnK
         QQHkdnnn/i8IaObW//M3kf3yoE1f3S0bUo6YJIV0+uSpzzQPkx11Z/uccqYS3H3a5iGG
         ILK2VSHM66jP4J6oTN+55g/Hl/juJUEhluudgoHT3RB0ktHqc4nGPVyxR+mTs9nMpTT0
         kRDyi2Q6W0ORdb0PSG2bpy+A9jNN5H9sRQwZKTPYkTWbERTiHCqFDfqlWntX72WEMxSM
         GpkqC2zZCqEVBLu3t67C6XpBn/MKE6MggVcLvprNQqBxPRptidw4B1Yq3D8x43RrQcKx
         Z4NQ==
X-Gm-Message-State: ACgBeo0FUE2rOaAGdA0+KcBB38LywtX+yyPPUtZT8jz2clwowCZrzb5m
        g76li4by168zZmtl4fIvh/jwIw==
X-Google-Smtp-Source: AA6agR4c1DTKer5rjgeH9fyewpJ5RPgXkTLRBUPFNoiXpRt2Z15Rit556F7+Kgsuh4QchL3D6fL3aQ==
X-Received: by 2002:a05:6402:248d:b0:437:dd4c:e70e with SMTP id q13-20020a056402248d00b00437dd4ce70emr6180153eda.75.1661510572444;
        Fri, 26 Aug 2022 03:42:52 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id vf19-20020a170907239300b0073de0506745sm721520ejb.197.2022.08.26.03.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 03:42:52 -0700 (PDT)
Message-ID: <ac35421a-c094-6622-afec-6572a3539646@blackwall.org>
Date:   Fri, 26 Aug 2022 13:42:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH ipsec-next,v3 2/3] xfrm: interface: support collect
 metadata mode
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        dsahern@kernel.org, contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220825154630.2174742-1-eyal.birger@gmail.com>
 <20220825154630.2174742-3-eyal.birger@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220825154630.2174742-3-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/08/2022 18:46, Eyal Birger wrote:
> This commit adds support for 'collect_md' mode on xfrm interfaces.
> 
> Each net can have one collect_md device, created by providing the
> IFLA_XFRM_COLLECT_METADATA flag at creation. This device cannot be
> altered and has no if_id or link device attributes.
> 
> On transmit to this device, the if_id is fetched from the attached dst
> metadata on the skb. If exists, the link property is also fetched from
> the metadata. The dst metadata type used is METADATA_XFRM which holds
> these properties.
> 
> On the receive side, xfrmi_rcv_cb() populates a dst metadata for each
> packet received and attaches it to the skb. The if_id used in this case is
> fetched from the xfrm state, and the link is fetched from the incoming
> device. This information can later be used by upper layers such as tc,
> ebpf, and ip rules.
> 
> Because the skb is scrubed in xfrmi_rcv_cb(), the attachment of the dst
> metadata is postponed until after scrubing. Similarly, xfrm_input() is
> adapted to avoid dropping metadata dsts by only dropping 'valid'
> (skb_valid_dst(skb) == true) dsts.
> 
> Policy matching on packets arriving from collect_md xfrmi devices is
> done by using the xfrm state existing in the skb's sec_path.
> The xfrm_if_cb.decode_cb() interface implemented by xfrmi_decode_session()
> is changed to keep the details of the if_id extraction tucked away
> in xfrm_interface.c.
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> 
> ----
> 
> v3:
>   - coding improvements suggested by Nikolay Aleksandrov
>   - use RCU_INIT_POINTER() instead of rcu_assign_pointer() in
>     xfrmi_dev_uninit() and rtnl_dereference() in xfrmi_exit_batch_net()
>     as suggested by Nikolay Aleksandrov
>   - omit redundant check on link assignment from metadata as suggested
>     by Nicolas Dichtel
>   - add missing extack message as suggested by Nicolas Dichtel
> 
> v2:
>   - add "link" property as suggested by Nicolas Dichtel
>   - rename xfrm_if_decode_session_params to xfrm_if_decode_session_result
> ---
>  include/net/xfrm.h           |  11 +++-
>  include/uapi/linux/if_link.h |   1 +
>  net/xfrm/xfrm_input.c        |   7 +-
>  net/xfrm/xfrm_interface.c    | 121 +++++++++++++++++++++++++++++------
>  net/xfrm/xfrm_policy.c       |  10 +--
>  5 files changed, 121 insertions(+), 29 deletions(-)
> 


Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

