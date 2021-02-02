Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3399030BA1B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 09:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhBBIjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 03:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbhBBIjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 03:39:45 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76C1C06174A;
        Tue,  2 Feb 2021 00:39:04 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id hs11so28661304ejc.1;
        Tue, 02 Feb 2021 00:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ui9lznfxgKd0EC8YqWskEdihBiSGTU2gHSqzSd+HKFs=;
        b=i5UP6Jkk8Z9BlsbbnvcyM+YyuKwxw3DcYSSNYQt7Su7er+pK3qIKEafV07fTdobzbU
         +GNAcimbHicXp14xMjRSV+QvQCgpy8mRMHciCeimVfHO3IoaocIY9oeyuZEIBlJ+q7gL
         1j8A04ovh9MuGT3fhmSQ7fPYM1CZruZPmHjPXV5xZDyHaIict/SuIiTGI73dDRyOMUbJ
         wOSUayGbVhrtty6CdYuAToceMTjPuPG8XWDr5RbCKg4NenVqG2FwlKIRG+Q9O03pKpY9
         TZsxedv+uqcVk2Oiy//BThSC+NU4aC+1GuDO4HHgYTXHwoQwXRdRADZd8rcHHpK0OmI+
         A9bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ui9lznfxgKd0EC8YqWskEdihBiSGTU2gHSqzSd+HKFs=;
        b=WCTo5GOGnGI+44xT9F1arzvw1ZYqMwbQPoo15xyy2YKkcXv1HmhSuS61j9PQWCC/6g
         RVp9HsLs9ybtDKx1ulUxqzAwdg9x60XQHllwkVPfnqBWO2ka3s4KAr+NH+7KQM9BoAd2
         h3p2hzOlHTl4HPTLSS3DcSatxA6VrOVryLZUXWwv/Y+5OEptmAhkXZ2zfIUU9CpF8Ity
         KGNhTri30FvQnCueiWGFTFCqFFBv+34a2l3muBs8nqW6VEAem+reRtBbsNbehkLC4qH8
         WvXbZyNjLY+1bu/kH2I13N5cCpDXZAg9h5vFc2o6XmPalDdPpQi7CfaqNIU+RnX6JKTQ
         spTQ==
X-Gm-Message-State: AOAM530YlxZD8v2jB/4TWcBnGj5y/n9BsJvN5KYZCBJZDJjMxyT7TkeX
        5HPBx+5LvLMyMxusZZT2mPY/osKbIhc/Pbj4BUs=
X-Google-Smtp-Source: ABdhPJzzbclUVootDxjXUEHOPNkNnKokxDkBBVmwAGgrLROBWz6vJwvV31Ew0ihZJPjoFF3puw2CWoMw5JoC0IIzDLg=
X-Received: by 2002:a17:906:4707:: with SMTP id y7mr9589812ejq.445.1612255143616;
 Tue, 02 Feb 2021 00:39:03 -0800 (PST)
MIME-Version: 1.0
References: <20210128134130.3051-1-elic@nvidia.com> <20210128134130.3051-2-elic@nvidia.com>
 <CAPWQSg0XtEQ1U5N3a767Ak_naoyPdVF1CeE4r3hmN11a-aoBxg@mail.gmail.com>
 <CAPWQSg3U9DCSK_01Kzuea5B1X+Ef9JB23wBY82A3ss-UXGek_Q@mail.gmail.com>
 <9d6058d6-5ce1-0442-8fd9-5a6fe6a0bc6b@redhat.com> <CAPWQSg3KOAypcrs9krW8cGE7EDLTehCUCYFZMUYYNaYPH1oBZQ@mail.gmail.com>
 <c65808bf-b336-8718-f7ea-b39fcc658dfb@redhat.com> <20210202070631.GA233234@mtl-vdi-166.wap.labs.mlnx>
In-Reply-To: <20210202070631.GA233234@mtl-vdi-166.wap.labs.mlnx>
From:   Si-Wei Liu <siwliu.kernel@gmail.com>
Date:   Tue, 2 Feb 2021 00:38:51 -0800
Message-ID: <CAPWQSg058RGaxSS7s5s=kpxdGryiy2padRFztUZtXN+ttiDd1A@mail.gmail.com>
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

Thanks Eli and Jason for clarifications. See inline.

On Mon, Feb 1, 2021 at 11:06 PM Eli Cohen <elic@nvidia.com> wrote:
>
> On Tue, Feb 02, 2021 at 02:02:25PM +0800, Jason Wang wrote:
> >
> > On 2021/2/2 =E4=B8=8B=E5=8D=8812:15, Si-Wei Liu wrote:
> > > On Mon, Feb 1, 2021 at 7:13 PM Jason Wang <jasowang@redhat.com> wrote=
:
> > > >
> > > > On 2021/2/2 =E4=B8=8A=E5=8D=883:17, Si-Wei Liu wrote:
> > > > > On Mon, Feb 1, 2021 at 10:51 AM Si-Wei Liu <siwliu.kernel@gmail.c=
om> wrote:
> > > > > > On Thu, Jan 28, 2021 at 5:46 AM Eli Cohen <elic@nvidia.com> wro=
te:
> > > > > > > suspend_vq should only suspend the VQ on not save the current=
 available
