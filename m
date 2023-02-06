Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083AB68BC0E
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjBFLt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjBFLtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:49:55 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300C718B3C
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 03:49:53 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-50aa54cc7c0so151765637b3.8
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 03:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JFC05RHyCIj/pG31ctaBnMlGxOtv1UfC03a25YpaYH4=;
        b=EskqRuXsHiySDcp25nQ4aFCDPksxl5qJLmfQnkI1uKMhX4/8KcFZHifObIlBsLnj06
         Cm81fgip2I6mskaxNH/oUYCGFd8NrIxHUXtL8HcUW/MmGKFNHmFsWDOYjm3uSdU/GzPH
         lwtopJvFNs6ij2VvqYOqRKeTV+0zN4UQysXbOF8lD9Pc4hBM2etv+qd8RKYKQGY+j538
         2vgdkN0D5Tmh3pgbnQmVJcoc0ZQDjuAPN/my47sBQLTyoI1bpKc+H27Ie87x8E5yOHIE
         iKpEt0c6DjDbXKtCuU4U/Nz5txlclJGI6xzrzCUvTgdMqMm/RGthr6KiNvBa81An4Xzf
         ghnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JFC05RHyCIj/pG31ctaBnMlGxOtv1UfC03a25YpaYH4=;
        b=RSSOenk8L0NbqP/0MnekXtsl90/47nJt0+3f1sRTroN3msdCjiRqY85LNzx4YlVofU
         uy6rDBoCszqbf/azXMLn55QyfJDGpWfVZmEWK/RjyPxY1g6WpMX8IGmxe/jh/i2FqsQb
         74t43SO0hr7QF0B76Wmzs08R3flI2Lax1z62BefX8IENEgJ2FHxrftRi2IcJwI7ZDghI
         K/doK/5hOSOEBRkSueZQWzn5FfT1hBBwk96C5Ubw/HFes66re2+cE1yJloKywqkxYH+/
         ITeTGi/uLChH3brK/K9HvxSeOFZzVxCCLAMW4rXdHxnnUBuqqYgGP5H8zo2Orud5rwAW
         57Iw==
X-Gm-Message-State: AO0yUKVUI0/E9pbDfG174p4qfe9BWsxZljMYnLn9foyu6/ShAt52myET
        VXkIsjyDYLFRAlt/9xudutHb+9ZCmm2y2jN7BJosOpBEtOlEug==
X-Google-Smtp-Source: AK7set81XRsvxfz7haLngofyh8lTUaDXv+l9TCPz5cR1nYsg7fc2hczuHBwPlQjHHN35BqpJFumMGohKNY+Fy78lTrI=
X-Received: by 2002:a0d:fdc5:0:b0:518:bcce:30b2 with SMTP id
 n188-20020a0dfdc5000000b00518bcce30b2mr2303511ywf.457.1675684192410; Mon, 06
 Feb 2023 03:49:52 -0800 (PST)
MIME-Version: 1.0
References: <20230205135525.27760-1-ozsh@nvidia.com> <20230205135525.27760-3-ozsh@nvidia.com>
 <Y+DbNFogMZWPPhNB@corigine.com> <CAM0EoM=OMfEP=qHjcNQFOKvr=gxoVd-2X8fCWhqoCf6CFsYhuw@mail.gmail.com>
In-Reply-To: <CAM0EoM=OMfEP=qHjcNQFOKvr=gxoVd-2X8fCWhqoCf6CFsYhuw@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 6 Feb 2023 06:49:41 -0500
Message-ID: <CAM0EoMk-uFE+vi-mNV5n=2qKuVxTTete+us_jCqQBUeKTyCYWg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/9] net/sched: act_pedit, setup offload
 action for action stats query
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Oz Shlomo <ozsh@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Never mind - of course it does ;->

cheers,
jamal

On Mon, Feb 6, 2023 at 6:48 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> Does it have to be?
>
> cheers,
> jamal
>
> On Mon, Feb 6, 2023 at 5:49 AM Simon Horman <simon.horman@corigine.com> wrote:
> >
> > On Sun, Feb 05, 2023 at 03:55:18PM +0200, Oz Shlomo wrote:
> > > A single tc pedit action may be translated to multiple flow_offload
> > > actions.
> > > Offload only actions that translate to a single pedit command value.
> > >
> > > Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> > >
> > > ---
> > > Change log:
> > >
> > > V1 -> V2:
> > >     - Add extack message on error
> > >     - Assign the flow action id outside the for loop.
> > >       Ensure the rest of the pedit actions follow the assigned id.
> > > ---
> > >  net/sched/act_pedit.c | 28 +++++++++++++++++++++++++++-
> > >  1 file changed, 27 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> > > index c42fcc47dd6d..dae88e205cb1 100644
> > > --- a/net/sched/act_pedit.c
> > > +++ b/net/sched/act_pedit.c
> > > @@ -545,7 +545,33 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
> > >               }
> > >               *index_inc = k;
> > >       } else {
> > > -             return -EOPNOTSUPP;
> > > +             struct flow_offload_action *fl_action = entry_data;
> > > +             u32 cmd = tcf_pedit_cmd(act, 0);
> > > +             u32 last_cmd;
> > > +             int k;
> > > +
> > > +             switch (cmd) {
> > > +             case TCA_PEDIT_KEY_EX_CMD_SET:
> > > +                     fl_action->id = FLOW_ACTION_MANGLE;
> > > +                     break;
> > > +             case TCA_PEDIT_KEY_EX_CMD_ADD:
> > > +                     fl_action->id = FLOW_ACTION_ADD;
> > > +                     break;
> > > +             default:
> > > +                     NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
> > > +                     return -EOPNOTSUPP;
> > > +             }
> > > +
> > > +             for (k = 1; k < tcf_pedit_nkeys(act); k++) {
> > > +                     cmd = tcf_pedit_cmd(act, k);
> > > +
> > > +                     if (cmd != last_cmd) {
> >
> > Hi Oz,
> >
> > Is last_cmd initialised for the first iteration of this loop?
> >
> > > +                             NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
> > > +                             return -EOPNOTSUPP;
> > > +                     }
> > > +
> > > +                     last_cmd = cmd;
> > > +             }
> > >       }
> > >
> > >       return 0;
> > > --
> > > 1.8.3.1
> > >
