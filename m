Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11AF0135039
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgAIABe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 19:01:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49948 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgAIABd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 19:01:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D7B1715334354;
        Wed,  8 Jan 2020 16:01:32 -0800 (PST)
Date:   Wed, 08 Jan 2020 16:01:32 -0800 (PST)
Message-Id: <20200108.160132.1698183476295743730.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 0/2] Broadcom tags support for 531x5/539x
 families
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200108050606.22090-1-f.fainelli@gmail.com>
References: <20200108050606.22090-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 16:01:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue,  7 Jan 2020 21:06:04 -0800

> This patch series finally allows us to enable Broadcom tags on the
> BCM531x5/BCM539x switch series which are very often cascaded onto
> another on-chip Broadcom switch. Because of that we need to be able to
> detect that Broadcom tags are already enabled on our DSA master which
> happens to be a DSA slave in that case since they are not part of the
> same DSA switch tree, the protocol does not support that.
> 
> Due to the way DSA works, get_tag_protocol() is called prior to
> ds->ops->setup and we do not have all data structures set-up (in
> particular dsa_port::cpu_dp is not filed yet) so doing this at the time
> get_tag_protocol() is called and without exporting a helper function is
> desirable to limit our footprint into the framework.
> 
> Having the core (net/dsa/dsa2.c) return and enforce DSA_TAG_PROTO_NONE
> was considered and done initially but this leaves the driver outside of
> the decision to force/fallback to a particular protocol, instead of
> letting it in control. Also there is no reason to suspect that all
> tagging protocols are problematic, e.g.: "inner" Marvell EDSA with
> "outer" Broadcom tag may work just fine, and vice versa.
> 
> This was tested on:
> 
> - Lamobo R1 which now has working Broadcom tags for its external BCM53125 switch
> - BCM7445 which has a BCM53125 hanging off one of its internal switch
>   port, the BCM53125 still works with DSA_TAG_PROTO_NONE
> - BCM7278 which has a peculiar dual CPU port set-up (so dual IMP mode
>   needs to be enabled)
> - Northstar Plus with DSA_TAG_PROTO_BRCM_PREPEND and no external
>   switches hanging off the internal switch

Series applied, thanks Florian.
