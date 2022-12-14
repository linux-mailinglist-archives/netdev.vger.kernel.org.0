Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C4C64CF9A
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 19:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238880AbiLNSmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 13:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238671AbiLNSmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 13:42:23 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08DF5F48
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 10:42:22 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id g10so4244442plo.11
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 10:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2RgklV7DxsIHlYiTKFAg3aR9zq9eoKwT/Q1P3Gt7rlw=;
        b=PivzMciD4mAgu+BosCMS/+LBRaMi3edU1w32cK8j4hju29UxoMmyGp1NL+O1HPVqT3
         7b4h8odj4/qSFI/Q56UcCImNEryFh4Ra6OpddKsHq/pZ20sMaUKJ7bNp9uHvk4S+ltu/
         g0a66Gl5Ma8telZrbCBneaxcfKCG5wBcpNJonClm42ftiR5Y423OGIHCyK2+fKD4s45O
         7sxpNiNbQeohJ3o7hEiPaKZLs8G+N4EVcWTof05RnKxXvvMgAD3achNj7GUKAkldMffZ
         oJY0VUQoQ0pNI/Wa+ELx5h4/l5PqgrmC2QXQdRCTlooXaUyUek0grNxvKW2wiAU7aRMo
         MQpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2RgklV7DxsIHlYiTKFAg3aR9zq9eoKwT/Q1P3Gt7rlw=;
        b=BKEZrZ49tcu9/sQIQC2TXQhDc193FbPUiCSfNkfcdUKAY5XqmnKIiOwUQZ6RZ/tDxJ
         ng7oZz1Sj+ssGCSSkLgEkw7a+LZbkxZHwnqG3XVqI2BffeBFgyjk46veYRH/E+qWg3BG
         owloUjPSwQVkZRdkMd9Q79t4Gk8XJSz2lVl5OeVwNjwMFYNfqgPbdpTl+bjx7r3hXonb
         ilui9WQ3402aQboYJ/Bu4ie84PGXOSH/U1ldD7gCGXfVv5EoQ42BkojjGd5IY21Eb+fh
         6XiXuSrkfkTLwSPPTC7yFwHRM1qhO6Eoi6cu5gE5qC/ueXvQ0ziOARo2SVdbU35F00t9
         NGlA==
X-Gm-Message-State: AFqh2krzfYFvD/ibFYfUMvkl33b3ZR29JJvSCcrRCgi3KBfGGRNMhkBC
        AiSDN9FuN+4yhhsunUhAeJhBZJ+OmSRlyD8FAJnvwQ==
X-Google-Smtp-Source: AMrXdXv3ScMa6EtlqyYs8vmOb6CyWiDwlUUkPfmrdfEeAQYoVGaXCXJSNw48WjRfxLY/mg9oc+WMJDla6ljlptMWFe4=
X-Received: by 2002:a17:90a:c389:b0:218:9107:381b with SMTP id
 h9-20020a17090ac38900b002189107381bmr390411pjt.75.1671043342165; Wed, 14 Dec
 2022 10:42:22 -0800 (PST)
MIME-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com> <20221213023605.737383-4-sdf@google.com>
 <94d8cd3a-fc07-88aa-94f8-6b08940a2087@linux.dev>
In-Reply-To: <94d8cd3a-fc07-88aa-94f8-6b08940a2087@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 14 Dec 2022 10:42:10 -0800
Message-ID: <CAKH8qBsg1hYnkmurnSGCCzTFOzQrV4DKCw1gefgXNb6UN57+Vg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 03/15] bpf: Introduce device-bound XDP programs
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 3:25 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 12/12/22 6:35 PM, Stanislav Fomichev wrote:
> > New flag BPF_F_XDP_DEV_BOUND_ONLY plus all the infra to have a way
> > to associate a netdev with a BPF program at load time.
> >
> > Some existing 'offloaded' routines are renamed to 'dev_bound' for
> > consistency with the rest.
> >
> > Also moved a bunch of code around to avoid forward declarations.
>
> There are too many things in one patch.  It becomes quite hard to follow, eg. I
> have to go back-and-forth a few times within this patch to confirm what change
> is just a move.  Please put the "moved a bunch of code around to avoid forward
> declarations" in one individual patch and also the
> "late_initcall(bpf_offload_init)" change in another individual patch.

