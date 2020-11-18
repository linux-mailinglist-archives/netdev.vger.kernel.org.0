Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE6C2B8382
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgKRSAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgKRSAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 13:00:51 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F04C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 10:00:50 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id a13so2695719qkl.4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 10:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=r+L3qp3oOQ+tYFNTgHlJ+2CTbZcOSSTeP1MEGmkX1ao=;
        b=cMA8/DFj5CjX4D7O1crIthxuwgjnSTo/NKSjdj7LB5dgaBYgu9yagnV+n2M1YRib8m
         cFjHbiiPcQJdXzY32nFbnQ67+tRgGR4jYF9jzjIpH1iVXEzwkJXvLpzkAPsxn2tmf3Pr
         WszYZYXWvFpl+jS7Xk7ODClPU6/Rm9dpm++l2XbDIpjNGHrWecZp+Ewf5o1IGmN+7+rS
         moe69/cXYv4/VSZ9XpMObWY+yknLyJK0sNcLQJgQEew8OKMeyE0hUAsvvkFGJ63HhmV7
         CZNKcKbf/6sMLiPYDNkbfE/D0e9mr9YCEl+Z2v2YFPlVns6/S4jjXuePMVu3xBNNvQ8Y
         mxZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=r+L3qp3oOQ+tYFNTgHlJ+2CTbZcOSSTeP1MEGmkX1ao=;
        b=G0nm/5VeCCaLw+Xcuf2c6hE5i7DP8/JWt8JtGeqYTPZT2gaTxYEp/DQDlmHRn1Icw5
         fz/plf2tRFbd5mirooc+ZNngEx7M4U5onhGthro7UBM0ZMqNyyqNo9ESBXANcOWH1y7a
         nIgSHkGAzFXms529d47gUt6Ld2ZvDixUz/XKO6/skTDxtWewi+K5M3emcHWa5Yn3gt7G
         GCllT0OhiaLdrymSGBsBC1kMs6KFM38dfqHKaRn2slBzdk8GOXui7qP8CCbK4aODsydZ
         2s292QfTIFbQhe16fTMj6MpDUHNhWg9f7MQoFuMtrt95ygOJLnu310IeZ7l4Lvy6ZUP+
         oclQ==
X-Gm-Message-State: AOAM531wsMZleQBE3hjpO6g+vI836SdXh74DOxQr3T3aqAmTj7xrNNjl
        SAOac15OdL/aBzq6YXDb0Nc=
X-Google-Smtp-Source: ABdhPJw6etfZAm26IS7mCnbT3+yQx/0NM+AZ0mRMkcBmPQcL9SrX8NF089xOQpUGrJ6cNUVNRJQ3AQ==
X-Received: by 2002:a37:aad2:: with SMTP id t201mr5852956qke.61.1605722449538;
        Wed, 18 Nov 2020 10:00:49 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.93])
        by smtp.gmail.com with ESMTPSA id z16sm18000555qka.18.2020.11.18.10.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 10:00:48 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6D6A7C556C; Wed, 18 Nov 2020 15:00:46 -0300 (-03)
Date:   Wed, 18 Nov 2020 15:00:46 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com
Subject: Re: [PATCH net] net/sched: act_mpls: ensure LSE is pullable before
 reading it
Message-ID: <20201118180046.GA449907@localhost.localdomain>
References: <e14a44135817430fc69b3c624895f8584a560975.1605716949.git.dcaratti@redhat.com>
 <20201118164719.GL3913@localhost.localdomain>
 <be2382dca0d817a4b5ac5b9820307ec82ce30c96.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be2382dca0d817a4b5ac5b9820307ec82ce30c96.camel@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 06:07:22PM +0100, Davide Caratti wrote:
> On Wed, 2020-11-18 at 13:47 -0300, Marcelo Ricardo Leitner wrote:
> > On Wed, Nov 18, 2020 at 05:36:52PM +0100, Davide Caratti wrote:
> > 
> > Hi,
> > 
> > >  	case TCA_MPLS_ACT_MODIFY:
> > > +		if (!pskb_may_pull(skb,
> > > +				   skb_network_offset(skb) + sizeof(new_lse)))
> > > +			goto drop;
> > >  		new_lse = tcf_mpls_get_lse(mpls_hdr(skb), p, false);
> > >  		if (skb_mpls_update_lse(skb, new_lse))
> > >  			goto drop;
> > 
> > Seems TCA_MPLS_ACT_DEC_TTL is also affected. skb_mpls_dec_ttl() will
> > also call mpls_hdr(skb) without this check.
> > 
> >   Marcelo
> > 
> ... yes, correct; and at a first glance, also set_mpls() in
> openvswitch/action.c has the same (theoretical) issue. I will follow-up
> with other 2 patches, ok?

Yep! Thanks.

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
