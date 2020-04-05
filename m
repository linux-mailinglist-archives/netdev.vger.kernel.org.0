Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0B6D19EA6A
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 12:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDEKgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 06:36:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49386 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgDEKgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 06:36:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/yYzyLnkt5o4Y6sZshOUF7fL7wkCcwbfoUoIru+drL8=; b=j5X9/Ru3dETwVmESQJCHU9yF9s
        On7QaK9lK3CMZ7kXWhnwVrN00KeNKZyK93dEX+TfcpnmgdoyAvD1FIUpxrA0AtPypRpPml23hJCfy
        KhRuDRSX396CyPjihpasA9adwWaq0CKaHfLy+4rbiWPgalNw2IJ8wCok/x6HFd5hhu4W9RTmUEzmb
        GXvYWCI9A/p3s5gxkNEiD7cRzDWz+pYUE0TMFZoki91O9P1uhFIS0Kn8MJO0wDuGphZksUbX4+V3j
        0DEI9ks+BWAqV+fB0QhxYlawQkcNHu278of7/FmzeAjJNLBaQGYAtfB+JM8PMys1oirQUeXrhmxbU
        g3IkxjmA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jL2dW-0007eO-Vw; Sun, 05 Apr 2020 10:36:18 +0000
Date:   Sun, 5 Apr 2020 03:36:18 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, willemb@google.com,
        kuba@kernel.org, simon.horman@netronome.com, sdf@google.com,
        john.hurley@netronome.com, edumazet@google.com, fw@strlen.de,
        jonathan.lemon@gmail.com, pablo@netfilter.org,
        rdunlap@infradead.org, jeremy@azazel.net, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] skbuff.h: Improve the checksum related comments
Message-ID: <20200405103618.GV21484@bombadil.infradead.org>
References: <1586071063-51656-1-git-send-email-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586071063-51656-1-git-send-email-decui@microsoft.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 05, 2020 at 12:17:43AM -0700, Dexuan Cui wrote:
>   * CHECKSUM_COMPLETE:
>   *
> - *   This is the most generic way. The device supplied checksum of the _whole_
> - *   packet as seen by netif_rx() and fills out in skb->csum. Meaning, the
> + *   This is the most generic way. The device supplies checksum of the _whole_
> + *   packet as seen by netif_rx() and fills out in skb->csum. This means the

I think both 'supplies' and 'supplied' are correct in this sentence.  The
nuances are slightly different, but the meaning is the same in this instance.

You missed a mistake in the second line though, it should be either 'fills
out' or 'fills in'.  I think we tend to prefer 'fills in'.

>   * CHECKSUM_COMPLETE:
>   *   Not used in checksum output. If a driver observes a packet with this value
> - *   set in skbuff, if should treat as CHECKSUM_NONE being set.
> + *   set in skbuff, the driver should treat it as CHECKSUM_NONE being set.

I would go with "it should treat the packet as if CHECKSUM_NONE were set."

> @@ -211,7 +211,7 @@
>   * is implied by the SKB_GSO_* flags in gso_type. Most obviously, if the
>   * gso_type is SKB_GSO_TCPV4 or SKB_GSO_TCPV6, TCP checksum offload as
>   * part of the GSO operation is implied. If a checksum is being offloaded
> - * with GSO then ip_summed is CHECKSUM_PARTIAL, csum_start and csum_offset
> + * with GSO then ip_summed is CHECKSUM_PARTIAL AND csum_start and csum_offset
>   * are set to refer to the outermost checksum being offload (two offloaded
>   * checksums are possible with UDP encapsulation).

Why the capitalisation of 'AND'?

Thanks for the improvements,

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
