Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A1F4620B3
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbhK2ToS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347630AbhK2TmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:42:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219A3C09B330;
        Mon, 29 Nov 2021 07:57:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B142D612E3;
        Mon, 29 Nov 2021 15:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C111AC53FAD;
        Mon, 29 Nov 2021 15:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638201429;
        bh=6PNUU+CgX9nNJylhSu1AL6pQJAc/RwS4ITMRm+DCXgs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=trEwIKTsmiy8bxX4JpHtVjW9TEezXNV7ldZWN5zMFuD9omjDj2uBkqhJoCKUSg2Vd
         NyOujHkioCtpqV0Xd5tI1Al8ro9oUeuVaQiuirOEcEm9Bk+1P42/Qghm4EC79W9TA7
         YPbAkjwcoYhXcO7de5NtM+kL3hnLy/XCD3ZyUvKEkk+29AKH/FabzoUJaemhPf8+Wv
         wLStAD5XOZKbcTkVDkKrfr4YRo7Xcx2qHsa+ZT/vj8aQyo4XqfgMDDOXl752KlJMA+
         q76ccytzhl1wD+J10/PBdJGmqCkvxMo1BoJodvypsua0G9RYn5QX2GnYVN+6JRRTx1
         GnUCE9U0x+yYg==
Date:   Mon, 29 Nov 2021 07:57:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, imagedong@tencent.com, ycheng@google.com,
        kuniyu@amazon.co.jp, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: snmp: add statistics for tcp small
 queue check
Message-ID: <20211129075707.47ab0ffe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211128060102.6504-1-imagedong@tencent.com>
References: <20211128060102.6504-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Nov 2021 14:01:02 +0800 menglong8.dong@gmail.com wrote:
> Once tcp small queue check failed in tcp_small_queue_check(), the
> throughput of tcp will be limited, and it's hard to distinguish
> whether it is out of tcp congestion control.
> 
> Add statistics of LINUX_MIB_TCPSMALLQUEUEFAILURE for this scene.

Isn't this going to trigger all the time and alarm users because of the
"Failure" in the TCPSmallQueueFailure name?  Isn't it perfectly fine
for TCP to bake full TSQ amount of data and have it paced out onto the
wire? What's your link speed?