> > > > > > > index. This is done when a change of map occurs when the driv=
er calls
> > > > > > > save_channel_info().
> > > > > > Hmmm, suspend_vq() is also called by teardown_vq(), the latter =
of
> > > > > > which doesn't save the available index as save_channel_info() d=
oesn't
> > > > > > get called in that path at all. How does it handle the case tha=
t
> > > > > > aget_vq_state() is called from userspace (e.g. QEMU) while the
> > > > > > hardware VQ object was torn down, but userspace still wants to =
access
> > > > > > the queue index?
> > > > > >
> > > > > > Refer to https://lore.kernel.org/netdev/1601583511-15138-1-git-=
send-email-si-wei.liu@oracle.com/
> > > > > >
> > > > > > vhost VQ 0 ring restore failed: -1: Resource temporarily unavai=
lable (11)
> > > > > > vhost VQ 1 ring restore failed: -1: Resource temporarily unavai=
lable (11)
> > > > > >
> > > > > > QEMU will complain with the above warning while VM is being reb=
ooted
> > > > > > or shut down.
> > > > > >
> > > > > > Looks to me either the kernel driver should cover this requirem=
ent, or
> > > > > > the userspace has to bear the burden in saving the index and no=
t call
> > > > > > into kernel if VQ is destroyed.
> > > > > Actually, the userspace doesn't have the insights whether virt qu=
eue
> > > > > will be destroyed if just changing the device status via set_stat=
us().
> > > > > Looking at other vdpa driver in tree i.e. ifcvf it doesn't behave=
 like
> > > > > so. Hence this still looks to me to be Mellanox specifics and
> > > > > mlx5_vdpa implementation detail that shouldn't expose to userspac=
e.
> > > >
> > > > So I think we can simply drop this patch?
> > > Yep, I think so. To be honest I don't know why it has anything to do
> > > with the memory hotplug issue.
> >
> >
> > Eli may know more, my understanding is that, during memory hotplut, qem=
u
> > need to propagate new memory mappings via set_map(). For mellanox, it m=
eans
> > it needs to rebuild memory keys, so the virtqueue needs to be suspended=
.
> >
>
> I think Siwei was asking why the first patch was related to the hotplug
> issue.

I was thinking how consistency is assured when saving/restoring this
h/w avail_index against the one in the virtq memory, particularly in
the region_add/.region_del() context (e.g. the hotplug case). Problem
is I don't see explicit memory barrier when guest thread updates the
avail_index, how does the device make sure the h/w avail_index is
uptodate while guest may race with updating the virtq's avail_index in
the mean while? Maybe I completely miss something obvious?

Thanks,
-Siwei

>
> But you're correct. When memory is added, I get a new memory map. This
> requires me to build a new memory key object which covers the new memory
> map. Since the virtqueue objects are referencing this memory key, I need
> to destroy them and build new ones referncing the new memory key.
>
> > Thanks
> >
> >
> > >
> > > -Siwei
> > >
> > > > Thanks
> > > >
> > > >
> > > > > > -Siwei
> > > > > >
> > > > > >
> > > > > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > > > > > ---
> > > > > > >    drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
> > > > > > >    1 file changed, 8 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa=
/mlx5/net/mlx5_vnet.c
> > > > > > > index 88dde3455bfd..549ded074ff3 100644
> > > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > @@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdpa_ne=
t *ndev, struct mlx5_vdpa_virtqueue *mvq)
> > > > > > >
> > > > > > >    static void suspend_vq(struct mlx5_vdpa_net *ndev, struct =
mlx5_vdpa_virtqueue *mvq)
> > > > > > >    {
> > > > > > > -       struct mlx5_virtq_attr attr;
> > > > > > > -
> > > > > > >           if (!mvq->initialized)
> > > > > > >                   return;
> > > > > > >
> > > > > > > @@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5_vdp=
a_net *ndev, struct mlx5_vdpa_virtqueue *m
> > > > > > >
> > > > > > >           if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_O=
BJECT_STATE_SUSPEND))
> > > > > > >                   mlx5_vdpa_warn(&ndev->mvdev, "modify to sus=
pend failed\n");
> > > > > > > -
> > > > > > > -       if (query_virtqueue(ndev, mvq, &attr)) {
> > > > > > > -               mlx5_vdpa_warn(&ndev->mvdev, "failed to query=
 virtqueue\n");
> > > > > > > -               return;
> > > > > > > -       }
> > > > > > > -       mvq->avail_idx =3D attr.available_index;
> > > > > > >    }
> > > > > > >
> > > > > > >    static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> > > > > > > --
> > > > > > > 2.29.2
> > > > > > >
> >
