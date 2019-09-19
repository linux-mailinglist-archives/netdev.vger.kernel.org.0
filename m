Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CB9B7A20
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 15:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732265AbfISNHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 09:07:51 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37827 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730838AbfISNHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 09:07:51 -0400
Received: by mail-qk1-f194.google.com with SMTP id u184so3288957qkd.4
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 06:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q8cnyfGfmzAjc9ImXRGBhM+FXEEv9+QulAkaTqqMuq0=;
        b=X52OAWbis3WGfxDzkDCwt9paOPvE4hB2l5oxhWiXbjRwZaajThKLWBHc32s31tcLnE
         5G7/mDnP7+EVb8anXxPR78J/80hhqkmzI2LL+9skIawodfqkiffOI+RlWUCCzmfXupVP
         SXvKHSafnu4Sol/6VnCVazTtL82o/yU/OSSymcG1bojUhF3Dl+Ruv22Wu37h3mhcsdl7
         dsyOMPS3dqha6YKvnTHlToY8oZBuGoYy0ZhxcSEBSx+ICv4/Mu0d09gbxLuDhrSHgNgR
         GKr1CEUlZNdoT0ZIjNCE6amC7jIWyqwm/Uuib9TSFe64tZAbL+Jcqti5dSway42j82NJ
         xTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q8cnyfGfmzAjc9ImXRGBhM+FXEEv9+QulAkaTqqMuq0=;
        b=sgsEx0n6+PgoPn2mcuDm/AByhJ+fKen/ZURRtZLVJ+RQp10w0dI4Qe73MiQTy8xYRu
         MizQN4H//EJTpEXBon/8lwguvDBy3iL+w5SfVqMdQx956YPQ+wgTqundKspPEHC/asxO
         P0w+PnKfIfFytsYvzNAzEDg0yBQG9NIN+R/89AlubGDYzLC9ZFtUpN/tjYQmfNws+sjp
         uhB8PvKiSnwL67TbOcZ73W19wXwX43z/C75k5rlvB3acxbcZpZrugVbPrvTYluerbxi5
         59q74lZjO1IW5L7nVjtuZ1SCPmdvBOvqZ7I3prq+DZcb7xHX6PRwrSA5GrXmL0N7K8G3
         U6dA==
X-Gm-Message-State: APjAAAXN6SJNJjnr7RNF6TjS2jPHXIYkjwafJdwgiO/XniEMVMLnX4V+
        P31UoV+l7JzjPY1cSN/Bpc8F5SmRTXE=
X-Google-Smtp-Source: APXvYqxhfoFkrcm/9C3A+W8PUKjbTii8b9ciEsen4mA/MbRav+V/5gp+eaLZDuYpKyUs1aZNWh1C5A==
X-Received: by 2002:a37:a00d:: with SMTP id j13mr2877908qke.2.1568898470231;
        Thu, 19 Sep 2019 06:07:50 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.215])
        by smtp.gmail.com with ESMTPSA id r1sm3715617qti.4.2019.09.19.06.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 06:07:49 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id B930EC4A4F; Thu, 19 Sep 2019 10:07:46 -0300 (-03)
Date:   Thu, 19 Sep 2019 10:07:46 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC v3 0/5] Support fraglist GRO/GSO
Message-ID: <20190919130746.GC3431@localhost.localdomain>
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
 <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com>
 <20190918165817.GA3431@localhost.localdomain>
 <CA+FuTSf0N9uhOM3r8xvXiVj0xhx0KqL6-rV9EGhBJ=d8oGaxyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSf0N9uhOM3r8xvXiVj0xhx0KqL6-rV9EGhBJ=d8oGaxyg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 08:55:22AM -0400, Willem de Bruijn wrote:
> On Wed, Sep 18, 2019 at 12:58 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Wed, Sep 18, 2019 at 12:17:08PM -0400, Willem de Bruijn wrote:
> > > On Wed, Sep 18, 2019 at 3:25 AM Steffen Klassert
> > > <steffen.klassert@secunet.com> wrote:
> > > >
> > > > This patchset adds support to do GRO/GSO by chaining packets
> > > > of the same flow at the SKB frag_list pointer. This avoids
> > > > the overhead to merge payloads into one big packet, and
> > > > on the other end, if GSO is needed it avoids the overhead
> > > > of splitting the big packet back to the native form.
> > > >
> > > > Patch 1 Enables UDP GRO by default.
> > > >
> > > > Patch 2 adds a netdev feature flag to enable listifyed GRO,
> > > > this implements one of the configuration options discussed
> > > > at netconf 2019.
> > > >
> > > > Patch 3 adds a netdev software feature set that defaults to off
> > > > and assigns the new listifyed GRO feature flag to it.
> > > >
> > > > Patch 4 adds the core infrastructure to do fraglist GRO/GSO.
> > > >
> > > > Patch 5 enables UDP to use fraglist GRO/GSO if configured and no
> > > > GRO supported socket is found.
> > >
> > > Very nice feature, Steffen. Aside from questions around performance,
> > > my only question is really how this relates to GSO_BY_FRAGS.
> >
> > They do the exact same thing AFAICT: they GSO according to a
> > pre-formatted list of fragments/packets, and not to a specific size
> > (such as MSS).
> >
> > >
> > > More specifically, whether we can remove that in favor of using your
> > > new skb_segment_list. That would actually be a big first step in
> > > simplifying skb_segment back to something manageable.
> >
> > The main issue (that I know) on obsoleting GSO_BY_FRAGS is that
> > dealing with frags instead of frag_list was considered easier to be
> > offloaded, if ever attempted.  So this would be a step back on that
> > aspect.  Other than this, it should be doable.
> 
> But GSO_BY_FRAGS also uses frag_list, not frags?

/me is scratching his head.
My bad. I thought it was already using frags. Thanks.

> 
> And list_skb->len for mss.

Which stands more for 'current frag size', yes.
(list_skb, not head_skb)
