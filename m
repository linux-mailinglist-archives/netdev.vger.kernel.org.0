Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDE16F2934
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 16:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjD3Oc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 10:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjD3OcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 10:32:25 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09141BD5
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 07:32:22 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 904A25C0082;
        Sun, 30 Apr 2023 10:32:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 30 Apr 2023 10:32:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682865139; x=1682951539; bh=iAo8xVoItz2rW
        HLwgIWNVD1b67HrR8Gd27ve9ix3y3s=; b=KRsGWAmqZFuR4JMr9qCQnA0AX7N1m
        GHmz6/Ob10V/LvMJuYc1anKQ864ccuCanFXkXA2z+/WuWY+5z55jmoOx7XOuFNn0
        ThQTRnxQ6dUpKkgbAuySrraxXEekhEdb1LbrsSLhQtENCKLGZRdA7JkyvGNnu7Ll
        mIs6ame0Tw13Wg1NkH35xoLV/a9I1xHFFY2tF83uyGTzAAOUqfK/tUzGk2XaL781
        /8qR4UKBtk2BfQh63qRhGFyDfAjYrMKrwVnUatS5eL5TlunCtL4osL4hWtGcD2al
        kicrmSw0d6NSD6eJpuCkMb8stT/1M7VoJFe0zvjtoq5xvmocGt8M1ojbQ==
X-ME-Sender: <xms:8ntOZC4Am71Zc6UZRazDy6e2uDPAFK6dKVqd0BzrhRKwL-3Zb5fEMw>
    <xme:8ntOZL6DhlMiFiCjFNc-LShBSO7YjQgKQZmbgxiKoN5NxIaI0-DpUkOVpndrZ-DUd
    5WHZq06d7i9rzU>
X-ME-Received: <xmr:8ntOZBckK5lBHdGV6q749EL-GQgkvCHxGMXTi8ldOOeZWsYskg388e2pgLRn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedvvddgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:8ntOZPJz4nXr2gUlGuHM8L59T0rDsE6xKOXCYIosFYRva8equYYxMA>
    <xmx:8ntOZGKO8qBDG9cKX1IungtSyv66c41OE-Obk5Zuz40OC0ggtXH93A>
    <xmx:8ntOZAxIcTI1pAFwjoTgWeIWtMwWqjsRr4_gAcsf9CmHqDf_minysA>
    <xmx:83tOZDB9gZehtwAzBlQZ2NZY8LDDgE89VbXYRIwKvrIDlENS9kPtTw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Apr 2023 10:32:18 -0400 (EDT)
Date:   Sun, 30 Apr 2023 17:32:15 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Zahari Doychev <zahari.doychev@linux.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v4 1/3] net: flow_dissector: add support for cfm
 packets
Message-ID: <ZE577xtGlv3fjTF2@shredder>
References: <20230425211630.698373-1-zahari.doychev@linux.com>
 <20230425211630.698373-2-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425211630.698373-2-zahari.doychev@linux.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:16:28PM +0200, Zahari Doychev wrote:
> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> Add support for dissecting cfm packets. The cfm packet header
> fields maintenance domain level and opcode can be dissected.
> 
> Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  include/net/flow_dissector.h | 20 ++++++++++++++++++++
>  net/core/flow_dissector.c    | 30 ++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index 85b2281576ed..479b66b11d2d 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -299,6 +299,25 @@ struct flow_dissector_key_l2tpv3 {
>  	__be32 session_id;
>  };
>  
> +/**
> + * struct flow_dissector_key_cfm
> + * @mdl_ver: maintenance domain level(mdl) and cfm protocol version
                                        ^ missing space

> + * @opcode: code specifying a type of cfm protocol packet
> + *
> + * See 802.1ag, ITU-T G.8013/Y.1731
> + *         1               2
> + * |7 6 5 4 3 2 1 0|7 6 5 4 3 2 1 0|
> + * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> + * | mdl | version |     opcode    |
> + * +-----+---------+-+-+-+-+-+-+-+-+
> + */
> +struct flow_dissector_key_cfm {
> +	u8	mdl_ver;
> +	u8	opcode;
> +};
> +
> +#define FLOW_DIS_CFM_MDL_MASK GENMASK(7, 5)
> +
>  enum flow_dissector_key_id {
>  	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
>  	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
> @@ -331,6 +350,7 @@ enum flow_dissector_key_id {
>  	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
>  	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
>  	FLOW_DISSECTOR_KEY_L2TPV3, /* struct flow_dissector_key_l2tpv3 */
> +	FLOW_DISSECTOR_KEY_CFM, /* struct flow_dissector_key_cfm */
>  
>  	FLOW_DISSECTOR_KEY_MAX,
>  };
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 25fb0bbc310f..62cc1be693de 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -547,6 +547,30 @@ __skb_flow_dissect_arp(const struct sk_buff *skb,
>  	return FLOW_DISSECT_RET_OUT_GOOD;
>  }
>  
> +static enum flow_dissect_ret
> +__skb_flow_dissect_cfm(const struct sk_buff *skb,
> +		       struct flow_dissector *flow_dissector,
> +		       void *target_container, const void *data,
> +		       int nhoff, int hlen)
> +{
> +	struct flow_dissector_key_cfm *key, *hdr, _hdr;
> +
> +	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_CFM))
> +		return FLOW_DISSECT_RET_OUT_GOOD;
> +
> +	hdr = __skb_header_pointer(skb, nhoff, sizeof(*key), data, hlen, &_hdr);
> +	if (!hdr)
> +		return FLOW_DISSECT_RET_OUT_BAD;
> +
> +	key = skb_flow_dissector_target(flow_dissector, FLOW_DISSECTOR_KEY_CFM,
> +					target_container);
> +
> +	key->mdl_ver = hdr->mdl_ver;
> +	key->opcode = hdr->opcode;
> +
> +	return  FLOW_DISSECT_RET_OUT_GOOD;
              ^ double space

> +}
> +
>  static enum flow_dissect_ret
>  __skb_flow_dissect_gre(const struct sk_buff *skb,
>  		       struct flow_dissector_key_control *key_control,
> @@ -1390,6 +1414,12 @@ bool __skb_flow_dissect(const struct net *net,
>  		break;
>  	}
>  
> +	case htons(ETH_P_CFM): {
> +		fdret = __skb_flow_dissect_cfm(skb, flow_dissector,
> +					       target_container, data,
> +					       nhoff, hlen);
> +		break;
> +	}

No variables are declared, drop the braces?

>  	default:
>  		fdret = FLOW_DISSECT_RET_OUT_BAD;
>  		break;
> -- 
> 2.40.0
> 
