Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A80FF5AF
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfKPVDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:03:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53796 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbfKPVDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:03:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70772151A15FC;
        Sat, 16 Nov 2019 13:03:12 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:03:12 -0800 (PST)
Message-Id: <20191116.130312.1715585977428653229.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] bonding: symmetric ICMP transmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191115111037.7843-1-mcroce@redhat.com>
References: <20191115111037.7843-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:03:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Fri, 15 Nov 2019 12:10:37 +0100

> A bonding with layer2+3 or layer3+4 hashing uses the IP addresses and the ports
> to balance packets between slaves. With some network errors, we receive an ICMP
> error packet by the remote host or a router. If sent by a router, the source IP
> can differ from the remote host one. Additionally the ICMP protocol has no port
> numbers, so a layer3+4 bonding will get a different hash than the previous one.
> These two conditions could let the packet go through a different interface than
> the other packets of the same flow:
 ...
> An ICMP error packet contains the header of the packet which caused the network
> error, so inspect it and match the flow against it, so we can send the ICMP via
> the same interface of the previous packet in the flow.
> Move the IP and port dissect code into a generic function bond_flow_ip() and if
> we are dissecting an ICMP error packet, call it again with the adjusted offset.
 ...
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied, thanks.
