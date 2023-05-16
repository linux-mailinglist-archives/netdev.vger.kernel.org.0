Return-Path: <netdev+bounces-2842-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7369D7043F3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 05:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5917C1C20C51
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 03:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E9B257C;
	Tue, 16 May 2023 03:30:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C44C23BD
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:30:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CC549DF
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684207829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=loCDtii2bD6W+7H3uoSjkUTPrHhjUmw5luEGcHFUSck=;
	b=AFSggo7ff7q6s/mez2nCA0SQ1GzvLdbt3icaWa9MyVrq/LlrQlBLEKLsPAnnhfwqYJNraU
	CiDvnlwjmN/vxrrkZ15Pfw96Sw+UFKpwINKqAsTP53IOaKpd52EqNRsP5F3fOOQvam6H4e
	C4Jkk6If/fleWSHdaZNY99n54RwBxBU=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-CYEWep7nN464N4xxQEvapA-1; Mon, 15 May 2023 23:30:28 -0400
X-MC-Unique: CYEWep7nN464N4xxQEvapA-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ac8f532751so53050901fa.2
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:30:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684207826; x=1686799826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=loCDtii2bD6W+7H3uoSjkUTPrHhjUmw5luEGcHFUSck=;
        b=f9gu29VoFks6TcnWSIEqWkfSujbiZW2g17wf+Jx71cDy4MZ+nUAbKWlT+wwcTdlPyH
         KgGj2SNciTnc+lm1biUsX6QrnWXWUtUZM+P9UJA1BCea+0SLPT+NO4bJ9v9YCJuXepXc
         3VNSJEDgQSHpDWY9qiSw7JIR1S2l+VMWOrJ8JfZfGB8BpZLprm3aOq6M9LGofate6TFh
         UKiMqKQhyqERYiYI3WZak9ZMmmRaYlcYj+lp2SqrgWMBcpFU1XHnmWyM0O4TD4CFNCGx
         2UUZXNmymIzWV4BNM9+CiNoE45UWW3dlj+i+OkdMOyvJn5OIKbfjsOB88mkpz0HXjhHs
         04JA==
X-Gm-Message-State: AC+VfDzpA4QAgH2SrSAbRdkqcm3+pixiSeni+04uLz5YhcwSK/Jiqxw+
	L30X+yMYL4WrulzBr4co/aEBA5dCclafkL0rsfhYwl9aObfvzG4Ddu/D7PAkCksTOmPZ6Gvu054
	Wqczkm6gppAVdZpFPdcwVgK4jipMe9lcD
X-Received: by 2002:a2e:9056:0:b0:2a8:bf35:3b7 with SMTP id n22-20020a2e9056000000b002a8bf3503b7mr6811378ljg.32.1684207826577;
        Mon, 15 May 2023 20:30:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4dDZ4FoJXEw1j0re42ZJYNkrhcBjKfMPdneRRgN+p8lYpgxJmGRVuPHHIR+gxAFYi6xntauA4fDv5VQGuO52U=
X-Received: by 2002:a2e:9056:0:b0:2a8:bf35:3b7 with SMTP id
 n22-20020a2e9056000000b002a8bf3503b7mr6811371ljg.32.1684207826407; Mon, 15
 May 2023 20:30:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230516025521.43352-1-shannon.nelson@amd.com> <20230516025521.43352-11-shannon.nelson@amd.com>
In-Reply-To: <20230516025521.43352-11-shannon.nelson@amd.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 16 May 2023 11:30:15 +0800
Message-ID: <CACGkMEv6CtrOQPTVaH6ngGLKyxBarwQMAhRiq0Z9QWnOz4Yx4g@mail.gmail.com>
Subject: Re: [PATCH v6 virtio 10/11] pds_vdpa: subscribe to the pds_core events
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org, 
	brett.creeley@amd.com, netdev@vger.kernel.org, simon.horman@corigine.com, 
	drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 10:56=E2=80=AFAM Shannon Nelson <shannon.nelson@amd=
