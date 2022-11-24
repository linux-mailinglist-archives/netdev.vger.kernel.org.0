Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64190637668
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 11:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiKXK2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 05:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiKXK2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 05:28:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE2626577
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669285662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pn7rCC3CWcfcfwcb+CXJIb0K1hMCjk7+sCKEh7DDk+Y=;
        b=XVkrY4zyMKnFPqt4IcCC7/nqueAyt2nPR4Uz5e3iTdr/Pel/oU0XZiZomEX0WUK4LYd9MV
        TQspx8X2GIkBXpW6+04chQZ3pUeHhaNf9N/4lc01ihRsenTqeqIdnI5Dbs8YyXjULERDQj
        vD4jpZkCTxSobrM0oCHZJlSDbD0cBh4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-624-ImZynyo-Ntm-G5cIMtHZiQ-1; Thu, 24 Nov 2022 05:27:39 -0500
X-MC-Unique: ImZynyo-Ntm-G5cIMtHZiQ-1
Received: by mail-wm1-f72.google.com with SMTP id az40-20020a05600c602800b003cfa26c40easo2685846wmb.1
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:27:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pn7rCC3CWcfcfwcb+CXJIb0K1hMCjk7+sCKEh7DDk+Y=;
        b=GB70wLGcwO+CmEUyZqmpy8ae70HbCx9W1rUQpIMGQT3EXrXXR292QSo2rAS4iusHVO
         RxW5PNOtuS7ZC2+1xJROAQfLjDe/bh4jmWVRHVA4WxiXVTfuMo4B76C75r/lMRpyy37C
         4vRi66vU0XdRIugDHgsJD9y8II+ic/sTGxzOExfkIcWmjaXbJfGTDsEj2Rd/KIQQ3lAH
         QGkLOTE87rZF9sDEYTKAvnDHLqK1eQWVjdcW8KLZzb4tBESt3i4R8LeDK8GOZ/Fva0qk
         JvzF2zs5nKapVGQiU3mbIa1Gdv5HUbKd6IbAKXo9ITjqoWAjOAlXi0Snql7+zU2OInBW
         BOfA==
X-Gm-Message-State: ANoB5plt8pBoZe7GS974y/1RJnOQFCSw6UJIN45ZRvk1igD8wTBad3sG
        PH+FvHPnQWxaOrRYsihzRf3qACeiZrjt3LFUlV7DIUQOepsD46d3oB26iu8zHhLk8rpmFMGfsz6
        cFkcxDxVNBH3zHQ2m
X-Received: by 2002:a7b:ce8c:0:b0:3cf:8b2d:8cbc with SMTP id q12-20020a7bce8c000000b003cf8b2d8cbcmr12318202wmj.89.1669285658312;
        Thu, 24 Nov 2022 02:27:38 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6h5IPDk9Fg4jVKKL8T7WTgKp+hIPWxes19NBdIZgo96iVZvVlCARdlGYbWsGP8h22yr9b/LA==
X-Received: by 2002:a7b:ce8c:0:b0:3cf:8b2d:8cbc with SMTP id q12-20020a7bce8c000000b003cf8b2d8cbcmr12318184wmj.89.1669285658131;
        Thu, 24 Nov 2022 02:27:38 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id n6-20020a1ca406000000b003d005aab31asm5061563wme.40.2022.11.24.02.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 02:27:37 -0800 (PST)
Date:   Thu, 24 Nov 2022 11:27:35 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com,
        syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com,
        syzbot+de987172bb74a381879b@syzkaller.appspotmail.com
Subject: Re: [PATCH net] l2tp: Don't sleep and disable BH under writer-side
 sk_callback_lock
Message-ID: <20221124102735.GA4647@pc-4.home>
References: <87wn7o7k7r.fsf@cloudflare.com>
 <ef09820a-ca97-0c50-e2d8-e1344137d473@I-love.SAKURA.ne.jp>
 <87fseb7vbm.fsf@cloudflare.com>
 <f2fdb53a-4727-278d-ac1b-d6dbdac8d307@I-love.SAKURA.ne.jp>
 <871qpvmfab.fsf@cloudflare.com>
 <a3b7d8cd-0c72-8e6b-78f2-71b92e70360f@I-love.SAKURA.ne.jp>
 <20221122141011.GA3303@pc-4.home>
 <c50bb326-7946-82b9-418a-95638818aa84@I-love.SAKURA.ne.jp>
 <20221123152400.GA18177@pc-4.home>
 <20221124100751.GA6671@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124100751.GA6671@katalix.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 10:07:51AM +0000, Tom Parkin wrote:
> On  Wed, Nov 23, 2022 at 16:24:00 +0100, Guillaume Nault wrote:
> > On Tue, Nov 22, 2022 at 11:28:45PM +0900, Tetsuo Handa wrote:
> > > That's what I thought at https://lkml.kernel.org/r/c64284f4-2c2a-ecb9-a08e-9e49d49c720b@I-love.SAKURA.ne.jp .
> > > 
> > > But the problem is not that setup_udp_tunnel_sock() can sleep. The problem is that lockdep
> > > gets confused due to changing lockdep class after the socket is already published. We need
> > > to avoid calling lockdep_set_class_and_name() on a socket retrieved via sockfd_lookup().
> > 
> > This is a second problem. The problem of setting sk_user_data under
> > sk_callback_lock write protection (while still calling
> > udp_tunnel_encap_enable() from sleepable context) still remains.
> > 
> > For lockdep_set_class_and_name(), maybe we could store the necessary
> > socket information (addresses, ports and checksum configuration) in the
> > l2tp_tunnel structure, thus avoiding the need to read them from the
> > socket. This way, we could stop locking the user space socket in
> > l2tp_xmit_core() and drop the lockdep_set_class_and_name() call.
> > I think either you or Jakub proposed something like this in another
> > thread.
> 
> I note that l2tp_xmit_core calls ip_queue_xmit which expects a socket
> atomic context*.
> 
> It also accesses struct inet_sock corking data which may also need locks
> to safely access.
> 
> Possibly we could somehow work around that, but on the face of it we'd
> need to do a bit more work to avoid the socket lock in the tx path.

I was thinking of avoiding using the socket entirely, which indeed
means replacing ip_queue_xmit(). We should probably use the different
variants of udp_tunnel_xmit_skb() instead.

> * davem fixed locking in the l2tp xmit path in:
> 
> 6af88da14ee2 ("l2tp: Fix locking in l2tp_core.c")
> -- 
> Tom Parkin
> Katalix Systems Ltd
> https://katalix.com
> Catalysts for your Embedded Linux software development

