Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1295BB0A4
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 17:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiIPP7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 11:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiIPP7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 11:59:02 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632F04A138
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 08:59:01 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r23so12173308pgr.6
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 08:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=lKzhFEvutueGpa9xhNg/vC6dP3GMURUn9ftmdP+uuto=;
        b=Nw/ztxpRLn2VfMMwLJumhDtRm29VfjtFcSsN7kLYn69Tv8H0RZCTSyemCYg4pNv7+S
         jmlLB9FVrp5es0lPcmMhY0EuKXE0X/Adh8PXL/mKh+gPfNloIAbYdSonADpEhrV20d7k
         JDzqsYp7aM9QueL81O2m3DvOJ0+5+WERyldBKAM09YJWQ9qW4w7tH4YufYFu1zPFvmem
         0fiy2zPmRhBBTtUUks+iiYoFwhZeAZzU6ngtNM2q5dpmzIV38nxeUzUlGDDiZt1OaULX
         c6voIMdpiO/nmls3NlfHnq3lNqZxkm3Eja7gnXqhGuAP3MweFUNc5MPf2Ya/R6Ckj1KC
         Ud6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=lKzhFEvutueGpa9xhNg/vC6dP3GMURUn9ftmdP+uuto=;
        b=x2X52RoV9tRNTC0xeHO2I3KuwIFfntLyef46g3t2b4RnyRj0+pVqCrBJ0KjBOrG2t+
         pkLsUYHluadLdQGdmhq+MPeu7sqGb28wl+JDggJFsDwiSj8tMZNlCnwe/bKxXhh2iKl/
         oOPE/9bj2uQM/hAgb5egXAyJGd8wcEeOD+kGj92Gx8TRdLpg+U8842uNLSeuSSluMzT7
         Ix1499RQkYOy++3HnWDzYjUu23seeam2qvw9x3mtHBM70j99JRq75NrDweoeVdHZAgSO
         mOLNMFE7l9lF7N/EMWQx8JvmaLDiH30BuIat4Vq4Cbi0XqOMzPN5DU3W9a28CY0qsA/g
         UIjw==
X-Gm-Message-State: ACrzQf2+ErozqgR/QYbHUBy6FnV7ruNS9TzlYDW55Uro0FvFzliBKlle
        JIXSjrmeM2ngvYNlDF1I7hgkxD7ZrHaDapUZLw0Yvfym
X-Google-Smtp-Source: AMsMyM5w3YBGC9MwSdiWjLHE5SmwbJsNrWZ8GqsS4G4Uc/QpKr22BvOjM6EeBY/VIiPtS9kdO7iO5kYLQGCPEN5HMXI=
X-Received: by 2002:a05:6a00:2181:b0:51b:560b:dd30 with SMTP id
 h1-20020a056a00218100b0051b560bdd30mr5936796pfi.44.1663343940697; Fri, 16 Sep
 2022 08:59:00 -0700 (PDT)
MIME-Version: 1.0
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
 <CAKgT0UcCrEAfiEi-EVkXAmZxdyD910yr2v54iYe3nzQdaX+6ng@mail.gmail.com>
 <MWHPR11MB12939CF44A137DD8349B1EB5F1439@MWHPR11MB1293.namprd11.prod.outlook.com>
 <CAKgT0UcierZArEiDZ2-8S8_gr2nwUZ3+3fJEAspGnbm13E_2Vw@mail.gmail.com>
 <MWHPR11MB1293428E17B99FBD3CBF4A87F1499@MWHPR11MB1293.namprd11.prod.outlook.com>
 <CAKgT0UdDk9em9h3MYDX=jzh7Bm9KWkTYx4raE=QuiszDoxf4Xw@mail.gmail.com> <MWHPR11MB1293DE4CD2757714FC469DECF1499@MWHPR11MB1293.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB1293DE4CD2757714FC469DECF1499@MWHPR11MB1293.namprd11.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 16 Sep 2022 08:58:48 -0700
