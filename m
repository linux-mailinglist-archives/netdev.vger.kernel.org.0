Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8826654BDC
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 05:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbiLWEGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 23:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiLWEGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 23:06:41 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26F7BE29
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 20:06:39 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 130so2551000pfu.8
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 20:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4/4swjF6goz/1r742K3NKCoJ8ZhDaJlUYbEQcoLbhfk=;
        b=GIC8zzfV5c9zgpD6qWZkcgRT0PUFxQscZDVQYpTaHur6upHs19Jtg3j+YBxpx1d2dm
         sXavbAnkmGkyHcKJ43ZJXuvK0dNInm2p10VIHuvYP8Kk7CUFn38OTKbHrBtqxDLXkrS+
         YK4z4WFPzGtK2bRMNnC0krVclHQbTKLDhdMa+nyVfKcEezEnYMLhNEquCndO7+tvq1Nr
         rdS+JYXZFBlxjOkSQMecAb5XcaLczfDUoD57zSuLaj7qdzdum71JJ+3hssJTZLLsoo85
         Y2BMKhIa9Hj4zazatDVmB2QoPpVykPvFSx6+s/C0+CDWlSh4SPnwnif1DYOfVYTAzKcG
         Dnyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4/4swjF6goz/1r742K3NKCoJ8ZhDaJlUYbEQcoLbhfk=;
        b=tYAoZUUQARhJW3m+hAAq2Q3umzT+nAq/lTKo0NL6m3J9IClVorq0m8DTMa3N6RjoDG
         btbVVp+kxgRFT2bmVqu9XPGSqDmqMTh+fIpVkXg1Bh2rVG1hDAb7fMkTSRnGDpJ5qWo8
         8JTU63B3kywlJ0koJHwqWJycMcSFjcdMZyawJ6r0w1qp3erGAiS7Zopk6Ebe2VubNrY3
         suXuvDeRRc4vEW8AyGiG21GlgeBuDZdzMlcvdAamnIVdVDWzxRJ1TnPXU5QJcSgUzTaX
         OT4Zz0wAUJfdKswqFr/oOt1/NlRJ88dnwZi/+oLexq2weBkuizBTHspjy0icLC+Q5olL
         PsmA==
X-Gm-Message-State: AFqh2kq+T2DOB4XLq+ErGxoTa8pmP/wXFJmOrKmWsKv814TTlSsNldpL
        0JfKpcNrVRFi8a9egLZ9wW18+t7tOIH6xOuX1yWhWQ==
X-Google-Smtp-Source: AMrXdXu3GpQ6UPOFHFXhryufD11v/lpXLTcrvQLvHHMvWMypUvxNpQweg/c+FXIamMyCnJ7q5bqYiUEl6Xus3JTpiLM=
X-Received: by 2002:aa7:8bd6:0:b0:578:8d57:12ce with SMTP id
 s22-20020aa78bd6000000b005788d5712cemr537650pfd.42.1671768398963; Thu, 22 Dec
 2022 20:06:38 -0800 (PST)
MIME-Version: 1.0
References: <20221220222043.3348718-1-sdf@google.com> <20221220222043.3348718-6-sdf@google.com>
 <04e1406b-0a31-0109-9a1b-f016e8f23603@linux.dev>
In-Reply-To: <04e1406b-0a31-0109-9a1b-f016e8f23603@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 22 Dec 2022 20:06:26 -0800
Message-ID: <CAKH8qBt192zF9nkbLVxgZ9RQS86-17Bv02Q58aANT28pBiL=GQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 05/17] bpf: Introduce device-bound XDP programs
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 22, 2022 at 4:19 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 12/20/22 2:20 PM, Stanislav Fomichev wrote:
> > -int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> > +int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
> >   {
> >       struct bpf_offload_netdev *ondev;
> >       struct bpf_prog_offload *offload;
> > @@ -199,7 +197,7 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> >           attr->prog_type != BPF_PROG_TYPE_XDP)
> >               return -EINVAL;
> >
> > -     if (attr->prog_flags)
> > +     if (attr->prog_flags & ~BPF_F_XDP_DEV_BOUND_ONLY)
> >               return -EINVAL;
> >
> >       offload = kzalloc(sizeof(*offload), GFP_USER);
> > @@ -214,11 +212,23 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> >       if (err)
> >               goto err_maybe_put;
> >
> > +     prog->aux->offload_requested = !(attr->prog_flags & BPF_F_XDP_DEV_BOUND_ONLY);
>
> Just noticed bpf_prog_dev_bound_init() takes BPF_PROG_TYPE_SCHED_CLS.  Not sure
> if there is device match check when attaching BPF_PROG_TYPE_SCHED_CLS.  If not,
> does it make sense to reject dev bound only BPF_PROG_TYPE_SCHED_CLS?

