Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA475A96F7
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiIAMfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiIAMfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:35:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79985C96D
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 05:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662035733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yDej3L3EBFcquZyEQEc+a5RUlj6LMW4FI5qypeLF5Ro=;
        b=ZPsiv/NItd56KjINsjWSmmM1XiznO7CS3RzKonKW03UoBmYL4diGJp1mFKYuvbrBZVOlU+
        GeUsNqESobHBJCmiOOzWQpUEdMGUQzAZ+Uq1B8PhXQ2H+U+KpnsEuIvYmNXNvp0B7yjxsQ
        RImVMLHSbtDRB3Qy4EoSxDaWky6lKRc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-443-hD89N4kwP1i8fpxtbbol3A-1; Thu, 01 Sep 2022 08:35:31 -0400
X-MC-Unique: hD89N4kwP1i8fpxtbbol3A-1
Received: by mail-wm1-f72.google.com with SMTP id r83-20020a1c4456000000b003a7b679981cso1204156wma.6
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 05:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=yDej3L3EBFcquZyEQEc+a5RUlj6LMW4FI5qypeLF5Ro=;
        b=qkFa43Vx2In9xtSllp1jcwBDbexueI3nWqS64oY8p5vFe/t30Ph5155VWBo6I1LMO/
         BshPpA89hGPiSCAgNKi6xNiLpO73q8jYqx5Zhwp/eC1P925asRsGA6Yqqy8LlZAS2kaD
         bDOLY4K95SBBf9yoHmHkb1JrNDWa5ALD4CdQPfPFA0LIY02rQ6vdDn7/qnyCyY/t4wAF
         jaQFOMMP5/ilhPqiOuxlBsvWeZFeZADH17t/MGjGIYuiKdWFxyf/uGQ0dnDvOFuU+AuP
         d8TJ3mPlP5FVipzEf1TQtDoJnY7FS+5Ccz/2Ag/Z7TXK+902JPnTY+k8HJ7L71dhDJKh
         7gVA==
X-Gm-Message-State: ACgBeo0ZfughmfKcKOqrF0dvMu4k8ScCM7HCj3YFv/8VVEI5Fc7p4z+S
        +6RvgJ0pMG6/wssrsjAoQwY9NpUdALf5cQLoB3+coCBQZMjv/v0nfTMKtD9RbQXkxcsNQ+WPR3d
        iv5h7EWJNBg7FYNsK
X-Received: by 2002:a05:6000:1f0c:b0:226:f3f3:9929 with SMTP id bv12-20020a0560001f0c00b00226f3f39929mr2138896wrb.362.1662035730709;
        Thu, 01 Sep 2022 05:35:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5Qn3VLevJs4PCzhQuaYamKPXouY8mPpkSXkDpdoVfr2pH2/yCqlIePiC8CdVndbpV39DeiKg==
X-Received: by 2002:a05:6000:1f0c:b0:226:f3f3:9929 with SMTP id bv12-20020a0560001f0c00b00226f3f39929mr2138883wrb.362.1662035730510;
        Thu, 01 Sep 2022 05:35:30 -0700 (PDT)
Received: from debian.home (2a01cb058d71f600677dd509c7265258.ipv6.abo.wanadoo.fr. [2a01:cb05:8d71:f600:677d:d509:c726:5258])
        by smtp.gmail.com with ESMTPSA id p8-20020a1c5448000000b003a63a3b55c3sm5794948wmi.14.2022.09.01.05.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:35:30 -0700 (PDT)
Date:   Thu, 1 Sep 2022 14:35:27 +0200
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
Subject: Re: [RFC PATCH net-next v3 2/5] flow_dissector: Add L2TPv3 dissectors
Message-ID: <20220901123527.GA3398@debian.home>
References: <20220901120131.1373568-1-wojciech.drewek@intel.com>
 <20220901120131.1373568-3-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901120131.1373568-3-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 02:01:28PM +0200, Wojciech Drewek wrote:
> Allow to dissect L2TPv3 specific field which is:
> - session ID (32 bits)
> 
> L2TPv3 might be transported over IP or over UDP,
> this ipmplementation is only about L2TPv3 over IP.
> IP protocold carries L2TPv3 when ip_proto is

Nit: you didn't fix the spelling of "protocold". It's probably not
worth to send a new version just because of this typo though.

> Acked-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v3: move !dissector_uses_key() check before calling
>     __skb_header_pointer
> ---
>  include/net/flow_dissector.h |  9 +++++++++
>  net/core/flow_dissector.c    | 28 ++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index 6c74812d64b2..5ccf52ef8809 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -289,6 +289,14 @@ struct flow_dissector_key_pppoe {
>  	__be16 type;
>  };
>  
> +/**
> + * struct flow_dissector_key_l2tpv3:
> + * @session_id: identifier for a l2tp session
> + */
> +struct flow_dissector_key_l2tpv3 {
> +	__be32 session_id;
> +};
> +
>  enum flow_dissector_key_id {
>  	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
>  	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
> @@ -320,6 +328,7 @@ enum flow_dissector_key_id {
>  	FLOW_DISSECTOR_KEY_HASH, /* struct flow_dissector_key_hash */
>  	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
>  	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
> +	FLOW_DISSECTOR_KEY_L2TPV3, /* struct flow_dissector_key_l2tpv3 */
>  
>  	FLOW_DISSECTOR_KEY_MAX,
>  };
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 764c4cb3fe8f..8180e65ab8e2 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -204,6 +204,30 @@ static void __skb_flow_dissect_icmp(const struct sk_buff *skb,
>  	skb_flow_get_icmp_tci(skb, key_icmp, data, thoff, hlen);
>  }
>  
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
> +	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_L2TPV3))
> +		return;
> +
> +	hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data, hlen, &_hdr);
> +	if (!hdr)
> +		return;
> +
> +	key_l2tpv3 = skb_flow_dissector_target(flow_dissector,
> +					       FLOW_DISSECTOR_KEY_L2TPV3,
> +					       target_container);
> +
> +	key_l2tpv3->session_id = hdr->session_id;
> +}
> +
>  void skb_flow_dissect_meta(const struct sk_buff *skb,
>  			   struct flow_dissector *flow_dissector,
>  			   void *target_container)
> @@ -1497,6 +1521,10 @@ bool __skb_flow_dissect(const struct net *net,
>  		__skb_flow_dissect_icmp(skb, flow_dissector, target_container,
>  					data, nhoff, hlen);
>  		break;
> +	case IPPROTO_L2TP:
> +		__skb_flow_dissect_l2tpv3(skb, flow_dissector, target_container,
> +					  data, nhoff, hlen);
> +		break;
>  
>  	default:
>  		break;
> -- 
> 2.31.1
> 

