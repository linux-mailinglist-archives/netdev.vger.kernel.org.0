Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04016647A50
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 00:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiLHXr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 18:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLHXrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 18:47:24 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF8B1EAE4
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 15:47:22 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so6308775pjp.1
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 15:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RHz/p94tRpWArc+NRaourv1FZGGAjavxHA+JkB/KZ8Y=;
        b=mR5Tolp08iTQW/5C1NJTRAoMOhbIOQMK29UbGb6VzbZG9tld40iecQXZXPv6TJY8gm
         Dv1TyaY6cquVsNxc67JHPaQXAF/lLZcDW3my6NuXlpQT60rPImh+9VGBt4hqRfY+UK16
         a2zfNi1398y8EhxeuNMdS8oyo9ia8gYd22VWPPp+tt2XZEqXZBLW53ZyROzAMVPvM5CV
         XMVX4gkUjrVFo1GuAfXPJAvMRE3XwREWUyTqMO12D0EOM6PlN642wZ30z1qScQ+VPiqJ
         3809UqN2BqpK4YkCOF6Z72/j9vrqrQgY8StGynahd2N3aTntXCzVRqUiSOElBpuIQoTG
         sopg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RHz/p94tRpWArc+NRaourv1FZGGAjavxHA+JkB/KZ8Y=;
        b=zwI9Y3J0itDfHu4wsbObJsRbhOJdmq0iv+EqI+9hx5yqab7ODfvMXBYnvoDnCJoJPh
         6z8ewKghvQULtNmhLL5aw//8qxsjgqOCaEQL3I/sfu+bITYir9AMQec/+Z7VzHhTvPEc
         3iBhYi4qzZfrW5fQyt1QSE26sZ6pRGSSvZeLOXSc3gX/OoFytlIFTHb0kYsukZwTmgf0
         xO4O+P0782UuvZozlvAtztZEMMHEqzEWvHxn6ONckTQHk3P9W1s2yQeFjehd16tPrstj
         24u+E/ejKW7SA+nqHf7cHkWxcd6bXo9zXjZ3SXoGdTvVFL2LEOiJ6m9A+2in+Nahr+aV
         BivA==
X-Gm-Message-State: ANoB5plJDhw4f/chJObKJuss+fYREbCBZ80I/DO0tLY/R4UaLkSQ/oJS
        g7/31IaUJouIJvWVcPVKkRQZnoRrI13RjoBC74aFIw==
X-Google-Smtp-Source: AA0mqf6iua9P2o6lgLNxy1HeHz8JDEFVLDHLRkw8kkkuPZcogC3iUmCPsb/7HHOq2HxvjCL0qSpGdYUmj69C7V7PXxw=
X-Received: by 2002:a17:902:d711:b0:188:c7b2:2dd with SMTP id
 w17-20020a170902d71100b00188c7b202ddmr79258168ply.88.1670543241942; Thu, 08
 Dec 2022 15:47:21 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <87bkodleca.fsf@toke.dk>
In-Reply-To: <87bkodleca.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 8 Dec 2022 15:47:10 -0800
Message-ID: <CAKH8qBuzpiXrL5SOxd1u0-zim+Kf166DRUDT0PuR081f-ad2-Q@mail.gmail.com>
Subject: Re: [xdp-hints] [PATCH bpf-next v3 00/12] xdp: hints via kfuncs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 8, 2022 at 2:29 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > Please see the first patch in the series for the overall
> > design and use-cases.
> >
> > Changes since v3:
> >
> > - Rework prog->bound_netdev refcounting (Jakub/Marin)
> >
> >   Now it's based on the offload.c framework. It mostly fits, except
> >   I had to automatically insert a HT entry for the netdev. In the
> >   offloaded case, the netdev is added via a call to
> >   bpf_offload_dev_netdev_register from the driver init path; with
> >   a dev-bound programs, we have to manually add (and remove) the entry.
> >
> >   As suggested by Toke, I'm also prohibiting putting dev-bound programs
> >   into prog-array map; essentially prohibiting tail calling into it.
> >   I'm also disabling freplace of the dev-bound programs. Both of those
> >   restrictions can be loosened up eventually.
>
> I thought it would be a shame that we don't support at least freplace
> programs from the get-go (as that would exclude libxdp from taking
> advantage of this). So see below for a patch implementing this :)
>
> -Toke

