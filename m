Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D4F30B03B
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhBATSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhBATSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:18:31 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABEAC061573;
        Mon,  1 Feb 2021 11:17:50 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id c4so15157205wru.9;
        Mon, 01 Feb 2021 11:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3fBmlBfS57862/YF+WQQY5rkDHUDDCvuVnlROpTuekI=;
        b=IDfadfEQtEXbBVg8PJZHUS2k1gwUj6j9QMA+njtCOluyx1dBGMnU+YdHFzlk2OIDTY
         +Xn+ldfDwNlKnoujIH6HvFrKqN7S27WAODtJntIfNHcvFS5AI6SIppsXe56nJ3iMdY/E
         OG5F6I4eXHVUmupcy17+fx6MN3YCQPs+Uet+QT02WQWsIdkzPugzg83YWLslWl2l0/it
         wSG7iOa0jVJ/CyW2xDYFDVJ39ct2lqHO7Lh5bleQlxr17K8GZCA/24GJqWWomnPd87YB
         R2aW4s3ntLCLRbU9ODlfDYl6tgZbOKz2B8p9ALEZvHQUMmjKMpXZvRJlXcA5ia8N7B12
         +wgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3fBmlBfS57862/YF+WQQY5rkDHUDDCvuVnlROpTuekI=;
        b=PW+ySHOz0Bl5QTLxnlute8A2WIyb6uTLn4MRrQx7s2XJnkIFF9fEDI8vACcrM/J4wA
         NrotrC2rpGk1FD2HCPNBEtaRIcJYRAKxVFsfbDNFXQSEtRxW2d3imIJWwTGDkz7UYfGW
         MVH8SAaI2MMkDmIiNM2maAO6HV52M0WMAJMwBT6qMkVZtLohMnnRim2qCnHQRcyExJkN
         9yGMuZH2xZztzM/ntxKZtBGuWx8sfMexZ6ae+e4AHAq7IwmtNIP8F9oDSm9R8LKjbzd5
         8P/359S8feHQDagB3yyPr9HkmqSEuFcQahL/PnvytSPTyDQwv3M3z8v9honcvW59gNAY
         /lbw==
X-Gm-Message-State: AOAM531FQMgcd56VOE6jIvaZhNtw1hEkhnzT/Vhsz+UPw1ZdPdJzhXUP
        HV1qb3Rexs6/TSo/07imERXxM9juauqK2ytNT00=
X-Google-Smtp-Source: ABdhPJwV6pESr8EYeKLJgtMN2DoSyEP+Jpyj0mBOWD5+7I+/szpICR184OQKmrO1jZuiUHSUq/pxmEaGi56efk6QcSM=
X-Received: by 2002:adf:f182:: with SMTP id h2mr19764072wro.355.1612207069428;
 Mon, 01 Feb 2021 11:17:49 -0800 (PST)
MIME-Version: 1.0
References: <20210128134130.3051-1-elic@nvidia.com> <20210128134130.3051-2-elic@nvidia.com>
 <CAPWQSg0XtEQ1U5N3a767Ak_naoyPdVF1CeE4r3hmN11a-aoBxg@mail.gmail.com>
In-Reply-To: <CAPWQSg0XtEQ1U5N3a767Ak_naoyPdVF1CeE4r3hmN11a-aoBxg@mail.gmail.com>
From:   Si-Wei Liu <siwliu.kernel@gmail.com>
Date:   Mon, 1 Feb 2021 11:17:37 -0800
Message-ID: <CAPWQSg3U9DCSK_01Kzuea5B1X+Ef9JB23wBY82A3ss-UXGek_Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] vdpa/mlx5: Avoid unnecessary query virtqueue
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com,
        Si-Wei Liu <si-wei.liu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 10:51 AM Si-Wei Liu <siwliu.kernel@gmail.com> wrote:
>
> On Thu, Jan 28, 2021 at 5:46 AM Eli Cohen <elic@nvidia.com> wrote:
> >
> > suspend_vq should only suspend the VQ on not save the current available
> > index. This is done when a change of map occurs when the driver calls
> > save_channel_info().
>
> Hmmm, suspend_vq() is also called by teardown_vq(), the latter of
> which doesn't save the available index as save_channel_info() doesn't
> get called in that path at all. How does it handle the case that
> aget_vq_state() is called from userspace (e.g. QEMU) while the
> hardware VQ object was torn down, but userspace still wants to access
> the queue index?
>
> Refer to https://lore.kernel.org/netdev/1601583511-15138-1-git-send-email-si-wei.liu@oracle.com/
>
> vhost VQ 0 ring restore failed: -1: Resource temporarily unavailable (11)
> vhost VQ 1 ring restore failed: -1: Resource temporarily unavailable (11)
>
> QEMU will complain with the above warning while VM is being rebooted
> or shut down.
>
> Looks to me either the kernel driver should cover this requirement, or
> the userspace has to bear the burden in saving the index and not call
> into kernel if VQ is destroyed.

Actually, the userspace doesn't have the insights whether virt queue
will be destroyed if just changing the device status via set_status().
Looking at other vdpa driver in tree i.e. ifcvf it doesn't behave like
so. Hence this still looks to me to be Mellanox specifics and
mlx5_vdpa implementation detail that shouldn't expose to userspace.
>
> -Siwei
>
>
> >
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
> >  1 file changed, 8 deletions(-)
> >
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 88dde3455bfd..549ded074ff3 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
> >
> >  static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
> >  {
> > -       struct mlx5_virtq_attr attr;
> > -
> >         if (!mvq->initialized)
> >                 return;
> >
> > @@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
> >
> >         if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
> >                 mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
> > -
> > -       if (query_virtqueue(ndev, mvq, &attr)) {
> > -               mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
> > -               return;
> > -       }
> > -       mvq->avail_idx = attr.available_index;
> >  }
> >
> >  static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> > --
> > 2.29.2
> >
