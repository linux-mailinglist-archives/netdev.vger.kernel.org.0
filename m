Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBCB14C98A
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 12:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgA2LYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 06:24:43 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43311 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgA2LYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 06:24:43 -0500
Received: by mail-ed1-f66.google.com with SMTP id dc19so18189351edb.10
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 03:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ULyE+yu8xzJ+9G2Q/3EWNFmSgwtokQLYCUEMq84Y8t0=;
        b=JKq/hOu5F8mofwSObBE0zVqOcCTR7+7XpyYlhz/EsQx1V194wfeeBRuNZPlgpMGaNF
         PYC6w1GAFAdUeJVPVhEA5j5zR7FHwAOzeYR3xWbUVxx+lerSVrUT3WTzTZ9UjOs3uynu
         Vx4CXP/HaHWkCurvvd40tO9HMufNQr5C5Q+fClQWywxekHiilscCfEJq5TA4e7zxUxaM
         jnD1COaVaPUVK4aCCUQiOTRKBYWZnS9HwYRYcAroWbnT2yy8ti9zQRhQ2rzOOUpNRdAK
         YhaseSuU+OSSKgxwRfxc0EAvYsT5zbWYRPj2ahPcfAUKPnDvgVJPFB2aaxg6jVM6GXYO
         Xccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ULyE+yu8xzJ+9G2Q/3EWNFmSgwtokQLYCUEMq84Y8t0=;
        b=KREIzVCLhOsttKqnFt/JMdfj6CFrW4VGITkoBd8jJDHkcxKh4b0HkUmESkIwarVGud
         XeAWhurkAm5dLGBWKOp+stl8vSTZFdKzIi4wBhMzTEUBBGQDxKJ0p96ysvV65nxFdT7c
         AaDfn99ZZkbkzqxPPO0n8Rtxj8WpGjxX8kpLrvvAQb0hsWzPJBuXviL9Kehg43ygZu3g
         DAWgwY5aek38RsuQXlomGaYcxpPjARu7T5bS5WX/vZFzdLLBmR+sL7OGMF83veEFbFTX
         VFNZMmQ4RPqCdJg15f0/iCC1X4SFWtwHHZxQAwhd4tGQpe1zCORLQo9rMO5u3Bb8se4V
         oRWg==
X-Gm-Message-State: APjAAAUeN9SfuneZdHzXVPoHQeJXaZckLrziMonxk0ZIASMt6kem4SCG
        2Fcl1uo5zJ1/XfhkHVWCK5Iihtt/22l4BakZ3L0=
X-Google-Smtp-Source: APXvYqyOPuuYFIG0/CUcs/yLaYLaYtw9FrO2DF4xLBk5flbpWkRxiXkcYBauXeDxWYd3UTqBkETJNXeHk6aXbI4Z6Ws=
X-Received: by 2002:a05:6402:19b2:: with SMTP id o18mr7504748edz.368.1580297081806;
 Wed, 29 Jan 2020 03:24:41 -0800 (PST)
MIME-Version: 1.0
References: <20200128235227.3942256-1-vinicius.gomes@intel.com>
 <20200128235227.3942256-3-vinicius.gomes@intel.com> <20200129.111245.1611718557356636170.davem@davemloft.net>
In-Reply-To: <20200129.111245.1611718557356636170.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 29 Jan 2020 13:24:30 +0200
Message-ID: <CA+h21hoDDULPuhkEDCby0RBs+3r0angFVvyvazvedRTdWX_UYQ@mail.gmail.com>
Subject: Re: [PATCH net v2 2/3] taprio: Allow users not to specify "flags"
 when changing schedules
To:     David Miller <davem@davemloft.net>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, 29 Jan 2020 at 12:14, David Miller <davem@davemloft.net> wrote:
>
> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Date: Tue, 28 Jan 2020 15:52:26 -0800
>
> > When any offload mode is enabled, users had to specify the
> > "flags" parameter when adding a new "admin" schedule.
> >
> > This fix allows that parameter to be omitted when adding a new
> > schedule.
> >
> > This will make that we have one source of truth for 'flags'.
> >
> > Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
> > Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> > Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> This will visibly change behavior for a feature in a released
> kernel (v5.3 and later) and it means that newer tools will do
> things that don't work in older kernels.
>
> I think your opportunity to adjust these semantics, has therefore,
> long passed.
>
> Sorry.

This is where the kernel-userspace policy escapes me a little bit.
How is this different from having a bug that would cause the "flags"
field to e.g. be ignored? Would the kernel policy make it impossible
for that bug to be fixed?
At some point, the 5.3 kernel will go EOL. When would be a good time
to make the "flags" optional on "tc qdisc replace", without concerns
about different behavior across versions?

Regards,
-Vladimir
