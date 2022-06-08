Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1458542A0C
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 10:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbiFHIzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 04:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiFHIyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 04:54:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5AC2E38C771
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 01:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654676089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1e5tD9PXzjV3+S+uI6hDOQFK0Opxb+SNgCa3LEsZqe8=;
        b=Iwm64QKTRUah/MQ+in9UUAJnTNPjxuD8WCFSNcKq9Q/NKK66E2bSM6T2ETu7eoKNI9jafS
        fLMKdpwOAcbfFuVMm8dUg6BgETwvihD9OSlqJVsR4c3wWrv/O1WJsoIatdudCUZgmtHQ1s
        +ICiyF9DHyrxSRBsJHzyuxFVUXp1Vmo=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-219-wP4scGR4N7GuGEuw233G9Q-1; Wed, 08 Jun 2022 04:14:45 -0400
X-MC-Unique: wP4scGR4N7GuGEuw233G9Q-1
Received: by mail-lj1-f198.google.com with SMTP id bn32-20020a05651c17a000b00253e2b131d3so3574547ljb.6
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 01:14:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1e5tD9PXzjV3+S+uI6hDOQFK0Opxb+SNgCa3LEsZqe8=;
        b=yr9vYmr3fve65NUzXn7Q/csjJ5ra1FD/HwloivNX6fVaLqAejgjQoeMurIgfmWKB9L
         TJ2xEJ4jrxYbFmFDQL7aZADD58dPkrpFpnqV6YkKLerRrq1yw1C0gyj9VFyjHpvYZ0iW
         lcoT3i84rbgP07ISx8X9dwHz0wD/z6TYdpUKtsJsBDxzrnEN4pwr10TXGVILv0WUA05T
         RtDgBvMBw+PlLJakqf/A0+k4huVM4qfqzaZIVfjwgoUQqZFm82T4FoQVqLuGRPUF8sOV
         geuVrtb9N96ATGxNXdg5DmSETahkusnHzSjKuxv2c1r8MjgXl7oX/2ygAG6WeiBoFppz
         COKQ==
X-Gm-Message-State: AOAM530H+QhEbv5oU8welAUrZhDKzsAiJfvUFYHamHLBQvx3SrcectVr
        jAXVOt6E7AbuuXA3ehSp3wAfIaxM949iNTUna9uiFHgJaZZr/vJURE4M5hHJEWQ7JQOHZzBEdCg
        ffAgnfs3MqUhbcisUpMR94Xj54y918/ZJ
X-Received: by 2002:a2e:bc05:0:b0:24b:212d:7521 with SMTP id b5-20020a2ebc05000000b0024b212d7521mr54621256ljf.243.1654676083981;
        Wed, 08 Jun 2022 01:14:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJOxxSMrbtrTLofBGIwZnPJwuN96zsC+6yUe+kAzCdIU5VLqefF45AdRHmWtf3v49sWuUXCqibNWV7P+HNoAA=
X-Received: by 2002:a2e:bc05:0:b0:24b:212d:7521 with SMTP id
 b5-20020a2ebc05000000b0024b212d7521mr54621233ljf.243.1654676083698; Wed, 08
 Jun 2022 01:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220603103356.26564-1-gautam.dawar@amd.com>
In-Reply-To: <20220603103356.26564-1-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 8 Jun 2022 16:14:32 +0800
Message-ID: <CACGkMEs38ycmAaDc48_rt5BeBHq4tzKH39gj=KczYFQC16ns5Q@mail.gmail.com>
Subject: Re: [PATCH] vdpa: allow vdpa dev_del management operation to return failure
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     netdev <netdev@vger.kernel.org>, linux-net-drivers@amd.com,
        hanand@amd.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gautam:

On Fri, Jun 3, 2022 at 6:34 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>
> Currently, the vdpa_nl_cmd_dev_del_set_doit() implementation allows
> returning a value to depict the operation status but the return type
> of dev_del() callback is void. So, any error while deleting the vdpa
> device in the vdpa parent driver can't be returned to the management
> layer.

I wonder under which cognition we can hit an error in dev_del()?

Thanks

