Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA03653FB68
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 12:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240618AbiFGKfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 06:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbiFGKf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 06:35:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABF5AEC314
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 03:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654598123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2wCnpTvBJaVs6eVMriCXRwE0A4oztOYgT9vPKYbw5nY=;
        b=Sqg/O/8Xy0ET9+up6aOmITIA0nA7Cd0xu74nQTjxL/7xJi4dvz/ahn/B6uSnST9whjJVv/
        TuyfUn117C6TJQX32zf1y31w6S7s/OU16HtIu2HkNH8Y/l/vctWeixHKuxzx6ODNn3UGgQ
        pGFjjwTsF3Tqp/cboXcUorlC75kVK9w=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-VSYsfbOVMXWfSBxxv-mc5w-1; Tue, 07 Jun 2022 06:35:22 -0400
X-MC-Unique: VSYsfbOVMXWfSBxxv-mc5w-1
Received: by mail-qv1-f69.google.com with SMTP id kk8-20020a056214508800b004645738eff6so7408009qvb.8
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 03:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=2wCnpTvBJaVs6eVMriCXRwE0A4oztOYgT9vPKYbw5nY=;
        b=oHZP7wPpPQ5g2DJKGOI8Vlf1ORBfyCoCaOvDxViLBOUXZaNXT5LOqOmhPhEJP8iXq3
         fx9x9bdssaEEjtsW/WxDOnE8u1qaWY+XUdPm4gHJ7XSfMHCO2BOhUOvBCBvfNrqydYDm
         sl4OF3qiRd9SDewNPIRvjxxDKLe8BbyalJW4hXpWzv89XCTUg5+1jVlhlaE+WS87mxOm
         FdeDmHR/rtKnOZRPd6PisnVk2xCpUqpONMXjrVe7YKOTwb6CU9CrgLIhhMXP+OHAU43U
         9+qxwYncxt6SxC2A/WFFjqykihSMP/Cf38bXuSctcsveBzkFPTheIpXolwmxCDIjhgnK
         i4dg==
X-Gm-Message-State: AOAM5300tP11Zu7KY1WYZR5BpNrYfXg5tztW4rdfo4BTs0cU6u3rYo8Q
        k8VeSt9G4lQkF0qh89Ks+Ivbybsh66oO5Kfunke6HnHsR+dDRqU1pB0AW+ZS85J4bgLkogbgzKq
        EyVq5bg13FYNC8dr1
X-Received: by 2002:a05:620a:25d1:b0:47e:b90:bf6c with SMTP id y17-20020a05620a25d100b0047e0b90bf6cmr18277398qko.538.1654598122376;
        Tue, 07 Jun 2022 03:35:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBvtVUjkzQtDSxswRBNUeGt7PfxMJrcrgb7jbPe7hjlU4RDPNpCLgQcisCf4t05qIPyaVNMA==
X-Received: by 2002:a05:620a:25d1:b0:47e:b90:bf6c with SMTP id y17-20020a05620a25d100b0047e0b90bf6cmr18277383qko.538.1654598122118;
        Tue, 07 Jun 2022 03:35:22 -0700 (PDT)
Received: from gerbillo.redhat.com ([146.241.112.184])
        by smtp.gmail.com with ESMTPSA id u11-20020a05620a0c4b00b006a6a840be59sm8980975qki.113.2022.06.07.03.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 03:35:21 -0700 (PDT)
Message-ID: <67666593dced5eca946ac1639f214133191ebd39.camel@redhat.com>
Subject: Re: [PATCH net] af_unix: Fix a data-race in
 unix_dgram_peer_wake_me().
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rainer Weikusat <rweikusat@mobileactivedefense.com>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Date:   Tue, 07 Jun 2022 12:35:13 +0200
In-Reply-To: <20220605232325.11804-1-kuniyu@amazon.com>
References: <20220605232325.11804-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-06-05 at 16:23 -0700, Kuniyuki Iwashima wrote:
> unix_dgram_poll() calls unix_dgram_peer_wake_me() without `other`'s
> lock held and check if its receive queue is full.  Here we need to
> use unix_recvq_full_lockless() instead of unix_recvq_full(), otherwise
> KCSAN will report a data-race.
> 
> Fixes: 7d267278a9ec ("unix: avoid use-after-free in ep_remove_wait_queue")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> As Eric noted in commit 04f08eb44b501, I think rest of unix_recvq_full()
> can be turned into the lockless version.  After this merge window, I can
> send a follow-up patch if there is no objection.

It looks like replacing the remaining instances of unix_recvq_full()
with unix_recvq_full_lockless() should be safe, but I'm wondering if
doing that while retaining the current state lock scope it's worthy?!? 

It may trick later readers of the relevant code to think that such code
may be reached without a lock. Or are you suggesting to additionally
shrink the state lock scope? that latter part looks much more tricky,
IMHO.

Cheers,

Paolo

