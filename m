Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D18E248EC6
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgHRTef convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Aug 2020 15:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgHRTee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:34:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985F7C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:34:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64EEE1279E90C;
        Tue, 18 Aug 2020 12:17:48 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:34:33 -0700 (PDT)
Message-Id: <20200818.123433.794427906392998261.davem@davemloft.net>
To:     alsi@bang-olufsen.dk
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] macvlan: validate setting of multiple
 remote source MAC addresses
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818085134.3228896-1-alsi@bang-olufsen.dk>
References: <20200817.145542.1273892481485714633.davem@davemloft.net>
        <20200818085134.3228896-1-alsi@bang-olufsen.dk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 12:17:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin ¦ipraga <alsi@bang-olufsen.dk>
Date: Tue, 18 Aug 2020 10:51:34 +0200

> Remote source MAC addresses can be set on a 'source mode' macvlan
> interface via the IFLA_MACVLAN_MACADDR_DATA attribute. This commit
> tightens the validation of these MAC addresses to match the validation
> already performed when setting or adding a single MAC address via the
> IFLA_MACVLAN_MACADDR attribute.
> 
> iproute2 uses IFLA_MACVLAN_MACADDR_DATA for its 'macvlan macaddr set'
> command, and IFLA_MACVLAN_MACADDR for its 'macvlan macaddr add' command,
> which demonstrates the inconsistent behaviour that this commit
> addresses:
> 
>  # ip link add link eth0 name macvlan0 type macvlan mode source
>  # ip link set link dev macvlan0 type macvlan macaddr add 01:00:00:00:00:00
>  RTNETLINK answers: Cannot assign requested address
>  # ip link set link dev macvlan0 type macvlan macaddr set 01:00:00:00:00:00
>  # ip -d link show macvlan0
>  5: macvlan0@eth0: <BROADCAST,MULTICAST,DYNAMIC,UP,LOWER_UP> mtu 1500 ...
>      link/ether 2e:ac:fd:2d:69:f8 brd ff:ff:ff:ff:ff:ff promiscuity 0
>      macvlan mode source remotes (1) 01:00:00:00:00:00 numtxqueues 1 ...
> 
> With this change, the 'set' command will (rightly) fail in the same way
> as the 'add' command.
> 
> Signed-off-by: Alvin ¦ipraga <alsi@bang-olufsen.dk>

Applied, thank you.
