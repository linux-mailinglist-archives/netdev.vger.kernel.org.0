Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62105FEE16
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 14:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiJNMoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 08:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJNMoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 08:44:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F284B1C713F
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 05:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665751441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p9eCoXO3GWSpEHLkysK5BIM7P6WZtEISqEMQjNvYTNs=;
        b=bHbbnwYOpHLo/eCxNIOmyOli+GIdU5qqvN9o3Y+anL0uQH0Em3g9VCSooQSKOvMl82EfJp
        xn0iUk+Gj6cn3WQ6ErC5jTYoTo5khbKP23V0hDRkmT+nFfvq7Ldn7CH/rxjV3lFy4BK6Mu
        BSd8OdabudrWiYRboF9z6VwaEBk+bUY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-612-M_qhh5obMbKJGy0Klen2qw-1; Fri, 14 Oct 2022 08:43:59 -0400
X-MC-Unique: M_qhh5obMbKJGy0Klen2qw-1
Received: by mail-pj1-f70.google.com with SMTP id y7-20020a17090a134700b0020b1347568bso2565023pjf.7
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 05:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p9eCoXO3GWSpEHLkysK5BIM7P6WZtEISqEMQjNvYTNs=;
        b=zH2/6AAAxf5I1FE6kR4A57OSenvsTsPuNR/XleiR3aYOlqc4s6ojEcKjspOpdhpNnO
         CXjNNkrPegS+q2xzitVkIYKcHJHn5PV+mFW4qYeleZyULZsmJYz8Zu3d21gOPMR5Bc3U
         +uQPRcbZppzhM3OyZXUeDgk1xOG+0annfz5vAQHJUOONoHr0dBdsXB3+1hUL1rRSGFd3
         WYbIjQFWMY74PaVZtvLhnCb4HFfYL4YNL7IxH4KEh+KkQYQt2c2OricNenb9gJAoSXkC
         0lq8Z3V80S4XEygDMgNFeId6dX2ZBV/xiOAcIPeMoBhcMRSuu34lYaMCzpTFxRJjKajE
         K+mQ==
X-Gm-Message-State: ACrzQf2cc0t8Y0ZXj9ZaId3bcYNcjIJqkG08ILR9yOht4kwyoMkgRx5/
        L4kRmyhK/1RUXzRUd0hb1fwjvQYdKqiy0jQK5QUeH6DRT4P/UopNwQEOUQTtbfVibVM/wFSMo+e
        sEY7aFkjYvNgDwmi0qQlMEn0vhAB2bwnQ
X-Received: by 2002:a17:90a:f286:b0:20a:b521:7bbe with SMTP id fs6-20020a17090af28600b0020ab5217bbemr17405835pjb.246.1665751438890;
        Fri, 14 Oct 2022 05:43:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5ifZ1jlCleEuwr1u+Ew17uTK4Dheyaq03kgzjSdqzMzPfHzmk6AWVa8Luibul9eoMvfrxJ4WIPXjXFnAQ28dI=
X-Received: by 2002:a17:90a:f286:b0:20a:b521:7bbe with SMTP id
 fs6-20020a17090af28600b0020ab5217bbemr17405796pjb.246.1665751438385; Fri, 14
 Oct 2022 05:43:58 -0700 (PDT)
MIME-Version: 1.0
References: <20221014103443.138574-1-ihuguet@redhat.com> <Y0lSYQ99lBSqk+eH@lunn.ch>
In-Reply-To: <Y0lSYQ99lBSqk+eH@lunn.ch>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Fri, 14 Oct 2022 14:43:47 +0200
Message-ID: <CACT4ouct9H+TQ33S=bykygU_Rpb61LMQDYQ1hjEaM=-LxAw9GQ@mail.gmail.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     irusskikh@marvell.com, dbogdanov@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, Li Liang <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 2:14 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Fix trying to acquire rtnl_lock at the beginning of those functions, an=
d
> > returning if NIC closing is ongoing. Also do the "linkstate" stuff in a
> > workqueue instead than in a threaded irq, where sleeping or waiting a
> > mutex for a long time is discouraged.
>
> What happens when the same interrupt fires again, while the work queue
> is still active? The advantage of the threaded interrupt handler is
> that the interrupt will be kept disabled, and should not fire again
> until the threaded interrupt handler exits.

Nothing happens, if it's already queued, it won't be queued again, and
when it runs it will evaluate the last link state. And in the worst
case, it will be enqueued to run again, and if linkstate has changed
it will be evaluated again. This will rarely happen and it's harmless.

Also, I haven't checked it but these lines suggest that the IRQ is
auto-disabled in the hw until you enable it again. I didn't rely on
this, anyway.
        self->aq_hw_ops->hw_irq_enable(self->aq_hw,
                                       BIT(self->aq_nic_cfg.link_irq_vec));

Honestly I was a bit in doubt on doing this, with the threaded irq it
would also work. I'd like to hear more opinions about this and I can
change it back.

>
> > +static void aq_nic_linkstate_task(struct work_struct *work)
> > +{
> > +     struct aq_nic_s *self =3D container_of(work, struct aq_nic_s,
> > +                                          linkstate_task);
> > +
> > +#if IS_ENABLED(CONFIG_MACSEC)
> > +     /* avoid deadlock at aq_nic_stop -> cancel_work_sync */
> > +     while (!rtnl_trylock()) {
> > +             if (aq_utils_obj_test(&self->flags, AQ_NIC_FLAG_CLOSING))
> > +                     return;
> > +             msleep(AQ_TASK_RETRY_MS);
> > +     }
> > +#endif
> > +
> >       aq_nic_update_link_status(self);
> >
> > +#if IS_ENABLED(CONFIG_MACSEC)
> > +     rtnl_unlock();
> > +#endif
> > +
>
> If MACSEC is enabled, aq_nic_update_link_status() is called with RTNL
> held. If it is not enabled, RTNL is not held. This sort of
> inconsistency could lead to further locking bugs, since it is not
> obvious. Please try to make this consistent.

This is not new in these patches, that's what was already happening, I
just moved it to get the lock a bit earlier. In my opinion, this is as
it should be: why acquire a mutex if you don't have anything to
protect with it? And it's worse with rtnl_lock which is held by many
processes, and can be held for quite long times...

>
>          Andrew
>


--=20
=C3=8D=C3=B1igo Huguet

