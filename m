Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B91237187A
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 17:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhECPx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 11:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbhECPxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 11:53:25 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E9CC061763
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 08:52:31 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id di13so6857990edb.2
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 08:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ads5H+GrxwHQH2QsDgLr4Axl9DvJP1bh3ARjt4Zgfbg=;
        b=pA7G7VszQVmgKkGLosyhgtTy1HpotnmpA1p8vaUg4nGuHW1XAyP0JobvVnPLpxIndn
         7kgEUuuSzhXrlXyBvEhnUNFOaIqErC8DNM+VHXEjGU556li3C+916yE+leCicg7C90jx
         fR0KSVLTBZCIc1fotzjTVJXG9q8Esw3pYsoSoGxA7f4oiSWbv+/SCs6vb+axI6TNOJ4Z
         j9WDft/RDomJsRc/sAnrkMZ71hkKRAFE507BLaxuDXn2752uX2bQ7nEP+pqZ1ZffQpGE
         WF58fzR9ZJJZPJ7Q10QkUNesk0iNW47ccw+GFu+sL43uZvQXO8vCkCVGmQJgOeuSohn/
         nkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ads5H+GrxwHQH2QsDgLr4Axl9DvJP1bh3ARjt4Zgfbg=;
        b=namUbmLoLDFO3IddDQHpx0g6zhKm0vAY/9oI1swJY0kPjMaoC6uRLfriv8YD6B3B8z
         AlAusXVQ6+CmwkTXIuw4ST9YGYwRqvib7K2KcSNlkSe1bhKPUSH8+VGwoGiJyJYdpRMh
         4lWtmClKvDDMhBaMRZNGyOnjGVN4WnbqeG0wI3DLv30ntsVZ36Dh6lhLFkoMHaCNEQ36
         eSQ1RKdmPwVSSrl0TupwLOfLslq31NjgngZLtbvokR2dhE9891pLnHTaPWTmYzZJO3Ek
         MAeB3G3hTq4tVbMZFxcx0nU3frvWdREGEISzX+G+3YyGRfGoBOwzjETrdgwQYg334oSb
         DMuw==
X-Gm-Message-State: AOAM5325nUw50codh97o+gYa/zz2povJDKPInNKbJbsiFG2CScAiysEZ
        qINudH83FUNDo03vb+8OLh735OBe3pjZfeV1UA0=
X-Google-Smtp-Source: ABdhPJwPKwWeb9TuIwKFXJMaeLfCMKQLXYQTAGLjAe2x7E3Et12Gf8AnEVFM/ZC9u59cS8cPXgsrc6wzgLNdUOQwoc4=
X-Received: by 2002:a05:6402:1a2f:: with SMTP id be15mr20606696edb.207.1620057150428;
 Mon, 03 May 2021 08:52:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-13-smalin@marvell.com>
 <92371529-22a2-cb2e-9a6f-4ecb606adaf5@suse.de>
In-Reply-To: <92371529-22a2-cb2e-9a6f-4ecb606adaf5@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 3 May 2021 18:52:19 +0300
Message-ID: <CAKKgK4zXLGDtdGGV4BoSgUs0Ee6=Ap+fHXF38R8hm6anNZWoTQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 12/27] nvme-tcp-offload: Add controller level error
 recovery implementation
