Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A54F30E72B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhBCXUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbhBCXUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 18:20:33 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F49BC061573;
        Wed,  3 Feb 2021 15:19:52 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id t5so1718096eds.12;
        Wed, 03 Feb 2021 15:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TBJSzXFYJBmrV0iibiMXRoDs3cCvbGe8O3cmeHWVSBY=;
        b=JCQXMBdUlsMoBgqqH/YpIB0a0fa87B+395I+R/ngqoxc7KMDPKYFXGyvU24+A/WmjB
         bR7jokxdQfdN6jGD+8sJw06p6OtdskKeUMUWPBNmXEIymCdRUHyebQmfdzFxWherPKYs
         XErQuR6Jsqmkha4ZBY6gAJowhi0yRnhi3ZVOu5x8DOFvuppPDznaZ5FlYrfMotiMHA7/
         YLbhZJeJaEt3KIPwZtjhVH7loypRVBmJtXnWWXK1Pr5hCcWoTSfSK/9YOLMNIp/8wiDy
         SMAk3VwtMWzJYK7Ba0z+DkqPbzaaekptFEmC1sN45u2AEfdum8Toj0SATjiJhyPfV9Kj
         XQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TBJSzXFYJBmrV0iibiMXRoDs3cCvbGe8O3cmeHWVSBY=;
        b=pscGEDuWQW0aieaGY6ebIG48iu+mqYEDNMA6RlqmGbV0Kfb1Ffea9RbSnPK5gzW7bu
         57FEmn+uQ7Iy2QW2eUnEsNw22SK4Y19c0i5++jbu81pPPtx8c8niJ7xW7CvuFFkyCejr
         tkBwPLUuAgm2HQ2pOQpXq5cqLcyn/MjlhUiVHakj34MGJTLDbCRaIPQz1oA0VGmMajUY
         6+AIkFlRhyi75irMHHehCSmbOVKDDBbfN09JTtnVWgvmHi5qzDAmJU5Ob9cMPnRqhHNj
         Cr4RijJ2Obd6VP5PBiooCvHzc/kV0r/XWz+sSAVZ3VAIV1fv+G0xqYfB/0ExbBKkJB/z
         7U4g==
X-Gm-Message-State: AOAM530lIJqfP3KUJU1oxR/eFEIAZ4OlmB04P8gpm/9SCamMdSPAHXAL
        mK460Z+hdokA4oN7Q0P2947U7SO528nun52gd10=
X-Google-Smtp-Source: ABdhPJzQhkoMjqOFAg1SXPEl07+HJNOeScobroYfS2l+7RZQUWmCGdG3rV8cSJKHNwwqE4bawogUORGa8ayRNs74jxo=
X-Received: by 2002:a05:6402:138e:: with SMTP id b14mr4521577edv.10.1612394391235;
 Wed, 03 Feb 2021 15:19:51 -0800 (PST)
MIME-Version: 1.0
References: <20210128134130.3051-1-elic@nvidia.com> <20210128134130.3051-2-elic@nvidia.com>
 <CAPWQSg0XtEQ1U5N3a767Ak_naoyPdVF1CeE4r3hmN11a-aoBxg@mail.gmail.com>
 <CAPWQSg3U9DCSK_01Kzuea5B1X+Ef9JB23wBY82A3ss-UXGek_Q@mail.gmail.com>
 <9d6058d6-5ce1-0442-8fd9-5a6fe6a0bc6b@redhat.com> <CAPWQSg3KOAypcrs9krW8cGE7EDLTehCUCYFZMUYYNaYPH1oBZQ@mail.gmail.com>
 <c65808bf-b336-8718-f7ea-b39fcc658dfb@redhat.com> <20210202070631.GA233234@mtl-vdi-166.wap.labs.mlnx>
 <CAPWQSg058RGaxSS7s5s=kpxdGryiy2padRFztUZtXN+ttiDd1A@mail.gmail.com>
 <20210202092253.GA236663@mtl-vdi-166.wap.labs.mlnx> <CAPWQSg0tRXoGF88LQSLzUg88ZEi8p+M=R6Qd445iABShfn-o4g@mail.gmail.com>
 <eed86e79-4fd9-dfcf-da17-288a3fc597e3@redhat.com>
In-Reply-To: <eed86e79-4fd9-dfcf-da17-288a3fc597e3@redhat.com>
From:   Si-Wei Liu <siwliu.kernel@gmail.com>
Date:   Wed, 3 Feb 2021 15:19:40 -0800
Message-ID: <CAPWQSg1=aXByZoR2eZj4rfak0CDxZF6GnLNsh-vMyqyERetQpw@mail.gmail.com>
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

