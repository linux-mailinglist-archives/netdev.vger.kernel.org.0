Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD23252D3F6
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238784AbiESN3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiESN3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:29:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC035C6E5F
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 06:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652966974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6gbnfiZlD4IhECy7QC1q49z85Ex/XZdiWKLQdiTpbDY=;
        b=dAOBgcGC6LeuRNbLNaosE5Y8ZlWLyKO9Eyn4XrBG2wEb/dpzyMn3XMBB+bnVvQX3E/0pYs
        A1txqFnKpbg1hWrHUVzPCpbLNF8N0fgX8cnkWCNG9g9LcA9A6wJoBQpTDHdR55OlqC6jjg
        3l9RWAxXDAQCXyvQWnSvd7aXcdE3Tng=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-eZinnm4LOHOf6WPP1nqo_Q-1; Thu, 19 May 2022 09:29:25 -0400
X-MC-Unique: eZinnm4LOHOf6WPP1nqo_Q-1
Received: by mail-wr1-f70.google.com with SMTP id x4-20020a5d4444000000b0020d130e8a36so1562800wrr.9
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 06:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=6gbnfiZlD4IhECy7QC1q49z85Ex/XZdiWKLQdiTpbDY=;
        b=B4kmt/bbEEzCWzdDnL9VvvcvWrJlCvcdXHI9I6zziuZmf0pt9YmKdfVhuSvXOPTddh
         AkFvmZt7TAlnzkpYRNzH6XVlztyuDYbyGSdNBG5OwjO4FL5Tjel1blqAeFbE+ZQioMha
         EynAw+fkL0HH6xNLaet7gSKCQdb9isF5Exkf3yRBhyjdfcFTWUevAyxRy4mrIKVnYKy7
         u6+qrCBQKZQTKcJY4IKWJNsbhpbr0Qdq9CfekHRnONPn6tO3LZ79ti9svNf3HFMf4zY/
         1sq6P0oDK3gscwrPit0B3/pJ6t7/MgTeX58PjEcbGyKkhTKkaf+qLKvcihqOjT86A9iw
         5DVw==
X-Gm-Message-State: AOAM533PqrDpkeBTVbqMhe6RCb6ww/LNEgHHbWIGpx8fSmfgdj91IuAf
        S8GfydQbHkneNrTrhVC8OL3BFIUCN3fKOdpTrQ0gWocNfy8vke9lUHIC0X9snlVkrYVb5f4oY1H
        UNS1zEcXWelJlxLrk
X-Received: by 2002:a05:6000:1ac7:b0:20c:6c81:175d with SMTP id i7-20020a0560001ac700b0020c6c81175dmr4049109wry.262.1652966964128;
        Thu, 19 May 2022 06:29:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyT0336c2lcoFTbZ+pQ4BRQZNzK2Xnnj2zCImCdzHhENYsIgyVb1CQb1dXzozaJh6bRujuCzA==
X-Received: by 2002:a05:6000:1ac7:b0:20c:6c81:175d with SMTP id i7-20020a0560001ac700b0020c6c81175dmr4049096wry.262.1652966963892;
        Thu, 19 May 2022 06:29:23 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id k186-20020a1ca1c3000000b0039732f1b4a3sm1333247wme.14.2022.05.19.06.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 06:29:23 -0700 (PDT)
Message-ID: <5cc5353c518e27de69fc0d832294634c83f431e5.camel@redhat.com>
Subject: Re: tg3 dropping packets at high packet rates
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Pavan Chebbi' <pavan.chebbi@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>
Date:   Thu, 19 May 2022 15:29:22 +0200
In-Reply-To: <f3d1d5bf11144b31b1b3959e95b04490@AcuMS.aculab.com>
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
         <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
         <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com>
         <CACKFLinwh=YgPGPZ0M0dTJK1ar+SoPUZtYb5nBmLj6CNPdCQ2g@mail.gmail.com>
         <13d6579e9bc44dc2bfb73de8d9715b10@AcuMS.aculab.com>
         <CALs4sv1RxAbVid2f8EQF_kQkk48fd=8kcz2WbkTXRkwLbPLgwA@mail.gmail.com>
         <f3d1d5bf11144b31b1b3959e95b04490@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-05-19 at 13:14 +0000, David Laight wrote:
> From: Pavan Chebbi
> > Sent: 19 May 2022 11:21
> ...
> > > 
> > > > Please show a snapshot of all the counters.  In particular,
> > > > rxbds_empty, rx_discards, etc will show whether the driver is keeping
> > > > up with incoming RX packets or not.
> > > 
> > > After running the test for a short time.
> > > The application stats indicate that around 40000 packets are missing.
> > > 
> ...
> 
> Some numbers taken at the same time:
> 
> Application trace - each 'gap' is one or more lost packets.
> T+000004:  all gaps so far 1104
> T+000005:  all gaps so far 21664
> T+000006:  all gaps so far 54644
> T+000007:  all gaps so far 84641
> T+000008:  all gaps so far 110232
> T+000009:  all gaps so far 131191
> T+000010:  all gaps so far 150286
> T+000011:  all gaps so far 171588
> T+000012:  all gaps so far 190777
> T+000013:  all gaps so far 210771
> 
> rx_packets counted by tg3_rx() and read every second.
> 63 344426
> 64 341734
> 65 338740
> 66 337995
> 67 339770
> 68 336314
> 69 340087
> 70 345084
> 
> Cumulative error counts since the driver was last loaded.
>      rxbds_empty: 30983
>      rx_discards: 3123
>      mbuf_lwm_thresh_hit: 3123
> 
> The number of interrupt is high - about 40000/sec.
> (I've not deltad these, just removed all the zeros and prefixed the
> cpu number before each non-zero value.)
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:234754517
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:234767945
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:234802555
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:234843542
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:234887963
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:234928204
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:234966428
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:235009505
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:235052740
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:235093254
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:235133299
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:235173151
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:235212387
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:235252403
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:235317928
> 86: IR-PCI-MSI 1050625-edge em2-rx-1 8:13 14:235371301
> 
> RSS is enabled, but I've used ethtool -X equal 1 to
> put everything through ring 0.
> Cpu 14 is still 25% idle - that is the busiest cpu.

If the packet processing is 'bursty', you can have idle time and still
hit now and the 'rx ring is [almost] full' condition. If pause frames
are enabled, that will cause the peer to stop sending frames: drop can
happen in the switch, and the local NIC will not notice (unless there
are counters avaialble for pause frames sent).

AFAICS the packet processing is bursty, because enqueuing packets to a
remote CPU in considerably faster then full network stack processing.

Side note: on a not-to-obsolete H/W the kernel should be able to
process >1mpps per cpu.

Paolo

