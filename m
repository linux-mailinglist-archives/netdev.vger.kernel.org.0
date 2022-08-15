Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CC2594CF3
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 03:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245339AbiHPBHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 21:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348086AbiHPBFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 21:05:07 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5772A1A7C16;
        Mon, 15 Aug 2022 13:53:35 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 2A2A6320005D;
        Mon, 15 Aug 2022 16:53:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 15 Aug 2022 16:53:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660596812; x=1660683212; bh=HPFMScc5rh
        1n/KUQUKK3sj0YWkmSXqa3merVTxllExE=; b=GrND2lXe7MGK4VptRdZgr8SmV2
        UHsbE+tvYBCAgUWGaTCGwBDbHtn05YfYLitzF4HYhSrDD3VOlh6BjcLdeswQr0a3
        0c1BD1I5KNMqAuCqDUQojm5DVGKlDz1YMhoRtnVrO5NhX3Iao7mrSsJOaTyxwSN1
        GGrwFUbkGZ8sEPQACUt3ys1wBu3p70IYFsRDPkMVxi/2/Tam2EYL6R1e57+eKjlJ
        v7XtUV4Swdia9uQ2zo7MdqxClGR220tS0CJVMFkBunq65nuTASnMdWbJgiXPZ6/g
        40lKbXFRsXHR/ygaTBwzHP6bRimZmNf5UbNbJPDw+muf0ktEZjQfZb6OrkOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660596812; x=1660683212; bh=HPFMScc5rh1n/KUQUKK3sj0YWkmS
        Xqa3merVTxllExE=; b=jJZqRm7ree9prKdUYWegxgRMEgZItep/jM86M1SQt9+J
        b7ghCdihuulSBOVnXdcRl6boF0IK9h5o+X6kxYqM9Ub3J+Mq2TM20FOYGU7DAd+L
        0cFYDC7YlSnPrQC7I7ymf2kRm4xALmg11KYziprI0UvHwffBZpvkFTjuK9VvFw5R
        cpJmmw+pkcuQZ1lZQ129K1ngIR3wpjt1fo/w4mCGvcPZY2ZfK2000ha2u1wAY9F7
        KDR+HshGHzz2B23S8BnH05rQyo1HvbK8Z0AZOx344rcTFrmYyw3tPTVhx2xHrbcQ
        Wxw3Oq8iopJwOvkSvrqnIqJGCxqVe300o5A3tGEa1A==
X-ME-Sender: <xms:S7L6Ykjf56ArH60Ke5dBi9Vcg8xi1f5acU892ZSUIE5gc9K8ukSqpA>
    <xme:S7L6YtDdqmOW-sM7szpv1IzigqqSJdSRZeoHpQItIuHyVO8yGUipgMlWV1ER50TnP
    kE4Y5sXxQA4ei_wog>
X-ME-Received: <xmr:S7L6YsGpKcazbvPWp2o3gwfsD7M5XYRSKth6O6SojFsrmMslbySNLdw_rhGoJ6d8hyDJuieIGdkqEgKPx_pNJP9OfG7lfHC0jvHchkAzNXwGqhRRG72O7VObUvCj>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddgudehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgu
    rhgvshcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtf
    frrghtthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteev
    udeitedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:S7L6YlQZEO9CSpN512tovSiJNM7oZ34W_NhYim79y7bYqroSU14Bqg>
    <xmx:S7L6YhwFUK50LTIf5jTvxSD_rtN63jWH_br1Z_QuHBWrWHFICy0uEg>
    <xmx:S7L6Yj7xX5to0FCcJpfmaCL87adpuJaaoScEuLiWr7_NX0gka3M9yQ>
    <xmx:TLL6YpB9XIEnAcPxX0o0cl_tCoxr_1v19RkbpATjGVqfcDmkW7zssg>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 16:53:31 -0400 (EDT)
Date:   Mon, 15 Aug 2022 13:53:30 -0700
From:   Andres Freund <andres@anarazel.de>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        c@redhat.com
Subject: Re: upstream kernel crashes
Message-ID: <20220815205330.m54g7vcs77r6owd6@awork3.anarazel.de>
References: <20220815071143.n2t5xsmifnigttq2@awork3.anarazel.de>
 <20220815034532-mutt-send-email-mst@kernel.org>
 <20220815081527.soikyi365azh5qpu@awork3.anarazel.de>
 <20220815042623-mutt-send-email-mst@kernel.org>
 <FCDC5DDE-3CDD-4B8A-916F-CA7D87B547CE@anarazel.de>
 <20220815113729-mutt-send-email-mst@kernel.org>
 <20220815164503.jsoezxcm6q4u2b6j@awork3.anarazel.de>
 <20220815124748-mutt-send-email-mst@kernel.org>
 <20220815174617.z4chnftzcbv6frqr@awork3.anarazel.de>
 <20220815161423-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815161423-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022-08-15 16:21:51 -0400, Michael S. Tsirkin wrote:
> On Mon, Aug 15, 2022 at 10:46:17AM -0700, Andres Freund wrote:
> > Hi,
> >
> > On 2022-08-15 12:50:52 -0400, Michael S. Tsirkin wrote:
> > > On Mon, Aug 15, 2022 at 09:45:03AM -0700, Andres Freund wrote:
> > > > Hi,
> > > >
> > > > On 2022-08-15 11:40:59 -0400, Michael S. Tsirkin wrote:
> > > > > OK so this gives us a quick revert as a solution for now.
> > > > > Next, I would appreciate it if you just try this simple hack.
> > > > > If it crashes we either have a long standing problem in virtio
> > > > > code or more likely a gcp bug where it can't handle smaller
> > > > > rings than what device requestes.
> > > > > Thanks!
> > > >
> > > > I applied the below and the problem persists.
> > > >
> > > > [...]
> > >
> > > Okay!
> >
> > Just checking - I applied and tested this atop 6.0-rc1, correct? Or did you
> > want me to test it with the 762faee5a267 reverted? I guess what you're trying
> > to test if a smaller queue than what's requested you'd want to do so without
> > the problematic patch applied...
> >
> >
> > Either way, I did this, and there are no issues that I could observe. No
> > oopses, no broken networking. But:
> >
> > To make sure it does something I added a debugging printk - which doesn't show
> > up. I assume this is at a point at least earlyprintk should work (which I see
> > getting enabled via serial)?
> >

> Sorry if I was unclear.  I wanted to know whether the change somehow
> exposes a driver bug or a GCP bug. So what I wanted to do is to test
> this patch on top of *5.19*, not on top of the revert.

Right, the 5.19 part was clear, just the earlier test:

> > > > On 2022-08-15 11:40:59 -0400, Michael S. Tsirkin wrote:
> > > > > OK so this gives us a quick revert as a solution for now.
> > > > > Next, I would appreciate it if you just try this simple hack.
> > > > > If it crashes we either have a long standing problem in virtio
> > > > > code or more likely a gcp bug where it can't handle smaller
> > > > > Thanks!

I wasn't sure about.

After I didn't see any effect on 5.19 + your patch, I grew a bit suspicious
and added the printks.


> Yes I think printk should work here.

The reason the debug patch didn't change anything, and that my debug printk
didn't show, is that gcp uses the legacy paths...

If there were a bug in the legacy path, it'd explain why the problem only
shows on gcp, and not in other situations.

I'll queue testing the legacy path with the equivalent change.

- Andres


Greetings,

Andres Freund