Message-ID: <CAKgT0Uc0R4r6111mfkqz9hugJTDqyuTBs7mf-ta=zqgemyiFsw@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 3:09 PM Nambiar, Amritha
<amritha.nambiar@intel.com> wrote:
>
> > -----Original Message-----
> > From: Alexander Duyck <alexander.duyck@gmail.com>
> > Sent: Thursday, September 15, 2022 8:21 AM
> > To: Nambiar, Amritha <amritha.nambiar@intel.com>
> > Cc: netdev@vger.kernel.org; kuba@kernel.org; jhs@mojatatu.com;
> > jiri@resnulli.us; xiyou.wangcong@gmail.com; Gomes, Vinicius
> > <vinicius.gomes@intel.com>; Samudrala, Sridhar
> > <sridhar.samudrala@intel.com>
> > Subject: Re: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
> > mapping
> >
> > On Thu, Sep 15, 2022 at 1:45 AM Nambiar, Amritha
> > <amritha.nambiar@intel.com> wrote:
> > >
> > > > -----Original Message-----
> > > > From: Alexander Duyck <alexander.duyck@gmail.com>
> > > > Sent: Friday, September 9, 2022 11:35 AM
> > > > To: Nambiar, Amritha <amritha.nambiar@intel.com>
> > > > Cc: netdev@vger.kernel.org; kuba@kernel.org; jhs@mojatatu.com;
> > > > jiri@resnulli.us; xiyou.wangcong@gmail.com; Gomes, Vinicius
> > > > <vinicius.gomes@intel.com>; Samudrala, Sridhar
> > > > <sridhar.samudrala@intel.com>
> > > > Subject: Re: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
> > > > mapping
> > > >
> > > > On Fri, Sep 9, 2022 at 2:18 AM Nambiar, Amritha
> > > > <amritha.nambiar@intel.com> wrote:
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Alexander Duyck <alexander.duyck@gmail.com>
> > > > > > Sent: Thursday, September 8, 2022 8:28 AM
> > > > > > To: Nambiar, Amritha <amritha.nambiar@intel.com>
> > > > > > Cc: netdev@vger.kernel.org; kuba@kernel.org; jhs@mojatatu.com;
> > > > > > jiri@resnulli.us; xiyou.wangcong@gmail.com; Gomes, Vinicius
> > > > > > <vinicius.gomes@intel.com>; Samudrala, Sridhar
> > > > > > <sridhar.samudrala@intel.com>
> > > > > > Subject: Re: [net-next PATCH v2 0/4] Extend action skbedit to RX
> > queue
> > > > > > mapping
> > > > > >
> > > > > > On Wed, Sep 7, 2022 at 6:14 PM Amritha Nambiar
> > > > > > <amritha.nambiar@intel.com> wrote:
> > > > > > >
> > > > > > > Based on the discussion on
> > > > > > >
> > > > https://lore.kernel.org/netdev/20220429171717.5b0b2a81@kernel.org/,
> > > > > > > the following series extends skbedit tc action to RX queue mapping.
> > > > > > > Currently, skbedit action in tc allows overriding of transmit queue.
> > > > > > > Extending this ability of skedit action supports the selection of
> > receive
> > > > > > > queue for incoming packets. Offloading this action is added for
> > receive
> > > > > > > side. Enabled ice driver to offload this type of filter into the
> > > > > > > hardware for accepting packets to the device's receive queue.
> > > > > > >
> > > > > > > v2: Added documentation in Documentation/networking
> > > > > > >
> > > > > > > ---
> > > > > > >
> > > > > > > Amritha Nambiar (4):
> > > > > > >       act_skbedit: Add support for action skbedit RX queue mapping
> > > > > > >       act_skbedit: Offload skbedit queue mapping for receive queue
> > > > > > >       ice: Enable RX queue selection using skbedit action
> > > > > > >       Documentation: networking: TC queue based filtering
> > > > > >
> > > > > > I don't think skbedit is the right thing to be updating for this. In
> > > > > > the case of Tx we were using it because at the time we stored the
> > > > > > sockets Tx queue in the skb, so it made sense to edit it there if we
> > > > > > wanted to tweak things before it got to the qdisc layer. However it
> > > > > > didn't have a direct impact on the hardware and only really affected
> > > > > > the software routing in the device, which eventually resulted in which
> > > > > > hardware queue and qdisc was selected.
> > > > > >
> > > > > > The problem with editing the receive queue is that the hardware
> > > > > > offloaded case versus the software offloaded can have very different
> > > > > > behaviors. I wonder if this wouldn't be better served by being an
> > > > >
> > > > > Could you please explain how the hardware offload and software cases
> > > > > behave differently in the skbedit case. From Jakub's suggestion on
> > > > >
> > https://lore.kernel.org/netdev/20220503084732.363b89cc@kernel.org/,
> > > > > it looked like the skbedit action fits better to align the hardware and
> > > > > software description of RX queue offload (considering the skb metadata
> > > > > remains same in offload vs no-offload case).
> > > >
> > > > So specifically my concern is RPS. The problem is RPS takes place
> > > > before your TC rule would be applied in the software case, but after
> > > > it has been applied in the hardware case. As a result the behavior
> > > > will be different for one versus the other. With the redirect action
> > > > it will pull the packet out of the Rx pipeline and reinsert it so that
> > > > RPS will be applied to the packet and it would be received on the CPUs
> > > > expected.
> > > >
> > >
> > > Okay, so I understand that without HW offload, the SW behavior would
> > > not align for RPS, i.e., RPS CPU would be from a queue (already selected
> > > by HW, RSS etc.),  and may not align with the queue selected from
> > > the SW TC rule. And I see your point, the solution to this would be
> > > reinserting the packet after updating the queue. But, as I look more into
> > > this, there are still some more concerns I have.
> > >
> > > IIUC, we may be looking at a potential TC rule as below:
> > > tc filter add dev ethX ingress ... \
> > > action mirred ingress redirect dev ethX rxqueue <rx_qid>
> > >
> > > It looks to me that this configuration could possibly result in loops
> > > recursively calling act_mirred. Since the redirection is from ingress
> > > to ingress on the same device, when the packet is reinserted into the
> > > RX pipeline of the same device, RPS and tc classification happens again,
> > > the tc filter with act mirred executes redirecting and reinserting the
> > > packet again. act_mirred keeps a CPU counter of recursive calls for the
> > > action and drops the packet when the limit is reached.
> > > If this is a valid configuration, I cannot find any code that perhaps uses
> > > a combination of skb->redirect and skb->from_ingress to check and
> > > prevent recursive classification (further execution of TC mirred redirect
> > > action).
> >
> > The recursion problem is easily solved by simply not requeueing again
> > if the packet is on the queue it is supposed to be. If you have rules
> > that are bouncing the traffic between two queues it wouldn't be any
> > different than the potential issue of bouncing traffic between two
> > netdevs which is why the recursion counters were added.
> >
>
> Okay, makes sense. So, redirecting (ingress to ingress) on the same
> device with the queue_mapping extension would make it possible to
> update the queue. Without the queue_mapping extension, ingress to
> ingress redirect on the same device would simply bounce the packets and
> eventually drop them once the recursion limit is reached.

