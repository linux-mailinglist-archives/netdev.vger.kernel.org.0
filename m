Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D605B2404
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiIHQ4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiIHQzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:55:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032EFEA616
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 09:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662656030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jM/4652ZU+ilVOa2VHytxd0Y/6mr00fBnuvbs8bYj04=;
        b=N8naxf9JavYeVUGKh/aLgW2vI18i0xpDzM3mO0K5cVIvfsC9/38ooWG3w5XNpfHY4R4F3Z
        1asl/JPUoXwoxxoMM/6zDNs9BlOVc9QbqpAWkMJLNNiDet4P93Zcf3AdSWnr1moZeApDsR
        jdqvjJdWFcABmVrDtTIzsx8INrk2CfU=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-660-uSHQjH_WOFWBHxQ98p_TaQ-1; Thu, 08 Sep 2022 12:53:49 -0400
X-MC-Unique: uSHQjH_WOFWBHxQ98p_TaQ-1
Received: by mail-io1-f70.google.com with SMTP id c2-20020a6bec02000000b00689b26e92f0so11654931ioh.6
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 09:53:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jM/4652ZU+ilVOa2VHytxd0Y/6mr00fBnuvbs8bYj04=;
        b=R8Rlp7l4WjycKp7xBknTje4aRxw6brZkplK0KPJ8jkGy1P4zBKQpuEIZT7qdUcf6En
         //BMg5hzv7FlLqa0LQ7CeO1sL719X2oioSS48/vyktwAT5usCkHPfL2yvMjmG1DZ/dqr
         KOQ9/LWW3BNAwltoSRBwm8QOhj3LD3/OwPvwZQfifHn25WCMIw8gCFubcwVC5RwrH4Qi
         Ww4PTPVTFCRo9xU9u+3emLVNjFtb0p+N/FzH12akgYYRIzNZmcim3k3ldUoTuPiSYCDg
         CFeetjjRBrrS/8fkg1+r2JJH11q1ttpSKFOKU5xs7QuqVteZ9JeOPHjskUtjthwz6Lp9
         uwFQ==
X-Gm-Message-State: ACgBeo3ZuKKFBPeKS38W+0MdUSvkkkHXZ40L4gLYyrS3TfCqI9eAivpK
        YWL8St82kOr7pqwVEmthcnzDfiu6f811XbrNJKrXCYPy3Hg/IP36l+TS5WW4YglD0sjf2U7a4Au
        1t1jRx/AZ2UzLA5cc
X-Received: by 2002:a05:6602:2c95:b0:689:e4e2:2c02 with SMTP id i21-20020a0566022c9500b00689e4e22c02mr4502050iow.94.1662656027337;
        Thu, 08 Sep 2022 09:53:47 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4C0Z1a3e1j36Z0x3OLIC8ipRTXLsZlmpzmGPoLTlCAR7z8o7PJmPC/zPVvPBR23LI13B82fg==
X-Received: by 2002:a05:6602:2c95:b0:689:e4e2:2c02 with SMTP id i21-20020a0566022c9500b00689e4e22c02mr4502042iow.94.1662656027114;
        Thu, 08 Sep 2022 09:53:47 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g8-20020a92d7c8000000b002e67267b4bfsm1025299ilq.70.2022.09.08.09.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 09:53:46 -0700 (PDT)
Date:   Thu, 8 Sep 2022 10:53:45 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, joao.m.martins@oracle.com,
        yishaih@nvidia.com, maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [GIT PULL] Please pull mlx5 vfio changes
Message-ID: <20220908105345.28da7c98.alex.williamson@redhat.com>
In-Reply-To: <YxmMMR3u1VRedWdK@unreal>
References: <20220907094344.381661-1-leon@kernel.org>
        <20220907132119.447b9219.alex.williamson@redhat.com>
        <YxmMMR3u1VRedWdK@unreal>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Sep 2022 09:31:13 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Wed, Sep 07, 2022 at 01:21:19PM -0600, Alex Williamson wrote:
> > On Wed,  7 Sep 2022 12:43:44 +0300
> > Leon Romanovsky <leon@kernel.org> wrote:
> >   
> > > Hi Alex,
> > > 
> > > This series is based on clean 6.0-rc4 as such it causes to two small merge
> > > conficts whis vfio-next. One is in thrird patch where you should take whole
> > > chunk for include/uapi/linux/vfio.h as is. Another is in vfio_main.c around
> > > header includes, which you should take too.  
> > 
> > Is there any reason you can't provide a topic branch for the two
> > net/mlx5 patches and the remainder are rebased and committed through
> > the vfio tree?    
> 
> You added your Acked-by to vfio/mlx5 patches and for me it is a sign to
> prepare clean PR with whole series.
> 
> I reset mlx5-vfio topic to have only two net/mlx5 commits without
> special tag.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git topic/mlx5-vfio
> Everything else can go directly to your tree without my intervention.

Sorry, I knew the intention initially was to send a PR and I didn't
think about the conflicts we'd have versus the base you'd use.  Thanks
for splitting this out, I think it'll make for a cleaner upstream path
given the clear code split.

Yishai, can you post a v7 rebased on the vfio next branch?  The comment
I requested is now ephemeral since it only existed in the commits Leon
dropped.  Also feel free to drop my Acks since I'll add new Sign-offs.
Thanks,

Alex

