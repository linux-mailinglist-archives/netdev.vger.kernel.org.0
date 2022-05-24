Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA565326AC
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 11:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiEXJis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 05:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiEXJip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 05:38:45 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F9464BF1
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 02:38:40 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id w10so15157837vsa.4
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 02:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c/ymE3c83/iDKxnuQ2U9161xSUAzpoxHCgtmLHfG7rk=;
        b=nqT9duA542+hQaTN6QFniknNvK08xM8sXUqwvnsfX0gv2f5I1Z/qI0uDBiVP1+An/q
         HtaWOvqghgbPdrlumoppL6H0YRre/PtwWk24rq7FGvbwvu06rrwpcN/xPtBWpSU0Q8k+
         dsOUEGicRqsC6jGOOdJkXM4FMlN0PFbuhPeevyu2wRpVn8ydyhCX8qG7BKeuneTgrUGW
         TsPgh/imMetkwGBRFU+BNJIgh3/p3ltgSs4lGdsyqldDyaPUgpRVWtrPERZpnmTSYCew
         nwAy/w9ffCI8uGnww6t43SmIXQbI35tSuYHzQFRRKFP8Vppl0SgYSEfesjLVTNM+F017
         hz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c/ymE3c83/iDKxnuQ2U9161xSUAzpoxHCgtmLHfG7rk=;
        b=yxk6ZPGR4hhEr/pJuvyvjrjceAJgHTgWhbq0XiA2EnU/tKah3HRgRvzpp5db6wf4s5
         Mr7FV/0r+6BEGsI6WlAq1pPqgrfvZ3jSGaYYkvJxKPTtiCs01TM1CKii5lgtMf0uvI55
         amNbVwGXrwtJETdzCqFIykt/mRh3j5LQNorwhLg5ziCZRBy3uOe+bOu+z+CYWSlq4Hfh
         J1KqyXbcVCb/M4vKMITAMI4cNwKzUzyOHK616uBXEXhNs4QDbFKPCVCAK5SbdWNIPj4P
         4wX+dX71r6OBuTkPSmI+kjxx74XAV539aC7hLiZ1xd91nqnJUHJ+paRt+6sng0h0AaTP
         kwgg==
X-Gm-Message-State: AOAM533FoGRfSpGa2FioOcpLF0bGW6sLr+VyIH5Gx/CMtY9c5PzlhY9H
        LGA5dTt8dl/FrWK3qUu2ZaBBzSqG4DBRX0TLOvk=
X-Google-Smtp-Source: ABdhPJwQRn8sSjRDQd/yjl8F2Cbfa/BZRtj0C8cA6bp/Ghp++RdFPQhU5rrbjvQ+32Foib2D5I9Tr8RjuB4W/1NpEic=
X-Received: by 2002:a67:bb1a:0:b0:337:cb55:7733 with SMTP id
 m26-20020a67bb1a000000b00337cb557733mr2340765vsn.19.1653385119912; Tue, 24
 May 2022 02:38:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220522031739.87399-1-wangyuweihx@gmail.com> <b5cf7fac361752d925f663d9a9b0b8415084f7d3.camel@redhat.com>
In-Reply-To: <b5cf7fac361752d925f663d9a9b0b8415084f7d3.camel@redhat.com>
From:   Yuwei Wang <wangyuweihx@gmail.com>
Date:   Tue, 24 May 2022 17:38:28 +0800
Message-ID: <CANmJ_FP0CxSVksjvNsNjpQO8w+S3_10byQSCpt1ifQ6HeURUmA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net, neigh: introduce interval_probe_time for
 periodic probe
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, daniel@iogearbox.net,
        roopa@nvidia.com, dsahern@kernel.org,
        =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org
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

