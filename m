Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC2EF2E088
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 17:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfE2PH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 11:07:27 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:55303 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfE2PH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 11:07:26 -0400
X-Originating-IP: 90.88.147.134
Received: from bootlin.com (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 033FBFF805;
        Wed, 29 May 2019 15:07:22 +0000 (UTC)
Date:   Wed, 29 May 2019 17:07:25 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] ethtool: Drop check for vlan etype and vlan
 tci when parsing flow_rule
Message-ID: <20190529170725.5856dd65@bootlin.com>
In-Reply-To: <20190529141044.24669-1-maxime.chevallier@bootlin.com>
References: <20190529141044.24669-1-maxime.chevallier@bootlin.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 16:10:44 +0200
Maxime Chevallier <maxime.chevallier@bootlin.com> wrote:

>When parsing an ethtool flow spec to build a flow_rule, the code checks
>if both the vlan etype and the vlan tci are specified by the user to add
>a FLOW_DISSECTOR_KEY_VLAN match.
>
>However, when the user only specified a vlan etype or a vlan tci, this
>check silently ignores these parameters.
>
>For example, the following rule :
>
>ethtool -N eth0 flow-type udp4 vlan 0x0010 action -1 loc 0
>
>will result in no error being issued, but the equivalent rule will be
>created and passed to the NIC driver :
>
>ethtool -N eth0 flow-type udp4 action -1 loc 0
>
>In the end, neither the NIC driver using the rule nor the end user have
>a way to know that these keys were dropped along the way, or that
>incorrect parameters were entered.
>
>This kind of check should be left to either the driver, or the ethtool
>flow spec layer.
>
>This commit makes so that ethtool parameters are forwarded as-is to the
>NIC driver.
>
>Since none of the users of ethtool_rx_flow_rule_create are using the
>VLAN dissector, I don't think this qualifies as a regression.
>
>Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

I should have targeted this to -net, and provided a Fixes tag.
Let me resend that to the proper tree.

Sorry about the noise,

Maxime
