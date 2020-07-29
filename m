Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D86223232A
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 19:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgG2RKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 13:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgG2RKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 13:10:49 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BECC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 10:10:49 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b14so21219018qkn.4
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 10:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R0kGDty+NJqDGvP5Qr/g4cuwUxsVq+wvXFPu1wEls8g=;
        b=OxjPYHOlqA8VqR/w9cEzf9mKQrFGiJYd8WB4j5iuYJmiTTGumwM0Nzu6VRXHGtDjzZ
         aJlek1wVPmyoKVvP3yioeumHp9iKNRZ+DZ8nkXD7ZpV9y1v8sJX4Gj/2vJ7Gkg7wfTHc
         dHUpvgPc6qBI1mAGpVT4NSr3VfIR+GjjP/Chqf3CTaG3NJvju9f6pE//sDRKDZ+PhHVW
         qche9QiXE1YP7F8T5ZhMjpfzJdRLQGZAxuosRDC3oMZfHWXS36sd6/PNaY/HaOdw3rwD
         LRuYSKUcGH/FRABsygivuam2tw88nkIkdB+I/bVgs3gTkYkVqvTPxE0PMm1rqgagkTYn
         m2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R0kGDty+NJqDGvP5Qr/g4cuwUxsVq+wvXFPu1wEls8g=;
        b=AuAxUVf0G5SneFFXxw5G++kGSI8w/OUiBX7AoNKEio5vKjjHPGsKbGVxAHewhhuVTm
         sYEtFpVlhPYGGTcamGOdr1grzH1t/Q7FNxxQgNaMQW+rSDmnvwuaEo7IsL0zbPTQimBI
         slolxVxBkFrsqfnMiIQLFQzHeMFgRrFOp+NRA3f8lIT9WMNaMdOfWVfCGY/MyrOV5ZqW
         i3UgoxgZ5dr2Gv35nNPCfkSLeEucPMhQy33LTVcZ70tw1xE4R7t0Upyq1m7hcKE+pnrP
         d/vRRBK13A7m8a3pqKUcY7qWCMyLmTXX3S9ZR+RdMzbPCd0BOtIUxwSPq9SW+31kVNN9
         tRhg==
X-Gm-Message-State: AOAM533v1Pus0K62qtyOUCc5GLZ4fp4lD2ouIgaulDXKGEy/qNxy1/BO
        uL0Yi48/n1mm6PZkFWtOqtYTXHWu
X-Google-Smtp-Source: ABdhPJyJaiCh2gQh7DBUeMQfANCsrrM2jAIKhw42ERI+Jid/w/e8PT6G7A5/B3oN1HJC+YbTDF0XOw==
X-Received: by 2002:a37:9c08:: with SMTP id f8mr34847035qke.454.1596042648258;
        Wed, 29 Jul 2020 10:10:48 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:ebc:14c7:c937:6c2c:946f])
        by smtp.gmail.com with ESMTPSA id h13sm2094826qtu.7.2020.07.29.10.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 10:10:47 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id E563CC1B7E; Wed, 29 Jul 2020 14:10:44 -0300 (-03)
Date:   Wed, 29 Jul 2020 14:10:44 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org,
        Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net 2/2] net/sched: act_ct: Set offload timeout when
 setting the offload bit
Message-ID: <20200729171044.GI3307@localhost.localdomain>
References: <20200728115759.426667-1-roid@mellanox.com>
 <20200728115759.426667-3-roid@mellanox.com>
 <20200728144249.GC3398@localhost.localdomain>
 <c33a4437-8a7d-10fe-7020-94cec26d5aca@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c33a4437-8a7d-10fe-7020-94cec26d5aca@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 03:55:53PM +0300, Roi Dayan wrote:
> 
> 
> On 2020-07-28 5:42 PM, Marcelo Ricardo Leitner wrote:
> > On Tue, Jul 28, 2020 at 02:57:59PM +0300, Roi Dayan wrote:
> >> On heavily loaded systems the GC can take time to go over all existing
> >> conns and reset their timeout. At that time other calls like from
> >> nf_conntrack_in() can call of nf_ct_is_expired() and see the conn as
> >> expired. To fix this when we set the offload bit we should also reset
> >> the timeout instead of counting on GC to finish first iteration over
> >> all conns before the initial timeout.
> >>
> >> Fixes: 64ff70b80fd4 ("net/sched: act_ct: Offload established connections to flow table")
> >> Signed-off-by: Roi Dayan <roid@mellanox.com>
> >> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
> >> ---
> >>  net/sched/act_ct.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> >> index e9f3576cbf71..650c2d78a346 100644
> >> --- a/net/sched/act_ct.c
> >> +++ b/net/sched/act_ct.c
> >> @@ -366,6 +366,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
> > 
> > Extra context line:
> > 	err = flow_offload_add(&ct_ft->nf_ft, entry);
> >>  	if (err)
> >>  		goto err_add;
> >>  
> >> +	nf_ct_offload_timeout(ct);
> >> +
> > 
> > What about adding this to flow_offload_add() instead?
> > It is already adjusting the flow_offload timeout there and then it
> > also effective for nft.
> > 
> 
> As you said, in flow_offload_add() we adjust the flow timeout.
> Here we adjust the conn timeout.
> So it's outside flow_offload_add() which only touch the flow struct.
> I guess it's like conn offload bit is set outside here and for nft.

Right, but

> What do you think?

I don't see why it can't update both. flow_offload_fixup_ct_timeout(),
called by flow_offload_del(), is updating ct->timeout already. It
looks consistent to me to update it in _add as well then. 

> 
> >>  	return;
> >>  
> >>  err_add:
> >> -- 
> >> 2.8.4
> >>