Damn, now I need to write a selftest :-)
But seriously, thank you for taking care of this, will try to include
preserving SoB!


> commit 3abb333e5fd2e8a0920b77013499bdae0ee3db43
> Author: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Date:   Thu Dec 8 23:10:54 2022 +0100
>
>     bpf: Support consuming XDP HW metadata from fext programs
>
>     Instead of rejecting the attaching of PROG_TYPE_EXT programs to XDP
>     programs that consume HW metadata, implement support for propagating =
the
>     offload information. The extension program doesn't need to set a flag=
 or
>     ifindex, it these will just be propagated from the target by the veri=
fier.
>     We need to create a separate offload object for the extension program=
,
>     though, since it can be reattached to a different program later (whic=
h
>     means we can't just inhering the offload information from the target)=
.
>
>     An additional check is added on attach that the new target is compati=
ble
>     with the offload information in the extension prog.
>
>     Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index b46b60f4eae1..cfa5c847cf2c 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2482,6 +2482,7 @@ void *bpf_offload_resolve_kfunc(struct bpf_prog *pr=
og, u32 func_id);
>  void unpriv_ebpf_notify(int new_state);
>
>  #if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
> +int __bpf_prog_offload_init(struct bpf_prog *prog, struct net_device *ne=
tdev);
>  int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr);
>  void bpf_offload_bound_netdev_unregister(struct net_device *dev);
>
> diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
> index bad8bab916eb..b059a7b53457 100644
> --- a/kernel/bpf/offload.c
> +++ b/kernel/bpf/offload.c
> @@ -83,36 +83,25 @@ bpf_offload_find_netdev(struct net_device *netdev)
>         return rhashtable_lookup_fast(&offdevs, &netdev, offdevs_params);
>  }
>
> -int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> +int __bpf_prog_offload_init(struct bpf_prog *prog, struct net_device *ne=
tdev)
>  {
>         struct bpf_offload_netdev *ondev;
>         struct bpf_prog_offload *offload;
>         int err;
>
> -       if (attr->prog_type !=3D BPF_PROG_TYPE_SCHED_CLS &&
> -           attr->prog_type !=3D BPF_PROG_TYPE_XDP)
> +       if (!netdev)
>                 return -EINVAL;
>
> -       if (attr->prog_flags & ~BPF_F_XDP_HAS_METADATA)
> -               return -EINVAL;
> +       err =3D __bpf_offload_init();
> +       if (err)
> +               return err;
>
>         offload =3D kzalloc(sizeof(*offload), GFP_USER);
>         if (!offload)
>                 return -ENOMEM;
>
> -       err =3D __bpf_offload_init();
> -       if (err)
> -               return err;
> -
>         offload->prog =3D prog;
> -
> -       offload->netdev =3D dev_get_by_index(current->nsproxy->net_ns,
> -                                          attr->prog_ifindex);
> -       err =3D bpf_dev_offload_check(offload->netdev);
> -       if (err)
> -               goto err_maybe_put;
> -
> -       prog->aux->offload_requested =3D !(attr->prog_flags & BPF_F_XDP_H=
AS_METADATA);
> +       offload->netdev =3D netdev;
>
>         down_write(&bpf_devs_lock);
>         ondev =3D bpf_offload_find_netdev(offload->netdev);
> @@ -135,19 +124,46 @@ int bpf_prog_offload_init(struct bpf_prog *prog, un=
ion bpf_attr *attr)
>         offload->offdev =3D ondev->offdev;
>         prog->aux->offload =3D offload;
>         list_add_tail(&offload->offloads, &ondev->progs);
> -       dev_put(offload->netdev);
>         up_write(&bpf_devs_lock);
>
>         return 0;
>  err_unlock:
>         up_write(&bpf_devs_lock);
> -err_maybe_put:
> -       if (offload->netdev)
> -               dev_put(offload->netdev);
>         kfree(offload);
>         return err;
>  }
>
> +int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> +{
> +       struct net_device *netdev;
> +       int err;
> +
> +       if (attr->prog_type !=3D BPF_PROG_TYPE_SCHED_CLS &&
> +           attr->prog_type !=3D BPF_PROG_TYPE_XDP)
> +               return -EINVAL;
> +
> +       if (attr->prog_flags & ~BPF_F_XDP_HAS_METADATA)
> +               return -EINVAL;
> +
> +       netdev =3D dev_get_by_index(current->nsproxy->net_ns, attr->prog_=
ifindex);
> +       if (!netdev)
> +               return -EINVAL;
> +
> +       err =3D bpf_dev_offload_check(netdev);
> +       if (err)
> +               goto out;
> +
> +       prog->aux->offload_requested =3D !(attr->prog_flags & BPF_F_XDP_H=
AS_METADATA);
> +
> +       err =3D __bpf_prog_offload_init(prog, netdev);
> +       if (err)
> +               goto out;
> +
> +out:
> +       dev_put(netdev);
> +       return err;
> +}
> +
>  int bpf_prog_offload_verifier_prep(struct bpf_prog *prog)
>  {
>         struct bpf_prog_offload *offload;
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index b345a273f7d0..606e6de5f716 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3021,6 +3021,14 @@ static int bpf_tracing_prog_attach(struct bpf_prog=
 *prog,
>                         goto out_put_prog;
>                 }
>
> +               if (bpf_prog_is_dev_bound(tgt_prog->aux) &&
> +                   (bpf_prog_is_offloaded(tgt_prog->aux) ||
> +                    !bpf_prog_is_dev_bound(prog->aux) ||
> +                    !bpf_offload_dev_match(prog, tgt_prog->aux->offload-=
>netdev))) {
> +                       err =3D -EINVAL;
> +                       goto out_put_prog;
> +               }
> +
>                 key =3D bpf_trampoline_compute_key(tgt_prog, NULL, btf_id=
);
>         }
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index bc8d9b8d4f47..d92e28dd220e 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -16379,11 +16379,6 @@ int bpf_check_attach_target(struct bpf_verifier_=
log *log,
>         if (tgt_prog) {
>                 struct bpf_prog_aux *aux =3D tgt_prog->aux;
>
> -               if (bpf_prog_is_dev_bound(tgt_prog->aux)) {
> -                       bpf_log(log, "Replacing device-bound programs not=
 supported\n");
> -                       return -EINVAL;
> -               }
> -
>                 for (i =3D 0; i < aux->func_info_cnt; i++)
>                         if (aux->func_info[i].type_id =3D=3D btf_id) {
>                                 subprog =3D i;
> @@ -16644,10 +16639,22 @@ static int check_attach_btf_id(struct bpf_verif=
ier_env *env)
>         if (tgt_prog && prog->type =3D=3D BPF_PROG_TYPE_EXT) {
>                 /* to make freplace equivalent to their targets, they nee=
d to
>                  * inherit env->ops and expected_attach_type for the rest=
 of the
> -                * verification
> +                * verification; we also need to propagate the prog offlo=
ad data
> +                * for resolving kfuncs.
>                  */
>                 env->ops =3D bpf_verifier_ops[tgt_prog->type];
>                 prog->expected_attach_type =3D tgt_prog->expected_attach_=
type;
> +
> +               if (bpf_prog_is_dev_bound(tgt_prog->aux)) {
> +                       if (bpf_prog_is_offloaded(tgt_prog->aux))
> +                               return -EINVAL;
> +
> +                       prog->aux->dev_bound =3D true;
> +                       ret =3D __bpf_prog_offload_init(prog,
> +                                                     tgt_prog->aux->offl=
oad->netdev);
> +                       if (ret)
> +                               return ret;
> +               }
>         }
>
>         /* store info about the attachment target that will be used later=
 */
>
