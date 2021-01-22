Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30742FFA52
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 03:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbhAVCRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 21:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbhAVCRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 21:17:03 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446E4C06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 18:16:23 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id d85so3859092qkg.5
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 18:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IlCRROwfS1HQeArbxxfXDNnQHftMDV2uqYONFgpfv9w=;
        b=EvCK8gQZ0MqU1nsbCuaoL2grPf/y/C3NHyFQH3psjMLuxyKl4BCjbuLErgLonVIvru
         V+sTWKpcTKldWAIy2Jna9+PCXg2Rq3Iwfqlr3g+X8z0yVynwfwfQxGHFPxILjUvrg4aq
         jQUdirTz2WDSByHbFiB5RICT/q6hSEL8N2wvAK3iY8yr61QCMdb5FeNJ2/qZKQFBTUNy
         38Ckf7AR/NKVz2BCxA6pJT1mfC+VXDx5P3efTtzAxhvv3Eey++d/jF1TEjFrt7acRAac
         kIlDqK0N3jWSXS1DL0RWCJvuddXNro+u94L9C0x07uvRAmYqhePNISAVIiNdpODdTwdO
         Mb2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IlCRROwfS1HQeArbxxfXDNnQHftMDV2uqYONFgpfv9w=;
        b=qPTSs52CJGsGI6PzmiKwOYZyOoIsYQP//49XudDei4NUrqX4fELwohFHBtCLylV0/Q
         QE0CIlW6aL4w4nmJC/3Y4pu1KZF5N/xvhYU7MNWMnqrM+do0FE3Daeccg397SPh5/JJR
         zep1+Xga9e/qC17omdqwW9UTOA8xoL2+k7IT6Xygcn5dpYwyY1wiCGNpyYmOFjPAuHzp
         MRz7hXXY5PSirPce8itdDylNri6H84ZYTWF0DT3w8pYSYg2GO5RM9nkpvBYhEJbXRlnn
         GlKSIbYXjEJGSjuh6lqnCAw6jmW7jgms2zpHdn4iu3J4WatbWdpTuo9mnNYA4Cy0IKnw
         lzPg==
X-Gm-Message-State: AOAM531uxWcDeWKpRKn41+oQDnz8aNk8Ny0KykD7d3H7jNyID8/tEMEG
        eE4nqQr8ImS/eX0J3LmErPg=
X-Google-Smtp-Source: ABdhPJxzRomniFuwgFONV3pn5sK1UbYckTj/GT4Smx5C8CImGKJ93AWw6ayVC+n5HXO1Bh7nnfrqXA==
X-Received: by 2002:a37:4285:: with SMTP id p127mr2764586qka.501.1611281782304;
        Thu, 21 Jan 2021 18:16:22 -0800 (PST)
Received: from horizon.localdomain ([2001:1284:f016:4ecb:865e:1ab1:c1d6:3650])
        by smtp.gmail.com with ESMTPSA id n20sm5109663qtc.13.2021.01.21.18.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 18:16:21 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id CD4BAC0EA1; Thu, 21 Jan 2021 23:16:18 -0300 (-03)
Date:   Thu, 21 Jan 2021 23:16:18 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 08/15] net/mlx5e: CT: Preparation for offloading
 +trk+new ct rules
Message-ID: <20210122021618.GH3863@horizon.localdomain>
References: <20210108214812.GB3678@horizon.localdomain>
 <c11867d2-6fda-d77c-6b52-f4093c751379@nvidia.com>
 <218258b2-3a86-2d87-dfc6-8b3c1e274b26@nvidia.com>
 <20210111235116.GA2595@horizon.localdomain>
 <f25eee28-4c4a-9036-8c3d-d84b15a8b5e7@nvidia.com>
 <20210114130238.GA2676@horizon.localdomain>
 <d1b5b862-8c30-efb6-1a2f-4f9f0d49ef15@nvidia.com>
 <20210114215052.GB2676@horizon.localdomain>
 <009bd8cf-df39-5346-b892-4e68a042c4b4@nvidia.com>
 <20210122011834.GA25356@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122011834.GA25356@salvia>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 02:18:34AM +0100, Pablo Neira Ayuso wrote:
> Hi Oz,
> 
> On Wed, Jan 20, 2021 at 06:09:48PM +0200, Oz Shlomo wrote:
> > On 1/14/2021 11:50 PM, Marcelo Ricardo Leitner wrote:
> > > 
> > > Thoughts?
> > > 
> > 
> > I wonder if we should develop a generic mechanism to optimize CT software
> > for a use case that is faulty by design.
> > This has limited value for software as it would only reduce the conntrack
> > table size (packet classification is still required).
> > However, this feature may have a big impact on hardware offload.
> > Normally hardware offload relies on software to handle new connections.
> > Causing all new connections to be processed by software.
> > With this patch the hardware may autonomously set the +new connection state
> > for the relevant connections.
> 
> Could you fix this issue with unidirectional flows by checking for
> IPS_CONFIRMED status bit? The idea is to hardware offload the entry
> after the first packet goes through software successfully. Then, there
> is no need to wait for the established state that requires to see
> traffic in both directions.

That's an interesting idea. This way, basically all that needs to be
changed is tcf_ct_flow_table_process_conn() to handle this new
condition for UDP packets and on tcf_ct_act().

It has a small performance penaulty if compared to the original
solution, as now the first packet(s) goes to sw, but looks like a good
compromise between supporting a (from what I could understand)
somewhat lazy flow design (as I still think these didn't need to go
through conntrack), an uniform system behavior (with and without
offload, with mlx5 or another driver) and a more generic approach.
Other situations that rely on unidirectional UDP flows will benefit
from it as well.

This way I even think it doesn't need to be configurable right now.
It will be easier to add a knob to switch back to the old behavior if
needed later on, if anything.

  Marcelo
