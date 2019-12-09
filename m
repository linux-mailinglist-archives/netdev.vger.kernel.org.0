Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B5F1173FE
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfLISUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:20:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33836 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfLISUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:20:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 610AB1543B088;
        Mon,  9 Dec 2019 10:20:51 -0800 (PST)
Date:   Mon, 09 Dec 2019 10:20:50 -0800 (PST)
Message-Id: <20191209.102050.2106424689422479418.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net] selftests: forwarding: Delete IPv6 address at the
 end
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209065634.337316-1-idosch@idosch.org>
References: <20191209065634.337316-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 10:20:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon,  9 Dec 2019 08:56:34 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> When creating the second host in h2_create(), two addresses are assigned
> to the interface, but only one is deleted. When running the test twice
> in a row the following error is observed:
> 
> $ ./router_bridge_vlan.sh
> TEST: ping                                                          [ OK ]
> TEST: ping6                                                         [ OK ]
> TEST: vlan                                                          [ OK ]
> $ ./router_bridge_vlan.sh
> RTNETLINK answers: File exists
> TEST: ping                                                          [ OK ]
> TEST: ping6                                                         [ OK ]
> TEST: vlan                                                          [ OK ]
> 
> Fix this by deleting the address during cleanup.
> 
> Fixes: 5b1e7f9ebd56 ("selftests: forwarding: Test routed bridge interface")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied, but wasn't the idea that we run these things in a separate
network namespace so that we don't pollute the top level config even
if the script dies mid-way or something?