Ugh, sorry, good point will definitely split more :-(

> [ ... ]
>
> > -int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> > +static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
> > +                                          struct net_device *netdev)
> > +{
> > +     struct bpf_offload_netdev *ondev;
> > +     int err;
> > +
> > +     ondev = kzalloc(sizeof(*ondev), GFP_KERNEL);
> > +     if (!ondev)
> > +             return -ENOMEM;
> > +
> > +     ondev->netdev = netdev;
> > +     ondev->offdev = offdev;
> > +     INIT_LIST_HEAD(&ondev->progs);
> > +     INIT_LIST_HEAD(&ondev->maps);
> > +
> > +     err = rhashtable_insert_fast(&offdevs, &ondev->l, offdevs_params);
> > +     if (err) {
> > +             netdev_warn(netdev, "failed to register for BPF offload\n");
> > +             goto err_unlock_free;
> > +     }
> > +
> > +     if (offdev)
> > +             list_add(&ondev->offdev_netdevs, &offdev->netdevs);
> > +     return 0;
> > +
> > +err_unlock_free:
> > +     up_write(&bpf_devs_lock);
>
> No need to handle bpf_devs_lock in the "__" version of the register() helper?
> The goto label probably also needs another name, eg. "err_free".

Ah, not sure how I missed that, thanks!

> > +     kfree(ondev);
> > +     return err;
> > +}
> > +
>
> [ ... ]
>
> > +int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
> >   {
> >       struct bpf_offload_netdev *ondev;
> >       struct bpf_prog_offload *offload;
> > @@ -87,7 +198,7 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> >           attr->prog_type != BPF_PROG_TYPE_XDP)
> >               return -EINVAL;
> >
> > -     if (attr->prog_flags)
> > +     if (attr->prog_flags & ~BPF_F_XDP_DEV_BOUND_ONLY)
> >               return -EINVAL;
> >
> >       offload = kzalloc(sizeof(*offload), GFP_USER);
> > @@ -102,11 +213,25 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> >       if (err)
> >               goto err_maybe_put;
> >
> > +     prog->aux->offload_requested = !(attr->prog_flags & BPF_F_XDP_DEV_BOUND_ONLY);
> > +
> >       down_write(&bpf_devs_lock);
> >       ondev = bpf_offload_find_netdev(offload->netdev);
> >       if (!ondev) {
> > -             err = -EINVAL;
> > -             goto err_unlock;
> > +             if (!bpf_prog_is_offloaded(prog->aux)) {
> > +                     /* When only binding to the device, explicitly
> > +                      * create an entry in the hashtable. See related
> > +                      * bpf_dev_bound_try_remove_netdev.
> > +                      */
> > +                     err = __bpf_offload_dev_netdev_register(NULL, offload->netdev);
> > +                     if (err)
> > +                             goto err_unlock;
> > +                     ondev = bpf_offload_find_netdev(offload->netdev);
> > +             }
> > +             if (!ondev) {
>
> nit.  A bit confusing because the "ondev = bpf_offload_find_netdev(...)" above
> should not fail but "!ondev" is tested again here.  I think the intention is to
> fail on the 'bpf_prog_is_offloaded() == true' case. May be:
>
>                 if (bpf_prog_is_offloaded(prog->aux)) {
>                         err = -EINVAL;
>                         goto err_unlock;
>                 }
>                 /* When only binding to the device, explicitly
>                  * ...
>                  */
>                 err = __bpf_offload_dev_netdev_register(NULL, offload->netdev);
>                 if (err)
>                         goto err_unlock;
>                 ondev = bpf_offload_find_netdev(offload->netdev);
>

Yeah, that looks better, thx!

> > +                     err = -EINVAL;
> > +                     goto err_unlock;
> > +             }
> >       }
> >       offload->offdev = ondev->offdev;
> >       prog->aux->offload = offload;
> > @@ -209,27 +334,28 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
> >       up_read(&bpf_devs_lock);
> >   }
> >
> > -static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
> > +static void bpf_dev_bound_try_remove_netdev(struct net_device *dev)
> >   {
> > -     struct bpf_prog_offload *offload = prog->aux->offload;
> > -
> > -     if (offload->dev_state)
> > -             offload->offdev->ops->destroy(prog);
> > +     struct bpf_offload_netdev *ondev;
> >
> > -     /* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
> > -     bpf_prog_free_id(prog, true);
> > +     if (!dev)
> > +             return;
> >
> > -     list_del_init(&offload->offloads);
> > -     kfree(offload);
> > -     prog->aux->offload = NULL;
> > +     ondev = bpf_offload_find_netdev(dev);
> > +     if (ondev && !ondev->offdev && list_empty(&ondev->progs))
>
> hmm....list_empty(&ondev->progs) is tested here but will it be empty? ...

Ugh, yeah, need to move that list_del_init(&offload->offloads) to
somewhere before bpf_dev_bound_try_remove_netdev.

> > +             __bpf_offload_dev_netdev_unregister(NULL, dev);
> >   }
> >
> > -void bpf_prog_offload_destroy(struct bpf_prog *prog)
> > +void bpf_prog_dev_bound_destroy(struct bpf_prog *prog)
> >   {
> > +     rtnl_lock();
> >       down_write(&bpf_devs_lock);
> > -     if (prog->aux->offload)
> > -             __bpf_prog_offload_destroy(prog);
> > +     if (prog->aux->offload) {
> > +             bpf_dev_bound_try_remove_netdev(prog->aux->offload->netdev);
>
> ... the "prog" here is still linked to ondev->progs, right?
> because __bpf_prog_dev_bound_destroy() is called later below.

Agreed, right.

> nit. May be the bpf_dev_bound_try_remove_netdev() should be folded/merged back
> into bpf_prog_dev_bound_destroy() to make things more clear.

Makes sense.

> > +             __bpf_prog_dev_bound_destroy(prog); > + }
> >       up_write(&bpf_devs_lock);
> > +     rtnl_unlock();
> >   }
>
> [ ... ]
>
> > +static int __init bpf_offload_init(void)
> > +{
> > +     int err;
> > +
> > +     down_write(&bpf_devs_lock);
>
> lock is probably not needed.

Sure, will drop.

> > +     err = rhashtable_init(&offdevs, &offdevs_params);
> > +     up_write(&bpf_devs_lock);
> > +
> > +     return err;
> > +}
> > +
> > +late_initcall(bpf_offload_init);
>
> [ ... ]
>
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 5d51999cba30..194f8116aad4 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -9228,6 +9228,10 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
> >                       NL_SET_ERR_MSG(extack, "Using offloaded program without HW_MODE flag is not supported");
> >                       return -EINVAL;
> >               }
> > +             if (bpf_prog_is_dev_bound(new_prog->aux) && !bpf_offload_dev_match(new_prog, dev)) {
> > +                     NL_SET_ERR_MSG(extack, "Program bound to different device");
> > +                     return -EINVAL;
> > +             }
> >               if (new_prog->expected_attach_type == BPF_XDP_DEVMAP) {
> >                       NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached to a device");
> >                       return -EINVAL;
> > @@ -10813,6 +10817,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
> >               /* Shutdown queueing discipline. */
> >               dev_shutdown(dev);
> >
> > +             bpf_dev_bound_netdev_unregister(dev);
>
> Does it matter if bpf_dev_bound_netdev_unregister(dev) is called before
> dev_xdp_uninstall(dev)?  Asking because it seems more logic to unregister dev
> after detaching xdp progs.

By running it first I was hoping to catch any possible issues. Agreed
that doing it after makes more sense, will move.

> >               dev_xdp_uninstall(dev);
> >
> >               netdev_offload_xstats_disable_all(dev);
>
>
