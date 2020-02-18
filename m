Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59BF6161F28
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 04:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgBRDBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 22:01:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57928 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgBRDBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 22:01:19 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7649101F0782;
        Mon, 17 Feb 2020 19:01:18 -0800 (PST)
Date:   Mon, 17 Feb 2020 19:01:18 -0800 (PST)
Message-Id: <20200217.190118.1525770684039829483.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     petrm@mellanox.com, pmachata@gmail.com, netdev@vger.kernel.org,
        idosch@mellanox.com, petedaws@gmail.com, daniel@iogearbox.net
Subject: Re: [PATCH net] selftests: forwarding: vxlan_bridge_1d: fix tos
 value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200218020508.GQ2159@dhcp-12-139.nay.redhat.com>
References: <20200217025904.GP2159@dhcp-12-139.nay.redhat.com>
        <87r1ytpkdu.fsf@mellanox.com>
        <20200218020508.GQ2159@dhcp-12-139.nay.redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 19:01:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue, 18 Feb 2020 10:05:08 +0800

> On Mon, Feb 17, 2020 at 11:40:13AM +0100, Petr Machata wrote:
>> RFC2474 states that "DS field [...] is intended to supersede the
>> existing definitions of the IPv4 TOS octet [RFC791] and the IPv6 Traffic
>> Class octet [IPv6]". So the field should be assumed to contain DSCP from
>> that point on. In my opinion, that makes commit 71130f29979c incorrect.
>> 
>> (And other similar uses of RT_TOS in other tunneling devices likewise.)
> 
> Yes, that's also what I mean, should we update RT_TOS to match
> RFC2474?

The RT_TOS() value elides the two lowest bits so that we can store other
pieces of binary state into those two lower bits.

So you can't just blindly change the RT_TOS() definition without breaking
a bunch of things.
