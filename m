Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65F35A7AF4
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 12:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiHaKHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 06:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiHaKHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 06:07:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439CDA5980
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 03:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661940440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N6qTg3zNKwUeekagaUfED5pDaKwZg5a4Zk5uKz1rgHU=;
        b=F0RW1RMWQ/KmHyOhIczkxHNHuteXNz96efvny3JphJo9A1hUpGrkf3NgBpIlt60dVJgnAx
        jLlvTBt0tDjbw5ZP721uzMFvM4GJS/ItjXhYffEq8qaNXcHvkzpUECC3N4QsdIuQbiAkty
        x4XElsSJr9FjLeTJjyVAlS//e2OJFDc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-22-XXhxJnRRPwiFQH2uuTknDA-1; Wed, 31 Aug 2022 06:07:19 -0400
X-MC-Unique: XXhxJnRRPwiFQH2uuTknDA-1
Received: by mail-wr1-f71.google.com with SMTP id r19-20020adfa153000000b00226d74bc332so1660801wrr.3
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 03:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=N6qTg3zNKwUeekagaUfED5pDaKwZg5a4Zk5uKz1rgHU=;
        b=4CuwkDhBwtMbQXaWvvGaYEn2nuuCQZDCDuuD2JMUx0T1ETFnKm821OlrMc5HFxxBF9
         e0d/aDeXI8cBz3/u0Fj+SlA88erC/hYlv6LjU/t3aYjYCaeKMUf1T7hrKHIku/OnFRmA
         ERO9/gSQhmo83jORHWq79mFK6cCuSmz/IdSPPSqNerAYIjwacVVzuVuBgwi2aQ/GtFAZ
         LzQmNGstRlEzDLweD9YbmX7xp8oCIYDbsUPqjmKOjD8Wu51WRc1RkKy/4G0YH7318bps
         UllYolq/asYGwNfJGxnUtbZJg6qWFp8lCRAANQ1gEHC4/RYXfpCA/PcumjhxLHPamL9H
         nkYA==
X-Gm-Message-State: ACgBeo2kwW9s9zJFzKK1DQxIyYwVvLzztaHRxP996iYkNcki03uqZ9t2
        uZgET2MWVbm7w2zfNzsBoPydwboMazr8IrwmMfJD8wmRxJOlW09c8H9Rt+jvR+fEHkddiOcg1AR
        GtcgAfd6KVVIVFF1E
X-Received: by 2002:a5d:4601:0:b0:21d:8db4:37c with SMTP id t1-20020a5d4601000000b0021d8db4037cmr11399416wrq.390.1661940438333;
        Wed, 31 Aug 2022 03:07:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6kHs+Sp137BQe+CSjnCGyd7UQhlMUbSrC1+biZ71oz51MxP8zhkNF8F0zWk3I3qThpWDFz7A==
X-Received: by 2002:a5d:4601:0:b0:21d:8db4:37c with SMTP id t1-20020a5d4601000000b0021d8db4037cmr11399392wrq.390.1661940438091;
        Wed, 31 Aug 2022 03:07:18 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id x4-20020a5d4904000000b0021e30e9e44asm11634009wrq.53.2022.08.31.03.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 03:07:17 -0700 (PDT)
Date:   Wed, 31 Aug 2022 12:07:15 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, marcin.szycik@linux.intel.com,
        michal.swiatkowski@linux.intel.com, kurt@linutronix.de,
        boris.sukholitko@broadcom.com, vladbu@nvidia.com,
        komachi.yoshiki@gmail.com, paulb@nvidia.com,
        baowen.zheng@corigine.com, louis.peens@corigine.com,
        simon.horman@corigine.com, pablo@netfilter.org,
        maksym.glubokiy@plvision.eu, intel-wired-lan@lists.osuosl.org,
        jchapman@katalix.com
Subject: Re: [RFC PATCH net-next v2 2/5] flow_dissector: Add L2TPv3 dissectors
Message-ID: <20220831100715.GB18919@pc-4.home>
References: <20220829094412.554018-1-wojciech.drewek@intel.com>
 <20220829094412.554018-3-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829094412.554018-3-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 11:44:09AM +0200, Wojciech Drewek wrote:
> Allow to dissect L2TPv3 specific field which is:
> - session ID (32 bits)
> 
> L2TPv3 might be transported over IP or over UDP,
> this ipmplementation is only about L2TPv3 over IP.
> IP protocold carries L2TPv3 when ip_proto is

s/protocold/protocol/

> +static void __skb_flow_dissect_l2tpv3(const struct sk_buff *skb,
> +				      struct flow_dissector *flow_dissector,
> +				      void *target_container, const void *data,
> +				      int nhoff, int hlen)
> +{
> +	struct flow_dissector_key_l2tpv3 *key_l2tpv3;
> +	struct {
> +		__be32 session_id;
> +	} *hdr, _hdr;
> +
> +	hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data, hlen, &_hdr);
> +	if (!hdr)
> +		return;
> +
> +	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_L2TPV3))
> +		return;

I'd find it more logical to test !dissector_uses_key() first, then call
__skb_header_pointer(). But that probably just a personnal preference.

In any case the code looks good to me.

Acked-by: Guillaume Nault <gnault@redhat.com>

