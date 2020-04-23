Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AEC1B52F0
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgDWDLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWDLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 23:11:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6C8C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:11:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6CC7A127BE373;
        Wed, 22 Apr 2020 20:11:50 -0700 (PDT)
Date:   Wed, 22 Apr 2020 20:11:49 -0700 (PDT)
Message-Id: <20200422.201149.711841705818992491.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH v2 net-next 0/5] dpaa2-eth: add support for xdp bulk
 enqueue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422120513.6583-1-ioana.ciornei@nxp.com>
References: <20200422120513.6583-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 20:11:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Wed, 22 Apr 2020 15:05:08 +0300

> The first patch moves the DEV_MAP_BULK_SIZE macro into the xdp.h header
> file so that drivers can take advantage of it and use it.
> 
> The following 3 patches are there to setup the scene for using the bulk
> enqueue feature.  First of all, the prototype of the enqueue function is
> changed so that it returns the number of enqueued frames. Second, the
> bulk enqueue interface is used but without any functional changes, still
> one frame at a time is enqueued.  Third, the .ndo_xdp_xmit callback is
> split into two stages, create all FDs for the xdp_frames received and
> then enqueue them.
> 
> The last patch of the series builds on top of the others and instead of
> issuing an enqueue operation for each FD it issues a bulk enqueue call
> for as many frames as possible. This is repeated until all frames are
> enqueued or the maximum number of retries is hit. We do not use the
> XDP_XMIT_FLUSH flag since the architecture is not capable to store all
> frames dequeued in a NAPI cycle, instead we send out right away all
> frames received in a .ndo_xdp_xmit call.
> 
> Changes in v2:
>  - statically allocate an array of dpaa2_fd by frame queue
>  - use the DEV_MAP_BULK_SIZE as the maximum number of xdp_frames
>    received in .ndo_xdp_xmit()

Series applied, thanks.
