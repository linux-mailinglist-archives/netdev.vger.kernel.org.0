Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE591A01C2
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 01:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgDFXkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 19:40:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51230 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726352AbgDFXkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 19:40:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586216406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WM8xDoDQ9iS/jeeUYD4yS2C0/dqqITfA49gu7xf3zpk=;
        b=SJ5T0XLrqjMl2Z+5ei5VjX+bEy3fSodHailFdQinPkB32dSjRB/Xpi+u1bZUMXuxe1Sd1P
        AkntBDqvxJgIG8XbUubfYR1eLTZCDwx043nH2sIFa+xywB4AC8weaiwtITdlfEambN3LL5
        e3iznquVgrYhMx2MrQ68wlt7k0+NnOs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-IKF6aZ_eNCy6plDcCa3dfQ-1; Mon, 06 Apr 2020 19:40:02 -0400
X-MC-Unique: IKF6aZ_eNCy6plDcCa3dfQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40E43800D5C;
        Mon,  6 Apr 2020 23:40:00 +0000 (UTC)
Received: from localhost (unknown [10.36.110.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CEC265D9C5;
        Mon,  6 Apr 2020 23:39:56 +0000 (UTC)
Date:   Tue, 7 Apr 2020 01:39:51 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nft_set_pipapo: remove unused pointer lt
Message-ID: <20200407013951.77a6409f@redhat.com>
In-Reply-To: <20200406232031.657615-1-colin.king@canonical.com>
References: <20200406232031.657615-1-colin.king@canonical.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Tue,  7 Apr 2020 00:20:31 +0100
Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer lt being assigned with a value that is never read and
> the pointer is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/netfilter/nft_set_pipapo_avx2.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> index d65ae0e23028..9458c6b6ea04 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -1049,11 +1049,9 @@ static int nft_pipapo_avx2_lookup_slow(unsigned long *map, unsigned long *fill,
>  					struct nft_pipapo_field *f, int offset,
>  					const u8 *pkt, bool first, bool last)
>  {
> -	unsigned long *lt = f->lt, bsize = f->bsize;
> +	unsigned long bsize = f->bsize;
>  	int i, ret = -1, b;
>  
> -	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
> -
>  	if (first)
>  		memset(map, 0xff, bsize * sizeof(*map));
>  
        for (i = offset; i < bsize; i++) {
                if (f->bb == 8)
                        pipapo_and_field_buckets_8bit(f, map, pkt);
                else
                        pipapo_and_field_buckets_4bit(f, map, pkt);

Now, this function should never be called, it's provided as a safety net
in case this algorithm is ever run with some strange packet field size,
still, your clean-up shows another "issue" here: as
pipapo_and_field_buckets_*() functions use the full buckets in lookup
tables, not just starting from an offset, there's no need to repeat
those operations starting from offset up to bsize.

It's fine to ignore the offset (which is just a "hint" here for faster
lookups) -- this function isn't supposed to be optimised in any way.

That is, this for loop should go away altogether, and the 'offset'
argument should be dropped as well. Let me know if you're comfortable
taking care of that as well, or if you prefer that I send a patch.

-- 
Stefano

