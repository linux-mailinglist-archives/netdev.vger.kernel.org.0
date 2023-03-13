Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1AA36B79FE
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjCMOLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjCMOK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:10:56 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7E26C19C;
        Mon, 13 Mar 2023 07:10:27 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id y189so2793270pgb.10;
        Mon, 13 Mar 2023 07:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678716626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ht9o1Rpg8r80GdsikkzvXlqYpvLBxzEFHcMldomiJSg=;
        b=e3w7k/2+Q+XmBHw4TrWj7O4XHw/qsvmVepR4XY5ZfCJub4JUfrKXNJ2HVvOaex+z5N
         +fkYMRJH625M1nCdf0AJ1da9CA7PRrl44BxK8mSGVQfErhScjytUZmMNw1yl0oMyol4I
         7hMp7MnHOhENxI7zuzA6pQdXT+0XoMYVMR8pRAmzGPkDoL6FIcc9kqm1E9rrbbPTZzQg
         o/PMYb/QiTK8IvWXfMMNS2E2/azzzbEABN2Rl+LcYNtL4AmdZR8TJIX7zEcBOYhvBEdH
         0qB7JqBUAS4cGuRhntg/3ckrQ9DgVOanw+VgBkLWqo5XBujJ6Gfi0GFXQSGfEjw5MviU
         preg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678716626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ht9o1Rpg8r80GdsikkzvXlqYpvLBxzEFHcMldomiJSg=;
        b=wp0eh8mEuZiUA/G5q6zpHBNMWr9Ofkdpb7HtfvKSsiaH7iKQt0yH3nSv0pD7qN19KH
         Ee4m/lRQeAg17UOkaE/V4oL/HhihFC++8Y/pvQLd31Wwci1YK0yNklZPHGy0ynuxp+sJ
         KrlkZ+05eVbxOsPz/h4RP0ZQdJjMjNvJTp60TR8T9e3lDU9+5gAAG/PRSN07h5bhBBTa
         6w+hpQY+22X9MGPYDBo9axL1r1fULhimIvme9Fhq4bAObcC4v+oXxU4HgHpFU+BXtjMI
         PJSYaPmKYuz0RPEfDuwhTDe2b+z4OnsJ4SlnsJgQpgo2wtndUByVpNpfDgOPqX7rHxVQ
         OC5A==
X-Gm-Message-State: AO0yUKVmxLJu239by+sR0NoH51opdV/+UL0vGycovHGzRlFr/jvG5qtz
        tDaCPMtCZx19TV2aoWOYO63nI9k6xm3RJcnoCxT6aP4jrM1QtPXl+PI=
X-Google-Smtp-Source: AK7set9dnEsbz+fkberoNUeb7gw2TtbQx0zJnNO2SNwjTPhfV3rVXiTgmWz5+lzHakZjJHPFs9Zx0qDMtBv491snjd0=
X-Received: by 2002:a62:8484:0:b0:5a9:d579:6902 with SMTP id
 k126-20020a628484000000b005a9d5796902mr3633248pfd.0.1678716626517; Mon, 13
 Mar 2023 07:10:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230313090002.3308025-1-zyytlz.wz@163.com> <ZA8rDCw+mJmyETEx@localhost.localdomain>
 <CAJedcCwgvo3meC=k_nPYrRzEj7Hzcy8kqrvHqHLvmPWLjCq_3Q@mail.gmail.com> <ZA8uMtMyYKhcEYQ/@localhost.localdomain>
In-Reply-To: <ZA8uMtMyYKhcEYQ/@localhost.localdomain>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Mon, 13 Mar 2023 22:10:15 +0800
Message-ID: <CAJedcCzLs3d3r1=3oXzE1=0Y=VhAfj62S3BgMNZjKbHYW0Wiaw@mail.gmail.com>
Subject: Re: [PATCH net v2] 9p/xen : Fix use after free bug in
 xen_9pfs_front_remove due to race condition
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, ericvh@gmail.com, lucho@ionkov.net,
        asmadeus@codewreck.org, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        1395428693sheep@gmail.com, alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michal Swiatkowski <michal.swiatkowski@linux.intel.com> =E4=BA=8E2023=E5=B9=
=B43=E6=9C=8813=E6=97=A5=E5=91=A8=E4=B8=80 22:08=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Mar 13, 2023 at 10:01:21PM +0800, Zheng Hacker wrote:
> > Michal Swiatkowski <michal.swiatkowski@linux.intel.com> =E4=BA=8E2023=
=E5=B9=B43=E6=9C=8813=E6=97=A5=E5=91=A8=E4=B8=80 21:54=E5=86=99=E9=81=93=EF=
=BC=9A
> > >
> > > On Mon, Mar 13, 2023 at 05:00:02PM +0800, Zheng Wang wrote:
> > > > In xen_9pfs_front_probe, it calls xen_9pfs_front_alloc_dataring
> > > > to init priv->rings and bound &ring->work with p9_xen_response.
> > > >
> > > > When it calls xen_9pfs_front_event_handler to handle IRQ requests,
> > > > it will finally call schedule_work to start the work.
> > > >
> > > > When we call xen_9pfs_front_remove to remove the driver, there
> > > > may be a sequence as follows:
> > > >
> > > > Fix it by finishing the work before cleanup in xen_9pfs_front_free.
> > > >
> > > > Note that, this bug is found by static analysis, which might be
> > > > false positive.
> > > >
> > > > CPU0                  CPU1
> > > >
> > > >                      |p9_xen_response
> > > > xen_9pfs_front_remove|
> > > >   xen_9pfs_front_free|
> > > > kfree(priv)          |
> > > > //free priv          |
> > > >                      |p9_tag_lookup
> > > >                      |//use priv->client
> > > >
> > > > Fixes: 71ebd71921e4 ("xen/9pfs: connect to the backend")
> > > > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > > > ---
> > > > v2:
> > > > - fix type error of ring found by kernel test robot
> > > > ---
> > > >  net/9p/trans_xen.c | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
> > > > index c64050e839ac..83764431c066 100644
> > > > --- a/net/9p/trans_xen.c
> > > > +++ b/net/9p/trans_xen.c
> > > > @@ -274,12 +274,17 @@ static const struct xenbus_device_id xen_9pfs=
_front_ids[] =3D {
> > > >  static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
> > > >  {
> > > >       int i, j;
> > > > +     struct xen_9pfs_dataring *ring =3D NULL;
> > > Move it before int i, j to have RCT.
> > >
> Sorry I didn't notice it before, move the definition to for loop.
>

Get it, will correct it in the next patch. Thanks for your notice :)

> > > >
> > > >       write_lock(&xen_9pfs_lock);
> > > >       list_del(&priv->list);
> > > >       write_unlock(&xen_9pfs_lock);
> > > >
> > > >       for (i =3D 0; i < priv->num_rings; i++) {
> Here:
> struct xen_9pfs_dataring *ring =3D &priv->rings[i];
>

Best regards,
Zheng
