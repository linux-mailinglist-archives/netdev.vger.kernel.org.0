Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616502F243F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405473AbhALAZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404208AbhAKXwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:52:01 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1618AC061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 15:51:20 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id j26so517068qtq.8
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 15:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ELinL68AP+kh1mq7W6/08RZWCl6WI3zHsrxLKXF39o0=;
        b=jxTen3VPm3sCBwuscmekvSZ8/YkjYhpeeVPpyuoLuSC8S1XekhOKNa+2uEs5fQdFWz
         1r+LOghi/82m5wJH6xrLH+pOGq62NyDseNVnStF0/fkbwpecVF6hxaSWJNPiLSeoSSHG
         MgpqUOekJPDYBfm9kpUDUyHade1OZ+4tab0eehuJDxj889fqKAZPKaZTPN2IBa+9W/Ux
         U98naCS6GEbdzP3G+zImreLPcgZd9YfIEHGRfF7czHgltYjnvpaDoc3/vgMTlNOjxwHP
         UaeoBBSVfISrA5vdf1/h8bHFmE5Q6xKRtIX0MvEe33328RCwk5ohjvIOgPehEwQ4nljR
         jFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ELinL68AP+kh1mq7W6/08RZWCl6WI3zHsrxLKXF39o0=;
        b=FOAX1iykRI7vDO5FxYGn18dEsWTVZ58P91n2mOy+nlYbS4FQtQ+ndskNQZj1ywACif
         MIEJc1jNLH3aop0F/K9FInFTWjpdDT2kUrmjQlXRWnqZQUkGUA9Pox3JkF3cnbRaSJd2
         PHw+BAuCg2IMvtp1SggU+JIJJgpLZ0f0zmXgcXvldSNF8IHmsa0ph/54h3JpB7rboskX
         53PCUd7T8wD+HJ9+OwfBhCKkNuM6FozxITpbsc1ocTQg8s+27b1/JCaCcfyUCk9N1dQh
         nfxH57wPbIBBNrGmtun70uO0Y1VcjYe4EhggmL3pA11zV8kK0eR4caP6/XXGG0jswdfy
         yGYw==
X-Gm-Message-State: AOAM530cgSM4716E9M5mwTeBcWXySO0Yh7LH/3q8utylRpTH3V4nyr6H
        Smj9E/4M/mgNcycOSLKGclk=
X-Google-Smtp-Source: ABdhPJyiFx3UkAG/iOVD+7WzDt2cBKMq3kczaoKKd93VSrtNo7uJ7wgtkc/+yj/kDsh9D5VAqXpvxA==
X-Received: by 2002:ac8:6f65:: with SMTP id u5mr2034251qtv.303.1610409079224;
        Mon, 11 Jan 2021 15:51:19 -0800 (PST)
Received: from horizon.localdomain ([177.220.172.93])
        by smtp.gmail.com with ESMTPSA id q37sm533847qte.10.2021.01.11.15.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 15:51:18 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 1362AC0867; Mon, 11 Jan 2021 20:51:16 -0300 (-03)
Date:   Mon, 11 Jan 2021 20:51:16 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: Re: [net-next 08/15] net/mlx5e: CT: Preparation for offloading
 +trk+new ct rules
Message-ID: <20210111235116.GA2595@horizon.localdomain>
References: <20210108053054.660499-1-saeed@kernel.org>
 <20210108053054.660499-9-saeed@kernel.org>
 <20210108214812.GB3678@horizon.localdomain>
 <c11867d2-6fda-d77c-6b52-f4093c751379@nvidia.com>
 <218258b2-3a86-2d87-dfc6-8b3c1e274b26@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <218258b2-3a86-2d87-dfc6-8b3c1e274b26@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 09:52:55AM +0200, Roi Dayan wrote:
> 
> 
> On 2021-01-10 9:45 AM, Roi Dayan wrote:
> > 
> > 
> > On 2021-01-08 11:48 PM, Marcelo Ricardo Leitner wrote:
> > > Hi,
> > > 
> > > On Thu, Jan 07, 2021 at 09:30:47PM -0800, Saeed Mahameed wrote:
> > > > From: Roi Dayan <roid@nvidia.com>
> > > > 
> > > > Connection tracking associates the connection state per packet. The
> > > > first packet of a connection is assigned with the +trk+new state. The
> > > > connection enters the established state once a packet is seen on the
> > > > other direction.
> > > > 
> > > > Currently we offload only the established flows. However, UDP traffic
> > > > using source port entropy (e.g. vxlan, RoCE) will never enter the
> > > > established state. Such protocols do not require stateful processing,
> > > > and therefore could be offloaded.
> > > 
> > > If it doesn't require stateful processing, please enlight me on why
> > > conntrack is being used in the first place. What's the use case here?
> > > 
> > 
> > The use case for example is when we have vxlan traffic but we do
> > conntrack on the inner packet (rules on the physical port) so
> > we never get established but on miss we can still offload as normal
> > vxlan traffic.
> > 
> 
> my mistake about "inner packet". we do CT on the underlay network, i.e.
> the outer header.

I miss why the CT match is being used there then. Isn't it a config
issue/waste of resources? What is CT adding to the matches/actions
being done on these flows?

> 
> > > > 
> > > > The change in the model is that a miss on the CT table will be forwarded
> > > > to a new +trk+new ct table and a miss there will be forwarded to
> > > > the slow
> > > > path table.
> > > 
> > > AFAICU this new +trk+new ct table is a wildcard match on sport with
> > > specific dports. Also AFAICU, such entries will not be visible to the
> > > userspace then. Is this right?
> > > 
> > >    Marcelo
> > > 
> > 
> > right.

Thanks,
Marcelo
