Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F092427376E
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgIVAbE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Sep 2020 20:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgIVAbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 20:31:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34313C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 17:31:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF5F2127DB648;
        Mon, 21 Sep 2020 17:14:15 -0700 (PDT)
Date:   Mon, 21 Sep 2020 17:31:02 -0700 (PDT)
Message-Id: <20200921.173102.2069908741483449991.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net] net: mscc: ocelot: return error if VCAP filter is
 not found
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921233637.152646-1-vladimir.oltean@nxp.com>
References: <20200921233637.152646-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 17:14:16 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 22 Sep 2020 02:36:37 +0300

> From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> 
> There are 2 separate, but related, issues.
> 
> First, the ocelot_vcap_block_get_filter_index function, née
> ocelot_ace_rule_get_index_id prior to the aae4e500e106 ("net: mscc:
> ocelot: generalize the "ACE/ACL" names") rename, does not do what the
> author probably intended. If the desired filter entry is not present in
> the ACL block, this function returns an index equal to the total number
> of filters, instead of -1, which is maybe what was intended, judging
> from the curious initialization with -1, and the "++index" idioms.
> Either way, none of the callers seems to expect this behavior.
> 
> Second issue, the callers don't actually check the return value at all.
> So in case the filter is not found in the rule list, propagate the
> return code to avoid kernel panics.
> 
> So update the callers and also take the opportunity to get rid of the
> odd coding idioms that appear to work but don't.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Please repost this with an appropriate Fixes: tag.

Thank you.
