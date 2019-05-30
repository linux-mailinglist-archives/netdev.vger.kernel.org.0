Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7A430300
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfE3Tw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:52:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59248 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Tw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:52:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2211E14DA9761;
        Thu, 30 May 2019 12:52:27 -0700 (PDT)
Date:   Thu, 30 May 2019 12:52:26 -0700 (PDT)
Message-Id: <20190530.125226.748439790590538564.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, robh+dt@kernel.org,
        mark.rutland@arm.com, ralf@linux-mips.org, paul.burton@mips.com,
        jhogan@kernel.org, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: mscc: ocelot: Hardware ofload for
 tc flower filter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529151802.19aa82a2@cakuba.netronome.com>
References: <1559125580-6375-1-git-send-email-horatiu.vultur@microchip.com>
        <1559125580-6375-3-git-send-email-horatiu.vultur@microchip.com>
        <20190529151802.19aa82a2@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 12:52:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 29 May 2019 15:18:44 -0700

> On Wed, 29 May 2019 12:26:20 +0200, Horatiu Vultur wrote:
>> +static int ocelot_flower_replace(struct tc_cls_flower_offload *f,
>> +				 struct ocelot_port_block *port_block)
>> +{
>> +	struct ocelot_ace_rule *rule;
>> +	int ret;
>> +
>> +	if (port_block->port->tc.block_shared)
>> +		return -EOPNOTSUPP;
> 
> FWIW since you only support TRAP and DROP actions here (AFAICT) you
> should actually be okay with shared blocks.  The problems with shared
> blocks start when the action is stateful (like act_police), because we
> can't share that state between devices.  But for most actions which just
> maintain statistics, it's fine to allow shared blocks.  HTH

Please update to remove this test Horatiu, thanks.
