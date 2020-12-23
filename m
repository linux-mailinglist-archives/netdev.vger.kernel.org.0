Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0B52E213D
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgLWUWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:22:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgLWUWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 15:22:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65DD42151B;
        Wed, 23 Dec 2020 20:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608754932;
        bh=6nziSX9pXTDslXWk3xxiYG4rsaGTqy0cKAr4xbFjJ1M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z8KoyYaCVfHRdKD5Nb7P/iNPfwSH+o8AJWWbl+4mzgFAtIEVEenthmRtCM0NRuePK
         kBtFvgJYTEQdTmiS3Rk1p+05UfvBPY8YnYu6anjyfLQq1eYsh6kFC3SnmwCkxJJ9On
         mzeP/1HTm0qP2xZmsG9Ioibog9LItNChUyYEILHwvsae7ZzRj+1hzmKskCE6A5yNf5
         1BGKFYycqdUUMwBUWdDuo4WQg4ckolPX4s8a7TNdGadLy04NEp7LeWRvIXPVCu/zxe
         BpYuOkDq8CjqaxYKWKzjuNWzbGFxwxjvtDdEmtwcOTQ0hwVlKGNqMbKBoqmMrl167a
         OGplU2edDQfcA==
Date:   Wed, 23 Dec 2020 12:22:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <me@pmachata.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH net] net: dcb: Validate netlink message in DCB handler
Message-ID: <20201223122211.31b8f3c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a2a9b88418f3a58ef211b718f2970128ef9e3793.1608673640.git.me@pmachata.org>
References: <a2a9b88418f3a58ef211b718f2970128ef9e3793.1608673640.git.me@pmachata.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Dec 2020 22:49:44 +0100 Petr Machata wrote:
> DCB uses the same handler function for both RTM_GETDCB and RTM_SETDCB
> messages. dcb_doit() bounces RTM_SETDCB mesasges if the user does not have
> the CAP_NET_ADMIN capability.
> 
> However, the operation to be performed is not decided from the DCB message
> type, but from the DCB command. Thus DCB_CMD_*_GET commands are used for
> reading DCB objects, the corresponding SET and DEL commands are used for
> manipulation.
> 
> The assumption is that set-like commands will be sent via an RTM_SETDCB
> message, and get-like ones via RTM_GETDCB. However, this assumption is not
> enforced.
> 
> It is therefore possible to manipulate DCB objects without CAP_NET_ADMIN
> capability by sending the corresponding command in an RTM_GETDCB message.
> That is a bug. Fix it by validating the type of the request message against
> the type used for the response.
> 
> Fixes: 2f90b8657ec9 ("ixgbe: this patch adds support for DCB to the kernel and ixgbe driver")
> Signed-off-by: Petr Machata <me@pmachata.org>

Applied, thanks!