On Tue, 24 May 2022 at 16:38, Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Sun, 2022-05-22 at 03:17 +0000, Yuwei Wang wrote:
> > commit 7482e3841d52 ("net, neigh: Add NTF_MANAGED flag for managed neighbor entries")
> > neighbor entries which with NTF_EXT_MANAGED flags will periodically call neigh_event_send()
> > for performing the resolution. and the interval was set to DELAY_PROBE_TIME
> >
> > DELAY_PROBE_TIME was configured as the first probe time delay, and it makes sense to set it to `0`.
> >
> > when DELAY_PROBE_TIME is `0`, the queue_delayed_work of neighbor entries with NTF_EXT_MANAGED will
> > be called recursively with no interval, and then threads of `system_power_efficient_wq` will consume 100% cpu.
> >
> > as commit messages mentioned in the above commit, we should introduce a new option which means resolution interval.
> >
> > Signed-off-by: Yuwei Wang <wangyuweihx@gmail.com>
> > ---
> > v2:
> > - move `NDTPA_INTERVAL_PROBE_TIME` to the tail of uAPI enum
> > - add `NDTPA_INTERVAL_PROBE_TIME` to `nl_ntbl_parm_policy`
> > - add detail explain for the behevior when `DELAY_PROBE_TIME` is `0` in
> >   commit messaage
> >
> > meanwhile, we should replace `DELAY_PROBE_TIME` with `INTERVAL_PROBE_TIME`
> > in `drivers/net/ethernet/mellanox` after this patch was merged
> >
> > and should we remove `include/uapi/linux/sysctl.h` seems it is no
> > longer be used.
> >
> >  include/net/neighbour.h        |  3 ++-
> >  include/net/netevent.h         |  1 +
> >  include/uapi/linux/neighbour.h |  1 +
> >  include/uapi/linux/sysctl.h    | 37 +++++++++++++++++-----------------
> >  net/core/neighbour.c           | 15 ++++++++++++--
> >  net/decnet/dn_neigh.c          |  1 +
> >  net/ipv4/arp.c                 |  1 +
> >  net/ipv6/ndisc.c               |  1 +
> >  8 files changed, 39 insertions(+), 21 deletions(-)
> >
> > diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> > index 87419f7f5421..75786903f1d4 100644
> > --- a/include/net/neighbour.h
> > +++ b/include/net/neighbour.h
> > @@ -48,6 +48,7 @@ enum {
> >       NEIGH_VAR_RETRANS_TIME,
> >       NEIGH_VAR_BASE_REACHABLE_TIME,
> >       NEIGH_VAR_DELAY_PROBE_TIME,
> > +     NEIGH_VAR_INTERVAL_PROBE_TIME,
> >       NEIGH_VAR_GC_STALETIME,
> >       NEIGH_VAR_QUEUE_LEN_BYTES,
> >       NEIGH_VAR_PROXY_QLEN,
> > @@ -64,7 +65,7 @@ enum {
> >       NEIGH_VAR_GC_THRESH1,
> >       NEIGH_VAR_GC_THRESH2,
> >       NEIGH_VAR_GC_THRESH3,
> > -     NEIGH_VAR_MAX
> > +     NEIGH_VAR_MAX,
>
> You should avoid style-only changes in area not touched otherwise by
> this

OK, I will redo this change in the next patch version.

>
> >  };
> >
> >  struct neigh_parms {
> > diff --git a/include/net/netevent.h b/include/net/netevent.h
> > index 4107016c3bb4..121df77d653e 100644
> > --- a/include/net/netevent.h
> > +++ b/include/net/netevent.h
> > @@ -26,6 +26,7 @@ enum netevent_notif_type {
> >       NETEVENT_NEIGH_UPDATE = 1, /* arg is struct neighbour ptr */
> >       NETEVENT_REDIRECT,         /* arg is struct netevent_redirect ptr */
> >       NETEVENT_DELAY_PROBE_TIME_UPDATE, /* arg is struct neigh_parms ptr */
> > +     NETEVENT_INTERVAL_PROBE_TIME_UPDATE, /* arg is struct neigh_parms ptr */
>
> Are you sure we need to notify the drivers about this parameter change?
> The host will periodically resolve the neighbours, and that should work
> regardless of the NIC offload. I think we don't need additional
> notifications.
>

`mlxsw_sp_router_netevent_event` in
drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c and
`mlx5e_rep_netevent_event` in
drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c still
use `NETEVENT_DELAY_PROBE_TIME_UPDATE` to receive the update event of
`DELAY_PROBE_TIME` as the probe interval.

I think we are supposed to replace `NETEVENT_DELAY_PROBE_TIME_UPDATE` with
`NETEVENT_INTERVAL_PROBE_TIME_UPDATE` after this patch is merged.

> >       NETEVENT_IPV4_MPATH_HASH_UPDATE, /* arg is struct net ptr */
> >       NETEVENT_IPV6_MPATH_HASH_UPDATE, /* arg is struct net ptr */
> >       NETEVENT_IPV4_FWD_UPDATE_PRIORITY_UPDATE, /* arg is struct net ptr */
> > diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> > index 39c565e460c7..8713c3ea81b2 100644
> > --- a/include/uapi/linux/neighbour.h
> > +++ b/include/uapi/linux/neighbour.h
> > @@ -154,6 +154,7 @@ enum {
> >       NDTPA_QUEUE_LENBYTES,           /* u32 */
> >       NDTPA_MCAST_REPROBES,           /* u32 */
> >       NDTPA_PAD,
> > +     NDTPA_INTERVAL_PROBE_TIME,      /* u64, msecs */
> >       __NDTPA_MAX
> >  };
> >  #define NDTPA_MAX (__NDTPA_MAX - 1)
> > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> > index 47b6c1f0fdbb..92447f04cf07 100644
> > --- a/net/core/neighbour.c
> > +++ b/net/core/neighbour.c
> > @@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
> >       list_for_each_entry(neigh, &tbl->managed_list, managed_list)
> >               neigh_event_send_probe(neigh, NULL, false);
> >       queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
> > -                        NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
> > +                        NEIGH_VAR(&tbl->parms, INTERVAL_PROBE_TIME));
> >       write_unlock_bh(&tbl->lock);
> >  }
> >
> > @@ -2100,7 +2100,9 @@ static int neightbl_fill_parms(struct sk_buff *skb, struct neigh_parms *parms)
> >           nla_put_msecs(skb, NDTPA_PROXY_DELAY,
> >                         NEIGH_VAR(parms, PROXY_DELAY), NDTPA_PAD) ||
> >           nla_put_msecs(skb, NDTPA_LOCKTIME,
> > -                       NEIGH_VAR(parms, LOCKTIME), NDTPA_PAD))
> > +                       NEIGH_VAR(parms, LOCKTIME), NDTPA_PAD) ||
> > +         nla_put_msecs(skb, NDTPA_INTERVAL_PROBE_TIME,
> > +                       NEIGH_VAR(parms, INTERVAL_PROBE_TIME), NDTPA_PAD))
> >               goto nla_put_failure;
> >       return nla_nest_end(skb, nest);
> >
> > @@ -2255,6 +2257,7 @@ static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
> >       [NDTPA_ANYCAST_DELAY]           = { .type = NLA_U64 },
> >       [NDTPA_PROXY_DELAY]             = { .type = NLA_U64 },
> >       [NDTPA_LOCKTIME]                = { .type = NLA_U64 },
> > +     [NDTPA_INTERVAL_PROBE_TIME]     = { .type = NLA_U64 },
>
> since a 0 value would not make any sense here and will cause problems,
> what about adding '.min = 1' ?

Thanks, good point! I will update this in the next patch version.

>
>
> Thanks!
>
> Paolo
>

Thanks!

Yuwei Wang
