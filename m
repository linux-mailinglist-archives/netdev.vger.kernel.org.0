Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C964C0D1
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 20:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbfFSSdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 14:33:18 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36821 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfFSSdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 14:33:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id p15so218712qtl.3
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 11:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ezZDRmELX75Qr4j3w5WT3PRC4CuwULI4Jc/cuLFS+KU=;
        b=OMWSTZT3rqO3kELfSVt+SLwz5uAo94pm9vfrx/lHhKnIatUiCndJv5w5lbdBTtEB4s
         2AZ3wXdfTEoiFjeSi9Yw6TKcNfvhy6uFNlySBXcZkTuCAkUjfUfAiWvzCFJRw+r5ZdPN
         tPxOdCxbc8/+sZVkuq2I71wFtEzweoGqC/1CBL8MI/+1kcDp7OGYDJT7LH36FB4fL4hd
         NsK+kXdPzE6c5EkW4zO+AfqSZDBeBnYejaS7CJu8HQaFu45EGq8cbUOTw7kWwb8LmZrC
         kpm0e5ThdYd+rBbWsyP0lc6R0yJvrnl0cYfzdR1qV3FJKKUT28suumLy1i2KlQYU2SgK
         8+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ezZDRmELX75Qr4j3w5WT3PRC4CuwULI4Jc/cuLFS+KU=;
        b=HDdgB/S2uw/K0FaWpJvb/CdAI1nXxujGWOQ+8rjETJtWGRFkSt+nx2D5e0fLGS0ZPM
         4Z5rcZNVXz4w7YrxFuryFTCwHvTb56JhFGbX+hTklQSCkfUqux/gieoilE1HXTANdIFq
         RstiSNtlhYF9d+42HHuo1q3Fh7VRZPUPdYM0CQtoJX2EUdGawy8UuysnzjboW9leUGna
         8OEc8MrgmAsHu+hzh+v3iB5z/hGg4JmWYPd3r2+enE68y2wq5Y4aSRRqO2E1opk/SOc/
         uZPRK9jtW6wYYWp87CBXCTJEYO/EdMURJvis2tWpwumFcILGhHW7fK7m8R8jHk8cPIyX
         J8SQ==
X-Gm-Message-State: APjAAAUSQXbTXEU+LM5YCEmN1sRYUP2q/kVzttU+Fc2bbQUsyOFwRaZN
        Yh+apY8R8pKeBBKKkw5aY/4=
X-Google-Smtp-Source: APXvYqxyu85KfIC6Yma7JovD7YyptKQaf7czroF6SPIxPDw772I8Z5evZEYOcSHXD34fmsiekdPZeQ==
X-Received: by 2002:ac8:3971:: with SMTP id t46mr88295209qtb.164.1560969197165;
        Wed, 19 Jun 2019 11:33:17 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:ed8b:101b:c686:4add:18ab])
        by smtp.gmail.com with ESMTPSA id 2sm12942952qtz.73.2019.06.19.11.33.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 11:33:16 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 8BC56C3BB8; Wed, 19 Jun 2019 15:33:13 -0300 (-03)
Date:   Wed, 19 Jun 2019 15:33:13 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
Message-ID: <20190619183313.GA2746@localhost.localdomain>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560259713-25603-2-git-send-email-paulb@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 04:28:31PM +0300, Paul Blakey wrote:
...
> +static int tcf_ct_fill_params_nat(struct tcf_ct_params *p,
> +				  struct tc_ct *parm,
> +				  struct nlattr **tb,
> +				  struct netlink_ext_ack *extack)
> +{
> +	struct nf_nat_range2 *range;
> +
> +	if (!(p->ct_action & TCA_CT_ACT_NAT))
> +		return 0;
> +
> +	if (!IS_ENABLED(CONFIG_NF_NAT)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Netfilter nat isn't enabled in kernel");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (!(p->ct_action & (TCA_CT_ACT_NAT_SRC | TCA_CT_ACT_NAT_DST)))
> +		return 0;
> +
> +	if ((p->ct_action & TCA_CT_ACT_NAT_SRC) &&
> +	    (p->ct_action & TCA_CT_ACT_NAT_DST)) {
> +		NL_SET_ERR_MSG_MOD(extack, "dnat and snat can't be enabled at the same time");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	range = &p->range;
> +	if (tb[TCA_CT_NAT_IPV4_MIN]) {
> +		range->min_addr.ip =
> +			nla_get_in_addr(tb[TCA_CT_NAT_IPV4_MIN]);
> +		range->flags |= NF_NAT_RANGE_MAP_IPS;
> +		p->ipv4_range = true;
> +	}
> +	if (tb[TCA_CT_NAT_IPV4_MAX]) {
> +		range->max_addr.ip =
> +			nla_get_in_addr(tb[TCA_CT_NAT_IPV4_MAX]);
> +		range->flags |= NF_NAT_RANGE_MAP_IPS;
> +		p->ipv4_range = true;
> +	} else if (range->min_addr.ip) {
> +		range->max_addr.ip = range->min_addr.ip;
> +	}
> +
> +	if (tb[TCA_CT_NAT_IPV6_MIN]) {
> +		range->min_addr.in6 =
> +			nla_get_in6_addr(tb[TCA_CT_NAT_IPV6_MIN]);
> +		range->flags |= NF_NAT_RANGE_MAP_IPS;
> +		p->ipv4_range = false;
> +	}
> +	if (tb[TCA_CT_NAT_IPV6_MAX]) {
> +		range->max_addr.in6 =
> +			nla_get_in6_addr(tb[TCA_CT_NAT_IPV6_MAX]);
> +		range->flags |= NF_NAT_RANGE_MAP_IPS;
> +		p->ipv4_range = false;
> +	} else if (memchr_inv(&range->min_addr.in6, 0,
> +		   sizeof(range->min_addr.in6))) {
> +		range->max_addr.in6 = range->min_addr.in6;

This will overwrite ipv4_max if it was used, as min/max_addr are
unions.
What about having the _MAX handling (for both ipv4/6) inside the
 if (.._MIN) { }  block ?

> +	}
> +
