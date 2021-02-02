Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8771530C8B4
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238078AbhBBR55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237886AbhBBRyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 12:54:55 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B269FC06178C;
        Tue,  2 Feb 2021 09:54:15 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id l12so21435619wry.2;
        Tue, 02 Feb 2021 09:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CJyHdLKM3KKlD0L2BTz6ZRZkRawk3i7fIdk2ltQBhgQ=;
        b=KhEXaUZLl7VRD+fZCHudvwEBlLIRqtBIbeNk60XG7hoos16ZR0lDtdvn903vyLCe7L
         LNMyrhbAWycofkBilzQBXDcKlxE7JNga/hHPNGhNJ+lwR9FQxe5hO5J9NciOZkK/uYKK
         bGnOtM+Sg9WA6glbdE5GyL2wNrImbf0bYmvbtD5GNvtjWqQWCZuoMQFh//26HaTk3s5b
         OkgfVWo1Bp3MXHVuGG4j7ZK2m09Sh/+1+xDlx+UUTj1od3LCVHix1UcnuFFpGcG0gZVF
         gRXQVVrsFxKjbhBQyp36dghvI28r3Nd1hf7aeZO7rmZ19xsrtTZ68Ul8RK1yKTDV47NS
         DdWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CJyHdLKM3KKlD0L2BTz6ZRZkRawk3i7fIdk2ltQBhgQ=;
        b=R/iqvWRLlrgCrN5rBc09TaWMtNmgAn2xgyOTSihnnOE0IWfQ6/1/79R/heOcntaG9w
         nYH6hfO1CUbFfE3nlooVRy/3knDySRhRhqUuFhEQ2Xj9WMOo6iUk1fvGyb+siOkvsKEn
         4dxh7KpV7F6lSAG1WykPZ1NzOOUsDhTX2cEmWhGDPaggJrexyaSAhJzhCQZoPfINK/f6
         L1L2GCCdTUShS0AQqObZO3tl46OsqOMzSYmDCzSDJgJ5fr3y1+Hh7PhldKNAWosRwaxq
         Ip8W8VOUZH0k06ITb5ixHZtIrnce/VAnSEOKzL7TwKNOL7Ksd1lTpxwRw5ydBDdnDeov
         y/SA==
X-Gm-Message-State: AOAM5320MtkyaOjycPOuUQ2LEUpOZcHy0WDHsOfA5EiXall/u6L+cpFi
        zJJBBATT14WLayAM74eYf0B8pRBDnh3liYfn2hc=
X-Google-Smtp-Source: ABdhPJyRQrR0eOd4kqTsOJnb6c1RpDnW2FDLIgNNMt8KEH3j0eupO8ShjmZP8Z+eJXt2vpA80TvvuICO3X5ERvIqxO8=
X-Received: by 2002:a5d:5502:: with SMTP id b2mr25035724wrv.245.1612288454444;
 Tue, 02 Feb 2021 09:54:14 -0800 (PST)
MIME-Version: 1.0
References: <20210128134130.3051-1-elic@nvidia.com> <20210128134130.3051-2-elic@nvidia.com>
 <CAPWQSg0XtEQ1U5N3a767Ak_naoyPdVF1CeE4r3hmN11a-aoBxg@mail.gmail.com>
 <CAPWQSg3U9DCSK_01Kzuea5B1X+Ef9JB23wBY82A3ss-UXGek_Q@mail.gmail.com>
 <9d6058d6-5ce1-0442-8fd9-5a6fe6a0bc6b@redhat.com> <CAPWQSg3KOAypcrs9krW8cGE7EDLTehCUCYFZMUYYNaYPH1oBZQ@mail.gmail.com>
 <c65808bf-b336-8718-f7ea-b39fcc658dfb@redhat.com> <20210202070631.GA233234@mtl-vdi-166.wap.labs.mlnx>
 <CAPWQSg058RGaxSS7s5s=kpxdGryiy2padRFztUZtXN+ttiDd1A@mail.gmail.com> <20210202092253.GA236663@mtl-vdi-166.wap.labs.mlnx>
In-Reply-To: <20210202092253.GA236663@mtl-vdi-166.wap.labs.mlnx>
From:   Si-Wei Liu <siwliu.kernel@gmail.com>
Date:   Tue, 2 Feb 2021 09:54:00 -0800
Message-ID: <CAPWQSg0tRXoGF88LQSLzUg88ZEi8p+M=R6Qd445iABShfn-o4g@mail.gmail.com>
Subject: Re: [PATCH 1/2] vdpa/mlx5: Avoid unnecessary query virtqueue
To:     Eli Cohen <elic@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com,
        Si-Wei Liu <si-wei.liu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 1:23 AM Eli Cohen <elic@nvidia.com> wrote:
