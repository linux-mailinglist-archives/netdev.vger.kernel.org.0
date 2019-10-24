Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAB8BE2991
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 06:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390226AbfJXEcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 00:32:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41904 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfJXEcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 00:32:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::b7e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1A1714B7D540;
        Wed, 23 Oct 2019 21:32:01 -0700 (PDT)
Date:   Wed, 23 Oct 2019 21:31:58 -0700 (PDT)
Message-Id: <20191023.213158.1339777924202893007.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        jiri@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 0/2] mlxsw: Update main pool computation and
 pool size limits
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191023060500.19709-1-idosch@idosch.org>
References: <20191023060500.19709-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Oct 2019 21:32:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 23 Oct 2019 09:04:58 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Petr says:
> 
> In Spectrum ASICs, the shared buffer is an area of memory where packets are
> kept until they can be transmitted. There are two resources associated with
> shared buffer size: cap_total_buffer_size and cap_guaranteed_shared_buffer.
> So far, mlxsw has been using the former as a limit when validating shared
> buffer pool size configuration. However, the total size also includes
> headrooms and reserved space, which really cannot be used for shared buffer
> pools. Patch #1 mends this and has mlxsw use the guaranteed size.
> 
> To configure default pool sizes, mlxsw has historically hard-coded one or
> two smallish pools, and one "main" pool that took most of the shared buffer
> (that would be pool 0 on ingress and pool 4 on egress). During the
> development of Spectrum-2, it became clear that the shared buffer size
> keeps shrinking as bugs are identified and worked around. In order to
> prevent having to tweak the size of pools 0 and 4 to catch up with updates
> to values reported by the FW, patch #2 changes the way these pools are set.
> Instead of hard-coding a fixed value, the main pool now takes whatever is
> left from the guaranteed size after the smaller pool(s) are taken into
> account.

Series applied, thanks.
