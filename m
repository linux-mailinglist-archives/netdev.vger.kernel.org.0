Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D63532C4E
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 16:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiEXOeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 10:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiEXOeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 10:34:06 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1457A66F84
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 07:34:02 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id j11so3717635vka.6
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 07:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TbybU3/1or+1LnRZZiLwXd9Guvm+3mF5PqpU8jWELds=;
        b=NZNmvhxMBVFg5ljVx/TsXNKpnTVPr4ZFQmq7Xui3IOcRl3Bo/5xyD19NV2f4hVzC5z
         kzae6ID/92ujbjHRCGuIPFJLqgT9oGTUcnAgiMg74Zp1qViHFjrxmCAYD5OHxN77KMld
         CDh9eUwjSI+QdtaFcdUDxliGHI+kJ63v2QwdC4eRZddQjISPviiwejNRbGXPvxJun1Rr
         sMwNNnwvuz5WnvOCdC7Qj/hfZ2kBsSrmJ/XMKJKQO4/5skWpa2oJXuIqQI/LeYhGdenO
         rrO+qXE86Azs1Si0QrViBypUEwnhovIT5q0GOtbkMbvGblkb8ejtyVL+pOdV30chTLn9
         ZrkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TbybU3/1or+1LnRZZiLwXd9Guvm+3mF5PqpU8jWELds=;
        b=pC64x8bL5IP6oVeoRvTagYaF+B/8LIwFZrQ+ror4cq3t8YMrwcKCLBTeKvJzOFx3Xm
         A7fWmtfQ9VE/q801KflRxqvbK+vSezRDM0AB/HJxyUiFN+jzHBMe7lMXvRqsEMC1QelJ
         px8jdaVQL0y9djy8Z9SdfcdzDtztaq2uu3vQXrRRrBe7So2iYD+QpLkiLsrDrMQ+U9LK
         iu1gFp+ka/8eDjvDiXvp3UzIPYTwIGfQ3mYFmm8itMGCYF2X8TK0KuWWfnzafWLoUqd4
         m/qAXokXON3eS39pRE5jAfGcA9liWVjfQF9v8uDgQfIAweZFkqFj2SfKIbDTJHY9JGlK
         12ig==
X-Gm-Message-State: AOAM532qk2/br2Frj5STIrS+AjdRfwHZ0FHbU+l5u1cv+DMdcAMCAIzW
        wyc35M0a9AVjwNhD6Sd3fVMfd1xj4qqoHRr4Kkg=
X-Google-Smtp-Source: ABdhPJzIPp16OEhuix/OjZtFXesm8PD9D74SmmtRbHW2a0xMY/L36k3sjSHYvKiYyt+LxWQuGr2P03asmGEJc7EfakA=
X-Received: by 2002:ac5:c7a1:0:b0:34e:98f9:88c3 with SMTP id
 d1-20020ac5c7a1000000b0034e98f988c3mr9765958vkn.15.1653402840904; Tue, 24 May
 2022 07:34:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220522031739.87399-1-wangyuweihx@gmail.com> <b5cf7fac361752d925f663d9a9b0b8415084f7d3.camel@redhat.com>
 <CANmJ_FP0CxSVksjvNsNjpQO8w+S3_10byQSCpt1ifQ6HeURUmA@mail.gmail.com> <cf3188eba7e529e4f112f6a752158f38e22f4851.camel@redhat.com>
In-Reply-To: <cf3188eba7e529e4f112f6a752158f38e22f4851.camel@redhat.com>
From:   Yuwei Wang <wangyuweihx@gmail.com>
Date:   Tue, 24 May 2022 22:33:49 +0800
Message-ID: <CANmJ_FOSfJY7VUQrxb+hX42XjiuF+WZGcbQEiSDRQiRZRBHT9g@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net, neigh: introduce interval_probe_time for
 periodic probe
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, daniel@iogearbox.net,
        roopa@nvidia.com, dsahern@kernel.org,
        =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org, yuwei wang <wangyuweihx@hotmail.com>
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

On Tue, 24 May 2022 at 18:41, Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2022-05-24 at 17:38 +0800, Yuwei Wang wrote:
> > On Tue, 24 May 2022 at 16:38, Paolo Abeni <pabeni@redhat.com> wrote:
> > >
> > > On Sun, 2022-05-22 at 03:17 +0000, Yuwei Wang wrote:
> > >
> > > > diff --git a/include/net/netevent.h b/include/net/netevent.h
> > > > index 4107016c3bb4..121df77d653e 100644
> > > > --- a/include/net/netevent.h
> > > > +++ b/include/net/netevent.h
> > > > @@ -26,6 +26,7 @@ enum netevent_notif_type {
> > > >       NETEVENT_NEIGH_UPDATE = 1, /* arg is struct neighbour ptr */
> > > >       NETEVENT_REDIRECT,         /* arg is struct netevent_redirect ptr */
> > > >       NETEVENT_DELAY_PROBE_TIME_UPDATE, /* arg is struct neigh_parms ptr */
> > > > +     NETEVENT_INTERVAL_PROBE_TIME_UPDATE, /* arg is struct neigh_parms ptr */
> > >
> > > Are you sure we need to notify the drivers about this parameter change?
> > > The host will periodically resolve the neighbours, and that should work
> > > regardless of the NIC offload. I think we don't need additional
> > > notifications.
> > >
> >
> > `mlxsw_sp_router_netevent_event` in
> > drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c and
> > `mlx5e_rep_netevent_event` in
> > drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c still
> > use `NETEVENT_DELAY_PROBE_TIME_UPDATE` to receive the update event of
> > `DELAY_PROBE_TIME` as the probe interval.
> >
> > I think we are supposed to replace `NETEVENT_DELAY_PROBE_TIME_UPDATE` with
> > `NETEVENT_INTERVAL_PROBE_TIME_UPDATE` after this patch is merged.
>
> AFAICS the event notification is to let neigh_timer_handler() cope
> properly with NIC offloading the data plane.
>
> In such scenario packets (forwarded by the NIC) don't reach the host,
> and neigh->confirmed can be untouched for a long time fooling
> neigh_timer_handler() into a timeout.
>
> The event notification allows the NIC to perform the correct actions to
> avoid such timeout.
>
> In case of MANAGED neighbour, the host is periodically sending probe
> request, and both req/replies should not be offloaded. AFAICS no action
> is expected from the NIC to cope with INTERVAL_PROBE_TIME changes.

I think `INTERVAL_PROBE_TIME` is not only for MANAGED neighbour,
if the driver needs periodically poll the device for neighbours activity,
we also should use  `INTERVAL_PROBE_TIME` rather than `DELAY_PROBE_TIME` as
the polling interval.

but as
Link: https://lore.kernel.org/netdev/20211011121238.25542-5-daniel@iogearbox.net/

> mlxsw which has similar driver-internal infrastructure
> c723c735fa6b ("mlxsw: spectrum_router: Periodically update the kernel's neigh table").
> In future, the latter could possibly reuse the NTF_MANAGED neighbors as well.

It seems that the behavior probe periodically by the driver will be
deprecated and replaced by setting the MANAGED flag.
or we can keep using `DELAY_PROBE_TIME` before it is replaced?

Look forward to your reply.

Yuwei Wang
