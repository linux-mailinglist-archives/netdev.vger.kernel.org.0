Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F18660411
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjAFQPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjAFQPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:15:38 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663A83E86F
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 08:15:37 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id c124so2318603ybb.13
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 08:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3A1vzUA9HFSXNRdaWQWHLlpCuOI1nmI5yJWhhjpwAUA=;
        b=ljdR9dBGuK6eUYoM0rJxFocsXyJnNQJOju3wPlsAlEYRZYcdM4g4tSiCxOgaN1fQ/W
         Acf+WWfYTEdlMm3n+w2gpkMOXW0hIbV68hC3aPU89GxYWMOhEoRcz+rU9lNR2AFlcGge
         FeJWfnwrRhQrhBp+Y0ovwrWROl1t/UNhGzvo7Q+n8BhCYxFovQZ5LktUm3VINYcuYuiT
         CXVzyZ4V/YsdoNQPMGHLViQTSbbDc5phFdFA065gAJlTLTRKhUlHYvMH/Zf1vGIef3y7
         P4So6eO91mlzDBoE9UGVXukspicrpgHQNfqIsZ3PQgtIjL9Do6VmI9YvFVRyCshjCeNp
         2IyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3A1vzUA9HFSXNRdaWQWHLlpCuOI1nmI5yJWhhjpwAUA=;
        b=DBNLW531+fymdurv2R9rL5GFhOU43/X1269hB1zl45K9ZdeLkXjFZr4OowrAS29xJM
         JW9cs277VTSxinwXegOnZiofjGPWKsSjlIiDQ/6cqK2aKkQzrDndEkMoNYLQmdr5NkyB
         gP2MiKW3Tmp4uKk6Mifs0q4N1HpukrG1U/hIPv2NCEGQoWc+0CCGm9q7aK9GRp3TvKKe
         I0mRs9CDulEMvpo+6qJm+CiIPM1evWv8pzkpBRbMyx6Bjeg7kFI73I05Sq3XAJoBFDOw
         pyeJeabLd57II1VDPjyqoFZf655bmPnrM/qKbOpfYX/cY1I3QwId+6dXtMVEtb2Ig/Xz
         u9xA==
X-Gm-Message-State: AFqh2kr2KLxhm2xaAw90/8TKgoeQ7f+JH3sMVhqn8jMBaBEPbFlbx3aX
        XMH6pdrOQrtDI076ndk8VXHhzg==
X-Google-Smtp-Source: AMrXdXtxpu9G3tp2YE/pheJJtCymUzG9B31gkBJf5HL/d8t67k0ELVkBUJHmyOHvhEXFZas/dg+6AQ==
X-Received: by 2002:a5b:388:0:b0:732:d27:6721 with SMTP id k8-20020a5b0388000000b007320d276721mr57734691ybp.3.1673021736575;
        Fri, 06 Jan 2023 08:15:36 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id t11-20020a05620a034b00b006fa31bf2f3dsm720621qkm.47.2023.01.06.08.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 08:15:35 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1pDpNX-006PdO-7F;
        Fri, 06 Jan 2023 12:15:35 -0400
Date:   Fri, 6 Jan 2023 12:15:35 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Cc:     kamalheib1@gmail.com, shiraz.saleem@intel.com, leon@kernel.org,
        sashal@kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Igor Raits <igor.raits@gooddata.com>
Subject: Re: Network do not works with linux >= 6.1.2. Issue bisected to
 "425c9bd06b7a70796d880828d15c11321bdfb76d" (RDMA/irdma: Report the correct
 link speed)
Message-ID: <Y7hJJ5hIxDolYIAV@ziepe.ca>
References: <CAK8fFZ6A_Gphw_3-QMGKEFQk=sfCw1Qmq0TVZK3rtAi7vb621A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8fFZ6A_Gphw_3-QMGKEFQk=sfCw1Qmq0TVZK3rtAi7vb621A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 08:55:29AM +0100, Jaroslav Pulchart wrote:
> [  257.967099] task:NetworkManager  state:D stack:0     pid:3387
> ppid:1      flags:0x00004002
> [  257.975446] Call Trace:
> [  257.977901]  <TASK>
> [  257.980004]  __schedule+0x1eb/0x630
> [  257.983498]  schedule+0x5a/0xd0
> [  257.986641]  schedule_timeout+0x11d/0x160
> [  257.990654]  __wait_for_common+0x90/0x1e0
> [  257.994666]  ? usleep_range_state+0x90/0x90
> [  257.998854]  __flush_workqueue+0x13a/0x3f0
> [  258.002955]  ? __kernfs_remove.part.0+0x11e/0x1e0
> [  258.007661]  ib_cache_cleanup_one+0x1c/0xe0 [ib_core]
> [  258.012721]  __ib_unregister_device+0x62/0xa0 [ib_core]
> [  258.017959]  ib_unregister_device+0x22/0x30 [ib_core]
> [  258.023024]  irdma_remove+0x1a/0x60 [irdma]
> [  258.027223]  auxiliary_bus_remove+0x18/0x30
> [  258.031414]  device_release_driver_internal+0x1aa/0x230
> [  258.036643]  bus_remove_device+0xd8/0x150
> [  258.040654]  device_del+0x18b/0x3f0
> [  258.044149]  ice_unplug_aux_dev+0x42/0x60 [ice]

We talked about this already - wasn't it on this series?

Don't hold locks when removing aux devices.

> [  258.048707]  ice_lag_changeupper_event+0x287/0x2a0 [ice]
> [  258.054038]  ice_lag_event_handler+0x51/0x130 [ice]
> [  258.058930]  raw_notifier_call_chain+0x41/0x60
> [  258.063381]  __netdev_upper_dev_link+0x1a0/0x370
> [  258.068008]  netdev_master_upper_dev_link+0x3d/0x60
> [  258.072886]  bond_enslave+0xd16/0x16f0 [bonding]
> [  258.077517]  ? nla_put+0x28/0x40
> [  258.080756]  do_setlink+0x26c/0xc10
> [  258.084249]  ? avc_alloc_node+0x27/0x180
> [  258.088173]  ? __nla_validate_parse+0x141/0x190
> [  258.092708]  __rtnl_newlink+0x53a/0x620
> [  258.096549]  rtnl_newlink+0x44/0x70

Especially not the rtnl.

Jason