>
> On Tue, Feb 02, 2021 at 12:38:51AM -0800, Si-Wei Liu wrote:
> > Thanks Eli and Jason for clarifications. See inline.
> >
> > On Mon, Feb 1, 2021 at 11:06 PM Eli Cohen <elic@nvidia.com> wrote:
> > >
> > > On Tue, Feb 02, 2021 at 02:02:25PM +0800, Jason Wang wrote:
> > > >
> > > > On 2021/2/2 =E4=B8=8B=E5=8D=8812:15, Si-Wei Liu wrote:
> > > > > On Mon, Feb 1, 2021 at 7:13 PM Jason Wang <jasowang@redhat.com> w=
rote:
> > > > > >
> > > > > > On 2021/2/2 =E4=B8=8A=E5=8D=883:17, Si-Wei Liu wrote:
> > > > > > > On Mon, Feb 1, 2021 at 10:51 AM Si-Wei Liu <siwliu.kernel@gma=
il.com> wrote:
> > > > > > > > On Thu, Jan 28, 2021 at 5:46 AM Eli Cohen <elic@nvidia.com>=
 wrote:
> > > > > > > > > suspend_vq should only suspend the VQ on not save the cur=
rent available
> > > > > > > > > index. This is done when a change of map occurs when the =
driver calls
> > > > > > > > > save_channel_info().
> > > > > > > > Hmmm, suspend_vq() is also called by teardown_vq(), the lat=
ter of
> > > > > > > > which doesn't save the available index as save_channel_info=
() doesn't
> > > > > > > > get called in that path at all. How does it handle the case=
 that
> > > > > > > > aget_vq_state() is called from userspace (e.g. QEMU) while =
the
> > > > > > > > hardware VQ object was torn down, but userspace still wants=
 to access
> > > > > > > > the queue index?
> > > > > > > >
> > > > > > > > Refer to https://lore.kernel.org/netdev/1601583511-15138-1-=
git-send-email-si-wei.liu@oracle.com/
> > > > > > > >
> > > > > > > > vhost VQ 0 ring restore failed: -1: Resource temporarily un=
available (11)
> > > > > > > > vhost VQ 1 ring restore failed: -1: Resource temporarily un=
available (11)
> > > > > > > >
> > > > > > > > QEMU will complain with the above warning while VM is being=
 rebooted
> > > > > > > > or shut down.
> > > > > > > >
> > > > > > > > Looks to me either the kernel driver should cover this requ=
irement, or
> > > > > > > > the userspace has to bear the burden in saving the index an=
d not call
> > > > > > > > into kernel if VQ is destroyed.
> > > > > > > Actually, the userspace doesn't have the insights whether vir=
t queue
> > > > > > > will be destroyed if just changing the device status via set_=
status().
> > > > > > > Looking at other vdpa driver in tree i.e. ifcvf it doesn't be=
have like
> > > > > > > so. Hence this still looks to me to be Mellanox specifics and
> > > > > > > mlx5_vdpa implementation detail that shouldn't expose to user=
space.
> > > > > >
> > > > > > So I think we can simply drop this patch?
> > > > > Yep, I think so. To be honest I don't know why it has anything to=
 do
> > > > > with the memory hotplug issue.
> > > >
> > > >
> > > > Eli may know more, my understanding is that, during memory hotplut,=
 qemu
