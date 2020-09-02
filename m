Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8407A25B726
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 01:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgIBXLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 19:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBXLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 19:11:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDACC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 16:11:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6252415746475;
        Wed,  2 Sep 2020 15:54:46 -0700 (PDT)
Date:   Wed, 02 Sep 2020 16:11:32 -0700 (PDT)
Message-Id: <20200902.161132.628904266817281846.davem@davemloft.net>
To:     mmilev_ml@icloud.com
Cc:     kuba@kernel.org, edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] Sysctl parameter to disable TCP RST packet to
 unknown socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200902195656.7538-1-mmilev_ml@icloud.com>
References: <20200902195656.7538-1-mmilev_ml@icloud.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 15:54:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mihail Milev <mmilev_ml@icloud.com>
Date: Wed,  2 Sep 2020 21:56:56 +0200

> What?
> 
> Create a new sysctl parameter called tcp_disable_rst_unkn_socket,
> which by default is set to 0 - "disabled". When this parameter is
> set to 1 - "enabled", it suppresses sending a TCP RST packet as a
> response to received TCP packets destined for a socket, which is
> unknown to the kernel.
> 
> Important!
> 
> By enabling this sysctl parameter, the TCP stack becomes non-
> conformal to RFC 793, which clearly states (as of revision
> September 1981) in the listing on page 36, point 1:
> "1. If the connection does not exist (CLOSED) then a reset is sent
> in response to any incoming segment except another reset. ..."

This is a non-starter sorry.

One can set up suitable netfilter rules, or an XDP program, to satisfy
this need.

Our TCP stack already has too many knobs.
