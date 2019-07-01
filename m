Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B296D5C09F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbfGAPrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:47:43 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33994 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbfGAPrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:47:42 -0400
Received: by mail-io1-f68.google.com with SMTP id k8so29956923iot.1
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 08:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OfVTi8HSGQbucQnQ2z2zaAjLXbwjLdUCiYBPlRHUr4Y=;
        b=JRsC8dxgZ5dmwha53zTz1Cbd1cxA4ZrzGGNkJjAWfrg+ZXL6mQtz56BgHLL7GiXoIy
         Bj7/MMNnVbXBPeASN5zfsl81nA551TyyrkaEQV29dg6PeMBNeuTx7crUI5PDjE18/1oB
         TyTKmFu9EM5Od0wiPYcJl1ahbWuLxe7G4nVUiGKQGoQvFhICVPvgikr4lzyiZQXW+TZ8
         Cs1//KoaG7DP5uYtQ7buNqb++/F3kT/gbm3N49LjAV+tFQdxYUsAZRiMD75Sg71bQuwv
         ozKAz2z3LCWRk/z9Sp4BUQ6Ma1eYNGkvP99cbyrb5GnUTCwHQ98BQBVtmm/ptAcS4hO+
         Kpng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OfVTi8HSGQbucQnQ2z2zaAjLXbwjLdUCiYBPlRHUr4Y=;
        b=G8uQ3mxRb8Kv9Z63i53qvBRZW5s6Y3u/RqLOf/evS6hoHmeERas21FTdoEoou224jH
         tmIlfdilYpv52+ULcuRVXY1o5+LoTRqnlpAXC9rimH7yvl3UhkbWEk63MhO6t7yPFyNc
         FXxBeqGst0j1zCA62Qt7yiUjXfN0Nj6UezC9R8vJgH7rXz9Xf8+S5aSPnFCjU5uFUB4m
         SP5OB2hxNkPt8jUk1mQ0QskDMh+efFN35dKneMfNZx7UOzV+iR4c2VNB7kWzK+odv/qh
         Vad4ZBkcPFxAaGBqZo+an1MgwVAl/7ZdowK05X+urzcQY2fyz2Z6QQ5SkJ6pjAs+wYcD
         nNjw==
X-Gm-Message-State: APjAAAWoJKm0aayX0qndnixgkyxVd4oejUg8c6Cq8AVukmyUb1eM4qZ2
        vDi8MHsV3wYXqMShtkTx47Q=
X-Google-Smtp-Source: APXvYqyQZD589ggqQzveMkdaUuDT28hRTNdjuyS2MxPrjiombfAKXEkA3ITJ4xokd7Daq76+a8lfsQ==
X-Received: by 2002:a6b:7e41:: with SMTP id k1mr1906923ioq.285.1561996061795;
        Mon, 01 Jul 2019 08:47:41 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f191:fe61:9293:d1ca? ([2601:282:800:fd80:f191:fe61:9293:d1ca])
        by smtp.googlemail.com with ESMTPSA id p25sm12587908iol.48.2019.07.01.08.47.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 08:47:40 -0700 (PDT)
Subject: Re: [PATCH net-next v4 4/5] net: sched: add mpls manipulation actions
 to TC
To:     John Hurley <john.hurley@netronome.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com
References: <1561984257-9798-1-git-send-email-john.hurley@netronome.com>
 <1561984257-9798-5-git-send-email-john.hurley@netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7f8a105b-5e9f-327d-f852-2f9e75e3081f@gmail.com>
Date:   Mon, 1 Jul 2019 09:47:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1561984257-9798-5-git-send-email-john.hurley@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 6:30 AM, John Hurley wrote:
> Currently, TC offers the ability to match on the MPLS fields of a packet
> through the use of the flow_dissector_key_mpls struct. However, as yet, TC
> actions do not allow the modification or manipulation of such fields.
> 
> Add a new module that registers TC action ops to allow manipulation of
> MPLS. This includes the ability to push and pop headers as well as modify
> the contents of new or existing headers. A further action to decrement the
> TTL field of an MPLS header is also provided.

Would be good to document an example here and how to handle a label
stack. The same example can be used with the iproute2 patch (I presume
this one ;-)).


> +static int valid_label(const struct nlattr *attr,
> +		       struct netlink_ext_ack *extack)
> +{
> +	const u32 *label = nla_data(attr);
> +
> +	if (!*label || *label & ~MPLS_LABEL_MASK) {
> +		NL_SET_ERR_MSG_MOD(extack, "MPLS label out of range");
> +		return -EINVAL;
> +	}

core MPLS code (nla_get_labels) checks for MPLS_LABEL_IMPLNULL as well.


> +
> +	return 0;
> +}
> +
> +static const struct nla_policy mpls_policy[TCA_MPLS_MAX + 1] = {
> +	[TCA_MPLS_UNSPEC]	= { .strict_start_type = TCA_MPLS_UNSPEC + 1 },
> +	[TCA_MPLS_PARMS]	= NLA_POLICY_EXACT_LEN(sizeof(struct tc_mpls)),
> +	[TCA_MPLS_PROTO]	= { .type = NLA_U16 },
> +	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_U32, valid_label),
> +	[TCA_MPLS_TC]		= NLA_POLICY_RANGE(NLA_U8, 0, 7),
> +	[TCA_MPLS_TTL]		= NLA_POLICY_MIN(NLA_U8, 1),
> +	[TCA_MPLS_BOS]		= NLA_POLICY_RANGE(NLA_U8, 0, 1),
> +};
> +
> +static int tcf_mpls_init(struct net *net, struct nlattr *nla,
> +			 struct nlattr *est, struct tc_action **a,
> +			 int ovr, int bind, bool rtnl_held,
> +			 struct tcf_proto *tp, struct netlink_ext_ack *extack)
> +{
> +	struct tc_action_net *tn = net_generic(net, mpls_net_id);
> +	struct nlattr *tb[TCA_MPLS_MAX + 1];
> +	struct tcf_chain *goto_ch = NULL;
> +	struct tcf_mpls_params *p;
> +	struct tc_mpls *parm;
> +	bool exists = false;
> +	struct tcf_mpls *m;
> +	int ret = 0, err;
> +	u8 mpls_ttl = 0;
> +
> +	if (!nla) {
> +		NL_SET_ERR_MSG_MOD(extack, "Missing netlink attributes");
> +		return -EINVAL;
> +	}
> +
> +	err = nla_parse_nested(tb, TCA_MPLS_MAX, nla, mpls_policy, extack);
> +	if (err < 0)
> +		return err;
> +
> +	if (!tb[TCA_MPLS_PARMS]) {
> +		NL_SET_ERR_MSG_MOD(extack, "No MPLS params");
> +		return -EINVAL;
> +	}
> +	parm = nla_data(tb[TCA_MPLS_PARMS]);
> +
> +	/* Verify parameters against action type. */
> +	switch (parm->m_action) {
> +	case TCA_MPLS_ACT_POP:
> +		if (!tb[TCA_MPLS_PROTO] ||
> +		    !eth_proto_is_802_3(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
> +			NL_SET_ERR_MSG_MOD(extack, "Invalid protocol type for MPLS pop");

would be better to call out '!tb[TCA_MPLS_PROTO]' with its own 'Protocol
must be set given for pop' message.

