Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B4C5B3EED
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 20:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiIISf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 14:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiIISfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 14:35:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C221460695
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 11:35:20 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id fv3so2323300pjb.0
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 11:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=zqeNBoPSeMY+eKTgD2tlbolXX5ihMQJdioqn1NLcoDI=;
        b=mz8onY2OGUA53SEP4a9H3IgGwiYcQfJAO9Hx2GQ9AlayA1gv1DBx2GVtJd2Lz9uejt
         Z5TIRrcLzn9jyd7VOO/7fLcga3wgGiMLa6VT3j1kUCpQ86B9zM1K7Zoinkf87b//D7B4
         ScCYf0S9OaAm/O2ZOTuU4hjWMHTunIpuZ6tR4C/cZPNry6kJZaRenpfvWXT65HexOaWC
         0SwEoy1fZAmLef5V/HGrqnXzbPjVYF1LurirVTZeewWl/1tR6o8j0de7pcWgHEYImj53
         yIrnitv+4BCZvymPQ4qHnkjkRH4tvyzmnRqIiyFbv7wJ0SZHYT1X72HksWHYzjAc3vYH
         CNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=zqeNBoPSeMY+eKTgD2tlbolXX5ihMQJdioqn1NLcoDI=;
        b=NTtGQ82T5MzYJCivahDAPfytwsTo/l5CzdX+tb1WJ+G32M1BodIjCEHJAmdjmw3H9L
         wbh8DPUOIbPY4hHsZs0y1C4ATv36xTcVjvKe/65CDBWEKCftidKIod4ZDmeqo0Kdfkn/
         WRqhF4zapdWOHeVFLiyUjYWmf8hhujo+oT5iQscMS96oGDjMDNlhSqRdgupD6yqIVKXi
         5N/34qFWkwlO7jixKcEHBjg2ZjRP3PG39uOUNAeDFpHkdeZDrwhznInmGgYVNTAQ8WM6
         K8dxt7wRncv+9FnF/Z8iXHEl3p8wOziTkAoEpgabevv0yiGZtQfOSeEl2bWRReR3470O
         SmWg==
X-Gm-Message-State: ACgBeo3XFHMWsOpaiAXLi10kyZBeQkg2nxp4ZAhMi0LUVKDgCB0fR42G
        joTRZU1hvdvGqVugqs9rU/dXlWtwR366xUxABsfsS/WX
X-Google-Smtp-Source: AA6agR7vKaJeTnAWDd1izonY5EcezSjOEdBjdkS4BjxAHmltwwXHuptXqwbIUBBOTjkMMYvDF48NZQyA7p2QI+tbRHI=
X-Received: by 2002:a17:903:516:b0:176:6c04:f15e with SMTP id
 jn22-20020a170903051600b001766c04f15emr14633862plb.93.1662748520070; Fri, 09
 Sep 2022 11:35:20 -0700 (PDT)
MIME-Version: 1.0
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
 <CAKgT0UcCrEAfiEi-EVkXAmZxdyD910yr2v54iYe3nzQdaX+6ng@mail.gmail.com> <MWHPR11MB12939CF44A137DD8349B1EB5F1439@MWHPR11MB1293.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB12939CF44A137DD8349B1EB5F1439@MWHPR11MB1293.namprd11.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 9 Sep 2022 11:35:07 -0700
