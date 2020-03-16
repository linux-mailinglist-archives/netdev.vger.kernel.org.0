Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E74D1860A5
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 01:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgCPACf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 20:02:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42618 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729068AbgCPACf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 20:02:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AFD9B1211040D;
        Sun, 15 Mar 2020 17:02:34 -0700 (PDT)
Date:   Sun, 15 Mar 2020 17:02:31 -0700 (PDT)
Message-Id: <20200315.170231.388798443331914470.davem@davemloft.net>
To:     vincent@bernat.ch
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        kafai@fb.com, dsahern@gmail.com
Subject: Re: [RFC PATCH net-next v1] net: core: enable SO_BINDTODEVICE for
 non-root users
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200315155910.3262015-1-vincent@bernat.ch>
References: <20200315155910.3262015-1-vincent@bernat.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 17:02:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Bernat <vincent@bernat.ch>
Date: Sun, 15 Mar 2020 16:59:11 +0100

> Currently, SO_BINDTODEVICE requires CAP_NET_RAW. This change allows a
> non-root user to bind a socket to an interface if it is not already
> bound. This is useful to allow an application to bind itself to a
> specific VRF for outgoing or incoming connections. Currently, an
> application wanting to manage connections through several VRF need to
> be privileged. Moreover, I don't see a reason why an application
> couldn't restrict its own scope. Such a privilege is already possible
> with UDP through IP_UNICAST_IF.

It could be argued that IP_UNICAST_IF and similar should be privileged
as well.

When the administrator sets up the routes, they don't expect that
arbitrary user applications can "escape" the route configuration by
specifying the interface so readily.
