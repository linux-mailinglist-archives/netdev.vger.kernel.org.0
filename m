Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E112D58B022
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 21:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiHETB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 15:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiHETB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 15:01:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87E1BAE76
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 12:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659726085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7jrr///GTPolXMT+fiyn3eyuZH49mBtYTjRUTuSdpSs=;
        b=EcJkzmngwNK2u4mqHfiov0BQCBUs6EtAwVSUBwsZqra6ea+AmtlBVAM7UquxD/G5JY05JJ
        7vpEnjIfMRF2HzL5kjIGqNyOFrZQNThMBvryEofmbvoUmCDH1w6gAKgNAJCKVHV7AUjHV9
        ddYXTfSYrdAdIRHACzxUbDprYRaCnYE=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-1NScn8cONvmsSUh0tbDJ4g-1; Fri, 05 Aug 2022 15:01:24 -0400
X-MC-Unique: 1NScn8cONvmsSUh0tbDJ4g-1
Received: by mail-il1-f197.google.com with SMTP id k11-20020a92c24b000000b002dd46b47e01so2217762ilo.14
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 12:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=7jrr///GTPolXMT+fiyn3eyuZH49mBtYTjRUTuSdpSs=;
        b=YIZOgxjgaUOI26i/lGqyIc70pA1FU4ywUl3qISyi4BI7ctPRXuHFigUF0or2iHA1/E
         K8HK5G7YDrJKJLD11Q2BEv3gBhe27zH6oiDYBW5sKGtBj181rvvdJVKjwIzC5sfUR6xT
         4O2En85sr9OKvx1IEJ6Dybi640NDsm4zRC9VLfNW5dzXC4oTqzdWPzmueX7CBKoFlC/5
         KoIY7yQHQbbxJdvZe1RDvzAnDBFAT12BvaMo+wS8E5Vi28N+H+NP/43rAIklb4uUwy0B
         PwfDhjgaGfo0was9aiwNB5or27OrmFWkTcf6msMqbU+PJFdFnvW6lfg2Xi5IkR7B2JFs
         BuTg==
X-Gm-Message-State: ACgBeo0N9l91/ekQqltE4BVAndC8YTigxoGfO4kF5Cju0d68/lM0fKKh
        /hX5Qx5pfd0/0gPwLtqGd7Zvw3zVhjznK50zzlFFHT+aob3FCinucrlCT9qkuKEgxQ+yG4jA9js
        1k+V9QbVpluUsfgVB
X-Received: by 2002:a05:6638:1305:b0:33f:7e59:4bc7 with SMTP id r5-20020a056638130500b0033f7e594bc7mr3471387jad.316.1659726083690;
        Fri, 05 Aug 2022 12:01:23 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5tl8wkqOGSRQbqQPvsP8x/sMHa+aTSdU4oxacleMUjEkM/f7HmEieSFt52FFtURojAjdepMg==
X-Received: by 2002:a05:6638:1305:b0:33f:7e59:4bc7 with SMTP id r5-20020a056638130500b0033f7e594bc7mr3471385jad.316.1659726083508;
        Fri, 05 Aug 2022 12:01:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f43-20020a02242b000000b00342744f18a9sm1983541jaa.99.2022.08.05.12.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 12:01:23 -0700 (PDT)
Date:   Fri, 5 Aug 2022 13:01:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V3 vfio 04/11] vfio: Move vfio.c to vfio_main.c
Message-ID: <20220805130121.36a2697d.alex.williamson@redhat.com>
In-Reply-To: <Yu08gdx2Py9vAN1n@nvidia.com>
References: <20220731125503.142683-1-yishaih@nvidia.com>
        <20220731125503.142683-5-yishaih@nvidia.com>
        <Yu08gdx2Py9vAN1n@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Aug 2022 12:51:29 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Sun, Jul 31, 2022 at 03:54:56PM +0300, Yishai Hadas wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > If a source file has the same name as a module then kbuild only supports
> > a single source file in the module.
> > 
> > Rename vfio.c to vfio_main.c so that we can have more that one .c file
> > in vfio.ko.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > 
> > ---
> >  drivers/vfio/Makefile                | 2 ++
> >  drivers/vfio/{vfio.c => vfio_main.c} | 0
> >  2 files changed, 2 insertions(+)
> >  rename drivers/vfio/{vfio.c => vfio_main.c} (100%)  
> 
> Alex, could you grab this patch for the current merge window?
> 
> It is a PITA to rebase across, it would be nice to have the rename in
> rc1

No objection from me, I'll see if Linus picks up my current pull
request and either pull this in or send it separately next week.
Thanks,

Alex

