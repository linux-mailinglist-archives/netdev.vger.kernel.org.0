Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888EC52D68C
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239776AbiESO6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240028AbiESO57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:57:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3932F3B543
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652972277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c8jDbEvRi6+iV6qqKNcRhWpgw9xMZvSzaM7VjjYN6zI=;
        b=I3vxrzFQHHVw3qORFuT2kHy12/hlXJ8YlVcE3QY8WVzIT+y4ctvHC92of/qPLe126powey
        ecmiOwdVx4nZ6hFdkyKBcm9OQz2CI0YlwQOLhe3RFJ+Cdcw51TrRw5En4egeQi+t9FTe/V
        sOep8g+fCAWrQ5XbmWytbxtM0P2i1xQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-NHbZwb1PNxu_Jrjqs48qvA-1; Thu, 19 May 2022 10:57:55 -0400
X-MC-Unique: NHbZwb1PNxu_Jrjqs48qvA-1
Received: by mail-qv1-f72.google.com with SMTP id kl23-20020a056214519700b0046200065604so1295867qvb.19
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:57:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c8jDbEvRi6+iV6qqKNcRhWpgw9xMZvSzaM7VjjYN6zI=;
        b=f53yVk5t7h1Q+Wk0hdlXLJSMdmyeqgOUmapVQEz2uiEedczZBRcRYJHXIYq0iaejAM
         nmaMbJQCjAikb8vU1nAUU4owJxJ2mO9wJsDKWPTDxedMrAc+98hijHukFNAKpaQlAfeq
         CwKaGwq2K1ZI5aKYSUkWNclXpQfoGUNfqAdKl22zo4aQ2ar31JjJyD1WXyznh/EPmAeA
         cIO6mnImTsO0RfEHLt1M2oX/Ps7zIW9PpL1RjjsFsyVlgoqZVxIOOvgZPb6CzRwMJBOk
         v27/lxbwCUseuCUgIfRSIUxjuxbZZo8BOQE5VQh7V1rcOQ1MEI6XG4hwRaaSQF7DTI/A
         wYKA==
X-Gm-Message-State: AOAM532p3X92d6BI0cJvEJTVz8yrLOAN+sNhlO2+3nzRlwDrLl7ZHbGP
        ubPgPctpOwU7FyDgz8CDWjpjafsJmdeQI+7ezoHyKqFjRZZLAy0agO2HgXQl/zQKbN0oEk53Rd0
        epBAhgFPbet+tdjxgrVDoL78QbTshrPYB
X-Received: by 2002:a05:622a:1899:b0:2f3:b09e:dbe9 with SMTP id v25-20020a05622a189900b002f3b09edbe9mr4153450qtc.199.1652972274465;
        Thu, 19 May 2022 07:57:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5fazVz2A8H1loe5PClxt9eyMGCIRyQO4I122g38usxKCQLkuCLe8K4TMfFt2GmgorC7+KG/yG0SowbzBLDLc=
X-Received: by 2002:a05:622a:1899:b0:2f3:b09e:dbe9 with SMTP id
 v25-20020a05622a189900b002f3b09edbe9mr4153431qtc.199.1652972274265; Thu, 19
 May 2022 07:57:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220519143145.767845-1-eperezma@redhat.com> <20220519144801.m7ioxoa5beo5jzv7@sgarzare-redhat>
In-Reply-To: <20220519144801.m7ioxoa5beo5jzv7@sgarzare-redhat>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 19 May 2022 16:57:18 +0200
Message-ID: <CAJaqyWfywBEe21P1a1LG2v=Ab2d-L5x19MrtWLvDqccOxFLMqQ@mail.gmail.com>
Subject: Re: [PATCH] vdpasim: allow to enable a vq repeatedly
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Michael Tsirkin <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org, Gautam Dawar <gdawar@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        kvm list <kvm@vger.kernel.org>, Cindy Lu <lulu@redhat.com>,
        netdev@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Parav Pandit <parav@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 4:48 PM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> On Thu, May 19, 2022 at 04:31:45PM +0200, Eugenio P=C3=A9rez wrote:
> >Code must be resilient to enable a queue many times.
> >
> >At the moment the queue is resetting so it's definitely not the expected
> >behavior.
> >
> >Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
> >Cc: stable@vger.kernel.org
> >Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >---
> > drivers/vdpa/vdpa_sim/vdpa_sim.c | 5 +++--
> > 1 file changed, 3 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vd=
pa_sim.c
> >index ddbe142af09a..b53cd00ad161 100644
> >--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> >+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> >@@ -355,9 +355,10 @@ static void vdpasim_set_vq_ready(struct vdpa_device=
 *vdpa, u16 idx, bool ready)
> >       struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
> >
> >       spin_lock(&vdpasim->lock);
> >-      vq->ready =3D ready;
> >-      if (vq->ready)
> >+      if (!vq->ready) {
> >+              vq->ready =3D ready;
> >               vdpasim_queue_ready(vdpasim, idx);
> >+      }
>
> But this way the first time vq->ready is set to true, then it will never
> be set back to false.
>

You're right, I had in mind to reset the flow before enabling as the
only possibility.

Sending v2 with that part fixed, thanks!

> Should we leave the assignment out of the block?
> Maybe after the if block to avoid the problem we are fixing.
>
> Thanks,
> Stefano
>