Right. Basically this would be an extension for the redirect action
that would move a queue up to a first class citizen of sorts.

> > > Also, since reinserting the packet after updating the queue would fix
> > > the RPS inconsistency, can this be done from the skbedit action instead
> > > of mirred redirect ? So, if skbedit action is used for Rx queue selection,
> > > maybe this sequence helps:
> > >
> > > RPS on RX q1 -> TC action skbedit RX q2 ->
> > > always reinsert if action skbedit is on RX -> RPS on RX q2 ->
> > > stop further execution of TC action RX skbedit
> >
> > That is changing the function of skbedit. In addition the skbedit
> > action isn't meant to be offloaded. The skbedit action is only really
> > supposed to edit skb medatada, it isn't supposed to take other actions
> > on the frame. What we want to avoid is making skbedit into another
> > mirred.
>
> Okay, so skbedit changing the skb metadata and doing the additional
> action here (reinserting the packet) is not right. But in terms of skbedit
> action not meant to be offloaded, I do find that skbedit action allows
> offload of certain parameters like mark, ptype and priority.

I had overlooked the offload use as it isn't exactly a direct use
case. It is needed in the context of offloading a qdisc if I am not
mistaken. So it isn't really the action that is being offloaded but
the queueing discipline itself, the skbedit is more of a passenger
along for the ride. The general idea is that the values would be
consumed by the qdisc layer to take some action, and since the qdisc
is being handled down in the hardware it is now down in the hardware
with it. I'm not thrilled, but I can see the justification as we have
had discussions about renaming the action before since it really just
edits the metadata for the frame.

The big difference is that it is the qdisc taking the action versus
the action directly, and all we are tweaking is the metadata which is
the main task of skbedit which is meant to only edit metadata.