> > > > need to propagate new memory mappings via set_map(). For mellanox, =
it means
> > > > it needs to rebuild memory keys, so the virtqueue needs to be suspe=
nded.
> > > >
> > >
> > > I think Siwei was asking why the first patch was related to the hotpl=
ug
> > > issue.
> >
> > I was thinking how consistency is assured when saving/restoring this
> > h/w avail_index against the one in the virtq memory, particularly in
> > the region_add/.region_del() context (e.g. the hotplug case). Problem
> > is I don't see explicit memory barrier when guest thread updates the
> > avail_index, how does the device make sure the h/w avail_index is
> > uptodate while guest may race with updating the virtq's avail_index in
> > the mean while? Maybe I completely miss something obvious?
> DKIM-Signature: v1; arsa-sha256; crelaxed/relaxed; dnvidia.com; sn1;
>         t 12257780; bhHnB0z4VEKwRS3WGY8d836MJgxu5Eln/jbFZlNXVxc08;
>         hX-PGP-Universal:Date:From:To:CC:Subject:Message-ID:References:
>          MIME-Version:Content-Type:Content-Disposition:
>          Content-Transfer-Encoding:In-Reply-To:User-Agent:X-Originating-I=
P:
>          X-ClientProxiedBy;
>         bgGmb8+rcn3/rKzKQ/7QzSnghWzZ+FAU0XntsRZYGQ66sFvT7zsYPHogG3LIWNY77=
t
>          wNHPw7GCJrNaH3nEXPbOp0FMOZw4Kv4W7UPuYPobbLeTkvuPAidjB8dM42vz+1X6=
1t
>          9IVQT9X4hnAxRjI5CqZOo41GS4Tl1X+ykGoA+VE80BR/R/+nQ3tXDVULfppzeB+v=
u3
>          TWnnpaZ2GyoNyPlMiyVRkHdXzDVgA4uQHxwHn7otGK5J4lzyu8KrFyQtiP+f6hfu=
5v
>          crJkYS8e9A+rfzUmKWuyHcKcmhPhAVJ4XdpzZcDXXlMHVxG7nR1o88xttC6D1+oN=
IP
>          9xHI3DkNBpEuA
> If you're asking about syncronization upon hot plug of memory, the
> hardware always goes to read the available index from memory when a new
> hardware object is associted with a virtqueue. You can argue then that
> you don't need to restore the available index and you may be right but
> this is the currect inteface to the firmware.
>
>
> If you're asking on generally how sync is assured when the guest updates
> the available index, can you please send a pointer to the code where you
> see the update without a memory barrier?

This is a snippet of virtqueue_add_split() where avail_index gets
updated by guest:

        /* Put entry in available array (but don't update avail->idx until =
they
         * do sync). */
        avail =3D vq->split.avail_idx_shadow & (vq->split.vring.num - 1);
        vq->split.vring.avail->ring[avail] =3D cpu_to_virtio16(_vq->vdev, h=
ead);

        /* Descriptors and available array need to be set before we expose =
the
         * new available array entries. */
        virtio_wmb(vq->weak_barriers);
        vq->split.avail_idx_shadow++;
        vq->split.vring.avail->idx =3D cpu_to_virtio16(_vq->vdev,
                                                vq->split.avail_idx_shadow)=
;
        vq->num_added++;

There's memory barrier to make sure the update to descriptor and
available ring is seen before writing to the avail->idx, but there
seems no gurantee that this update would flush to the memory
immmedately either before or after the mlx5-vdpa is suspened and gets
the old avail_index value stashed somewhere. In this case, how does
the hardware ensure the consistency between the guest virtio and host
mlx5-vdpa? Or, it completly relies on guest to update the avail_index
once the next buffer is available, so that the index will be in sync
again?

Thanks,
-Siwei

>
> >
> > Thanks,
> > -Siwei
> >
> > >
> > > But you're correct. When memory is added, I get a new memory map. Thi=
s
> > > requires me to build a new memory key object which covers the new mem=
ory
> > > map. Since the virtqueue objects are referencing this memory key, I n=
eed
> > > to destroy them and build new ones referncing the new memory key.
> > >
> > > > Thanks
> > > >
> > > >
> > > > >
> > > > > -Siwei
> > > > >
> > > > > > Thanks
> > > > > >
> > > > > >
> > > > > > > > -Siwei
> > > > > > > >
> > > > > > > >
> > > > > > > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > > > > > > > ---
> > > > > > > > >    drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
> > > > > > > > >    1 file changed, 8 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/=
vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > index 88dde3455bfd..549ded074ff3 100644
> > > > > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > @@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdp=
a_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
> > > > > > > > >
> > > > > > > > >    static void suspend_vq(struct mlx5_vdpa_net *ndev, str=
uct mlx5_vdpa_virtqueue *mvq)
> > > > > > > > >    {
> > > > > > > > > -       struct mlx5_virtq_attr attr;
> > > > > > > > > -
> > > > > > > > >           if (!mvq->initialized)
> > > > > > > > >                   return;
> > > > > > > > >
> > > > > > > > > @@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5=
_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
> > > > > > > > >
> > > > > > > > >           if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET=
_Q_OBJECT_STATE_SUSPEND))
> > > > > > > > >                   mlx5_vdpa_warn(&ndev->mvdev, "modify to=
 suspend failed\n");
> > > > > > > > > -
> > > > > > > > > -       if (query_virtqueue(ndev, mvq, &attr)) {
> > > > > > > > > -               mlx5_vdpa_warn(&ndev->mvdev, "failed to q=
uery virtqueue\n");
> > > > > > > > > -               return;
> > > > > > > > > -       }
> > > > > > > > > -       mvq->avail_idx =3D attr.available_index;
> > > > > > > > >    }
> > > > > > > > >
> > > > > > > > >    static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> > > > > > > > > --
> > > > > > > > > 2.29.2
> > > > > > > > >
> > > >
