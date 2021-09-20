Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862844111B6
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236203AbhITJN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:13:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236641AbhITJLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:11:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632128937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3bwpyCkW6qg7kgZ8CqmlgUOkstGYMd23C6q6E4d3w8c=;
        b=MyM81hMQUISpPi/Fx2tZnFEtp1xWa032UzRWOd0izCfpyvkV11i+RUMUv9HLimNkir8MBd
        dnb1lUtKYmibSytOJnD+jRUiSqvsiyYiOJau/tQlxaHADkiznQfAHN87a4cXTdW+77YMjU
        9V3jMqyUQ8OkjCK3aNppnEF6vRZSb1Q=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-iQ9AmB0OMNiIoLFv5ohWIg-1; Mon, 20 Sep 2021 05:08:56 -0400
X-MC-Unique: iQ9AmB0OMNiIoLFv5ohWIg-1
Received: by mail-ed1-f71.google.com with SMTP id m20-20020aa7c2d4000000b003d1add00b8aso15021090edp.0
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 02:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3bwpyCkW6qg7kgZ8CqmlgUOkstGYMd23C6q6E4d3w8c=;
        b=ly/ScWsqCaD3fqFugFnDWrs/7qSFmNVEde3uI2TbC+18F80LVBtwyp+ICxKTpo9qgI
         W16yWQmmXnl28pfmKGTkyJ4+JKV+o/eOi86gKATWcmAxZij/NzA6sn2R5y4vWmuO60IL
         wGY19+c02Ab9eX7q8CAFBQMiTfBCeI0qBrVU93jkU6yF7K97Rlhl2div6jud+IOFM2y3
         dZYVEa5g5yLXki3YreHdHERgzyuQ29afjHD/onqm4731G0fH5j0Rh2izp5lli51x75zd
         Qr8ttOZbzTaWXq3tOMn/ywDTFkOtBIARaTy1EkDMn6IIP48G3G64oLeZADkvKaGmIz/4
         TdTg==
X-Gm-Message-State: AOAM530jopkp/mCiBUOf/IAE7+rAIU3ApAPRO3DIJx7rJ7TiW/ApOkEV
        4YweEj4i2+1BDWFAJbwC7aFAjclISZc8aR6lXGaiu88a+jmVN+ua9ygNzDl+rUV9gml/oDrBgDy
        H68z+a90FUq+uYGRG
X-Received: by 2002:a17:906:584:: with SMTP id 4mr27142175ejn.56.1632128935030;
        Mon, 20 Sep 2021 02:08:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgMdl12Eww6sRiAL1BPDILRwJBD7OomGR1K4WwvlsWiNZ2UY+Vy9zRfl26a0Gii41SgThZdg==
X-Received: by 2002:a17:906:584:: with SMTP id 4mr27142154ejn.56.1632128934850;
        Mon, 20 Sep 2021 02:08:54 -0700 (PDT)
Received: from localhost (net-188-218-7-234.cust.vodafonedsl.it. [188.218.7.234])
        by smtp.gmail.com with ESMTPSA id q19sm6802963edc.74.2021.09.20.02.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 02:08:54 -0700 (PDT)
Date:   Mon, 20 Sep 2021 11:08:53 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: sched: fix initialiser warning in sch_frag.c
Message-ID: <YUhPpaas69u4vZdp@dcaratti.users.ipa.redhat.com>
References: <E1mS5U9-002wsa-TC@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mS5U9-002wsa-TC@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 19, 2021 at 11:40:33PM +0100, Russell King (Oracle) wrote:
> Debian gcc 10.2.1 complains thusly:
> 
> net/sched/sch_frag.c:93:10: warning: missing braces around initializer [-Wmissing-braces]
>    struct rtable sch_frag_rt = { 0 };
>           ^
> net/sched/sch_frag.c:93:10: warning: (near initialization for 'sch_frag_rt.dst') [-Wmissing-braces]
> 
> Fix it by removing the unnecessary '0' initialiser, leaving the
> braces.

hello Russell, thanks a lot for reporting!
 
> diff --git a/net/sched/sch_frag.c b/net/sched/sch_frag.c
> index 8c06381391d6..ab359d63287c 100644
> --- a/net/sched/sch_frag.c
> +++ b/net/sched/sch_frag.c
> @@ -90,7 +90,7 @@ static int sch_fragment(struct net *net, struct sk_buff *skb,
>  	}
>  
>  	if (skb_protocol(skb, true) == htons(ETH_P_IP)) {
> -		struct rtable sch_frag_rt = { 0 };
> +		struct rtable sch_frag_rt = { };

this surely fixes the -Wmissing-braces, but then -Wpedantic
would complain about usage of GNU extension (I just tried on godbolt
with x86_64 gcc 11.2):

warning: ISO C forbids empty initializer braces [-Wpedantic]

While we are fixing this, probably the best thing is to initialize the
'dst' struct member  to 0: in my understanding this should be sufficient
to let the compiler fill all the struct members with 0.

Oh, and I might have inserted a similar thing in openvswitch kernel
module (see [1]), if you agree I will send a patch that fixes this as
well. WDYT?

-- 
davide

[1] https://lore.kernel.org/netdev/80dbe764b5ae660bba3cf6edcb045a74b0f85853.1618844973.git.dcaratti@redhat.com/

