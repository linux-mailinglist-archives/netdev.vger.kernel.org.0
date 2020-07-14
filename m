Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9226522004D
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgGNVvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgGNVvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:51:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D36C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 14:51:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E54C415E4045B;
        Tue, 14 Jul 2020 14:51:12 -0700 (PDT)
Date:   Tue, 14 Jul 2020 14:51:12 -0700 (PDT)
Message-Id: <20200714.145112.401027331513605821.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 00/13] mlxsw: Mirror to CPU preparations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714142106.386354-1-idosch@idosch.org>
References: <20200714142106.386354-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 14:51:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 14 Jul 2020 17:20:53 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> A future patch set will add the ability to trap packets that were
> dropped due to buffer related reasons (e.g., early drop). Internally
> this is implemented by mirroring these packets towards the CPU port.
> This patch set adds the required infrastructure to enable such
> mirroring.
> 
> Patches #1-#2 extend two registers needed for above mentioned
> functionality.
> 
> Patches #3-#6 gradually add support for setting the mirroring target of
> a SPAN (mirroring) agent as the CPU port. This is only supported from
> Spectrum-2 onwards, so an error is returned for Spectrum-1.
> 
> Patches #7-#8 add the ability to set a policer on a SPAN agent. This is
> required because unlike regularly trapped packets, a policer cannot be
> set on the trap group with which the mirroring trap is associated.
> 
> Patches #9-#12 parse the mirror reason field from the Completion Queue
> Element (CQE). Unlike other trapped packets, the trap identifier of
> mirrored packets only indicates that the packet was mirrored, but not
> why. The reason (e.g., tail drop) is encoded in the mirror reason field.
> 
> Patch #13 utilizes the mirror reason field in order to lookup the
> matching Rx listener. This allows us to maintain the abstraction that an
> Rx listener is mapped to a single trap reason. Without taking the mirror
> reason into account we would need to register a single Rx listener for
> all mirrored packets.

Series applied, thanks Ido.