To:     Hannes Reinecke <hare@suse.de>, linux-nvme@lists.infradead.org
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Arie Gershberg <agershberg@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/21 7:29 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > From: Arie Gershberg <agershberg@marvell.com>
> >
> > In this patch, we implement controller level error handling and recover=
y.
> > Upon an error discovered by the ULP or reset controller initiated by th=
e
> > nvme-core (using reset_ctrl workqueue), the ULP will initiate a control=
ler
> > recovery which includes teardown and re-connect of all queues.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Arie Gershberg <agershberg@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/host/tcp-offload.c | 138 +++++++++++++++++++++++++++++++=
-
> >   drivers/nvme/host/tcp-offload.h |   1 +
> >   2 files changed, 137 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-of=
fload.c
> > index 59e1955e02ec..9082b11c133f 100644
> > --- a/drivers/nvme/host/tcp-offload.c
> > +++ b/drivers/nvme/host/tcp-offload.c
> > @@ -74,6 +74,23 @@ void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_of=
ld_dev *dev)
> >   }
> >   EXPORT_SYMBOL_GPL(nvme_tcp_ofld_unregister_dev);
> >
> > +/**
> > + * nvme_tcp_ofld_error_recovery() - NVMeTCP Offload Library error reco=
very.
> > + * function.
> > + * @nctrl:   NVMe controller instance to change to resetting.
> > + *
> > + * API function that change the controller state to resseting.
> > + * Part of the overall controller reset sequence.
> > + */
> > +void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl)
> > +{
> > +     if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_RESETTING))
> > +             return;
> > +
> > +     queue_work(nvme_reset_wq, &to_tcp_ofld_ctrl(nctrl)->err_work);
> > +}
> > +EXPORT_SYMBOL_GPL(nvme_tcp_ofld_error_recovery);
> > +
> >   /**
> >    * nvme_tcp_ofld_report_queue_err() - NVMeTCP Offload report error ev=
ent
> >    * callback function. Pointed to by nvme_tcp_ofld_queue->report_err.
> > @@ -84,7 +101,8 @@ EXPORT_SYMBOL_GPL(nvme_tcp_ofld_unregister_dev);
> >    */
> >   int nvme_tcp_ofld_report_queue_err(struct nvme_tcp_ofld_queue *queue)
> >   {
> > -     /* Placeholder - invoke error recovery flow */
> > +     pr_err("nvme-tcp-offload queue error\n");
> > +     nvme_tcp_ofld_error_recovery(&queue->ctrl->nctrl);
> >
> >       return 0;
> >   }
> > @@ -296,6 +314,28 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl=
 *nctrl, bool new)