On Tue, Feb 2, 2021 at 9:16 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/3 =E4=B8=8A=E5=8D=881:54, Si-Wei Liu wrote:
> > On Tue, Feb 2, 2021 at 1:23 AM Eli Cohen <elic@nvidia.com> wrote:
> >> On Tue, Feb 02, 2021 at 12:38:51AM -0800, Si-Wei Liu wrote:
> >>> Thanks Eli and Jason for clarifications. See inline.
> >>>
> >>> On Mon, Feb 1, 2021 at 11:06 PM Eli Cohen <elic@nvidia.com> wrote:
> >>>> On Tue, Feb 02, 2021 at 02:02:25PM +0800, Jason Wang wrote:
> >>>>> On 2021/2/2 =E4=B8=8B=E5=8D=8812:15, Si-Wei Liu wrote:
> >>>>>> On Mon, Feb 1, 2021 at 7:13 PM Jason Wang <jasowang@redhat.com> wr=
ote:
> >>>>>>> On 2021/2/2 =E4=B8=8A=E5=8D=883:17, Si-Wei Liu wrote:
> >>>>>>>> On Mon, Feb 1, 2021 at 10:51 AM Si-Wei Liu <siwliu.kernel@gmail.=
com> wrote:
> >>>>>>>>> On Thu, Jan 28, 2021 at 5:46 AM Eli Cohen <elic@nvidia.com> wro=
te:
> >>>>>>>>>> suspend_vq should only suspend the VQ on not save the current =
available
> >>>>>>>>>> index. This is done when a change of map occurs when the drive=
r calls
> >>>>>>>>>> save_channel_info().
> >>>>>>>>> Hmmm, suspend_vq() is also called by teardown_vq(), the latter =
of
> >>>>>>>>> which doesn't save the available index as save_channel_info() d=
oesn't
> >>>>>>>>> get called in that path at all. How does it handle the case tha=
t
> >>>>>>>>> aget_vq_state() is called from userspace (e.g. QEMU) while the
> >>>>>>>>> hardware VQ object was torn down, but userspace still wants to =
access
> >>>>>>>>> the queue index?
> >>>>>>>>>
> >>>>>>>>> Refer to https://lore.kernel.org/netdev/1601583511-15138-1-git-=
send-email-si-wei.liu@oracle.com/
> >>>>>>>>>
> >>>>>>>>> vhost VQ 0 ring restore failed: -1: Resource temporarily unavai=
lable (11)
> >>>>>>>>> vhost VQ 1 ring restore failed: -1: Resource temporarily unavai=
lable (11)
> >>>>>>>>>
> >>>>>>>>> QEMU will complain with the above warning while VM is being reb=
ooted
> >>>>>>>>> or shut down.
> >>>>>>>>>
> >>>>>>>>> Looks to me either the kernel driver should cover this requirem=
ent, or
> >>>>>>>>> the userspace has to bear the burden in saving the index and no=
t call
> >>>>>>>>> into kernel if VQ is destroyed.
> >>>>>>>> Actually, the userspace doesn't have the insights whether virt q=
ueue
> >>>>>>>> will be destroyed if just changing the device status via set_sta=
tus().
> >>>>>>>> Looking at other vdpa driver in tree i.e. ifcvf it doesn't behav=
e like
> >>>>>>>> so. Hence this still looks to me to be Mellanox specifics and
> >>>>>>>> mlx5_vdpa implementation detail that shouldn't expose to userspa=
ce.
> >>>>>>> So I think we can simply drop this patch?
> >>>>>> Yep, I think so. To be honest I don't know why it has anything to =
do
> >>>>>> with the memory hotplug issue.
> >>>>>
> >>>>> Eli may know more, my understanding is that, during memory hotplut,=
 qemu
