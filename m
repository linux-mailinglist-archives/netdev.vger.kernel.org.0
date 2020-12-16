Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4FE2DC786
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 21:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgLPUKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 15:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgLPUKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 15:10:42 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51B8C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 12:10:01 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id u18so51554905lfd.9
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 12:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=h2101cMf55YqZGiixeHdueKN1bwn9y4505cvJB5CG4Y=;
        b=OhdSb/8bMRbx8Mdl7k5ypptqvEHfI/iA1xA7Tutq3de85DJ8p1Jvu7XnsP2TFhFMhU
         zCQqjOw3X9zgEUaHHt77cfbQ6Yskyezmh5ZQIfXnayoTj0v8s9vCb2rRG/68yzVUd3y7
         tejhdenvHPJeUz0GSwANVL2+1vWp0w54ufe1IyHSUZn9dFW2W0Ysqy6MthQaHKaaZ4+8
         y9Qix1RPVLnB4sxlv22gUMlvPhRwC5Tgp1Wt1SQtWTkM8q/MzHdCq5cEpGtgjupe7sCk
         iTe4i+qtRIMlA+xCG0FiiDOtM+ZitcrDi3e85dtr/E8yfMit3TC5VivQI8yP8UhrPnfW
         mONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=h2101cMf55YqZGiixeHdueKN1bwn9y4505cvJB5CG4Y=;
        b=X6NiO9rf70CdmqZqxNV7zl0RbfFxdxBVPXenRVNVsaybg/qCeH/Q9I0bAXNzDLBjHz
         jvQrlmRg7Ba8Ai3UPiB0x+fbi927c0B9YrIqLZiVeykKtP0m0Kz5SkdtjAyLT4FaJJyB
         PdTcGI2fOEKWPGGinyfC5z1aWAZrtZ49dPOgzCuB6uHbTbXX07t+eb64ozlI2XhQriBS
         cUN6y73bCyU4SDhENtiRlYzoNyFB2MbJYEqB8UPLq2u72G/jmvblxBiURiXAN7auF+tP
         Vr//z7RPDlCDADRpB8BoECOPlICq3G6eCHQ+8uiJXti8OrF4hhZiGM8LIMSiUXVL6kAJ
         o/nA==
X-Gm-Message-State: AOAM532+YwzahSdXylqQLvhaYoEjhnss9q4OfrCU6emJip5H/8uxgbry
        0MulIrU9Exwsu9sDt6M4+8R3kA9jWwQEnbGZ
X-Google-Smtp-Source: ABdhPJwpVfDeolshBmjqtaIYGVaKkc5emUPe6UNLaFn/p1Zt3RKV9J0ik3St4W2a0N7SgqzXHQOc5Q==
X-Received: by 2002:a05:651c:130b:: with SMTP id u11mr7758374lja.118.1608149399644;
        Wed, 16 Dec 2020 12:09:59 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id o12sm387371ljp.123.2020.12.16.12.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 12:09:59 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/5] net: dsa: Link aggregation support
In-Reply-To: <20201216184427.amplixitum6x2zui@skbuf>
References: <20201216160056.27526-1-tobias@waldekranz.com> <20201216160056.27526-4-tobias@waldekranz.com> <20201216184427.amplixitum6x2zui@skbuf>
Date:   Wed, 16 Dec 2020 21:09:58 +0100
Message-ID: <87k0thbjhl.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 20:44, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Dec 16, 2020 at 05:00:54PM +0100, Tobias Waldekranz wrote:
>> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
>> index 183003e45762..deee4c0ecb31 100644
>> --- a/net/dsa/dsa2.c
>> +++ b/net/dsa/dsa2.c
>> @@ -21,6 +21,46 @@
>>  static DEFINE_MUTEX(dsa2_mutex);
>>  LIST_HEAD(dsa_tree_list);
>>
>> +void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag)
>
> Maybe a small comment here and in dsa_lag_unmap, describing what they're
> for? They look a bit bland. Just a few words about the linear array will
> suffice.

Not sure I understand why these two are "bland" whereas dsa_switch_find
just below it is not. But sure, I will add a comment. You want a block
comment before each function?

>> +{
>> +	unsigned int id;
>> +
>> +	if (dsa_lag_id(dst, lag) >= 0)
>> +		/* Already mapped */
>> +		return;
>> +
>> +	for (id = 0; id < dst->lags_len; id++) {
>> +		if (!dsa_lag_dev(dst, id)) {
>> +			dst->lags[id] = lag;
>> +			return;
>> +		}
>> +	}
>> +
>> +	/* No IDs left, which is OK. Some drivers do not need it. The
>> +	 * ones that do, e.g. mv88e6xxx, will discover that
>> +	 * dsa_tree_lag_id returns an error for this device when
>> +	 * joining the LAG. The driver can then return -EOPNOTSUPP
>> +	 * back to DSA, which will fall back to a software LAG.
>> +	 */
>> +}
>> +
>> +void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag)
>> +{
>> +	struct dsa_port *dp;
>> +	unsigned int id;
>> +
>> +	dsa_lag_foreach_port(dp, dst, lag)
>> +		/* There are remaining users of this mapping */
>> +		return;
>> +
>> +	dsa_lags_foreach_id(id, dst) {
>> +		if (dsa_lag_dev(dst, id) == lag) {
>> +			dst->lags[id] = NULL;
>> +			break;
>> +		}
>> +	}
>> +}
>> diff --git a/net/dsa/port.c b/net/dsa/port.c
>> index 73569c9af3cc..121e5044dbe7 100644
>> --- a/net/dsa/port.c
>> +++ b/net/dsa/port.c
>> @@ -193,6 +193,85 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
>>  	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
>>  }
>>
>> +int dsa_port_lag_change(struct dsa_port *dp,
>> +			struct netdev_lag_lower_state_info *linfo)
>> +{
>> +	struct dsa_notifier_lag_info info = {
>> +		.sw_index = dp->ds->index,
>> +		.port = dp->index,
>> +	};
>> +	bool tx_enabled;
>> +
>> +	if (!dp->lag_dev)
>> +		return 0;
>> +
>> +	/* On statically configured aggregates (e.g. loadbalance
>> +	 * without LACP) ports will always be tx_enabled, even if the
>> +	 * link is down. Thus we require both link_up and tx_enabled
>> +	 * in order to include it in the tx set.
>> +	 */
>> +	tx_enabled = linfo->link_up && linfo->tx_enabled;
>> +
>> +	if (tx_enabled == dp->lag_tx_enabled)
>> +		return 0;
>
> Why would we get a NETDEV_CHANGELOWERSTATE notification if tx_enabled ==
> dp->lag_tx_enabled? What is it that changed?

A typical scenario would be:

1. Link goes down: linfo->link_up=false linfo->tx_enabled=false
   => tx_enabled=false

2. Link comes up: linfo->link_up=true linfo->tx_enabled=false
   => tx_enabled=false

3. LACP peers: linfo->link_up=true linfo->tx_enabled=true
   => tx_enabled=true

We get three events, but we only go to the hardware for (1) and (3).

>> +
>> +	dp->lag_tx_enabled = tx_enabled;
>> +
>> +	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_CHANGE, &info);
>> +}
>
> I am very happy with how simple this turned out. Thanks for the patience.
> You can add these tags when you resend once net-next opens.
>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Tested-by: Vladimir Oltean <olteanv@gmail.com>

Thank you. Yeah I also like the way it ended up.
