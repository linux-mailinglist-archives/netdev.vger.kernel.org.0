Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A463930B653
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 05:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhBBEQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 23:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhBBEQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 23:16:24 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C6FC061573;
        Mon,  1 Feb 2021 20:15:44 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id i9so1111111wmq.1;
        Mon, 01 Feb 2021 20:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H+NesHjdhPYkx2/ro7wCQ8JwDxI6uAdbGh+UgZkxW2k=;
        b=U5J/0VCktRTFSFZClgQ/qNH4PY5lN79/8UDqEPb8+d+wC5E2MxodJfQt83Sx1f/kkD
         mwg0G9wLZDSwCeMXAE8G5SysrPQJ4CxYdmNIaaBRcKhdisHD89xS99uZLgM5u+jC+kd/
         47S/LMzvvWpw5lpefzF+K+yeQwYQGFS/aiXl2pwaFfotYUAZdhMcJRX4v4COMfrL0szw
         TvjMkSlmYkYKM/AR7ED3zoRpzfieXQ49FovwWKzSBKpp9lAPgV9iFIMkfTtzpUNae8AW
         T2HpqRBb56k3/fHScfd9S4OmzdfwyOC+7AhE6h8ZYDkQ7XxO87GHLl3+Vj1AoY9Ulpdd
         zZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H+NesHjdhPYkx2/ro7wCQ8JwDxI6uAdbGh+UgZkxW2k=;
        b=Q4olOenRqqUvLfNnR6uK2xI096ODIjkD175UhEdqX1jjHay2BYzeXcTY0KIOM339dV
         oQZbZxQFLVDuaZzObzlcL47mrZkwfy03C4h7meI6pqSasuUmRiDVlSkX6QEfjVthaVGZ
         z6xZZK8/9ZRcHCsRE++CoxvZfKbh5C12HdF7VJZcq2zmqvY8vp4TbPWhE+S6my1x0yKD
         lBnyGfw8N/5TyMlxL/DLqt5r7y3WWIgZOgLgWsXxZ5L2ffQguDxJWZSiVQy7syvhHpHN
         Gph7l9ERwEomKKsducIIumaxFZlnDTMroskmnFjSXsQxsk52oM9UAzTUjAalqcjglWWq
         2mDg==
X-Gm-Message-State: AOAM532881jTy/uAbLaWmBjiLQ5mO8Mwdbm+iqbyH0f4V9HBfjXS+eP/
        kE1cj9rZWez310tZHQUhzZ1VpA+20P4AHDqvLqw=
X-Google-Smtp-Source: ABdhPJwMJBvOvrmZ6tJqKD3eUvuZ+pMnIF6Py0ncMzk3+h9PmZO2leAKL47sodZLt2IQ21AKGfR7nsOMpQMWx7SFaoQ=
X-Received: by 2002:a1c:4c01:: with SMTP id z1mr1693390wmf.159.1612239341255;
 Mon, 01 Feb 2021 20:15:41 -0800 (PST)
MIME-Version: 1.0
References: <20210128134130.3051-1-elic@nvidia.com> <20210128134130.3051-2-elic@nvidia.com>
 <CAPWQSg0XtEQ1U5N3a767Ak_naoyPdVF1CeE4r3hmN11a-aoBxg@mail.gmail.com>
 <CAPWQSg3U9DCSK_01Kzuea5B1X+Ef9JB23wBY82A3ss-UXGek_Q@mail.gmail.com> <9d6058d6-5ce1-0442-8fd9-5a6fe6a0bc6b@redhat.com>
In-Reply-To: <9d6058d6-5ce1-0442-8fd9-5a6fe6a0bc6b@redhat.com>
From:   Si-Wei Liu <siwliu.kernel@gmail.com>
Date:   Mon, 1 Feb 2021 20:15:29 -0800
Message-ID: <CAPWQSg3KOAypcrs9krW8cGE7EDLTehCUCYFZMUYYNaYPH1oBZQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] vdpa/mlx5: Avoid unnecessary query virtqueue
To:     Jason Wang <jasowang@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com,
        Si-Wei Liu <si-wei.liu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 7:13 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/2 =E4=B8=8A=E5=8D=883:17, Si-Wei Liu wrote:
> > On Mon, Feb 1, 2021 at 10:51 AM Si-Wei Liu <siwliu.kernel@gmail.com> wr=
ote:
> >> On Thu, Jan 28, 2021 at 5:46 AM Eli Cohen <elic@nvidia.com> wrote:
> >>> suspend_vq should only suspend the VQ on not save the current availab=
le
> >>> index. This is done when a change of map occurs when the driver calls
> >>> save_channel_info().
> >> Hmmm, suspend_vq() is also called by teardown_vq(), the latter of
> >> which doesn't save the available index as save_channel_info() doesn't
> >> get called in that path at all. How does it handle the case that
> >> aget_vq_state() is called from userspace (e.g. QEMU) while the
> >> hardware VQ object was torn down, but userspace still wants to access
> >> the queue index?
> >>
> >> Refer to https://lore.kernel.org/netdev/1601583511-15138-1-git-send-em=
ail-si-wei.liu@oracle.com/
> >>
> >> vhost VQ 0 ring restore failed: -1: Resource temporarily unavailable (=
11)
> >> vhost VQ 1 ring restore failed: -1: Resource temporarily unavailable (=
11)
> >>
> >> QEMU will complain with the above warning while VM is being rebooted
> >> or shut down.
> >>
> >> Looks to me either the kernel driver should cover this requirement, or
> >> the userspace has to bear the burden in saving the index and not call
> >> into kernel if VQ is destroyed.
> > Actually, the userspace doesn't have the insights whether virt queue
> > will be destroyed if just changing the device status via set_status().
> > Looking at other vdpa driver in tree i.e. ifcvf it doesn't behave like
> > so. Hence this still looks to me to be Mellanox specifics and
> > mlx5_vdpa implementation detail that shouldn't expose to userspace.
>
>
> So I think we can simply drop this patch?

Yep, I think so. To be honest I don't know why it has anything to do
with the memory hotplug issue.

-Siwei

>
> Thanks
>
>
> >> -Siwei
> >>
> >>
> >>> Signed-off-by: Eli Cohen <elic@nvidia.com>
> >>> ---
> >>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
> >>>   1 file changed, 8 deletions(-)
> >>>
> >>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/ne=
t/mlx5_vnet.c
> >>> index 88dde3455bfd..549ded074ff3 100644
> >>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> >>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> >>> @@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdpa_net *ndev,=
 struct mlx5_vdpa_virtqueue *mvq)
> >>>
> >>>   static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa=
_virtqueue *mvq)
> >>>   {
> >>> -       struct mlx5_virtq_attr attr;
> >>> -
> >>>          if (!mvq->initialized)
> >>>                  return;
> >>>
> >>> @@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5_vdpa_net *n=
dev, struct mlx5_vdpa_virtqueue *m
> >>>
> >>>          if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STA=
TE_SUSPEND))
> >>>                  mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend fail=
ed\n");
> >>> -
> >>> -       if (query_virtqueue(ndev, mvq, &attr)) {
> >>> -               mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtque=
ue\n");
> >>> -               return;
> >>> -       }
> >>> -       mvq->avail_idx =3D attr.available_index;
> >>>   }
> >>>
> >>>   static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> >>> --
> >>> 2.29.2
> >>>
>
