Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD1E68BC0D
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjBFLtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjBFLtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:49:12 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC229526B
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 03:49:11 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id i2so10806371ybt.2
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 03:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R7e4gYcwL6+T1LFN1Gm0FJ5VBlz+wwFu1M/HemB8NdE=;
        b=oIzmUkKAGzDiRj/Ccpvprkxh+SDxOdeMAH4tcHrDLmsAvajslgJkEsc4Q51GChDrJX
         lFxtl5OmYY+iZjNdgkqLh2BCTJ8cdQ7mjL2qCOCM4Ic0Qi4UT+prM+Iz3ZKpup6AyI2c
         ls9nwC8zfoe/4gIbFzbxLc6jhUahvNVNZAtOZMr1/wNKdICZW7yCuXGOiuNMrfg70PXR
         6fL/1TDOo+P+34w8ljdcXQ6TD9Z3XbR3EYGPzh3C2OCFX0Ckl5PlSxAEp1EOH/rqMYrZ
         gKlUC8jhKZ6IZmcZDEHH0zDITrLixy96Qpp9Ba+i2PmCrlurRGQBUqlE/g/b7PJK4uDu
         xjVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R7e4gYcwL6+T1LFN1Gm0FJ5VBlz+wwFu1M/HemB8NdE=;
        b=tIvn+B3R8AUF2IS84QEmY7Dk2mFTbioZnqEhByQoIUrcFoHy8kgF7BTnCHPncp+QCA
         uMs/pnGDRuDQvj6E3uHWH1TOIf2gZg+VsMNZkbKM8nWSOoUcGNQ5pxrJkggYqRJKz0I8
         R3vLCyWhbsjkUB8GIfq+3omEvjBg3agIGkD+CiXjIMYS+OVDaOtcB/Hv93vhjat0LXm9
         SE7B0xPSaiReynP4g3/WMw3e9gDQWPF4NmJPUIhha0UXa48o9C5Km6MqRuMkiOvsHjw7
         4Grrt2GMkm4mJwAHEPU7mXS4eJXAUpuZWwtt7nuCFvzQbtyusF5zcpfwOccpxatIbHmI
         UZLw==
X-Gm-Message-State: AO0yUKVRRL4OI7HlHPIxK/IHRza3TK3Yf4xK4TGsxmMoemRn3CZWqK+x
        dO8Ypo7rXF1Zzp+wr8yuW3eIUApX1I5I6P05PWhkuA==
X-Google-Smtp-Source: AK7set+ouQP2YELPgOB9GfP7NypAFXie+kzAmmsNys2O9wed7lfVJIY3RVV0fBAxnU6ktTgFh42sKDqiX7wnpv7tMIs=
X-Received: by 2002:a5b:c44:0:b0:892:7037:9466 with SMTP id
 d4-20020a5b0c44000000b0089270379466mr489135ybr.188.1675684151093; Mon, 06 Feb
 2023 03:49:11 -0800 (PST)
MIME-Version: 1.0
References: <20230205135525.27760-1-ozsh@nvidia.com> <20230205135525.27760-3-ozsh@nvidia.com>
 <Y+DbNFogMZWPPhNB@corigine.com>
In-Reply-To: <Y+DbNFogMZWPPhNB@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 6 Feb 2023 06:48:59 -0500
Message-ID: <CAM0EoM=OMfEP=qHjcNQFOKvr=gxoVd-2X8fCWhqoCf6CFsYhuw@mail.gmail.com>
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

Does it have to be?

cheers,
jamal

On Mon, Feb 6, 2023 at 5:49 AM Simon Horman <simon.horman@corigine.com> wrote:
>
> On Sun, Feb 05, 2023 at 03:55:18PM +0200, Oz Shlomo wrote:
> > A single tc pedit action may be translated to multiple flow_offload
> > actions.
> > Offload only actions that translate to a single pedit command value.
> >
> > Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> >
> > ---
> > Change log:
> >
> > V1 -> V2:
> >     - Add extack message on error
> >     - Assign the flow action id outside the for loop.
> >       Ensure the rest of the pedit actions follow the assigned id.
> > ---
> >  net/sched/act_pedit.c | 28 +++++++++++++++++++++++++++-
> >  1 file changed, 27 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> > index c42fcc47dd6d..dae88e205cb1 100644
> > --- a/net/sched/act_pedit.c
> > +++ b/net/sched/act_pedit.c
> > @@ -545,7 +545,33 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
> >               }
> >               *index_inc = k;
> >       } else {
> > -             return -EOPNOTSUPP;
> > +             struct flow_offload_action *fl_action = entry_data;
> > +             u32 cmd = tcf_pedit_cmd(act, 0);
> > +             u32 last_cmd;
> > +             int k;
> > +
> > +             switch (cmd) {
> > +             case TCA_PEDIT_KEY_EX_CMD_SET:
> > +                     fl_action->id = FLOW_ACTION_MANGLE;
> > +                     break;
> > +             case TCA_PEDIT_KEY_EX_CMD_ADD:
> > +                     fl_action->id = FLOW_ACTION_ADD;
> > +                     break;
> > +             default:
> > +                     NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
> > +                     return -EOPNOTSUPP;
> > +             }
> > +
> > +             for (k = 1; k < tcf_pedit_nkeys(act); k++) {
> > +                     cmd = tcf_pedit_cmd(act, k);
> > +
> > +                     if (cmd != last_cmd) {
>
> Hi Oz,
>
> Is last_cmd initialised for the first iteration of this loop?
>
> > +                             NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
> > +                             return -EOPNOTSUPP;
> > +                     }
> > +
> > +                     last_cmd = cmd;
> > +             }
> >       }
> >
> >       return 0;
> > --
> > 1.8.3.1
> >
