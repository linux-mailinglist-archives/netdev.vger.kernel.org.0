Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEAD46A8CA
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 21:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349830AbhLFUxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238973AbhLFUxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:53:07 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243E2C061746;
        Mon,  6 Dec 2021 12:49:38 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id r2so11550276ilb.10;
        Mon, 06 Dec 2021 12:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=fr+myOspVKNuyatnaGOZFIgpe0q3Dw7jH0sivNq1jwY=;
        b=O8X1P2Sk7R1pFlni8KOPK7OBbO091pL5AlntXhvY3RHmT1fhJM+mP6z18T4mULQZRM
         i9qk3u42Hdbu+8WsN0VHrwIhcfb1bjXxVj4wF7yLtNhBBDYJVWHSiY5y3v6JBUoly08C
         rLDYRd2kRsBaXDE4rCs2TpFM9dkLTQuMbvxauLGreobmGI4Nl9ePTKMYNHNwv+im76xi
         cEsGyHxdX2gU94zHs9CGcTwOjaHow6tqAy+7Jj5cCu9s48hkocsP0CNR2hX8FVjZz38F
         gz80/8bT5S7kh6L1NkUmTBfbVuaw7aA5mQ1UTD5j6BHlhqsW6gDVB2zCnxCwbOy23spc
         rzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=fr+myOspVKNuyatnaGOZFIgpe0q3Dw7jH0sivNq1jwY=;
        b=XJtOar0GVq+njdOhhWeHhfZBXebj77xXmYLJpPG3VhfL7pn/ifydGjEGrQLnn25GFr
         0ib4dsJ36gAZSplksbpa/aLF//MlbI71WOK3unhHQU8pEsPliovaobslWvDTIw68pzzD
         /VGTHctQDpsmxgZEltMXKEKivsPSspj/yVZBC6LeuSpNmqq+32VV6TyqFXZJpok1PhIE
         WD2ozbKbuaUtwZQo8121+cSXQkq3qaEk5Cclu8V5S4hNfWXqAWowFIndlXTGkHt6UUyf
         uPVUgcK7nWf3KyNUrHq2UWl6M0yUvufwzI6+l/AN4XOQA8n+YW68GNTMQAVfkxRm/rWu
         H1ZA==
X-Gm-Message-State: AOAM531G2a9yx4mz3w56ZYDD+vsNnjxj0CMKiXHsM6O8vhcGaoQmMBIK
        GNDAg52Pzzn+1d5RizmPaPA=
X-Google-Smtp-Source: ABdhPJw1iFKdcZsW8f7cycMzONzU6yxUgEuZazhdPogGYK+F3RTgppqoM9HbNbtTNedEZ9JFoWPJHQ==
X-Received: by 2002:a92:4a0a:: with SMTP id m10mr33586996ilf.160.1638823777601;
        Mon, 06 Dec 2021 12:49:37 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id x7sm7090403ilq.86.2021.12.06.12.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 12:49:37 -0800 (PST)
Date:   Mon, 06 Dec 2021 12:49:28 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <61ae775880778_106e0208ef@john.notmuch>
In-Reply-To: <Ya5j9mtNyuyNf/MF@lore-desk>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <95151f4b8a25ce38243e82f0a82104d0f46fb33a.1638272238.git.lorenzo@kernel.org>
 <61ad7e4cbc69d_444e20888@john.notmuch>
 <Ya4oCkbOjBHFOHyS@lore-desk>
 <61ae427999a20_881820893@john.notmuch>
 <Ya5j9mtNyuyNf/MF@lore-desk>
Subject: Re: [PATCH v19 bpf-next 03/23] net: mvneta: update mb bit before
 passing the xdp buffer to eBPF layer
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> > Lorenzo Bianconi wrote:
> > > > Lorenzo Bianconi wrote:
> > > > > Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
> > > > > XDP remote drivers if this is a "non-linear" XDP buffer. Access
> > > > > skb_shared_info only if xdp_buff mb is set in order to avoid possible
> > > > > cache-misses.
> > > > > 
> > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > 
> > > > [...]
> > > > 
> > > > > @@ -2320,8 +2325,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
> > > > >  		      struct xdp_buff *xdp, u32 desc_status)
> > > > >  {
> > > > >  	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> > > > > -	int i, num_frags = sinfo->nr_frags;
> > > > >  	struct sk_buff *skb;
> > > > > +	u8 num_frags;
> > > > > +	int i;
> > > > > +
> > > > > +	if (unlikely(xdp_buff_is_mb(xdp)))
> > > > > +		num_frags = sinfo->nr_frags;
> > > > 
> > > > Doesn't really need a respin IMO, but rather an observation. Its not
> > > > obvious to me the unlikely/likely pair here is wanted. Seems it could
> > > > be relatively common for some applications sending jumbo frames.
> > > > 
> > > > Maybe worth some experimenting in the future.
> > > 
> > > Probably for mvneta it will not make any difference but in general I tried to
> > > avoid possible cache-misses here (accessing sinfo pointers). I will carry out
> > > some comparison to see if I can simplify the code.
> > 
> > Agree, I'll predict for mvneta it doesn't make a difference either way and
> > perhaps if you want to optimize small pkt benchmarks on a 100Gbps nic it would
> > show a win.
> > 
> 
> actually it makes a slightly difference on mvneta as well (~45-50Kpps).
> I will keep the code as it is for the moment.

OK works for me thanks for checking.

> 
> Regards,
> Lorenzo
