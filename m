Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA4C2FE0F9
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbhAUEoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731553AbhAUDyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 22:54:44 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93739C0613C1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 19:53:45 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id i5so534595pgo.1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 19:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z3/GB6k6fe5nPvbFcB2OU++JNroGZBPrfitLmiQDTec=;
        b=GhI9xnAUP6scPK7X8Hxo1S9SQbDweWl7K6DMKrXeXWwfR2gg/M8xO8qbKdFXmtahIm
         zC44l+qqEgGqLUp2+SrSD0+HxLq4llMCv9h9AsgKVlvc3gLoo0Z23tQiqLWwAKOKNdwU
         zOxaHaz73WKAIDX9KF/6GycxAYZcUB0xHwCnZHCA3ikPu1Nc6gqPvBYdrB3qr1Oxr41E
         Z4gSj1G22bfukGSvSYNs81eOgMyYVVQA9bBZyQVetFsUInlSKyf8QbgWfq3/PzZhFohX
         4BEBaa5oZALGmum4JkKjHJmnmQ2/0zXTves11rqI2z3OgmCA764fgXEONWOpeaBcj0TK
         LRoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z3/GB6k6fe5nPvbFcB2OU++JNroGZBPrfitLmiQDTec=;
        b=GKM8zWtrvfn/gRGmItgTfpok78+TfUQ3BnAip3SCWxZiaiGgsZg7G+ZsnMh7oG9EzB
         nyS6HyzCy/EcOejA+tkdArAvECiOtBUFgepAe7u2q1LksgElrhCI88EZsQP9ke3C80dK
         Qz9qcOosPNJd646UEeu1yf0hMFuEY7fHAaUm179w1UcY4oondGkOHfRUhGabEwoUbE9i
         hY50t4mq6GwAfehXDr+IYQ+37m6DYUD2EbKRSUrU90qqhgT8QnAV1xqQ3b1FnsOYr/9w
         csPBPjTPaNxwbm+AM95MOYvhO3J4Bv0Xv8stk985JL3uWfzD5nvIAmgSwWIQ6bXPhaGr
         dDrQ==
X-Gm-Message-State: AOAM530cDk62YdpMSWyyO5WmtHINmFJHswjVyvcflXj/eYZIiCA/SGHJ
        jwwns5Vn0wp+OEv45stUyDg=
X-Google-Smtp-Source: ABdhPJytuOdFvYf25r/zr1R/SCA5+gqbB6cqFaPkI/Aw3ubA94IVLuTiir8iiuwHbdzM20D4qHUQng==
X-Received: by 2002:a63:5805:: with SMTP id m5mr12467181pgb.352.1611201224981;
        Wed, 20 Jan 2021 19:53:44 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n128sm3983766pga.55.2021.01.20.19.53.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 19:53:44 -0800 (PST)
Subject: Re: [PATCH v5 net-next 07/10] net: dsa: allow changing the tag
 protocol via the "tagging" device attribute
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
References: <20210121023616.1696021-1-olteanv@gmail.com>
 <20210121023616.1696021-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9c5f179b-056b-f513-6500-eb36f9f8df0e@gmail.com>
Date:   Wed, 20 Jan 2021 19:53:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210121023616.1696021-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/2021 6:36 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently DSA exposes the following sysfs:
> $ cat /sys/class/net/eno2/dsa/tagging
> ocelot
> 
> which is a read-only device attribute, introduced in the kernel as
> commit 98cdb4807123 ("net: dsa: Expose tagging protocol to user-space"),
> and used by libpcap since its commit 993db3800d7d ("Add support for DSA
> link-layer types").
> 
> It would be nice if we could extend this device attribute by making it
> writable:
> $ echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
> 
> This is useful with DSA switches that can make use of more than one
> tagging protocol. It may be useful in dsa_loop in the future too, to
> perform offline testing of various taggers, or for changing between dsa
> and edsa on Marvell switches, if that is desirable.
> 
> In terms of implementation, drivers can now move their tagging protocol
> configuration outside of .setup/.teardown, and into .set_tag_protocol
> and .del_tag_protocol. The calling order is:
> 
> .setup -> [.set_tag_protocol -> .del_tag_protocol]+ -> .teardown
> 
> There was one more contract between the DSA framework and drivers, which
> is that if a CPU port needs to account for the tagger overhead in its
> MTU configuration, it must do that privately. Which means it needs the
> information about what tagger it uses before we call its MTU
> configuration function. That promise is still held.
> 
> Writing to the tagging sysfs will first tear down the tagging protocol
> for all switches in the tree attached to that DSA master, then will
> attempt setup with the new tagger.
> 
> Writing will fail quickly with -EOPNOTSUPP for drivers that don't
> support .set_tag_protocol, since that is checked during the deletion
> phase. It is assumed that all switches within the same DSA tree use the
> same driver, and therefore either all have .set_tag_protocol implemented,
> or none do.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

We talked about it over IRC and I like the approach you have taken, few
comments below:

[snip]

> +static int dsa_switch_tag_proto_del(struct dsa_switch *ds,
> +				    struct dsa_notifier_tag_proto_info *info)
> +{
> +	int err = 0, port;
> +
> +	for (port = 0; port < ds->num_ports; port++) {
> +		if (!dsa_switch_tag_proto_match(ds, port, info))
> +			continue;
> +
> +		/* Check early if we can replace it, so we don't delete it
> +		 * for nothing and leave the switch dangling.
> +		 */
> +		if (!ds->ops->set_tag_protocol) {
> +			err = -EOPNOTSUPP;
> +			break;
> +		}

This can be moved out of the loop.

> +
> +		/* The delete method is optional, just the setter
> +		 * is mandatory
> +		 */
> +		if (ds->ops->del_tag_protocol)
> +			ds->ops->del_tag_protocol(ds, port,
> +						  info->tag_ops->proto);
> +	}
> +
> +	return err;
> +}
> +
> +static int dsa_switch_tag_proto_set(struct dsa_switch *ds,
> +				    struct dsa_notifier_tag_proto_info *info)
> +{
> +	bool proto_changed = false;
> +	int port, err;
> +
> +	for (port = 0; port < ds->num_ports; port++) {
> +		struct dsa_port *cpu_dp = dsa_to_port(ds, port);
> +
> +		if (!dsa_switch_tag_proto_match(ds, port, info))
> +			continue;
> +
> +		err = ds->ops->set_tag_protocol(ds, cpu_dp->index,
> +						info->tag_ops->proto);
> +		if (err)
> +			return err;

Don't you need to test for ds->ops->set_tag_protocol to be implemented
before calling it? Similar comment to earlier, can we do an early check
for the operation being supported outside of the loop?
-- 
Florian
