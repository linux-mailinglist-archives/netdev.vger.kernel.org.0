Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABF041537E
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 00:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238309AbhIVWd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 18:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238288AbhIVWd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 18:33:57 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14D5C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 15:32:26 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id q125so721604qkd.12
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 15:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AWnNN/40myxVrcT3SnK4q8kCCAEQj47HtpWTVSAoKmI=;
        b=aoONzh0A1HOx3oUj2x1t0ReoGrlddBUuP+bJgQJ1GXIQWZGNyjjZidTRMNiIjgEx0g
         UERxOYx1FUoOITl9f8u3ol4WtY9jMXPPKegA/5i86rvO5eHOdw4CnrHVkVU4sCe8H2MY
         WwIi/6Ev0qO3I3l0cjgeOeWSDnDtWqbBi4T5R/G+l7Pt7vKPXffA908o+lr750kCbJTu
         LPyKgB5oxTz/R3CuzWAtMqV0aeses5UDVD7bsmQJfVrntEqxPGpyrmu47Zka45zBNsrp
         Pnbhn1vKxTKwComwTIOS1AOcN2wKD8qW4PChjhicRtuVZSD8lC/GWW7ETxTvbFuCA4lP
         DyOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AWnNN/40myxVrcT3SnK4q8kCCAEQj47HtpWTVSAoKmI=;
        b=3oDsB6+L8JAezBCxNFXBM6m+Zm9xIWqVjNcxrwf5S8ZWKJ6FrMWXq5XEf1H/w6AWv5
         4lOpQt3cu9Y2m0l6zre1o92IbNTH/GFSk3gKLpZR2/Hr1bqFRu7NyF58IlUHbsj82Tf5
         UtV7SFbwZmyBnyWZAuj3AEJgvCDCdXVDb+0Iq5WJ1JwjbRz0Dl1n0RHUD13kgMJIk1Wi
         epcPrOP9aNe3zUvowoC8RvKEKH8aN22eLlpQCH3ItTzmq4ZbQHGQuZF3FjWwy7M5zRC5
         28Md2Gbt0/4e8ccBoDbJ2fA3mx8PQsCwp//bzHQdQGDM2J/uUD6aqeiLVRltIeTGP/qt
         cVVA==
X-Gm-Message-State: AOAM533SqJaSaK8q+BOCXzBnMS65cb2jVCgPHrB2BHDwpWhWlHqqm1YD
        oGTGHRt8woYmGNKRnroMCTc=
X-Google-Smtp-Source: ABdhPJzdT4nXiRVmPTJWjTC/wXVvae5Rl6qi/u/Z778RDV+AL4/YvXA9NYEzu7JS0Z2p8QSDui/J3g==
X-Received: by 2002:a05:620a:11ab:: with SMTP id c11mr1806376qkk.169.1632349945964;
        Wed, 22 Sep 2021 15:32:25 -0700 (PDT)
Received: from t14s.localdomain ([177.220.174.161])
        by smtp.gmail.com with ESMTPSA id b20sm2253752qtt.2.2021.09.22.15.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 15:32:24 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 89)
        id AEE9C675CA; Wed, 22 Sep 2021 20:06:16 -0300 (-03)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id DD6DB673A5; Wed, 22 Sep 2021 17:25:53 -0300 (-03)
Date:   Wed, 22 Sep 2021 17:25:53 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Tom Herbert <tom@sipanda.io>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Felipe Magno de Almeida <felipe@sipanda.io>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>, paulb@nvidia.com,
        Davide Caratti <dcaratti@redhat.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2
 classifier based on PANDA parser in kernel
Message-ID: <YUuRUa67muprw7jS@t14s.localdomain>
References: <20210916200041.810-1-felipe@expertise.dev>
 <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
 <YUq1Ez1g8nBvA8Ad@nanopsycho>
 <CAOuuhY8KA99mV7qBHwX79xP31tqtc9EggSNZ-=j4Z+awJUosdQ@mail.gmail.com>
 <20210922154929.GA31100@corigine.com>
 <CAOuuhY9NPy+cEkBx3B=74A6ef0xfT_YFLASEOB4uvRn=W-tB5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOuuhY9NPy+cEkBx3B=74A6ef0xfT_YFLASEOB4uvRn=W-tB5A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 10:28:41AM -0700, Tom Herbert wrote:
