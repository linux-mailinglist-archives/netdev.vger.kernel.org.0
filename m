Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D6E66730D
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 14:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbjALNTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 08:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbjALNS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 08:18:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EFE32240
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673529494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FczANLzjWLC+T8ElqheikTdKGOmFGdHTPNpppfFzGN8=;
        b=DdUbo8gfY2cuJNk2kTeWr1H1IOGSYwsOKefpcGbqxA22I1bmBfpqu7k3EuBMh1b4L66fd8
        jDDXTX4xqDanlazu8VmvzrRcOVv3UEE0n8/REJ36RjZsAatLJavrM/rVTwxmMef8N2gmkH
        tDfMVbNH4mjUTZncc8vstldgsx2impo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-340-VN0YoBbcN6W32lvTQLQxZw-1; Thu, 12 Jan 2023 08:18:12 -0500
X-MC-Unique: VN0YoBbcN6W32lvTQLQxZw-1
Received: by mail-qk1-f198.google.com with SMTP id i4-20020a05620a248400b006febc1651bbso12952389qkn.4
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:18:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FczANLzjWLC+T8ElqheikTdKGOmFGdHTPNpppfFzGN8=;
        b=eoitHIiLmtiHR1FzxVg/BdQ81Ii8uWIGy8K2LfPf2MzEw2XyL2oNiRQxIfw9rx2Xbx
         LcihR9y/75Ip1OWQ+2P1CwqyqkAQV9adlhdB0Abj8eIRrDhRq1y8r40RQ1fdIF4GYqPL
         +TIGnqS33yWVbjJm4Ldw684cYb0qFCHBUa+RyCXlaKlRox5HazGz3X6nQidtxAzyNY8c
         aoRSVEJNCxfdYerMt9cSfbtyZUHi2HwPCnajks7ufeNP6kbccVixLdaKvIQ9aPytwsJv
         9VSUJYaYNZun8/l0/XWFkwoyOLwAElPGqiK0U+GPWUln8V6OoZcmMeXLXzwrDnI4CmgK
         LsDg==
X-Gm-Message-State: AFqh2kpDQM63TBtAWC5bwvmeKKtu418pos/O5a5hlYTlTjKMFnJu/LWz
        vKpOOcgepG5vaMlN+mBIUTtcExn0wMFApW4mJaWHayyvey0H0Qfm1/skP6fL3ZvxLTdgR2amG00
        AI+ia2RS9Tgk4MjZb
X-Received: by 2002:ac8:7518:0:b0:3b1:e5f9:18ff with SMTP id u24-20020ac87518000000b003b1e5f918ffmr1804469qtq.20.1673529492485;
        Thu, 12 Jan 2023 05:18:12 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsfPFfGQIjYijbYxLudiBr+DXnAeK2jzCSeesQ6/OqmioqEwm4dgYxW86tbRldRc2d8JmNtzA==
X-Received: by 2002:ac8:7518:0:b0:3b1:e5f9:18ff with SMTP id u24-20020ac87518000000b003b1e5f918ffmr1804457qtq.20.1673529492270;
        Thu, 12 Jan 2023 05:18:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-183.dyn.eolo.it. [146.241.113.183])
        by smtp.gmail.com with ESMTPSA id d8-20020ac84e28000000b0039c7b9522ecsm9050129qtw.35.2023.01.12.05.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 05:18:11 -0800 (PST)
Message-ID: <989d0a69c3f6c571e6bfc234a744d0183c4a269a.camel@redhat.com>
Subject: Re: [Patch net v2 1/2] l2tp: convert l2tp_tunnel_list to idr
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, saeed@kernel.org, gnault@redhat.com,
        Cong Wang <cong.wang@bytedance.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Date:   Thu, 12 Jan 2023 14:18:08 +0100
In-Reply-To: <20230111112910.GA4173@katalix.com>
References: <20230110210030.593083-1-xiyou.wangcong@gmail.com>
         <20230110210030.593083-2-xiyou.wangcong@gmail.com>
         <20230111112910.GA4173@katalix.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-01-11 at 11:29 +0000, Tom Parkin wrote:
> On  Tue, Jan 10, 2023 at 13:00:29 -0800, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> > 
> > l2tp uses l2tp_tunnel_list to track all registered tunnels and
> > to allocate tunnel ID's. IDR can do the same job.
> > 
> > More importantly, with IDR we can hold the ID before a successful
> > registration so that we don't need to worry about late error
> > handling, it is not easy to rollback socket changes.
> > 
> > This is a preparation for the following fix.
> > 
> > Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Cc: Guillaume Nault <gnault@redhat.com>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/l2tp/l2tp_core.c | 85 ++++++++++++++++++++++----------------------
> >  1 file changed, 42 insertions(+), 43 deletions(-)
> > 
> > diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> > index 9a1415fe3fa7..894bc9ff0e71 100644
> > --- a/net/l2tp/l2tp_core.c
> > +++ b/net/l2tp/l2tp_core.c
> <snip>
> > @@ -1455,12 +1456,19 @@ static int l2tp_validate_socket(const struct sock *sk, const struct net *net,
> >  int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
> >  			 struct l2tp_tunnel_cfg *cfg)
> >  {
> > -	struct l2tp_tunnel *tunnel_walk;
> > -	struct l2tp_net *pn;
> > +	struct l2tp_net *pn = l2tp_pernet(net);
> > +	u32 tunnel_id = tunnel->tunnel_id;
> >  	struct socket *sock;
> >  	struct sock *sk;
> >  	int ret;
> >  
> > +	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
> > +	ret = idr_alloc_u32(&pn->l2tp_tunnel_idr, NULL, &tunnel_id, tunnel_id,
> > +			    GFP_ATOMIC);
> > +	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
> > +	if (ret)
> > +		return ret;
> > +
> 
> I believe idr_alloc_u32 will return one of ENOSPC or ENOMEM on
> failure, whereas previously this ID check explicitly returned EEXIST
> when there was an existing tunnel in the list with the specified ID.
> 
> The return code is directly reflected back to userspace in the
> pppol2tp case at least (via. the connect handler).
> 
> I don't know whether the failure return code could be considered part
> of the userspace API or not, but should we be trying to return the
> same error code for the "that ID is already in use" case?

I agree it would be better to preserve this specific error num. I fear
otherwise the patch could break existing applications (e.g. retrying
with a different id vs giving-up depending on the error number)

Thanks!

Paolo

