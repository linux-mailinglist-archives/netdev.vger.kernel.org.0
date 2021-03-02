Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865CF32A36F
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446361AbhCBI5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237977AbhCBIJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 03:09:18 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3ACC061756;
        Tue,  2 Mar 2021 00:08:35 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 33EC8C01B; Tue,  2 Mar 2021 09:08:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1614672514; bh=jo1ApVji+2tQwiUYRWmYN3Y+RBqiduiLhHfkJ1tbAVI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0cNN7pnls8BE7DnPzkHaXGu9tEd7hrNWUN75AnMdJUaMT8PBKw9A5YNP1gSwEDhIR
         54cJ4nh030YM7fLrUCymQGkKNu6aRtQryhME1O/sUHfJdkGtmXQM8HasmFjvsPbQ4o
         WiP8E8lFetzeLpp1AXF/WyLKo8vkl7Sfk/GIcx2fWrx7iunSrUIjOR//9zvQGBaT59
         frfOWbOTxTQUDjM81C+iM1/mDtnSPZkTuHQBeOxQ4uqXzEo6aL6K74pxUHfmXj5brP
         M/av2VPnLFEFKkTgO8KVSJskh8ZMlRGwFWtxfgEdQJ2mvB/91q5LRxvEYtIJrPunkY
         mgvpEYktQr5Bw==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 161F1C01B;
        Tue,  2 Mar 2021 09:08:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1614672513; bh=jo1ApVji+2tQwiUYRWmYN3Y+RBqiduiLhHfkJ1tbAVI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OpT+RaVXKbY5pxROi3uyhFf/WrZ1CFSp2mGEdK3FHtTsafFaLFy2HkJI9r36aDLCT
         Lj+tn4GZ/4CG9uFLG06ApZEuI4vv7dtKHXzZiZTv/jDnOk4vJjy0dgfND1PDWbzZEV
         WGaVPsYBZrN1u6C9RrBco3Ta+kt3I5xp4CUoVA2eF1rfHUKeMPxyCPZyWrl665TfBc
         x+Z3lTMBwcbUkUluwbdbmPQDbfIRHhjhmBADcqktEBG+1lIBs90BuUu1HpVp0yOOcK
         gl6yXLay7POrbiOxIDbPGnQXDWrR0FxXxo4087PmV+YZ/z8ZCashmSPIzax84UaXdo
         haWi3jPnkh1dQ==
Received: from odin (localhost [127.0.0.1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id af406e63;
        Tue, 2 Mar 2021 08:08:28 +0000 (UTC)
Date:   Tue, 2 Mar 2021 17:08:13 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: 9p: free what was emitted when read count is 0
Message-ID: <YD3ybcx1i8Rtbvkp@codewreck.org>
References: <20210301103336.2e29da13@xhacker.debian>
 <YDxWrB8AoxJOmScE@odin>
 <20210301110157.19d9ad4e@xhacker.debian>
 <YD3BMLuZXIcETtzp@codewreck.org>
 <20210302153940.64332d11@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210302153940.64332d11@xhacker.debian>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jisheng Zhang wrote on Tue, Mar 02, 2021 at 03:39:40PM +0800:
> > Rather than make an exception for 0, how about just removing the if as
> > follow ?
> 
> IMHO, we may need to keep the "if" in current logic. When count
> reaches zero, we need to break the "while(iov_iter_count(to))" loop, so removing
> the "if" modifying the logic.

We're not looking at the same loop, the break will happen properly
without the if because it's the return value of p9_client_read_once()
now.

In the old code I remember what you're saying and it makes sense, I
guess that was the reason for the special case.
It's not longer required, let's remove it.

-- 
Dominique