> On Wed, Sep 22, 2021 at 8:49 AM Simon Horman <simon.horman@corigine.com> wrote:
> >
> > On Wed, Sep 22, 2021 at 07:42:58AM -0700, Tom Herbert wrote:
> > > On Tue, Sep 21, 2021 at 9:46 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > > >
> > > > Wed, Sep 22, 2021 at 06:38:20AM CEST, xiyou.wangcong@gmail.com wrote:
> > > > >On Thu, Sep 16, 2021 at 1:02 PM Felipe Magno de Almeida
> > > > ><felipe@sipanda.io> wrote:
> > > > >>
> > > > >> The PANDA parser, introduced in [1], addresses most of these problems
> > > > >> and introduces a developer friendly highly maintainable approach to
> > > > >> adding extensions to the parser. This RFC patch takes a known consumer
> > > > >> of flow dissector - tc flower - and  shows how it could make use of
> > > > >> the PANDA Parser by mostly cutnpaste of the flower code. The new
> > > > >> classifier is called "flower2". The control semantics of flower are
> > > > >> maintained but the flow dissector parser is replaced with a PANDA
> > > > >> Parser. The iproute2 patch is sent separately - but you'll notice
> > > > >> other than replacing the user space tc commands with "flower2"  the
> > > > >> syntax is exactly the same. To illustrate the flexibility of PANDA we
> > > > >> show a simple use case of the issues described in [2] when flower
> > > > >> consumes PANDA. The PANDA Parser is part of the PANDA programming
> > > > >> model for network datapaths, this is described in
> > > > >> https://github.com/panda-net/panda.
> > > > >
> > > > >My only concern is that is there any way to reuse flower code instead
> > > > >of duplicating most of them? Especially when you specifically mentioned
> > > > >flower2 has the same user-space syntax as flower, this makes code
> > > > >reusing more reasonable.
> > > >
> > > > Exactly. I believe it is wrong to introduce new classifier which would
> > > > basically behave exacly the same as flower, only has different parser
> > > > implementation under the hood.
> > > >
> > > > Could you please explore the possibility to replace flow_dissector by
> > > > your dissector optionally at first (kernel config for example)? And I'm
> > > > not talking only about flower, but about the rest of the flow_dissector
> > > > users too.
> >
> > +1
> >
> > > Hi Jiri,
> > >
> > > Yes, the intent is to replace flow dissector with a parser that is
> > > more extensible, more manageable and can be accelerated in hardware
> > > (good luck trying to HW accelerate flow dissector as is ;-) ). I did a
> > > presentation on this topic at the last Netdev conf:
> > > https://www.youtube.com/watch?v=zVnmVDSEoXc. FIrst introducing this
> > > with a kernel config is a good idea.
> >
> > Can we drop hyperbole? There are several examples of hardware that
> > offload (a subset of) flower. That the current kernel implementation has
> > the properties you describe is pretty much irrelevant for current hw
> > offload use-cases.
> 
> Simon,
> 
> "current hw offload use-cases" is the problem; these models offer no
> extensibility. For instance, if a new protocol appears or a user wants
> to support their own custom protocol in things like tc-flower there is
> no feasible way to do this. Unfortunately, as of today it seems, we
> are still bound by the marketing department at hardware vendors that
> pick and choose the protocols that they think their customers want and
> are willing to invest in-- we need to get past this once and for all!

Not that I don't agree with this, but I'm having a hard time seeing
how flower2 would be more flexible than current approach in this
sense. Say that someone wants to add support for IPv64. AFAICS it
would still require changes to iproute, cls_flower2, panda and
drivers, which is the complain that I usually hear about cls_flower
extensibility.

TCP options too, for example. The 1st patch has code like:

+#define PANDA_METADATA_tcp_options                                     \
+       struct {                                                        \
+               __u16 mss;                                              \
+               __u8 window_scaling;                                    \
+               struct {                                                \
+                       __u32 value;                                    \
+                       __u32 echo;                                     \
+               } timestamp;                                            \
+               struct {                                                \
+                       __u32 left_edge;                                \
+                       __u32 right_edge;                               \
+               } sack[PANDA_TCP_MAX_SACKS];                                    \
+       } tcp_options

...

+#define PANDA_METADATA_TEMP_tcp_option_mss(NAME, STRUCT)               \
+static void NAME(const void *vopt, void *iframe,                       \
+                struct panda_ctrl_data ctrl)                           \
+{                                                                      \
+       const struct tcp_opt_union *opt = vopt;                         \
+       struct STRUCT *frame = iframe;                                  \
+                                                                       \
+       frame->tcp_options.mss = ntohs(opt->mss);                       \
+}

So if we have a new option on the game, what will need updating?

  Marcelo

> IMO, what we need is a common way to extend the kernel, tc, and other
> applications for new protocols and features, but also be able to apply
> that method to extend to the hardware which is _offloading_ kernel
> functionality which in this case is flow dissector. The technology is
> there to do this as programmable NICs for instance are the rage, but
> we do need to create common APIs to be able to do that. Note this
> isn't just tc, but a whole space of features; for instance, XDP hints
> is nice idea for the NIC to provide information about protocols in a
> packet, but unless/until there is a way to program the device to pull
> out arbitrary information that the user cares about like something
> from their custom protocol, then it's very limited utility...
> 
> Tom