.com> wrote:
>
> Register for the pds_core's notification events, primarily to
> find out when the FW has been reset so we can pass this on
> back up the chain.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vdpa/pds/vdpa_dev.c | 59 ++++++++++++++++++++++++++++++++++++-
>  drivers/vdpa/pds/vdpa_dev.h |  1 +
>  2 files changed, 59 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
> index 07b98dff5701..9afa803c4f21 100644
> --- a/drivers/vdpa/pds/vdpa_dev.c
> +++ b/drivers/vdpa/pds/vdpa_dev.c
> @@ -23,6 +23,52 @@ static struct pds_vdpa_device *vdpa_to_pdsv(struct vdp=
a_device *vdpa_dev)
>         return container_of(vdpa_dev, struct pds_vdpa_device, vdpa_dev);
>  }
>
> +static int pds_vdpa_notify_handler(struct notifier_block *nb,
> +                                  unsigned long ecode,
> +                                  void *data)
> +{
> +       struct pds_vdpa_device *pdsv =3D container_of(nb, struct pds_vdpa=
_device, nb);
> +       struct device *dev =3D &pdsv->vdpa_aux->padev->aux_dev.dev;
> +
> +       dev_dbg(dev, "%s: event code %lu\n", __func__, ecode);
> +
> +       if (ecode =3D=3D PDS_EVENT_RESET || ecode =3D=3D PDS_EVENT_LINK_C=
HANGE) {
> +               if (pdsv->config_cb.callback)
> +                       pdsv->config_cb.callback(pdsv->config_cb.private)=
;
> +       }
> +
> +       return 0;
> +}
> +
> +static int pds_vdpa_register_event_handler(struct pds_vdpa_device *pdsv)
> +{
> +       struct device *dev =3D &pdsv->vdpa_aux->padev->aux_dev.dev;
> +       struct notifier_block *nb =3D &pdsv->nb;
> +       int err;
> +
> +       if (!nb->notifier_call) {
> +               nb->notifier_call =3D pds_vdpa_notify_handler;
> +               err =3D pdsc_register_notify(nb);
> +               if (err) {
> +                       nb->notifier_call =3D NULL;
> +                       dev_err(dev, "failed to register pds event handle=
r: %ps\n",
> +                               ERR_PTR(err));
> +                       return -EINVAL;
> +               }
> +               dev_dbg(dev, "pds event handler registered\n");
> +       }
> +
> +       return 0;
> +}
> +
> +static void pds_vdpa_unregister_event_handler(struct pds_vdpa_device *pd=
sv)
> +{
> +       if (pdsv->nb.notifier_call) {
> +               pdsc_unregister_notify(&pdsv->nb);
> +               pdsv->nb.notifier_call =3D NULL;
> +       }
> +}
> +
>  static int pds_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid=
,
>                                    u64 desc_addr, u64 driver_addr, u64 de=
vice_addr)
>  {
> @@ -594,6 +640,12 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *md=
ev, const char *name,
>
>         pdsv->vdpa_dev.mdev =3D &vdpa_aux->vdpa_mdev;
>
> +       err =3D pds_vdpa_register_event_handler(pdsv);
> +       if (err) {
> +               dev_err(dev, "Failed to register for PDS events: %pe\n", =
ERR_PTR(err));
> +               goto err_unmap;
> +       }
> +
>         /* We use the _vdpa_register_device() call rather than the
>          * vdpa_register_device() to avoid a deadlock because our
>          * dev_add() is called with the vdpa_dev_lock already set
> @@ -602,13 +654,15 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *m=
dev, const char *name,
>         err =3D _vdpa_register_device(&pdsv->vdpa_dev, pdsv->num_vqs);
>         if (err) {
>                 dev_err(dev, "Failed to register to vDPA bus: %pe\n", ERR=
_PTR(err));
> -               goto err_unmap;
> +               goto err_unevent;
>         }
>
>         pds_vdpa_debugfs_add_vdpadev(vdpa_aux);
>
>         return 0;
>
> +err_unevent:
> +       pds_vdpa_unregister_event_handler(pdsv);
>  err_unmap:
>         put_device(&pdsv->vdpa_dev.dev);
>         vdpa_aux->pdsv =3D NULL;
> @@ -618,8 +672,11 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *md=
ev, const char *name,
>  static void pds_vdpa_dev_del(struct vdpa_mgmt_dev *mdev,
>                              struct vdpa_device *vdpa_dev)
>  {
> +       struct pds_vdpa_device *pdsv =3D vdpa_to_pdsv(vdpa_dev);
>         struct pds_vdpa_aux *vdpa_aux;
>
> +       pds_vdpa_unregister_event_handler(pdsv);
> +
>         vdpa_aux =3D container_of(mdev, struct pds_vdpa_aux, vdpa_mdev);
>         _vdpa_unregister_device(vdpa_dev);
>
> diff --git a/drivers/vdpa/pds/vdpa_dev.h b/drivers/vdpa/pds/vdpa_dev.h
> index 25c1d192f0ef..a1bc37de9537 100644
> --- a/drivers/vdpa/pds/vdpa_dev.h
> +++ b/drivers/vdpa/pds/vdpa_dev.h
> @@ -40,6 +40,7 @@ struct pds_vdpa_device {
>         u8 vdpa_index;                  /* rsvd for future subdevice use =
*/
>         u8 num_vqs;                     /* num vqs in use */
>         struct vdpa_callback config_cb;
> +       struct notifier_block nb;
>  };
>
>  #define PDS_VDPA_PACKED_INVERT_IDX     0x8000
> --
> 2.17.1
>


