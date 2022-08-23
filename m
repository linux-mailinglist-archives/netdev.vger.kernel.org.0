Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2E659EDD6
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 22:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiHWU5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 16:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiHWU5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 16:57:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D826A6F252
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 13:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661288226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Ye9Fi4oA+sgS1EZvFu2xD8Gq2Q7V2mGd9cMXbr5HfE=;
        b=M5lkpdiJ6Gbd1EZg3Yc1yf+6u2VORasYLIt0WZSwVAlg6jenFZSYVqGYqYQap74dYj93vp
        79LIYe+JcN6NAkqfcDTevziFZyXQ21KK4wn3Yd/JvoYtYn4PNvly0xR8NQbmA7cqrfZR6u
        p7sHV1fPYYThQf174McRiADXHZ8PXUU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-437-S7RVAJd-OkKXN1VccgziaA-1; Tue, 23 Aug 2022 16:57:04 -0400
X-MC-Unique: S7RVAJd-OkKXN1VccgziaA-1
Received: by mail-wm1-f72.google.com with SMTP id f18-20020a05600c4e9200b003a5f81299caso8459537wmq.7
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 13:57:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=3Ye9Fi4oA+sgS1EZvFu2xD8Gq2Q7V2mGd9cMXbr5HfE=;
        b=BkcMt6wSo21OhqHpeHruOkbc0vzT86GfAhee03t8MzWKkhZf7sbexs+ytb43gG9vZU
         /L50aBKksERlQhU6SA3g+6NxevaF7og0vQ3MJ1zJ8NlWrEdoVfjoicDnCKHcs69RghTb
         J4KQBalSP1G+VCv8RFJU1jtudjURf/jtVqTUpz9Soa3tI6JORpVmBa9Lu10+JVwqlW2k
         ql/NXrLugVv9pTZYlMHQzNXsoE/NEBj38uArBXJvvlJgj5gHxcZGMLiTRhdeiasx/i6J
         1fuHTpehLZ8RfGrfNuR9pf96/AQHpN1XOpWqXk6JgmXxKPs5VL9RhPDbcaaIBVRXHMGL
         tEJg==
X-Gm-Message-State: ACgBeo12FVFzd/O27cX85zNwC8sKsfmW9jatklDa5ThJnULC4IRBdb11
        SNSCoGW8/upem2mET8z6F6NhruttX/kdsO9VMQCQSZ6WPKoXLcicr5Q0zbnXeQvGCZ4xKntdJAT
        SEz9+6irMUOztVhb9
X-Received: by 2002:a5d:6d8c:0:b0:225:57a2:9564 with SMTP id l12-20020a5d6d8c000000b0022557a29564mr7076786wrs.139.1661288223797;
        Tue, 23 Aug 2022 13:57:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR54Q25oOQQy6ncWsx6VrUpN/F0yvxwJjNCy88FJ6OQgWy/SD0qe1rcQwPjDrsdsaDlIGDXXRg==
X-Received: by 2002:a5d:6d8c:0:b0:225:57a2:9564 with SMTP id l12-20020a5d6d8c000000b0022557a29564mr7076778wrs.139.1661288223584;
        Tue, 23 Aug 2022 13:57:03 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-176.dyn.eolo.it. [146.241.97.176])
        by smtp.gmail.com with ESMTPSA id 25-20020a05600c029900b003a62bc1735asm280179wmk.9.2022.08.23.13.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 13:57:03 -0700 (PDT)
Message-ID: <5174d4ef7fe3928472d5a575c87ee627bfb4c129.camel@redhat.com>
Subject: Re: [PATCH net-next v4 0/9] vsock: updates for SO_RCVLOWAT handling
From:   Paolo Abeni <pabeni@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Date:   Tue, 23 Aug 2022 22:57:01 +0200
In-Reply-To: <YwU443jzc/N4fV3A@fedora>
References: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
         <YwUnAhWauSFSJX+g@fedora> <20220823121852.1fde7917@kernel.org>
         <YwU443jzc/N4fV3A@fedora>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
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

On Tue, 2022-08-23 at 16:30 -0400, Stefan Hajnoczi wrote:
> On Tue, Aug 23, 2022 at 12:18:52PM -0700, Jakub Kicinski wrote:
> > On Tue, 23 Aug 2022 15:14:10 -0400 Stefan Hajnoczi wrote:
> > > Stefano will be online again on Monday. I suggest we wait for him to
> > > review this series. If it's urgent, please let me know and I'll take a
> > > look.
> > 
> > It was already applied, sorry about that. But please continue with
> > review as if it wasn't. We'll just revert based on Stefano's feedback
> > as needed.
> 
> Okay, no problem.

For the records, I applied the series since it looked to me Arseniy
addressed all the feedback from Stefano on the first patch (the only
one still lacking an acked-by/reviewed-by tag) and I thought it would
be better avoiding such delay.

We are still early in this net-next cycle, I think it can be improved
incrementally as needed.

Paolo

