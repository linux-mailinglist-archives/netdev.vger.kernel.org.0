Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50A55974EF
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbiHQRUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241182AbiHQRUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:20:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A151760C7
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660756828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E1x5LNrRWuvWgMZzul66wIPkfRn59vrBUCTEKqLPjoU=;
        b=DIDKnbS4bitFJ/nmetDMX6j2ebs8SPgpNWSvDlbrSonr8sSgvLMwfJB8y/AX08Sc8F2umS
        b6SlhzGsAo7ZJdVJCndR/lRsaJvPz4PJ6wPLMaFy2OsSivGNunPpen2Mito3xS4iPs+51p
        ZyJJBk9ZsygPe0Al0ttE4C5+s/f0tE0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-388-fBhm5je_Nlu7D8wu-enxFA-1; Wed, 17 Aug 2022 13:20:26 -0400
X-MC-Unique: fBhm5je_Nlu7D8wu-enxFA-1
Received: by mail-wr1-f72.google.com with SMTP id r17-20020adfa151000000b00224f8e2a2edso2221150wrr.0
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=E1x5LNrRWuvWgMZzul66wIPkfRn59vrBUCTEKqLPjoU=;
        b=MCxep37vhFqjBAPPGcgXRZHDIi5WP4aVfBEWEYk+KkQ3Vy3h8EbBKvI8MDZeqe4rt3
         p2hx0A8yPZYDBN8qFNozllJa6rEdsKdl8PJj8a7mR8dWKw7ArPXvENAOSAgCjjLLF0Ob
         iDad3kGLOtzMJCOFkshmGmy1eLBakocjlSPFenPANHBR5dhybHqajklN7buVmPyHyNBO
         nozC9srujzTxHfAIA81EscYN2X4k3f273+HTrPu3Yq21aMTJwD2n+IEDOSK4hpCWd/sY
         HRirvZIG5FpIabLRYjK83LXqTMsWG6HxAsfv+LNk2S0Ot5uZlPKXCm1VxuOSSzQmh+yY
         dCGA==
X-Gm-Message-State: ACgBeo1l9qI2v6xGIGua//s7VE6mFXhnjyc/Xx+8c7DbEOZ1NImBlUQq
        Dii8fwe3IEKg53eemVUNvGNaWADlyqf/OZ/wMWSsOjppG0XYmh5zGUP6DAB1WA1pOum85KLXW9v
        5R9iJpvbPO8oYueRS
X-Received: by 2002:a1c:19c2:0:b0:3a5:168e:a918 with SMTP id 185-20020a1c19c2000000b003a5168ea918mr2792770wmz.31.1660756825530;
        Wed, 17 Aug 2022 10:20:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4cDOhH9gb57ZgsmemV6RwBgg2yGkmkUplYW2gdzH3YejzjL5WNaW6YF8Ruh007bts4KbJ2Bw==
X-Received: by 2002:a1c:19c2:0:b0:3a5:168e:a918 with SMTP id 185-20020a1c19c2000000b003a5168ea918mr2792746wmz.31.1660756825315;
        Wed, 17 Aug 2022 10:20:25 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id h82-20020a1c2155000000b003a319bd3278sm2862407wmh.40.2022.08.17.10.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 10:20:24 -0700 (PDT)
Date:   Wed, 17 Aug 2022 13:20:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH 3/6] vsock: add netdev to vhost/virtio vsock
Message-ID: <20220817131437-mutt-send-email-mst@kernel.org>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <5a93c5aad99d79f028d349cb7e3c128c65d5d7e2.1660362668.git.bobby.eshleman@bytedance.com>
 <20220816123701-mutt-send-email-mst@kernel.org>
 <20220816110717.5422e976@kernel.org>
 <YvtAktdB09tM0Ykr@bullseye>
 <20220816160755.7eb11d2e@kernel.org>
 <YvtVN195TS1xpEN7@bullseye>
 <20220816181528.5128bc06@kernel.org>
 <Yvt2f5i5R9NNNYUL@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yvt2f5i5R9NNNYUL@bullseye>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 10:50:55AM +0000, Bobby Eshleman wrote:
> > > > Eh, I was hoping it was a side channel of an existing virtio_net 
> > > > which is not the case. Given the zero-config requirement IDK if 
> > > > we'll be able to fit this into netdev semantics :(  
> > > 
> > > It's certainly possible that it may not fit :/ I feel that it partially
> > > depends on what we mean by zero-config. Is it "no config required to
> > > have a working socket" or is it "no config required, but also no
> > > tuning/policy/etc... supported"?
> > 
> > The value of tuning vs confusion of a strange netdev floating around
> > in the system is hard to estimate upfront. 
> 
> I think "a strange netdev floating around" is a total
> mischaracterization... vsock is a networking device and it supports
> vsock networks. Sure, it is a virtual device and the routing is done in
> host software, but the same is true for virtio-net and VM-to-VM vlan.
> 
> This patch actually uses netdev for its intended purpose: to support and
> manage the transmission of packets via a network device to a network.
> 
> Furthermore, it actually prepares vsock to eliminate a "strange" use of
> a netdev. The netdev in vsockmon isn't even used to transmit
> packets, it's "floating around" for no other reason than it is needed to
> support packet capture, which vsock couldn't support because it didn't
> have a netdev.
> 
> Something smells when we are required to build workaround kernel modules
> that use netdev for ciphoning packets off to userspace, when we could
> instead be using netdev for its intended purpose and get the same and
> more benefit.

So what happens when userspace inevitably attempts to bind a raw
packet socket to this device? Assign it an IP? Set up some firewall
rules?

These things all need to be addressed before merging since they affect UAPI.


> > 
> > The nice thing about using a built-in fq with no user visible knobs is
> > that there's no extra uAPI. We can always rip it out and replace later.
> > And it shouldn't be controversial, making the path to upstream smoother.
> 
> The issue is that after pulling in fq for one kind of flow management,
> then as users observe other flow issues, we will need to re-implement
> pfifo, and then TBF, and then we need to build an interface to let users
> select one, and to choose queue sizes... and then after awhile we've
> needlessly re-implemented huge chunks of the tc system.
> 
> I don't see any good reason to restrict vsock users to using suboptimal
> and rigid queuing.
> 
> Thanks.