No, good point, I haven't added a device match check to tc progs; will
add a check here to reject dev-bound progs at tc.

> > +
> >       down_write(&bpf_devs_lock);
> >       ondev = bpf_offload_find_netdev(offload->netdev);
> >       if (!ondev) {
> > -             err = -EINVAL;
> > -             goto err_unlock;
> > +             if (bpf_prog_is_offloaded(prog->aux)) {
> > +                     err = -EINVAL;
> > +                     goto err_unlock;
> > +             }
> > +
> > +             /* When only binding to the device, explicitly
> > +              * create an entry in the hashtable.
> > +              */
> > +             err = __bpf_offload_dev_netdev_register(NULL, offload->netdev);
> > +             if (err)
> > +                     goto err_unlock;
> > +             ondev = bpf_offload_find_netdev(offload->netdev);
> >       }
> >       offload->offdev = ondev->offdev;
> >       prog->aux->offload = offload;
> > @@ -321,12 +331,41 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
> >       up_read(&bpf_devs_lock);
> >   }
> >
> > -void bpf_prog_offload_destroy(struct bpf_prog *prog)
> > +static void __bpf_prog_dev_bound_destroy(struct bpf_prog *prog)
> > +{
> > +     struct bpf_prog_offload *offload = prog->aux->offload;
> > +
> > +     if (offload->dev_state)
> > +             offload->offdev->ops->destroy(prog);
> > +
> > +     /* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
> > +     bpf_prog_free_id(prog, true);
> > +
> > +     kfree(offload);
> > +     prog->aux->offload = NULL;
> > +}
> > +
> > +void bpf_prog_dev_bound_destroy(struct bpf_prog *prog)
> >   {
> > +     struct bpf_offload_netdev *ondev;
> > +     struct net_device *netdev;
> > +
> > +     rtnl_lock();
> >       down_write(&bpf_devs_lock);
> > -     if (prog->aux->offload)
> > -             __bpf_prog_offload_destroy(prog);
> > +     if (prog->aux->offload) {
> > +             list_del_init(&prog->aux->offload->offloads);
> > +
> > +             netdev = prog->aux->offload->netdev;
>
> After saving the netdev, would it work to call __bpf_prog_offload_destroy() here
> instead of creating an almost identical __bpf_prog_dev_bound_destroy().  The
> idea is to call list_del_init() first but does not need the "offload" around to
> do the __bpf_offload_dev_netdev_unregister()?

Good idea, that might work, let me try..

> > +             if (netdev) {

[..]

> I am thinking offload->netdev cannot be NULL.  Did I overlook places that reset
> offload->netdev back to NULL?  eg. In bpf_prog_offload_info_fill_ns(), it is not
> checking offload->netdev.
>
> > +                     ondev = bpf_offload_find_netdev(netdev);
>
> and ondev should not be NULL too?
>
> I am trying to ensure my understanding that all offload->netdev and ondev should
> be protected by bpf_devs_lock.

I think you're right and I'm just being overly cautious here.


> > +                     if (ondev && !ondev->offdev && list_empty(&ondev->progs))
> > +                             __bpf_offload_dev_netdev_unregister(NULL, netdev);
> > +             }
> > +
> > +             __bpf_prog_dev_bound_destroy(prog);
> > +     }
> >       up_write(&bpf_devs_lock);
> > +     rtnl_unlock();
> >   }
>