> This patch changes the return type of dev_del() callback to int to
> allow returning an error code in case of failure.
>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c      |  3 ++-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c    |  3 ++-
>  drivers/vdpa/vdpa.c                  | 11 ++++++++---
>  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 ++-
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 ++-
>  drivers/vdpa/vdpa_user/vduse_dev.c   |  3 ++-
>  include/linux/vdpa.h                 |  5 +++--
>  7 files changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 4366320fb68d..6a967935478b 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -800,13 +800,14 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>         return ret;
>  }
>
> -static void ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
> +static int ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
>  {
>         struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
>
>         ifcvf_mgmt_dev = container_of(mdev, struct ifcvf_vdpa_mgmt_dev, mdev);
>         _vdpa_unregister_device(dev);
>         ifcvf_mgmt_dev->adapter = NULL;
> +       return 0;
>  }
>
>  static const struct vdpa_mgmtdev_ops ifcvf_vdpa_mgmt_dev_ops = {
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index e0de44000d92..b06204c2f3e8 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2775,7 +2775,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
>         return err;
>  }
>
> -static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *dev)
> +static int mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *dev)
>  {
>         struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
>         struct mlx5_vdpa_dev *mvdev = to_mvdev(dev);
> @@ -2788,6 +2788,7 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
>         destroy_workqueue(wq);
>         _vdpa_unregister_device(dev);
>         mgtdev->ndev = NULL;
> +       return 0;
>  }
>
>  static const struct vdpa_mgmtdev_ops mdev_ops = {
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 2b75c00b1005..65dc8bf2f37f 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -363,10 +363,11 @@ static int vdpa_match_remove(struct device *dev, void *data)
>  {
>         struct vdpa_device *vdev = container_of(dev, struct vdpa_device, dev);
>         struct vdpa_mgmt_dev *mdev = vdev->mdev;
> +       int err = 0;
>
>         if (mdev == data)
> -               mdev->ops->dev_del(mdev, vdev);
> -       return 0;
> +               err = mdev->ops->dev_del(mdev, vdev);
> +       return err;
>  }
>
>  void vdpa_mgmtdev_unregister(struct vdpa_mgmt_dev *mdev)
> @@ -673,7 +674,11 @@ static int vdpa_nl_cmd_dev_del_set_doit(struct sk_buff *skb, struct genl_info *i
>                 goto mdev_err;
>         }
>         mdev = vdev->mdev;
> -       mdev->ops->dev_del(mdev, vdev);
> +       err = mdev->ops->dev_del(mdev, vdev);
> +       if (err) {
> +               NL_SET_ERR_MSG_MOD(info->extack, "ops->dev_del failed");
> +               goto dev_err;
> +       }
>  mdev_err:
>         put_device(dev);
>  dev_err:
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> index 42d401d43911..443d4b94268f 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> @@ -280,12 +280,13 @@ static int vdpasim_blk_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>         return ret;
>  }
>
> -static void vdpasim_blk_dev_del(struct vdpa_mgmt_dev *mdev,
> +static int vdpasim_blk_dev_del(struct vdpa_mgmt_dev *mdev,
>                                 struct vdpa_device *dev)
>  {
>         struct vdpasim *simdev = container_of(dev, struct vdpasim, vdpa);
>
>         _vdpa_unregister_device(&simdev->vdpa);
> +       return 0;
>  }
>
>  static const struct vdpa_mgmtdev_ops vdpasim_blk_mgmtdev_ops = {
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> index d5324f6fd8c7..9e5a5ad34e65 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -167,12 +167,13 @@ static int vdpasim_net_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>         return ret;
>  }
>
> -static void vdpasim_net_dev_del(struct vdpa_mgmt_dev *mdev,
> +static int vdpasim_net_dev_del(struct vdpa_mgmt_dev *mdev,
>                                 struct vdpa_device *dev)
>  {
>         struct vdpasim *simdev = container_of(dev, struct vdpasim, vdpa);
>
>         _vdpa_unregister_device(&simdev->vdpa);
> +       return 0;
>  }
>
>  static const struct vdpa_mgmtdev_ops vdpasim_net_mgmtdev_ops = {
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> index f85d1a08ed87..33ff45e70ff7 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -1540,9 +1540,10 @@ static int vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>         return 0;
>  }
>
> -static void vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
> +static int vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
>  {
>         _vdpa_unregister_device(dev);
> +       return 0;
>  }
>
>  static const struct vdpa_mgmtdev_ops vdpa_dev_mgmtdev_ops = {
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 8943a209202e..e547c9dfdfce 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -443,12 +443,13 @@ void vdpa_set_status(struct vdpa_device *vdev, u8 status);
>   *          @mdev: parent device to use for device removal
>   *          @dev: vdpa device to remove
>   *          Driver need to remove the specified device by calling
> - *          _vdpa_unregister_device().
> + *          _vdpa_unregister_device(). Driver must return 0
> + *          on success or appropriate error code in failure case.
>   */
>  struct vdpa_mgmtdev_ops {
>         int (*dev_add)(struct vdpa_mgmt_dev *mdev, const char *name,
>                        const struct vdpa_dev_set_config *config);
> -       void (*dev_del)(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev);
> +       int (*dev_del)(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev);
>  };
>
>  /**
> --
> 2.30.1
>