Message-ID: <CAKgT0UcierZArEiDZ2-8S8_gr2nwUZ3+3fJEAspGnbm13E_2Vw@mail.gmail.com>
Subject: Re: [net-next PATCH v2 0/4] Extend action skbedit to RX queue mapping
To:     "Nambiar, Amritha" <amritha.nambiar@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 9, 2022 at 2:18 AM Nambiar, Amritha
<amritha.nambiar@intel.com> wrote:
>
> > -----Original Message-----
> > From: Alexander Duyck <alexander.duyck@gmail.com>
> > Sent: Thursday, September 8, 2022 8:28 AM
> > To: Nambiar, Amritha <amritha.nambiar@intel.com>
> > Cc: netdev@vger.kernel.org; kuba@kernel.org; jhs@mojatatu.com;
> > jiri@resnulli.us; xiyou.wangcong@gmail.com; Gomes, Vinicius
> > <vinicius.gomes@intel.com>; Samudrala, Sridhar
> > <sridhar.samudrala@intel.com>
> > Subject: Re: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
> > mapping
> >
> > On Wed, Sep 7, 2022 at 6:14 PM Amritha Nambiar
> > <amritha.nambiar@intel.com> wrote:
> > >
> > > Based on the discussion on
> > > https://lore.kernel.org/netdev/20220429171717.5b0b2a81@kernel.org/,
> > > the following series extends skbedit tc action to RX queue mapping.
> > > Currently, skbedit action in tc allows overriding of transmit queue.
> > > Extending this ability of skedit action supports the selection of receive
> > > queue for incoming packets. Offloading this action is added for receive
> > > side. Enabled ice driver to offload this type of filter into the
> > > hardware for accepting packets to the device's receive queue.
> > >
> > > v2: Added documentation in Documentation/networking
> > >
> > > ---
> > >
> > > Amritha Nambiar (4):
> > >       act_skbedit: Add support for action skbedit RX queue mapping
> > >       act_skbedit: Offload skbedit queue mapping for receive queue
> > >       ice: Enable RX queue selection using skbedit action
> > >       Documentation: networking: TC queue based filtering
> >
> > I don't think skbedit is the right thing to be updating for this. In
> > the case of Tx we were using it because at the time we stored the
> > sockets Tx queue in the skb, so it made sense to edit it there if we
> > wanted to tweak things before it got to the qdisc layer. However it
> > didn't have a direct impact on the hardware and only really affected
> > the software routing in the device, which eventually resulted in which
> > hardware queue and qdisc was selected.
> >
> > The problem with editing the receive queue is that the hardware
> > offloaded case versus the software offloaded can have very different
> > behaviors. I wonder if this wouldn't be better served by being an
>
> Could you please explain how the hardware offload and software cases
> behave differently in the skbedit case. From Jakub's suggestion on
> https://lore.kernel.org/netdev/20220503084732.363b89cc@kernel.org/,
> it looked like the skbedit action fits better to align the hardware and
> software description of RX queue offload (considering the skb metadata
> remains same in offload vs no-offload case).

So specifically my concern is RPS. The problem is RPS takes place
before your TC rule would be applied in the software case, but after
it has been applied in the hardware case. As a result the behavior
will be different for one versus the other. With the redirect action
it will pull the packet out of the Rx pipeline and reinsert it so that
RPS will be applied to the packet and it would be received on the CPUs
expected.

> > extension of the mirred ingress redirect action which is already used
> > for multiple hardware offloads as I recall.
> >
> > In this case you would want to be redirecting packets received on a
> > port to being received on a specific queue on that port. By using the
> > redirect action it would take the packet out of the receive path and
> > reinsert it, being able to account for anything such as the RPS
> > configuration on the device so the behavior would be closer to what
> > the hardware offloaded behavior would be.
>
> Wouldn't this be an overkill as we only want to accept packets into a
> predetermined queue? IIUC, the mirred redirect action typically moves
> packets from one interface to another, the filter is added on interface
> different from the destination interface. In our case, with the
> destination interface being the same, I am not understanding the need
> for a loopback. Also, WRT to RPS, not sure I understand the impact
> here. In hardware, once the offloaded filter executes to select the queue,
> RSS does not run. In software, if RPS executes before
> sch_handle_ingress(), wouldn't any tc-actions (mirred redirect or skbedit
> overriding the queue) behave in similar way ?

The problem is that RPS != RSS. You can use the two together to spread
work out over a greater set of queues. So for example in a NUMA system
with multiple sockets/nodes you might use RSS to split the work up
into a per-node queue(s), and then use RPS to split up the work across
CPUs within that node. If you pick a packet up from one device and
redirect it via the mirred action the RPS is applied as though the
packet was received on the device so the RPS queue would be correct
assuming you updated the queue. That is what I am looking for. What
this patch is doing is creating a situation where the effect is very
different between the hardware and software version of things which
would likely break things for a use case such as this.
