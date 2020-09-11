Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD04266A2A
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgIKViY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgIKViY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:38:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BA0C061573;
        Fri, 11 Sep 2020 14:38:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 694DC1366732E;
        Fri, 11 Sep 2020 14:21:36 -0700 (PDT)
Date:   Fri, 11 Sep 2020 14:38:22 -0700 (PDT)
Message-Id: <20200911.143822.1454479961504655918.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: b53: Configure VLANs while not
 filtering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <12b6df34-6f0b-fb40-2f04-1927d88f5321@gmail.com>
References: <20200911041905.58191-1-f.fainelli@gmail.com>
        <12b6df34-6f0b-fb40-2f04-1927d88f5321@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 14:21:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 11 Sep 2020 11:28:27 -0700

> 
> 
> On 9/10/2020 9:19 PM, Florian Fainelli wrote:
>> Update the B53 driver to support VLANs while not filtering. This
>> requires us to enable VLAN globally within the switch upon driver
>> initial configuration (dev->vlan_enabled).
>> We also need to remove the code that dealt with PVID re-configuration
>> in
>> b53_vlan_filtering() since that function worked under the assumption
>> that it would only be called to make a bridge VLAN filtering, or not
>> filtering, and we would attempt to move the port's PVID accordingly.
>> Now that VLANs are programmed all the time, even in the case of a
>> non-VLAN filtering bridge, we would be programming a default_pvid for
>> the bridged switch ports.
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> David, Jakub, please hold off applying this just yet, Vladimir has
> submitted another patch for testing that would be IMHO a better way to
> deal with DSA switches that have an egress tagged
> default_pvid. Depending on the outcome of that patch, I will resubmit
> this one or request that you apply it.

Ok.
