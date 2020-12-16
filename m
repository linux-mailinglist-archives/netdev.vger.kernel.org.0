Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460BB2DC6B4
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 19:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731827AbgLPSpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 13:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731826AbgLPSpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 13:45:12 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23AFC061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 10:44:31 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id p22so25888780edu.11
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 10:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j2kTvw4kzKrAeKpW0mVY6SZ6bjtqkNGUskE2rkwL8hI=;
        b=OEVhropBWscsD9XWEs84l01m3kGYZT3e2TWUPlvGGv77dcPrevBNTxWEqoHWF+wG4n
         hUwaZ2Mw1n+f6OrGxCZMeXo47krazp/V9b7RlS0b11GpN/c1BX6DFouHC4jt68KGYYy2
         gfnCcEHF/dji4mfzqT6Jep5exhJAv9f6so3sZ8J58Da1C0vGQpbIGQdtmxGLlb4wLF+j
         ePnf0OpcHLPR3hrLDcX8EPEykAtZORW8scldQeXH4LG8T8NLCsyA8guYFi8qaii2UFaT
         lQmvttz6hKxQpg/rP8XJJycxI13GKwIj5oXXwP9QP7r49omwwRR7KcI+IsB2ve0mJ57J
         whYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j2kTvw4kzKrAeKpW0mVY6SZ6bjtqkNGUskE2rkwL8hI=;
        b=DIwgvFx92yd1EK6ErPpEY/HQKMONZJAe7sa1M6SXezhOWkMjAsTrrRD8Qe0ZQSxRxY
         KkEhqfiD/HlkJPQRyRiULdzlP9AYZ0MWr/iK1DbR5lurFSaY9Mvw9ecl35fGZbLlc0hj
         gE4T3bWeksr8UuydCNwFTfYV8Tz9+aCNRPR/I6R7J6LOvmn/dB66YjsrTD7JZN9rnq/C
         t+9GPlGW+sl7AfuERRBwe3JQRNwflxESJNnElKU6RJIYpreKldSspEPKf/RV8Vkdr4KT
         xP8tlqk4E2b5063Pf7PtqRF9uexkRi7JmGlrgZdSPKIToMHiB5S2CH8fzjDowqtS9hO0
         tDHg==
X-Gm-Message-State: AOAM532l3+7c1OopZnQO9/5uGt//gADOpi4Ej3OuGzPC9m3pTjKzjXJX
        d9QXcr1XD5ogG45NJtZTKGU=
X-Google-Smtp-Source: ABdhPJyOrv2eDAdNDl8mCeozyZj1aDqMcNpkP/s+Xx4OySZPnLZF38VXTs+Esq6475nYvtcqHGLaLg==
X-Received: by 2002:a50:f604:: with SMTP id c4mr23512092edn.307.1608144269445;
        Wed, 16 Dec 2020 10:44:29 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id ng1sm1958735ejb.112.2020.12.16.10.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 10:44:28 -0800 (PST)
Date:   Wed, 16 Dec 2020 20:44:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/5] net: dsa: Link aggregation support
Message-ID: <20201216184427.amplixitum6x2zui@skbuf>
References: <20201216160056.27526-1-tobias@waldekranz.com>
 <20201216160056.27526-4-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216160056.27526-4-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 05:00:54PM +0100, Tobias Waldekranz wrote:
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index 183003e45762..deee4c0ecb31 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -21,6 +21,46 @@
>  static DEFINE_MUTEX(dsa2_mutex);
>  LIST_HEAD(dsa_tree_list);
>
> +void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag)

Maybe a small comment here and in dsa_lag_unmap, describing what they're
for? They look a bit bland. Just a few words about the linear array will
suffice.

> +{
> +	unsigned int id;
> +
> +	if (dsa_lag_id(dst, lag) >= 0)
> +		/* Already mapped */
> +		return;
> +
> +	for (id = 0; id < dst->lags_len; id++) {
> +		if (!dsa_lag_dev(dst, id)) {
> +			dst->lags[id] = lag;
> +			return;
> +		}
> +	}
> +
> +	/* No IDs left, which is OK. Some drivers do not need it. The
> +	 * ones that do, e.g. mv88e6xxx, will discover that
> +	 * dsa_tree_lag_id returns an error for this device when
> +	 * joining the LAG. The driver can then return -EOPNOTSUPP
> +	 * back to DSA, which will fall back to a software LAG.
> +	 */
> +}
> +
> +void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag)
> +{
> +	struct dsa_port *dp;
> +	unsigned int id;
> +
> +	dsa_lag_foreach_port(dp, dst, lag)
> +		/* There are remaining users of this mapping */
> +		return;
> +
> +	dsa_lags_foreach_id(id, dst) {
> +		if (dsa_lag_dev(dst, id) == lag) {
> +			dst->lags[id] = NULL;
> +			break;
> +		}
> +	}
> +}
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 73569c9af3cc..121e5044dbe7 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -193,6 +193,85 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
>  	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
>  }
>
> +int dsa_port_lag_change(struct dsa_port *dp,
> +			struct netdev_lag_lower_state_info *linfo)
> +{
> +	struct dsa_notifier_lag_info info = {
> +		.sw_index = dp->ds->index,
> +		.port = dp->index,
> +	};
> +	bool tx_enabled;
> +
> +	if (!dp->lag_dev)
> +		return 0;
> +
> +	/* On statically configured aggregates (e.g. loadbalance
> +	 * without LACP) ports will always be tx_enabled, even if the
> +	 * link is down. Thus we require both link_up and tx_enabled
> +	 * in order to include it in the tx set.
> +	 */
> +	tx_enabled = linfo->link_up && linfo->tx_enabled;
> +
> +	if (tx_enabled == dp->lag_tx_enabled)
> +		return 0;

Why would we get a NETDEV_CHANGELOWERSTATE notification if tx_enabled ==
dp->lag_tx_enabled? What is it that changed?

> +
> +	dp->lag_tx_enabled = tx_enabled;
> +
> +	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_CHANGE, &info);
> +}

I am very happy with how simple this turned out. Thanks for the patience.
You can add these tags when you resend once net-next opens.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
