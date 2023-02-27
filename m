Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349F26A46A1
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 17:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjB0QBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 11:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjB0QBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 11:01:49 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3600F2332F
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 08:01:48 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-536c2a1cc07so189044487b3.5
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 08:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XS/B4pGdLV1AO7O+wz9U8z2v4z271XsjW+PCNF6J2YQ=;
        b=Sm2Blett3oy2CobZWlAjbX2rdM+iD7LONaeelApS8JmXMeJ0+ghUmKV9glcb1yx76v
         0BFiIlR8veO2FRoLCFLe6QgenkOFjd49IahoZGvp6rJGFB6ssBqm+dLs/z/Q4P4Nubvb
         gT7qDmhh6ia2QLeJH9G2JUnFyplwadeqCNQVqlYgJre1KXwOVYEhQ0wShnKP3IMGF7C/
         4NArIqJYVtcvyaD5tQh3qr9LqhhX6Hc2lmaKvgSdfkMLiei3r1XloRJOkUC0LeaGbXNt
         /zonAkdl+/uq1Grstz2yy7h2mYwJY1tM3NpRRJID0cDnkbYu/H/B3qJDjgH23EnhCeKM
         V/rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XS/B4pGdLV1AO7O+wz9U8z2v4z271XsjW+PCNF6J2YQ=;
        b=sPBP5LR8gRVZ9Aj8nSaJoS5PGMv5rArdvGg9a2XmxSqvDYItRq/8krghDsDP1qOrtk
         I/y6z/gCsmZRQZ5uQbaZIYcefk7sNTmAw+NU+0poVM4OGtKeO+l2zgSWNz9nwKZreG9N
         rtsZLEK0crZF+9StcBAI05KtyNUQ6hcCRVQ0W9acRbIxQnjTkQ8HYUuKdYOkes+s0L5n
         d5njaLNG/2lEKUrtGHIv6EkXEP771jHeIWH9yxd4xAb9+1dV+CppwAOp4Ue3/Eq+fHNI
         9xSC1M6kxntMSnOo4RpeW5i/yhQXqqwEMAiBV/hdcDca2DAoxGr+Q9tapjuHobtf+9Mq
         j3Dg==
X-Gm-Message-State: AO0yUKXYQi2jPhoUTpAXVBvZL3vmWy20w2ODhV0jwAmLZcU599/levwN
        nwxfHUEaheOZLodQKOq3ctMwu9kI0idHNKg/Duk=
X-Google-Smtp-Source: AK7set/9r5pNkgF6eMPDDvamTse4ZxS7uOLHAFR8CRjOx3Zlp2kbqkTA74QMdRdXKUxBgZNLpWq2IfK+kvRRAJKwqLU=
X-Received: by 2002:a25:9392:0:b0:997:bdfe:78c5 with SMTP id
 a18-20020a259392000000b00997bdfe78c5mr9456665ybm.6.1677513707069; Mon, 27 Feb
 2023 08:01:47 -0800 (PST)
MIME-Version: 1.0
References: <20230221043547.21147-1-u9012063@gmail.com> <103076c8-12df-7ef6-2660-280301754e01@intel.com>
In-Reply-To: <103076c8-12df-7ef6-2660-280301754e01@intel.com>
From:   William Tu <u9012063@gmail.com>
Date:   Mon, 27 Feb 2023 08:01:11 -0800
Message-ID: <CALDO+SYXo8NJcmLs0BoqXBHwk=wpY70WiuvG4OO73RrpOt9qzA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v17] vmxnet3: Add XDP support.
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, jsankararama@vmware.com, gyang@vmware.com,
        doshir@vmware.com, alexander.duyck@gmail.com,
        alexandr.lobakin@intel.com, bang@vmware.com,
        maciej.fijalkowski@intel.com, witu@nvidia.com,
        Yifeng Sun <yifengs@vmware.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 7:24=E2=80=AFAM Alexander Lobakin
<aleksander.lobakin@intel.com> wrote:
>
> From: William Tu <u9012063@gmail.com>
> Date: Mon, 20 Feb 2023 20:35:47 -0800
>
> > The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIREC=
T.
>
> [...]
>
> > +static int
> > +vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
> > +             struct netlink_ext_ack *extack)
> > +{
> > +     struct vmxnet3_adapter *adapter =3D netdev_priv(netdev);
> > +     struct bpf_prog *new_bpf_prog =3D bpf->prog;
> > +     struct bpf_prog *old_bpf_prog;
> > +     bool need_update;
> > +     bool running;
> > +     int err;
> > +
> > +     if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {
> > +             NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
>
> Minor: we now have NL_SET_ERR_MSG_FMT_MOD(), so you could even print to
> user what the maximum MTU you support for XDP is.
good idea, will use it.

>
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> > +     if (adapter->netdev->features & NETIF_F_LRO) {
> > +             NL_SET_ERR_MSG_MOD(extack, "LRO is not supported with XDP=
");
> > +             adapter->netdev->features &=3D ~NETIF_F_LRO;
> > +     }
> > +
> > +     old_bpf_prog =3D rcu_dereference(adapter->xdp_bpf_prog);
> > +     if (!new_bpf_prog && !old_bpf_prog)
> > +             return 0;
> > +
> > +     running =3D netif_running(netdev);
> > +     need_update =3D !!old_bpf_prog !=3D !!new_bpf_prog;
> > +
> > +     if (running && need_update)
> > +             vmxnet3_quiesce_dev(adapter);
>
> [...]
>
> > +             bpf_warn_invalid_xdp_action(rq->adapter->netdev, prog, ac=
t);
> > +             fallthrough;
> > +     case XDP_ABORTED:
> > +             trace_xdp_exception(rq->adapter->netdev, prog, act);
> > +             rq->stats.xdp_aborted++;
> > +             break;
> > +     case XDP_DROP:
> > +             rq->stats.xdp_drops++;
> > +             break;
> > +     }
> > +
> > +     page_pool_recycle_direct(rq->page_pool, page);
>
> You can speed up stuff a bit here. recycle_direct() takes ->max_len to
> sync DMA for device when recycling. You can use page_pool_put_page() and
> specify the actual length which needs to be synced. This is a bit
> tricky, but some systems have incredibly expensive DMA synchronization
> and every byte counts there.
> "Tricky" because you can't specify the original frame size here and ATST
> can't specify the current xdp.data_end - xdp.data. As xdp.data may grow
> to both left and right, the same with .data_end. So what you basically
> need is the following:
>
> sync_len =3D max(orig_len,
>                xdp.data_end - xdp.data_hard_start - page_pool->p.offset)
>
> Because we don't care about the data between data_hard_start and
> p.offset -- hardware doesn't touch it. But we care about the whole area
> that might've been touched to the right of it.
>
> Anyway, up to you. On server x86_64 platforms DMA sync is usually a noop.
Thanks a lot!
Actually at hypersor side we noticed that DMA sync is pretty expensive,
that's why we have dataring as optimization (no DMA sync)
So it might worth doing it and I will try and see if there is any
performance difference!
(but not the next version)

>
> > +
> > +     return act;
> > +}
>
> [...]
>
> > +static inline bool vmxnet3_xdp_enabled(struct vmxnet3_adapter *adapter=
)
> > +{
> > +     return !!rcu_access_pointer(adapter->xdp_bpf_prog);
> > +}
> > +
> > +#endif
>
> I feel good with the rest of the patch, thanks! Glad to see all the
> feedback addressed when applicable.
>
> Olek

Thanks!
William
