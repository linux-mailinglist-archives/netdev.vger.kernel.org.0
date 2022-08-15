Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D67594C93
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 03:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbiHPBTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 21:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbiHPBS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 21:18:58 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E6458099;
        Mon, 15 Aug 2022 14:10:54 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 12D0C32002D8;
        Mon, 15 Aug 2022 17:10:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 15 Aug 2022 17:10:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660597837; x=1660684237; bh=9d7dhCe3Fq
        d/bfA8yD544NDBFEKnJIxJgepP6HupnHc=; b=Sw2GBTR4vuywnmfbU2VucVwN4b
        efRwLx92+SeVxu9DpYiM9sS9H38X+M9nmB2XpzhNvOxxb5JoJDbTxawwkLvyk2c3
        buevRKZhBacx0DwC2+uAC/LsFPKBO76ez0raPhNZoceUAslgZH4W2rO7xZmFFmtt
        NV3qcTcxQFLYsWMFvy4tzaHbZYJ6Vt2/wj/Sta4FHeb65rISF4i+p9Tv4zpDkP8A
        NK+lS5/hOGiOxGACwReToCSic0km/wxhPXT7vfwCUeCdbIMCQ8wgCnkZn78PLK9o
        +pcAZ9QUkGDWP5Mvnob0xP2ktcIZkVN7CKZAoof0l396WC6OVXZHaU/q840Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660597837; x=1660684237; bh=9d7dhCe3Fqd/bfA8yD544NDBFEKn
        JIxJgepP6HupnHc=; b=KOJlnqL03kLLyaO/0NB3mk/dJoirnU68Nx7JTKUpj8rf
        vVe7p792KJXBC1XDT+m4D2XgZDLPBhNoR4xTIgMVHlR6yfvZ3QIQsgWhIqzQ44V8
        PUSEk7w8PQAn/cFwQq+u3nktOgacR/uZ+f/6/FbpnfDILGqmlI1I8po77UZvWuG2
        wg6vQMgkdVeECgU1fuw5SKVQh+x1HHTMdqhw/Ae0XBcAIi4nLfb24x4PrqZt2H83
        JWa0oWlIGniGkDoc2Y1SnLtkyK6JXlFGoKLWA1QB5a6CrDmNS4mJ6vX5P2Yl+I/+
        v5EOExxCTEDkGcg3t8qDwfwwukD2UeOcM6FCEGo6gw==
X-ME-Sender: <xms:Tbb6YsEkABtzc4Y_Sr5ZmBvRzpXaR81ZHU6DEjuFqNDIQ7DddIR32Q>
    <xme:Tbb6YlUo9yf4_vq38Q77-Pqh-fUecSXPT9kPCwk_4dwcTRVZ6cjmnG3_mhiJYyVdr
    ExyPbqT2Mr-TXcCrw>
X-ME-Received: <xmr:Tbb6YmLiNO647ITbjg7f3pxHrktTjd2oV97wWdqgBttIN1JFZ6hpd8R7e3DQspRulyGm4oFVin6wjfrn2XsFjodZ_NB5Ro5q8XVBweAnnRwfunOFBtiP70Fp5OH4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddgudeitdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgu
    rhgvshcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtf
    frrghtthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteev
    udeitedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:Tbb6YuHbI-M3grPW61plMNzu61m3zkee0ETlUw9gk4q6sbJlWg6vNA>
    <xmx:Tbb6YiWJgPtSuMItQui8RNHoixxsOw7S2ug5QkWCOHSulPe9czixag>
    <xmx:Tbb6YhM_9JVkTmRQZblFmAZ_kM-EIsBAgpimesyVUEvFlNzP29ao8Q>
    <xmx:Tbb6YvWGsb5k3UxdvkK7WVOFDAxucBDvrXXvFRG-6dadihdmb0CvaQ>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 17:10:36 -0400 (EDT)
Date:   Mon, 15 Aug 2022 14:10:35 -0700
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
Message-ID: <20220815211035.r2ojxkilwsbxyewu@awork3.anarazel.de>
References: <20220815081527.soikyi365azh5qpu@awork3.anarazel.de>
 <20220815042623-mutt-send-email-mst@kernel.org>
 <FCDC5DDE-3CDD-4B8A-916F-CA7D87B547CE@anarazel.de>
 <20220815113729-mutt-send-email-mst@kernel.org>
 <20220815164503.jsoezxcm6q4u2b6j@awork3.anarazel.de>
 <20220815124748-mutt-send-email-mst@kernel.org>
 <20220815174617.z4chnftzcbv6frqr@awork3.anarazel.de>
 <20220815161423-mutt-send-email-mst@kernel.org>
 <20220815205330.m54g7vcs77r6owd6@awork3.anarazel.de>
 <20220815210437.saptyw6clr7datun@awork3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815210437.saptyw6clr7datun@awork3.anarazel.de>
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

On 2022-08-15 14:04:37 -0700, Andres Freund wrote:
> Booting with the equivalent change, atop 5.19, in the legacy setup_vq()
> reliably causes boot to hang:

I don't know much virtio, so take this with a rock of salt:

Legacy setup_vq() doesn't tell the host about the queue size. The modern one
does:
	vp_modern_set_queue_size(mdev, index, virtqueue_get_vring_size(vq));
but the legacy one doesn't.

I assume this means the host will assume the queue is of the size suggested by
vp_legacy_get_queue_size(). If the host continues to write into the space
after the "assumed end" of the queue, but the guest puts other stuff in that
space, well, I'd expect fun roughly like the stuff we've been seeing in this
and related threads.

Greetings,

Andres Freund
