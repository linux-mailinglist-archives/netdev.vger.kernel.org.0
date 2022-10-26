Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478BA60E354
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbiJZOab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiJZOa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:30:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DD1422C8;
        Wed, 26 Oct 2022 07:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A0CCB82033;
        Wed, 26 Oct 2022 14:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFC1C433C1;
        Wed, 26 Oct 2022 14:30:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="signature verification failed" (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PLquYrQz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666794619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P6tG8AO+VnJ6tGDJZNZETw7TGH2GPbgVHdULos2RrT4=;
        b=PLquYrQzd8Dq5Xpi6TjfwLK5bB+2sSOz0v/BByfpdPGjMfbUgMJhXqmAM9y9AU2ACHIoar
        FeBoJ9q9KA+64KRL8LwyPRg5QXD1W+zY5CymoCEEQQDtl5rb2uq+qjj39Dd3qzJabVxr2k
        IC8VyBw9KtRvh8LEkBQdKVDlzag0rts=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1c5698b1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 26 Oct 2022 14:30:19 +0000 (UTC)
Date:   Wed, 26 Oct 2022 16:30:17 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Simon Horman <horms@verge.net.au>, stable@vger.kernel.org
Subject: Re: [PATCH] ipvs: use explicitly signed chars
Message-ID: <Y1lEebYfRwrtliDL@zx2c4.com>
References: <20221026123216.1575440-1-Jason@zx2c4.com>
 <4cc36ff5-46fd-c2b3-3292-d6369337fec1@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4cc36ff5-46fd-c2b3-3292-d6369337fec1@ssi.bg>
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 05:20:03PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Wed, 26 Oct 2022, Jason A. Donenfeld wrote:
> 
> > The `char` type with no explicit sign is sometimes signed and sometimes
> > unsigned. This code will break on platforms such as arm, where char is
> > unsigned. So mark it here as explicitly signed, so that the
> > todrop_counter decrement and subsequent comparison is correct.
> > 
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Cc: Julian Anastasov <ja@ssi.bg>
> > Cc: Simon Horman <horms@verge.net.au>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> 
> 	Looks good to me for -next, thanks!

This is actually net.git material, not net-next.git material,
considering it fixes a bug on arm and many other archs, and is marked
with a stable@ tag.

> 
> Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> > ---
> >  net/netfilter/ipvs/ip_vs_conn.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> > index 8c04bb57dd6f..7c4866c04343 100644
> > --- a/net/netfilter/ipvs/ip_vs_conn.c
> > +++ b/net/netfilter/ipvs/ip_vs_conn.c
> > @@ -1249,40 +1249,40 @@ static const struct seq_operations ip_vs_conn_sync_seq_ops = {
> >  	.next  = ip_vs_conn_seq_next,
> >  	.stop  = ip_vs_conn_seq_stop,
> >  	.show  = ip_vs_conn_sync_seq_show,
> >  };
> >  #endif
> >  
> >  
> >  /* Randomly drop connection entries before running out of memory
> >   * Can be used for DATA and CTL conns. For TPL conns there are exceptions:
> >   * - traffic for services in OPS mode increases ct->in_pkts, so it is supported
> >   * - traffic for services not in OPS mode does not increase ct->in_pkts in
> >   * all cases, so it is not supported
> >   */
> >  static inline int todrop_entry(struct ip_vs_conn *cp)
> >  {
> >  	/*
> >  	 * The drop rate array needs tuning for real environments.
> >  	 * Called from timer bh only => no locking
> >  	 */
> > -	static const char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
> > -	static char todrop_counter[9] = {0};
> > +	static const signed char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
> > +	static signed char todrop_counter[9] = {0};
> >  	int i;
> >  
> >  	/* if the conn entry hasn't lasted for 60 seconds, don't drop it.
> >  	   This will leave enough time for normal connection to get
> >  	   through. */
> >  	if (time_before(cp->timeout + jiffies, cp->timer.expires + 60*HZ))
> >  		return 0;
> >  
> >  	/* Don't drop the entry if its number of incoming packets is not
> >  	   located in [0, 8] */
> >  	i = atomic_read(&cp->in_pkts);
> >  	if (i > 8 || i < 0) return 0;
> >  
> >  	if (!todrop_rate[i]) return 0;
> >  	if (--todrop_counter[i] > 0) return 0;
> >  
> >  	todrop_counter[i] = todrop_rate[i];
> >  	return 1;
> >  }
> > -- 
> > 2.38.1
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 
