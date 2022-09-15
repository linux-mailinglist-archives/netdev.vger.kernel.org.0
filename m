Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6165B9EA9
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 17:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiIOPXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 11:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiIOPW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 11:22:57 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BC495E49
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:21:37 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id w20so6608275ply.12
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=mWjJSxELc2zFZU/tvKbzSM2AZvmaSOTOw3fBcdMzdk4=;
        b=R/xnwH3T8/eWccA2lGX8viXg3ljpdTfDxVl0+BcxUNdLm4PPO8XJqYBahuFyXhPbh8
         pFeNUpbq5w2PJw8cSyZmMPYNQIpQrb4h12WWOTSlxuAV5urxl6KKfzH9RVKU4fALajhD
         zB+ozIyp+q/d3tTM6SJpLSK7MIWTsfs3gqAw3REBuS7HU253U3py/kqFqImv1dfF3efV
         tAQfDmSlr/X87uBMyOxOF36YTwCatFPNsojJGrUU/tFhf78oa72kBnDE1xijqLZkkf2c
         qyOsOdEJ1ALrI2DSLVdkHNEw9f2KrZlxSUX4rmg/7zsQXSpmAFukisqslzulUaMIJrNw
         +D1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=mWjJSxELc2zFZU/tvKbzSM2AZvmaSOTOw3fBcdMzdk4=;
        b=pBvueoYwcZzzmK1WRm/hStU7rejhDcvK66Q5H9+isVVPaYP6x/xmE/FY4JEGHnbu0A
         VRSfm/zh2KSX/q6ECOfhlT0aERH97XV8UsO6ublGpdtiX/OK5ZfXqR4f/x0dqnB8mcEQ
         DxitbR+FqZ9M1WnvqtVSTeVMy4DtYJskZie85ZBPfP432vMNvd0Fvs+wVoXoIJrJEM2V
         1H1EUcHFW29iF/4OKI/FMxp5tDiLdUTp2RKMVxgYI47gC4eOtSBIc853vLjnsFk27dWr
         FuuXB3EslSE27SV6/c1UcIQFbDJV1Y6anxt9NcJKZYEYilQLwvs1ihkx19xv4QITG7K6
         yRkg==
X-Gm-Message-State: ACrzQf0JX5wxym30DvhQRi0Cpo9+JdceClrls1odfw7bKyQKNvB0Uh0M
        ZenvTyQt0a3iJLq9PkHnu/W3cYOnrO1C5b4H2cU=
X-Google-Smtp-Source: AMsMyM7k6oyhbdR9I6b1vKBLIuNu1LqfNVlws26tZ7wDFE+wdmSFpvVcNml5mv2vq0Q7u3gmQIrtAjjvp2YSdk4SIB4=
X-Received: by 2002:a17:90b:1b0e:b0:202:c913:221f with SMTP id
 nu14-20020a17090b1b0e00b00202c913221fmr11316599pjb.211.1663255297199; Thu, 15
 Sep 2022 08:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
 <CAKgT0UcCrEAfiEi-EVkXAmZxdyD910yr2v54iYe3nzQdaX+6ng@mail.gmail.com>
 <MWHPR11MB12939CF44A137DD8349B1EB5F1439@MWHPR11MB1293.namprd11.prod.outlook.com>
 <CAKgT0UcierZArEiDZ2-8S8_gr2nwUZ3+3fJEAspGnbm13E_2Vw@mail.gmail.com> <MWHPR11MB1293428E17B99FBD3CBF4A87F1499@MWHPR11MB1293.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB1293428E17B99FBD3CBF4A87F1499@MWHPR11MB1293.namprd11.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 15 Sep 2022 08:21:25 -0700
Message-ID: <CAKgT0UdDk9em9h3MYDX=jzh7Bm9KWkTYx4raE=QuiszDoxf4Xw@mail.gmail.com>
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

