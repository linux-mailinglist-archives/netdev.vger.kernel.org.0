Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC5A4A2B35
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfH2XyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:54:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55460 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfH2XyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:54:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86999153C23DD;
        Thu, 29 Aug 2019 16:54:15 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:54:15 -0700 (PDT)
Message-Id: <20190829.165415.1821954803967440924.davem@davemloft.net>
To:     ruxandra.radulescu@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next v3 3/3] dpaa2-eth: Add pause frame support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567001295-31801-3-git-send-email-ruxandra.radulescu@nxp.com>
References: <1567001295-31801-1-git-send-email-ruxandra.radulescu@nxp.com>
        <1567001295-31801-3-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 16:54:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Date: Wed, 28 Aug 2019 17:08:15 +0300

> Starting with firmware version MC10.18.0, we have support for
> L2 flow control. Asymmetrical configuration (Rx or Tx only) is
> supported, but not pause frame autonegotioation.
> 
> Pause frame configuration is done via ethtool. By default, we start
> with flow control enabled on both Rx and Tx. Changes are propagated
> to hardware through firmware commands, using two flags (PAUSE,
> ASYM_PAUSE) to specify Rx and Tx pause configuration, as follows:
> 
> PAUSE | ASYM_PAUSE | Rx pause | Tx pause
> ----------------------------------------
>   0   |     0      | disabled | disabled
>   0   |     1      | disabled | enabled
>   1   |     0      | enabled  | enabled
>   1   |     1      | enabled  | disabled
> 
> The hardware can automatically send pause frames when the number
> of buffers in the pool goes below a predefined threshold. Due to
> this, flow control is incompatible with Rx frame queue taildrop
> (both mechanisms target the case when processing of ingress
> frames can't keep up with the Rx rate; for large frames, the number
> of buffers in the pool may never get low enough to trigger pause
> frames as long as taildrop is enabled). So we set pause frame
> generation and Rx FQ taildrop as mutually exclusive.
> 
> Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied.
