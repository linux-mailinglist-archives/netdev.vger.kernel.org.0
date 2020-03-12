Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7B01828CB
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387889AbgCLGN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:13:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56080 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387767AbgCLGN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:13:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D5DFE14CF8273;
        Wed, 11 Mar 2020 23:13:27 -0700 (PDT)
Date:   Wed, 11 Mar 2020 23:13:27 -0700 (PDT)
Message-Id: <20200311.231327.132987828940639157.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, mst@redhat.com, willemb@google.com
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring
 index on drop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 23:13:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon,  9 Mar 2020 11:34:35 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> In one error case, tpacket_rcv drops packets after incrementing the
> ring producer index.
> 
> If this happens, it does not update tp_status to TP_STATUS_USER and
> thus the reader is stalled for an iteration of the ring, causing out
> of order arrival.
> 
> The only such error path is when virtio_net_hdr_from_skb fails due
> to encountering an unknown GSO type.
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>

I'm applying this, as it fixes the ring state management in this case.

The question of what we should actually be doing for unknown GSO types
is a separate discussion.

Thanks Willem.