On Thu, Sep 15, 2022 at 1:45 AM Nambiar, Amritha
<amritha.nambiar@intel.com> wrote:
>
> > -----Original Message-----
> > From: Alexander Duyck <alexander.duyck@gmail.com>
> > Sent: Friday, September 9, 2022 11:35 AM
> > To: Nambiar, Amritha <amritha.nambiar@intel.com>
> > Cc: netdev@vger.kernel.org; kuba@kernel.org; jhs@mojatatu.com;
> > jiri@resnulli.us; xiyou.wangcong@gmail.com; Gomes, Vinicius
> > <vinicius.gomes@intel.com>; Samudrala, Sridhar
> > <sridhar.samudrala@intel.com>
> > Subject: Re: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
> > mapping
> >
> > On Fri, Sep 9, 2022 at 2:18 AM Nambiar, Amritha
> > <amritha.nambiar@intel.com> wrote:
> > >
> > > > -----Original Message-----
> > > > From: Alexander Duyck <alexander.duyck@gmail.com>
> > > > Sent: Thursday, September 8, 2022 8:28 AM
> > > > To: Nambiar, Amritha <amritha.nambiar@intel.com>
> > > > Cc: netdev@vger.kernel.org; kuba@kernel.org; jhs@mojatatu.com;
> > > > jiri@resnulli.us; xiyou.wangcong@gmail.com; Gomes, Vinicius
> > > > <vinicius.gomes@intel.com>; Samudrala, Sridhar
> > > > <sridhar.samudrala@intel.com>
> > > > Subject: Re: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
> > > > mapping
> > > >
> > > > On Wed, Sep 7, 2022 at 6:14 PM Amritha Nambiar
> > > > <amritha.nambiar@intel.com> wrote:
> > > > >
> > > > > Based on the discussion on
> > > > >
> > https://lore.kernel.org/netdev/20220429171717.5b0b2a81@kernel.org/,
> > > > > the following series extends skbedit tc action to RX queue mapping.
> > > > > Currently, skbedit action in tc allows overriding of transmit queue.
> > > > > Extending this ability of skedit action supports the selection of receive
> > > > > queue for incoming packets. Offloading this action is added for receive
> > > > > side. Enabled ice driver to offload this type of filter into the
> > > > > hardware for accepting packets to the device's receive queue.
> > > > >
> > > > > v2: Added documentation in Documentation/networking
> > > > >
> > > > > ---
> > > > >
> > > > > Amritha Nambiar (4):
> > > > >       act_skbedit: Add support for action skbedit RX queue mapping
> > > > >       act_skbedit: Offload skbedit queue mapping for receive queue
> > > > >       ice: Enable RX queue selection using skbedit action
> > > > >       Documentation: networking: TC queue based filtering
> > > >
> > > > I don't think skbedit is the right thing to be updating for this. In
> > > > the case of Tx we were using it because at the time we stored the
> > > > sockets Tx queue in the skb, so it made sense to edit it there if we
> > > > wanted to tweak things before it got to the qdisc layer. However it
> > > > didn't have a direct impact on the hardware and only really affected
> > > > the software routing in the device, which eventually resulted in which
> > > > hardware queue and qdisc was selected.
> > > >
> > > > The problem with editing the receive queue is that the hardware
> > > > offloaded case versus the software offloaded can have very different
> > > > behaviors. I wonder if this wouldn't be better served by being an
> > >
> > > Could you please explain how the hardware offload and software cases
> > > behave differently in the skbedit case. From Jakub's suggestion on
> > > https://lore.kernel.org/netdev/20220503084732.363b89cc@kernel.org/,
> > > it looked like the skbedit action fits better to align the hardware and
> > > software description of RX queue offload (considering the skb metadata
> > > remains same in offload vs no-offload case).
> >
> > So specifically my concern is RPS. The problem is RPS takes place
> > before your TC rule would be applied in the software case, but after
> > it has been applied in the hardware case. As a result the behavior
> > will be different for one versus the other. With the redirect action
> > it will pull the packet out of the Rx pipeline and reinsert it so that
> > RPS will be applied to the packet and it would be received on the CPUs
> > expected.
> >
>
> Okay, so I understand that without HW offload, the SW behavior would
> not align for RPS, i.e., RPS CPU would be from a queue (already selected
> by HW, RSS etc.),  and may not align with the queue selected from
> the SW TC rule. And I see your point, the solution to this would be
> reinserting the packet after updating the queue. But, as I look more into
> this, there are still some more concerns I have.
>
> IIUC, we may be looking at a potential TC rule as below:
> tc filter add dev ethX ingress ... \
> action mirred ingress redirect dev ethX rxqueue <rx_qid>
>
> It looks to me that this configuration could possibly result in loops
> recursively calling act_mirred. Since the redirection is from ingress
> to ingress on the same device, when the packet is reinserted into the
> RX pipeline of the same device, RPS and tc classification happens again,
> the tc filter with act mirred executes redirecting and reinserting the
> packet again. act_mirred keeps a CPU counter of recursive calls for the
> action and drops the packet when the limit is reached.
> If this is a valid configuration, I cannot find any code that perhaps uses
> a combination of skb->redirect and skb->from_ingress to check and
> prevent recursive classification (further execution of TC mirred redirect
> action).

The recursion problem is easily solved by simply not requeueing again
if the packet is on the queue it is supposed to be. If you have rules
that are bouncing the traffic between two queues it wouldn't be any
different than the potential issue of bouncing traffic between two
netdevs which is why the recursion counters were added.

> Also, since reinserting the packet after updating the queue would fix
> the RPS inconsistency, can this be done from the skbedit action instead
> of mirred redirect ? So, if skbedit action is used for Rx queue selection,
> maybe this sequence helps:
>
> RPS on RX q1 -> TC action skbedit RX q2 ->
> always reinsert if action skbedit is on RX -> RPS on RX q2 ->
> stop further execution of TC action RX skbedit

That is changing the function of skbedit. In addition the skbedit
action isn't meant to be offloaded. The skbedit action is only really
supposed to edit skb medatada, it isn't supposed to take other actions
on the frame. What we want to avoid is making skbedit into another
mirred.
