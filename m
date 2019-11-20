Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B621041DE
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbfKTRRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:17:21 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43302 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727671AbfKTRRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:17:20 -0500
Received: by mail-pg1-f195.google.com with SMTP id b1so25947pgq.10
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 09:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=5PexT+/ipxiQAcT6cILQ4wqSXMxHeHrXKtJBoJO5N/Y=;
        b=H7iJfIVGlBWjAOWxioUwGTqGTAiavtkFC5fCNsdmCFHVxpbhj7r6ijz2ojBx2oMPDH
         +h0IHRMQacg4RcRWum/0es1beA1Z/CGMLcNz9n6jl+i4UfW1sdvhyD41nOtyy7WRinEf
         NHX8rIagl/6VZzUsxPK5npDwGl9KJoHF1eQin867srifuIDDH2Iw+sPeUnuVTcyZnxox
         w6LYA8zfXXeqM+Q2zg+m3skf686iSWJMDpUNuknNKEqg0hi3GxEPNL/oRZBapfboaypW
         DEZnfQp8Rtn4WevV9YNuTtM77PfEPDNTN5N8aBi5zqH2m6r29I9thM0fs2WN663niapT
         7bcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5PexT+/ipxiQAcT6cILQ4wqSXMxHeHrXKtJBoJO5N/Y=;
        b=BzsHx9a6PqybDQIIrFoPZnZCOtnSqxdveWmY3smPELUz+d2DfpZns6SRk9n1y3mroM
         49ecCmuff24mbHTFRYX1P51S/8LlOcpvbGIqy3XD51FFFZAEXnebd1/6eBq/bLh11B3L
         s2B2S0qju+5M8VyjSgeqj+QxUiJ3oV0/9xC+YxM77UoZMrJ0e+zJFaPE3Qgj+O0i7omn
         ti4+h+dJad9mrbi3U8W22MXnFGtxtNUVfty8NYfKQrcVFPQfx2/RlggAJyZL+RKSa/Lf
         SkNCv7UHHWYPt5MNHxQcKOQ99RDGb3z9epwOcDQcwIt79qWHm/7c1E2hOmvB97END8rw
         pMOA==
X-Gm-Message-State: APjAAAWbXRZXi7msIGgnLQNBy4YAMNonlLMw1mo46CdtznPy0zYkmrJ1
        AIsgk4V0CzF0zEtZVr79GS7i1A==
X-Google-Smtp-Source: APXvYqz7KFcaXXGL/A4GmIQe3xYZFbp9h0x7N1Tmq/pG+hz6ohK+2sUesTWLRDctwtafOWkEi/Is6Q==
X-Received: by 2002:a65:6803:: with SMTP id l3mr4417590pgt.293.1574270239938;
        Wed, 20 Nov 2019 09:17:19 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id r13sm32357727pfg.3.2019.11.20.09.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 09:17:19 -0800 (PST)
Date:   Wed, 20 Nov 2019 09:17:04 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Simon Horman <simon.horman@netronome.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>
Subject: Re: [PATCH net-next 1/4] net: sched: add vxlan option support to
 act_tunnel_key
Message-ID: <20191120091704.2d10ab90@cakuba.netronome.com>
In-Reply-To: <CADvbK_d8XrsVJvdwemxjTEQbA-MAcOeERtJ3GTPtUmZ_6foEdw@mail.gmail.com>
References: <cover.1574155869.git.lucien.xin@gmail.com>
        <af3c3d95717d8ff70c2c21621cb2f49c310593e2.1574155869.git.lucien.xin@gmail.com>
        <20191119161241.5b010232@cakuba.netronome.com>
        <CADvbK_d8XrsVJvdwemxjTEQbA-MAcOeERtJ3GTPtUmZ_6foEdw@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 13:08:39 +0800, Xin Long wrote:
> > >  static const struct nla_policy
> > > @@ -64,6 +66,11 @@ geneve_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX + 1] = {
> > >                                                      .len = 128 },
> > >  };
> > >
> > > +static const struct nla_policy
> > > +vxlan_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX + 1] = {  
> >
> > [TCA_TUNNEL_KEY_ENC_OPT_VXLAN_UNSPEC] =
> >         { .strict_type_start = TCA_TUNNEL_KEY_ENC_OPT_VXLAN_UNSPEC + 1, }
> >  
> > > +     [TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP]         = { .type = NLA_U32 },
> > > +};
> > > +  
> But vxlan_opt_policy is a new policy, and it will be parsed by
> nla_parse_nested()
> where NL_VALIDATE_STRICT has been used.
> 
> .strict_type_start is used for setting NL_VALIDATE_STRICT for some new
> option appending on an old policy.
> 
> So I think .strict_type_start is not needed here.

Hm, that's what I thought but then we were asked to add it in
act_mpls.c. I should've checked the code.

Anyway, we should probably clean up act_mpls.c and act_ct.c so people
don't copy it unnecessarily.
