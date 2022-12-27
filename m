Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58FC6567DF
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 08:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiL0Hef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 02:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiL0Hee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 02:34:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8146310B6
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672126430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h2F2GH9r8G5/9JPGcKQm0Kg39TfbvH77Y/WP493sark=;
        b=JWY/+/+CRUIyTNRTfzoCCrxhJHYa/KCLdrUGXBXo8KpzUlGUL9AiC+VMe/HDudvpuu2QQS
        l9M/6hGF4qZaGDhrlJJIxH89WwIM8b/ZzeB0SLAbdD5YOaGE+Z3W7KehF4gn24BqNBM13q
        6r5OnX63mXc/V3hkhBtyVBAqVDeUai8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-600-g12M_f9qNaue3Lm2LT0jNg-1; Tue, 27 Dec 2022 02:33:49 -0500
X-MC-Unique: g12M_f9qNaue3Lm2LT0jNg-1
Received: by mail-wm1-f69.google.com with SMTP id bd6-20020a05600c1f0600b003d96f7f2396so6066320wmb.3
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:33:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2F2GH9r8G5/9JPGcKQm0Kg39TfbvH77Y/WP493sark=;
        b=K+prCyX4rhKhFRQDG1z5QNWLl35fxAdd0a0UZYR1XbujwDk9tS9U7nPGTIvpewtX13
         y9jTwWWNhY26EZtLlf0YgTJAtMyLRpP+a7T8K2GNjw6uIu18moJKaRNaiUgRN7srVNlN
         a8rCzqDbKY2cwzCr9iPpaozTA6pVsg7yOaD0eKNodCatWsQD+bLVJJl8e1HKNd+n1Lgf
         JU2nTRf73WFUmMQ9o/5rjCwIkiBk78iB3kXbHcixrovHa8tFKiyKoigbNZ6qvITyclDW
         vJmXlWqUKAPEiXDlOtaJSJyE6Ob3LX1JkotebM3qfsbfQ0V2h0+IIbIKF2NzqqOJxNYc
         ToAQ==
X-Gm-Message-State: AFqh2kpvKXQJXmnL6K1+3jP/Y0wSq56zeAeNx7Q7CJFThYjVsKxmYXKG
        ZuoG/R2K7v4d5J36TVaqoBaGwG/NwbIsM2PQZpZOY3ZwzAfM7BpHmcHiN67dmPgytecyGpssw6p
        DcRVpYjHNZAqCzjEj
X-Received: by 2002:a5d:6849:0:b0:280:70e1:c24f with SMTP id o9-20020a5d6849000000b0028070e1c24fmr2305142wrw.68.1672126428060;
        Mon, 26 Dec 2022 23:33:48 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuclLqFnR9qkTo2hfrgyxoL/HUwscW2Ss3HBVsduIc3VD7zOi8RbL5ZWgzxX6AOL6LqRjw/Mg==
X-Received: by 2002:a5d:6849:0:b0:280:70e1:c24f with SMTP id o9-20020a5d6849000000b0028070e1c24fmr2305128wrw.68.1672126427814;
        Mon, 26 Dec 2022 23:33:47 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id c17-20020adffb51000000b0027cb20605e3sm5064232wrs.105.2022.12.26.23.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 23:33:47 -0800 (PST)
Date:   Tue, 27 Dec 2022 02:33:43 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
Message-ID: <20221227022255-mutt-send-email-mst@kernel.org>
References: <20221226074908.8154-1-jasowang@redhat.com>
 <20221226074908.8154-4-jasowang@redhat.com>
 <20221226183705-mutt-send-email-mst@kernel.org>
 <CACGkMEuNZLJRnWw+XNxJ-to1y8L2GrTrJkk0y0Gwb5H2YhDczQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEuNZLJRnWw+XNxJ-to1y8L2GrTrJkk0y0Gwb5H2YhDczQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 27, 2022 at 12:30:35PM +0800, Jason Wang wrote:
> > But device is still going and will later use the buffers.
> >
> > Same for timeout really.
> 
> Avoiding infinite wait/poll is one of the goals, another is to sleep.
> If we think the timeout is hard, we can start from the wait.
> 
> Thanks

If the goal is to avoid disrupting traffic while CVQ is in use,
that sounds more reasonable. E.g. someone is turning on promisc,
a spike in CPU usage might be unwelcome.

things we should be careful to address then:
1- debugging. Currently it's easy to see a warning if CPU is stuck
   in a loop for a while, and we also get a backtrace.
   E.g. with this - how do we know who has the RTNL?
   We need to integrate with kernel/watchdog.c for good results
   and to make sure policy is consistent.
2- overhead. In a very common scenario when device is in hypervisor,
   programming timers etc has a very high overhead, at bootup
   lots of CVQ commands are run and slowing boot down is not nice.
   let's poll for a bit before waiting?
3- suprise removal. need to wake up thread in some way. what about
   other cases of device breakage - is there a chance this
   introduces new bugs around that? at least enumerate them please.


-- 
MST

