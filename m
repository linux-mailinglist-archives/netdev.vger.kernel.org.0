Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98532B822C
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgKRQrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgKRQrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:47:24 -0500
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD658C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:47:23 -0800 (PST)
Received: by mail-qv1-xf43.google.com with SMTP id r12so1299088qvq.13
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SMsAI3U5uNrh/wvCsMdYdfdwWRudjwCCaun4Diu/bWE=;
        b=R2HEzQJACHhUyYxxLOBy3SFAsSiWblO3fm0FLoVIef28IGvghso/ZaR+3xczRm2T40
         TscV/C26wWQ48qNWfMcLvrBKTQ0efcuiPI+t5pECZjj77skhUnDhpSEAOvqePd98YEJK
         y7V/TMWpv4XTU6zGrerCEmxzuexJuIUwHCm0wZjGCNSd9UgOCKzSeceeuAuJazFAF8s5
         w4FulhVwTADQlvUuJaKzLCc0fZajR+h/th9dqdf+8QdXxDFyMOJpLwB9qaA4MNgpoiMJ
         VXTPHe/MwWciKuRXKcI7nhfipMGtzel/rn+ge36NTigRh7Se1tohKryxbLFtnwwkdV/n
         MJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SMsAI3U5uNrh/wvCsMdYdfdwWRudjwCCaun4Diu/bWE=;
        b=pRLeka2or9wyXaOpUFPKxbReaE4kjWAyJIDOVvFYn9DWOrv5+wlxHtHhQMPlQ8pbJa
         FWQY0cbAPpKb16C3RfKHsv6hTKlN5yTK1bf141bVdAGG6Ri1eus0ld4i/W/V1noJkLNe
         1nbFOP/r/vEMd8J+RTiM3oGPkRCYIMoik3992UOr+gCp+p7qhLsXU7QVq9bYd0yQ1jo9
         nZu/pdAKNGFTorLdl/TcFPO9c1wZ23/Ey4WaUQLYlyBGpbAlA4MsMY1nceIzEFAYsnUM
         aeUXMl+/EUJVWJ8MNENW4NnGz8ddi5IIelFsdPpeFcR/4RkqVVfFgUhMlDNhWQqT9zIb
         +AgA==
X-Gm-Message-State: AOAM532rjgAqUHy6HFcFKnspIIl2d3CfoocrP/cKOQG4BkVXlhUxd8ph
        RGpIbffFYGumKRpyo5OVzog=
X-Google-Smtp-Source: ABdhPJxSJUGxGoEM8kyKQ39WCRovuxbOR+TkUG3+SqhckWsXtUge9TSm8CWkzUj7rWzEsiqisBbx7w==
X-Received: by 2002:a05:6214:612:: with SMTP id z18mr5661869qvw.41.1605718042950;
        Wed, 18 Nov 2020 08:47:22 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f016:5d3f:367b:7d2c:63ea:dcc3])
        by smtp.gmail.com with ESMTPSA id o63sm16413093qkd.96.2020.11.18.08.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 08:47:21 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 94AF7C2B35; Wed, 18 Nov 2020 13:47:19 -0300 (-03)
Date:   Wed, 18 Nov 2020 13:47:19 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com
Subject: Re: [PATCH net] net/sched: act_mpls: ensure LSE is pullable before
 reading it
Message-ID: <20201118164719.GL3913@localhost.localdomain>
References: <e14a44135817430fc69b3c624895f8584a560975.1605716949.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e14a44135817430fc69b3c624895f8584a560975.1605716949.git.dcaratti@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 05:36:52PM +0100, Davide Caratti wrote:

Hi,

>  	case TCA_MPLS_ACT_MODIFY:
> +		if (!pskb_may_pull(skb,
> +				   skb_network_offset(skb) + sizeof(new_lse)))
> +			goto drop;
>  		new_lse = tcf_mpls_get_lse(mpls_hdr(skb), p, false);
>  		if (skb_mpls_update_lse(skb, new_lse))
>  			goto drop;

Seems TCA_MPLS_ACT_DEC_TTL is also affected. skb_mpls_dec_ttl() will
also call mpls_hdr(skb) without this check.

  Marcelo
