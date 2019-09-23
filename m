Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13A86BB193
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 11:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392221AbfIWJnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 05:43:02 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44247 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387666AbfIWJnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 05:43:02 -0400
Received: by mail-io1-f66.google.com with SMTP id j4so31740248iog.11
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 02:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rBryJp5wOkHZTqAucRvKJjub57kC1uuRec2f+TsNXZA=;
        b=Pf0PNUYXIq07cOq8PzMH1MgocBjNK76uI4dB+7L2aw01NeRgmGhgPlfznbQUrhicy+
         XRpfY+6JWs7BWFgN2A0oWBWz7qkZCFfzLSlVPVWw9eRuo18AnbyUnII7zIA72qXjlOj0
         ObjfuJTl3nBpvSO1GsbjXjAj5YgLabxB+SerEhRsezzeI9nIW3mLYIG3o0NBHNXX5rwt
         Eix96NH2aOaSW+lZqQji1JH/GzAvmQbnjpp21sJVzU5IqmaFxI6j2tXwgX+2a9xte/bE
         aVtqSedZG0tbQnDE/PhV4jTXArHbt3hxjETeG0y5zE2mVrFbx9cU8Gbbnq2MkQmVPbHi
         /RBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rBryJp5wOkHZTqAucRvKJjub57kC1uuRec2f+TsNXZA=;
        b=to3tdENr9hOnw0nBdUvw3x+mbM42pNSKTuq7dZFqJQlcduCODomS6Gw4b3sDctU1sv
         tfgzCds/jLQ+9rsIDBtdT8V3oV3frO0nZ4OE4hn7NKW/QAbRWP41YCR/yquXps+Nyp6A
         Rz07i9gkgXKYyO9Nx1wA+TZWw2t4vhz2OUxRPhQDnbfFCQ34q1g57ALgnSIb7KMxeBXp
         KUgRhsHzEqNcSc0BXGOZaFRYUB9Yvzq4oBeKBoE1Gc24/M/nnmT8toseVwr70TX04eQK
         C9dKCjDLGDzFf0s7Hik5sBiFX4FT1Zr7/p11vUJxr0Ikiyk83Xi55GbtbIyfjcckBOsA
         mTTw==
X-Gm-Message-State: APjAAAWAXRNo33+MJLjE2yqBc+rc/Z3kxgRVL4gy9Ipvi+WT8dS8I8q2
        zVc446iSwSVmPu5E8yyfYXOXIrXCSo1q5LO1plILMg==
X-Google-Smtp-Source: APXvYqxfI2d3ASqYmB+TDGQMQDg4HkPD9eQT/vS4woTY29QcY7jZ70NGeEz3O+r+kBV08CcCgCtjYgSqK+/b4S4+vho=
X-Received: by 2002:a5e:8c15:: with SMTP id n21mr21360843ioj.246.1569231781397;
 Mon, 23 Sep 2019 02:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <1568882232-12847-1-git-send-email-wenxu@ucloud.cn>
 <CAJ3xEMhQTr=HPsMs-j3_V6XRKHa0Jo7iYVY+R4U8etoEu9R7jw@mail.gmail.com> <cc63e5ba-661a-72c3-7531-7bd09694549b@ucloud.cn>
In-Reply-To: <cc63e5ba-661a-72c3-7531-7bd09694549b@ucloud.cn>
From:   John Hurley <john.hurley@netronome.com>
Date:   Mon, 23 Sep 2019 10:42:50 +0100
Message-ID: <CAK+XE=kJXoWBO=4A2g9p0VTp7p-iN4Eb-FB+Y9Bdr0vJ_NwiYQ@mail.gmail.com>
Subject: Re: [PATCH net v3] net/sched: cls_api: Fix nooffloaddevcnt counter
 when indr block call success
To:     wenxu <wenxu@ucloud.cn>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 5:20 AM wenxu <wenxu@ucloud.cn> wrote:
>
> Hi John & Jakub
>
> There are some limitations for indirect tc callback work with  skip_sw ?
>

Hi Wenxu,
This is not really a limitation.
As Or points out, indirect block offload is not supposed to work with skip_sw.
Indirect offload allows us to hook onto existing kernel devices (for
TC events we may which to offload) that are out of the control of the
offload driver and, therefore, should always accept software path
rules.
For example, the vxlan driver does not implement a setup_tc ndo so it
does not expect to run rules in hw - it should always handle
associated rules in the software datapath as a minimum.
I think accepting skip_sw rules for devices with no in-built concept
of hardware offload would be wrong.
Do you have a use case that requires skip_sw rules for such devices?