> >>>>> need to propagate new memory mappings via set_map(). For mellanox, =
it means
> >>>>> it needs to rebuild memory keys, so the virtqueue needs to be suspe=
nded.
> >>>>>
> >>>> I think Siwei was asking why the first patch was related to the hotp=
lug
> >>>> issue.
> >>> I was thinking how consistency is assured when saving/restoring this
> >>> h/w avail_index against the one in the virtq memory, particularly in
> >>> the region_add/.region_del() context (e.g. the hotplug case). Problem
> >>> is I don't see explicit memory barrier when guest thread updates the
> >>> avail_index, how does the device make sure the h/w avail_index is
> >>> uptodate while guest may race with updating the virtq's avail_index i=
n
> >>> the mean while? Maybe I completely miss something obvious?
> >> DKIM-Signature: v1; arsa-sha256; crelaxed/relaxed; dnvidia.com; sn1;
> >>          t 12257780; bhHnB0z4VEKwRS3WGY8d836MJgxu5Eln/jbFZlNXVxc08;
> >>          hX-PGP-Universal:Date:From:To:CC:Subject:Message-ID:Reference=
s:
> >>           MIME-Version:Content-Type:Content-Disposition:
> >>           Content-Transfer-Encoding:In-Reply-To:User-Agent:X-Originati=
ng-IP:
> >>           X-ClientProxiedBy;
> >>          bgGmb8+rcn3/rKzKQ/7QzSnghWzZ+FAU0XntsRZYGQ66sFvT7zsYPHogG3LIW=
NY77t
> >>           wNHPw7GCJrNaH3nEXPbOp0FMOZw4Kv4W7UPuYPobbLeTkvuPAidjB8dM42vz=
+1X61t
> >>           9IVQT9X4hnAxRjI5CqZOo41GS4Tl1X+ykGoA+VE80BR/R/+nQ3tXDVULfppz=
eB+vu3
> >>           TWnnpaZ2GyoNyPlMiyVRkHdXzDVgA4uQHxwHn7otGK5J4lzyu8KrFyQtiP+f=
6hfu5v
> >>           crJkYS8e9A+rfzUmKWuyHcKcmhPhAVJ4XdpzZcDXXlMHVxG7nR1o88xttC6D=
1+oNIP
> >>           9xHI3DkNBpEuA
> >> If you're asking about syncronization upon hot plug of memory, the
> >> hardware always goes to read the available index from memory when a ne=
w
> >> hardware object is associted with a virtqueue. You can argue then that
> >> you don't need to restore the available index and you may be right but
> >> this is the currect inteface to the firmware.
> >>
> >>
> >> If you're asking on generally how sync is assured when the guest updat=
es
> >> the available index, can you please send a pointer to the code where y=
ou
> >> see the update without a memory barrier?
> > This is a snippet of virtqueue_add_split() where avail_index gets
> > updated by guest:
> >
> >          /* Put entry in available array (but don't update avail->idx u=
ntil they
> >           * do sync). */
> >          avail =3D vq->split.avail_idx_shadow & (vq->split.vring.num - =
1);
> >          vq->split.vring.avail->ring[avail] =3D cpu_to_virtio16(_vq->vd=
ev, head);
> >
> >          /* Descriptors and available array need to be set before we ex=
pose the
> >           * new available array entries. */
> >          virtio_wmb(vq->weak_barriers);
> >          vq->split.avail_idx_shadow++;
> >          vq->split.vring.avail->idx =3D cpu_to_virtio16(_vq->vdev,
> >                                                  vq->split.avail_idx_sh=
adow);
> >          vq->num_added++;
> >
> > There's memory barrier to make sure the update to descriptor and
> > available ring is seen before writing to the avail->idx, but there
> > seems no gurantee that this update would flush to the memory
> > immmedately either before or after the mlx5-vdpa is suspened and gets
> > the old avail_index value stashed somewhere. In this case, how does
> > the hardware ensure the consistency between the guest virtio and host
> > mlx5-vdpa? Or, it completly relies on guest to update the avail_index
> > once the next buffer is available, so that the index will be in sync
> > again?
>
>
> I'm not sure I get the question but notice that the driver should check
> and notify virtqueue when device want a notification. So there's a
> virtio_wmb() e.g in:
>
> static bool virtqueue_kick_prepare_split(struct virtqueue *_vq)
> {
>      struct vring_virtqueue *vq =3D to_vvq(_vq);
>      u16 new, old;
>      bool needs_kick;
>
>      START_USE(vq);
>      /* We need to expose available array entries before checking avail
>       * event. */
>      virtio_mb(vq->weak_barries);
>
>      old =3D vq->split.avail_idx_shadow - vq->num_added;
>      new =3D vq->split.avail_idx_shadow;
>      vq->num_added =3D 0;
>
> (See the comment above virtio_mb()). So the avail idx is guaranteed to
> be committed to memroy(cache hierarchy) before the check of
> notification. I think we sync through this.

Thanks for pointing it out! Indeed, the avail index is synced before
kicking the device. However, even so I think the race might still be
possible, see below:


  mlx5_vdpa device                       virtio driver
-------------------------------------------------------------------------
                                  virtqueue_add_split
                                    (bumped up avail_idx1 to
                                    avail_idx2, but update
                                    not yet committed to mem)

(hot plug memory...)
mlx5_vdpa_set_map
  mlx5_vdpa_change_map
    suspend_vqs
      suspend_vq
        (avail_idx1 was saved)
    save_channels_info
    :
    :                             virtqueue_kick_prepare_split
    :                               (avail_idx2 committed to memory)
    restore_channels_info
    setup_driver
      ...
        create_virtqueue
          (saved avail_idx1
          getting restored;
          whereas current
          avail_idx2 in
          memory is ignored)
:
:
                                   virtqueue_notify
                                     vp_notify
mlx5_vdpa_kick_vq
  (device processing up to
  avail_idx1 rather than
  avail_idx2?)


According to Eli, the vdpa firmware does not load the latest value,
i.e. avail_idx2 from memory when re-creating the virtqueue object.
Instead it starts with a stale avail_idx1 that was saved in mlx5_vdpa
driver private structure before the memory update is made. That is the
way how the current firmware interface is designed. The thing I'm not
sure though is if the firmware/device will resync and get to the
latest avail_idx2 from memory while processing the kick request with
mlx5_vdpa_kick_vq? If not, a few avail entries will be missing in the
kick, which could cause odd behavior or implicit failure.

But if the firmware will resync on kick_vq (and get_vq_state), I think
I completely lost the point of saving and restoring avail_idx when
changing the memory map...

Thanks,
-Siwei

>
> Thanks
>
>
> >
> > Thanks,
> > -Siwei
> >
> >>> Thanks,
> >>> -Siwei
> >>>
> >>>> But you're correct. When memory is added, I get a new memory map. Th=
is
> >>>> requires me to build a new memory key object which covers the new me=
mory
> >>>> map. Since the virtqueue objects are referencing this memory key, I =
need
> >>>> to destroy them and build new ones referncing the new memory key.
> >>>>
> >>>>> Thanks
> >>>>>
> >>>>>
> >>>>>> -Siwei
> >>>>>>
> >>>>>>> Thanks
> >>>>>>>
> >>>>>>>
> >>>>>>>>> -Siwei
> >>>>>>>>>
> >>>>>>>>>
> >>>>>>>>>> Signed-off-by: Eli Cohen <elic@nvidia.com>
> >>>>>>>>>> ---
> >>>>>>>>>>     drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
> >>>>>>>>>>     1 file changed, 8 deletions(-)
> >>>>>>>>>>
> >>>>>>>>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/=
mlx5/net/mlx5_vnet.c
> >>>>>>>>>> index 88dde3455bfd..549ded074ff3 100644
> >>>>>>>>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> >>>>>>>>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> >>>>>>>>>> @@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdpa_net=
 *ndev, struct mlx5_vdpa_virtqueue *mvq)
