Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619D1322A9C
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbhBWMew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 07:34:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232672AbhBWMe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 07:34:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614083575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x3DW69ELSoGab9iFk3XQpMfjw5ZB9SvGphEN2R3aLT0=;
        b=ape6WaeydVqSF26qBqbqU3x4oUNvVPH+EuMKJl57pZYQMdwxtuh3Fxac5jaGV+Ql5MkwFa
        W6MaEA/KZdZMxBIMHzBci1PzYoBCAVEWut2cmToTKXlX/Ciq1wXSTcJkQkb9L1XAE/1qFe
        bNxNs/EgO4+6TM8MEcgW31fSn+B8k4o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-nyvF_jrUPIuqIAw7xpUojA-1; Tue, 23 Feb 2021 07:32:53 -0500
X-MC-Unique: nyvF_jrUPIuqIAw7xpUojA-1
Received: by mail-wm1-f70.google.com with SMTP id u15so1138185wmj.2
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 04:32:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x3DW69ELSoGab9iFk3XQpMfjw5ZB9SvGphEN2R3aLT0=;
        b=ZjzGqkUku0Z0OK/Kjzpav+rpGG67LRsOCXEwxJpAcPMGotjKr/mY8uWfgjLNPE5I5b
         QAKtMAzSNQvqofaiz2RslK5uSqJcFSKjLkRBpI9Zj3gXKNopMK+tPRb65RkT4m3TkOP5
         o3zAB3AdCe8oqfZI3YURJeN7TfO64fp/uitI6gsjzMcUcjrBWAsUgQvLqu0BjbqrNh+q
         5Kr4/qT2B6RHKJbC8m/yckbMnierdHEnTOR9q5/E+NCjDzSN9mwJsRcYyNcBokhMtXoq
         iJlzywyhjLs/FCBKEgt/97fU+vYMKNRH9Z+JESeyKoFpo2kkjXMPoG72QO6Nzjma/d3d
         /FSw==
X-Gm-Message-State: AOAM532+yzUTQYIdwFwENpOjsWSQYRMmG5nG/BUgPIjdrP0Gim2iZNJ6
        idNf37fMdKE7FAcsJBlVkDG/Resu3lEuQoTsyNTcC39GCEeAD5dtHMrV6i/32rqCyJkISC5tMzi
        qHwRVJXSh42XsvpVv
X-Received: by 2002:a1c:f60b:: with SMTP id w11mr24660188wmc.3.1614083572529;
        Tue, 23 Feb 2021 04:32:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/j0eRjoVScr7mxvXDLNHosb0ARMNPamB4G4SgA5hHEoAJqxPK6ghP73oKIZ48MV2ylGM7TQ==
X-Received: by 2002:a1c:f60b:: with SMTP id w11mr24660173wmc.3.1614083572413;
        Tue, 23 Feb 2021 04:32:52 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id v5sm2671407wmh.2.2021.02.23.04.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 04:32:52 -0800 (PST)
Date:   Tue, 23 Feb 2021 07:32:49 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        si-wei.liu@oracle.com
Subject: Re: [PATCH] vdpa/mlx5: Extract correct pointer from driver data
Message-ID: <20210223073225-mutt-send-email-mst@kernel.org>
References: <20210216055022.25248-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216055022.25248-1-elic@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 07:50:21AM +0200, Eli Cohen wrote:
> struct mlx5_vdpa_net pointer was stored in drvdata. Extract it as well
> in mlx5v_remove().
> 
> Fixes: 74c9729dd892 ("vdpa/mlx5: Connect mlx5_vdpa to auxiliary bus")
> Signed-off-by: Eli Cohen <elic@nvidia.com>

Sorry which tree this is for? Couldn't apply.

> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 6b0a42183622..4103d3b64a2a 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2036,9 +2036,9 @@ static int mlx5v_probe(struct auxiliary_device *adev,
>  
>  static void mlx5v_remove(struct auxiliary_device *adev)
>  {
> -	struct mlx5_vdpa_dev *mvdev = dev_get_drvdata(&adev->dev);
> +	struct mlx5_vdpa_net *ndev = dev_get_drvdata(&adev->dev);
>  
> -	vdpa_unregister_device(&mvdev->vdev);
> +	vdpa_unregister_device(&ndev->mvdev.vdev);
>  }
>  
>  static const struct auxiliary_device_id mlx5v_id_table[] = {
> -- 
> 2.29.2