John


>
> BR
>
> wenxu
>
> On 9/19/2019 8:50 PM, Or Gerlitz wrote:
> >
> >> successfully bind with a real hw through indr block call, It also add
> >> nooffloadcnt counter. This counter will lead the rule add failed in
> >> fl_hw_replace_filter-->tc_setup_cb_call with skip_sw flags.
> > wait.. indirect tc callbacks are typically used to do hw offloading
> > for decap rules (tunnel key unset action) set on SW devices (gretap, vxlan).
> >
> > However, AFAIK, it's been couple of years since the kernel doesn't support
> > skip_sw for such rules. Did we enable it again? when? I am somehow
> > far from the details, so copied some folks..
> >
> > Or.
> >
> >
> >> In the tc_setup_cb_call will check the nooffloaddevcnt and skip_sw flags
> >> as following:
> >> if (block->nooffloaddevcnt && err_stop)
> >>         return -EOPNOTSUPP;
> >>
> >> So with this patch, if the indr block call success, it will not modify
> >> the nooffloaddevcnt counter.
> >>
> >> Fixes: 7f76fa36754b ("net: sched: register callbacks for indirect tc block binds")
> >> Signed-off-by: wenxu <wenxu@ucloud.cn>
> >> ---
> >> v3: rebase to the net
> >>
> >>  net/sched/cls_api.c | 30 +++++++++++++++++-------------
> >>  1 file changed, 17 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> >> index 32577c2..c980127 100644
> >> --- a/net/sched/cls_api.c
> >> +++ b/net/sched/cls_api.c
> >> @@ -607,11 +607,11 @@ static void tc_indr_block_get_and_ing_cmd(struct net_device *dev,
> >>         tc_indr_block_ing_cmd(dev, block, cb, cb_priv, command);
> >>  }
> >>
> >> -static void tc_indr_block_call(struct tcf_block *block,
> >> -                              struct net_device *dev,
> >> -                              struct tcf_block_ext_info *ei,
> >> -                              enum flow_block_command command,
> >> -                              struct netlink_ext_ack *extack)
> >> +static int tc_indr_block_call(struct tcf_block *block,
> >> +                             struct net_device *dev,
> >> +                             struct tcf_block_ext_info *ei,
> >> +                             enum flow_block_command command,
> >> +                             struct netlink_ext_ack *extack)
> >>  {
> >>         struct flow_block_offload bo = {
> >>                 .command        = command,
> >> @@ -621,10 +621,15 @@ static void tc_indr_block_call(struct tcf_block *block,
> >>                 .block_shared   = tcf_block_shared(block),
> >>                 .extack         = extack,
> >>         };
> >> +
> >>         INIT_LIST_HEAD(&bo.cb_list);
> >>
> >>         flow_indr_block_call(dev, &bo, command);
> >> -       tcf_block_setup(block, &bo);
> >> +
> >> +       if (list_empty(&bo.cb_list))
> >> +               return -EOPNOTSUPP;
> >> +
> >> +       return tcf_block_setup(block, &bo);
> >>  }
> >>
> >>  static bool tcf_block_offload_in_use(struct tcf_block *block)
> >> @@ -681,8 +686,6 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
> >>                 goto no_offload_dev_inc;
> >>         if (err)
> >>                 goto err_unlock;
> >> -
> >> -       tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
> >>         up_write(&block->cb_lock);
> >>         return 0;
> >>
> >> @@ -691,9 +694,10 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
> >>                 err = -EOPNOTSUPP;
> >>                 goto err_unlock;
> >>         }
> >> +       err = tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
> >> +       if (err)
> >> +               block->nooffloaddevcnt++;
> >>         err = 0;
> >> -       block->nooffloaddevcnt++;
> >> -       tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
> >>  err_unlock:
> >>         up_write(&block->cb_lock);
> >>         return err;
> >> @@ -706,8 +710,6 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
> >>         int err;
> >>
> >>         down_write(&block->cb_lock);
> >> -       tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
> >> -
> >>         if (!dev->netdev_ops->ndo_setup_tc)
> >>                 goto no_offload_dev_dec;
> >>         err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
> >> @@ -717,7 +719,9 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
> >>         return;
> >>
> >>  no_offload_dev_dec:
> >> -       WARN_ON(block->nooffloaddevcnt-- == 0);
> >> +       err = tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
> >> +       if (err)
> >> +               WARN_ON(block->nooffloaddevcnt-- == 0);
> >>         up_write(&block->cb_lock);
> >>  }
> >>
> >> --
> >> 1.8.3.1
> >>
