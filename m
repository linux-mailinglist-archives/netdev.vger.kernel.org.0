Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC9A198296
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgC3Rn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:43:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40132 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727779AbgC3Rn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:43:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB79D15C26ADF;
        Mon, 30 Mar 2020 10:43:25 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:43:24 -0700 (PDT)
Message-Id: <20200330.104324.1433166586415849555.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com,
        xmu@redhat.com, lucien.xin@gmail.com
Subject: Re: [PATCH net 1/1] net: fix fraglist segmentation reference count
 leak
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330165129.5200-1-fw@strlen.de>
References: <20200330165129.5200-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:43:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Mon, 30 Mar 2020 18:51:29 +0200

> Xin Long says:
>  On udp rx path udp_rcv_segment() may do segment where the frag skbs
>  will get the header copied from the head skb in skb_segment_list()
>  by calling __copy_skb_header(), which could overwrite the frag skbs'
>  extensions by __skb_ext_copy() and cause a leak.
> 
>  This issue was found after loading esp_offload where a sec path ext
>  is set in the skb.
> 
> Fix this by discarding head state of the fraglist skb before replacing
> its contents.
> 
> Fixes: 3a1296a38d0cf62 ("net: Support GRO/GSO fraglist chaining.")
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Tested-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied and queued up for v5.6 -stable, thanks.
