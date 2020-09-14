Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C542697CB
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgINVhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgINVhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:37:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE725C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:37:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0260C1282952D;
        Mon, 14 Sep 2020 14:21:00 -0700 (PDT)
Date:   Mon, 14 Sep 2020 14:37:46 -0700 (PDT)
Message-Id: <20200914.143746.1677781343005012467.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net-next 0/5] mlxsw: Derive SBIB from maximum port
 speed & MTU
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200913154609.14870-1-idosch@idosch.org>
References: <20200913154609.14870-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 14:21:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 13 Sep 2020 18:46:04 +0300

> From: Ido Schimmel <idosch@nvidia.com>
> 
> Petr says:
> 
> Internal buffer is a part of port headroom used for packets that are
> mirrored due to triggers that the Spectrum ASIC considers "egress". Besides
> ACL mirroring on port egresss this includes also packets mirrored due to
> ECN marking.
> 
> This patchset changes the way the internal mirroring buffer is reserved.
> Currently the buffer reflects port MTU and speed accurately. In the future,
> mlxsw should support dcbnl_setbuffer hook to allow the users to set buffer
> sizes by hand. In that case, there might not be enough space for growth of
> the internal mirroring buffer due to MTU and speed changes. While vetoing
> MTU changes would be merely confusing, port speed changes cannot be vetoed,
> and such change would simply lead to issues in packet mirroring.
> 
> For these reasons, with these patches the internal mirroring buffer is
> derived from maximum MTU and maximum speed achievable on the port.
> 
> Patches #1 and #2 introduce a new callback to determine the maximum speed a
> given port can achieve.
> 
> With patches #3 and #4, the information about, respectively, maximum MTU
> and maximum port speed, is kept in struct mlxsw_sp_port.
> 
> In patch #5, maximum MTU and maximum speed are used to determine the size
> of the internal buffer. MTU update and speed update hooks are dropped,
> because they are no longer necessary.

Series applied, thank you.
