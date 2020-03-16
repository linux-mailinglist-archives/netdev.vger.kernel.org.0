Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95AB418657A
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 08:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbgCPHQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 03:16:00 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:43394 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728302AbgCPHQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 03:16:00 -0400
Received: by mail-il1-f193.google.com with SMTP id d14so14901681ilq.10;
        Mon, 16 Mar 2020 00:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tRh0qGsHo1Z8/8EsTHyXL3Vn9WTVBKRNVDpdnxNvsWU=;
        b=sbtgZ4fcgpuUhIPdsfN86WqZ2Z3IKkM7ZUIa3UnsbXvVMMvEM5UulAwdMpvlQMRABu
         NOgyRpFJzQaKdYHO3n64PY+He+tvBhGOZ+nvQwGUSSYWlylCtk5pJePV6CBs5DqSjluO
         mtkBLQfX6fJg1hO/Hbo4KLondpf6k9vmeNv8gZyDze9nF+DNZbBnBymDNmd1TFxW1lYq
         4F0Y+xZnGnh8qasrIhTXn3oMGvAmPgURcP11NWuDZWtLiSBM8clE86G5LWdD2GFMLC7X
         Zl8o2y5SM2HDmYg/6MTVMzmUaytPDPu0H0Z2NHyGmvRd3iy+yRPKo1U27GIccXE7bOR9
         7Iew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tRh0qGsHo1Z8/8EsTHyXL3Vn9WTVBKRNVDpdnxNvsWU=;
        b=Hrda7V4uffvLoCjS9ra6kbAh5Sm9cdgPlPwPaL4ix3xBm9/9rwfBJFEmu999hE+LFg
         EM9gABy1bwd2Qd8xSsj+Za3uuP2lz6CYvVdXz3+UNjjYW93Uf75JPVLJt9gmI9zMRxf8
         oBaGsxOKa4gv5BE+IBGKwLGEiCM71D/WMEHqid3CocYXIRPovNVfUsSLHRLnbXnbUqta
         0GWHbwAhtrC9rEsNiz6TTXVKzphEeUhfZRINJHmrWV3f0ikCFw2fsArTdh1+mZPqr9jC
         5Ig1WrmSjMHBQuuyhPF4DBFsMurGGnLqjzQ8iYe35sDkT6Tb9Nn+10JBbsYwutJ6D/if
         A2dA==
X-Gm-Message-State: ANhLgQ0p+N0infP7zRll5+xx/Y0egE5rJhRBP6ifOBOQfs/rENw3ZK3y
        DjIVSoLdICipNCtTeIP2xMQTEhTVfVlk+0IN4QY=
X-Google-Smtp-Source: ADFU+vuwyY6yUEhRU+0bXIjjvAJjxvEP7ZJrXrSiHKFUMWhDQrDXRhZFaMVz6T+YtT+E0hIPwj4EiME6IaF5YZJzlJA=
X-Received: by 2002:a92:dd0e:: with SMTP id n14mr9668098ilm.0.1584342957526;
 Mon, 16 Mar 2020 00:15:57 -0700 (PDT)
MIME-Version: 1.0
References: <1584341983-11245-1-git-send-email-hqjagain@gmail.com>
In-Reply-To: <1584341983-11245-1-git-send-email-hqjagain@gmail.com>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Mon, 16 Mar 2020 15:15:46 +0800
Message-ID: <CAJRQjofA4+LJxYn-HQdBZ_Lxv3DgS1WrPtM3L1z4-ycRKPS5nw@mail.gmail.com>
Subject: Re: [PATCH] drm/lease: fix potential race in fill_object_idr
To:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry about sending to wrong maintainers. Please ignore it.
I'll resend it.

On Mon, Mar 16, 2020 at 2:59 PM Qiujun Huang <hqjagain@gmail.com> wrote:
>
> We should hold idr_mutex for idr_alloc.
>
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> ---
>  drivers/gpu/drm/drm_lease.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
> index b481caf..427ee21 100644
> --- a/drivers/gpu/drm/drm_lease.c
> +++ b/drivers/gpu/drm/drm_lease.c
> @@ -418,6 +418,7 @@ static int fill_object_idr(struct drm_device *dev,
>                 goto out_free_objects;
>         }
>
> +       mutex_lock(&dev->mode_config.idr_mutex);
>         /* add their IDs to the lease request - taking into account
>            universal planes */
>         for (o = 0; o < object_count; o++) {
> @@ -437,7 +438,7 @@ static int fill_object_idr(struct drm_device *dev,
>                 if (ret < 0) {
>                         DRM_DEBUG_LEASE("Object %d cannot be inserted into leases (%d)\n",
>                                         object_id, ret);
> -                       goto out_free_objects;
> +                       goto out_unlock;
>                 }
>                 if (obj->type == DRM_MODE_OBJECT_CRTC && !universal_planes) {
>                         struct drm_crtc *crtc = obj_to_crtc(obj);
> @@ -445,20 +446,22 @@ static int fill_object_idr(struct drm_device *dev,
>                         if (ret < 0) {
>                                 DRM_DEBUG_LEASE("Object primary plane %d cannot be inserted into leases (%d)\n",
>                                                 object_id, ret);
> -                               goto out_free_objects;
> +                               goto out_unlock;
>                         }
>                         if (crtc->cursor) {
>                                 ret = idr_alloc(leases, &drm_lease_idr_object, crtc->cursor->base.id, crtc->cursor->base.id + 1, GFP_KERNEL);
>                                 if (ret < 0) {
>                                         DRM_DEBUG_LEASE("Object cursor plane %d cannot be inserted into leases (%d)\n",
>                                                         object_id, ret);
> -                                       goto out_free_objects;
> +                                       goto out_unlock;
>                                 }
>                         }
>                 }
>         }
>
>         ret = 0;
> +out_unlock:
> +       mutex_unlock(&dev->mode_config.idr_mutex);
>  out_free_objects:
>         for (o = 0; o < object_count; o++) {
>                 if (objects[o])
> --
> 1.8.3.1
>
