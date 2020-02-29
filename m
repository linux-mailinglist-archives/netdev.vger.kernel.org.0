Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F571743F4
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 01:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgB2AuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 19:50:20 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42408 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgB2AuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 19:50:19 -0500
Received: by mail-ed1-f65.google.com with SMTP id n18so5485190edw.9
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 16:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fxmv1+Fswn7MWmCWRm/GEvVRMXqVzHdSR8v8tCCxRWY=;
        b=sSEUNIHT38u8ILT3kPcZNveXLcLG2/vaSJmceR9gEy98MUQVPremkwS0n44M1P9UP6
         /6EOcjc9cHhLZ5SiI+jESnWlS5SAvW/ysTWtb1EWQS6PrVhU9U5135aNop9oCbSZWvQB
         qrcEDQh7+fdeSLX/BwFx73/cxMWOn2p6vj2S3jkgFutZKBuLanQu8GrEqWFYN4P3GVTf
         8AmCodbTFm8pbQ2LRSpbAhSm1mMnfkqas7KhaM+A5EIEkO0DExkJz13qSOls6E/WWDPO
         Aby47g6ZqaE8cl832CxMhAsucuSi5rsYoqBYZvyv9ZPIs9Yc4AFqDj2MEySpfrot65cY
         rAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fxmv1+Fswn7MWmCWRm/GEvVRMXqVzHdSR8v8tCCxRWY=;
        b=deKzIeOYvSlZUzBZg7ACal/pA+1Lc7qAqZkCzk/krUU0G0cq0geTFOETAomeuZWvRe
         LQTVS9hXzugaa5/4bxgL1HFWJSyN3f2E+H6FdcsmoxI0iwrXU9AwkY+Koap/n090vWkw
         Qakurr3/b8sCr+NP7IyOhrGigBc61A9lfervMWQaZ3JTt723vI8EVzFPeDkFN0bkHXBG
         EzSmibFLx6srxblXJG26aKWsaQ2eVTACOPLgiP2JR8888GZ4kiMM9MzcNG+gKbOBaY4/
         qJAARVyfqH3RIEYE6NMmFjozjhvEED1t0KedZOVn844Vpx+OWmWe2ByfX7y3tN1rBXzi
         ftOA==
X-Gm-Message-State: APjAAAX+C2LiMP2RlqPZU0Vpeed5YIbpv+gqoZeQJNaptNAnth/7N6ey
        4LpsB1nOB3gZ+FxfGjoUx8vLNeHF2D14/awg4ds=
X-Google-Smtp-Source: APXvYqyhUhTn216F/BcKLyGEScE8O7mub3TJ4FONjTTncvgUGmS9H+X0PCWQENGOVzCt92FiseFiPX4qzA/cA4PT4oM=
X-Received: by 2002:a05:6402:3132:: with SMTP id dd18mr6798429edb.118.1582937417149;
 Fri, 28 Feb 2020 16:50:17 -0800 (PST)
MIME-Version: 1.0
References: <20200228172505.14386-1-jiri@resnulli.us> <20200228172505.14386-3-jiri@resnulli.us>
In-Reply-To: <20200228172505.14386-3-jiri@resnulli.us>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 29 Feb 2020 02:50:06 +0200
Message-ID: <CA+h21hpuBWDZ4WoE70+LB6uS=fUo+DgezqRFw4UT=v56pCXApQ@mail.gmail.com>
Subject: Re: [patch net-next v2 02/12] ocelot_flower: use flow_offload_has_one_action()
 helper
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ido Schimmel <idosch@mellanox.com>, aelior@marvell.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, pablo@netfilter.org,
        Edward Cree <ecree@solarflare.com>, mlxsw@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Feb 2020 at 19:25, Jiri Pirko <jiri@resnulli.us> wrote:
>
> From: Jiri Pirko <jiri@mellanox.com>
>
> Instead of directly checking number of action entries, use
> flow_offload_has_one_action() helper.
>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>

> v1->v2:
> - new patch
> ---
>  drivers/net/ethernet/mscc/ocelot_flower.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
> index 3d65b99b9734..b85111dcc2be 100644
> --- a/drivers/net/ethernet/mscc/ocelot_flower.c
> +++ b/drivers/net/ethernet/mscc/ocelot_flower.c
> @@ -19,7 +19,7 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
>         const struct flow_action_entry *a;
>         int i;
>
> -       if (f->rule->action.num_entries != 1)
> +       if (!flow_offload_has_one_action(&f->rule->action))
>                 return -EOPNOTSUPP;
>
>         flow_action_for_each(i, a, &f->rule->action) {
> --
> 2.21.1
>
