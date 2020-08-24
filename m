Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB22E250BBB
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgHXWfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbgHXWfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 18:35:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B97C061574;
        Mon, 24 Aug 2020 15:35:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC75D12905C11;
        Mon, 24 Aug 2020 15:18:34 -0700 (PDT)
Date:   Mon, 24 Aug 2020 15:35:18 -0700 (PDT)
Message-Id: <20200824.153518.700546598086140133.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     kuba@kernel.org, kurt@linutronix.de, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, bigeasy@linutronix.de,
        richardcochran@gmail.com, kamil.alkhouri@hs-offenburg.de,
        ilias.apalodimas@linaro.org, ivan.khoronzhuk@linaro.org,
        vinicius.gomes@intel.com, xiaoliang.yang_1@nxp.com, Po.Liu@nxp.com
Subject: Re: [PATCH v3 0/8] Hirschmann Hellcreek DSA driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200824220203.atjmjrydq4qyt33x@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de>
        <20200824143110.43f4619f@kicinski-fedora-PC1C0HJN>
        <20200824220203.atjmjrydq4qyt33x@skbuf>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 15:18:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 25 Aug 2020 01:02:03 +0300

> Just my comment on patch 5/8 about netdev->tc_to_txq. There are 2
> distinct things about that:
> - accessing struct net_device directly hurts the DSA model a little bit.
> - I think there's some confusion regarding the use of netdev->tc_to_txq
>   itself. I don't think that's the right place to setup a VLAN PCP to
>   traffic class mapping. That's simply "what traffic class does each
>   netdev queue have". I would even go as far as say that Linux doesn't
>   support a VLAN PCP to TC mapping (similar to the DSCP to TC mapping
>   from the DCB ops) at all, except for the ingress-qos-map and
>   egress-qos-map of the 8021q driver, which can't be offloaded and don't
>   map nicely over existing hardware anyway (what hardware has an
>   ingress-qos-map and an egress-qos-map per individual VLAN?!).
>   Although I do really see the need for having a mapping between VLAN
>   PCP and traffic class, I would suggest Kurt to not expose this through
>   taprio/mqprio (hardcode the PCP mapping as 1-to-1 with TC, as other
>   drivers do), and let's try to come up separately with an abstraction
>   for that.

Agreed, Kurt can you repost this series without the TAPRIO support for
now since it's controversial and needs more discussion and changes?

Thank you.