> >       return rc;
> >   }
> >
> > +static void nvme_tcp_ofld_reconnect_or_remove(struct nvme_ctrl *nctrl)
> > +{
> > +     /* If we are resetting/deleting then do nothing */
> > +     if (nctrl->state !=3D NVME_CTRL_CONNECTING) {
> > +             WARN_ON_ONCE(nctrl->state =3D=3D NVME_CTRL_NEW ||
> > +                          nctrl->state =3D=3D NVME_CTRL_LIVE);
> > +
> > +             return;
> > +     }
> > +
> > +     if (nvmf_should_reconnect(nctrl)) {
> > +             dev_info(nctrl->device, "Reconnecting in %d seconds...\n"=
,
> > +                      nctrl->opts->reconnect_delay);
> > +             queue_delayed_work(nvme_wq,
> > +                                &to_tcp_ofld_ctrl(nctrl)->connect_work=
,
> > +                                nctrl->opts->reconnect_delay * HZ);
> > +     } else {
> > +             dev_info(nctrl->device, "Removing controller...\n");
> > +             nvme_delete_ctrl(nctrl);
> > +     }
> > +}
> > +
> >   static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new=
)
> >   {
> >       struct nvmf_ctrl_options *opts =3D nctrl->opts;
> > @@ -407,10 +447,68 @@ nvme_tcp_ofld_teardown_io_queues(struct nvme_ctrl=
 *nctrl, bool remove)
> >       /* Placeholder - teardown_io_queues */
> >   }
> >
> > +static void nvme_tcp_ofld_reconnect_ctrl_work(struct work_struct *work=
)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D
> > +                             container_of(to_delayed_work(work),
> > +                                          struct nvme_tcp_ofld_ctrl,
> > +                                          connect_work);
> > +     struct nvme_ctrl *nctrl =3D &ctrl->nctrl;
> > +
> > +     ++nctrl->nr_reconnects;
> > +
> > +     if (ctrl->dev->ops->setup_ctrl(ctrl, false))
> > +             goto requeue;
> > +
> > +     if (nvme_tcp_ofld_setup_ctrl(nctrl, false))
> > +             goto release_and_requeue;
> > +
> > +     dev_info(nctrl->device, "Successfully reconnected (%d attempt)\n"=
,
> > +              nctrl->nr_reconnects);
> > +
> > +     nctrl->nr_reconnects =3D 0;
> > +
> > +     return;
> > +
> > +release_and_requeue:
> > +     ctrl->dev->ops->release_ctrl(ctrl);
> > +requeue:
> > +     dev_info(nctrl->device, "Failed reconnect attempt %d\n",
> > +              nctrl->nr_reconnects);
> > +     nvme_tcp_ofld_reconnect_or_remove(nctrl);
> > +}
> > +
> > +static void nvme_tcp_ofld_error_recovery_work(struct work_struct *work=
)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D
> > +             container_of(work, struct nvme_tcp_ofld_ctrl, err_work);
> > +     struct nvme_ctrl *nctrl =3D &ctrl->nctrl;
> > +
> > +     nvme_stop_keep_alive(nctrl);
> > +     nvme_tcp_ofld_teardown_io_queues(nctrl, false);
> > +     /* unquiesce to fail fast pending requests */
> > +     nvme_start_queues(nctrl);
> > +     nvme_tcp_ofld_teardown_admin_queue(nctrl, false);
> > +     blk_mq_unquiesce_queue(nctrl->admin_q);
> > +
> > +     if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_CONNECTING)) {
> > +             /* state change failure is ok if we started nctrl delete =
*/
> > +             WARN_ON_ONCE(nctrl->state !=3D NVME_CTRL_DELETING &&
> > +                          nctrl->state !=3D NVME_CTRL_DELETING_NOIO);
> > +
> > +             return;
> > +     }
> > +
> > +     nvme_tcp_ofld_reconnect_or_remove(nctrl);
> > +}
> > +
> >   static void
> >   nvme_tcp_ofld_teardown_ctrl(struct nvme_ctrl *nctrl, bool shutdown)
> >   {
> > -     /* Placeholder - err_work and connect_work */
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +
> > +     cancel_work_sync(&ctrl->err_work);
> > +     cancel_delayed_work_sync(&ctrl->connect_work);
> >       nvme_tcp_ofld_teardown_io_queues(nctrl, shutdown);
> >       blk_mq_quiesce_queue(nctrl->admin_q);
> >       if (shutdown)
> > @@ -425,6 +523,38 @@ static void nvme_tcp_ofld_delete_ctrl(struct nvme_=
ctrl *nctrl)
> >       nvme_tcp_ofld_teardown_ctrl(nctrl, true);
> >   }
> >
> > +static void nvme_tcp_ofld_reset_ctrl_work(struct work_struct *work)
> > +{
> > +     struct nvme_ctrl *nctrl =3D
> > +             container_of(work, struct nvme_ctrl, reset_work);
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +
> > +     nvme_stop_ctrl(nctrl);
> > +     nvme_tcp_ofld_teardown_ctrl(nctrl, false);
> > +
> > +     if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_CONNECTING)) {
> > +             /* state change failure is ok if we started ctrl delete *=
/
> > +             WARN_ON_ONCE(nctrl->state !=3D NVME_CTRL_DELETING &&
> > +                          nctrl->state !=3D NVME_CTRL_DELETING_NOIO);
> > +
> > +             return;
> > +     }
> > +
> > +     if (ctrl->dev->ops->setup_ctrl(ctrl, false))
> > +             goto out_fail;
> > +
> > +     if (nvme_tcp_ofld_setup_ctrl(nctrl, false))
> > +             goto release_ctrl;
> > +
> > +     return;
> > +
> > +release_ctrl:
> > +     ctrl->dev->ops->release_ctrl(ctrl);
> > +out_fail:
> > +     ++nctrl->nr_reconnects;
> > +     nvme_tcp_ofld_reconnect_or_remove(nctrl);
> > +}
> > +
> >   static int
> >   nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
> >                          struct request *rq,
> > @@ -521,6 +651,10 @@ nvme_tcp_ofld_create_ctrl(struct device *ndev, str=
uct nvmf_ctrl_options *opts)
> >                            opts->nr_poll_queues + 1;
> >       nctrl->sqsize =3D opts->queue_size - 1;
> >       nctrl->kato =3D opts->kato;
> > +     INIT_DELAYED_WORK(&ctrl->connect_work,
> > +                       nvme_tcp_ofld_reconnect_ctrl_work);
> > +     INIT_WORK(&ctrl->err_work, nvme_tcp_ofld_error_recovery_work);
> > +     INIT_WORK(&nctrl->reset_work, nvme_tcp_ofld_reset_ctrl_work);
> >       if (!(opts->mask & NVMF_OPT_TRSVCID)) {
> >               opts->trsvcid =3D
> >                       kstrdup(__stringify(NVME_TCP_DISC_PORT), GFP_KERN=
EL);
> > diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-of=
fload.h
> > index 9fd270240eaa..b23b1d7ea6fa 100644
> > --- a/drivers/nvme/host/tcp-offload.h
> > +++ b/drivers/nvme/host/tcp-offload.h
> > @@ -204,3 +204,4 @@ struct nvme_tcp_ofld_ops {
> >   /* Exported functions for lower vendor specific offload drivers */
> >   int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
> >   void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
> > +void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl);
> >
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Thanks.


>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
