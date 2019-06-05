Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE6A35507
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 03:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfFEBex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 21:34:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55456 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfFEBex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 21:34:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ABD4315042E97;
        Tue,  4 Jun 2019 18:34:52 -0700 (PDT)
Date:   Tue, 04 Jun 2019 18:34:52 -0700 (PDT)
Message-Id: <20190604.183452.368761665430431543.davem@davemloft.net>
To:     timbeale@catalyst.net.nz
Cc:     netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net] udp: only choose unbound UDP socket for multicast
 when not in a VRF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559613383-6086-1-git-send-email-timbeale@catalyst.net.nz>
References: <1559613383-6086-1-git-send-email-timbeale@catalyst.net.nz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 18:34:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tim Beale <timbeale@catalyst.net.nz>
Date: Tue,  4 Jun 2019 13:56:23 +1200

> By default, packets received in another VRF should not be passed to an
> unbound socket in the default VRF. This patch updates the IPv4 UDP
> multicast logic to match the unicast VRF logic (in compute_score()),
> as well as the IPv6 mcast logic (in __udp_v6_is_mcast_sock()).
> 
> The particular case I noticed was DHCP discover packets going
> to the 255.255.255.255 address, which are handled by
> __udp4_lib_mcast_deliver(). The previous code meant that running
> multiple different DHCP server or relay agent instances across VRFs
> did not work correctly - any server/relay agent in the default VRF
> received DHCP discover packets for all other VRFs.
> 
> Signed-off-by: Tim Beale <timbeale@catalyst.net.nz>

Applied and queued up for -stable, thanks.
