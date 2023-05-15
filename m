Return-Path: <netdev+bounces-2484-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F0F70231D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:02:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB7C91C20A35
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 05:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F4CA1C20;
	Mon, 15 May 2023 05:02:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C79B10E6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:02:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E82133
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 22:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684126940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B0zykRHSym2wUsyz7uvj72KV38qh10+aeWx/77S+cEo=;
	b=I9rT+NkvwtwAtSjv2yQ7bq9zO1Q5pQyNdB/XI5WojIlYwHabf2f8FbaP1mrqzNfpSYkJB6
	WpqqRxS+FKsKrWiERbyZsciLSlVNThJ3a7y3bdcm456ES2+v1q/CPVHWCtTFQ28JMRNX7s
	blnQ7Ogl+xdd2rqERtDmrElyF5a/nNQ=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-W4ab-ANgPeW4SebeS-4KHA-1; Mon, 15 May 2023 01:02:16 -0400
X-MC-Unique: W4ab-ANgPeW4SebeS-4KHA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4edd54a0eaeso7200534e87.0
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 22:02:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684126934; x=1686718934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B0zykRHSym2wUsyz7uvj72KV38qh10+aeWx/77S+cEo=;
        b=XEHXTLicZ4XfDLp8Ybk5STEMumeLIEX8e8c8LoWCerIhbs1tzgqd2ZbWjxpMEhfIsZ
         10SwYo9C79nQc7lqC3CMx4WVcZmVerFmfrK4hZUr4iOAD5VF9cQsHYQq83hIDaYlvHBo
         tpzhnlJRosrz+8YSlt9PWPiMNo1B0TTjWer/LuUd26tk3rCRCkAZxr6p+G9qC3dIYjQT
         8NehX7yYYdxsDccSfNVv32YxuMaweSnlYOQ2/umItp2kbuO8LcTbLdAM+d+W19fR1HPV
         FO0tTUSIrt8fyO4pux/Vf3o+zt0qe2ooegJyBHyYaPi6RPpYbdLnbFZL3qgNMR4ErIpz
         gPWA==
X-Gm-Message-State: AC+VfDwRBeMwUozHzngBGXWT9f+YNZBNLK52tX3IgWe5dt/H+0C11QgW
	9IxE97J1/FZTKpT/0rxhfNzQ94vLQRnB/E1NL41RoKIgeoDDr9WRRV43w4vw7fMMyydq8oXe+i+
	zcOirSk6QPy+xzm9b2UJLzVA8Og998MVU
X-Received: by 2002:a05:6512:11e7:b0:4ec:8e7e:46f1 with SMTP id p7-20020a05651211e700b004ec8e7e46f1mr5363894lfs.66.1684126934676;
        Sun, 14 May 2023 22:02:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6lhIqlhQd6lLls7n0zaA85UdEqq4xQ/62YJVC6WCw3PxLJHBNU0JhKeQPjII4KXKrbIFS9BZCGF7Xkj2fsH9s=
X-Received: by 2002:a05:6512:11e7:b0:4ec:8e7e:46f1 with SMTP id
 p7-20020a05651211e700b004ec8e7e46f1mr5363886lfs.66.1684126934331; Sun, 14 May
 2023 22:02:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230503181240.14009-1-shannon.nelson@amd.com> <20230503181240.14009-11-shannon.nelson@amd.com>
In-Reply-To: <20230503181240.14009-11-shannon.nelson@amd.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 15 May 2023 13:02:03 +0800
Message-ID: <CACGkMEuytKwDp3GLcaQmU1CtWSmb2RZRaGdgFyXoCqveruJBpA@mail.gmail.com>
Subject: Re: [PATCH v5 virtio 10/11] pds_vdpa: subscribe to the pds_core events
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

On Thu, May 4, 2023 at 2:13=E2=80=AFAM Shannon Nelson <shannon.nelson@amd.c=
om> wrote:
>
> Register for the pds_core's notification events, primarily to
> find out when the FW has been reset so we can pass this on
> back up the chain.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vdpa/pds/vdpa_dev.c | 68 ++++++++++++++++++++++++++++++++++++-
>  drivers/vdpa/pds/vdpa_dev.h |  1 +
>  2 files changed, 68 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
> index 9970657cdb3d..377eefc2fa1e 100644
> --- a/drivers/vdpa/pds/vdpa_dev.c
> +++ b/drivers/vdpa/pds/vdpa_dev.c
> @@ -21,6 +21,61 @@ static struct pds_vdpa_device *vdpa_to_pdsv(struct vdp=
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
> +       /* Give the upper layers a hint that something interesting
> +        * may have happened.  It seems that the only thing this
> +        * triggers in the virtio-net drivers above us is a check
> +        * of link status.
> +        *
> +        * We don't set the NEEDS_RESET flag for EVENT_RESET
> +        * because we're likely going through a recovery or
> +        * fw_update and will be back up and running soon.
> +        */
> +       if (ecode =3D=3D PDS_EVENT_RESET || ecode =3D=3D PDS_EVENT_LINK_C=
HANGE) {

The code here seems to conflict with the comment above. If we don't
set NEEDS_RESET, there's no need for the config callback?

Thanks

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
> @@ -522,6 +577,12 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *md=
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
> @@ -530,13 +591,15 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *m=
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
> @@ -546,8 +609,11 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *md=
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
> index a21596f438c1..1650a2b08845 100644
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
>  int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
> --
> 2.17.1
>


