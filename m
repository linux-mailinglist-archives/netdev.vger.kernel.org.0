Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC665E5472
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 22:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiIUUVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 16:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiIUUVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 16:21:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D59A4059
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663791695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YF/WX0Q0N3g8RclqtFHbK8d5momntCiYiVl+3XDp9cQ=;
        b=S1sXmimAfOZJ45WILLKY2wy7l62hhcI3A3C54FG71yj650Ui+dGw51MRlfVwtOhjZA+4ra
        Kp7s40t8SRiDSvf4eX2sJEraotzGABhatGLHfWBM8sGUN/TU1jjuxrykJMqteYqtVS9gmV
        vkwo39/Qhlr7ElzfggHLwu4xqXxIi5c=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-32-FvQcryYZPKavxj1DhVcaiw-1; Wed, 21 Sep 2022 16:21:33 -0400
X-MC-Unique: FvQcryYZPKavxj1DhVcaiw-1
Received: by mail-qt1-f199.google.com with SMTP id j25-20020ac84c99000000b0035bb13ed4ffso5026192qtv.23
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:21:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=YF/WX0Q0N3g8RclqtFHbK8d5momntCiYiVl+3XDp9cQ=;
        b=BGU2MvWY6EdS8Zy1W2sez5tgLRiyXznAaQIQ3ljU6b1jRaAZndOPk6x9krwng391VO
         KGN26Yv9iCnvMzrjku3cg7SG9Bb5f1Q+vBZ59PHapen8KuIxnCN1n/NkWG71qutDV5ow
         2cp+s9qXcx2SVG5pKzS0KDsQhTJRjW3smkJlV0+aZU2XPq2nOJdib2nK5tSJT8TbNxz/
         k/ySuF68qVb6bziESvwmNM76bFH+OZuVwEF0xaeI5Ibv8//7VP0q8akVzNbu5KXKMwYl
         GOrZXCU/3nJuKitA2hrbdSaTpg3QHfG2Ldo5EEeN58KQk63YD2PSuZLWi/eP2FSIRYEh
         0TYA==
X-Gm-Message-State: ACrzQf2r04DuNm7PygGcueyc+OnG42qYaG9IHiAyAv2Dia0HmH65Jc8r
        FCInDW7PjJi74MGodWE9q6i/spkEo1xDqNSsFJVDIwAfgrTG6UQ8glkeSO0xOOq3JF4YKEC0TN/
        YwVJ8asb51v37Dtby
X-Received: by 2002:ac8:5914:0:b0:35b:b041:3a09 with SMTP id 20-20020ac85914000000b0035bb0413a09mr102008qty.354.1663791693301;
        Wed, 21 Sep 2022 13:21:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4dwSgh++KD8esZtpxXCnhWLy+CXWPA7BQ11re2m2aTF/OdX0FENrHmEBEjNRjhTsqDZKxWSw==
X-Received: by 2002:ac8:5914:0:b0:35b:b041:3a09 with SMTP id 20-20020ac85914000000b0035bb0413a09mr101980qty.354.1663791692869;
        Wed, 21 Sep 2022 13:21:32 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-76.dyn.eolo.it. [146.241.104.76])
        by smtp.gmail.com with ESMTPSA id d21-20020ac84e35000000b00359961365f1sm2317185qtw.68.2022.09.21.13.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 13:21:32 -0700 (PDT)
Message-ID: <aaf8214cf5d73ac5564aec38e67973ef47c45b5e.camel@redhat.com>
Subject: Re: [PATCH net-next] net: skb: introduce and use a single page frag
 cache
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Wed, 21 Sep 2022 22:21:29 +0200
In-Reply-To: <cb3f22f20f3ecb8b049c3e590fd99c52006ef964.camel@redhat.com>
References: <59a54c9a654fe19cc9fb7da5b2377029d93a181e.1663778475.git.pabeni@redhat.com>
         <e2bf192391a86358f5c7502980268f17682bb328.camel@gmail.com>
         <cb3f22f20f3ecb8b049c3e590fd99c52006ef964.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-21 at 21:33 +0200, Paolo Abeni wrote:
> On Wed, 2022-09-21 at 11:11 -0700, Alexander H Duyck wrote:
[...]
> 
> > >  {
> > >  	struct napi_alloc_cache *nc;
> > >  	struct sk_buff *skb;
> > > +	bool pfmemalloc;
> > >  	void *data;
> > >  
> > >  	DEBUG_NET_WARN_ON_ONCE(!in_softirq());
> > >  	len += NET_SKB_PAD + NET_IP_ALIGN;
> > >  
> > > +	/* When the small frag allocator is available, prefer it over kmalloc
> > > +	 * for small fragments
> > > +	 */
> > > +	if (NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) {
> > > +		nc = this_cpu_ptr(&napi_alloc_cache);
> > > +
> > > +		if (sk_memalloc_socks())
> > > +			gfp_mask |= __GFP_MEMALLOC;
> > > +
> > > +		/* we are artificially inflating the allocation size, but
> > > +		 * that is not as bad as it may look like, as:
> > > +		 * - 'len' less then GRO_MAX_HEAD makes little sense
> > > +		 * - larger 'len' values lead to fragment size above 512 bytes
> > > +		 *   as per NAPI_HAS_SMALL_PAGE_FRAG definition
> > > +		 * - kmalloc would use the kmalloc-1k slab for such values
> > > +		 */
> > > +		len = SZ_1K;
> > > +
> > > +		data = page_frag_alloc_1k(&nc->page_small, gfp_mask);
> > > +		pfmemalloc = nc->page_small.pfmemalloc;
> > > +		goto check_data;
> > > +	}
> > > +
> > 
> > It might be better to place this code further down as a branch rather
> > than having to duplicate things up here such as the __GFP_MEMALLOC
> > setting.
> > 
> > You could essentially just put the lines getting the napi_alloc_cache
> > and adding the shared info after the sk_memalloc_socks() check. Then it
> > could just be an if/else block either calling page_frag_alloc or your
> > page_frag_alloc_1k.
> 
> I thought about that option, but I did not like it much because adds a
> conditional in the fast-path for small-size allocation, and the
> duplicate code is very little.
> 
> I can change the code that way, if you have strong opinion in that
> regards.

Thinking again about the above, I now belive that what you suggest is
the right thing to do: my patch ignores the requested 
__GFP_DIRECT_RECLAIM and GFP_DMA flags for small allocation - we always
need to fallback to kmalloc() when the caller ask for them.

TL;DR: I'll move the page_frag_alloc_1k() call below in v2.

Thanks!

Paolo