> >>>>>>>>>>
> >>>>>>>>>>     static void suspend_vq(struct mlx5_vdpa_net *ndev, struct =
mlx5_vdpa_virtqueue *mvq)
> >>>>>>>>>>     {
> >>>>>>>>>> -       struct mlx5_virtq_attr attr;
> >>>>>>>>>> -
> >>>>>>>>>>            if (!mvq->initialized)
> >>>>>>>>>>                    return;
> >>>>>>>>>>
> >>>>>>>>>> @@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5_vdpa=
_net *ndev, struct mlx5_vdpa_virtqueue *m
> >>>>>>>>>>
> >>>>>>>>>>            if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_O=
BJECT_STATE_SUSPEND))
> >>>>>>>>>>                    mlx5_vdpa_warn(&ndev->mvdev, "modify to sus=
pend failed\n");
> >>>>>>>>>> -
> >>>>>>>>>> -       if (query_virtqueue(ndev, mvq, &attr)) {
> >>>>>>>>>> -               mlx5_vdpa_warn(&ndev->mvdev, "failed to query =
virtqueue\n");
> >>>>>>>>>> -               return;
> >>>>>>>>>> -       }
> >>>>>>>>>> -       mvq->avail_idx =3D attr.available_index;
> >>>>>>>>>>     }
> >>>>>>>>>>
> >>>>>>>>>>     static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> >>>>>>>>>> --
> >>>>>>>>>> 2.29.2
> >>>>>>>>>>
>
