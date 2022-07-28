Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3B3583AA6
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 10:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbiG1Iup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 04:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbiG1Iuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 04:50:37 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950AF3D5B4
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:50:32 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q18so1294039wrx.8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZgzacCaCOoerdDx6vlz2KKkQdgG6Y3WTQI+PEXOK+1U=;
        b=rp1DvlRxhlGH+PfDRgpXZ1PlEORceia1n4i1cOtvV4B87NrqQRwQaqMnsL6qY9KODm
         Uf2EsQIxVm53pNzhyV9JRrsOo0CRxOZpqEQXs/iyrz0EQ3nqDHAt/HrZShMzb9fcXi1y
         qfx1Lp3pctKDyH4/T8MxeP5w96w7AOqKl0bNYya38hpdNRwQgxZLXGyIlW3+u3iTEzdU
         N+aqQNNzFK/go2irgPenzt1LB2bp54znKb2xixosUcCqZApnCbdjYvt06UPoPbYum4TC
         mGX5PfC+Kf7mSGssmgUlWGVc+YQSVEiji+8icnf25F+7m5aFgp79S1H3Z7o7b6h0vDXh
         awZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZgzacCaCOoerdDx6vlz2KKkQdgG6Y3WTQI+PEXOK+1U=;
        b=Hgnq+arbiC08LIIY6kvT3dvMmWTgFUTTb5hksiqv20lv544QCzNb3aLk3B7HJu6hpY
         idWL0EmDzqbFryyLjtom+GAX0I/fi93A5XR0NqSl7xKebShqzIH4oBFFUOouiM9CpQ10
         MXWAdEOmQ9DPAjYwOVtgXDNuPz92mvPpVcZO/m9GPul2xn5Flp0lKF9jN4RAQ+C4nPDr
         0BbqHbu2kgj3gAgmvkmq7ZwyHemEKYP0XwogvdAv5JHqGDxYUfgVdxHV1Vt5ZYlpZEMl
         dvua+WxDJhRhy4RmKOnbj8WNYxQM8LqYzJOezfk/Bf5C9V3Jzvp3EHW4ijwR/Icin+bC
         pZsw==
X-Gm-Message-State: AJIora+6LiHkNE3iWlV51dcBcdRVrXBnPKa/EsvDW3QH/nfZE3NVhHKH
        wtPIn7SS+fPqcAN01A5BMKNlzA==
X-Google-Smtp-Source: AGRyM1ukRrnzSFARU+p3ApPqgHS/ISS7zQCOhaCEKXCtOuyA9HGOq4Z1mtAh3f8AsLYvb6YbgtIx9A==
X-Received: by 2002:adf:ee85:0:b0:21e:485a:9720 with SMTP id b5-20020adfee85000000b0021e485a9720mr16242004wro.579.1658998230925;
        Thu, 28 Jul 2022 01:50:30 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j20-20020a5d6e54000000b0021e5e5cd3a8sm312317wrz.87.2022.07.28.01.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 01:50:30 -0700 (PDT)
Date:   Thu, 28 Jul 2022 10:50:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/9] net: devlink: remove region snapshots list
 dependency on devlink->lock
Message-ID: <YuJN1SYkPR33trcs@nanopsycho>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
 <1658941416-74393-3-git-send-email-moshe@nvidia.com>
 <20220727190156.0ec856ae@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727190156.0ec856ae@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 28, 2022 at 04:01:56AM CEST, kuba@kernel.org wrote:
>On Wed, 27 Jul 2022 20:03:29 +0300 Moshe Shemesh wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> After mlx4 driver is converted to do locked reload,
>> devlink_region_snapshot_create() may be called from both locked and
>> unlocked context.
>
>You need to explain why, tho. What makes region snapshots special? 

Will do.


>
>> So resolve this by removing dependency on devlink->lock for region
>> snapshots list consistency and introduce new mutex to ensure it.
>
>I was hoping to avoid per-subobject locks. What prevents us from
>depending on the instance lock here (once the driver is converted)?

The fact that it could be called in mlx4 from both devl locked and
unlocked context. Basically whenever CMD to fw is called.

What is wrong in small locks here and there when they are sufficient?

